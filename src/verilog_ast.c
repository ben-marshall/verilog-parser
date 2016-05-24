/*!
@file verilog_ast.c
@brief Contains definitions of functions which 
       operate on the Verilog Abstract Syntax Tree (AST)
*/

#include "assert.h"
#include "stdio.h"

#include "verilog_ast.h"

/*!
@brief Creates a new empty ast_node and returns it.
*/
ast_node * ast_node_new()
{
    ast_node * tr = calloc(1, sizeof(ast_node));;

    tr-> type         = NONE;
    tr-> parent       = NULL;
    tr-> children     = NULL;
    tr-> child_count  = 0;
    
    return tr;
}

/*!
@brief Creates and returns a new node for the tree which contains a
       single simple identifier.
*/
ast_node * ast_new_identifier_node(ast_identifier identifier)
{
    ast_node * tr = ast_node_new();

    tr->type         = IDENTIFIER;
    tr->value.string = identifier;

    return tr;
}

/*!
@brief Creates and returns as a pointer a new attribute descriptor.
*/
ast_node_attributes * ast_new_attributes(ast_identifier name, ast_node * value)
{
    ast_node_attributes * tr = calloc(1, sizeof(ast_node_attributes));
    tr->attr_name   = name;
    tr->attr_value  = value;
    return tr;
}


/*!
@brief Creates and returns a new attribute node with the specified value
       and name.
*/
ast_node * ast_new_attribute_node(ast_node_attributes * value)
{
    ast_node * tr = ast_node_new();

    tr -> type = ATTRIBUTE_LIST;
    tr -> value.attributes = value;

    return tr;
}

/*!
@brief Creates and returns a new attribute node with the specified value
       and name.
@param [inout] parent - Pointer to the node which represents the list of
                        attribute name,value pairs.
@param [in]    toadd  - The new attribute to add.
*/
void ast_append_attribute(ast_node_attributes * parent, 
                          ast_node_attributes * toadd)
{
    // Add the new attribute to the end of the list.

    ast_node_attributes * walker = parent -> next;
    while(walker -> next != NULL)
        walker = walker -> next;
    walker -> next = toadd;

}

/*!
@brief Creates and returns a new @ref ast_lvalue pointer, with the data type
       being a single identifier of either @ref NET_IDENTIFIER or
       @ref VAR_IDENTIFIER.
*/
ast_lvalue * ast_new_lvalue_id(ast_lvalue_type type, ast_identifier id)
{
    assert(type == NET_IDENTIFIER || type == VAR_IDENTIFIER);
    ast_lvalue * tr = calloc(1, sizeof(ast_lvalue));
    tr -> type = type;
    tr -> data.identifier = id;
    return tr;
}

/*!
@brief Creates and returns a new @ref ast_lvalue pointer, with the data type
       being a concatenation holder of either @ref NET_CONCATENATION or
       @ref VAR_CONCATENATION.
*/
ast_lvalue * ast_new_lvalue_concat(ast_lvalue_type type, 
                                   ast_concatenation concat)
{
    assert(type == NET_CONCATENATION || type == VAR_CONCATENATION);
    ast_lvalue * tr = calloc(1, sizeof(ast_lvalue));
    tr -> type = type;
    tr -> data.concatenation = concat;
    return tr;
}

/*!
@brief Creates a new ast primary which is part of a constant expression tree
       with the supplied type and value.
*/
ast_primary * ast_new_constant_primary(ast_primary_value_type type)
{
    ast_primary * tr = calloc(1, sizeof(ast_primary));

    tr -> primary_type  = CONSTANT_PRIMARY;
    tr -> value_type    = type;

    return tr;
}

/*!
@brief Creates a new ast primary which is part of an expression tree
       with the supplied type and value.
*/
ast_primary * ast_new_primary(ast_primary_value_type type)
{
    ast_primary * tr = calloc(1, sizeof(ast_primary));

    tr -> primary_type  = PRIMARY;
    tr -> value_type    = type;

    return tr;
}

/*!
@brief Creates a new ast primary which is part of a constant expression tree
       with the supplied type and value.
*/
ast_primary * ast_new_module_path_primary(ast_primary_value_type type)
                                          
{
    ast_primary * tr = calloc(1, sizeof(ast_primary));

    tr -> primary_type  = MODULE_PATH_PRIMARY;
    tr -> value_type    = type;

    return tr;
}
