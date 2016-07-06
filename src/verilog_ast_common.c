/*!
@file verilog_ast_common.c
@brief Contains definitions of value-independent data structures like
       linked lists which are used in the ast.
*/

#include "stdarg.h"
#include "stdlib.h"
#include "assert.h"

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


/*!
@brief Adds a new item to the front of a linked list.
*/
void       ast_list_preappend(ast_list * list, void * data)
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
        ast_list_element * to_add = calloc(1, sizeof(ast_list_element));
        to_add -> data = data;

        to_add -> next = list -> head;
        list   -> head = to_add;

        list -> items += 1;
        list -> current_item += 1;
    }
}

/*!
@brief Finds and returns the i'th item in the linked list.
@details Returns a void* pointer. The programmer must be sure to cast this
as the correct type.
*/
void *    ast_list_get(ast_list * list, int item)
{
    if(item > list -> items - 1)
    {
        return NULL;
    }
    else
    {
        if(item < list -> current_item)
        {
            list -> current_item = 0;
            list -> walker = list -> head;
        }

        while(list -> current_item != item && list -> walker != NULL)
        {
            list -> walker = list -> walker -> next;
            list -> current_item += 1;
        }

        return list -> walker -> data;
    }
}

/*!
@brief concatenates the two supplied lists into one.
@param head - This will form the "front" of the new list.
@param tail - This will form the "end" of the new list.
@details This function takes all the elements in tail and appends them
to those in head. The tail argument is then released from memory, and the
original head pointer is returned, with all data items still in tact.
*/
ast_list *    ast_list_concat(ast_list * head, ast_list * tail)
{
    // Perform the concatenation.
    if(tail -> head != NULL)
    {
        head -> tail -> next = tail -> head;
        head -> items        = head -> items + tail -> items;
    }

    // Free only the tail data-structure, not it's elements.
    free(tail);

    // return the new list.
    return head;
}

/*!
@brief Creates and returns a new stack object.
*/
ast_stack * ast_stack_new(){
    ast_stack * tr = calloc(1,sizeof(ast_stack));
    tr -> depth = 0;
    return tr;
}

/*!
@brief Free the stack, but not it's contents
*/
void ast_stack_free(ast_stack * stack){
    assert(stack != NULL);
    
    while(stack -> items != NULL){
        ast_stack_element * tmp = stack -> items -> next;
        free(stack -> items);
        stack -> items = tmp;
    }

    free(stack);
}

/*!
@brief Push a new item to the top of the stack.
@param [inout] stack - The stack to push to.
@param [in]    item  - The thing to push onto the stack.
*/
void ast_stack_push(
    ast_stack * stack,
    void      * item
){
    assert(stack != NULL);

    if(stack -> items == NULL)
    {
        stack -> items = calloc(1,sizeof(ast_stack_element));
        stack -> items -> data = item;
    } 
    else
    {
        ast_stack_element * toadd = calloc(1,sizeof(ast_stack_element));
        toadd -> data = item;
        toadd -> next = stack -> items;
        stack -> items = toadd;
    }

    stack -> depth ++;

}

/*!
@brief Pop the top item from the top of the stack.
@param [inout] stack - The stack to pop from.
*/
void * ast_stack_pop(

  ast_stack * stack
){
    assert(stack != NULL);

    if(stack -> items != NULL)
    {
        void * tr = stack -> items -> data;
        ast_stack_element * tofree = stack -> items;
        stack -> items = stack -> items -> next;
        free(tofree);
        stack -> depth --;
        return tr;
    }
    else
    {
        return NULL;
    }
}

/*!
@brief Peek at the top item on the top of the stack.
@param [inout] stack - The stack to peek at
*/
void * ast_stack_peek(
    ast_stack * stack
){
    assert(stack != NULL);
    
    if(stack -> items != NULL)
    {
        void * tr = stack -> items -> data;
        return tr;
    }
    else
    {
        return NULL;
    }
}

