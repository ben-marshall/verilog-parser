/*!
@file verilog_ast.c
@brief Contains definitions of functions which operate on the Verilog Abstract
Syntax Tree (AST)
*/

#include <assert.h>
#include <stdio.h>

#include "verilog_ast.h"
#include "verilog_preprocessor.h"

/*!
@brief Responsible for setting the line number and file of each node's
meta data member.
@param [inout] meta - A pointer to the metadata member to modify.
*/
void ast_set_meta_info(ast_metadata * meta)
{
    meta -> line = yylineno;
    meta -> file = verilog_preprocessor_current_file(yy_preproc);
}

/*!
@brief Creates and returns as a pointer a new attribute descriptor.
*/
ast_node_attributes * ast_new_attributes(ast_identifier name, 
                                         ast_expression * value)
{
    ast_node_attributes * tr = ast_calloc(1, sizeof(ast_node_attributes));
    tr->attr_name   = name;
    tr->attr_value  = value;
    return tr;
}

/*!
@brief Creates and returns a new attribute node with the specified value
       and name.
@param [inout] parent - Pointer to the node which represents the list of
                        attribute name,value pairs.
@param [in]    toadd  - The new attribute to add.
*/
void ast_append_attribute(ast_node_attributes * parent, 
                          ast_node_attributes * toadd)
{
    // Add the new attribute to the end of the list.

    ast_node_attributes * walker = parent;
    while(walker -> next != NULL)
        walker = walker -> next;
    walker -> next = toadd;

}

/*!
@brief Creates and returns a new @ref ast_lvalue pointer, with the data type
       being a single identifier of either @ref NET_IDENTIFIER or
       @ref VAR_IDENTIFIER.
*/
ast_lvalue * ast_new_lvalue_id(ast_lvalue_type type, ast_identifier id)
{
    assert(type == NET_IDENTIFIER 
        || type == VAR_IDENTIFIER
        || type == GENVAR_IDENTIFIER
        || type == SPECPARAM_ID
        || type == PARAM_ID);
    ast_lvalue * tr = ast_calloc(1, sizeof(ast_lvalue));
    ast_set_meta_info(&(tr->meta));
    tr -> type = type;
    tr -> data.identifier = id;
    return tr;
}

/*!
@brief Creates and returns a new @ref ast_lvalue pointer, with the data type
       being a concatenation holder of either @ref NET_CONCATENATION or
       @ref VAR_CONCATENATION.
*/
ast_lvalue * ast_new_lvalue_concat(ast_lvalue_type type, 
                                   ast_concatenation*concat)
{
    assert(type == NET_CONCATENATION 
        || type == VAR_CONCATENATION);
    ast_lvalue * tr = ast_calloc(1, sizeof(ast_lvalue));
    ast_set_meta_info(&(tr->meta));
    tr -> type = type;
    tr -> data.concatenation = concat;
    return tr;
}

/*!
@brief A utility function for converting an ast expression primaries back into
a string representation.
@param [in] p - The expression primary to turn into a string.
*/
char * ast_primary_tostring(
    ast_primary * p
){
    char * tr;

    switch (p -> value_type)
    {
        case PRIMARY_NUMBER:
            tr = ast_number_tostring(p -> value.number);
            break;
        case PRIMARY_IDENTIFIER:
            tr = ast_identifier_tostring(p -> value.identifier);
            break;
        case PRIMARY_FUNCTION_CALL:
            tr = ast_identifier_tostring(p ->value.function_call -> function);
            break;
        case PRIMARY_MINMAX_EXP:
            tr = ast_expression_tostring(p -> value.minmax);
            break;
        case PRIMARY_CONCATENATION:
        default:
            printf("primary type to string not supported: %d %s\n",
                __LINE__,__FILE__);
            tr = "<unsupported>";
            break;
    }

    return tr;
}

/*!
@brief Creates a new ast primary which is part of a constant expression tree
       with the supplied type and value.
*/
ast_primary * ast_new_constant_primary(ast_primary_value_type type)
{
    ast_primary * tr = ast_calloc(1, sizeof(ast_primary));
    ast_set_meta_info(&(tr->meta));

    tr -> primary_type  = CONSTANT_PRIMARY;
    tr -> value_type    = type;

    return tr;
}


/*!
@brief Creates a new AST primary wrapper around a function call.
*/
ast_primary * ast_new_primary_function_call(ast_function_call * call)
{
    ast_primary * tr = ast_calloc(1, sizeof(ast_primary));
    ast_set_meta_info(&(tr->meta));
    assert(tr!=NULL);

    tr -> primary_type  = PRIMARY;
    tr -> value_type    = PRIMARY_FUNCTION_CALL;
    tr -> value.function_call = call;

    return tr;
}


/*!
@brief Creates a new ast primary which is part of an expression tree
       with the supplied type and value.
*/
ast_primary * ast_new_primary(ast_primary_value_type type)
{
    ast_primary * tr = ast_calloc(1, sizeof(ast_primary));
    ast_set_meta_info(&(tr->meta));

    tr -> primary_type  = PRIMARY;
    tr -> value_type    = type;

    return tr;
}

/*!
@brief Creates a new ast primary which is part of a constant expression tree
       with the supplied type and value.
*/
ast_primary * ast_new_module_path_primary(ast_primary_value_type type)
                                          
{
    ast_primary * tr = ast_calloc(1, sizeof(ast_primary));
    ast_set_meta_info(&(tr->meta));

    tr -> primary_type  = MODULE_PATH_PRIMARY;
    tr -> value_type    = type;

    return tr;
}

/*!
@brief Creates and returns a new expression primary.
@details This is simply an expression instance wrapped around a
primary instance for the purposes of mirroring the expression tree gramamr.
Whether or not the expression is constant is denoted by the type member
of the passed primary.
*/
ast_expression * ast_new_expression_primary(ast_primary * p)
{
    assert(sizeof(ast_expression) != 0);
    ast_expression * tr = ast_calloc(1, sizeof(ast_expression));
    ast_set_meta_info(&(tr->meta));
    assert(tr != NULL);
    
    tr -> attributes    = NULL;
    tr -> right         = NULL;
    tr -> left          = NULL;
    tr -> aux           = NULL;
    tr -> type          = PRIMARY_EXPRESSION;
    tr -> primary       = p;
    tr -> constant      = p -> primary_type == CONSTANT_PRIMARY ? AST_TRUE 
                                                                : AST_FALSE;

    return tr;
}

//! Returns the string representation of an operator;
char * ast_operator_tostring(ast_operator op)
{
    switch(op)
    {

        case OPERATOR_STAR   : return "*"; 
        case OPERATOR_PLUS   : return "+"; 
        case OPERATOR_MINUS  : return "-"; 
        case OPERATOR_ASL    : return "<<<"; 
        case OPERATOR_ASR    : return ">>>"; 
        case OPERATOR_LSL    : return "<<"; 
        case OPERATOR_LSR    : return ">>>"; 
        case OPERATOR_DIV    : return "/"; 
        case OPERATOR_POW    : return "^"; 
        case OPERATOR_MOD    : return "%"; 
        case OPERATOR_GTE    : return ">="; 
        case OPERATOR_LTE    : return "<="; 
        case OPERATOR_GT     : return ">"; 
        case OPERATOR_LT     : return "<"; 
        case OPERATOR_L_NEG  : return "!"; 
        case OPERATOR_L_AND  : return "&&"; 
        case OPERATOR_L_OR   : return "||"; 
        case OPERATOR_C_EQ   : return "=="; 
        case OPERATOR_L_EQ   : return "="; 
        case OPERATOR_C_NEQ  : return "!="; 
        case OPERATOR_L_NEQ  : return "!="; 
        case OPERATOR_B_NEG  : return "~"; 
        case OPERATOR_B_AND  : return "&"; 
        case OPERATOR_B_OR   : return "|"; 
        case OPERATOR_B_XOR  : return "^"; 
        case OPERATOR_B_EQU  : return "==="; 
        case OPERATOR_B_NAND : return "~&"; 
        case OPERATOR_B_NOR  : return "~|"; 
        case OPERATOR_TERNARY: return "?"; 
        default: return " ";
    }
}

/*!
@brief A utility function for converting an ast expression tree back into
a string representation.
@returns The string representation of the passed expression or an empty string
if exp is NULL.
@param [in] exp - The expression to turn into a string.
*/
char * ast_expression_tostring(
    ast_expression * exp
){
    if(exp == NULL){return "";}
    char * tr;
    char * lhs;
    char * rhs;
    char * pri;
    char * cond;
    char * mid;
    char * op;
    size_t len;

    switch(exp -> type)
    {
        case PRIMARY_EXPRESSION:
        case MODULE_PATH_PRIMARY_EXPRESSION:
            tr = ast_primary_tostring(exp -> primary);
            break;
        case STRING_EXPRESSION:
            tr = ast_strdup(exp -> string);
            break;
        case UNARY_EXPRESSION:  
        case MODULE_PATH_UNARY_EXPRESSION:
            pri = ast_primary_tostring(exp -> primary);
            op  = ast_operator_tostring(exp -> operation);
            tr = ast_calloc(strlen(pri)+5,sizeof(char));
            strcat(tr,"(");
            strcat(tr, op); 
            strcat(tr,pri);
            strcat(tr,")");
            break;
        case BINARY_EXPRESSION:
        case MODULE_PATH_BINARY_EXPRESSION:
            lhs = ast_expression_tostring(exp -> left);
            rhs = ast_expression_tostring(exp -> right);
            op  = ast_operator_tostring(exp -> operation);
            len =5+strlen(lhs)+ strlen(rhs);
            tr = ast_calloc(len,sizeof(char));
            strcat(tr,"(");
            strcat(tr,lhs);
            strcat(tr, op); 
            strcat(tr,rhs);
            strcat(tr,")");
            break;
        case RANGE_EXPRESSION_UP_DOWN:
            lhs = ast_expression_tostring(exp -> left);
            rhs = ast_expression_tostring(exp -> right);
            len =3+strlen(lhs)+ strlen(rhs);
            tr = ast_calloc(len,sizeof(char));
            strcat(tr,lhs);
            strcat(tr,":");
            strcat(tr,rhs);
            break;
        case RANGE_EXPRESSION_INDEX:
            tr = ast_expression_tostring(exp -> left);
            break;
        case MODULE_PATH_MINTYPMAX_EXPRESSION:
        case MINTYPMAX_EXPRESSION: 
            lhs = ast_expression_tostring(exp -> left);
            rhs = ast_expression_tostring(exp -> right);
            mid = ast_expression_tostring(exp -> aux);
            len = 3 +
                  strlen(lhs) + 
                  strlen(rhs) + 
                  strlen(mid);
            tr = ast_calloc(len,sizeof(char));
            strcat(tr,lhs);
            strcat(tr,":");
            strcat(tr,mid);
            strcat(tr,":");
            strcat(tr,rhs);
            break;
        case CONDITIONAL_EXPRESSION: 
        case MODULE_PATH_CONDITIONAL_EXPRESSION:
            lhs = ast_expression_tostring(exp -> left);
            rhs = ast_expression_tostring(exp -> right);
            cond= ast_expression_tostring(exp -> aux);
            len = 3 +
                  strlen(lhs) + 
                  strlen(rhs) + 
                  strlen(cond);
            tr = ast_calloc(len,sizeof(char));
            strcat(tr,cond);
            strcat(tr,"?");
            strcat(tr,lhs);
            strcat(tr,":");
            strcat(tr,rhs);
            break;
        default:
            printf("ERROR: Expression type to string not supported. %d of %s",
                __LINE__,__FILE__);
            tr = "<unsupported>";
            break;

    }
    
    return tr;
}


