/*!
@file verilog_ast.h
@brief Contains Declarations of datastructures and functions which represent
       and operate on the Verilog Abstract Syntax Tree (AST)
*/

#include "stdarg.h"
#include "stdlib.h"

#ifndef VERILOG_AST_H
#define VERILOG_AST_H

/*!
@brief Stores the various data values that a node in the AST can represent.
*/
typedef union ast_value_u 
{
    int     integer;
    float   real;
    char  * string;
}ast_value;

/*!
@brief Enum type describing the data value that an AST node holds.
*/
typedef enum ast_value_type_e
{
    ATTRIBUTE,      //!< A design attribute.
    NONE,           //!< The node has no stored data type.
    INTEGER,        //!< Node stores and integer.
    REAL,           //!< Node stores a real number.
    CHAR_STRING,    //<! Node stores a character string.
    IDENTIFIER,     //<! An identifier.
    MODULE          //<! A design module.
} ast_value_type;

/*!
@brief Node type that forms the tree.
*/
typedef struct ast_node_t ast_node;
struct ast_node_t
{
    ast_node     * parent;      //!< Parent node in the tree.
    unsigned int   child_count; //!< Number of children the node has.
    ast_node     * children;    //!< Linked list of children.

    ast_value      value;       //!< Data value of the node.
    ast_value_type type;        //!< Datatype of the value stored in the node.
};

/*!
@brief Creates a new empty ast_node and returns it.
*/
ast_node ast_node_new();
    
/*!
@brief Creates and returns a new node for the tree which contains a
       single simple identifier.
*/
ast_node ast_new_identifier_node(char * identifier);


/*!
@brief Creates a new module description node.
*/
ast_node ast_new_module_node(char     * identifier,
                             ast_node * parameter_list,
                             ast_node * port_list,
                             ast_node * module_items);

#endif
