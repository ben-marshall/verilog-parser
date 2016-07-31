/*!
@file verilog_preprocessor.h
@brief Contains function and data structures to support source code
       preprocessing.
*/

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>

#include "verilog_ast.h"
#include "verilog_ast_common.h"

#ifndef VERILOG_PREPROCESSOR_H
#define VERILOG_PREPROCESSOR_H

/*!
@defgroup verilog-preprocessor Preprocessor
@{
@brief This module contains all code and information on the preprocessor and
how it works / is implemented.

@details

The preprocessor is implemented mostly as part of the lexer, with the
various compiler directives handled within the verilog_preprocessor_context
structure and it's associated functions.

*/

// ----------------------- Default Net Type Directives ------------------

/*!
@brief Keeps track of the points at which default net type directives are
encountered.
*/
typedef struct verilog_default_net_type_t{
    unsigned int token_number;  //!< Token number of the directive.
    unsigned int line_number;   //!< Line number of the directive.
    ast_net_type type;          //!< The net type.
} verilog_default_net_type;

//! Creates and returns a new default net type directive.
verilog_default_net_type * verilog_new_default_net_type(
    unsigned int token_number,  //!< Token number of the directive.
    unsigned int line_number,   //!< Line number of the directive.
    ast_net_type type           //!< The net type.
);

// ----------------------- Line Directives ------------------------------

//! Describes a line directive.
typedef struct verilog_line_directive_t{
    unsigned int  line;  //!< The line to set the current counter to.
    char *        file;  //!< The file we should pretend stuff comes from.
    unsigned char level; //!< Level of include depth.
} verilog_line_directive;

// ----------------------- Timescale Directives -------------------------

//! Describes a simulation timescale directive.
typedef struct verilog_timescale_directive_t{
    char * scale;       //!< The timescale to simulate on.
    char * precision;   //!< Precision of each timestep.
} verilog_timescale_directive;

// ----------------------- resetall directives --------------------------

/*!
@brief Handles the encounter of a `resetall directive as described in annex
19.6 of the spec.
*/
void verilog_preprocessor_resetall();

// ----------------------- Connected Drive Directives -------------------

/*!
@brief Handles the entering of a no-unconnected drive directive.
@param [in] direction -  Where should an unconnected line be pulled?
*/
void verilog_preprocessor_nounconnected_drive(
    ast_primitive_strength direction;
);

// ----------------------- Include Directives ---------------------------

//! Stores information on an include directive.
typedef struct verilog_include_directive_t{
    char       * filename;      //!< The file to include.
    unsigned int lineNumber;    //!< The line number of the directive.
    ast_boolean  file_found;    //!< Can we find the file?
} verilog_include_directive;

/*! 
@brief Handles the encounter of an include directive.
@returns A pointer to the newly created directive reference.
*/
verilog_include_directive * verilog_preprocessor_include(
    char * filename,        //<! The file to include.
    unsigned int lineNumber //!< The line number of the directive.
);

// ----------------------- `define Directives ---------------------------

/*!
@brief A simple container for macro directives
*/
typedef struct verilog_macro_directive_t{
    unsigned int line;      //!< Line number of the directive.
    char * macro_id;        //!< The name of the macro.
    char * macro_value;     //!< The value it expands to.
} verilog_macro_directive;

/*!
@brief Instructs the preprocessor to register a new macro definition.
*/
void verilog_preprocessor_macro_define(
    unsigned int line,  //!< The line the defininition comes from.
    char * macro_name,  //!< The macro identifier.
    char * macro_text,  //!< The value the macro expands to.
    size_t text_len     //!< Length in bytes of macro_text.
);
    
/*!
@brief Removes a macro definition from the preprocessors lookup table.
*/
void verilog_preprocessor_macro_undefine(
    char * macro_name //!< The name of the macro to remove.
);

// ----------------------- Conditional Compilation Directives -----------

/*!
@brief Stores information regarding a particular level of conditional
compilation.
@brief A stack of these is maintained, each one relating to a different
level of nested `ifdef or `ifndef statements.
*/
typedef struct verilog_preprocessor_conditional_context_t{
    char        * condition;           //!< The definition to check for.
    int           line_number;         //!< Where the `ifdef came from.
    ast_boolean   condition_passed;    //!< Did the condition pass?
    ast_boolean   is_ndef;             //!< True if directive was `ifndef
    ast_boolean   wait_for_endif;      //!< Emit nothing more until `endif
} verilog_preprocessor_conditional_context;

