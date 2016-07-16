/*!
@file verilog_ast_util.c
@brief Contains definitions of functions which 
       operate on the Verilog Abstract Syntax Tree (AST)
*/

#include <assert.h>
#include <stdio.h>

#include "verilog_ast_util.h"


/*!
@brief Searches the list of modules in the parsed source tree, returning the
one that matches the passed identifer.
@returns The matching module declaration, or NULL if no such declaration
exists.
*/
ast_module_declaration * verilog_find_module_declaration(
    verilog_source_tree * source,
    ast_identifier module_name
){
    int m;
    for(m = 0; m < source -> modules -> items; m++)
    {
        ast_module_declaration * candidate = ast_list_get(source -> modules,m);

        if(ast_identifier_cmp(module_name, candidate -> identifier) == 0)
        {
            return candidate;
        }
    }

    return NULL;
}


/*!
@brief searches across an entire verilog source tree, resolving module
identifiers to their declarations.
*/
void verilog_resolve_modules(
    verilog_source_tree * source
){
    assert(source != NULL);
    assert(source -> modules != NULL);

    int resolved = 0;
    int unresolved = 0;

    int m;
    for(m = 0; m < source -> modules -> items; m++)
    {
        ast_module_declaration * module = ast_list_get(source -> modules, m);
        
        assert(module != NULL);

        if(module -> module_instantiations == NULL ||
           module -> identifier == NULL){
            continue;
        }
        
        assert(module -> identifier != NULL);
        assert(module -> module_instantiations != NULL);

        //printf("%s\n", ast_identifier_tostring(module -> identifier));

        
        int sm;
        for(sm = 0; sm < module -> module_instantiations -> items; sm ++)
        {
            ast_module_instantiation * submod = 
                            ast_list_get(module -> module_instantiations, sm);
            
            if(submod -> resolved)
            {
                // Do Nothing
            }
            else
            {
                // Find the module via it's identifier.
                ast_module_declaration * foundmod= 
                    verilog_find_module_declaration(source,
                        submod -> module_identifer);
                if(foundmod == NULL)
                {
                    //printf("Could not resolve module name '%s'\n",
                    //ast_identifier_tostring(submod -> module_identifer));
                    unresolved ++;
                }
                else
                {
                    submod -> resolved = AST_TRUE;
                    submod -> declaration = foundmod;
                    resolved ++;
                }
            }
        }
    }
    //printf("Resolved Modules: %d\t Unresolved Modules: %d\n", 
    //    resolved,unresolved);
}
