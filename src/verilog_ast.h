/*!
@file verilog_ast.h
@brief Contains Declarations of datastructures and functions which represent
       and operate on the Verilog Abstract Syntax Tree (AST)
*/

#include <stdarg.h>
#include <stdlib.h>

#include "verilog_ast_common.h"

#ifndef VERILOG_AST_H
#define VERILOG_AST_H

//! Iterates over all allocated memory and frees it.
void ast_free_all();


//! Forward declare. Defines the core node type for the AST.
typedef struct ast_node_t ast_node;

//! Typedef to make it easier to change into a proper structure later.
//! @todo add proper support for hierarchical identifiers and scope.
typedef char * ast_identifier;

//! Placeholder until this is implemented properly.
typedef struct ast_concatenation_t ast_concatenation;

typedef struct ast_expression_t ast_expression;
typedef struct ast_function_call_t ast_function_call;
    
typedef char * ast_operator     ;
typedef char * ast_string       ;
typedef struct ast_assignment_t ast_assignment;
typedef struct ast_single_assignment_t ast_single_assignment;
typedef struct ast_generate_block_t ast_generate_block;
typedef void * ast_delay3       ;
typedef void * ast_delay2       ;
typedef void * ast_delay_value  ;
typedef void * ast_drive_strength;
typedef void * ast_macro_use    ;
typedef void * ast_minmax_exp   ;
typedef void * ast_number       ;
typedef void * ast_range        ;
typedef void * ast_output_symbol;
typedef void * ast_module_or_generate_item;

typedef struct ast_statement_t ast_statement;

//! Stores the values of booleans.
typedef enum  ast_boolean_e
{
    AST_TRUE=1,
    AST_FALSE=0
} ast_boolean;

//! Describes a rising or falling edge, or where none is specified.
typedef enum ast_edge_e{
    EDGE_POS,
    EDGE_NEG,
    EDGE_NONE,
    EDGE_ANY 
} ast_edge;

//! Describes the direction of a port
typedef enum ast_port_direction_e{
    PORT_INPUT,
    PORT_OUTPUT,
    PORT_INOUT,
    PORT_NONE,  //!< Used for when we don't know at declaration time.
} ast_port_direction;

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
    char                * attr_name;    //!< Name of the attribute
    ast_expression      * attr_value;   //!< Value of the attribute.

    ast_node_attributes * next;         //!< Next one in a linked list.
};


/*!
@brief Creates and returns a new attribute node with the specified value
       and name.
*/
ast_node * ast_new_attribute_node( ast_node_attributes* value);

/*!
@brief Creates and returns as a pointer a new attribute descriptor.
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
    CONCATENATION_EXPRESSION,
    CONCATENATION_CONSTANT_EXPRESSION,
    CONCATENATION_NET,
    CONCATENATION_VARIABLE,
    CONCATENATION_MODULE_PATH
} ast_concatenation_type;

//! Fully describes a concatenation in terms of type and data.
struct ast_concatenation_t{
    ast_concatenation_type   type;  //!< The type of concatenation
    ast_expression         * repeat;//!< The number of repetitions. Normally 1.
    ast_list               * items; //!< sequence of items.
};

/*!
@brief Creates a new AST concatenation element with the supplied type and
initial starting value.
@param [in] repeat - Used for replications or multiple_concatenation
@details Depending on the type supplied, the type of first_value
should be:
    - CONCATENATION_EXPRESSION          : ast_expression
    - CONCATENATION_CONSTANT_EXPRESSION : ast_expression
    - CONCATENATION_NET                 : TBD
    - CONCATENATION_VARIABLE            : TBD
    - CONCATENATION_MODULE_PATH         : TBD
*/
ast_concatenation * ast_new_concatenation(ast_concatenation_type type,
                                          ast_expression * repeat,
                                          void * first_value);

/*!
@brief Creates and returns a new empty concatenation of the specified type.
*/
ast_concatenation * ast_new_empty_concatenation(ast_concatenation_type type);

