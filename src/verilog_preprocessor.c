/*!
@file verilog_preprocessor.c
@brief Contains function implementations to support source code preprocessing.
*/

#include "verilog_preprocessor.h"

verilog_preprocessor_context * verilog_new_preprocessor_context()
{
    verilog_preprocessor_context * tr = 
        ast_calloc(1,sizeof(verilog_preprocessor_context));

    tr -> token_count    = 0;
    tr -> in_cell_define = AST_FALSE;
    tr -> emit           = AST_TRUE;

    tr -> current_file   = ast_stack_new();
    tr -> includes       = ast_list_new();
    tr -> net_types      = ast_list_new();
    tr -> unconnected_drive_pull = STRENGTH_NONE;
    tr -> macrodefines   = ast_hashtable_new();
    tr -> ifdefs         = ast_stack_new();
    tr -> search_dirs    = ast_list_new();

    // By default, search CWD for include files.
    ast_list_append(tr -> search_dirs,"./");

    return tr;
}


/*!
@brief Clears the stack of files being parsed, and sets the current file to
the supplied string.
@param [inout] preproc - The context who's file name is being set.
@param [in] file - The file path to put as the current file.
*/
void verilog_preprocessor_set_file(
    verilog_preprocessor_context * preproc,
    char * file
){
    while(ast_stack_peek(preproc -> current_file) != NULL)
    {
        ast_stack_pop(preproc -> current_file);
    }
    ast_stack_push(preproc -> current_file, file);
}

/*!
@brief Returns the file currently being parsed by the context, or NULL 
@param [in] preproc - The context to get the current file for.
*/
char * verilog_preprocessor_current_file(
    verilog_preprocessor_context * preproc
){
    return ast_stack_peek(preproc -> current_file);
}


void verilog_free_preprocessor_context(verilog_preprocessor_context * tofree)
{
    printf("ERROR: Function not implemented. preprocessor context at %p not freed.\n", tofree);
}

void verilog_preproc_enter_cell_define()
{
    yy_preproc -> in_cell_define = AST_FALSE;
}

void verilog_preproc_exit_cell_define()
{
    yy_preproc -> in_cell_define = AST_FALSE;
}

//! Creates and returns a new default net type directive.
verilog_default_net_type * verilog_new_default_net_type(
    unsigned int token_number,  //!< Token number of the directive.
    unsigned int line_number,   //!< Line number of the directive.
    ast_net_type type           //!< The net type.
){
    verilog_default_net_type * tr = 
        ast_calloc(1,sizeof(verilog_default_net_type));

    tr -> token_number = token_number;
    tr -> line_number  = line_number;
    tr -> type         = type;

    return tr;
}

/*!
@brief Registers a new default net type directive.
@details Adds a record of the directive to the end of the linked list
"net_types" in the global yy_preproc.
*/
void verilog_preproc_default_net(
    unsigned int token_number,  //!< Token number of the directive.
    unsigned int line_number,   //!< Line number of the directive.
    ast_net_type type           //!< The net type.
){
    verilog_default_net_type * directive = verilog_new_default_net_type(
        token_number,
        line_number,
        type
    );

    ast_list_append(yy_preproc -> net_types, directive);
}


/*!
@brief Handles the encounter of a `resetall directive as described in annex
19.6 of the spec.
*/
void verilog_preprocessor_resetall()
{
    return;
}


/*!
@brief Handles the entering of a no-unconnected drive directive.
*/
void verilog_preprocessor_nounconnected_drive(
    ast_primitive_strength direction
){
    assert(direction == STRENGTH_PULL1 ||
           direction == STRENGTH_PULL0 ||
           direction == STRENGTH_NONE);

    yy_preproc -> unconnected_drive_pull = direction;
}


