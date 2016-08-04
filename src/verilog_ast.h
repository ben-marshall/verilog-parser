/*!
@file verilog_ast.h
@brief Contains Declarations of datastructures and functions which represent
       and operate on the Verilog Abstract Syntax Tree (AST)
*/

#include <stdarg.h>
#include <stdlib.h>
#include <string.h>

#include "verilog_ast_common.h"

#ifndef VERILOG_AST_H
#define VERILOG_AST_H

extern int yylineno;

//! Forward declare. Defines the core node type for the AST.
typedef struct ast_node_t ast_node;

/*! 
@brief Typedef to make it easier to change into a proper structure later.
@note The pointer is already included in the type.
*/
typedef struct ast_identifier_t * ast_identifier;

//! Placeholder until this is implemented properly.
typedef struct ast_concatenation_t ast_concatenation;
 
//! Expression type over a struct
typedef struct ast_expression_t ast_expression;
//! Expression type over a struct
typedef struct ast_function_call_t ast_function_call;

//! An item within a module. Duh.
typedef struct ast_module_item_t ast_module_item;
    
//! Stores different Operators.
typedef enum ast_operator_e{
    OPERATOR_STAR    , //!<
    OPERATOR_PLUS    , //!<
    OPERATOR_MINUS   , //!<
    OPERATOR_ASL     , //!< Arithmetic shift left
    OPERATOR_ASR     , //!< Arithmetic shift right
    OPERATOR_LSL     , //!< logical shift left
    OPERATOR_LSR     , //!< logical shift right
    OPERATOR_DIV     , //!< divide
    OPERATOR_POW     , //!< pow
    OPERATOR_MOD     , //!< mod
    OPERATOR_GTE     , //!< greater than or equal to
    OPERATOR_LTE     , //!<
    OPERATOR_GT      , //!<
    OPERATOR_LT      , //!<
    OPERATOR_L_NEG   , //!<
    OPERATOR_L_AND   , //!<
    OPERATOR_L_OR    , //!<
    OPERATOR_C_EQ    , //!<
    OPERATOR_L_EQ    , //!<
    OPERATOR_C_NEQ   , //!<
    OPERATOR_L_NEQ   , //!<
    OPERATOR_B_NEG   , //!<
    OPERATOR_B_AND   , //!<
    OPERATOR_B_OR    , //!<
    OPERATOR_B_XOR   , //!<
    OPERATOR_B_EQU   , //!<
    OPERATOR_B_NAND  , //!<
    OPERATOR_B_NOR   , //!<
    OPERATOR_TERNARY , //!<
    OPERATOR_NONE = 0
} ast_operator;

typedef char * ast_string       ;
//! A set of lvalue and corresponding assigned expressions
typedef struct ast_assignment_t ast_assignment;
//! A single lvalue=expression assignment.
typedef struct ast_single_assignment_t ast_single_assignment;
//! Generate block (of statements) type.
typedef struct ast_generate_block_t ast_generate_block;
typedef struct ast_delay3_t ast_delay3;
typedef struct ast_delay2_t ast_delay2;
typedef struct ast_delay_value_t ast_delay_value  ;
typedef struct ast_pull_strength_t ast_drive_strength;
typedef void * ast_macro_use    ;
typedef void * ast_minmax_exp   ;
//! Number data structure.
typedef struct ast_number_t ast_number ;
typedef struct ast_range_t ast_range ;
typedef struct ast_block_item_declaration_t ast_block_item_declaration;
typedef void * ast_tf_input_declaration;
typedef struct ast_statement_t ast_statement;
typedef struct ast_module_declaration_t ast_module_declaration;

//! Stores the values of booleans.
typedef enum  ast_boolean_e
{
    AST_TRUE=1,
    AST_FALSE=0
} ast_boolean;

//! Describes a rising or falling edge, or where none is specified.
typedef enum ast_edge_e{
    EDGE_POS,   //! Positive edge
    EDGE_NEG,   //! Negative edge
    EDGE_NONE,  //! Not edge triggered
    EDGE_ANY    //! Positive or negative edge.
} ast_edge;

//! Describes the direction of a port
typedef enum ast_port_direction_e{
    PORT_INPUT,     //!< Input port.
    PORT_OUTPUT,    //!< Output port.
    PORT_INOUT,     //!< Bi-directional port.
    PORT_NONE,  //!< Used for when we don't know at declaration time.
} ast_port_direction;

/*!
@defgroup ast-node-meta Meta Data
@{
@ingroup ast-construction
@brief Objects used to represent meta data about a particular construct.
*/

//! Refers to a source code file line number.
typedef int ast_line;
//! Refers to a source code file name.
typedef char * ast_file;

/*!
@brief Stores "meta" information and other tagging stuff about nodes.
*/
typedef struct ast_metadata_t{
    ast_line line;  //!< The line number the construct came from.
    ast_file file;  //!< The file the construct came from.
} ast_metadata;

/*! @} */

//-------------- Numbers ---------------------------------------

/*!
@defgroup ast-node-numbers Numbers
@{
@ingroup ast-construction
@brief Objects used to represent individual numbers.
*/

//! Base value of a number representation.
typedef enum ast_number_base_e{
    BASE_BINARY,
    BASE_OCTAL,
    BASE_DECIMAL,
    BASE_HEX
} ast_number_base;

//! How is the number represented?
typedef enum ast_number_representation_e{
    REP_BITS,       //!< For numbers specified per digit.
    REP_INTEGER,    //!< For "Integer" typed numbers"
    REP_FLOAT       //!< For "real" typed numbers.
} ast_number_representation;

/*!
@brief Stores the base, value and width (in bits) of a number.
*/
struct ast_number_t{
    ast_metadata    meta;   //!< Node metadata.
    unsigned int    width; //!< Width of the number in bits.
    ast_number_base base; //!< Hex, octal, binary, decimal.
    ast_number_representation   representation; //!< How is it expressed?
    union{
        char * as_bits;
        float  as_float;
        int    as_int;
    };
};

/*!
@brief Creates a new number representation object.
*/
ast_number * ast_new_number(
    ast_number_base base,   //!< What is the base of the number.
    ast_number_representation representation,   //!< How to interepret digits.
    char  * digits  //!< The string token representing the number.
);

/*!
@brief A utility function for converting an ast number into a string.
@param [in] n - The number to turn into a string.
*/
char * ast_number_tostring(
    ast_number * n
);


/*! @} */


//-------------- attributes ------------------------------------

/*!
@defgroup ast-node-attributes Attributes
@{
@ingroup ast-construction
@brief Describes attributes passed to modules, functions and expression
assignments.
*/

/*!
@brief Node data describing an attribute.
*/
typedef struct ast_node_attributes_t ast_node_attributes;
struct ast_node_attributes_t
{
    ast_metadata    meta;   //!< Node metadata.
    ast_identifier        attr_name;    //!< Name of the attribute
    ast_expression      * attr_value;   //!< Value of the attribute.

    ast_node_attributes * next;         //!< Next one in a linked list.
};


/*!
@brief Creates and returns as a pointer a new attribute descriptor.
@param [in] name - The name of the parameter/attribute.
@param [in] value - The value the attribute should take.
*/
ast_node_attributes * ast_new_attributes(
    ast_identifier name, 
    ast_expression * value
);

/*!
@brief Creates and returns a new attribute node with the specified value
       and name.
@param [inout] parent - Pointer to the node which represents the list of
                        attribute name,value pairs.
@param [in]    toadd  - The new attribute to add.
*/
void ast_append_attribute(ast_node_attributes * parent, 
                          ast_node_attributes * toadd);

/*! @} */
// -------------------------------- Concatenations ---------------------------

/*!
@defgroup ast-node-concatenations Concatenations
@{
@ingroup ast-construction
@brief Concatenations of expressions, l-values, variables, nets and
module paths.
*/

//! Describes the type of concatenation being dealt with.
typedef enum ast_concatenation_type_e
{
    CONCATENATION_EXPRESSION,           //!< A set of expressions concatenated
    CONCATENATION_CONSTANT_EXPRESSION,  //!< Constant expressions
    CONCATENATION_NET,                  //!< Net name concatenation (lvalue)
    CONCATENATION_VARIABLE,             //!< Variable name concatenation (lvalue)
    CONCATENATION_MODULE_PATH           //!< Module path concatenation.
} ast_concatenation_type;

//! Fully describes a concatenation in terms of type and data.
struct ast_concatenation_t{
    ast_metadata    meta;   //!< Node metadata.
    ast_concatenation_type   type;  //!< The type of concatenation
    ast_expression         * repeat;//!< The number of repetitions. Normally 1.
    ast_list               * items; //!< sequence of items.
};

/*!
@brief Creates a new AST concatenation element with the supplied type and
initial starting value.
@param [in] repeat - Used for replications or multiple_concatenation
@param [in] type - What sort of values are being concatenated?
@param [in] first_value - The first element of the concatentation.
@details Depending on the type supplied, the type of first_value
should be:
    - CONCATENATION_EXPRESSION          : ast_expression
    - CONCATENATION_CONSTANT_EXPRESSION : ast_expression
    - CONCATENATION_NET                 : ast_identifier
    - CONCATENATION_VARIABLE            : ast_identifer
    - CONCATENATION_MODULE_PATH         : ast_identifier
*/
ast_concatenation * ast_new_concatenation(ast_concatenation_type type,
                                          ast_expression * repeat,
                                          void * first_value);

/*!
@brief Creates and returns a new empty concatenation of the specified type.
@param [in] type - What sort of values are being concatenated?
*/
ast_concatenation * ast_new_empty_concatenation(ast_concatenation_type type);

/*!
@brief Adds a new data element on to the *front* of a concatenation.
@param [inout] element - THe concantenation being extended,
@param [in] repeat - Is the concatenation repeated?
@param [in] data - The item to add to the concatenation sequence.
*/
void                ast_extend_concatenation(ast_concatenation * element,
                                             ast_expression * repeat,
                                             void * data);


/*! @} */
// -------------------------------- L Value ------------------------

/*!
@defgroup ast-node-lvalues L-Values
@{
@ingroup ast-construction
@brief Represents the class of values which represent the left hand term
of an assignment.
*/

/*!
@brief Identifies the kind of LValue the @ref ast_lvalue structure holds.
*/
typedef enum ast_lvalue_type_e
{
    SPECPARAM_ID,
    PARAM_ID,
    NET_IDENTIFIER,     //!< Identifies a wire/reg
    VAR_IDENTIFIER,     //!< Identifies a variable
    GENVAR_IDENTIFIER,  //!< Generateor variable.
    NET_CONCATENATION,  //!< Concatenation of net identifiers
    VAR_CONCATENATION   //!< Concatenation of variable identifiers.
} ast_lvalue_type;

/*!
@brief Storage for the data describing an assignment L Value.
*/
typedef union ast_lvalue_data_u
{
    ast_identifier      identifier;     //!< Identifier value.
    ast_concatenation * concatenation;  //!< Concatenation list.
} ast_lvalue_data ;

/*!
@brief Stores and describes an expression l value.
*/
typedef struct ast_lvalue_t
{
    ast_metadata    meta;   //!< Node metadata.
    ast_lvalue_data data; //!< The identifier or concattenation being assigned.
    ast_lvalue_type type; //!< The type of the L Value assignment.
} ast_lvalue;

/*!
@brief Creates and returns a new @ref ast_lvalue pointer, with the data type
       being a single identifier of either @ref NET_IDENTIFIER or
       @ref VAR_IDENTIFIER.
*/
ast_lvalue * ast_new_lvalue_id(ast_lvalue_type type, ast_identifier id);

/*!
@brief Creates and returns a new @ref ast_lvalue pointer, with the data type
       being a concatenation holder of either @ref NET_CONCATENATION or
       @ref VAR_CONCATENATION.
*/
ast_lvalue * ast_new_lvalue_concat(ast_lvalue_type type, ast_concatenation*id);

/*! @} */
// -------------------------------- Function Calls ---------------------------

/*!
@defgroup ast-node-function-calls Function Calls
@{
@ingroup ast-construction
@brief Represents a call to a system or user function. Note this is
destinct from a function declaration.
*/
/*!

@brief describes a single call to a function, constant function, or
system fucntion.
*/
struct ast_function_call_t {
    ast_metadata    meta;   //!< Node metadata.
    ast_boolean         constant;   //!< Constant function call?
    ast_boolean         system;     //!< System function call?
    ast_identifier      function;   //!< Function identifier
    ast_list        *   arguments;  //!< Linked list of arguments.
    ast_node_attributes * attributes;
};


/*!
@brief Creates and returns a new node representing a function call.
@param [in] arguments - list of elements of type ast_expression
representing the various parameters to the function. If the function has
no arguments, then it is an empty list, not NULL.
@param [in] id - Function identifier / name
@param [in] constant - Does this function return a constant value?
@param [in] system - Is this a system function?
@param [in] attr - Attributes for vendor specific tool features.
*/
ast_function_call * ast_new_function_call(ast_identifier  id,
                                          ast_boolean     constant,
                                          ast_boolean     system,
                                          ast_node_attributes * attr,
                                          ast_list      * arguments);


