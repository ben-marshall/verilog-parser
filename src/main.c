/*!
@file main.c
@brief A simple test program for the C library code.
*/

#include "stdio.h"

#include "verilog_parser.h"

int main(int argc, char ** argv)
{
    if(argc < 2)
    {
        printf("ERROR. Please supply at least one file path argument.\n");
        return 1;
    }
    else
    {
        int F = 0;

        for(F = 1; F < argc; F++)
        {
            // Load the file.
            FILE * fh = fopen(argv[F], "r");
            
            // Instance the parser.
            verilog_parser parser = verilog_file_parse(fh);

            // Parse the file and store the result.
            int result = verilog_parse_buffer(parser);

            verilog_free_parser(parser);
            fclose(fh);
            
            if(result == 0)
            {
                printf("Parse successful for %s\n",argv[F]);
            }
            else
            {
                printf("Parse failed for %s\n",argv[F]);
            }
        }
    }
    return 0;
}