/*!
@brief Creates a new unary expression with the supplied operation.
*/
ast_expression * ast_new_unary_expression(ast_primary    * operand,
                                          ast_operator     operation,
                                          ast_node_attributes * attr,
                                          ast_boolean       constant)
{
    ast_expression * tr = ast_calloc(1, sizeof(ast_expression));
    ast_set_meta_info(&(tr->meta));

    tr -> operation     = operation;
    tr -> attributes    = attr;
    tr -> primary       = operand;
    tr -> right         = NULL;
    tr -> left          = NULL;
    tr -> aux           = NULL;
    tr -> type          = UNARY_EXPRESSION;
    tr -> constant      = constant;

    #ifdef VERILOG_PARSER_COVERAGE_ON
        printf("Unary Expression: '%s'\n", ast_expression_tostring(tr));
    #endif

    return tr;
}

/*!
@brief Creates a new range expression with the supplied operands.
*/
ast_expression * ast_new_range_expression(ast_expression * left,
                                          ast_expression * right)
{
    ast_expression * tr = ast_calloc(1, sizeof(ast_expression));
    ast_set_meta_info(&(tr->meta));
    
    tr -> attributes    = NULL;
    tr -> right         = right;
    tr -> left          = left;
    tr -> aux           = NULL;
    tr -> type          = RANGE_EXPRESSION_UP_DOWN;
    
    #ifdef VERILOG_PARSER_COVERAGE_ON
        printf("Range Expression: '%s'\n", ast_expression_tostring(tr));
    #endif

    return tr;
}
                                           
/*!
@brief Creates a new range index expression with the supplied operands.
*/
ast_expression * ast_new_index_expression(ast_expression * left)
{
    ast_expression * tr = ast_calloc(1, sizeof(ast_expression));
    ast_set_meta_info(&(tr->meta));
    
    tr -> attributes    = NULL;
    tr -> right         = NULL;
    tr -> left          = left;
    tr -> aux           = NULL;
    tr -> type          = RANGE_EXPRESSION_INDEX;
    
    #ifdef VERILOG_PARSER_COVERAGE_ON
        printf("Index Expression: '%s'\n", ast_expression_tostring(tr));
    #endif

    return tr;
}

/*!
@brief Creates a new primary expression with the supplied operation
and operands.
@note Sets the type of the expression 
*/
ast_expression * ast_new_binary_expression(ast_expression * left,
                                           ast_expression * right,
                                           ast_operator     operation,
                                           ast_node_attributes * attr,
                                           ast_boolean      constant)
{
    ast_expression * tr = ast_calloc(1, sizeof(ast_expression));
    ast_set_meta_info(&(tr->meta));

    tr -> operation     = operation;
    tr -> attributes    = attr;
    tr -> right         = right;
    tr -> left          = left;
    tr -> aux           = NULL;
    tr -> type          = BINARY_EXPRESSION;
    tr -> constant      = constant;
    
    #ifdef VERILOG_PARSER_COVERAGE_ON
        printf("Binary Expression: '%s'\n", ast_expression_tostring(tr));
    #endif

    return tr;
}


/*!
@brief Creates a new string expression.
*/
ast_expression * ast_new_string_expression(ast_string string)
{
    ast_expression * tr = ast_calloc(1, sizeof(ast_expression));
    ast_set_meta_info(&(tr->meta));

    tr -> attributes    = NULL;
    tr -> right         = NULL;
    tr -> left          = NULL;
    tr -> aux           = NULL;
    tr -> type          = STRING_EXPRESSION;
    tr -> constant      = AST_TRUE;
    tr -> string        = string;
    
    #ifdef VERILOG_PARSER_COVERAGE_ON
        printf("String Expression: '%s'\n", ast_expression_tostring(tr));
    #endif
    
    return tr;
}


/*!
@brief Creates a new conditional expression node. 
@note The condition is stored in the aux member, if_true in left, and if_false
on the right.
*/
ast_expression * ast_new_conditional_expression(ast_expression * condition,
                                                ast_expression * if_true,
                                                ast_expression * if_false,
                                                ast_node_attributes * attr)
{
    ast_expression * tr = ast_calloc(1, sizeof(ast_expression));
    ast_set_meta_info(&(tr->meta));

    tr -> attributes    = attr;
    tr -> right         = if_false;
    tr -> left          = if_true;
    tr -> aux           = condition;
    tr -> type          = CONDITIONAL_EXPRESSION;
    
    return tr;
}

/*!
@brief Creates a new (min,typical,maximum) expression.
@details If the mintypmax expression only specifies a typical value,
then the min and max arguments should be NULL, and only typ set. 
*/
ast_expression * ast_new_mintypmax_expression(ast_expression * min,
                                              ast_expression * typ,
                                              ast_expression * max)
{
    ast_expression * tr = ast_calloc(1, sizeof(ast_expression));
    ast_set_meta_info(&(tr->meta));

    tr -> attributes    = NULL;
    tr -> right         = max;
    tr -> left          = min;
    tr -> aux           = typ;
    tr -> type          = MINTYPMAX_EXPRESSION;
    
    return tr;
}


/*!
@brief Creates and returns a new node representing a function call.
@param [in] id - The function identifier.
@param [in] attr - Attributes to be passed to the function call.
@param [in] system - Is this a system function call?
@param [in] constant - Is this a constant function call?
@param [in] arguments - list of elements of type ast_expression
representing the various parameters to the function. If the function has
no arguments, then it is an empty list, not NULL. If this is supplied as
NULL, then an empty list is added automatically by the function.
*/
ast_function_call * ast_new_function_call(ast_identifier  id,
                                          ast_boolean     constant,
                                          ast_boolean     system,
                                          ast_node_attributes * attr,
                                          ast_list      * arguments)
{
    ast_function_call * tr = ast_calloc(1, sizeof(ast_function_call));
    ast_set_meta_info(&(tr->meta));

    tr -> function  = id;
    tr -> constant  = constant;
    tr -> system    = system;
    tr -> arguments = arguments;
    tr -> attributes = attr;
    
    if(tr -> arguments == NULL)
    {
        tr -> arguments = ast_list_new();
    }

    return tr;
}


/*!
@brief Creates a new AST concatenation element with the supplied type and
initial starting value.
@param [in] repeat - Used for replications or multiple_concatenation.
@param [in] type - The kind of value being concatenated.
@param [in] first_value - The first value at the LHS of the concatenation.
@details Depending on the type supplied, the type of first_value
should be:
    - CONCATENATION_EXPRESSION          : ast_expression
    - CONCATENATION_CONSTANT_EXPRESSION : ast_expression
    - CONCATENATION_NET                 : TBD
    - CONCATENATION_VARIABLE            : TBD
    - CONCATENATION_MODULE_PATH         : TBD
@todo Better implement repetition of elements.
*/
ast_concatenation * ast_new_concatenation(ast_concatenation_type type,
                                          ast_expression * repeat,
                                          void * first_value)
{
    ast_concatenation * tr = ast_calloc(1,sizeof(ast_concatenation));
    ast_set_meta_info(&(tr->meta));

    tr -> repeat = repeat;
    tr -> type   = type;
    tr -> items  = ast_list_new();
    ast_list_append(tr -> items, first_value);

    return tr;
}

/*!
@brief Creates and returns a new empty concatenation of the specified type.
*/
ast_concatenation * ast_new_empty_concatenation(ast_concatenation_type type)
{
    ast_concatenation * tr = ast_calloc(1,sizeof(ast_concatenation));
    ast_set_meta_info(&(tr->meta));

    tr -> repeat = NULL;
    tr -> type   = type;
    tr -> items  = ast_list_new();

    return tr;
}


/*!
@brief Adds a new data element on to the end of a concatenation.
@details Appends to the front because this naturally follows the
behaviour of a left-recursive grammar.
@todo Better implement repetition of elements.
*/
void                ast_extend_concatenation(ast_concatenation * element,
                                             ast_expression * repeat,
                                             void * data)
{
    element -> repeat = repeat;
    ast_list_preappend(element -> items, data);
}


/*!
@brief Creates and returns a new path declaration type. Expects that the data
be filled in manually;
*/
ast_path_declaration * ast_new_path_declaration(ast_path_declaration_type type)
{
    ast_path_declaration * tr = ast_calloc(1,sizeof(ast_path_declaration));
    ast_set_meta_info(&(tr->meta));

    tr -> type = type;
    tr -> state_expression = NULL;

    return tr;
}

/*!
@brief Creates and returns a pointer to a new simple parallel path declaration.
*/
ast_simple_parallel_path_declaration * ast_new_simple_parallel_path_declaration
    (
        ast_identifier      input_terminal,
        ast_operator        polarity,
        ast_identifier      output_terminal,
        ast_list        *   delay_value
    )
{
    ast_simple_parallel_path_declaration * tr = 
            ast_calloc(1, 
            sizeof(ast_simple_parallel_path_declaration));
    ast_set_meta_info(&(tr->meta));

    tr -> input_terminal = input_terminal;
    tr -> polarity       = polarity;
    tr -> output_terminal= output_terminal;
    tr -> delay_value    = delay_value;

    return tr;
}


/*!
@brief Creates and returns a pointer to a new simple full path declaration.
*/
ast_simple_full_path_declaration * ast_new_simple_full_path_declaration
    (
        ast_list        *   input_terminals,
        ast_operator        polarity,
        ast_list        *   output_terminals,
        ast_list        *   delay_value
    )
{
    ast_simple_full_path_declaration * tr = 
            ast_calloc(1, 
            sizeof(ast_simple_full_path_declaration));
    ast_set_meta_info(&(tr->meta));

    tr -> input_terminals= input_terminals;
    tr -> polarity       = polarity;
    tr -> output_terminals=output_terminals;
    tr -> delay_value    = delay_value;

    return tr;
}