/*!
@brief Adds a new data element on to the *front* of a concatenation.
@details Appends to the front because this naturally follows the
behaviour of a left-recursive grammar.
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
    NET_IDENTIFIER,
    VAR_IDENTIFIER,
    GENVAR_IDENTIFIER,
    NET_CONCATENATION,
    VAR_CONCATENATION
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

//! Describes the kind of expression primary being represented.
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
    ast_number          number;
    ast_identifier      identifier;
    ast_concatenation * concatenation;
    ast_function_call * function_call;
    ast_minmax_exp      minmax;
    ast_macro_use       macro;
} ast_primary_value;

//! Stores the type and value of an AST primary expression.
typedef struct ast_primary_t
{
    ast_primary_type        primary_type;
    ast_primary_value_type  value_type;
    ast_primary_value       value;
} ast_primary;


/*!
@brief Creates a new ast primary which is part of a constant expression tree
       with the supplied type and value.
*/
ast_primary * ast_new_constant_primary(ast_primary_value_type type);

/*!
@brief Creates a new AST primary wrapper around a function call.
*/
ast_primary * ast_new_primary_function_call(ast_function_call * call);

/*!
@brief Creates a new ast primary which is part of an expression tree
       with the supplied type and value.
*/
ast_primary * ast_new_primary(ast_primary_value_type type);

