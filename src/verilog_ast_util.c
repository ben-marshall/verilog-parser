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
    unsigned int m;
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

    unsigned int m;
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

        
        unsigned int sm;
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


/*!
@brief Returns a list of module instantiations, representing the different 
types of module which this parent instantiates.
*/
ast_list * verilog_module_get_children(
    ast_module_declaration * module
){
    ast_list * tr = ast_list_new();
    
    unsigned int m;
    for(m = 0; m < module -> module_instantiations -> items; m++)
    {
        ast_module_instantiation * child = 
                            ast_list_get(module -> module_instantiations, m);

        unsigned int c;
        unsigned char added_already = 0;
        for(c = 0; c < tr -> items; c++)
        {
            ast_module_instantiation * maybe = ast_list_get(tr,c);
            ast_identifier i1, i2;
            if(maybe -> resolved)
                i1 = maybe -> declaration -> identifier;
            else
                i1 = maybe -> module_identifer;
            
            if(child -> resolved)
                i2 = child -> declaration -> identifier;
            else
                i2 = child-> module_identifer;

            if(ast_identifier_cmp(i1,i2) == 0)
            {
                added_already = 1;
                break;
            }
        }

        if(added_already)
        {
            continue;
        }
        else
        {
            ast_list_append(tr,child);
        }
    }

    return tr;
}


/*!
@brief Finds the child modules for all modules in a source tree.
@returns A hash table, keyed by the module identifiers, of lists of
module children.
@pre The verilog_resolve_modules function has been called on the source tree
to which the passed module belongs.
@see verilog_module_get_children
*/
ast_hashtable * verilog_modules_get_children(
    verilog_source_tree * source
){
    ast_hashtable * tr = ast_hashtable_new();

    unsigned int m;
    for(m = 0; m < source -> modules -> items; m++)
    {
        ast_module_declaration * module = ast_list_get(source -> modules, m);

        ast_list * children = verilog_module_get_children(module);

        char * key = ast_identifier_tostring(module -> identifier);

        ast_hashtable_insert(tr,key,children);
    }

    return tr;
}
