/*!
@file verilog_ast.c
@brief Contains definitions of functions which 
       operate on the Verilog Abstract Syntax Tree (AST)
*/

#include "stdio.h"
#include "verilog_ast.h"


/*!
@description Creates a new ast node of the supplied type, adds the
supplied children and then returns a pointer to the new node.
*/
verilog_ast_node new_ast_node(verilog_ast_node_type   type,
                                lineno                  line,
                                char                  * file,
                                unsigned int            childCount
                               )
{
    verilog_ast_node tr;

    tr.line = line;
    tr.file = file;
    tr.type = type;

    tr.child_count = childCount;

    if(childCount > 0)
    {
        // Storage for the children of this node that will be added later.
        tr.children = calloc(childCount, sizeof(verilog_ast_node));
    }
    else
    {
        tr.children = NULL;
    }

    return tr;
}


/*!
@brief Adds a child to the supplied parent node at index idx.
*/
void ast_node_add_child(verilog_ast_node * parent, 
                        verilog_ast_node   child,
                        unsigned int       idx)
{
    if(idx < parent -> child_count)
    {
        parent -> children[idx] = child;
    }
    else
    {
        printf("ERRROR! Trying to add more children than you should!\n");
    }
}
