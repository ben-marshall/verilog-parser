/*!
@file verilog_ast.h
@brief Contains definitions of functions which 
       operate on the Verilog Abstract Syntax Tree (AST)
*/

#include <assert.h>
#include <stdio.h>

#include "verilog_ast.h"

#ifndef VERILOG_AST_UTIL_H
#define VERILOG_AST_UTIL_H

/*!
@brief searches across an entire verilog source tree, resolving module
identifiers to their declarations.
*/
void verilog_resolve_modules(
    verilog_source_tree * source
);

#endif
