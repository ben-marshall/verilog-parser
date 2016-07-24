/*!
@file verilog_ast_mem.c
@brief Contains definitions of datastructures and functions for helping to
manage dynamic memory allocation within the library.
*/

#include <stdarg.h>
#include <stdlib.h>
#include <string.h>

#include "verilog_ast_mem.h"

/*!
@defgroup ast-utility-mem-manage Memory Management
@{
    @brief Helps to manage memory allocated during AST construction.
@ingroup ast-utility
*/

/*!
@brief A simple linked list element holder for just about everything.
*/
typedef struct ast_alloc_t ast_alloc;
struct ast_alloc_t{
    ast_alloc * next;   //!< Next element in the linked list.
    void * data;        //!< Data held in the list.
};

//! Used to store the head of the linked list of allocated data.
ast_alloc * head = NULL;
//! Used to walk along the list when adding or freeing.
ast_alloc * walker = NULL;

/*!
@brief A simple wrapper around calloc.
@details This function is identical to calloc, but uses the head and
walker variables above to keep a linked list of all heap memory that the
AST construction allocates. This makes it very easy to clean up afterward
using the @ref ast_free_all function.
@param [in] num - Number of elements to allocate space for.
@param [in] size - The size of each element being allocated.
@returns A pointer to the start of the block of memory allocated.
*/
void * ast_calloc(size_t num, size_t size)
{
    if(head == NULL)
    {
        head =  calloc(1,sizeof(ast_alloc));
        walker = head;
    }
    else
    {
        walker -> next = calloc(1,sizeof(ast_alloc));
        walker = walker -> next;
    }

    walker -> data = calloc(num,size);
    return walker -> data;
}

/*!
@brief Frees all memory allocated using @ref ast_calloc.
@details Free's all data stored in the linked list pointed to by the
@ref head variable.
@post @ref walker and @ref head are NULL. All memory allocated by ast_calloc
has been freed.
@bug Causes segmentation fault due to double free call on the same pointer.
*/
void ast_free_all()
{
    if(head == NULL)
        return; // No memory was allocated in the first place.

    while(head -> next != NULL)
    {
        walker = head;
        head = head -> next;
        if(walker -> data != NULL)
        {
            free(walker -> data);
        }
        free(walker);
    }

    walker = NULL;
    head = NULL;
}

/*!@}*/

