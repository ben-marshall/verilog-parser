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


/*!
@brief Container struct for the linked list data structure.
*/
typedef struct ast_list_t {
    ast_list_element *  head;         //!< The "front" of the list.
    ast_list_element *  tail;         //!< The "end" of the list.
    ast_list_element *  walker;       //!< Used to "walk" along the list.
    unsigned int        items;        //!< Number of items in the list.
    unsigned int        current_item; //! Current position of walker in list.
} ast_list;


/*!
@brief Creates and returns a pointer to a new linked list.
*/
ast_list * ast_list_new ();

/*!
@brief Frees the memory of the supplied linked list.
@note Does not free the memory of the data elements in the list, only
the list construct itself.
*/
void       ast_list_free(ast_list * list);

/*!
@brief Adds a new item to the end of a linked list.
*/
void       ast_list_append(ast_list * list, void * data);


/*!
@brief Adds a new item to the front of a linked list.
*/
void       ast_list_preappend(ast_list * list, void * data);

#endif
