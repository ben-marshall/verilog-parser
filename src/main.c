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
            printf("%s", argv[F]);fflush(stdout);

            // Load the file.
            FILE * fh = fopen(argv[F], "r");
            
            // Instance the parser.
            verilog_parser parser = verilog_file_parse(fh);
            printf(" parser built ");fflush(stdout);

            // Parse the file and store the result.
            int result = verilog_parse_buffer(parser);
            printf(" parser finished");fflush(stdout);

            verilog_free_parser(parser);
            printf(" parser freed");fflush(stdout);
            fclose(fh);
            
            if(result == 0)
            {
                printf(" - Parse successful\n");
            }
            else
            {
                printf(" - Parse failed for\n");
            }
        }
    }
    return 0;
}
