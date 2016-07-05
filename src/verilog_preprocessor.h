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
    ast_boolean  emit;           //!< Only emit tokens iff true.
    unsigned int token_count;    //!< Keeps count of tokens processed.
    ast_boolean  in_cell_define; //!< TRUE iff we are in a cell define.
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

#endif

