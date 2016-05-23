/*!
@file verilog_ast.h
@brief Contains Declarations of datastructures and functions which represent
       and operate on the Verilog Abstract Syntax Tree (AST)
*/

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
    MODULE_DEC,             //!< A Module Declaration
    MODULE_INST,            //!< Instantiation of a declared module.
    PORT_DEC,               //!< Declaration of a module port.
    PORT_REF,               //!< Reference to a module port.
    NET_DEC,                //!< Net declaration.
    NET_REF,                //!< Reference to a net.
    VAR_DEC,                //!< Variable declaration.
    VAR_REF                 //!< Reference to a variable.
};


/*!
@brief The main structure that will hold all information on a particular parsed
       source file.
*/
typedef struct verilog_ast_t {

} verilog_ast;



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
    verilog_ast_node        * parent; //!< This node's parent in the tree.
    verilog_ast_node_type     type;   //!< The type of the data member.
    verilog_ast_node_data     data;   //!< The actual data the node represents.
    lineno                    line;   //!< Line of the file the node comes from.
    char                    * file;   //!< The file path the node comes from.
};

#endif
