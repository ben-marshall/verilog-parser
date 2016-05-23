/*!
@file main.c
@brief A simple test program for the C library code.
*/

#include "stdio.h"

#include "verilog_parser.h"

int main(int argc, char ** argv)
{
    if(argc != 2)
    {
        printf("ERROR. Please supply exactly one file path argument.\n");
        return 1;
    }
    else
    {
        // Load the file.
        FILE * fh = fopen(argv[1], "r");
        
        // Instance the parser.
        verilog_parser parser = verilog_file_parse(fh);

        // Parse the file and store the result.
        int result = verilog_parse_buffer(parser);
        
        printf("Parse result: %d\n", result);
        if(result == 0)
        {
            printf("Parse successful\n");
        }
        else
        {
            printf("Parse failed\n");
        }

        fclose(fh);
    }
    return 0;
}