/*! @} */
// -------------------------------- Primaries ----------------------

/*!
@defgroup ast-node-expression-primaries Expression Primaries
@{
@ingroup ast-node-expressions
@brief Expresses primary terms of expressions. These can be sub-expressions,
numbers, identifiers etc.
*/

/*!
@brief Describes the kind of expression primary being represented, and hence
the sort of expression we are dealing with.
*/
typedef enum ast_primary_type_e
{
    CONSTANT_PRIMARY,
    PRIMARY,
    MODULE_PATH_PRIMARY
} ast_primary_type;


//! The kind of production the expression primary holds.
typedef enum ast_primary_value_type_e
{
    PRIMARY_NUMBER,
    PRIMARY_IDENTIFIER,
    PRIMARY_CONCATENATION,
    PRIMARY_FUNCTION_CALL,
    PRIMARY_MINMAX_EXP,
    PRIMARY_MACRO_USAGE    
} ast_primary_value_type;

//! The expression primary can produce several different sub-expressions:
typedef union ast_primary_value_e
{
    ast_number        * number;         //!< A single constant number
    ast_identifier      identifier;     //!< Net or variable identifier.
    ast_concatenation * concatenation;  //!< Concatenation of expressions.
    ast_function_call * function_call;  //!< Call to a function.
    ast_expression    * minmax;
    ast_macro_use       macro;          //!< A MACRO expansion.
    char              * string;
} ast_primary_value;

/*!
@brief Stores the type and value of an AST primary expression.
@details The following AST_PRIMARY_VALUE_TYPE values map to the following
ast_primary_value_members:

  - PRIMARY_NUMBER          : use value.number       
  - PRIMARY_IDENTIFIER      : use value.identifier
  - PRIMARY_CONCATENATION   : use value.concatenation
  - PRIMARY_FUNCTION_CALL   : use value.function_call
  - PRIMARY_MINMAX_EXP      : use value.minmax
  - PRIMARY_MACRO_USAGE     : use value.macro        

*/
typedef struct ast_primary_t
{
    ast_metadata    meta;   //!< Node metadata.
    ast_primary_type        primary_type;   //!< @see ast_primary_type
    ast_primary_value_type  value_type;     //!< @see ast_primary_value_type
    ast_primary_value       value;          //!< @see ast_primary_value
} ast_primary;


/*!
@brief A utility function for converting an ast expression primaries back into
a string representation.
@param [in] p - The expression primary to turn into a string.
*/
char * ast_primary_tostring(
    ast_primary * p
);

/*!
@brief Creates a new ast primary which is part of a constant expression tree
       with the supplied type and value.
@param [in] type - Self explanatory
*/
ast_primary * ast_new_constant_primary(ast_primary_value_type type);

/*!
@brief Creates a new AST primary wrapper around a function call.
@param [in] call - The AST node representing a function call.
*/
ast_primary * ast_new_primary_function_call(ast_function_call * call);

/*!
@brief Creates a new ast primary which is part of an expression tree
       with the supplied type and value.
@param [in] type - Self explanatory
*/
ast_primary * ast_new_primary(ast_primary_value_type type);

/*!
@brief Creates a new ast primary which is part of a constant expression tree
       with the supplied type and value.
@param [in] type - Self explanatory
*/
ast_primary * ast_new_module_path_primary(ast_primary_value_type type);

/*! @} */
// -------------------------------- Expressions --------------------

/*!
@defgroup ast-node-expressions Expressions
@{
@ingroup ast-construction
@brief Super-group for data-structures representing the kinds of 
expressions that Verilog has.
*/

//! Describes the kind of expression a node contains.
typedef enum ast_expression_type_e
{
    PRIMARY_EXPRESSION,                 //!< A straight value
    UNARY_EXPRESSION,                   //!< A unary op: "~bits" for example.
    BINARY_EXPRESSION,                  //!< The "normal" expression
    RANGE_EXPRESSION_UP_DOWN,           //!< Bit range expression
    RANGE_EXPRESSION_INDEX,             //!< Bit index expression
    MINTYPMAX_EXPRESSION,               //!< Minimum typical maximum
    CONDITIONAL_EXPRESSION,             //!< Conditional expression
    MODULE_PATH_PRIMARY_EXPRESSION,
    MODULE_PATH_BINARY_EXPRESSION,
    MODULE_PATH_UNARY_EXPRESSION,
    MODULE_PATH_CONDITIONAL_EXPRESSION,
    MODULE_PATH_MINTYPMAX_EXPRESSION,
    STRING_EXPRESSION                 //!< Just a normal string. No operations.
} ast_expression_type;


//! Returns the string representation of an operator;
char * ast_operator_tostring(ast_operator op);

/*! 
@brief Storage type for an entire expression / subexpression tree.
@details Each expression node has left and right children (unless it is a
leaf) and an operation. The idea being that if the children are primaries,
then we extract their value, perform the operation described in this node,
and return up the expression tree, or recurse into a child expression as
appropriate.
@todo This part of the tree (and sub parts) is currently quite messy.
When I come to actually using this for something practicle, I may end up
re-writing it. That will be post the first "release" though.
*/
struct ast_expression_t
{
    ast_metadata    meta;   //!< Node metadata.
    ast_expression_type type;           //!< What sort of expression is this?
    ast_node_attributes * attributes;   //!< Additional expression attributes.
    ast_expression * left;              //!< LHS of operation
    ast_expression * right;             //!< RHS of operation
    ast_expression * aux;               //!< Optional auxiliary/predicate.
    ast_primary    * primary;           //!< Valid IFF type == PRIMARY_EXPRESSION.
    ast_operator     operation;         //!< What are we doing?
    ast_boolean      constant;          //!< True iff constant_expression.
    ast_string       string;            //!< The string constant. Valid IFF type == STRING_EXPRESSION.
};

/*!
@brief A utility function for converting an ast expression tree back into
a string representation.
@param [in] exp - The expression to turn into a string.
*/
char * ast_expression_tostring(
    ast_expression * exp
);

/*!
@brief Creates and returns a new expression primary.
@details This is simply an expression instance wrapped around a
primary instance for the purposes of mirroring the expression tree gramamr.
Whether or not the expression is constant is denoted by the type member
of the passed primary.
@param [in] p - The primary to insert into the expression.
*/
ast_expression * ast_new_expression_primary(ast_primary * p);

/*!
@brief Creates a new binary infix expression with the supplied operands.
@param [in] left - LHS of the infix operation.
@param [in] right - RHS of the infix operation.
@param [in] operation - What do we do?!
@param [in] attr - Attributes applied to the expression.
@param [in] constant - Is this a constant expression we can simplify?
*/
ast_expression * ast_new_binary_expression(ast_expression * left,
                                           ast_expression * right,
                                           ast_operator     operation,
                                           ast_node_attributes * attr,
                                           ast_boolean      constant);

/*!
@brief Creates a new unary expression with the supplied operation.
@param [in] operand - The thing to operate on.
@param [in] operation - What do we do?!
@param [in] attr - Expression attributes.
@param [in] constant - Is this a constant expression we can simplify?
*/
ast_expression * ast_new_unary_expression(ast_primary    * operand,
                                          ast_operator     operation,
                                          ast_node_attributes * attr,
                                          ast_boolean       constant);

/*!
@brief Creates a new range expression with the supplied operands.
@param [in] left - The Upper range of the expression
@param [in] right - The lower range of the expression.
@details
For example, when specifying a simple bus in verilog:

@code
wire [31:0] bus_data;
@endcode

Then the `31` would go into left, and the `0` into the right.
*/
ast_expression * ast_new_range_expression(ast_expression * left,
                                          ast_expression * right);

/*!
@brief Creates a new range index expression with the supplied operands.
@param [in] left - The single expression index into an array.
@details Used to represent code like...

@code
wire [32:0] adder_result;
assign overflow = adder_result[32];
@endcode

Here, accessing the 32nd bit of `adder_result` is an index expression.
*/
ast_expression * ast_new_index_expression(ast_expression * left);

/*!
@brief Creates a new string expression.
@param [in] string - The string. Duh.
*/
ast_expression * ast_new_string_expression(ast_string string);


/*!
@brief Creates a new conditional expression node. 
@param [in] condition - Decides which result expression is presented.
@param [in] if_true - executed if condition == true (!0)
@param [in] if_false - executed if condition == false (0).
@param [in] attr - Attributes
@note The condition is stored in the aux member, if_true in left, and if_false
on the right.
@details Can be used to represent ternary operations:

@code
assign stall = mem_error || mem_stall ? 1'b0 : global_stall;
@endcode

*/
ast_expression * ast_new_conditional_expression(ast_expression * condition,
                                                ast_expression * if_true,
                                                ast_expression * if_false,
                                                ast_node_attributes * attr);

/*!
@brief Creates a new (min,typical,maximum) expression.
@details If the mintypmax expression only specifies a typical value,
then the min and max arguments should be NULL, and only typ set.
@param [in] min - Minimum value in the distribution.
@param [in] typ - Typical / average.
@param [in] max - Maximum value in the distribution.
*/
ast_expression * ast_new_mintypmax_expression(ast_expression * min,
                                              ast_expression * typ,
                                              ast_expression * max);

/*! @} */
// -------------------------------- Specify Blocks ---------------------------

/*!
@defgroup ast-node-path-declaration Path Declarations
@{
@ingroup ast-construction
@brief Describes construction of path declarations and delay specifiers.
*/

//! Describes the type of path being declared.
typedef enum ast_path_declaration_type_e{
    SIMPLE_PARALLEL_PATH,
    SIMPLE_FULL_PATH,
    EDGE_SENSITIVE_PARALLEL_PATH,
    EDGE_SENSITIVE_FULL_PATH,
    STATE_DEPENDENT_PARALLEL_PATH,
    STATE_DEPENDENT_FULL_PATH,
    STATE_DEPENDENT_EDGE_PARALLEL_PATH,
    STATE_DEPENDENT_EDGE_FULL_PATH,
} ast_path_declaration_type;


//! Describes the declaration of a path.
typedef struct ast_simple_parallel_path_declaration_t{
    ast_metadata    meta;   //!< Node metadata.
    ast_identifier      input_terminal;
    ast_operator        polarity;
    ast_identifier      output_terminal;
    ast_list        *   delay_value;
} ast_simple_parallel_path_declaration;


//! Describes the declaration of a path.
typedef struct ast_simple_full_path_declaration_t{
    ast_metadata    meta;   //!< Node metadata.
    ast_list        *   input_terminals;
    ast_operator        polarity;
    ast_list        *   output_terminals;
    ast_list        *   delay_value;
} ast_simple_full_path_declaration;


//! Describes a single edge sensitive path declaration
typedef struct ast_edge_sensitive_parallel_path_declaration_t {
    ast_metadata    meta;   //!< Node metadata.
    ast_edge            edge;               //!< edge_identifier
    ast_identifier      input_terminal;     //!< specify_input_terminal_descriptor
    ast_operator        polarity;           //!< polarity_operator
    ast_identifier      output_terminal;    //!< specify_output_terminal_descriptor
    ast_expression  *   data_source;        //!< data_source_expression
    ast_list        *   delay_value;        //!< path_delay_value
} ast_edge_sensitive_parallel_path_declaration;

//! Describes a parallel edge sensitive path declaration
typedef struct ast_edge_sensitive_full_path_declaration_t {
    ast_metadata    meta;   //!< Node metadata.
    ast_edge            edge;               //!< edge_identifier
    ast_list        *   input_terminal;     //!< list_of_path_inputs
    ast_operator        polarity;           //!< polarity_operator
    ast_list        *   output_terminal;    //!< list_of_path_outputs
    ast_expression  *   data_source;        //!< data_source_expression
    ast_list        *   delay_value;        //!< path_delay_value
} ast_edge_sensitive_full_path_declaration;

//! Struct which holds the type and data of a path declaration.
typedef struct ast_path_declaration_t{
    ast_metadata    meta;   //!< Node metadata.
    ast_path_declaration_type   type;
    ast_expression        * state_expression; //!< Used iff type == state_dependent_*
    union {
        ast_simple_parallel_path_declaration         * parallel;
        ast_simple_full_path_declaration             * full;
        ast_edge_sensitive_parallel_path_declaration * es_parallel;
        ast_edge_sensitive_full_path_declaration     * es_full;
    };
} ast_path_declaration;

/*!
@brief Creates and returns a new path declaration type. Expects that the data
be filled in manually;
*/
ast_path_declaration * ast_new_path_declaration(ast_path_declaration_type type);