/*! 
@brief Describes a single edge sensitive path declaration
*/
ast_edge_sensitive_parallel_path_declaration * 
  ast_new_edge_sensitive_parallel_path_declaration(
    ast_edge            edge,               //!< edge_identifier
    ast_identifier      input_terminal,     //!< specify_input_terminal_descriptor
    ast_operator        polarity,           //!< polarity_operator
    ast_identifier      output_terminal,    //!< specify_output_terminal_descriptor
    ast_expression  *   data_source,        //!< data_source_expression
    ast_list        *   delay_value         //!< path_delay_value
)
{
    ast_edge_sensitive_parallel_path_declaration * tr = 
        ast_calloc(1,sizeof(ast_edge_sensitive_parallel_path_declaration));
    ast_set_meta_info(&(tr->meta));

    tr -> edge            = edge           ;
    tr -> input_terminal  = input_terminal ;
    tr -> polarity        = polarity       ;
    tr -> output_terminal = output_terminal;
    tr -> data_source     = data_source    ;
    tr -> delay_value     = delay_value    ;

    return tr;
}


/*! 
@brief Describes a parallel edge sensitive path declaration
*/
ast_edge_sensitive_full_path_declaration * 
  ast_new_edge_sensitive_full_path_declaration(
    ast_edge            edge,               //!< edge_identifier
    ast_list        *   input_terminal,     //!< list_of_path_inputs
    ast_operator        polarity,           //!< polarity_operator
    ast_list        *   output_terminal,    //!< list_of_path_outputs
    ast_expression  *   data_source,        //!< data_source_expression
    ast_list        *   delay_value         //!< path_delay_value
)
{
    ast_edge_sensitive_full_path_declaration * tr = 
        ast_calloc(1,sizeof(ast_edge_sensitive_full_path_declaration));
    ast_set_meta_info(&(tr->meta));

    tr -> edge            = edge           ;
    tr -> input_terminal  = input_terminal ;
    tr -> polarity        = polarity       ;
    tr -> output_terminal = output_terminal;
    tr -> data_source     = data_source    ;
    tr -> delay_value     = delay_value    ;

    return tr;
}


/*!
@brief creates and returns a pointer to a new task-enable statement.
*/
ast_task_enable_statement * ast_new_task_enable_statement(
    ast_list        * expressions,
    ast_identifier    identifier, 
    ast_boolean       is_system   
)
{
    ast_task_enable_statement * tr = ast_calloc(1,
                                        sizeof(ast_task_enable_statement));
    ast_set_meta_info(&(tr->meta));

    tr -> expressions = expressions;
    tr -> identifier  = identifier;
    tr -> is_system   = is_system;

    return tr;
}


/*!
@brief Creates and returns a new forever loop statement.
@param inner_statement - Pointer to the inner body of statements which
make upt the loop body.
*/
ast_loop_statement * ast_new_forever_loop_statement(
    ast_statement * inner_statement
)
{
    ast_loop_statement * tr = ast_calloc(1,sizeof(ast_loop_statement));
    ast_set_meta_info(&(tr->meta));
    
    tr -> type              = LOOP_FOREVER;
    tr -> inner_statement   = inner_statement;
    tr -> initial           = NULL;
    tr -> condition         = NULL;
    tr -> modify            = NULL;

    return tr;
}

/*!
@brief Creates and returns a new for loop statement.
@param inner_statement - Pointer to the inner body of statements which
make upt the loop body.
@param initial_condition - Assignement which sets up the initial condition
of the iterator.
@param modify_assignment - How the iterator variable changes with each
loop iteration.
@param continue_condition - Expression which governs whether the loop should
continue or break.
*/
ast_loop_statement * ast_new_for_loop_statement(
    ast_statement  * inner_statement,
    ast_single_assignment * initial_condition,
    ast_single_assignment * modify_assignment,
    ast_expression * continue_condition
)
{
    ast_loop_statement * tr = ast_calloc(1,sizeof(ast_loop_statement));
    ast_set_meta_info(&(tr->meta));
    
    tr -> type              = LOOP_FOR;
    tr -> inner_statement   = inner_statement;
    tr -> initial           = initial_condition;
    tr -> condition         = continue_condition;
    tr -> modify            = modify_assignment;

    return tr;
}

/*!
@brief Creates and returns a new generate loop statement.
@param inner_statements - Pointer to the inner body of statements which
make up the loop body.
@param initial_condition - Assignement which sets up the initial condition
of the iterator.
@param modify_assignment - How the iterator variable changes with each
loop iteration.
@param continue_condition - Expression which governs whether the loop should
continue or break.
*/
ast_loop_statement * ast_new_generate_loop_statement(
    ast_list              * inner_statements,
    ast_single_assignment * initial_condition,
    ast_single_assignment * modify_assignment,
    ast_expression        * continue_condition
){
    ast_loop_statement * tr = ast_new_for_loop_statement(NULL,
                                                         initial_condition,
                                                         modify_assignment,
                                                         continue_condition);
    ast_set_meta_info(&(tr->meta));
    
    tr -> type = LOOP_GENERATE;
    tr -> generate_items = inner_statements;

    return tr;
}

/*!
@brief Creates and returns a while loop statement.
@param inner_statement - Pointer to the inner body of statements which
make upt the loop body.
@param continue_condition - Expression which governs whether the loop should
continue or break.
*/
ast_loop_statement * ast_new_while_loop_statement(
    ast_statement  * inner_statement,
    ast_expression * continue_condition
)
{
    ast_loop_statement * tr = ast_calloc(1,sizeof(ast_loop_statement));
    ast_set_meta_info(&(tr->meta));
    
    tr -> type              = LOOP_WHILE;
    tr -> inner_statement   = inner_statement;
    tr -> initial           = NULL;
    tr -> condition         = continue_condition;
    tr -> modify            = NULL;

    return tr;
}

/*!
@brief Creates and returns a repeat loop statement.
@param inner_statement - Pointer to the inner body of statements which
make upt the loop body.
@param continue_condition - Expression which governs whether the loop should
continue or break.
*/
ast_loop_statement * ast_new_repeat_loop_statement(
    ast_statement  * inner_statement,
    ast_expression * continue_condition
)
{
    ast_loop_statement * tr = ast_calloc(1,sizeof(ast_loop_statement));
    ast_set_meta_info(&(tr->meta));
    
    tr -> type              = LOOP_REPEAT;
    tr -> inner_statement   = inner_statement;
    tr -> initial           = NULL;
    tr -> condition         = continue_condition;
    tr -> modify            = NULL;

    return tr;
}


/*!
@brief Create and return a new item in a cast statement.
@param conditions - The conditions on which the item is executed.
@param body - Executes when any of the conditions are met.
*/
ast_case_item * ast_new_case_item(ast_list      * conditions,
                                  ast_statement * body)
{
    ast_case_item * tr = ast_calloc(1,sizeof(ast_case_item));
    ast_set_meta_info(&(tr->meta));
    
    tr -> conditions = conditions;
    tr -> body       = body;
    tr -> is_default = AST_FALSE;

    return tr;
}


/*!
@brief Creates and returns a new case statement.
@param expression - The expression evaluated to select a case.
@param cases - list of possible cases.
*/
ast_case_statement * ast_new_case_statement(ast_expression * expression,
                                            ast_list       * cases,
                                            ast_case_statement_type type)
{
    ast_case_statement * tr = ast_calloc(1,sizeof(ast_case_statement));
    ast_set_meta_info(&(tr->meta));

    tr -> expression = expression;
    tr -> cases      = cases;
    tr -> type       = type;
    tr -> is_function = AST_FALSE;

    if(tr -> cases != NULL)
    {
        unsigned int i;
        for(i = 0; i < tr -> cases -> items; i ++)
        {
            ast_case_item * the_case = ast_list_get(tr->cases,i);

            if(the_case == NULL){
                break;
            }

            if(the_case -> is_default == AST_TRUE)
            {
                // Set the default *ast_statement*
                tr -> default_item = the_case -> body;
                break;
            }
        }
    }

    return tr;
}


/*!
@brief Creates and returns a new conditional statement.
@param statement - what to run if the condition holds true.
@param condtion  - the condition on which statement is run.
*/
ast_conditional_statement * ast_new_conditional_statement(
    ast_statement * statement,
    ast_expression * condition
)
{
    ast_conditional_statement * tr = 
        ast_calloc(1,sizeof(ast_conditional_statement));
    ast_set_meta_info(&(tr->meta));

    tr -> statement = statement;
    tr -> condition = condition;

    return tr;
}


/*!
@brief Creates a new if-then-else-then statement.
@param if_condition - the conditional statement.
@param else_condition - What to do if no conditional statements are executed.
This can be NULL.
@details This node also supports "if then elseif then else then" statements,
and uses the ast_extend_if_else function to append a new 
ast_conditional_statement to the end of a list of if-else conditions.
Priority of exectuion is given to items added first.
*/
ast_if_else * ast_new_if_else(
    ast_conditional_statement * if_condition,
    ast_statement             * else_condition
)
{
    ast_if_else * tr = ast_calloc(1, sizeof(ast_if_else));
    ast_set_meta_info(&(tr->meta));

    tr -> else_condition         = else_condition;
    tr -> conditional_statements = ast_list_new();

    ast_list_append(tr -> conditional_statements, if_condition);

    return tr;
}


/*!
@brief Adds an additional conditional (ha..) to an existing if-else
statement.
@param conditional_statements - the existing if-else tree.
@param new_statement - The new statement to add at the end of the existing
if-then conditions, but before any else_condtion.
*/
void  ast_extend_if_else(
    ast_if_else     * conditional_statements,
    ast_list        * new_statements
)
{
    if(new_statements != NULL)
    {
        ast_list_concat(conditional_statements -> conditional_statements,
                        new_statements);
    }
}


/*!
@brief Creates and returns a new wait statement.
*/
ast_wait_statement * ast_new_wait_statement(
    ast_expression * wait_for,
    ast_statement  * statement
)
{
    ast_wait_statement * tr = ast_calloc(1, sizeof(ast_wait_statement));
    ast_set_meta_info(&(tr->meta));
    
    tr -> expression = wait_for;
    tr -> statement  = statement;

    return tr;
}

