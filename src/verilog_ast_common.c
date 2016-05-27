/*!
@file verilog_ast_common.c
@brief Contains definitions of value-independent data structures like
       linked lists which are used in the ast.
*/

#include "stdarg.h"
#include "stdlib.h"

#include "verilog_ast_common.h"

/*!
@brief Creates and returns a pointer to a new linked list.
*/
ast_list * ast_list_new ()
{
    ast_list * tr = calloc(1, sizeof(ast_list));
    tr -> head          = NULL;
    tr -> tail          = NULL;
    tr -> walker        = NULL;
    tr -> items         = 0;
    tr -> current_item  = 0;
    return tr;
}

/*!
@brief Frees the memory of the supplied linked list.
@note Does not free the memory of the data elements in the list, only
the list construct itself.
*/
void       ast_list_free(ast_list * list)
{
    if(list -> items > 0);
    {
        list -> walker = list -> head;
        
        // Walk along the list, freeing elements as we go.
        while(list -> walker != NULL)
        {
            ast_list_element * tmp = list -> walker;
            list -> walker = list -> walker -> next;

            if(tmp != NULL)
            {
                free(tmp);
            }
        }
    }

    free(list);
}

/*!
@brief Adds a new item to the end of a linked list.
*/
void       ast_list_append(ast_list * list, void * data)
{
    if(list -> items == 0)
    {
        list -> head         = calloc(1,sizeof(ast_list_element));
        list -> head -> next = NULL;
        list -> head -> data = data;

        list -> tail         = list -> head;
        list -> walker       = list -> tail;
        list -> items       += 1;
        list -> current_item = list -> items-1;
    }
    else
    {
        list -> tail -> next = calloc(1, sizeof(ast_list_element));
        list -> tail = list -> tail -> next;
        list -> tail -> data = data;

        list -> items += 1;
    }
}
