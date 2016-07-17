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
@defgroup ast-utility-modules Module Resoloution & Searching
@{
@brief Functions for resolving module names.
@ingroup ast-utility
*/

/*!
@brief searches across an entire verilog source tree, resolving module
identifiers to their declarations.
*/
void verilog_resolve_modules(
    verilog_source_tree * source
);

/*!
@brief Searches the list of modules in the parsed source tree, returning the
one that matches the passed identifer.
@returns The matching module declaration, or NULL if no such declaration
exists.
*/
ast_module_declaration * verilog_find_module_declaration(
    verilog_source_tree * source,
    ast_identifier module_name
);

// -------------------------------------------------------------------------


/*!
@brief Returns a list of module declarations, representing the different types
of module which this parent instantiates.
@details Each child module will appear once in the returned list. That is, if
a register instantiates eight flip flop modules, then the flip flop module
will appear only once in the returned list.
@returns a list of elements of type ast_module_declaration.
@pre The verilog_resolve_modules function has been called on the source tree
to which the passed module belongs.
@see verilog_modules_get_children
*/
ast_list * verilog_module_get_children(
    ast_module_declaration * module
);


/*!
@brief Finds the child modules for all modules in a source tree.
@returns A hash table, keyed by the module identifiers, of lists of
module children.
@pre The verilog_resolve_modules function has been called on the source tree
to which the passed module belongs.
@see verilog_module_get_children
*/
ast_hashtable * verilog_modules_get_children(
    verilog_source_tree * source
);

/*! @} */

#endif