/*!
@brief Creates a new event expression node
@param trigger_edge - the edge on which the trigger is activated.
@param expression - the expression to monitor the waveforms of.
@bug Assertion (commented out) fires in some circumstances.
*/
ast_event_expression * ast_new_event_expression(
    ast_edge trigger_edge,
    ast_expression * expression
)
{
    ast_event_expression * tr = ast_calloc(1,sizeof(ast_event_expression));

    //assert(trigger_edge != EDGE_NONE);

    if(trigger_edge == EDGE_POS)
    {
        tr -> type = EVENT_POSEDGE;
        tr -> expression = expression;
    }
    else if (trigger_edge == EDGE_NEG)
    {
        tr -> type = EVENT_NEGEDGE;
        tr -> expression = expression;
    }
    else if (trigger_edge == EDGE_ANY)
    {
        tr -> type = EVENT_EXPRESSION;
        tr -> expression = expression;
    }

    return tr;
}

/*!
@brief Creates a new event expression node, which is itself a sequence of
sub-expressions.
*/
ast_event_expression * ast_new_event_expression_sequence(
    ast_event_expression * left,
    ast_event_expression * right
)
{
    ast_event_expression * tr = ast_calloc(1,sizeof(ast_event_expression));

    tr -> type = EVENT_SEQUENCE;
    tr -> sequence = ast_list_new();

    ast_list_append(tr -> sequence, right);
    ast_list_append(tr -> sequence, left );

    return tr;
}

/*!
@brief Creates and returns a new event control specifier.
*/
ast_event_control * ast_new_event_control(
    ast_event_control_type type,
    ast_event_expression * expression
)
{
    ast_event_control * tr = ast_calloc(1,sizeof(ast_event_control));
    ast_set_meta_info(&(tr->meta));

    if(type == EVENT_CTRL_ANY)
        assert(expression == NULL);

    tr -> type = type;
    tr -> expression = expression;

    return tr;
}

/*!
@brief creates and returns a new delay control statement.
*/
ast_delay_ctrl * ast_new_delay_ctrl_value(ast_delay_value * value)
{
    ast_delay_ctrl * tr = ast_calloc(1,sizeof(ast_event_control));
    ast_set_meta_info(&(tr->meta));

    tr -> type = DELAY_CTRL_VALUE;
    tr -> value = value;

    return tr;
}

/*!
@brief creates and returns a new delay control statement.
*/
ast_delay_ctrl * ast_new_delay_ctrl_mintypmax(
    ast_expression * mintypmax
)
{
    ast_delay_ctrl * tr = ast_calloc(1,sizeof(ast_event_control));
    ast_set_meta_info(&(tr->meta));

    tr -> type = DELAY_CTRL_MINTYPMAX;
    tr -> mintypmax = mintypmax;

    return tr;
}

/*!
@brief Creates and returns a new timing control statement node.
*/
ast_timing_control_statement * ast_new_timing_control_statement_delay(
    ast_timing_control_statement_type   type,
    ast_statement                     * statement,
    ast_delay_ctrl                    * delay_ctrl
)
{
    ast_timing_control_statement * tr = 
        ast_calloc(1,sizeof(ast_timing_control_statement));
    ast_set_meta_info(&(tr->meta));

    assert(type == TIMING_CTRL_DELAY_CONTROL);

    tr -> type = type;
    tr -> delay = delay_ctrl;
    tr -> statement = statement;
    tr -> repeat = NULL;

    return tr;
}


/*!
@brief Creates and returns a new timing control statement node.
*/
ast_timing_control_statement * ast_new_timing_control_statement_event(
    ast_timing_control_statement_type   type,
    ast_expression                    * repeat,
    ast_statement                     * statement,
    ast_event_control                 * event_ctrl
)
{
    ast_timing_control_statement * tr = 
        ast_calloc(1,sizeof(ast_timing_control_statement));
    ast_set_meta_info(&(tr->meta));

    assert(type == TIMING_CTRL_EVENT_CONTROL ||
           type == TIMING_CTRL_EVENT_CONTROL_REPEAT);

    tr -> type = type;
    tr -> event_ctrl = event_ctrl;
    tr -> statement = statement;
    tr -> repeat = repeat;

    return tr;
}

/*!
@brief Creates and returns a new assignment.
*/
ast_single_assignment * ast_new_single_assignment(
    ast_lvalue * lval,
    ast_expression * expression
)
{
    ast_single_assignment * tr = ast_calloc(1,sizeof(ast_single_assignment));
    ast_set_meta_info(&(tr->meta));

    tr -> lval = lval;
    tr -> expression = expression;

    return tr;
}

/*!
@brief Creates a new hybrid assignment of the specified type.
*/
ast_assignment * ast_new_hybrid_assignment(
    ast_hybrid_assignment_type type,
    ast_single_assignment * assignment
)
{
    ast_assignment * tr = ast_calloc(1,sizeof(ast_assignment));
    ast_set_meta_info(&(tr->meta));

    tr -> type = ASSIGNMENT_HYBRID;
    tr -> hybrid = ast_calloc(1,sizeof(ast_hybrid_assignment));
    tr -> hybrid -> type = type;
    tr -> hybrid -> assignment = assignment;

    return tr;
}


/*!
@brief Creates a new hybrid assignment of the specified type.
*/
ast_assignment * ast_new_hybrid_lval_assignment(
    ast_hybrid_assignment_type type,
    ast_lvalue *lval 
)
{
    ast_assignment * tr = ast_calloc(1,sizeof(ast_assignment));
    ast_set_meta_info(&(tr->meta));

    tr -> type = ASSIGNMENT_HYBRID;
    tr -> hybrid = ast_calloc(1,sizeof(ast_hybrid_assignment));
    tr -> hybrid -> type = type;
    tr -> hybrid -> lval = lval;

    return tr;
}

/*!
@brief Creates and returns a new blocking procedural assignment object.
*/
ast_assignment * ast_new_blocking_assignment(
    ast_lvalue * lval,
    ast_expression  * expression,
    ast_timing_control_statement* delay_or_event
)
{
    ast_assignment * tr = ast_calloc(1,sizeof(ast_assignment));
    ast_set_meta_info(&(tr->meta));
    tr -> type          = ASSIGNMENT_BLOCKING;

    tr -> procedural    =  ast_calloc(1,sizeof(ast_procedural_assignment));
    tr -> procedural    -> lval = lval;
    tr -> procedural    -> expression = expression;
    tr -> procedural    -> delay_or_event = delay_or_event;

    return tr;
}

/*!
@brief Creates and returns a new nonblocking procedural assignment object.
*/
ast_assignment * ast_new_nonblocking_assignment(
    ast_lvalue * lval,
    ast_expression  * expression,
    ast_timing_control_statement * delay_or_event
)
{
    ast_assignment * tr = ast_calloc(1,sizeof(ast_assignment));
    ast_set_meta_info(&(tr->meta));
    tr -> type          = ASSIGNMENT_NONBLOCKING;

    tr -> procedural    =  ast_calloc(1,sizeof(ast_procedural_assignment));
    tr -> procedural    -> lval = lval;
    tr -> procedural    -> expression = expression;
    tr -> procedural    -> delay_or_event = delay_or_event;

    return tr;
}


/*!
@brief Creates and returns a new continuous assignment object.
*/
ast_assignment * ast_new_continuous_assignment(
    ast_list * assignments,
    ast_drive_strength * strength,
    ast_delay3 * delay
)
{
    ast_continuous_assignment * trc = ast_calloc(1,
                sizeof(ast_continuous_assignment));
    trc -> assignments = assignments;

    unsigned int i;
    for(i = 0; i < assignments -> items;  i++)
    {
        ast_single_assignment * item = ast_list_get(assignments,i);
        item -> drive_strength = strength;
        item -> delay    = delay;
    }

    ast_assignment * tr = ast_calloc(1, sizeof(ast_assignment));

    ast_set_meta_info(&(tr->meta));

    tr -> type = ASSIGNMENT_CONTINUOUS;
    tr -> continuous = trc;

    return tr;
}


/*!
@brief Creates and returns a new statement block of the specified type
*/
ast_statement_block * ast_new_statement_block(
    ast_block_type   type,
    ast_identifier   block_identifier,
    ast_list       * declarations,
    ast_list       * statements
)
{
    ast_statement_block * tr = ast_calloc(1,sizeof(ast_statement_block));
    ast_set_meta_info(&(tr->meta));

    tr -> type = type;
    tr -> block_identifier = block_identifier;
    tr -> declarations = declarations;
    tr -> statements = statements;

    return tr;
}

//! Creates and returns a pointer to a new disable statement.
ast_disable_statement * ast_new_disable_statement(ast_identifier   id)
{
    ast_disable_statement * tr = ast_calloc(1, sizeof(ast_disable_statement));
    ast_set_meta_info(&(tr->meta));
    tr -> id = id;
    return tr;
}


/*!
@brief Creates a new AST statement and returns it.
@note Requires the data field of the union to be filled out manually.
*/
ast_statement * ast_new_statement(
    ast_node_attributes * attr,
    ast_boolean         is_function_statement,
    void             *  data,
    ast_statement_type  type
)
{
    ast_statement * tr = ast_calloc(1,sizeof(ast_statement));
    ast_set_meta_info(&(tr->meta));

    tr -> type = type;
    tr -> is_function_statement = is_function_statement;
    tr -> is_generate_statement = AST_FALSE;
    tr -> data = data;
    tr -> attributes = attr;

    return tr;
}


/*!
@brief Creates a new UDP port AST node
@details
@returns A pointer to the new port
*/
ast_udp_port * ast_new_udp_port(
    ast_port_direction    direction,
    ast_identifier        identifier,
    ast_node_attributes * attributes,
    ast_boolean           reg,
    ast_expression      * default_value
)
{
    ast_udp_port * tr = ast_calloc(1,sizeof(ast_udp_port));
    ast_set_meta_info(&(tr->meta));
    tr -> direction     = direction;
    assert(direction != PORT_INPUT);
    tr -> identifier    = identifier;
    tr -> attributes    = attributes;
    tr -> reg           = reg;
    tr -> default_value = default_value;
    return tr;
}


/*!
@brief Creates a new UDP port AST node
@details
@returns A pointer to the new port
*/
ast_udp_port * ast_new_udp_input_port(
    ast_list            * identifiers,
    ast_node_attributes * attributes
)
{
    ast_udp_port * tr = ast_calloc(1,sizeof(ast_udp_port));
    ast_set_meta_info(&(tr->meta));
    tr -> direction     = PORT_INPUT;
    tr -> identifiers   = identifiers;
    tr -> attributes    = attributes;
    tr -> reg           = AST_FALSE;
    tr -> default_value = NULL;
    return tr;
}

