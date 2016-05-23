
/*!
@file verilog_parser.c
@brief Contains implementations of functions declared in verilog_parser.h
*/

#include "verilog_parser.h"

// External definitions exist for the flex functions.
#define YY_BUF_SIZE 16384
extern void             yy_switch_to_buffer (YY_BUFFER_STATE new_buffer  );
extern YY_BUFFER_STATE  yy_create_buffer    (FILE *file,int size  );
extern void             yy_delete_buffer    (YY_BUFFER_STATE b  );
extern void             yy_init_buffer      (YY_BUFFER_STATE b,FILE *file  );
extern YY_BUFFER_STATE  yy_scan_string      (const char *yy_str  );

/*!
@brief Creates and returns a verilog parser handle.
@detail Used for parsing a file from disk. Acts as a wrapper
        for the yy_create_buffer function.
*/
verilog_parser verilog_file_parse(FILE * file)
{
    // Create the buffer state for the supplied file.
    verilog_parser tr = yy_create_buffer(file, YY_BUF_SIZE);
    return tr;
}

/*!
@brief Creates and returns a verilog parser handle.
@detail Used for parsing a string that has already been loaded
        into memory. Acts as a wrapper for the yy_scan_string function.
*/
verilog_parser verilog_string_parse(const char * str)
{
    // Create the buffer aimed at the supplied string.
    verilog_parser tr = yy_scan_string(str);
    return tr;
}

/*!
@brief Selects which buffer we are currently parsing.
@detail Acts as a wrapper around yy_switch_to_buffer.
*/
void           verilog_set_parser(verilog_parser parser)
{
    // Just wrap around the lex function.
    yy_switch_to_buffer(parser);
}

/*!
@brief Destroys the buffer handle and all of its resources.
@detail Acts as a wrapper for the yy_delete_buffer function.
*/
void           verilog_free_parser(verilog_parser parser)
{
    yy_delete_buffer(parser);
}


/*!
@brief Perform a parsing operation on the currently selected buffer.
@detail Acts as a wrapper around yyparse().
*/
int            verilog_parse_current_buffer()
{
    return yyparse();
}

/*!
@brief Perform a parsing operation on the supplied buffer.
@detail Acts as a wrapper around yyparse(). Switches to the supplied parser
        and then calls verilog_parse_current_buffer().
*/
int            verilog_parse_buffer(verilog_parser parser)
{
    verilog_set_parser(parser);
    return yyparse();
}



