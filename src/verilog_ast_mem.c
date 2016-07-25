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
    void * tr = calloc(num,size);

    return tr;
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
    printf("ERROR: ast_free_all() on line %d of %s not implemented.\n",
        __LINE__,__FILE__);
}

/*!@}*/