/*!
@brief Creates and returns a pointer to a new simple parallel path declaration.
*/
ast_simple_parallel_path_declaration * ast_new_simple_parallel_path_declaration
(
    ast_identifier      input_terminal,
    ast_operator        polarity,
    ast_identifier      output_terminal,
    ast_list        *   delay_value
);


/*!
@brief Creates and returns a pointer to a new simple full path declaration.
*/
ast_simple_full_path_declaration * ast_new_simple_full_path_declaration
(
    ast_list        *   input_terminals,
    ast_operator        polarity,
    ast_list        *   output_terminals,
    ast_list        *   delay_value
);

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
);

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
); 


/*! @} */

// -------------------------------- Task Enable Statements -------------------

/*!
@defgroup ast-node-task-enable-statements Task Enable Statements
@{
@ingroup ast-node-procedural
@brief Describes task enable statements.
*/

//! Fully describes a task enable statement.
typedef struct ast_task_enable_statement_t{
    ast_metadata    meta;   //!< Node metadata.
    ast_list        * expressions;  //!< Arguments to the task
    ast_identifier    identifier;   //!< Task identifier.
    ast_boolean       is_system;    //!< Is this a system task?
} ast_task_enable_statement;

/*!
@brief creates and returns a pointer to a new task-enable statement.
*/
ast_task_enable_statement * ast_new_task_enable_statement(
    ast_list        * expressions,
    ast_identifier    identifier, 
    ast_boolean       is_system   
);

/*! @} */

// -------------------------------- Loop Statements --------------------------

/*!
@defgroup ast-node-loop-statements Loop Statements
@{
@ingroup ast-node-procedural
@brief Describes for and while loop representation.
*/

//! Describes the different syntactic methods of looping.
typedef enum ast_loop_type_e{
    LOOP_FOREVER,
    LOOP_REPEAT,
    LOOP_WHILE,
    LOOP_FOR,
    LOOP_GENERATE
} ast_loop_type;

//! Fully describes a single loop statement.
typedef struct ast_loop_statement_t{
    ast_metadata    meta;   //!< Node metadata.
    ast_loop_type   type;            //!< The type of loop
    union{
        ast_statement * inner_statement; //!< Loop body.
        ast_list      * generate_items; //!< IFF type == LOOP_GENERATE;
    };
    ast_expression * condition;      //!< Condition on which the loop runs.
    ast_single_assignment * initial;       //!< Initial condition for for loops.
    ast_single_assignment * modify;        //!< Modification assignment for for loop.
} ast_loop_statement;


/*!
@brief Creates and returns a new forever loop statement.
@param inner_statement - Pointer to the inner body of statements which
make upt the loop body.
*/
ast_loop_statement * ast_new_forever_loop_statement(
    ast_statement * inner_statement
);

/*!
@brief Creates and returns a new for loop statement.
@param inner_statements - Pointer to the inner body of statements which
make up the loop body.
@param initial_condition - Assignement which sets up the initial condition
of the iterator.
@param modify_assignment - How the iterator variable changes with each
loop iteration.
@param continue_condition - Expression which governs whether the loop should
continue or break.
*/
ast_loop_statement * ast_new_for_loop_statement(
    ast_statement  * inner_statements,
    ast_single_assignment * initial_condition,
    ast_single_assignment * modify_assignment,
    ast_expression * continue_condition
);

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
);

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
);

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
);


/*! @} */

// -------------------------------- Case Statements --------------------------

/*!
@defgroup ast-node-case-statements Case Statements
@{
@ingroup ast-node-procedural
@brief 
*/

//! Records the three different types of case statement Verilog has.
typedef enum ast_case_statement_type_e{
    CASE,
    CASEX,
    CASEZ
} ast_case_statement_type;

//! Describes a single exeuctable item in a case statement.
typedef struct ast_case_item_t{
    ast_metadata    meta;   //!< Node metadata.
    ast_list    * conditions; //!< A list of condtions, one must be met.
    ast_statement * body;     //!< What to execute if the condition is met.
    ast_boolean     is_default; //!< This is the default item.
} ast_case_item;

//! Describes the top level of a case statement in terms of its items.
typedef struct ast_case_statement_t{
    ast_metadata    meta;   //!< Node metadata.
    ast_expression  * expression;   //!< The thing to be evaluated.
    ast_list        * cases;        //!< Statements, conditionally run.
    ast_statement   * default_item; //!< Default IFF no item matches.
    ast_case_statement_type type;   //!< CASE, CASEX or CASEZ.
    ast_boolean       is_function;  //!< Is this a function_case_statement?
} ast_case_statement;

/*!
@brief Create and return a new item in a cast statement.
@param conditions - The conditions on which the item is executed.
@param body - Executes when any of the conditions are met.
*/
ast_case_item * ast_new_case_item(ast_list      * conditions,
                                  ast_statement * body);


/*!
@brief Creates and returns a new case statement.
@param expression - The expression evaluated to select a case.
@param cases - list of possible cases.
*/
ast_case_statement * ast_new_case_statement(ast_expression * expression,
                                            ast_list       * cases,
                                            ast_case_statement_type type);


/*! @} */

// -------------------------------- IF Else Statements -----------------------

/*!
@defgroup ast-node-if-else If Else Statements
@{
@ingroup ast-node-procedural
@brief 
*/

//! Describes a single if-then-do statement.
typedef struct ast_conditional_statement_t {
    ast_metadata    meta;   //!< Node metadata.
    ast_statement   * statement; //!< What should be executed.
    ast_expression  * condition; //!< Execute iff true.
} ast_conditional_statement;

//! Describes a complete set of if-elseif-else statements
typedef struct ast_if_else_t{
    ast_metadata    meta;   //!< Node metadata.
    ast_list * conditional_statements; //!< Ordered list of if-elseifs
    ast_statement * else_condition;    //!< Execute iff no conditonals are met.
} ast_if_else;


/*!
@brief Creates and returns a new conditional statement.
@param statement - what to run if the condition holds true.
@param condtion  - the condition on which statement is run.
*/
ast_conditional_statement * ast_new_conditional_statement(
    ast_statement * statement,
    ast_expression * condition
);

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
);


/*!
@brief Adds an additional conditional (ha..) to an existing if-else
statement.
@param conditional_statements - the existing if-else tree.
@param new_statement - The new statement to add at the end of the existing
if-then conditions, but before any else_condtion.
*/
void  ast_extend_if_else(
    ast_if_else                 * conditional_statements,
    ast_list                    * new_statement
);


/*! @} */

// -------------------------------- Timing Control Statements ----------------

/*!
@defgroup ast-node-timing-control Timing Control Statements
@{
@ingroup ast-construction
@brief 
*/

//! Describes a single wait statement.
typedef struct ast_wait_statement_t{
    ast_metadata    meta;   //!< Node metadata.
    ast_expression * expression; //!< How long to wait for.
    ast_statement  * statement;  //!< What to execute after waiting.
} ast_wait_statement;

typedef enum ast_event_expression_type_e{
    EVENT_EXPRESSION,   //!< Goes to a single expression
    EVENT_POSEDGE,      //!< on posedge
    EVENT_NEGEDGE,      //!< on negedge
    EVENT_SEQUENCE      //!< Covers event_expression COMMA event_expression
} ast_event_expression_type;

//! Describes a single event expression
typedef struct ast_event_expression_t ast_event_expression;
    ast_metadata    meta;   //!< Node metadata.
struct ast_event_expression_t {
    ast_event_expression_type type;
    union{
        ast_expression * expression; //!< Single event expressions.
        ast_list       * sequence;   //!< Used for CSV lists of events
    };
};

//! Whether an event control struct contains a list of triggers, no triggers
// or triggers on anything.
typedef enum ast_event_control_type_e{
    EVENT_CTRL_NONE,
    EVENT_CTRL_ANY,
    EVENT_CTRL_TRIGGERS

} ast_event_control_type;

//! Describes the type of event triggers.
typedef struct ast_event_control_t{
    ast_metadata    meta;   //!< Node metadata.
    ast_event_control_type type;
    ast_event_expression * expression;
} ast_event_control;

//! What sort of procedural timing control statement is this?
typedef enum ast_timing_control_statement_type_e{
    TIMING_CTRL_DELAY_CONTROL,
    TIMING_CTRL_EVENT_CONTROL,
    TIMING_CTRL_EVENT_CONTROL_REPEAT
} ast_timing_control_statement_type;

//! Denotes whether a delay control expression is a single value or a range
typedef enum ast_delay_ctrl_type_e{
    DELAY_CTRL_VALUE,
    DELAY_CTRL_MINTYPMAX
} ast_delay_ctrl_type;

//! Describes a single delay control statement
typedef struct ast_delay_ctrl_t{
    ast_metadata    meta;   //!< Node metadata.
    ast_delay_ctrl_type type;
    union{
        ast_delay_value * value;
        ast_expression  * mintypmax;
    };
} ast_delay_ctrl;

//! Describes a single procedural timing control statement.
typedef struct ast_timing_control_statement_t{
    ast_metadata    meta;   //!< Node metadata.
    ast_timing_control_statement_type type;
    union{
        ast_delay_ctrl    * delay;
        ast_event_control * event_ctrl;
    };
    ast_expression    * repeat;     //! NULL unless part of repeat statement.
    ast_statement     * statement;  //! What to execute after the control.
} ast_timing_control_statement;

/*!
@brief Creates and returns a new wait statement.
*/
ast_wait_statement * ast_new_wait_statement(
    ast_expression * wait_for,
    ast_statement  * statement
);

/*!
@brief Creates a new event expression node
@param trigger_edge - the edge on which the trigger is activated.
@param expression - the expression to monitor the waveforms of.
*/
ast_event_expression * ast_new_event_expression(
    ast_edge trigger_edge,
    ast_expression * expression
);

/*!
@brief Creates a new event expression node, which is itself a sequence of
sub-expressions.
*/
ast_event_expression * ast_new_event_expression_sequence(
    ast_event_expression * left,
    ast_event_expression * right
);

/*!
@brief Creates and returns a new event control specifier.
*/
ast_event_control * ast_new_event_control(
    ast_event_control_type type,
    ast_event_expression * expression
);

/*!
@brief creates and returns a new delay control statement.
*/
ast_delay_ctrl * ast_new_delay_ctrl_value(ast_delay_value * value);

/*!
@brief creates and returns a new delay control statement.
*/
ast_delay_ctrl * ast_new_delay_ctrl_mintypmax(
    ast_expression * mintypmax 
);

/*!
@brief Creates and returns a new timing control statement node.
*/
ast_timing_control_statement * ast_new_timing_control_statement_delay(
    ast_timing_control_statement_type   type,
    ast_statement                     * statement,
    ast_delay_ctrl                    * delay_ctrl
);


/*!
@brief Creates and returns a new timing control statement node.
*/
ast_timing_control_statement * ast_new_timing_control_statement_event(
    ast_timing_control_statement_type   type,
    ast_expression                    * repeat,
    ast_statement                     * statement,
    ast_event_control                 * event_ctrl
);

/*! @} */

// -------------------------------- Fork Join Sequential ---------------------

/*!
@defgroup ast-node-fork-join Fork Join and Sequential Blocks
@{
@ingroup ast-node-module-items
@brief Fork join and sequential stamement blocks.
*/

//! Contains the identifier from a disable statement.
typedef struct ast_disable_statement_t{
    ast_metadata    meta;   //!< Node metadata.
    ast_identifier   id;
} ast_disable_statement;

//! Creates and returns a pointer to a new disable statement.
ast_disable_statement * ast_new_disable_statement(ast_identifier   id);


//! Describes the type of a block of statements.
typedef enum ast_block_type_e{
    BLOCK_SEQUENTIAL,
    BLOCK_FUNCTION_SEQUENTIAL,
    BLOCK_PARALLEL,
} ast_block_type;

//! Fully describes a single block of statements.
typedef struct ast_statement_block_t{
    ast_metadata    meta;   //!< Node metadata.
    ast_block_type   type;
    ast_identifier   block_identifier;
    ast_list       * declarations;
    ast_list       * statements;
} ast_statement_block;

/*!
@brief Creates and returns a new statement block of the specified type
*/
ast_statement_block * ast_new_statement_block(
    ast_block_type   type,
    ast_identifier   block_identifier,
    ast_list       * declarations,
    ast_list       * statements
);

/*! @} */

// -------------------------------- Procedural Blocks and Assignments --------

/*!
@defgroup ast-node-procedural Procedural Blocks and Assignments
@{
@ingroup ast-node-module-items
@brief Describes items found inside procedural blocks.
@details 
*/

//! Describes the type (and implicitly, the location) of an assignment.
typedef enum ast_assignment_type_e{
    ASSIGNMENT_CONTINUOUS,  //!< Continuous (combinatorial) assignment.
    ASSIGNMENT_BLOCKING,    //!< Procedural, blocking assignment.
    ASSIGNMENT_NONBLOCKING, //!< Procedural, non-blocking assignment.
    ASSIGNMENT_HYBRID, //!< @see ast_hybrid_assignment
} ast_assignment_type;