/*! 
@brief Handles the encounter of an include directive.
@returns A pointer to the newly created directive reference.
*/
verilog_include_directive * verilog_preprocessor_include(
    char * filename,
    unsigned int lineNumber
){
    verilog_include_directive * toadd = 
        ast_calloc(1,sizeof(verilog_include_directive));

    filename = filename + 1; // Remove leading quote mark.
    size_t length = strlen(filename);
    
    toadd -> filename = ast_strdup(filename);
    toadd -> filename[length-1] = '\0';
    toadd -> lineNumber = lineNumber;

    ast_list_append(yy_preproc -> includes, toadd);

    // Search the possible include paths to find a match.
    unsigned int d = 0;
    for(d = 0; d < yy_preproc -> search_dirs -> items; d ++)
    {
        char * dir       = ast_list_get(yy_preproc -> search_dirs, d);
        size_t dirlen    = strlen(dir)+1;
        size_t namelen   = strlen(toadd -> filename);
        char * full_name = ast_calloc(dirlen+namelen, sizeof(char));

        strcat(full_name, dir);
        strcat(full_name, toadd -> filename);

        FILE * handle = fopen(full_name,"r");
        if(handle)
        {
            fclose(handle);
            toadd -> filename = full_name;
            toadd -> file_found = AST_TRUE;
            
            // Since we are diving into an include file, update the stack of
            // files currently being parsed.
            ast_stack_push(yy_preproc -> current_file, filename);

            break;
        }
        else
        {   
            toadd -> file_found = AST_FALSE;
        }
    }

    return toadd;
}

/*
@brief Instructs the preprocessor to register a new macro definition.
*/
void verilog_preprocessor_macro_define(
    unsigned int line,  //!< The line the defininition comes from.
    char * macro_name,  //!< The macro identifier.
    char * macro_text,  //!< The value the macro expands to.
    size_t text_len     //!< Length in bytes of macro_text.
){
    verilog_macro_directive * toadd = 
        ast_calloc(1, sizeof(verilog_macro_directive));
    
    toadd -> line = line;

    //printf("\nEncountered macro '%s' on line %d ",toadd->macro_id,line);
    //printf("with value '%s'\n", toadd -> macro_value);
    //fflush(stdout);

    // Make space for, and duplicate, the macro text, into the thing
    // we will put into the hashtable.
    toadd -> macro_id    = ast_strdup(macro_name);

    if(text_len > 0){
        // Make sure we exclude all comments from the macro text.
        unsigned int i = 0;
        for(i = 0; i < text_len-1; i++)
        {
            if(macro_text[i]   == '/' &&
               macro_text[i+1] == '/')
            {
                text_len = (size_t)i;
                break;
            }
        }

        toadd -> macro_value = ast_strdup(macro_text);
    } else {
        toadd -> macro_value = "";
    }

    //printf("MACRO: '%s' - '%s'\n", toadd -> macro_id, toadd -> macro_value);

    ast_hashtable_insert(
        yy_preproc -> macrodefines,
        toadd -> macro_id,
        toadd
    );

    return;
}

/*!
@brief Removes a macro definition from the preprocessors lookup table.
*/
void verilog_preprocessor_macro_undefine(
    char * macro_name //!< The name of the macro to remove.
){
    ast_hashtable_delete(
        yy_preproc -> macrodefines,
        macro_name
    );
    //printf("Removed Macro definition: '%s'\n", macro_name);
    return;
}

//! Creates and returns a new conditional context.
verilog_preprocessor_conditional_context * 
    verilog_preprocessor_new_conditional_context(
    char        * condition,          //!< The definition to check for.
    int           line_number         //!< Where the `ifdef came from.
){
    verilog_preprocessor_conditional_context * tr = 
        ast_calloc(1,sizeof(verilog_preprocessor_conditional_context));

    tr -> line_number = line_number;
    tr -> condition   = condition;

    return tr;
}


/*!
@brief Handles an ifdef statement being encountered.
@param [in] macro_name - The macro to test if defined or not.
*/
void verilog_preprocessor_ifdef (
    char * macro_name,
    unsigned int lineno,
    ast_boolean is_ndef
){
    // Create a new ifdef context.
    verilog_preprocessor_conditional_context * topush = 
        verilog_preprocessor_new_conditional_context(macro_name,lineno);

    topush -> is_ndef = is_ndef;

    void * data;
    ast_hashtable_result r = ast_hashtable_get(yy_preproc -> macrodefines,
                                               macro_name, &data);
    
    //printf("Compilation conditional on '%s' ",macro_name);
    
    if(((r == HASH_SUCCESS        && is_ndef == AST_FALSE) ||
        (r == HASH_KEY_NOT_FOUND  && is_ndef == AST_TRUE )) &&
        yy_preproc -> emit == AST_FALSE)
    {
        // Push the context, with the condition true.
        topush -> condition_passed = AST_TRUE;
        topush -> wait_for_endif   = AST_TRUE;
        yy_preproc -> emit         = AST_TRUE;
        ast_stack_push(yy_preproc -> ifdefs, topush);
        //printf("Condition TRUE\n");
    }
    else
    {
        // Push the context, with the condition false.
        topush -> condition_passed = AST_FALSE;
        if(yy_preproc -> emit == AST_FALSE)
            topush -> wait_for_endif   = AST_TRUE;
        else
            topush -> wait_for_endif   = AST_FALSE;
        yy_preproc -> emit         = AST_FALSE;
        ast_stack_push(yy_preproc -> ifdefs, topush);
        //printf("Condition FALSE\n");
    }
}