/*!
@brief Creates a new UDP declaration node
@details
@returns A pointer to the new node.
*/
ast_udp_declaration * ast_new_udp_declaration(
    ast_node_attributes * attributes,
    ast_identifier        identifier,
    ast_list            * ports,
    ast_udp_body        * body
)
{
    ast_udp_declaration * tr = ast_calloc(1,sizeof(ast_udp_declaration));
    ast_set_meta_info(&(tr->meta));

    tr -> attributes    = attributes;
    tr -> identifier    = identifier;
    tr -> ports         = ports;
    tr -> body_entries  = body -> entries;
    tr -> initial       = body -> initial;
    tr -> body_type     = body -> body_type;

    return tr;
}

/*!
@brief Creates a new instance of a UDP.
@details
@returns A pointer to the new instance.
*/
ast_udp_instance * ast_new_udp_instance(
    ast_identifier        identifier,
    ast_range           * range,
    ast_lvalue          * output,
    ast_list            * inputs
){
    ast_udp_instance * tr = ast_calloc(1,sizeof(ast_udp_instance));
    ast_set_meta_info(&(tr->meta));

    tr -> identifier    = identifier;
    tr -> range         = range;
    tr -> output        = output;
    tr -> inputs        = inputs;

    return tr;
}

/*!
@brief Creates a new list of UDP instances with shared properties.
@details 
@returns A pointer to the new list.
*/
ast_udp_instantiation * ast_new_udp_instantiation(
    ast_list            * instances,
    ast_identifier        identifier,
    ast_drive_strength  * drive_strength,
    ast_delay2          * delay
){
    ast_udp_instantiation * tr = ast_calloc(1,sizeof(ast_udp_instantiation));
    ast_set_meta_info(&(tr->meta));

    tr -> instances     = instances;
    tr -> identifier    = identifier;
    tr -> drive_strength= drive_strength;
    tr -> delay         = delay;

    return tr;
}


//! Creates a new initial statement node.
ast_udp_initial_statement * ast_new_udp_initial_statement(
    ast_identifier   output_port,
    ast_number     * initial_value
){
    ast_udp_initial_statement *tr=ast_calloc(1,sizeof(ast_udp_initial_statement));
    
    tr -> output_port   = output_port;
    tr -> initial_value = initial_value;

    return tr;
}


//! Creates and returns a new sequential UDP body representation.
ast_udp_body * ast_new_udp_sequential_body(
    ast_udp_initial_statement * initial_statement,
    ast_list                  * sequential_entries
){
    ast_udp_body * tr = ast_calloc(1,sizeof(ast_udp_body));
    ast_set_meta_info(&(tr->meta));
    
    tr -> body_type = UDP_BODY_SEQUENTIAL;
    tr -> initial   = initial_statement;
    tr -> entries   = sequential_entries;

    return tr;
}

//! Creates and returns a new combinatorial UDP body representation.
ast_udp_body * ast_new_udp_combinatoral_body(
    ast_list                  * combinatorial_entries
){
    ast_udp_body * tr = ast_calloc(1,sizeof(ast_udp_body));
    ast_set_meta_info(&(tr->meta));

    tr -> body_type = UDP_BODY_COMBINATORIAL;
    tr -> entries = combinatorial_entries;

    return tr;
}

//! Creates a new combinatorial entry for a UDP node.
ast_udp_combinatorial_entry * ast_new_udp_combinatoral_entry(
    ast_list * input_levels,
    ast_udp_next_state output_symbol
){
    ast_udp_combinatorial_entry * tr = 
        ast_calloc(1,sizeof(ast_udp_combinatorial_entry));
    ast_set_meta_info(&(tr->meta));

    tr -> input_levels = input_levels;
    tr -> output_symbol = output_symbol;

    return tr;
}

//! Creates a new sequntial body entry for a UDP node.
ast_udp_sequential_entry * ast_new_udp_sequential_entry(
    ast_udp_seqential_entry_prefix prefix_type,
    ast_list    *                  levels_or_edges,
    ast_level_symbol               current_state,
    ast_udp_next_state             output
){
    ast_udp_sequential_entry * tr = ast_calloc(1,
                                        sizeof(ast_udp_sequential_entry));
    ast_set_meta_info(&(tr->meta));

    tr -> entry_prefix = prefix_type;

    if(prefix_type == PREFIX_EDGES)
        tr -> edges = levels_or_edges;
    else
        tr -> levels = levels_or_edges;

    tr -> current_state = current_state;
    tr -> output        = output;

    return tr;
}


/*!
@brief Creates and returns a new item which exists inside a generate statement.
@details Wraps around ast_new_statement and sets appropriate internal flags
to represent this as a statment in a generate block.
@note the void* type of the construct parameter allows for a single
constructor function rather than one per member of the union inside the
ast_generate_item structure.
*/
ast_statement * ast_new_generate_item(
    ast_statement_type type,
    void    *          construct
){
    ast_statement * tr = ast_new_statement(NULL, AST_FALSE, construct,type);
    ast_set_meta_info(&(tr->meta));

    tr -> is_generate_statement = AST_TRUE;

    return tr;
}


//! Creates and returns a new block of generate items.
ast_generate_block * ast_new_generate_block(
    ast_identifier   identifier,
    ast_list       * generate_items
){
    ast_generate_block * tr = ast_calloc(1,sizeof(ast_generate_block));
    ast_set_meta_info(&(tr->meta));

    tr -> generate_items = generate_items;
    tr -> identifier     = identifier;

    return tr;
}


/*!
@brief Creates and returns a new set of module instances with shared
parameters.
*/
ast_module_instantiation * ast_new_module_instantiation(
    ast_identifier          module_identifer,
    ast_list              * module_parameters,
    ast_list              * module_instances
){
    ast_module_instantiation * tr = 
        ast_calloc(1,sizeof(ast_module_instantiation));
    ast_set_meta_info(&(tr->meta));
    
    tr -> resolved = AST_FALSE;
    tr -> module_identifer  = module_identifer;
    tr -> module_parameters = module_parameters;
    tr -> module_instances  = module_instances;

    return tr;
}

/*!
@brief Creates and returns a new instance of a module with a given identifer
and set of port connections.
*/
ast_module_instance * ast_new_module_instance(
    ast_identifier          instance_identifier,
    ast_list              * port_connections
){
    ast_module_instance * tr = ast_calloc(1,sizeof(ast_module_instance));
    ast_set_meta_info(&(tr->meta));

    tr -> instance_identifier = instance_identifier;
    tr -> port_connections    = port_connections;

    return tr;
}

/*!
@brief Creates and returns a new port connection representation.
@param port_name - The port being assigned to.
@param expression - The thing inside the module the port connects to.
*/
ast_port_connection * ast_new_named_port_connection(
    ast_identifier   port_name,
    ast_expression * expression
){
    ast_port_connection * tr = ast_calloc(1,sizeof(ast_port_connection));
    ast_set_meta_info(&(tr->meta));

    tr -> port_name = port_name;
    tr -> expression = expression;

    return tr;
}


//! Instances a new switch type with a delay3.
ast_switch_gate * ast_new_switch_gate_d3(
    ast_switchtype type,
    ast_delay3    * delay
){
    assert(type != SWITCH_TRAN && type != SWITCH_RTRAN);
    ast_switch_gate * tr = ast_calloc(1,sizeof(ast_switch_gate));
    ast_set_meta_info(&(tr->meta));

    tr -> type   = type;
    tr -> delay3 = delay;

    return tr;
}

//! Instances a new switch type with a delay2.
ast_switch_gate * ast_new_switch_gate_d2(
    ast_switchtype type,
    ast_delay2    * delay
){
    assert(type == SWITCH_TRAN || type == SWITCH_RTRAN);
    ast_switch_gate * tr = ast_calloc(1,sizeof(ast_switch_gate));
    ast_set_meta_info(&(tr->meta));

    tr -> type   = type;
    tr -> delay2 = delay;

    return tr;
}

//! Creates and returns a new structure describing primitive net strength.
ast_primitive_pull_strength * ast_new_primitive_pull_strength(
    ast_pull_direction       direction,
    ast_primitive_strength   strength_1,
    ast_primitive_strength   strength_0
){
    ast_primitive_pull_strength * tr = 
        ast_calloc(1,sizeof(ast_primitive_pull_strength));
    ast_set_meta_info(&(tr->meta));

    tr -> direction  = direction;
    tr -> strength_1 = strength_1;
    tr -> strength_0 = strength_0;

    return tr;
}

/*! @brief Describes a single pull gate instance.*/
ast_pull_gate_instance * ast_new_pull_gate_instance(
    ast_identifier      name,
    ast_lvalue        * output_terminal
){
    ast_pull_gate_instance * tr = ast_calloc(1,sizeof(ast_pull_gate_instance));
    ast_set_meta_info(&(tr->meta));

    tr -> name = name;
    tr -> output_terminal = output_terminal;

    return tr;
}

/*! @brief A single pass transistor instance.*/
ast_pass_switch_instance * ast_new_pass_switch_instance(
    ast_identifier      name,
    ast_lvalue        * terminal_1,
    ast_lvalue        * terminal_2
){
    ast_pass_switch_instance * tr = 
                        ast_calloc(1,sizeof(ast_pass_switch_instance));
    ast_set_meta_info(&(tr->meta));

    tr -> name = name;
    tr -> terminal_1 = terminal_1;
    tr -> terminal_2 = terminal_2;

    return tr;
}

/*! @brief An N-input gate instance. e.g. 3-to-1 NAND.*/
ast_n_input_gate_instance * ast_new_n_input_gate_instance(
    ast_identifier      name,
    ast_list          * input_terminals,
    ast_lvalue        * output_terminal
){
    ast_n_input_gate_instance * tr =
                        ast_calloc(1,sizeof(ast_n_input_gate_instance));

    tr -> name = name;
    tr -> input_terminals = input_terminals;
    tr -> output_terminal = output_terminal;

    return tr;
}

/*! @brief A single Enable gate instance.*/
ast_enable_gate_instance * ast_new_enable_gate_instance(
    ast_identifier      name,
    ast_lvalue        * output_terminal,
    ast_expression    * enable_terminal,
    ast_expression    * input_terminal
){
    ast_enable_gate_instance * tr = 
        ast_calloc(1,sizeof(ast_enable_gate_instance));
    ast_set_meta_info(&(tr->meta));

    tr -> name = name;
    tr -> output_terminal = output_terminal;
    tr -> enable_terminal = enable_terminal;
    tr -> input_terminal  = input_terminal;

    return tr;
}

