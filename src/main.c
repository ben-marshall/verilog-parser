/*!
@file main.c
@brief A simple test program for the C library code.
*/

#include "stdio.h"

#include "verilog_parser.tab.h"

extern void yyrestart (FILE *input_file  );

int main(int argc, char ** argv)
{
    if(argc != 2)
    {
        printf("ERROR. Please supply exactly one file path argument.\n");
        return 1;
    }
    else
    {
        FILE * fh = fopen(argv[1], "r");
        yyrestart(fh);
        int result = yyparse();
        
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
