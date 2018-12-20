/*!
@file verilog_ast_mem.h
@brief Contains Declarations of datastructures and functions for helping to
manage dynamic memory allocation within the library.
*/

#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>
#include <string.h>

#ifndef VERILOG_AST_MEM_H
#define VERILOG_AST_MEM_H

//! Typedef over ast_memory_T
typedef struct ast_memory_t ast_memory;

//! Stores information on some allocated memory as a linked list.
struct ast_memory_t{
    size_t          size;   //!< Amount of memory allocated.
    void        *   data;   //!< Pointer to the allocated memory.
    ast_memory  *   next;   //!< Next element to be allocated.
};


//! Iterates over all allocated memory and frees it.
void ast_free_all();

//! Duplicates the supplied null terminated string.
char * ast_strdup(char * in);

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
void * ast_calloc(size_t num, size_t size);



#endif