/*! @brief A single MOS switch (transistor) instance.*/
ast_mos_switch_instance * ast_new_mos_switch_instance(
    ast_identifier      name,
    ast_lvalue        * output_terminal,
    ast_expression    * enable_terminal,
    ast_expression    * input_terminal
){
    ast_mos_switch_instance * tr = 
        ast_calloc(1,sizeof(ast_mos_switch_instance));
    ast_set_meta_info(&(tr->meta));

    tr -> name = name;
    tr -> output_terminal = output_terminal;
    tr -> enable_terminal = enable_terminal;
    tr -> input_terminal  = input_terminal;

    return tr;
}

/*! @brief A single CMOS switch (transistor) instance.*/
ast_cmos_switch_instance * ast_new_cmos_switch_instance(
    ast_identifier      name,
    ast_lvalue        * output_terminal,
    ast_expression    * ncontrol_terminal,
    ast_expression    * pcontrol_terminal,
    ast_expression    * input_terminal
){
    ast_cmos_switch_instance * tr = 
        ast_calloc(1,sizeof(ast_cmos_switch_instance));
    ast_set_meta_info(&(tr->meta));

    tr -> name = name;
    tr -> output_terminal = output_terminal;
    tr -> ncontrol_terminal = ncontrol_terminal;
    tr -> pcontrol_terminal = pcontrol_terminal;
    tr -> input_terminal = input_terminal;

    return tr;
}

/*!
@brief Creates and returns a new pass enable switch instance.
*/
ast_pass_enable_switch * ast_new_pass_enable_switch(
    ast_identifier      name,
    ast_lvalue        * terminal_1,
    ast_lvalue        * terminal_2,
    ast_expression    * enable
){
    ast_pass_enable_switch * tr = 
        ast_calloc(1,sizeof(ast_pass_enable_switch));
    ast_set_meta_info(&(tr->meta));

    tr -> name = name;
    tr -> terminal_1 = terminal_1;
    tr -> terminal_2 = terminal_2;
    tr -> enable = enable;

    return tr;
}


/*!
@brief Creates and returns a collection of pass enable switches.
*/
ast_pass_enable_switches * ast_new_pass_enable_switches(
    ast_pass_enable_switchtype    type,
    ast_delay2                  * delay,
    ast_list                    * switches 
){
    ast_pass_enable_switches * tr = 
                              ast_calloc(1,sizeof(ast_pass_enable_switches));
    ast_set_meta_info(&(tr->meta));

    tr -> type = type;
    tr -> delay = delay;
    tr -> switches = switches;

    return tr;
}


/*! 
@brief Creates collection of n-input gates with the same type and properties.
*/
ast_n_input_gate_instances * ast_new_n_input_gate_instances(
    ast_gatetype_n_input    type,
    ast_delay3            * delay,
    ast_drive_strength    * drive_strength,
    ast_list              * instances
){
    ast_n_input_gate_instances * tr = 
                            ast_calloc(1,sizeof(ast_n_input_gate_instances));
    ast_set_meta_info(&(tr->meta));

    tr -> type = type;
    tr -> delay = delay;
    tr -> drive_strength = drive_strength;
    tr -> instances = instances;

    return tr;
}

//! Creates collection of enable gates with the same type and properties.
ast_enable_gate_instances * ast_new_enable_gate_instances(
    ast_gatetype_n_input    type,
    ast_delay3            * delay,
    ast_drive_strength    * drive_strength,
    ast_list              * instances
){
    ast_enable_gate_instances * tr = 
                            ast_calloc(1,sizeof(ast_enable_gate_instances));
    ast_set_meta_info(&(tr->meta));

    tr -> type = type;
    tr -> delay = delay;
    tr -> drive_strength = drive_strength;
    tr -> instances = instances;

    return tr;
}


/*!
@brief Creates and returns a new n_output gate instance.
@see ast_n_output_gate_instances
*/
ast_n_output_gate_instance * ast_new_n_output_gate_instance(
    ast_identifier                name,
    ast_list                    * outputs,
    ast_expression              * input
){
    ast_n_output_gate_instance * tr =
                            ast_calloc(1,sizeof(ast_n_output_gate_instance));

    tr -> name = name;
    tr -> outputs = outputs;
    tr -> input = input;

    return tr;
}

/*!
@brief Creates and returns a set of n_output gates with the same properties.
*/
ast_n_output_gate_instances * ast_new_n_output_gate_instances(
    ast_n_output_gatetype         type,
    ast_delay2                  * delay,
    ast_drive_strength          * drive_strength,
    ast_list                    * instances
){
    ast_n_output_gate_instances * tr = 
                          ast_calloc(1,sizeof(ast_n_output_gate_instances));
    ast_set_meta_info(&(tr->meta));

    tr -> type = type;
    tr -> delay = delay;
    tr -> drive_strength = drive_strength;
    tr -> instances = instances;

    return tr;
}

/*!
@brief creat and return a new collection of AST switches.
*/
ast_switches * ast_new_switches(ast_switch_gate * type, ast_list * switches)
{
    ast_switches * tr = ast_calloc(1,sizeof(ast_switches));
    ast_set_meta_info(&(tr->meta));

    tr -> type = type;
    tr -> switches = switches;

    return tr;
}

//! Create and return a new pull strength indicator for 1 and 0.
ast_pull_strength * ast_new_pull_stregth(
    ast_primitive_strength strength_1,
    ast_primitive_strength strength_2
){
    ast_pull_strength * tr =ast_calloc(1,sizeof(ast_pull_strength));
    ast_set_meta_info(&(tr->meta));

    tr -> strength_1 = strength_1;
    tr -> strength_2 = strength_2;

    return tr;
}

/*!
@brief Creates and returns a new gate instantiation descriptor.
@details Expects the data fields to be filled out manually after the structure
is returned.
*/
ast_gate_instantiation * ast_new_gate_instantiation(ast_gate_type type)
{
    ast_gate_instantiation * tr = ast_calloc(1,sizeof(ast_gate_instantiation));
    ast_set_meta_info(&(tr->meta));
    tr -> type = type;
    return tr;
}

/*!
@brief creates and returns a new set of parameter declarations of the same type
@param [in] assignments - The list of individual assignments.
@param [in] signed_values - are the bit vectors signed?
@param [in] range - Bit range
@param [in] type - type of the parameters.
*/
ast_parameter_declarations * ast_new_parameter_declarations(
    ast_list        * assignments,
    ast_boolean       signed_values,
    ast_boolean       local,
    ast_range       * range,
    ast_parameter_type  type 
){
    ast_parameter_declarations * tr = 
            ast_calloc(1,sizeof(ast_parameter_declarations));
    ast_set_meta_info(&(tr->meta));


    tr -> assignments = assignments;
    tr -> signed_values = signed_values;
    tr -> range = range;
    tr -> type = type;
    tr -> local = local;

    if(type != PARAM_GENERIC){
        tr -> range = NULL;
        tr -> signed_values = AST_FALSE;
    }

    return tr;
}

/*!
@brief Creates and returns a new port declaration representation.
*/
ast_port_declaration * ast_new_port_declaration(
    ast_port_direction  direction,      //!< [in] Input / output / inout etc.
    ast_net_type        net_type,       //!< [in] Wire/reg etc
    ast_boolean         net_signed,     //!< [in] Signed value?
    ast_boolean         is_reg,         //!< [in] Is explicitly a "reg"
    ast_boolean         is_variable,    //!< [in] Variable or net?
    ast_range         * range,          //!< [in] Bus width.
    ast_list          * port_names      //!< [in] The names of the ports.
){
    ast_port_declaration * tr = ast_calloc(1,sizeof(ast_port_declaration));
    ast_set_meta_info(&(tr->meta));

    tr -> direction   =  direction  ;
    tr -> net_type    =  net_type   ;
    tr -> net_signed  =  net_signed ;
    tr -> is_reg      =  is_reg     ;
    tr -> is_variable =  is_variable;
    tr -> range       =  range      ;
    tr -> port_names  = port_names  ;
    
    return tr;
}

/*!
@brief Creates and returns a node to represent the declaration of a new
module item construct.
@details Because of the complex nature of the grammar for these declarations,
(bourne from the number of optional modifiers) no single constructor function
is provided. Rather, one can create a new type declaration of a
known type, but must otherwise fill out the data members as they go along.
All pointer members are initialised to NULL, and all boolean members will
initially be false.
*/
ast_type_declaration * ast_new_type_declaration(ast_declaration_type type)
{
    ast_type_declaration * tr = ast_calloc(1,sizeof(ast_type_declaration));
    ast_set_meta_info(&(tr->meta));

    tr -> type = type;
    tr -> identifiers = NULL;
    tr -> delay = NULL;
    tr -> drive_strength = NULL;
    tr -> charge_strength = CHARGE_DEFAULT;
    tr -> range = NULL;
    tr -> vectored = AST_FALSE;
    tr -> scalared = AST_FALSE;
    tr -> is_signed = AST_FALSE;
    tr -> net_type  = NET_TYPE_NONE;

    return tr;
}   

/*!
@brief Creates a new net declaration object.
@details Turns a generic "type declaration" object into a net_declration
object and discards un-needed member fields.
@returns A set of ast_net_declaration types as a list, one for each identifer
in the original type declaration object.
*/
ast_list * ast_new_net_declaration(
    ast_type_declaration * type_dec
){
    assert(type_dec != NULL);
    assert(type_dec -> identifiers != NULL);

    ast_list * tr = ast_list_new();
    
    unsigned int i = 0;
    for (i = 0; i < type_dec -> identifiers -> items; i ++)
    {
        ast_net_declaration * toadd =ast_calloc(1,sizeof(ast_net_declaration));
        toadd -> meta       = type_dec -> meta;

        toadd -> identifier = ast_list_get(type_dec -> identifiers, i);
        toadd -> type       = type_dec -> net_type;
        toadd -> delay      = type_dec -> delay;
        toadd -> drive      = type_dec -> drive_strength;
        toadd -> range      = type_dec -> range;
        toadd -> vectored   = type_dec -> vectored;
        toadd -> scalared   = type_dec -> scalared;
        toadd -> is_signed  = type_dec -> is_signed;
        toadd -> value      = NULL;

        ast_list_append(tr,toadd);
    }

    return tr;
}