/*!
@brief encodes a single assignment.
*/
struct ast_single_assignment_t{
    ast_metadata    meta;   //!< Node metadata.
    ast_lvalue      * lval;         //!< The thing being assigned to.
    ast_expression  * expression;   //!< The value it takes on.
    ast_drive_strength * drive_strength; //!< Drive strength of the assignment.
    ast_delay3         * delay; //!< Signal propagation delay.
};

/*!
@brief Creates and returns a new continuous assignment.
*/
ast_single_assignment * ast_new_single_assignment(
    ast_lvalue         * lval,          //!< The thing being assigned to.
    ast_expression     * expression //!< The value it takes on.
);

/*!
@brief Describes a set of assignments with the same drive strength and delay.
*/
typedef struct ast_continuous_assignment_t{
    ast_metadata    meta;   //!< Node metadata.
    ast_list          * assignments; //!< A list of @ref ast_single_assignment.
} ast_continuous_assignment;

/*!
@brief Describes a procedural assignment, can be blocking or nonblocking.
*/
typedef struct ast_procedural_assignment_t{
    ast_metadata    meta;   //!< Node metadata.
    ast_lvalue      * lval;
    ast_expression  * expression;
    ast_timing_control_statement * delay_or_event;
} ast_procedural_assignment;

//! Describes the different types of procedural continuous assignments.
typedef enum ast_hybrid_assignment_type_e{
    HYBRID_ASSIGNMENT_ASSIGN,
    HYBRID_ASSIGNMENT_DEASSIGN,
    HYBRID_ASSIGNMENT_FORCE_NET,
    HYBRID_ASSIGNMENT_FORCE_VAR,
    HYBRID_ASSIGNMENT_RELEASE_VAR,
    HYBRID_ASSIGNMENT_RELEASE_NET,
}ast_hybrid_assignment_type;

/*!
@brief caters for procedural_continuous_assignments in Annex A.6.2 of spec.
@details this is needed because the spec describes something it calls
procedural continuous assignments. I think these are procedural in the
programatic / statement sense, but are continous in the time domain during a
simulation.
*/
typedef struct ast_hybrid_assignment_t{
    ast_metadata    meta;   //!< Node metadata.
    union
    {
        ast_single_assignment * assignment; //!< The assignment being made.
        ast_lvalue            * lval; //!< lvalue being assigned / deassigned.
    };
    ast_hybrid_assignment_type type; //!< Type of hybrid assignment.
} ast_hybrid_assignment;

//! Top level descriptor for an assignment.
struct ast_assignment_t{
    ast_metadata    meta;   //!< Node metadata.
    ast_assignment_type type;  //!< Which element of the internal union to use.
    union{
        ast_continuous_assignment * continuous; //!< The continuous assignment.
        ast_procedural_assignment * procedural; //!< The procedural assignment.
        ast_hybrid_assignment     * hybrid; //!< The hybrid special assignment.
    };
};

/*!
@brief Creates a new hybrid assignment of the specified type.
*/
ast_assignment * ast_new_hybrid_assignment(
    ast_hybrid_assignment_type type,    //!< The assignment type.
    ast_single_assignment * assignment  //!< The things being assigned.
);

/*!
@brief Creates a new hybrid assignment of the specified type.
*/
ast_assignment * ast_new_hybrid_lval_assignment(
    ast_hybrid_assignment_type type, //!< FORCE or (DE)ASSIGN.
    ast_lvalue * lval   //!< The thing to change.
);

/*!
@brief Creates and returns a new blocking procedural assignment object.
*/
ast_assignment * ast_new_blocking_assignment(
    ast_lvalue * lval, //!< The net/variable being assigned to.
    ast_expression  * expression,   //!< Assign it this value.
    ast_timing_control_statement* delay_or_event //!< The timing module
);

/*!
@brief Creates and returns a new nonblocking procedural assignment object.
*/
ast_assignment * ast_new_nonblocking_assignment(
    ast_lvalue * lval,  //!< The net/variable being assigned to.
    ast_expression  * expression,   //!< The value it will take.
    ast_timing_control_statement * delay_or_event //!< Timing model.
);


/*!
@brief Creates and returns a new continuous assignment object.
@brief All of the assignments will have the same drive strength and
signal delay properties.
*/
ast_assignment * ast_new_continuous_assignment(
    ast_list * assignments, //!< The list of assignments to make.
    ast_drive_strength * strength, //!< The drive strength
    ast_delay3 * delay  //!< Delay in making the assignment.
);


//! Describes the kind of statement in a statement struct.
typedef enum ast_statement_type_e{
    STM_GENERATE,
    STM_ASSIGNMENT,         //!< Blocking, non-blocking, continuous
    STM_CASE,
    STM_CONDITIONAL,        //!< if/if-else/if-elseif-else
    STM_DISABLE,
    STM_EVENT_TRIGGER,
    STM_LOOP,               //!< While, for, repeat
    STM_BLOCK,              //!< Par, sequential
    STM_TIMING_CONTROL,
    STM_FUNCTION_CALL,
    STM_TASK_ENABLE,        //!< System, user
    STM_WAIT,
    STM_MODULE_ITEM
} ast_statement_type;


/*! 
@brief Describes a single statement, and can contain sequential statement 
    blocks.
@warning The data member of the union should *never* be accessed except
when first instantiating the structure. It is used to set the data content
and nothing more. This is *very* bad practice and knowing this code is here
pains me dearly.
*/
struct ast_statement_t{
    ast_metadata    meta;   //!< Node metadata.
    ast_statement_type      type;
    ast_boolean             is_function_statement;
    ast_node_attributes   * attributes;
    ast_boolean             is_generate_statement;
    union{
        ast_wait_statement              * wait;
        ast_task_enable_statement       * task_enable;
        ast_function_call               * function_call;
        ast_timing_control_statement    * timing_control;
        ast_statement_block             * block;
        ast_loop_statement              * loop;
        ast_event_expression            * event;
        ast_disable_statement           * disable;
        ast_conditional_statement       * conditional;
        ast_case_statement              * case_statement;
        ast_assignment                  * assignment;
        ast_generate_block              * generate_block;
        ast_module_item                 * module_item;
        void                            * data;
    };
};

/*!
@brief Creates a new AST statement and returns it.
@note Requires the data field of the union to be filled out manually.
*/
ast_statement * ast_new_statement(
    ast_node_attributes * attr,
    ast_boolean         is_function_statement,
    void             *  data,
    ast_statement_type  type
);


/*!
@brief Describes the pulse characteristics in signal transmission?
*/
typedef struct ast_pulse_control_specparam_t{
    ast_metadata    meta;   //!< Node metadata.
    ast_expression * reject_limit;
    ast_expression * error_limit;
    ast_identifier   input_terminal;
    ast_identifier   output_terminal;
} ast_pulse_control_specparam;

/*!
@brief Creates and returns a new pulse control data structure.
*/
ast_pulse_control_specparam * ast_new_pulse_control_specparam(
    ast_expression * reject_limit,
    ast_expression * error_limit
);

/*!
@brief Describes a range or dimension.
*/
struct ast_range_t{
    ast_expression * upper;
    ast_expression * lower;
};

/*!
@brief Creates and returns a new range or dimension representation node.
*/
ast_range * ast_new_range(
    ast_expression * upper,
    ast_expression * lower
);


/*! @} */

// -------------------------------- UDP Blocks -------------------------------

/*!
@defgroup ast-node-udp-block User Defined Primitives
@{
@ingroup ast-construction
@brief User defined primitive types.
@details
Needs to describe the outer declaration, port lists, body statements and
instantiations
*/

//! Describes the initial value of a UDP output.
typedef enum ast_udp_init_val_e{
    UDP_INIT_1,
    UDP_INIT_0,
    UDP_INIT_X
} ast_udp_init_val;

//! Describes a single logic level symbol.
typedef enum ast_level_symbol_e{
    LEVEL_0,
    LEVEL_1,
    LEVEL_B,
    LEVEL_X,
    LEVEL_Q //!< Refers to '?'
} ast_level_symbol;

//! Is the body of the UDP specified combinatorially or sequentially.
typedef enum ast_udp_body_type_e{
    UDP_BODY_SEQUENTIAL,
    UDP_BODY_COMBINATORIAL
} ast_udp_body_type;


//! Whether a sequential body entry starts with level or edge symbols.
typedef enum ast_udp_seqential_entry_prefix_e{
    PREFIX_EDGES,
    PREFIX_LEVELS
} ast_udp_seqential_entry_prefix;

//! Describes the possible output values for a UDP element.
typedef enum ast_udp_next_state_e{
    UDP_NEXT_STATE_X,
    UDP_NEXT_STATE_0,
    UDP_NEXT_STATE_1,
    UDP_NEXT_STATE_DC, //!< Don't care.
    UDP_NEXT_STATE_QM  //!< Question mark.
} ast_udp_next_state;

//! Describes a single port for a user defined primitive.
typedef struct ast_udp_port_t{
    ast_metadata    meta;   //!< Node metadata.
    ast_port_direction    direction;
    union{
        ast_identifier        identifier;  //! IFF direction != input
        ast_list            * identifiers; //! IFF direction = input
    };
    ast_node_attributes * attributes;
    ast_boolean           reg;  //!< Is a register or wire?
    ast_expression      * default_value;
} ast_udp_port;

//! Describes the initial statement of a sequential udp body.
typedef struct ast_udp_initial_statement_t{
    ast_metadata    meta;   //!< Node metadata.
    ast_identifier    output_port;
    ast_number      * initial_value;
} ast_udp_initial_statement;

//! Describes a single UDP body sequentially or combinatorially.
typedef struct ast_udp_body_t{
    ast_metadata    meta;   //!< Node metadata.
    ast_list *        entries;    
    ast_udp_initial_statement * initial; //!< IFF body_type = sequential
    ast_udp_body_type body_type;
} ast_udp_body;

//! Describes a single combinatorial entry in the UDP ast tree.
typedef struct ast_udp_combinatorial_entry_t{
    ast_metadata    meta;   //!< Node metadata.
    ast_list * input_levels;
    ast_udp_next_state  output_symbol;
} ast_udp_combinatorial_entry;

//! describes a sequential entry in a udp body.
typedef struct ast_udp_sequential_entry_t{
    ast_metadata    meta;   //!< Node metadata.
    ast_udp_seqential_entry_prefix entry_prefix;
    union {
        ast_list * edges; //!< iff entry_prefix == PREFIX_EDGES
        ast_list * levels;  //!< iff entry_prefix == PREFIX_LEVELS
    };
    ast_level_symbol   current_state;
    ast_udp_next_state output;
} ast_udp_sequential_entry;

/*! 
@brief Describes the declaration of a user defined primitive (UDP)
@note The ports member can represent the udp_port_list non-terminal
in the grammar. This means that the first element is the output terminal,
while the subsequent elements are input terminals.
*/
typedef struct ast_udp_declaration_t{
    ast_metadata    meta;   //!< Node metadata.
    ast_identifier        identifier;
    ast_node_attributes * attributes;
    ast_list            * ports;
    ast_list            * body_entries;    
    ast_udp_initial_statement * initial; //!< IFF body_type = sequential
    ast_udp_body_type     body_type;
} ast_udp_declaration;

//! Describes a single instance of a UDP
typedef struct ast_udp_instance_t{
    ast_metadata    meta;   //!< Node metadata.
    ast_identifier        identifier;
    ast_range           * range;
    ast_lvalue          * output;
    ast_list            * inputs;
} ast_udp_instance;

//! Describes an a list of instances of a particular kind of UDP.
typedef struct ast_udp_instantiation_t{
    ast_metadata    meta;   //!< Node metadata.
    ast_list            * instances; //!< list of ast_udp_instance
    ast_identifier        identifier;
    ast_drive_strength  * drive_strength;
    ast_delay2          * delay;
} ast_udp_instantiation;


//! Creates a new initial statement node.
ast_udp_initial_statement * ast_new_udp_initial_statement(
    ast_identifier   output_port,
    ast_number     * initial_value
);


//! Creates and returns a new sequential UDP body representation.
ast_udp_body * ast_new_udp_sequential_body(
    ast_udp_initial_statement * initial_statement,
    ast_list                  * sequential_entries
);

//! Creates and returns a new combinatorial UDP body representation.
ast_udp_body * ast_new_udp_combinatoral_body(
    ast_list                  * combinatorial_entries
);

//! Creates a new combinatorial entry for a UDP node.
ast_udp_combinatorial_entry * ast_new_udp_combinatoral_entry(
    ast_list * input_levels,
    ast_udp_next_state output_symbol
);

//! Creates a new sequntial body entry for a UDP node.
ast_udp_sequential_entry * ast_new_udp_sequential_entry(
    ast_udp_seqential_entry_prefix prefix_type,
    ast_list    *                  levels_or_edges,
    ast_level_symbol               current_state,
    ast_udp_next_state             output
);