/*!
@brief Handles an elseif statement being encountered.
@param [in] macro_name - The macro to test if defined or not.
*/
void verilog_preprocessor_elseif(char * macro_name, unsigned int lineno)
{
    verilog_preprocessor_conditional_context * tocheck = 
        ast_stack_peek(yy_preproc -> ifdefs);

    if(tocheck == NULL)
    {
        printf("ERROR - `elseif without preceding `ifdef or `ifndef on line \
            %d\n\tExpect it all to go wrong from here.\n", lineno);
        return;
    }

    void * data;
    ast_hashtable_result r = ast_hashtable_get(yy_preproc -> macrodefines,
                                               macro_name, &data);

    if(tocheck -> wait_for_endif == AST_FALSE &&
       yy_preproc -> emit        == AST_TRUE)
    {
        if((tocheck -> is_ndef == AST_TRUE  && r == HASH_KEY_NOT_FOUND) ||
           (tocheck -> is_ndef == AST_FALSE && r == HASH_SUCCESS      ))
        {
            tocheck -> condition_passed = AST_TRUE;
            tocheck -> wait_for_endif   = AST_TRUE;
            yy_preproc -> emit          = AST_TRUE;
        }
        else
        {
            yy_preproc -> emit = AST_FALSE;
            tocheck    -> condition_passed = AST_FALSE;
        }
    }
    else
    {
        yy_preproc -> emit = AST_FALSE;
        tocheck    -> condition_passed = AST_FALSE;
    }
}

/*!
@brief Handles an else statement being encountered.
*/
void verilog_preprocessor_else  (unsigned int lineno)
{
    verilog_preprocessor_conditional_context * tocheck = 
        ast_stack_peek(yy_preproc -> ifdefs);

    verilog_preprocessor_conditional_context * parent = 
        ast_stack_peek2(yy_preproc -> ifdefs);

    if(tocheck == NULL)
    {
        printf("ERROR - `else without preceding `ifdef or `ifndef on line \
            %d\n\tExpect it all to go wrong from here.\n", lineno);
        return;
    }
    
    if(yy_preproc -> emit           == AST_TRUE && 
        tocheck   -> wait_for_endif == AST_FALSE)
    {
        yy_preproc -> emit              = AST_FALSE;
        tocheck    -> condition_passed  = AST_FALSE;
    }
    else
    {
        if(parent != NULL)
        {
            if(parent -> condition_passed == AST_TRUE)
            {
                yy_preproc -> emit              = AST_TRUE;
                tocheck    -> condition_passed  = AST_TRUE;
            }
            else
            {
                yy_preproc -> emit              = AST_FALSE;
                tocheck    -> condition_passed  = AST_FALSE;
            }
        }
        else
        {
            yy_preproc -> emit              = AST_TRUE;
            tocheck    -> condition_passed  = AST_TRUE;
        }
    }

    tocheck -> wait_for_endif = AST_TRUE;
}

/*!
@brief Handles an else statement being encountered.
*/
void verilog_preprocessor_endif (unsigned int lineno)
{
    verilog_preprocessor_conditional_context * tocheck = 
        ast_stack_pop(yy_preproc -> ifdefs);

    if(tocheck == NULL)
    {
        printf("ERROR - `endif without preceding `ifdef or `ifndef on line \
            %d\n\tExpect it all to go wrong from here.\n", lineno);
        return;
    }

    tocheck = ast_stack_peek(yy_preproc -> ifdefs);

    if(tocheck == NULL)
        yy_preproc -> emit = AST_TRUE;
    else
        yy_preproc -> emit = tocheck -> condition_passed;
}



