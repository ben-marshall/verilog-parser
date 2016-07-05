/*!
@file verilog_preprocessor.c
@brief Contains function implementations to support source code preprocessing.
*/

#include "verilog_preprocessor.h"

verilog_preprocessor_context * verilog_new_preprocessor_context()
{
    verilog_preprocessor_context * tr = 
        ast_calloc(1,sizeof(verilog_preprocessor_context));

    tr -> token_count = 0;

    return tr;
}


void verilog_free_preprocessor_context(verilog_preprocessor_context * tofree)
{
    free(tofree);
}
