/*!
@file main.c
@brief A simple test program for the C library code.
*/

#include "stdio.h"

#include "verilog_parser.h"
#include "verilog_ast_common.h"
#include "verilog_preprocessor.h"
#include "verilog_ast_util.h"

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
            
        // Initialise the parser.
        verilog_parser_init();

        // Setup the preprocessor to look in ./tests/ for include files.
        ast_list_append(yy_preproc -> search_dirs, "./tests/");
        ast_list_append(yy_preproc -> search_dirs, "./");

        for(F = 1; F < argc; F++)
        {
            printf("%s ", argv[F]);fflush(stdout);

            // Load the file.
            FILE * fh = fopen(argv[F], "r");

            verilog_preprocessor_set_file(yy_preproc, argv[F]);
            
            // Parse the file and store the result.
            int result = verilog_parse_file(fh);

            // Close the file handle
            fclose(fh);
            
            if(result == 0)
            {
                printf(" - Parse successful\n");
            }
            else
            {
                printf(" - Parse failed\n");
                if(argc<=2) return 1;
            }
        }
    }
    verilog_resolve_modules(yy_verilog_source_tree);
    ast_free_all();
    return 0;
}
