/*!
@file verilog_ast.h
@brief Contains Declarations of datastructures and functions which represent
       and operate on the Verilog Abstract Syntax Tree (AST)
*/

#include "stdarg.h"
#include "stdlib.h"

#ifndef VERILOG_AST_H
#define VERILOG_AST_H

//! Forward declare. Defines the core node type for the AST.
typedef struct ast_node_t ast_node;

//! Typedef to make it easier to change into a proper structure later.
//! @todo add proper support for hierarchical identifiers and scope.
typedef char * ast_identifier;

//! Placeholder until this is implemented properly.
typedef void * ast_concatenation;
    
typedef void * ast_number       ;
typedef void * ast_function_call;
typedef void * ast_system_call  ;
typedef void * ast_minmax_exp   ;
typedef void * ast_macro_use    ;

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

// -------------------------------- L Value ------------------------

/*!
@brief Identifies the kind of LValue the @ref ast_lvalue structure holds.
*/
typedef enum ast_lvalue_type_e
{
    NET_IDENTIFIER,
    VAR_IDENTIFIER,
    NET_CONCATENATION,
    VAR_CONCATENATION
} ast_lvalue_type;

/*!
@brief Storage for the data describing an assignment L Value.
*/
typedef union ast_lvalue_data_u
{
    ast_identifier      identifier;     //!< Identifier value.
    ast_concatenation   concatenation;  //!< Concatenation list.
} ast_lvalue_data ;

/*!
@brief Stores and describes an expression l value.
*/
typedef struct ast_lvalue_t
{
    ast_lvalue_data data; //!< The identifier or concattenation being assigned.
    ast_lvalue_type type; //!< The type of the L Value assignment.
} ast_lvalue;

/*!
@brief Creates and returns a new @ref ast_lvalue pointer, with the data type
       being a single identifier of either @ref NET_IDENTIFIER or
       @ref VAR_IDENTIFIER.
*/
ast_lvalue * ast_new_lvalue_id(ast_lvalue_type type, ast_identifier id);

/*!
@brief Creates and returns a new @ref ast_lvalue pointer, with the data type
       being a concatenation holder of either @ref NET_CONCATENATION or
       @ref VAR_CONCATENATION.
*/
ast_lvalue * ast_new_lvalue_concat(ast_lvalue_type type, ast_concatenation id);


// -------------------------------- Primaries ----------------------

//! Describes the kind of expression primary being represented.
typedef enum ast_primary_type_e
{
    CONSTANT_PRIMARY,
    PRIMARY,
    MODULE_PATH_PRIMARY
} ast_primary_type;


//! The kind of production the expression primary holds.
typedef enum ast_primary_value_type_e
{
    PRIMARY_NUMBER,
    PRIMARY_IDENTIFIER,
    PRIMARY_CONCATENATION,
    PRIMARY_FUNCTION_CALL,
    PRIMARY_SYSTEM_CALL,
    PRIMARY_MINMAX_EXP,
    PRIMARY_MACRO_USAGE    
} ast_primary_value_type;

//! The expression primary can produce several different sub-expressions:
typedef union ast_primary_value_e
{
    ast_number          number;
    ast_identifier      identifier;
    ast_concatenation   concatenation;
    ast_function_call   function_call;
    ast_system_call     system_call;
    ast_minmax_exp      minmax;
    ast_macro_use       macro;
} ast_primary_value;

//! Stores the type and value of an AST primary expression.
typedef struct ast_primary_t
{
    ast_primary_type        primary_type;
    ast_primary_value_type  value_type;
    ast_primary_value       value;
} ast_primary;


/*!
@brief Creates a new ast primary which is part of a constant expression tree
       with the supplied type and value.
*/
ast_primary * ast_new_constant_primary(ast_primary_value_type type);

/*!
@brief Creates a new ast primary which is part of an expression tree
       with the supplied type and value.
*/
ast_primary * ast_new_primary(ast_primary_value_type type);

/*!
@brief Creates a new ast primary which is part of a constant expression tree
       with the supplied type and value.
*/
ast_primary * ast_new_module_path_primary(ast_primary_value_type type);

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
