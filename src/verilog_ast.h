/*!
@file verilog_ast.h
@brief Contains Declarations of datastructures and functions which represent
       and operate on the Verilog Abstract Syntax Tree (AST)
*/

#include "stdarg.h"
#include "stdlib.h"

#ifndef VERILOG_AST_H
#define VERILOG_AST_H

//! Line number typedef for represent where in a file an ast node came from.
typedef unsigned int lineno;

/*!
@brief Lists the various types of node that can be represented inside an
       AST.
*/
typedef enum verilog_ast_node_type_e verilog_ast_node_type;
enum verilog_ast_node_type_e {
    GENERIC,    //!< Generic node for when no alternative exists.
    NONE        //!< Node has no type.
};



/*!
@brief A container for the various different kinds of node that the AST will
       be made up of.
*/
typedef union verilog_ast_node_data_u verilog_ast_node_data;
union verilog_ast_node_data_u {
    void * rubbish;
    int    integer;
    float  real;
};



/*!
@brief A single node of the syntax tree with it's accompanying type and
       data.
*/
typedef struct verilog_ast_node_t verilog_ast_node;
struct verilog_ast_node_t {
    verilog_ast_node       * parent; //!< This node's parent in the tree.
    verilog_ast_node_type    type;   //!< The type of the data member.
    verilog_ast_node_data    data;   //!< The actual data the node represents.
    lineno                   line;   //!< Line of the file the node comes from.
    char                   * file;   //!< The file path the node comes from.
    verilog_ast_node       * children; //!< Array of child nodes.
    unsigned int             child_count; //!< Number of nodes in children.
};


/*!
@brief Creates a new AST node with the supplied parameters.
*/
verilog_ast_node new_ast_node(verilog_ast_node_type   type,
                              lineno                  line,
                              char                  * file,
                              unsigned int            childCount);

/*!
@brief Adds a child to the supplied parent node at index idx.
*/
void ast_node_add_child(verilog_ast_node * parent, 
                        verilog_ast_node   child,
                        unsigned int       idx);



/*!
@brief The main structure that will hold all information on a particular parsed
       source file.
*/
typedef struct verilog_ast_t {
    verilog_ast_node root;  //!< The root of the abstract syntax tree.
} verilog_ast;


#endif
