/*!
@file verilog_ast.h
@brief Contains Declarations of datastructures and functions which represent
       and operate on the Verilog Abstract Syntax Tree (AST)
*/

#include "stdarg.h"
#include "stdlib.h"

#ifndef VERILOG_AST_H
#define VERILOG_AST_H

typedef struct ast_node_t ast_node;

//-------------- attributes ------------------------------------

/*!
@brief Node data describing an attribute.
*/
typedef struct ast_node_attributes_t ast_node_attributes;
struct ast_node_attributes_t
{
    char                * attr_name;    //!< Name of the attribute
    ast_node            * attr_value;   //!< Value of the attribute.

    ast_node_attributes * next;         //!< Next one in a linked list.
};


/*!
@brief Creates and returns a new attribute node with the specified value
       and name.
*/
ast_node * ast_new_attribute_node( ast_node_attributes* value);

/*!
@brief Creates and returns a new attribute node with the specified value
       and name.
@param [inout] parent - Pointer to the node which represents the list of
                        attribute name,value pairs.
@param [in]    toadd  - The new attribute to add.
*/
void ast_append_attribute(ast_node_attributes * parent, 
                          ast_node_attributes * toadd);


// -------------------------------- Nodes --------------------------

/*!
@brief Stores the various data values that a node in the AST can represent.
*/
typedef union ast_value_u 
{
    int     integer;
    float   real;
    char  * string;
    ast_node_attributes * attributes;
}ast_value;

/*!
@brief Enum type describing the data value that an AST node holds.
*/
typedef enum ast_value_type_e
{
    ATTRIBUTE_LIST, //!< A design attribute. @ref ast_node_attributes_t
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
ast_node * ast_node_new();
    
/*!
@brief Creates and returns a new node for the tree which contains a
       single simple identifier.
*/
ast_node * ast_new_identifier_node(char * identifier);



#endif