/*!
@brief Creates a new reg declaration object.
@details Turns a generic "type declaration" object into a reg_declration
object and discards un-needed member fields.
@returns A set of ast_reg_declaration types as a list, one for each identifer
in the original type declaration object.
*/
ast_list * ast_new_reg_declaration(
    ast_type_declaration * type_dec
){
    ast_list * tr = ast_list_new();
    
    unsigned int i = 0;
    for (i = 0; i < type_dec -> identifiers -> items; i ++)
    {
        ast_reg_declaration * toadd =ast_calloc(1,sizeof(ast_reg_declaration));
        toadd -> meta       = type_dec -> meta;

        toadd -> identifier = ast_list_get(type_dec -> identifiers, i);
        toadd -> range      = type_dec -> range;
        toadd -> is_signed  = type_dec -> is_signed;
        toadd -> value      = NULL;

        ast_list_append(tr,toadd);
    }

    return tr;
}

/*!
@brief Creates a new variable declaration object.
@details Turns a generic "var declaration" object into a var_declration
object and discards un-needed member fields.
@returns A set of ast_var_declaration types as a list, one for each identifer
in the original type declaration object.
*/
ast_list * ast_new_var_declaration(
    ast_type_declaration * type_dec
){
    ast_list * tr = ast_list_new();
    
    unsigned int i = 0;
    for (i = 0; i < type_dec -> identifiers -> items; i ++)
    {
        ast_var_declaration * toadd =ast_calloc(1,sizeof(ast_var_declaration));
        toadd -> meta       = type_dec -> meta;

        toadd -> identifier = ast_list_get(type_dec -> identifiers,i);
        toadd -> type       = type_dec -> type;

        ast_list_append(tr,toadd);
    }

    return tr;
}

/*!
@brief Create a new delay value.
*/
ast_delay_value * ast_new_delay_value(
    ast_delay_value_type type,
    void * data
){
    ast_delay_value * tr = ast_calloc(1,sizeof(ast_delay_value));
    ast_set_meta_info(&(tr->meta));
    
    tr -> type = type;
    tr -> data = data;

    return tr;
}

/*!
@brief Create a new delay3 instance.
*/
ast_delay3 * ast_new_delay3(
    ast_delay_value * min,
    ast_delay_value * avg,
    ast_delay_value * max
){
    ast_delay3 * tr = ast_calloc(1,sizeof(ast_delay3));
    ast_set_meta_info(&(tr->meta));

    tr -> min = min;
    tr -> avg = avg;
    tr -> max = max;

    return tr;
}

/*!
@brief Create a new delay2 instance.
*/
ast_delay2 * ast_new_delay2(
    ast_delay_value * min,
    ast_delay_value * max
){
    ast_delay2 * tr = ast_calloc(1,sizeof(ast_delay2));
    ast_set_meta_info(&(tr->meta));

    tr -> min = min;
    tr -> max = max;

    return tr;
}


/*!
@brief Creates and returns a new pulse control data structure.
*/
ast_pulse_control_specparam * ast_new_pulse_control_specparam(
    ast_expression * reject_limit,
    ast_expression * error_limit
){
    ast_pulse_control_specparam * tr =
        ast_calloc(1,sizeof(ast_pulse_control_specparam));

    tr -> reject_limit = reject_limit;
    tr -> error_limit  = error_limit;

    return tr;
}


/*!
@brief Creates and returns a new range or dimension representation node.
*/
ast_range * ast_new_range(
    ast_expression * upper,
    ast_expression * lower
){
    ast_range * tr = ast_calloc(1,sizeof(ast_range));

    tr -> upper = upper;
    tr -> lower = lower;

    return tr;
}

/*!
@brief Creates and returns a new object storing either a range or a type.
@note Expects the union member of ast_range_or_type to be set manually.
@param [in] is_range - true if the contained object will be a range instance,
else false.
*/
ast_range_or_type * ast_new_range_or_type(ast_boolean is_range)
{
    ast_range_or_type * tr = ast_calloc(1,sizeof(ast_range_or_type));
    ast_set_meta_info(&(tr->meta));

    tr -> is_range = is_range;

    return tr;
}

/*!
@brief Creates and returns a function declaration node.
*/
ast_function_declaration * ast_new_function_declaration(
    ast_boolean         automatic,
    ast_boolean         is_signed,
    ast_boolean         function_or_block,
    ast_range_or_type  *rot,
    ast_identifier      identifier,
    ast_list           *item_declarations,
    ast_statement      *statements
){
    ast_function_declaration * tr = ast_calloc(
        1,sizeof(ast_function_declaration));
    ast_set_meta_info(&(tr->meta));
    
    tr -> automatic         = automatic;
    tr -> is_signed         = is_signed;
    tr -> function_or_block = function_or_block;
    tr -> rot               = rot;
    tr -> identifier        = identifier;
    tr -> item_declarations = item_declarations;
    tr -> statements        = statements;

    return tr;
}

/*!
@brief Creates and returns a new function item declaration.
@note All member fields must be filled out manaully. THis function just
ensures the memory is allocated properly.
*/
ast_function_item_declaration * ast_new_function_item_declaration(){
    return ast_calloc(1,sizeof(ast_function_item_declaration));
}

/*
@brief Creates and returns a new representation of a task or function
argument.
*/
ast_task_port * ast_new_task_port(
    ast_port_direction direction,
    ast_boolean        reg,
    ast_boolean        is_signed,
    ast_range        * range,
    ast_task_port_type type,
    ast_list         * identifiers //!< The list of port names.
){
    ast_task_port * tr = ast_calloc(1,sizeof(ast_task_port));
    ast_set_meta_info(&(tr->meta));

    tr -> direction   = direction;
    tr -> reg         = reg;
    tr -> is_signed   = is_signed;
    tr -> range       = range;
    tr -> type        = type;
    tr -> identifiers = identifiers; //!< The list of port names.

    return tr;
}

/*!
@brief Creates and returns a new task declaration statement.
*/
ast_task_declaration * ast_new_task_declaration(
    ast_boolean         automatic,
    ast_identifier      identifier,
    ast_list        *   ports,
    ast_list        *   declarations,
    ast_statement   *   statements
){
    ast_task_declaration * tr = ast_calloc(1,sizeof(ast_task_declaration));
    ast_set_meta_info(&(tr->meta));

    tr -> automatic  = automatic;
    tr -> identifier = identifier;
    tr -> declarations = declarations;
    tr -> ports     = ports;
    tr -> statements = statements;

    return tr;
}

/*!
@brief Creates and returns a new block register declaration descriptor.
*/
ast_block_reg_declaration * ast_new_block_reg_declaration(
    ast_boolean   is_signed,
    ast_range   * range,
    ast_list    * identifiers
){
    ast_block_reg_declaration * tr =
        ast_calloc(1,sizeof(ast_block_reg_declaration));

    tr -> is_signed = is_signed;
    tr -> range     = range;
    tr -> identifiers = identifiers;

    return tr;
}


/*!
@brief Creates and returns a new block item declaration of the specified type.
@note Expects the relevant union member to be set manually.
*/
ast_block_item_declaration * ast_new_block_item_declaration(
    ast_block_item_declaration_type type,
    ast_node_attributes             * attributes
){
    ast_block_item_declaration * tr = 
        ast_calloc(1,sizeof(ast_block_item_declaration));
    ast_set_meta_info(&(tr->meta));

    tr -> type = type;
    tr -> attributes = attributes;

    return tr;
}

/*!
@brief Creates and returns a new module item descriptor.
@note Expects the relevant union member to be set based on the type manually.
*/
ast_module_item * ast_new_module_item(
    ast_node_attributes * attributes,
    ast_module_item_type  type
){
    ast_module_item * tr = ast_calloc(1,sizeof(ast_module_item));
    ast_set_meta_info(&(tr->meta));

    tr -> type       = type;
    tr -> attributes = attributes;

    return tr;
}