/*!
@brief Creates a new UDP port AST node
@details
@returns A pointer to the new port
*/
ast_udp_port * ast_new_udp_port(
    ast_port_direction    direction,
    ast_identifier        identifier, //!< The udp being instanced.
    ast_node_attributes * attributes,
    ast_boolean           reg,
    ast_expression      * default_value
);

/*!
@brief Creates a new UDP input port AST node
@details
@returns A pointer to the new port
*/
ast_udp_port * ast_new_udp_input_port(
    ast_list            * identifiers,
    ast_node_attributes * attributes
);

/*!
@brief Creates a new UDP declaration node
@details
@note the first element of the ports list should be the output terminal.
@returns A pointer to the new node.
*/
ast_udp_declaration * ast_new_udp_declaration(
    ast_node_attributes * attributes,
    ast_identifier        identifier,
    ast_list            * ports,
    ast_udp_body        * body
);

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
);

/*!
@brief Creates a new list of UDP instances with shared properties.
@details 
@returns A pointer to the new list.
*/
ast_udp_instantiation * ast_new_udp_instantiation(
    ast_list            * instances,
    ast_identifier        identifier, //!< The UDP being instanced
    ast_drive_strength  * drive_strength,
    ast_delay2          * delay
);


/*! @} */

// -------------------------------- Generate Statements ----------------------

/*!
@defgroup ast-node-generate-statement Generate Statements
@{
@ingroup ast-node-module-items
@brief Represents generate loops.
*/

//! Simple wrapper and placeholder for generate associated meta-data.
struct ast_generate_block_t{
    ast_metadata    meta;   //!< Node metadata.
    ast_identifier   identifier;
    ast_list       * generate_items;
};

//! Creates and returns a new block of generate items.
ast_generate_block * ast_new_generate_block(
    ast_identifier   identifier,
    ast_list       * generate_items
);

/*!
@brief Creates and returns a new item which exists inside a generate statement.
@note the void* type of the construct parameter allows for a single
constructor function rather than one per member of the union inside the
ast_generate_item structure.
*/
ast_statement * ast_new_generate_item(
    ast_statement_type type,
    void    *          construct
);

/*! @} */

// -------------------------------- Module Instantiation ---------------------

/*!
@defgroup ast-node-module-instantiation Module Instantiation
@{
@ingroup ast-node-module-items
@brief Describes the instantiation of a module, as opposed to it's declaration.
*/

/*! 
@brief Describes the instantiation of one or more modules of the same type with
the same parameters.
@details If the resolved member is true, then you can access the declaration
member, and find out everything about the module being instanced. Otherwise,
you must access the module_identifier member, and can only know what the
module is called.
*/
typedef struct ast_module_instantiation_t {
    ast_metadata    meta;   //!< Node metadata.
    ast_boolean     resolved; //!< Is the name resolved to a declaration?
    union{
        ast_identifier  module_identifer; //!< The module being instanced.
        ast_module_declaration * declaration; //!< The module instanced.
    };
    ast_list              * module_parameters;
    ast_list              * module_instances;
} ast_module_instantiation;

/*!
@brief Creates and returns a new set of module instances with shared
parameters.
*/
ast_module_instantiation * ast_new_module_instantiation(
    ast_identifier          module_identifer,
    ast_list              * module_parameters,
    ast_list              * module_instances
);

/*!
@brief A single instance of a defined module.
@warning Don't confuse this with @ref ast_module_instantiation which is a
collection of ast_module_instance with the same parameters.
*/
typedef struct ast_module_instance_t{
    ast_metadata    meta;   //!< Node metadata.
    ast_identifier          instance_identifier;
    ast_list              * port_connections;
} ast_module_instance;


/*!
@brief Creates and returns a new instance of a module with a given identifer
and set of port connections.
*/
ast_module_instance * ast_new_module_instance(
    ast_identifier          instance_identifier,
    ast_list              * port_connections
);

/*! 
@brief Decribes a single port connection in a module instance.
@note This is also used to represent parameter assignments.
*/
typedef struct ast_port_connection_t{
    ast_metadata    meta;   //!< Node metadata.
    ast_identifier   port_name;
    ast_expression * expression;
} ast_port_connection;

/*!
@brief Creates and returns a new port connection representation.
@param port_name - The port being assigned to.
@param expression - The thing inside the module the port connects to.
@note This is also used for module parameter assignments.
*/
ast_port_connection * ast_new_named_port_connection(
    ast_identifier   port_name,
    ast_expression * expression
);

/*! @} */

// -------------------------------- Primitives -------------------------------

/*!
@defgroup ast-node-primitives Primitives
@{
@ingroup ast-construction
@brief Digital design primitive representation. Transistors, transmission
gates, etc.
*/

//! describes the type of a single MOS switch.
typedef enum ast_switchtype_e{
    SWITCH_CMOS,
    SWITCH_RCMOS,
    SWITCH_NMOS,
    SWITCH_PMOS,
    SWITCH_RNMOS,
    SWITCH_RPMOS,
    SWITCH_TRAN,
    SWITCH_RTRAN
} ast_switchtype;

//! Describes a single gate type along with it's delay properties.
typedef struct ast_switch_gate_t{
    ast_metadata    meta;   //!< Node metadata.
    ast_switchtype type;
    union {
        ast_delay3 * delay3;
        ast_delay2 * delay2; //!< IFF type == TRAN or RTRAN
    };
} ast_switch_gate;

//! Instances a new switch type with a delay3.
ast_switch_gate * ast_new_switch_gate_d3(
    ast_switchtype type,
    ast_delay3     * delay
);

//! Instances a new switch type with a delay2.
ast_switch_gate * ast_new_switch_gate_d2(
    ast_switchtype type,
    ast_delay2     * delay
);

//! Describes the drive strength of a single primitive.
typedef enum ast_primitive_strength_e{
    STRENGTH_HIGHZ0,
    STRENGTH_HIGHZ1,
    STRENGTH_SUPPLY0,
    STRENGTH_STRONG0,
    STRENGTH_PULL0,
    STRENGTH_WEAK0,
    STRENGTH_SUPPLY1,
    STRENGTH_STRONG1,
    STRENGTH_PULL1,
    STRENGTH_WEAK1,
    STRENGTH_NONE
} ast_primitive_strength;

//! Describes pull direction.
typedef enum ast_pull_direction_e{
    PULL_UP,
    PULL_DOWN,
    PULL_NONE
 }ast_pull_direction;

//! Fully describes the pull's of a net going up and down.
 typedef struct ast_pull_strength_t{
    ast_metadata    meta;   //!< Node metadata.
    ast_primitive_strength strength_1;
    ast_primitive_strength strength_2;
 } ast_pull_strength;

//! Create and return a new pull strength indicator for 1 and 0.
ast_pull_strength * ast_new_pull_stregth(
    ast_primitive_strength strength_1,
    ast_primitive_strength strength_2
);

//! Describes the pull strength and direction of a primitive.
typedef struct ast_primitive_pull_strength_t{
    ast_metadata    meta;   //!< Node metadata.
    ast_pull_direction       direction;
    ast_primitive_strength   strength_1;
    ast_primitive_strength   strength_0;
} ast_primitive_pull_strength;

//! Creates and returns a new structure describing primitive net strength.
ast_primitive_pull_strength * ast_new_primitive_pull_strength(
    ast_pull_direction       direction,
    ast_primitive_strength   strength_1,
    ast_primitive_strength   strength_0
);

//! Describes a single pull gate instance.
typedef struct ast_pull_gate_instance_t{
    ast_metadata    meta;   //!< Node metadata.
    ast_identifier      name;
    ast_lvalue        * output_terminal;
} ast_pull_gate_instance;

//! A single pass transistor instance.
typedef struct ast_pass_switch_instance_t{
    ast_metadata    meta;   //!< Node metadata.
    ast_identifier      name;
    ast_lvalue        * terminal_1;
    ast_lvalue        * terminal_2;
} ast_pass_switch_instance;

//! Describes the logical function performed by a builtin n-input gate.
typedef enum ast_gatetype_n_input_e{
    N_IN_AND,
    N_IN_NAND,
    N_IN_NOR,
    N_IN_OR ,
    N_IN_XOR,
    N_IN_XNOR
} ast_gatetype_n_input;

//! A collection of n-input gates with the same type and delay properties.
typedef struct ast_n_input_gate_instances_t{
    ast_metadata    meta;   //!< Node metadata.
    ast_gatetype_n_input    type;
    ast_delay3            * delay;
    ast_drive_strength    * drive_strength;
    ast_list              * instances;
} ast_n_input_gate_instances;

//! Creates collection of n-input gates with the same type and properties.
ast_n_input_gate_instances * ast_new_n_input_gate_instances(
    ast_gatetype_n_input    type,
    ast_delay3            * delay,
    ast_drive_strength    * drive_strength,
    ast_list              * instances
);

//! An N-input gate instance. e.g. 3-to-1 NAND.
typedef struct ast_n_input_gate_instance_t{
    ast_metadata    meta;   //!< Node metadata.
    ast_identifier      name;
    ast_list          * input_terminals;
    ast_lvalue        * output_terminal;
} ast_n_input_gate_instance;

//! Describes a variety of enable gate type.
typedef enum ast_enable_gatetype_e{
    EN_BUFIF0,
    EN_BUFIF1,
    EN_NOTIF0,
    EN_NOTIF1 
} ast_enable_gatetype;

//! A collection of enable gates with the same type and delay properties.
typedef struct ast_enable_gate_instances{
    ast_metadata    meta;   //!< Node metadata.
    ast_enable_gatetype     type;
    ast_delay3            * delay;
    ast_drive_strength    * drive_strength;
    ast_list              * instances;
} ast_enable_gate_instances;

//! Creates collection of enable gates with the same type and properties.
ast_enable_gate_instances * ast_new_enable_gate_instances(
    ast_gatetype_n_input    type,
    ast_delay3            * delay,
    ast_drive_strength    * drive_strength,
    ast_list              * instances
);

//! A single enable gate
typedef struct ast_enable_gate_instance_t{
    ast_metadata    meta;   //!< Node metadata.
    ast_identifier      name;
    ast_lvalue        * output_terminal;
    ast_expression    * enable_terminal;
    ast_expression    * input_terminal;
} ast_enable_gate_instance;

//! A single MOS switch (transistor) instance.
typedef struct ast_mos_switch_instance_t{
    ast_metadata    meta;   //!< Node metadata.
    ast_identifier      name;
    ast_lvalue        * output_terminal;
    ast_expression    * enable_terminal;
    ast_expression    * input_terminal;
} ast_mos_switch_instance;

//! A single CMOS switch (transistor) instance.
typedef struct ast_cmos_switch_instance_t{
    ast_metadata    meta;   //!< Node metadata.
    ast_identifier      name;
    ast_lvalue        * output_terminal;
    ast_expression    * ncontrol_terminal;
    ast_expression    * pcontrol_terminal;
    ast_expression    * input_terminal;
} ast_cmos_switch_instance;

//! A single pass enable switch with pass and enable terminals.
typedef struct ast_pass_enable_switch_t{
    ast_metadata    meta;   //!< Node metadata.
    ast_identifier      name;
    ast_lvalue        * terminal_1;
    ast_lvalue        * terminal_2;
    ast_expression    * enable;
} ast_pass_enable_switch;

//! Describes a particular type of pass enable switch.
typedef enum ast_pass_enable_switchtype_e{
    PASS_EN_TRANIF0,
    PASS_EN_TRANIF1,
    PASS_EN_RTRANIF0,
    PASS_EN_RTRANIF1 
} ast_pass_enable_switchtype;

/*!
@brief Describes a collection of pass enable switches withe the same type and
delay characteristics.
*/
typedef struct ast_pass_enable_switches_t{
    ast_metadata    meta;   //!< Node metadata.
    ast_pass_enable_switchtype    type;
    ast_delay2                  * delay;
    ast_list                    * switches;
} ast_pass_enable_switches;

//! Describes the type of an n_output gate.
typedef enum ast_n_output_gatetype_e{
    N_OUT_BUF,
    N_OUT_NOT
} ast_n_output_gatetype;

//! Describes a single gate with one input and several outputs.
typedef struct ast_n_output_gate_instance_t{
    ast_metadata    meta;   //!< Node metadata.
    ast_identifier                name;
    ast_list                    * outputs;
    ast_expression              * input;
} ast_n_output_gate_instance;

typedef struct ast_n_output_gate_instances_t{
    ast_metadata    meta;   //!< Node metadata.
    ast_n_output_gatetype         type;
    ast_delay2                  * delay;
    ast_drive_strength          * drive_strength;
    ast_list                    * instances;
} ast_n_output_gate_instances;

/*!
@brief Creates and returns a new n_output gate instance.
@see ast_n_output_gate_instances
*/
ast_n_output_gate_instance * ast_new_n_output_gate_instance(
    ast_identifier                name,
    ast_list                    * outputs,
    ast_expression              * input
);

