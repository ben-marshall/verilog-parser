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

    tr -> includes       = ast_list_new();
    tr -> net_types      = ast_list_new();
    tr -> unconnected_drive_pull = STRENGTH_NONE;

    return tr;
}


void verilog_free_preprocessor_context(verilog_preprocessor_context * tofree)
{
    free(tofree);
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


//! Handles the encounter of an include diretive.
void verilog_preprocessor_include(
    char * filename,
    unsigned int lineNumber
){
    verilog_include_directive * toadd = 
        ast_calloc(1,sizeof(verilog_include_directive));

    toadd -> filename = filename;
    toadd -> lineNumber = lineNumber;

    ast_list_append(yy_preproc -> includes, toadd);
}
