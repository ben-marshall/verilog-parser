/*!
@file verilog_ast_common.h
@brief Contains Declarations of value-independent data structures like
       linked lists which are used in the ast.
*/

#include "stdarg.h"
#include "stdlib.h"
#include "string.h"

#include "verilog_ast_mem.h"

#ifndef VERILOG_AST_COMMON_H
#define VERILOG_AST_COMMON_H


// --------------- Linked List ------------------------

/*!
@defgroup ast-linked-lists Linked List
@{
@ingroup ast-utility
*/


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

/*!
@brief Finds and returns the i'th item in the linked list.
@details Returns a void* pointer. The programmer must be sure to cast this
as the correct type.
*/
void *    ast_list_get(ast_list * list, unsigned int item);

/*!
@brief Removes the i'th item from a linked list.
*/
void      ast_list_remove_at(ast_list * list, unsigned int i);

/*!
@brief concatenates the two supplied lists into one.
@param head - This will form the "front" of the new list.
@param tail - This will form the "end" of the new list.
@details This function takes all the elements in tail and appends them
to those in head. The tail argument is then released from memory, and the
original head pointer is returned, with all data items still in tact.
*/
ast_list *    ast_list_concat(ast_list * head, ast_list * tail);


/*!
@brief Searches the list, returning true or false if the data item supplied is
contained within it.
@details Performs a *pointer* comparison. That is, if the internal list
pointer has the same address as the supplied data pointer, the item is
considered to be found.
*/
int ast_list_contains(
    ast_list * list,
    void * data
);


/*! @} */

// ----------------------- Stack --------------------------------------

/*!
@defgroup ast-stack Stack
@{
@ingroup ast-utility
*/

//! Typedef for the ast_stack_element_t
typedef struct ast_stack_element_t ast_stack_element;

/*!
@brief Storage container for a single element in the stack
*/
struct ast_stack_element_t{
    ast_stack_element * next;
    void             * data;
};

//! A very simple stack.
typedef struct ast_stack_t{
    unsigned int          depth; //!< How many items are on the stack?
    ast_stack_element   * items; //!< The stack of items.
} ast_stack;

/*!
@brief Creates and returns a new stack object.
*/
ast_stack * ast_stack_new();

/*!
@brief Free the stack, but not it's contents
*/
void ast_stack_free(ast_stack * stack);

/*!
@brief Push a new item to the top of the stack.
@param [inout] stack - The stack to push to.
@param [in]    item  - The thing to push onto the stack.
*/
void ast_stack_push(
    ast_stack * stack,
    void      * item
);

/*!
@brief Pop the top item from the top of the stack.
@param [inout] stack - The stack to pop from.
*/
void * ast_stack_pop(
    ast_stack * stack
);

/*!
@brief Peek at the top item on the top of the stack.
@param [inout] stack - The stack to peek at
*/
void * ast_stack_peek(
    ast_stack * stack
);

/*!
@brief Peek at the item *below* the top item on the top of the stack.
@param [inout] stack - The stack to peek into
*/
void * ast_stack_peek2(
    ast_stack * stack
);

/*! @} */


// ----------------------- Hash Table ---------------------------------


/*!
@defgroup ast-hashtable Hash Table
@{
@ingroup ast-utility
@brief A *very* simple hash table implemented (for now) over a linked list.
@details This can be used for simple key-value pair storage. Current
access time is O(n) for a table with N elements in it.
@warning This is a *terrible* way to implement a hash table. It doesn't
even do any hashing!
@todo Re-implement over a proper hash table structure.
*/

/*! @} */


//! A single element in the hash table.
typedef struct ast_hashtable_element_t{
    char * key; //!< The key for the element.
    void * data;    //!< The data associated with they key.
} ast_hashtable_element;


//! A hash table object.
typedef struct ast_hashtable_t{
    ast_list * elements; //!< The items.
    unsigned int size;   //!< The number of elements in the table.
} ast_hashtable;

typedef enum ast_hashtable_result_e{
    HASH_SUCCESS        = 0,
    HASH_FAIL           = 1,
    HASH_KEY_COLLISION  = 2,
    HASH_KEY_NOT_FOUND  = 3
} ast_hashtable_result;

//! Creates and returns a new hashtable.
ast_hashtable * ast_hashtable_new();

//! Frees an existing hashtable, but not it's contents, only the structure.
void  ast_hashtable_free(
    ast_hashtable * table  //!< The table to free.
);

//! Inserts a new item into the hashtable.
ast_hashtable_result ast_hashtable_insert(
    ast_hashtable * table, //!< The table to insert into.
    char          * key,   //!< The key to insert with.
    void          * value  //!< The data being added.
);

//! Returns an item from the hashtable.
ast_hashtable_result ast_hashtable_get(
    ast_hashtable * table, //!< The table to fetch from.
    char          * key,   //!< The key of the data to fetch.
    void         ** value  //!< [out] The data being returned.
);

//! Removes a key value pair from the hashtable.
ast_hashtable_result ast_hashtable_delete(
    ast_hashtable * table, //!< The table to delete from.
    char          * key    //!< The key to delete.
);

//! Updates an existing item in the hashtable.
ast_hashtable_result ast_hashtable_update(
    ast_hashtable * table, //!< The table to update.
    char          * key,   //!< The key to update with.
    void          * value  //!< The new data item to update.
);

#endif