/*!
@brief Creates and returns a set of n_output gates with the same properties.
*/
ast_n_output_gate_instances * ast_new_n_output_gate_instances(
    ast_n_output_gatetype         type,
    ast_delay2                  * delay,
    ast_drive_strength          * drive_strength,
    ast_list                    * instances
);

/*!
@brief Creates and returns a collection of pass enable switches.
*/
ast_pass_enable_switches * ast_new_pass_enable_switches(
    ast_pass_enable_switchtype    type,
    ast_delay2                  * delay,
    ast_list                    * switches 
);

/*!
@brief Creates and returns a new pass enable switch instance.
*/
ast_pass_enable_switch * ast_new_pass_enable_switch(
    ast_identifier      name,
    ast_lvalue        * terminal_1,
    ast_lvalue        * terminal_2,
    ast_expression    * enable
);

/*! @brief Describes a single pull gate instance.*/
ast_pull_gate_instance * ast_new_pull_gate_instance(
    ast_identifier      name,
    ast_lvalue        * output_terminal
);

/*! @brief A single pass transistor instance.*/
ast_pass_switch_instance * ast_new_pass_switch_instance(
    ast_identifier      name,
    ast_lvalue        * terminal_1,
    ast_lvalue        * terminal_2
);

/*! @brief An N-input gate instance. e.g. 3-to-1 NAND.*/
ast_n_input_gate_instance * ast_new_n_input_gate_instance(
    ast_identifier      name,
    ast_list          * input_terminals,
    ast_lvalue        * output_terminal
);

/*! @brief A single Enable gate instance.*/
ast_enable_gate_instance * ast_new_enable_gate_instance(
    ast_identifier      name,
    ast_lvalue        * output_terminal,
    ast_expression    * enable_terminal,
    ast_expression    * input_terminal
);

/*! @brief A single MOS switch (transistor) instance.*/
ast_mos_switch_instance * ast_new_mos_switch_instance(
    ast_identifier      name,
    ast_lvalue        * output_terminal,
    ast_expression    * enable_terminal,
    ast_expression    * input_terminal
);

/*! @brief A single CMOS switch (transistor) instance.*/
ast_cmos_switch_instance * ast_new_cmos_switch_instance(
    ast_identifier      name,
    ast_lvalue        * output_terminal,
    ast_expression    * ncontrol_terminal,
    ast_expression    * pcontrol_terminal,
    ast_expression    * input_terminal
);

//! A collection of CMOS, MOS or PASS switches of the same type.
typedef struct ast_switches_t{
    ast_metadata    meta;   //!< Node metadata.
    ast_switch_gate * type;
    ast_list        * switches;
} ast_switches;

/*!
@brief creates and returns a new collection of AST switches.
*/
ast_switches * ast_new_switches(ast_switch_gate * type, ast_list * switches);

//! Describes a kind of gate primitive.
typedef enum ast_gate_type_e{
    GATE_CMOS,      //!< Complementary metal oxide semiconductor.
    GATE_MOS,       //!< Metal oxide Semiconductor.
    GATE_PASS,      //!< Pass Transistor
    GATE_ENABLE,    //!< Enable Gate
    GATE_N_OUT,     //!< N output gates - buffers & Inverters.
    GATE_N_IN,      //!< N input gates - AND,NAND,OR etc
    GATE_PASS_EN,   //!< Pass transistor enable gate.
    GATE_PULL_UP,   //!< Pull up resistor.
    GATE_PULL_DOWN  //!< Pull down resistor.
} ast_gate_type;


/*!
@brief Fully describes the instantiation of one or more gate level primitives.
*/
typedef struct ast_gate_instantiation_t{
    ast_metadata    meta;   //!< Node metadata.
    ast_gate_type type;
    union{
        ast_switches * switches;
        ast_pass_enable_switches * pass_en;
        ast_enable_gate_instances * enable;
        ast_n_input_gate_instances * n_in;
        ast_n_output_gate_instances * n_out;
        struct{
            ast_primitive_pull_strength   * pull_strength;
            ast_list                      * pull_gates;
        };
    };
} ast_gate_instantiation;

/*!
@brief Creates and returns a new gate instantiation descriptor.
@details Expects the data fields to be filled out manually after the structure
is returned.
*/
ast_gate_instantiation * ast_new_gate_instantiation(ast_gate_type type);

/*! @} */

// -------------------------------- Delays -----------------------------------

/*!
@defgroup ast-node-delays Delays
@{
@ingroup ast-construction
@brief Signal propagation delays
*/

//! Describes the union member of an ast_delay_value structure to be accessed.
typedef enum ast_delay_value_type_e{
    DELAY_VAL_PARAMETER,
    DELAY_VAL_SPECPARAM,
    DELAY_VAL_NUMBER,
    DELAY_VAL_MINTYPMAX
} ast_delay_value_type;

//! Describes the type and value of a delay specifier.
typedef struct ast_delay_value_t{
    ast_metadata    meta;   //!< Node metadata.
    ast_delay_value_type type;
    union{
        ast_identifier parameter_id;
        ast_identifier specparam_id;
        ast_number  *  unsigned_number;
        ast_minmax_exp mintypmax;
        void        *  data;
    };
} ast_delay_value;

//! Describes a 3 point delay distribution.
struct ast_delay3_t{
    ast_metadata    meta;   //!< Node metadata.
    ast_delay_value * min;
    ast_delay_value * max;
    ast_delay_value * avg;
};

//! Describes a 2 point delay distribution.
struct ast_delay2_t{
    ast_metadata    meta;   //!< Node metadata.
    ast_delay_value * min;
    ast_delay_value * max;
};

/*!
@brief Create a new delay value.
*/
ast_delay_value * ast_new_delay_value(
    ast_delay_value_type type,
    void * data
);

/*!
@brief Create a new delay3 instance.
*/
ast_delay3 * ast_new_delay3(
    ast_delay_value * min,
    ast_delay_value * avg,
    ast_delay_value * max
);

/*!
@brief Create a new delay2 instance.
*/
ast_delay2 * ast_new_delay2(
    ast_delay_value * min,
    ast_delay_value * max
);


/*! @} */

// -------------------------------- Strengths --------------------------------

/*!
@defgroup ast-node-strengths Drive Strengths
@{
@ingroup ast-construction
@brief Describes signal drive strengths.
@see ast_primitive_strength ast_primitive_pull_strength ast_drive_strength
*/

/*!
@brief Describes (coloquially?!) the charge strength on a driver.
@warning In physics, the quanta of charge are *not* small, medium and large.
*/
typedef enum ast_charge_strength_e{
    CHARGE_SMALL,   //!<
    CHARGE_MEDIUM,  //!<
    CHARGE_LARGE,   //!<
    CHARGE_DEFAULT  //!< Use when not explicitly specified.
} ast_charge_strength;

/*! @} */

// -------------------------------- Nets and Variables -----------------------

/*!
@defgroup ast-node-net-variables Nets and Variables
@{
@ingroup ast-construction
@brief Net and variable types, declarations and assignments.
*/



/*! @} */


// -------------------------------- Port Declarations ------------------------

/*!
@defgroup ast-node-port-declarations Module Port Declaration
@{
@ingroup ast-node-module-declaration
@brief 
*/

//! Describes the type of a net in Verilog.
typedef enum ast_net_type_e{
    NET_TYPE_SUPPLY0,   //!< Logic 0 supply rail
    NET_TYPE_SUPPLY1,   //!< Logic 1 supply rail.
    NET_TYPE_TRI,       //!< Tri-state
    NET_TYPE_TRIAND,    //!< Tri-state AND
    NET_TYPE_TRIOR,     //!< Tri-state OR
    NET_TYPE_TRIREG,    //!< Tri-state reg wire
    NET_TYPE_WIRE,      //!< Wire
    NET_TYPE_WAND,      //!< ?
    NET_TYPE_WOR,       //!< ?
    NET_TYPE_NONE       //!< Use only when not specified!
} ast_net_type;

//! Fully describes a single port declaration
typedef struct ast_port_declaration_t{
    ast_metadata    meta;   //!< Node metadata.
    ast_port_direction  direction;      //!< Input / output / inout etc.
    ast_net_type        net_type;       //!< Wire/reg etc
    ast_boolean         net_signed;     //!< Signed value?
    ast_boolean         is_reg;         //!< Is explicitly a "reg"
    ast_boolean         is_variable;    //!< Variable or net?
    ast_range         * range;          //!< Bus width.
    ast_list          * port_names;     //!< The names of the ports.
} ast_port_declaration;

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
);

/*! @} */

// -------------------------------- Type Declarations ------------------------

/*!
@defgroup ast-node-type-declaration Type Declaration
@{
@ingroup ast-construction
@brief Custom type declarations.
*/

//! Describes the datatype of the construct being declared.
typedef enum ast_declaration_type_e{
    DECLARE_EVENT,
    DECLARE_GENVAR,
    DECLARE_INTEGER,
    DECLARE_TIME,
    DECLARE_REALTIME,
    DECLARE_REAL,
    DECLARE_NET,
    DECLARE_REG,
    DECLARE_UNKNOWN //!< For when we don't know the type when instancing.
} ast_declaration_type;

/*! 
@brief Fully describes the declaration of elements one might find inside a
module.
@todo Clean this up to avoid accessing members which are mutually exclusive
*/
typedef struct ast_type_declaration_t{
    ast_metadata    meta;   //!< Node metadata.
    ast_declaration_type  type;
    ast_net_type          net_type;
    ast_list            * identifiers;
    ast_delay3          * delay;
    ast_drive_strength  * drive_strength;
    ast_charge_strength   charge_strength;
    ast_boolean           vectored;
    ast_boolean           scalared;
    ast_boolean           is_signed;
    ast_range           * range;
} ast_type_declaration;

//! Describes a single net declaration.
typedef struct ast_net_declaration_t{
    ast_metadata         meta;       //!< Node metadata.
    ast_net_type         type;       //!< What sort of net is this?
    ast_identifier       identifier; //!< What is the net called?
    ast_delay3         * delay;      //!< Delay characteristics.
    ast_drive_strength * drive;      //!< Drive strength.
    ast_range          * range;      //!< Width of the net.
    ast_boolean          vectored;
    ast_boolean          scalared;
    ast_boolean          is_signed;
    ast_expression     * value;      //!< Default assigned value.
} ast_net_declaration;


//! Describes a single reg declaration.
typedef struct ast_reg_declaration_t{
    ast_metadata         meta;       //!< Node metadata.
    ast_identifier       identifier; //!< What is the reg called?
    ast_range          * range;      //!< Width of the reg.
    ast_boolean          is_signed;
    ast_expression     * value;      //!< Default assigned value.
} ast_reg_declaration;

//! Describes a simple set of declarations of a particular type.
typedef struct ast_var_declaration_t{
    ast_metadata        meta;       //!< Metadata
    ast_identifier      identifier; //!< The variable identifier.
    ast_declaration_type type;      //!< What sort of variable is this?
} ast_var_declaration;

/*!
@brief Creates a new net declaration object.
@details Turns a generic "type declaration" object into a net_declration
object and discards un-needed member fields.
@returns A set of ast_net_declaration types as a list, one for each identifer
in the original type declaration object.
*/
ast_list * ast_new_net_declaration(
    ast_type_declaration * type_dec
);

/*!
@brief Creates a new reg declaration object.
@details Turns a generic "type declaration" object into a reg_declration
object and discards un-needed member fields.
@returns A set of ast_reg_declaration types as a list, one for each identifer
in the original type declaration object.
*/
ast_list * ast_new_reg_declaration(
    ast_type_declaration * type_dec
);

/*!
@brief Creates a new variable declaration object.
@details Turns a generic "var declaration" object into a var_declration
object and discards un-needed member fields.
@returns A set of ast_var_declaration types as a list, one for each identifer
in the original type declaration object.
*/
ast_list * ast_new_var_declaration(
    ast_type_declaration * type_dec
);


/*!
@brief Creates and returns a node to represent the declaration of a new
module item construct.
@param [in] type - What sort of item is contained in the returned structure.
From this, we know which members of the ast_type_declaration make sense and
are safe to access.
@details Because of the complex nature of the grammar for these declarations,
(bourne from the number of optional modifiers) no single constructor function
is provided. Rather, one can create a new type declaration of a
known type, but must otherwise fill out the data members as they go along.
All pointer members are initialised to NULL, and all boolean members will
initially be false.
*/
ast_type_declaration * ast_new_type_declaration(ast_declaration_type type);

/*! @} */

// -------------------------------- Module Parameters ------------------------

/*!
@defgroup ast-node-module-parameters Module Parameters
@{
@ingroup ast-node-module-declaration
@brief 
*/

