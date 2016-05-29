
/*!
@file verilog_parser.h
@brief A nice interface for the whole verilog parser.
@details Provides wrappers around the awkward yylex and yyparse functions,
as well as an easy way to change the input stream.
*/

#include "stdio.h"

// Essential to make sure we have access to all of the yy functions.
#include "verilog_parser.tab.h"

#ifndef H_VERILOG_PARSER
#define H_VERILOG_PARSER


//! A nicer typedef to wrap around the YY buffer state variable.
typedef struct yy_buffer_state *verilog_parser;
typedef struct yy_buffer_state *YY_BUFFER_STATE;

/*!
@brief Creates and returns a verilog parser handle.
@details Used for parsing a file from disk. Acts as a wrapper
        for the yy_create_buffer function.
*/
verilog_parser verilog_file_parse(FILE * file);

/*!
@brief Creates and returns a verilog parser handle.
@details Used for parsing a string that has already been loaded
        into memory. Acts as a wrapper for the yy_scan_string function.
*/
verilog_parser verilog_string_parse(const char * str);

/*!
@brief Selects which buffer we are currently parsing.
@details Acts as a wrapper around yy_switch_to_buffer.
*/
void           verilog_set_parser(verilog_parser parser);


/*!
@brief Destroys the buffer handle and all of its resources.
@details Acts as a wrapper for the yy_delete_buffer function.
*/
void           verilog_free_parser(verilog_parser parser);


/*!
@brief Perform a parsing operation on the currently selected buffer.
@details Acts as a wrapper around yyparse().
*/
int            verilog_parse_current_buffer();

/*!
@brief Perform a parsing operation on the supplied buffer.
@details Acts as a wrapper around yyparse(). Switches to the supplied parser
        and then calls verilog_parse_current_buffer().
*/
int            verilog_parse_buffer(verilog_parser parser);

#endif
