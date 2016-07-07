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
    unsigned int         line;
    char *               file;
    unsigned char        level;
} verilog_line_directive;

// ----------------------- Timescale Directives -------------------------

//! Describes a line directive.
typedef struct verilog_timescale_directive_t{
    char * scale;
    char * precision;
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
*/
void verilog_preprocessor_nounconnected_drive(
    ast_primitive_strength direction;
);

// ----------------------- Include Directives ---------------------------

//! Stores information on an include directive.
typedef struct verilog_include_directive_t{
    char       * filename;
    unsigned int lineNumber;
} verilog_include_directive;

//! Handles the encounter of an include diretive.
void verilog_preprocessor_include(
    char * filename,
    unsigned int lineNumber
);

// ----------------------- `define Directives ---------------------------

/*!
@brief A simple container for macro directives
@note Expect this to expand as macro processing is completed.
*/
typedef struct verilog_macro_directive_t{
    unsigned int line;
    char * macro_id;
    char * macro_value;
} verilog_macro_directive;

/*
@brief Instructs the preprocessor to register a new macro definition.
*/
void verilog_preprocessor_macro_define(
    unsigned int line,  //!< The line the defininition comes from.
    char * macro_name,  //!< The macro identifier.
    size_t name_len  ,  //!< Length in bytes of macro_name.
    char * macro_text,  //!< The value the macro expands to.
    size_t text_len     //!< Length in bytes of macro_text.
);
    
/*!
@brief Removes a macro definition from the preprocessors lookup table.
*/
void verilog_preprocessor_macro_undefine(
    char * macro_name //!< The name of the macro to remove.
);

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
    
    ast_hashtable * macrodefines;   //!< `define kvp matching.
    ast_list      * includes;       //!< Include directives.
    ast_list      * net_types;      //!< Storage for default nettype directives
    verilog_timescale_directive timescale; //!< Timescale information
    ast_primitive_strength unconnected_drive_pull; //!< nounconnectedrive
} verilog_preprocessor_context;


//! Stores all information needed for the preprocessor.
extern verilog_preprocessor_context * yy_preproc;


/*!
@brief Creates a new pre-processor context.
*/
verilog_preprocessor_context * verilog_new_preprocessor_context();


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