//! Data value types that a module parameter can take on.
typedef enum ast_parameter_type_e{
    PARAM_INTEGER,
    PARAM_REAL,
    PARAM_REALTIME,
    PARAM_TIME,
    PARAM_GENERIC,  //!< used when no type keywork is used in the declaration.
    PARAM_SPECPARAM
} ast_parameter_type;

//! Stores the type and characteristics of one or more parameter declarations.
typedef struct ast_parameter_declarations_t{
    ast_metadata    meta;   //!< Node metadata.
    ast_list        * assignments;
    ast_boolean       signed_values; //!< Valid IFF type==PARAM_GENERIC
    ast_boolean       local;        //!< Local parameter or global.
    ast_range       * range; //!< Valid IFF type==PARAM_GENERIC
    ast_parameter_type  type;
} ast_parameter_declarations;

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
);

/*! @} */

// --------------------------- Block Item Declaration ------------------------

/*!
@defgroup ast-node-declaration Declarations
@{
@ingroup ast-node-module-items
@brief Blocks of definitions
*/

//! Describes the declaration of a set of registers within a block.
typedef struct ast_block_reg_declaration_t{
    ast_metadata    meta;   //!< Node metadata.
    ast_boolean   is_signed;     //!< Do they represent signed values?
    ast_range   * range;         //!< Are these vectors of registers?
    ast_list    * identifiers;   //!< list of reg names with same properties.
} ast_block_reg_declaration;

/*!
@brief Creates and returns a new block register declaration descriptor.
*/
ast_block_reg_declaration * ast_new_block_reg_declaration(
    ast_boolean   is_signed,    //!< Do they represent signed values?
    ast_range   * range,        //!< Are these vectors of registers?
    ast_list    * identifiers   //!< list of reg names with same properties.
);

//! Describes what sort of block item is being declared.
typedef enum ast_block_item_declaration_type_e{
    BLOCK_ITEM_REG, //!< Reg declaration.
    BLOCK_ITEM_PARAM,//!< Parameters
    BLOCK_ITEM_TYPE //!< event, integer,real,time,realtime
} ast_block_item_declaration_type;

//! Describes the declaration of a block item.
struct ast_block_item_declaration_t{
    ast_metadata    meta;   //!< Node metadata.
    ast_block_item_declaration_type type;
    ast_node_attributes             * attributes;
    union{
        ast_block_reg_declaration * reg; //!< When type == BLOCK_ITEM_REG
        ast_type_declaration * event_or_var;//!< When type == BLOCK_ITEM_TYPE.
        ast_parameter_declarations *  parameters; //!< When type==BLOCK_ITEM_PARAM.
    };
};

/*!
@brief Creates and returns a new block item declaration of the specified type.
@note Expects the relevant union member to be set manually.
*/
ast_block_item_declaration * ast_new_block_item_declaration(
    ast_block_item_declaration_type type, //!< The item type.
    ast_node_attributes             * attributes //!< Tool specific attributes.
);


/*! @} */

// -------------------------------- Function Declaration ---------------------

/*!
@defgroup ast-node-function-declaration Function Declaration
@{
@ingroup ast-node-declaration
@brief Describes a declaration of a user function.
@see ast-node-function-calling
*/

//! Return value type for a task.
typedef enum ast_task_port_type_e{
    PORT_TYPE_TIME,     //!< Time value.
    PORT_TYPE_REAL,     //!< Real valued number.
    PORT_TYPE_REALTIME, //!< Real valued time.
    PORT_TYPE_INTEGER,  //!< Integer type.
    PORT_TYPE_NONE,     //!< No specified type.
} ast_task_port_type;

//! Holds either a range or a type data item.
typedef struct ast_range_or_type_t{
    ast_metadata    meta;   //!< Node metadata.
    ast_boolean is_range;   //!< iff true use range, else type.
    union{
        ast_range * range;  //!< The range strucure.
        ast_task_port_type type; //!< The type structure (an enum)
    };
} ast_range_or_type;

/*!
@brief Creates and returns a new object storing either a range or a type.
@param [in] is_range - IFF true then the structure's union contains a
range structure, otherwise it contains a type structure.
*/
ast_range_or_type * ast_new_range_or_type(ast_boolean is_range);


/*!
@brief Fully describes the declaration of a verilog function.
*/
typedef struct ast_function_declaration_t{
    ast_metadata    meta;   //!< Node metadata.
    ast_boolean         automatic;         //!< Is automatic?
    ast_boolean         is_signed;         //!< Is the returned value signed?
    ast_boolean         function_or_block; //!< IFF true statements is list of function_item_declaration else list of block_item_declaration.
    ast_range_or_type  *rot;               //!< Range or type.
    ast_identifier      identifier;        //!< Function name.
    ast_list           *item_declarations; //!< Internal variable declarations.
    ast_statement      *statements;        //!< Executable statements.
} ast_function_declaration;

/*!
@brief Creates and returns a function declaration node.
*/
ast_function_declaration * ast_new_function_declaration(
    ast_boolean         automatic,         //!< Is automatic?
    ast_boolean         is_signed,         //!< Is the returned value signed?
    ast_boolean         function_or_block, //!< IFF true statements is list of function_item_declaration else list of block_item_declaration.
    ast_range_or_type  *rot,               //!< Range or type.
    ast_identifier      identifier,        //!< Function name.
    ast_list           *item_declarations, //!< Internal variable declarations.
    ast_statement      *statements         //!< Executable statements.
);

/*
@brief Fully describes a set of task arguments with the same properties.
*/
typedef struct ast_task_port_t{
    ast_metadata    meta;   //!< Node metadata.
    ast_port_direction direction;   //!< Input or output to the port.
    ast_boolean        reg;         //!< Is is a registered value?
    ast_boolean        is_signed;   //!< Does it represent a signed value?
    ast_range        * range;       //!< Bit or item range for arrays.
    ast_task_port_type type;        //!< Data type (if any)
    ast_list         * identifiers; //!< The list of port names.
} ast_task_port;


/*
@brief Creates and returns a new representation of a task or function
argument.
*/
ast_task_port * ast_new_task_port(
    ast_port_direction direction,   //!< Input or output to the port.
    ast_boolean        reg,         //!< Is is a registered value?
    ast_boolean        is_signed,   //!< Does it represent a signed value?
    ast_range        * range,       //!< Bit or item range for arrays.
    ast_task_port_type type,        //!< Data type (if any)
    ast_list         * identifiers //!< The list of port names.
);

/*!
@brief Describes a function item declaration, which is either a block
item or port declaration.
*/
typedef struct ast_function_item_declaration_t{
    ast_metadata    meta;   //!< Node metadata.
    ast_boolean is_port_declaration; //!< True IFF an argument to the function.
    union{
        ast_block_item_declaration  * block_item; //!< Standard body statements.
        ast_task_port               * port_declaration; //!< IFF is_port_declaration == AST_TRUE
    };
} ast_function_item_declaration;

/*!
@brief Creates and returns a new function item declaration.
@note All member fields must be filled out manaully. THis function just
ensures the memory is allocated properly.
*/
ast_function_item_declaration * ast_new_function_item_declaration();

/*! @} */

// -------------------------------- Task Declaration -------------------------

/*!
@defgroup ast-node-task-declaration Task Declaration
@{
@ingroup ast-node-declaration
@brief User task (procedure) definition.
*/

/*!
@brief Creates and returns a new task declaration statement.
*/
typedef struct ast_task_declaration_t{
    ast_metadata    meta;   //!< Node metadata.
    ast_boolean         automatic;      //!< Automatic iff TRUE
    ast_identifier      identifier;     //!< The task name.
    ast_list        *   ports;          //!< Arguments to the task.
    ast_list        *   declarations;   //!< Internal variable declarations.
    ast_statement   *   statements;     //!< The body of the task.
} ast_task_declaration;

/*!
@brief Creates and returns a new task declaration statement.
*/
ast_task_declaration * ast_new_task_declaration(
    ast_boolean         automatic,      //!< Automatic iff TRUE
    ast_identifier      identifier,     //!< The task name.
    ast_list        *   ports,          //!< Arguments to the task.
    ast_list        *   declarations,   //!< Internal variable declarations.
    ast_statement   *   statements      //!< The body of the task.
);



/*! @} */

// -------------------------------- Module Items -----------------------------

/*!
@defgroup ast-node-module-items Module Items
@{
@ingroup ast-node-module-declaration
@brief Contains things like continuous assignments, procedural blocks and
module instantiations.
*/

//! Describes the type of data structure representing a module item.
typedef enum ast_module_item_type_e{
    MOD_ITEM_PORT_DECLARATION, //!< port_declaration
    MOD_ITEM_GENERATED_INSTANTIATION,
    MOD_ITEM_PARAMETER_DECLARATION, //!< Local or global.
    MOD_ITEM_SPECIFY_BLOCK,
    MOD_ITEM_SPECPARAM_DECLARATION,
    MOD_ITEM_PARAMETER_OVERRIDE,
    MOD_ITEM_CONTINOUS_ASSIGNMENT, //!< access continuous_assignment
    MOD_ITEM_GATE_INSTANTIATION,
    MOD_ITEM_UDP_INSTANTIATION,
    MOD_ITEM_MODULE_INSTANTIATION,
    MOD_ITEM_INITIAL_CONSTRUCT,
    MOD_ITEM_ALWAYS_CONSTRUCT,
    MOD_ITEM_NET_DECLARATION,
    MOD_ITEM_REG_DECLARATION,
    MOD_ITEM_INTEGER_DECLARATION,
    MOD_ITEM_REAL_DECLARATION,
    MOD_ITEM_TIME_DECLARATION,
    MOD_ITEM_REALTIME_DECLARATION,
    MOD_ITEM_EVENT_DECLARATION,
    MOD_ITEM_GENVAR_DECLARATION,
    MOD_ITEM_TASK_DECLARATION,
    MOD_ITEM_FUNCTION_DECLARATION
} ast_module_item_type;

//! Describes a single module item, its type and data structure.
struct ast_module_item_t{
    ast_metadata    meta;   //!< Node metadata.
    ast_module_item_type type;
    ast_node_attributes *attributes;
    union{
        ast_port_declaration        * port_declaration;
        ast_generate_block          * generated_instantiation;
        ast_parameter_declarations  * parameter_declaration;
        ast_list                    * specify_block;
        ast_parameter_declarations  * specparam_declaration;
        ast_list                    * parameter_override;
        ast_continuous_assignment   * continuous_assignment;
        ast_gate_instantiation      * gate_instantiation;
        ast_udp_instantiation       * udp_instantiation;
        ast_module_instantiation    * module_instantiation;
        ast_statement               * always_construct;
        ast_statement               * initial_construct;
        ast_type_declaration        * net_declaration;
        ast_type_declaration        * reg_declaration;
        ast_type_declaration        * integer_declaration;
        ast_type_declaration        * real_declaration;
        ast_type_declaration        * time_declaration;
        ast_type_declaration        * realtime_declaration;
        ast_type_declaration        * event_declaration;
        ast_type_declaration        * genvar_declaration;
        ast_task_declaration        * task_declaration;
        ast_function_declaration    * function_declaration;
    };
};

/*!
@brief Creates and returns a new module item descriptor.
@param [in] attributes - Tool specific attributes.
@param [in] type - What sort of module item is being represented?
@note Expects the relevant union member to be set based on the type manually.
*/
ast_module_item * ast_new_module_item(
    ast_node_attributes * attributes,
    ast_module_item_type  type
);


/*! @} */

// -------------------------------- Module Declarations ----------------------

/*!
@defgroup ast-node-module-declaration Module Declaration
@{
@ingroup ast-construction
@brief Details declaration of module ports and parameters.
*/

/*!
@brief Fully describes a single module declaration in terms of parameters
ports and internal constructs.
@details
*/
struct ast_module_declaration_t{
    ast_metadata    meta;   //!< Node metadata.
    ast_node_attributes * attributes; //!< Tool specific attributes.
    ast_identifier        identifier; //!< The name of the module.
    ast_list * always_blocks; //!< ast_statement
    ast_list * continuous_assignments; //!< ast_single_assignment
    ast_list * event_declarations; //!< ast_var_declaration
    ast_list * function_declarations; //!< ast_task_declaration
    ast_list * gate_instantiations; //!< ast_gate_instantiation
    ast_list * genvar_declarations; //!< ast_var_declaration
    ast_list * generate_blocks; //!< ast_generate_block
    ast_list * initial_blocks; //!< ast_statement
    ast_list * integer_declarations; //!< ast_var_declaration
    ast_list * local_parameters; //!< ast_parameter_declaration
    ast_list * module_instantiations; //!< ast_module_instantiation
    ast_list * module_parameters; //!< ast_parameter_declaration
    ast_list * module_ports; //!< ast_port_declaration
    ast_list * net_declarations; //!< ast_net_declaration
    ast_list * parameter_overrides; //!< ast_single_assignment
    ast_list * real_declarations; //!< ast_var_declaration
    ast_list * realtime_declarations; //!< ast_var_declaration
    ast_list * reg_declarations; //!< ast_reg_declaration
    ast_list * specify_blocks; //!< Not Supported
    ast_list * specparams; //!< ast_parameter_declaration
    ast_list * task_declarations; //!< ast_task_declaration
    ast_list * time_declarations; //!< ast_var_declaration
    ast_list * udp_instantiations; //!< ast_udp_instantiation

} ;

