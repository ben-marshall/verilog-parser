
/*!
@file verilog_parser.h
@brief A nice interface for the whole verilog parser.
@details Provides wrappers around the awkward yylex and yyparse functions,
as well as an easy way to change the input stream.
*/

#include "stdio.h"

// Essential to make sure we have access to all of the yy functions.
#include "verilog_parser.tab.h"
#include "verilog_preprocessor.h"

#ifndef H_VERILOG_PARSER
#define H_VERILOG_PARSER
 
//! refered too externally.
extern verilog_preprocessor_context * yy_preproc;

//! External declaration of the yyresart function.
extern void yyrestart (FILE *input_file  );

int     verilog_parse_current_buffer();
void    verilog_parser_setup(FILE * input_file);

#endif
