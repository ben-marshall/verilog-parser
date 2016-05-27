/*!
@file verilog_ast_common.h
@brief Contains Declarations of value-independent data structures like
       linked lists which are used in the ast.
*/

#include "stdarg.h"
#include "stdlib.h"

#ifndef VERILOG_AST_COMMON_H
#define VERILOG_AST_COMMON_H


// --------------- Linked List ------------------------

//! Typedef for the ast_list_element_t
typedef struct ast_list_element_t ast_list_element;

/*!
@brief Storage container for a single element in the linked list.
*/
struct ast_list_element_t{
    ast_list_element * next;
    void             * data;
};


typedef struct ast_list_t {
    ast_list_element *  head;         //!< The "front" of the list.
    ast_list_element *  tail;         //!< The "end" of the list.
    ast_list_element *  walker;       //!< Used to "walk" along the list.
    unsigned int        items;        //!< Number of items in the list.
    unsigned int        current_item; //! Current position of walker in list.
} ast_list;

#endif
