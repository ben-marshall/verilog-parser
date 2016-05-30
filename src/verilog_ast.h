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

//! Forward declare. Defines the core node type for the AST.
typedef struct ast_node_t ast_node;

//! Typedef to make it easier to change into a proper structure later.
//! @todo add proper support for hierarchical identifiers and scope.
typedef char * ast_identifier;

//! Placeholder until this is implemented properly.
typedef struct ast_concatenation_t ast_concatenation;

typedef struct ast_expression_t ast_expression;
typedef struct ast_function_call_t ast_function_call;
    
typedef void * ast_number       ;
typedef char * ast_operator     ;
typedef void * ast_minmax_exp   ;
typedef void * ast_macro_use    ;
typedef char * ast_string       ;

//! Stores the values of booleans.
typedef enum  ast_boolean_e
{
    AST_TRUE=1,
    AST_FALSE=0
} ast_boolean;

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
    ast_node            * attr_value;   //!< Value of the attribute.

    ast_node_attributes * next;         //!< Next one in a linked list.
};


/*!
@brief Creates and returns a new attribute node with the specified value
       and name.
*/
ast_node * ast_new_attribute_node( ast_node_attributes* value);

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
@ingroup ast-construction
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
    ast_operator     operation;         //!< What are we doing?
    ast_expression * left;              //!< LHS of operation
    ast_expression * right;             //!< RHS of operation
    ast_expression * aux;               //!< Optional auxiliary/predicate.
    ast_boolean      constant;          //!< True iff constant_expression.
    ast_string       string;            //!< The string constant. Valid IFF type == STRING_EXPRESSION.
    ast_primary    * primary;           //!< Valid IFF type == PRIMARY_EXPRESSION.
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
    SIMPLE_FULL_PATH
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

/*! @} */

// -------------------------------- Loop Statements --------------------------

/*!
@defgroup ast-node-loop-statements Loop Statements
@{
@ingroup ast-construction
@brief Describes for and while loop representation.
*/



/*! @} */

// -------------------------------- Case Statements --------------------------

/*!
@defgroup ast-node-case-statements Case Statements
@{
@ingroup ast-construction
@brief 
*/



/*! @} */

// -------------------------------- IF Else Statements -----------------------

/*!
@defgroup ast-node-if-else If Else Statements
@{
@ingroup ast-construction
@brief 
*/



/*! @} */

// -------------------------------- Timing Control Statements ----------------

/*!
@defgroup ast-node-timing-control Timing Control Statements
@{
@ingroup ast-construction
@brief 
*/



/*! @} */

// -------------------------------- Fork Join Sequential ---------------------

/*!
@defgroup ast-node-fork-join Fork Join
@{
@ingroup ast-construction
@brief Fork join stamements.
*/



/*! @} */

// -------------------------------- Procedural Blocks and Assignments --------

/*!
@defgroup ast-node-procedural Procedural Blocks and Assignments
@{
@ingroup ast-construction
@brief Describes items found inside procedural blocks.
*/



/*! @} */

// -------------------------------- UDP Blocks -------------------------------

/*!
@defgroup ast-node-udp-block User Defined Primitives
@{
@ingroup ast-construction
@brief User defined primitive types.
*/



/*! @} */

// -------------------------------- Generate Statements ----------------------

/*!
@defgroup ast-node-generate-statement Generate Statements
@{
@ingroup ast-construction
@brief Represents generate loops.
*/



/*! @} */

// -------------------------------- Module Instantiation ---------------------

/*!
@defgroup ast-node-module-instantiation Module Instantiation
@{
@ingroup ast-construction
@brief Describes the instantiation of a module, as opposed to it's declaration.
*/



/*! @} */

// -------------------------------- Primitives -------------------------------

/*!
@defgroup ast-node-primitives Primitives
@{
@ingroup ast-construction
@brief Digital design primitive representation. Transistors, transmission
gates, etc.
*/



/*! @} */

// -------------------------------- Task Declaration -------------------------

/*!
@defgroup ast-node-task-declaration Task Declaration
@{
@ingroup ast-construction
@brief User task (procedure) definition.
*/



/*! @} */

// -------------------------------- Function Declaration ---------------------

/*!
@defgroup ast-node-function-declaration Function Declaration
@{
@ingroup ast-construction
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
