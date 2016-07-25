/*!
@file verilog_ast_mem.c
@brief Contains definitions of datastructures and functions for helping to
manage dynamic memory allocation within the library.
*/

#include "verilog_ast_mem.h"

/*!
@defgroup ast-utility-mem-manage Memory Management
@{
    @brief Helps to manage memory allocated during AST construction.
@ingroup ast-utility
*/

//! The total number of memory allocations made.
unsigned int memory_allocations = 0;

//! Head of the linked list of allocated memory.
ast_memory * memory_head = NULL;

//! Walker for the linked list of allocated memory.
ast_memory * walker = NULL;


/*!
@brief A simple wrapper around calloc.
@details Makes it very easy to clean up afterward using the @ref ast_free_all
function.
@param [in] num - Number of elements to allocate space for.
@param [in] size - The size of each element being allocated.
@returns A pointer to the start of the block of memory allocated.
*/
void * ast_calloc(size_t num, size_t size)
{
    // This is the memory the user asked for.
    void * data = calloc(num,size);
    
    memory_allocations += 1;

    // Add the allocated memory to tracking data structure.
    if(walker == NULL)
    {
        memory_head = calloc(1,sizeof(ast_memory));
        memory_head -> size = num * size;
        memory_head -> data = data;
        memory_head -> next = NULL;
        walker      = memory_head;
    } 
    else
    {
        walker -> next = calloc(1,sizeof(ast_memory));
        walker -> next -> size = num * size;
        walker -> next -> data = data;
        walker -> next -> next = NULL;
        walker         = walker -> next;
    }

    return data;
}

/*!
@brief Frees all memory allocated using @ref ast_calloc.
@details Free's all data stored in the linked list pointed to by the
@ref head variable.
@post @ref walker and @ref head are NULL. All memory allocated by ast_calloc
has been freed.
*/
void ast_free_all()
{
    printf("Freeing data for %u memory allocations.\n", memory_allocations);
    printf("ERROR: ast_free_all() on line %d of %s not implemented.\n",
        __LINE__,__FILE__);
}

/*!@}*/

