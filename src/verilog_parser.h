
/*!
@file verilog_parser.h
@brief A nice interface for the whole verilog parser.
@details Provides wrappers around the awkward yylex and yyparse functions,
as well as an easy way to change the input stream.
@note Functions declared in this file are defined in verilog_parser_wrapper.c
*/

#include "stdio.h"

// Essential to make sure we have access to all of the yy functions.
#include "verilog_preprocessor.h"

#ifndef H_VERILOG_PARSER
#define H_VERILOG_PARSER

#ifndef YY_TYPEDEF_YY_SIZE_T
#define YY_TYPEDEF_YY_SIZE_T
typedef size_t yy_size_t;
#endif
 
#ifndef YY_BUF_SIZE
    #define YY_BUF_SIZE 16384
#endif
typedef struct yy_buffer_state *YY_BUFFER_STATE;
extern void yyrestart (FILE *input_file  );
extern void yy_switch_to_buffer (YY_BUFFER_STATE new_buffer  );
extern YY_BUFFER_STATE yy_create_buffer (FILE *file,int size  );
extern YY_BUFFER_STATE yy_scan_buffer (char *base,yy_size_t size  );
extern YY_BUFFER_STATE yy_scan_bytes (const char *bytes,int len  );
extern void yy_delete_buffer (YY_BUFFER_STATE b  );

/*!
@defgroup parser-api Verilog Parser API
@{
@brief Describes the top level, programmer facing parser API.
*/

/*!
@brief Sets up the parsing environment ready for input.
@details Makes sure that there is a vaild preprocessor context and source
tree object ready to store any parsed constructs.
@pre The yy_preproc and yy_verilog_source_tree objects are in an unknown
state
@post The yy_preproc and yy_verilog_source_tree objects are not NULL, and
are certain to be either new or existing contexts ready for parsing.
@note Calling this function, parsing a file, and then calling this function
again, does *not* destroy the original preprocessor context or source tree.
*/
void    verilog_parser_init();

/*!
@brief Perform a parsing operation on the supplied file.
@details Parses the supplied file object, adding any parsed constructs to
the existing yy_verilog_source_tree object, and using the existing
yy_preproc preprocessor context.
@param [in] to_parse - The open file object to be parsed.
@pre yy_init has been called atleast once, and to_parse is an open and
valid file to be read.
@post Any valid verilog constructs have been added to the 
yy_verilog_source_tree global object.
@returns An integer describing the result of the parse operation. If 
the return value is a zero, the file was parsed successfully. If it takes
any other value, the file parsed was syntactically invalid.
@note In the event of an invalid file being parsed, then the 
yy_verilog_source_tree object will only contain upto, but not including,
the most recently valid parsed object. For example, when the following
source is parsed:

    module valid_module();
        initial begin
            $display("This module is valid");
        end
    endmodule

    module invalid_module();
        initial begin
            $display("This module is syntactically invalid");
    endmodule

then the first "valid_module" object will be added to the source tree, but
the second will not.
*/
int     verilog_parse_file(FILE * to_parse);

/*!
@brief Perform a parsing operation on the supplied in-memory string.
@details Parses the supplied string, reading at most "length" bytes, adding
any parsed constructs to the existing yy_verilog_source_tree object, and using
the existing yy_preproc preprocessor context.
@param [in] to_parse - The string to be parsed.
@param [in] length - How many characters of to_parse to process.
@pre yy_init has been called atleast once, and to_parse is an accessible
array of characters.
@post Any valid verilog constructs have been added to the 
yy_verilog_source_tree global object.
@returns An integer describing the result of the parse operation. If 
the return value is a zero, the file was parsed successfully. If it takes
any other value, the file parsed was syntactically invalid.
@warning This function will create a copy of to_parse, and so is not destructive
to the originally passed variable. If you would rather not create a copy,
then use the verilog_parse_buffer function.
@note In the event of an invalid file being parsed, then the 
yy_verilog_source_tree object will only contain upto, but not including,
the most recently valid parsed object. For example, when the following
source is parsed:

    module valid_module();
        initial begin
            $display("This module is valid");
        end
    endmodule

    module invalid_module();
        initial begin
            $display("This module is syntactically invalid");
    endmodule

then the first "valid_module" object will be added to the source tree, but
the second will not.
*/
int     verilog_parse_string(char * to_parse, int length);


/*!
@brief Perform a parsing operation on the supplied in-memory string.
@details Parses the supplied string, reading at most "length" bytes, adding
any parsed constructs to the existing yy_verilog_source_tree object, and using
the existing yy_preproc preprocessor context.
@param [in] to_parse - The string to be parsed.
@param [in] length - How many characters of to_parse to process.
@pre yy_init has been called atleast once, and to_parse is an accessible
array of characters.
@post Any valid verilog constructs have been added to the 
yy_verilog_source_tree global object.
@returns An integer describing the result of the parse operation. If 
the return value is a zero, the file was parsed successfully. If it takes
any other value, the file parsed was syntactically invalid.
@warning This function does not create a copy of the to_parse data, and will
destroy the contents of the buffer. If you would rather the function operate
on a copy of the data instead, please use the verilog_parse_string function.
@note In the event of an invalid file being parsed, then the 
yy_verilog_source_tree object will only contain upto, but not including,
the most recently valid parsed object. For example, when the following
source is parsed:

    module valid_module();
        initial begin
            $display("This module is valid");
        end
    endmodule

    module invalid_module();
        initial begin
            $display("This module is syntactically invalid");
    endmodule

then the first "valid_module" object will be added to the source tree, but
the second will not.
*/
int     verilog_parse_buffer(char * to_parse, int length);

/*! }@ */

#endif