/*!
@brief Creates a new module instantiation.
@param [in] attributes - Tool specific attributes.
@param [in] identifier - The full module name
@param [in] parameters - List of parameters to the module
@param [in] ports      - List of module ports.
@param [in] constructs - The internal constructs such as tasks, procedures and
                         internal instantiations.
*/
ast_module_declaration * ast_new_module_declaration(
    ast_node_attributes * attributes,
    ast_identifier        identifier,
    ast_list            * parameters,
    ast_list            * ports,
    ast_list            * constructs
);


/*! @} */

// -------------------------------- Identifiers ------------------------------

/*!
@defgroup ast-node-identifiers Identifiers
@{
@ingroup ast-construction
@brief Functions and data structures representing identifiers for all
Verilog Constructs.
*/

/*!
@brief Describes the type of contruct that the identifier corresponds to.
*/
typedef enum ast_identifier_type_e{
    ID_ARRAYED,
    ID_BLOCK,
    ID_CELL,
    ID_CONFIG,
    ID_ESCAPED_ARRAYED,
    ID_ESCAPED_HIERARCHICAL_BRANCH,
    ID_ESCAPED_HIERARCHICAL,
    ID_ESCAPED_HIERARCHICALS,
    ID_ESCAPED,
    ID_EVENT,
    ID_EVENT_TRIGGER,
    ID_FUNCTION,
    ID_GATE_INSTANCE,
    ID_GENERATE_BLOCK,
    ID_GENVAR,
    ID_HIERARCHICAL_BLOCK,
    ID_HIERARCHICAL_EVENT,
    ID_HIERARCHICAL_FUNCTION,
    ID_HIERARCHICAL,
    ID_HIERARCHICAL_NET,
    ID_HIERARCHICAL_TASK,
    ID_HIERARCHICAL_VARIABLE,
    ID_CSV,
    ID_INOUT_PORT,
    ID_INPUT,
    ID_INPUT_PORT,
    ID_INSTANCE,
    ID_LIBRARY,
    ID_MODULE,                      //!< Declaration
    ID_MODULE_INSTANCE,             //!< Instantiation
    ID_NAME_OF_GATE_INSTANCE,
    ID_NAME_OF_INSTANCE,
    ID_NET,
    ID_OUTPUT,
    ID_OUTPUT_PORT,
    ID_PARAMETER,
    ID_PORT,
    ID_REAL,
    ID_SIMPLE_ARRAYED,
    ID_SIMPLE_HIERARCHICAL_BRANCH,
    ID_SIMPLE_HIERARCHICAL,
    ID_SIMPLE,
    ID_SPECPARAM,
    ID_SYSTEM_FUNCTION,
    ID_SYSTEM_TASK,
    ID_TASK,
    ID_TOPMODULE,
    ID_UNKNOWN,                     //!< Used when we don't know the type.
    ID_UNEXPANDED_MACRO,            //!< For when the pre-processor hasn't run.
    ID_UDP,                         //!< Declaration
    ID_UDP_INSTANCE,                //!< Instantiation
    ID_VARIABLE,
} ast_identifier_type;

//! Used to tell if an identifier has a bit vector or index attatched to it.
typedef enum ast_id_range_or_index_e{
    ID_HAS_RANGE,   //!< Has a range selector
    ID_HAS_RANGES,   //!< Has >1 range selector
    ID_HAS_INDEX,   //!< Has an index selector
    ID_HAS_NONE     //!< Has neither a range or index selector.
} ast_id_range_or_index;

/*!
@brief Structure containing all information on an identifier.
*/
struct ast_identifier_t{
    ast_metadata    meta;   //!< Node metadata.
    ast_identifier_type   type;         //!< What construct does it identify?
    char                * identifier;   //!< The identifier value.
    unsigned int          from_line;    //!< The line number of the file.
    ast_boolean           is_system;    //!< Is this a system identifier?
    ast_identifier        next;         //!< Represents a hierarchical id.
    ast_id_range_or_index range_or_idx; //!< Is it indexed or ranged?
    union{
        ast_list        * ranges; //!< For multi-dimensional arrays.
        ast_range       * range; //!< Iff range_or_idx == ID_HAS_RANGE
        ast_expression  * index; //!< Iff range_or_idx == ID_HAS_INDEX
    };
};

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
char * ast_identifier_tostring(ast_identifier id);

/*!
@brief Acts like strcmp but works on ast identifiers.
*/
int ast_identifier_cmp(
    ast_identifier a,
    ast_identifier b
);

/*!
@brief Creates and returns a new node representing an identifier.
@details By default, the returned identifier has the ID_UNKNOWN type,
and this is set later when the parser winds back up and knows which rules
to follow.
Also, the is_system member is set to false. If you want a new system
idenifier instance, use the @ref ast_new_system_identifier function.
*/
ast_identifier ast_new_identifier(
    char         * identifier,  //!< String text of the identifier.
    unsigned int   from_line    //!< THe line the idenifier came from.
);


/*!
@brief Creates and returns a new node representing an identifier.
@details By default, the returned identifier has the ID_SYSTEM_* type,
*/
ast_identifier ast_new_system_identifier(
    char         * identifier,  //!< String text of the identifier.
    unsigned int   from_line    //!< THe line the idenifier came from.
);

/*!
@brief Used to construct linked lists of hierarchical identifiers.
@details The child node is linked to the next field of the parent,
and the parent field returned.
@param [in] child - The child to add to the hierarchy.
@param [inout] parent - The parent identifier.
*/
ast_identifier ast_append_identifier(
    ast_identifier parent,
    ast_identifier child
);

/*!
@brief Used to set the range field of an identifier.
@param [inout] id - The identifier to set the range for.
@param [in] range - The range the identifier refers to.
@post Also sets the range_or_idx member to ID_HAS_RANGE
*/
void ast_identifier_set_range(
    ast_identifier    id,
    ast_range       * range
);

/*!
@brief Used to set the index field of an identifier.
@param [inout] id - The identifier to set the index for.
@param [in] index - The index the identifier refers to.
@post Also sets the range_or_idx member to ID_HAS_INDEX
*/
void ast_identifier_set_index(
    ast_identifier    id,
    ast_expression  * index
);

/*! @} */

// -------------------------------- Configuration Source ---------------------

/*!
@defgroup ast-node-configuration-source Configuration Source
@{
@ingroup ast-construction
@brief  Describes configuration constructs.
*/

//! Fully describes a config rule statemnet. See Annex 1.2
typedef struct ast_config_rule_statement_t{
    ast_metadata    meta;   //!< Node metadata.
    ast_boolean    is_default;
    ast_boolean    multiple_clauses; //<! IFF TRUE use clauses, else clause_2
    ast_identifier clause_1;    //!< The first grammar clause.
    union{
        ast_identifier clause_2;    //!< The second grammar clause.
        ast_list     * clauses;     //!< List of ast_identifier.
    };
} ast_config_rule_statement;


/*!
@brief Creates and returns a new configuration rule statment node.
@details If is_default is TRUE then clause_2 is NULL.
*/
ast_config_rule_statement * ast_new_config_rule_statement(
    ast_boolean    is_default,
    ast_identifier clause_1,    //!< The first grammar clause.
    ast_identifier clause_2     //!< The second grammar clause.
);

//! Describes a single config declaration in it's entirety.
typedef struct ast_config_declaration_t{
    ast_metadata    meta;   //!< Node metadata.
    ast_identifier  identifier;
    ast_identifier  design_statement;
    ast_list      * rule_statements;
} ast_config_declaration;

/*!
@brief Creates and returns a new config declaration node.
*/
ast_config_declaration * ast_new_config_declaration(
    ast_identifier  identifier,
    ast_identifier  design_statement,
    ast_list      * rule_statements
);

/*! @} */

// -------------------------------- Library Source Text ----------------------

/*!
@defgroup ast-node-library-source-text Library Source
@{
@ingroup ast-construction
@brief Library, config and include statements / constructs.
*/

/*!
@brief Describes a library declaration of file and include paths.
*/
typedef struct ast_library_declaration_t{
    ast_metadata    meta;   //!< Node metadata.
    ast_identifier  identifier;
    ast_list      * file_paths;
    ast_list      * incdirs;
} ast_library_declaration;

/*!
@brief Creates a new library declaration node.
*/
ast_library_declaration * ast_new_library_declaration(
    ast_identifier  identifier,
    ast_list      * file_paths,
    ast_list      * incdirs
);

//! Describes a library item.
typedef enum ast_library_item_type_e{
    LIB_LIBRARY,
    LIB_INCLUDE,
    LIB_CONFIG
} ast_library_item_type;

//! Super structure for different library construct types.
typedef struct ast_library_descriptions_t{
    ast_metadata    meta;   //!< Node metadata.
    ast_library_item_type type;
    union{
        ast_library_declaration * library;
        ast_config_declaration  * config;
        ast_string                include;
    };
} ast_library_descriptions;

//! Creates and returns a new library description object.
ast_library_descriptions * ast_new_library_description(
    ast_library_item_type type
);

/*! @} */

// -------------------------------- Compiler Directives ----------------------

/*!
@defgroup ast-node-compiler-directives Compiler Directives
@{
@ingroup ast-construction
@brief TODO
*/



/*! @} */

// -------------------------------- Grammar Top Level ------------------------

/*!
@defgroup ast-node-top-level Top Level
@{
@ingroup ast-construction
@brief Represents nodes at the very top of the source tree.
@details These nodes won't always correspond to a syntactic construct, and are
used to represent a collection of other nodes.
*/

//! Describes the type of a item in the list of source entries.
typedef enum ast_source_item_type_e{
    SOURCE_MODULE = 0,  //!< Refers to a module definition
    SOURCE_UDP    = 1   //!< A User Defined Primitive (UDP) Declaration
} ast_source_item_type;

//! Contains a source item and it's type.
typedef struct ast_source_item_t{
    ast_metadata    meta;   //!< Node metadata.
    ast_source_item_type type;  //!< Which member of the union to access.
    union{
        ast_module_declaration * module; //!< IFF type == SOURCE_MODULE
        ast_udp_declaration    * udp;   //!< IFF type == SOURCE_UDP
    };
} ast_source_item;

/*!
@brief Creates and returns a new source item representation.
@param [in] type - The type of the source item to be represented.
@note Expects the union member of the returned ast_source_item to be
set manually.
*/
ast_source_item * ast_new_source_item(ast_source_item_type type);

/*!
@brief Top level container for parsed source code.
@details All source code which the parser processes is placed inside an
instance of this object. It contains lists of all top level objects which
a verilog source file can contain.
*/
typedef struct verilog_source_tree_t{
    ast_list    *   modules;
    ast_list    *   primitives;
    ast_list    *   configs;
    ast_list    *   libraries;
} verilog_source_tree;


//! This is where we put all of the parsed constructs.
extern verilog_source_tree * yy_verilog_source_tree;


/*!
@brief Creates and returns a new, empty source tree.
@details This should be called ahead of parsing anything, so we will
have an object to put parsed constructs into.
*/
verilog_source_tree * verilog_new_source_tree();

/*!
@brief Releases a source tree object from memory.
@details Frees the top level source tree object, and all of it's child
ast_* objects by calling the ast_free_all function.
@param [in] tofree - The source tree to be free'd
*/
void verilog_free_source_tree(
    verilog_source_tree * tofree
);

// --------------------------------------------------------------

/*!
@brief Enum type describing the data value that an AST node holds.
@deprecated The AST Node was only ever temporary, don't add new stuff with it.
*/
typedef enum ast_node_type_e
{
    ATTRIBUTE_LIST, //!< A design attribute. @ref ast_node_attributes_t
    EXPRESSION,     //!< A constant or variable expression.
    IDENTIFIER,     //<! An identifier.
    MODULE,         //<! A design module.
    NONE,           //!< The node has no stored data type.
} ast_node_type;

/*!
@brief Node type that forms the tree.
@deprecated The AST Node was only ever temporary, don't add new stuff with it.
*/
struct ast_node_t
{
    ast_node     * parent;      //!< Parent node in the tree.
    unsigned int   child_count; //!< Number of children the node has.
    ast_node     * children;    //!< Linked list of children.
    ast_node_attributes * attributes;
    ast_node_type  type;        //!< Datatype of the value stored in the node.
};

/*!
@brief Creates a new empty ast_node and returns it.
@deprecated The AST Node was only ever temporary, don't add new stuff with it.
*/
ast_node * ast_node_new();


/*! @} */


#endif
