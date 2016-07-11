
/*!
@file verilog_parser.c
@brief Contains implementations of functions declared in verilog_parser.h
*/

#include "verilog_ast.h"
#include "verilog_parser.h"

/*!
@brief Sets up the parser to accept more input from a new input file.
@details Acts as a wrapper around yyrestart()
*/
void    verilog_parser_setup(FILE * input_file)
{
    if(yy_preproc == NULL) 
    {
        //printf("Added new preprocessor context\n");
        yy_preproc = verilog_new_preprocessor_context();
    }
    if(yy_verilog_source_tree == NULL)
    {
        //printf("Added new source tree\n");
        yy_verilog_source_tree = verilog_new_source_tree();
    }
    yyrestart(input_file);
}

/*!
@brief Perform a parsing operation on the currently selected buffer.
@details Acts as a wrapper around yyparse().
*/
int     verilog_parse_current_buffer()
{
    return yyparse();
}