/*!
@brief Creates a new module instantiation.
@param [in] ports - This should be a list of ast_port_declaration if we are
using the new style of port declaration, or NULL if the port declarations are
contained within the module items list.
*/
ast_module_declaration * ast_new_module_declaration(
    ast_node_attributes * attributes,
    ast_identifier        identifier,
    ast_list            * parameters,
    ast_list            * ports,
    ast_list            * constructs
){
    ast_module_declaration * tr = ast_calloc(1,sizeof(ast_module_declaration));
    ast_set_meta_info(&(tr->meta));

    tr -> attributes = attributes;
    tr -> identifier = identifier;
    tr -> module_parameters = parameters;

    // Are we using the old or new style of port declaration?
    if(ports == NULL) {
        // Old style - search in internal module items for ports.
        tr -> module_ports      = ast_list_new();
    } else {
        // New style, just use the passed ports.
        tr -> module_ports      = ports;
    }
    
    tr -> always_blocks          = ast_list_new();
    tr -> continuous_assignments = ast_list_new();
    tr -> event_declarations     = ast_list_new();
    tr -> function_declarations  = ast_list_new();
    tr -> gate_instantiations    = ast_list_new();
    tr -> genvar_declarations    = ast_list_new();
    tr -> generate_blocks        = ast_list_new();
    tr -> initial_blocks         = ast_list_new();
    tr -> integer_declarations   = ast_list_new();
    tr -> local_parameters       = ast_list_new();
    tr -> module_instantiations  = ast_list_new();
    tr -> net_declarations       = ast_list_new();
    tr -> parameter_overrides    = ast_list_new();
    tr -> real_declarations      = ast_list_new();
    tr -> realtime_declarations  = ast_list_new();
    tr -> reg_declarations       = ast_list_new();
    tr -> specify_blocks         = ast_list_new();
    tr -> specparams             = ast_list_new();
    tr -> task_declarations      = ast_list_new();
    tr -> time_declarations      = ast_list_new();
    tr -> udp_instantiations     = ast_list_new();

    unsigned int i;

    for(i = 0; i < constructs -> items; i++)
    {
        ast_module_item * construct = ast_list_get(constructs, i);

        if(construct -> type == MOD_ITEM_PORT_DECLARATION && ports == NULL){
            // Only accept ports declared this way iff the ports argument to
            // this function is NULL, signifying the old style of port 
            // declaration.
            ast_list_append(tr -> module_ports, 
                            construct -> port_declaration);
        }
        else if(construct -> type == MOD_ITEM_GENERATED_INSTANTIATION){
            ast_list_append(tr -> generate_blocks,
                            construct -> generated_instantiation);
        } 
        else if(construct -> type == MOD_ITEM_PARAMETER_DECLARATION) {
            ast_list_append(tr -> module_parameters,
                            construct -> parameter_declaration);
        } 
        else if(construct -> type == MOD_ITEM_SPECIFY_BLOCK){
            ast_list_append(tr -> specify_blocks,
                            construct -> specify_block);
        } 
        else if(construct -> type == MOD_ITEM_SPECPARAM_DECLARATION){
            ast_list_append(tr -> specparams,
                            construct -> specparam_declaration);
        } 
        else if(construct -> type == MOD_ITEM_PARAMETER_OVERRIDE){
            ast_list_append(tr -> parameter_overrides,
                            construct -> parameter_override);
        } 
        else if(construct -> type == MOD_ITEM_CONTINOUS_ASSIGNMENT){
            ast_list_append(tr -> continuous_assignments,
                            construct -> continuous_assignment);
        } 
        else if(construct -> type == MOD_ITEM_GATE_INSTANTIATION){
            ast_list_append(tr -> gate_instantiations,
                            construct -> gate_instantiation);
        } 
        else if(construct -> type == MOD_ITEM_UDP_INSTANTIATION){
            ast_list_append(tr -> udp_instantiations,
                            construct -> udp_instantiation);
        } 
        else if(construct -> type == MOD_ITEM_MODULE_INSTANTIATION){
            ast_list_append(tr -> module_instantiations,
                            construct -> module_instantiation);
        } 
        else if(construct -> type == MOD_ITEM_INITIAL_CONSTRUCT){
            ast_list_append(tr -> initial_blocks,
                            construct -> initial_construct);
        } 
        else if(construct -> type == MOD_ITEM_ALWAYS_CONSTRUCT){
            ast_list_append(tr -> always_blocks,
                            construct -> always_construct);
        } 
        else if(construct -> type == MOD_ITEM_NET_DECLARATION){
            tr -> net_declarations = ast_list_concat(
                tr -> net_declarations,
                ast_new_net_declaration(construct -> net_declaration));
        } 
        else if(construct -> type == MOD_ITEM_REG_DECLARATION){
            tr -> reg_declarations = ast_list_concat(
                tr -> reg_declarations,
                ast_new_reg_declaration(construct -> reg_declaration));
        } 
        else if(construct -> type == MOD_ITEM_INTEGER_DECLARATION){
            tr -> integer_declarations = ast_list_concat(
                tr -> integer_declarations,
                ast_new_var_declaration(construct -> integer_declaration));
        } 
        else if(construct -> type == MOD_ITEM_REAL_DECLARATION){
            tr -> real_declarations = ast_list_concat(
                tr -> real_declarations,
                ast_new_var_declaration(construct -> real_declaration));
        } 
        else if(construct -> type == MOD_ITEM_TIME_DECLARATION){
            tr -> time_declarations = ast_list_concat(
                tr -> time_declarations,
                ast_new_var_declaration(construct -> time_declaration));
        } 
        else if(construct -> type == MOD_ITEM_REALTIME_DECLARATION){
            tr -> realtime_declarations = ast_list_concat(
                tr -> realtime_declarations,
                ast_new_var_declaration(construct -> realtime_declaration));
        } 
        else if(construct -> type == MOD_ITEM_EVENT_DECLARATION){
            tr -> event_declarations = ast_list_concat(
                tr -> event_declarations,
                ast_new_var_declaration(construct -> event_declaration));
        } 
        else if(construct -> type == MOD_ITEM_GENVAR_DECLARATION){
            tr -> genvar_declarations = ast_list_concat(
                tr -> genvar_declarations,
                ast_new_var_declaration(construct -> genvar_declaration));
        } 
        else if(construct -> type == MOD_ITEM_TASK_DECLARATION){
            ast_list_append(tr -> task_declarations,
                            construct -> task_declaration);
        } 
        else if(construct -> type == MOD_ITEM_FUNCTION_DECLARATION){
            ast_list_append(tr -> function_declarations,
                            construct -> function_declaration);
        } 
        else
        {
            printf("ERROR: Unsupported module construct type: %d\n",
                construct -> type);
            assert(0); // Fail out because this should *never* happen
        }
    }

    return tr;
}

//! Creates and returns a new source item representation.
ast_source_item * ast_new_source_item(ast_source_item_type type){
    ast_source_item * tr = ast_calloc(1,sizeof(ast_source_item));
    ast_set_meta_info(&(tr->meta));

    tr -> type = type;

    return tr;
}


/*!
@brief Simply returns the fully qualified representation of an identifier as
a string.
@details Where the identifier is "simple" or a system id, then the identifier
will just be returned as a character array. Where it is a hierarchical
idenifier, then a dot separated string of all identifiers in the hierarchy
will be returned.
@param [in] id - The identifier object to return a string representation of.
@returns A copy of the identifiers full name, as a null terminated character
array.
*/
char * ast_identifier_tostring(ast_identifier id)
{
    char * tr = ast_strdup(id -> identifier);   
    ast_identifier walker = id;

    while(walker -> next != NULL)
    {
        walker = walker -> next;

        size_t len = strlen(walker -> identifier)+1 + strlen(tr);
        tr = realloc(tr,len);
        strcat(tr, walker -> identifier);
    }
    return tr;
}

/*!
@brief Acts like strcmp but works on ast identifiers.
*/
int ast_identifier_cmp(
    ast_identifier a,
    ast_identifier b
){
    char * s1 = ast_identifier_tostring(a);
    char * s2 = ast_identifier_tostring(b);

    int result = strcmp(s1,s2);

    return result;
}

ast_identifier ast_new_identifier(
    char         * identifier, 
    unsigned int   from_line  
){
    ast_identifier tr = ast_calloc(1,sizeof(struct ast_identifier_t));
    ast_set_meta_info(&(tr->meta));
    
    tr -> identifier = ast_strdup(identifier);
    tr -> from_line = from_line;
    tr -> type = ID_UNKNOWN;
    tr -> next = NULL;
    tr -> range_or_idx = ID_HAS_NONE;

    return tr;
}

ast_identifier ast_new_system_identifier(
    char         * identifier,  //!< String text of the identifier.
    unsigned int   from_line    //!< THe line the idenifier came from.
){
    ast_identifier tr = ast_new_identifier(identifier,from_line);
    ast_set_meta_info(&(tr->meta));
    
    tr -> is_system = AST_TRUE;

    return tr;
}

ast_identifier ast_append_identifier(
    ast_identifier parent,
    ast_identifier child
){
    ast_identifier tr = parent;
    parent -> next = child;
    return tr;
}

void ast_identifier_set_range(
    ast_identifier    id,
    ast_range       * range
){
    id -> range = range;
    id -> range_or_idx = ID_HAS_RANGE;
}

void ast_identifier_set_index(
    ast_identifier    id,
    ast_expression  * index 
){
    id -> index = index;
    id -> range_or_idx = ID_HAS_INDEX;
}


/*!
@brief Creates and returns a new configuration rule statment node.
*/
ast_config_rule_statement * ast_new_config_rule_statement(
    ast_boolean    is_default,
    ast_identifier clause_1,    //!< The first grammar clause.
    ast_identifier clause_2     //!< The second grammar clause.
){
    ast_config_rule_statement * tr =
        ast_calloc(1,sizeof(ast_config_rule_statement));

    tr -> is_default = is_default;
    tr -> clause_1 = clause_1;
    tr -> clause_2 = clause_2;

    return tr;
}

ast_config_declaration * ast_new_config_declaration(
    ast_identifier  identifier,
    ast_identifier  design_statement,
    ast_list      * rule_statements
){
    ast_config_declaration * tr = ast_calloc(1,sizeof(ast_config_declaration));
    ast_set_meta_info(&(tr->meta));

    tr -> identifier = identifier;
    tr -> design_statement = design_statement;
    tr -> rule_statements = rule_statements;

    return tr;
}

/*!
@brief Creates a new library declaration node.
*/
ast_library_declaration * ast_new_library_declaration(
    ast_identifier  identifier,
    ast_list      * file_paths,
    ast_list      * incdirs
){
    ast_library_declaration * tr =
            ast_calloc(1,sizeof(ast_library_declaration));
    
    tr -> identifier = identifier;
    tr -> file_paths = file_paths;
    tr -> incdirs    = incdirs;
    
    return tr;
}

//! Creates and returns a new library description object.
ast_library_descriptions * ast_new_library_description(
    ast_library_item_type type
){
    ast_library_descriptions * tr = 
                ast_calloc(1,sizeof(ast_library_descriptions));
    ast_set_meta_info(&(tr->meta));

    tr -> type = type;

    return tr;
}


/*!
@brief Creates a new number representation object.
@todo Implement proper representation converstion.
*/
ast_number * ast_new_number(
    ast_number_base base,   //!< What is the base of the number.
    ast_number_representation representation,   //!< How to interepret digits.
    char  * digits  //!< The string token representing the number.
){
    ast_number * tr = ast_calloc(1,sizeof(ast_number));
    ast_set_meta_info(&(tr->meta));

    tr -> base = base;
    tr -> representation = representation;
    tr -> as_bits = digits;

    return tr;
}

/*!
@brief A utility function for converting an ast number into a string.
@param [in] n - The number to turn into a string.
*/
char * ast_number_tostring(
    ast_number * n
){
    assert(n!=NULL);
    char * tr;

    ast_number_representation rep = n -> representation;

    switch(rep)
    {
        case REP_BITS:
            tr = n -> as_bits;
            break;
        case REP_INTEGER:
            tr = calloc(11,sizeof(char));
            sprintf(tr, "%d", n-> as_int);
            break;
        case REP_FLOAT:
            tr = calloc(21,sizeof(char));
            sprintf(tr, "%20f", n -> as_float);
            break;
        default:
            tr = "NULL";
            break;
    }

    return tr;
}


// ----------------------------------------------------------------------------


/*!
@brief Global source tree object, used to store parsed constructs.
@details This is a global variable, initialised prior to calling
the verilog_parse function, into which all objects the parser finds are
stored.
*/
verilog_source_tree * yy_verilog_source_tree;

/*!
@brief Creates and returns a new, empty source tree.
@details This should be called ahead of parsing anything, so we will
have an object to put parsed constructs into.
*/
verilog_source_tree * verilog_new_source_tree()
{
    verilog_source_tree * tr = ast_calloc(1,sizeof(verilog_source_tree));

    tr -> modules       =   ast_list_new();
    tr -> primitives    =   ast_list_new();
    tr -> configs       =   ast_list_new();
    tr -> libraries     =   ast_list_new();

    return tr;
}

/*!
@brief Releases a source tree object from memory.
@param [in] tofree - The source tree to be free'd
*/
void verilog_free_source_tree(
    verilog_source_tree * tofree
){
    printf("ERROR: Function not implemented. Source tree at %p not freed.\n", tofree);
}
