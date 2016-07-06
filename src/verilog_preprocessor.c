/*!
@file verilog_preprocessor.c
@brief Contains function implementations to support source code preprocessing.
*/

#include "verilog_preprocessor.h"

verilog_preprocessor_context * verilog_new_preprocessor_context()
{
    verilog_preprocessor_context * tr = 
        ast_calloc(1,sizeof(verilog_preprocessor_context));

    tr -> token_count    = 0;
    tr -> in_cell_define = AST_FALSE;
    tr -> emit           = AST_TRUE;

    tr -> net_types      = ast_list_new();

    return tr;
}


void verilog_free_preprocessor_context(verilog_preprocessor_context * tofree)
{
    free(tofree);
}

void verilog_preproc_enter_cell_define()
{
    yy_preproc -> in_cell_define = AST_FALSE;
}

void verilog_preproc_exit_cell_define()
{
    yy_preproc -> in_cell_define = AST_FALSE;
}

//! Creates and returns a new default net type directive.
verilog_default_net_type * verilog_new_default_net_type(
    unsigned int token_number,  //!< Token number of the directive.
    unsigned int line_number,   //!< Line number of the directive.
    ast_net_type type           //!< The net type.
){
    verilog_default_net_type * tr = 
        ast_calloc(1,sizeof(verilog_default_net_type));

    tr -> token_number = token_number;
    tr -> line_number  = line_number;
    tr -> type         = type;

    return tr;
}

/*!
@brief Registers a new default net type directive.
@details Adds a record of the directive to the end of the linked list
"net_types" in the global yy_preproc.
*/
void verilog_preproc_default_net(
    unsigned int token_number,  //!< Token number of the directive.
    unsigned int line_number,   //!< Line number of the directive.
    ast_net_type type           //!< The net type.
){
    verilog_default_net_type * directive = verilog_new_default_net_type(
        token_number,
        line_number,
        type
    );

    ast_list_append(yy_preproc -> net_types, directive);
}