//! Creates and returns a new conditional context.
verilog_preprocessor_conditional_context * 
    verilog_preprocessor_new_conditional_context(
    char        * condition,          //!< The definition to check for.
    int           line_number         //!< Where the `ifdef came from.
);

/*!
@brief Handles an ifdef statement being encountered.
@param [in] macro_name - The macro to test if defined or not.
@param [in] lineno - The line the directive occurs on.
@param [in] is_ndef - TRUE IFF the directive is `ifndef. Else the directive
is `ifdef and this should be FALSE.
*/
void verilog_preprocessor_ifdef (
    char * macro_name,
    unsigned int lineno,    //!< line number of the directive.
    ast_boolean is_ndef     //!< Is this an ifndef or ifdef directive.
);

/*!
@brief Handles an elseif statement being encountered.
@param [in] macro_name - The macro to test if defined or not.
@param [in] lineno - The line the directive occurs on.
*/
void verilog_preprocessor_elseif(char * macro_name, unsigned int lineno);

/*!
@brief Handles an else statement being encountered.
@param [in] lineno - The line the directive occurs on.
*/
void verilog_preprocessor_else  (unsigned int lineno);

/*!
@brief Handles an else statement being encountered.
@param [in] lineno - The line the directive occurs on.
*/
void verilog_preprocessor_endif (unsigned int lineno);


// ----------------------- Preprocessor Context -------------------------

/*
@brief Stores all of the contextual information used by the pre-processor.
@details Stores things like:
- Macro names and evaluations.
- Default net types.
- In Cell Defines.
- IF/ELSE pre-processor directives.
- Timescale directives
*/
typedef struct verilog_preprocessor_context_t{
    ast_boolean     emit;           //!< Only emit tokens iff true.
    unsigned int    token_count;    //!< Keeps count of tokens processed.
    ast_boolean     in_cell_define; //!< TRUE iff we are in a cell define.

    char *          scratch;        //!< A scratch variable. DO NOT USE.
    
    ast_stack     * current_file;   //!< Stack of files currently being parsed.
    ast_hashtable * macrodefines;   //!< `define kvp matching.
    ast_list      * includes;       //!< Include directives.
    ast_list      * net_types;      //!< Storage for default nettype directives
    verilog_timescale_directive timescale; //!< Timescale information
    ast_primitive_strength unconnected_drive_pull; //!< nounconnectedrive
    ast_stack     * ifdefs;         //!< Storage for conditional compile stack.
    ast_list      * search_dirs;    //!< Where to look for include files.
} verilog_preprocessor_context;


/*! 
@brief Stores all information needed for the preprocessor.
@details This does not usually need to be accessed by the programmer, and
certainly should never be written to unless you are defining your own
default directives. For example, if I was writing my own simulated and
wanted to add my own "__IS_MY_SIMULATOR__" pre-defined macro, it can be
done by accessing this variable, and using the 
verilog_preprocessor_macro_define function.
@note This is a global variable. Treat it with care!
*/
extern verilog_preprocessor_context * yy_preproc;


/*!
@brief Creates a new pre-processor context.
@details This is called *once* at the beginning of a parse call.
*/
verilog_preprocessor_context * verilog_new_preprocessor_context();

/*!
@brief Clears the stack of files being parsed, and sets the current file to
the supplied string.
@param [inout] preproc - The context who's file name is being set.
@param [in] file - The file path to put as the current file.
*/
void verilog_preprocessor_set_file(
    verilog_preprocessor_context * preproc,
    char * file
);

/*!
@brief Returns the file currently being parsed by the context, or NULL 
@param [in] preproc - The context to get the current file for.
*/
char * verilog_preprocessor_current_file(
    verilog_preprocessor_context * preproc
);

/*!
@brief Frees a preprocessor context and all child constructs.
*/
void verilog_free_preprocessor_context(
    verilog_preprocessor_context * tofree
);


/*!
@brief Tells the preprocessor we are now defining PLI modules and to tag
       them as such.
*/
void verilog_preproc_enter_cell_define();


/*!
@brief Tells the preprocessor we are no longer defining PLI modules.
*/
void verilog_preproc_exit_cell_define();

/*!
@brief Registers a new default net type directive.
*/
void verilog_preproc_default_net(
    unsigned int token_number,  //!< Token number of the directive.
    unsigned int line_number,   //!< Line number of the directive.
    ast_net_type type           //!< The net type.
);

/*! @} */

#endif