/*!
@brief Creates a new ast primary which is part of a constant expression tree
       with the supplied type and value.
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
    STRING_EXPRESSION
} ast_expression_type;


/*! 
@brief Storage type for an entire expression / subexpression tree.
*/
struct ast_expression_t
{
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
@brief Creates and returns a new expression primary.
@details This is simply an expression instance wrapped around a
primary instance for the purposes of mirroring the expression tree gramamr.
Whether or not the expression is constant is denoted by the type member
of the passed primary.
*/
ast_expression * ast_new_expression_primary(ast_primary * p);

/*!
@brief Creates a new binary infix expression with the supplied operands.
*/
ast_expression * ast_new_binary_expression(ast_expression * left,
                                           ast_expression * right,
                                           ast_operator     operation,
                                           ast_node_attributes * attr,
                                           ast_boolean      constant);

/*!
@brief Creates a new unary expression with the supplied operation.
*/
ast_expression * ast_new_unary_expression(ast_expression * operand,
                                          ast_operator     operation,
                                          ast_node_attributes * attr,
                                          ast_boolean       constant);

/*!
@brief Creates a new range expression with the supplied operands.
*/
ast_expression * ast_new_range_expression(ast_expression * left,
                                          ast_expression * right);

/*!
@brief Creates a new range index expression with the supplied operands.
*/
ast_expression * ast_new_index_expression(ast_expression * left);

/*!
@brief Creates a new string expression.
*/
ast_expression * ast_new_string_expression(ast_string string);


/*!
@brief Creates a new conditional expression node. 
@note The condition is stored in the aux member, if_true in left, and if_false
on the right.
*/
ast_expression * ast_new_conditional_expression(ast_expression * condition,
                                                ast_expression * if_true,
                                                ast_expression * if_false,
                                                ast_node_attributes * attr);

/*!
@brief Creates a new (min,typical,maximum) expression.
@details If the mintypmax expression only specifies a typical value,
then the min and max arguments should be NULL, and only typ set. 
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
    ast_identifier      input_terminal;
    ast_operator        polarity;
    ast_identifier      output_terminal;
    ast_list        *   delay_value;
} ast_simple_parallel_path_declaration;


//! Describes the declaration of a path.
typedef struct ast_simple_full_path_declaration_t{
    ast_list        *   input_terminals;
    ast_operator        polarity;
    ast_list        *   output_terminals;
    ast_list        *   delay_value;
} ast_simple_full_path_declaration;


//! Describes a single edge sensitive path declaration
typedef struct ast_edge_sensitive_parallel_path_declaration_t {
    ast_edge            edge;               //!< edge_identifier
    ast_identifier      input_terminal;     //!< specify_input_terminal_descriptor
    ast_operator        polarity;           //!< polarity_operator
    ast_identifier      output_terminal;    //!< specify_output_terminal_descriptor
    ast_expression  *   data_source;        //!< data_source_expression
    ast_list        *   delay_value;        //!< path_delay_value
} ast_edge_sensitive_parallel_path_declaration;

//! Describes a parallel edge sensitive path declaration
typedef struct ast_edge_sensitive_full_path_declaration_t {
    ast_edge            edge;               //!< edge_identifier
    ast_list        *   input_terminal;     //!< list_of_path_inputs
    ast_operator        polarity;           //!< polarity_operator
    ast_list        *   output_terminal;    //!< list_of_path_outputs
    ast_expression  *   data_source;        //!< data_source_expression
    ast_list        *   delay_value;        //!< path_delay_value
} ast_edge_sensitive_full_path_declaration;

//! Struct which holds the type and data of a path declaration.
typedef struct ast_path_declaration_t{
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
    LOOP_FOR
} ast_loop_type;

//! Fully describes a single loop statement.
typedef struct ast_loop_statement_t{
    ast_loop_type   type;            //!< The type of loop
    ast_statement * inner_statement; //!< Loop body.
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
    ast_list    * conditions; //!< A list of condtions, one must be met.
    ast_statement * body;     //!< What to execute if the condition is met.
    ast_boolean     is_default; //!< This is the default item.
} ast_case_item;

//! Describes the top level of a case statement in terms of its items.
typedef struct ast_case_statement_t{
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
    ast_statement   * statement; //!< What should be executed.
    ast_expression  * condition; //!< Execute iff true.
} ast_conditional_statement;

//! Describes a complete set of if-elseif-else statements
typedef struct ast_if_else_t{
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
    ast_delay_ctrl_type type;
    union{
        ast_delay_value * value;
        ast_expression  * mintypmax;
    };
} ast_delay_ctrl;

//! Describes a single procedural timing control statement.
typedef struct ast_timing_control_statement_t{
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

typedef enum ast_assignment_type_e{
    ASSIGNMENT_CONTINUOUS,
    ASSIGNMENT_BLOCKING,
    ASSIGNMENT_NONBLOCKING,
    ASSIGNMENT_HYBRID, //!< @see ast_hybrid_assignment
} ast_assignment_type;

/*!
@brief encodes a single assignment.
*/
struct ast_single_assignment_t{
    ast_lvalue      * lval;
    ast_expression  * expression;
};

/*!
@brief Creates and returns a new continuous assignment.
*/
ast_single_assignment * ast_new_single_assignment(
    ast_lvalue * lval,
    ast_expression * expression
);

/*!
@brief Describes a set of assignments with the same drive strength and delay.
*/
typedef struct ast_continuous_assignment_t{
    ast_list            * assignments;
    ast_drive_strength  * drive_strength;
    ast_delay3          * delay;
} ast_continuous_assignment;

/*!
@brief Describes a single procedural assignment, can be blocking or nonblocking.
*/
typedef struct ast_procedural_assignment_t{
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
    union
    {
        ast_single_assignment * assignment;
        ast_lvalue            * lval;
    };
    ast_hybrid_assignment_type type;
} ast_hybrid_assignment;

//! Top level descriptor for an assignment.
struct ast_assignment_t{
    ast_assignment_type type;
    union{
        ast_continuous_assignment * continuous;
        ast_procedural_assignment * procedural;
        ast_hybrid_assignment     * hybrid;
    };
};

/*!
@brief Creates a new hybrid assignment of the specified type.
*/
ast_assignment * ast_new_hybrid_assignment(
    ast_hybrid_assignment_type type,
    ast_single_assignment * assignment
);

/*!
@brief Creates a new hybrid assignment of the specified type.
*/
ast_assignment * ast_new_hybrid_lval_assignment(
    ast_hybrid_assignment_type type,
    ast_lvalue * lval
);

/*!
@brief Creates and returns a new blocking procedural assignment object.
*/
ast_assignment * ast_new_blocking_assignment(
    ast_lvalue * lval,
    ast_expression  * expression,
    ast_timing_control_statement* delay_or_event
);

/*!
@brief Creates and returns a new nonblocking procedural assignment object.
*/
ast_assignment * ast_new_nonblocking_assignment(
    ast_lvalue * lval,
    ast_expression  * expression,
    ast_timing_control_statement * delay_or_event
);


/*!
@brief Creates and returns a new continuous assignment object.
*/
ast_assignment * ast_new_continuous_assignment(
    ast_list * assignments,
    ast_drive_strength * strength,
    ast_delay3 * delay
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
    STM_WAIT
} ast_statement_type;


/*! 
@brief Describes a single statement, and can contain sequential statement 
    blocks.
@warning The data member of the union should *never* be accessed except
when first instantiating the structure. It is used to set the data content
and nothing more. This is *very* bad practice and knowing this code is here
pains me dearly.
@todo Write 10 functions which set the correct type of the statement and
accept only corresponding valid types as the data argument.
*/
struct ast_statement_t{
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
    ast_identifier    output_port;
    ast_number      * initial_value;
} ast_udp_initial_statement;

//! Describes a single UDP body sequentially or combinatorially.
typedef struct ast_udp_body_t{
    ast_list *        entries;    
    ast_udp_initial_statement * initial; //!< IFF body_type = sequential
    ast_udp_body_type body_type;
} ast_udp_body;

//! Describes a single combinatorial entry in the UDP ast tree.
typedef struct ast_udp_combinatorial_entry_t{
    ast_list * input_levels;
    ast_udp_next_state  output_symbol;
} ast_udp_combinatorial_entry;

//! describes a sequential entry in a udp body.
typedef struct ast_udp_sequential_entry_t{
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
    ast_identifier        identifier;
    ast_node_attributes * attributes;
    ast_list            * ports;
    ast_list            * body_entries;    
    ast_udp_initial_statement * initial; //!< IFF body_type = sequential
    ast_udp_body_type     body_type;
} ast_udp_declaration;

//! Describes a single instance of a UDP
typedef struct ast_udp_instance_t{
    ast_identifier        identifier;
    ast_range           * range;
    ast_lvalue          * output;
    ast_list            * inputs;
} ast_udp_instance;

//! Describes an a list of instances of a particular kind of UDP.
typedef struct ast_udp_instantiation_t{
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
*/
typedef struct ast_module_instantiation_t {
    ast_identifier          module_identifer; //!< The module being instanced.
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
    ast_switchtype type;
    union {
        ast_delay3 delay3;
        ast_delay2 delay2; //!< IFF type == TRAN or RTRAN
    };
} ast_switch_gate;

//! Instances a new switch type with a delay3.
ast_switch_gate * ast_new_switch_gate_d3(
    ast_switchtype type,
    ast_delay3     delay
);

//! Instances a new switch type with a delay2.
ast_switch_gate * ast_new_switch_gate_d2(
    ast_switchtype type,
    ast_delay2     delay
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

//! Describes the pull strength and direction of a primitive.
typedef struct ast_primitive_pull_strength_t{
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
    ast_identifier      name;
    ast_lvalue        * output_terminal;
} ast_pull_gate_instance;

//! A single pass transistor instance.
typedef struct ast_pass_switch_instance_t{
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
    ast_identifier      name;
    ast_list          * input_terminals;
    ast_lvalue        * output_terminal;
} ast_n_input_gate_instance;

//! A single MOS switch (transistor) instance.
typedef struct ast_mos_switch_instance_t{
    ast_identifier      name;
    ast_lvalue        * output_terminal;
    ast_expression    * enable_terminal;
    ast_expression    * input_terminal;
} ast_mos_switch_instance;

//! A single CMOS switch (transistor) instance.
typedef struct ast_cmos_switch_instance_t{
    ast_identifier      name;
    ast_lvalue        * output_terminal;
    ast_expression    * ncontrol_terminal;
    ast_expression    * pcontrol_terminal;
    ast_expression    * input_terminal;
} ast_cmos_switch_instance;

//! A single pass enable switch with pass and enable terminals.
typedef struct ast_pass_enable_switch_t{
    ast_identifier    * name;
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
    ast_pass_enable_switchtype    type;
    ast_delay2                    delay;
    ast_list                    * switches;
} ast_pass_enable_switches;

/*!
@brief Creates and returns a collection of pass enable switches.
*/
ast_pass_enable_switches * ast_new_pass_enable_switches(
    ast_pass_enable_switchtype    type,
    ast_delay2                    delay,
    ast_list                    * switches 
);

/*!
@brief Creates and returns a new pass enable switch instance.
*/
ast_pass_enable_switch * ast_new_pass_enable_switch(
    ast_identifier    * name,
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


/*! @} */

// -------------------------------- Task Declaration -------------------------

/*!
@defgroup ast-node-task-declaration Task Declaration
@{
@ingroup ast-node-module-items
@brief User task (procedure) definition.
*/



/*! @} */

// -------------------------------- Function Declaration ---------------------

/*!
@defgroup ast-node-function-declaration Function Declaration
@{
@ingroup ast-node-module-items
@brief Describes a declaration of a user function.
*/



/*! @} */

// -------------------------------- Declaration Lists ------------------------

/*!
@defgroup ast-node-declaration-lists Declaration Lists
@{
@ingroup ast-construction
@brief 
*/



/*! @} */

// -------------------------------- Delays -----------------------------------

/*!
@defgroup ast-node-delays Delays
@{
@ingroup ast-construction
@brief Signal propagation delays
*/



/*! @} */

// -------------------------------- Strengths --------------------------------

/*!
@defgroup ast-node-strengths Drive Strengths
@{
@ingroup ast-construction
@brief Describes signal drive strengths.
*/



/*! @} */

// -------------------------------- Nets and Variables -----------------------

/*!
@defgroup ast-node-net-variables Nets and Variables
@{
@ingroup ast-construction
@brief Net and variable types, declarations and assignments.
*/



/*! @} */

// -------------------------------- Type Declarations ------------------------

/*!
@defgroup ast-node-type-declaration Type Declaration
@{
@ingroup ast-construction
@brief Custom type declarations.
*/



/*! @} */

// -------------------------------- Port Declarations ------------------------

/*!
@defgroup ast-node-port-declarations Module Port Declaration
@{
@ingroup ast-node-module-declaration
@brief 
*/



/*! @} */

// -------------------------------- Module Parameters ------------------------

/*!
@defgroup ast-node-module-parameters Module Parameters
@{
@ingroup ast-node-module-declaration
@brief 
*/



/*! @} */

// -------------------------------- Module Items -----------------------------

/*!
@defgroup ast-node-module-items Module Items
@{
@ingroup ast-node-module-declaration
@brief Contains things like continuous assignments, procedural blocks and
module instantiations.
*/



/*! @} */

// -------------------------------- Module Declarations ----------------------

/*!
@defgroup ast-node-module-declaration Module Declaration
@{
@ingroup ast-construction
@brief Details declaration of module ports and parameters.
*/



/*! @} */

// -------------------------------- Configuration Source ---------------------

/*!
@defgroup ast-node-configuration-source Configuration Source
@{
@ingroup ast-construction
@brief 
*/



/*! @} */

// -------------------------------- Library Source Text ----------------------

/*!
@defgroup ast-node-library-source-text Library Source
@{
@ingroup ast-construction
@brief 
*/



/*! @} */

// -------------------------------- Compiler Directives ----------------------

/*!
@defgroup ast-node-compiler-directives Compiler Directives
@{
@ingroup ast-construction
@brief 
*/



/*! @} */

// -------------------------------- Grammar Top Level ------------------------

/*!
@defgroup ast-node-top-level Top Level
@{
@ingroup ast-construction
@brief 
*/

/*!
@brief Stores the various data values that a node in the AST can represent.
*/
typedef union ast_value_u 
{
    int     integer;
    float   real;
    char  * string;
    ast_node_attributes * attributes;
}ast_value;

/*!
@brief Enum type describing the data value that an AST node holds.
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
*/
struct ast_node_t
{
    ast_node     * parent;      //!< Parent node in the tree.
    unsigned int   child_count; //!< Number of children the node has.
    ast_node     * children;    //!< Linked list of children.

    ast_value      value;       //!< Data value of the node.
    ast_node_type  type;        //!< Datatype of the value stored in the node.
};

/*!
@brief Creates a new empty ast_node and returns it.
*/
ast_node * ast_node_new();
    
/*!
@brief Creates and returns a new node for the tree which contains a
       single simple identifier.
*/
ast_node * ast_new_identifier_node(char * identifier);


/*! @} */


#endif
