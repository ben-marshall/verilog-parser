%require  "3.0"
%defines 
%define parse.trace
%verbose


%define parse.error verbose

%{
    #include <stdio.h>
    #include <string.h>
    #include <assert.h>

    #include "verilog_ast.h"

    extern int yylex();
    extern int yylineno;
    extern char * yytext;

    void yyerror(const char *msg){
        printf("line %d - ERROR: %s\n", yylineno,msg);
        printf("- '%s'\n", yytext);
    }
%}

%code requires{
    #include "verilog_ast.h"
}


/* token types */
%union {
    ast_assignment               * assignment;
    ast_block_item_declaration   * block_item_declaration;
    ast_block_reg_declaration    * block_reg_declaration;
    ast_case_item                * case_item;
    ast_case_statement           * case_statement;
    ast_charge_strength            charge_strength;
    ast_cmos_switch_instance     * cmos_switch_instance ;
    ast_concatenation            * concatenation;
    ast_config_rule_statement    * config_rule_statement;
    ast_config_declaration       * config_declaration;
    ast_library_declaration      * library_declaration;
    ast_library_descriptions     * library_descriptions;
    ast_delay2                   * delay2;
    ast_delay3                   * delay3;
    ast_delay_ctrl               * delay_control;
    ast_delay_value              * delay_value;
    ast_disable_statement        * disable_statement;
    ast_drive_strength           * drive_strength;
    ast_edge                       edge;
    ast_enable_gate_instance     * enable_gate;
    ast_enable_gate_instances    * enable_gates;
    ast_enable_gatetype            enable_gatetype;
    ast_event_control            * event_control;
    ast_event_expression         * event_expression;
    ast_expression               * expression;
    ast_function_call            * call_function;
    ast_function_declaration     * function_declaration;
    ast_function_item_declaration* function_or_task_item;
    ast_gate_instantiation       * gate_instantiation;
    ast_gatetype_n_input           n_input_gatetype;
    ast_generate_block           * generate_block;
    ast_identifier                 identifier;
    ast_if_else                  * ifelse;
    ast_level_symbol               level_symbol;
    ast_list                     * list;
    ast_loop_statement           * loop_statement;
    ast_lvalue                   * lvalue;
    ast_module_declaration       * module_declaration;
    ast_module_instance          * module_instance;
    ast_module_instantiation     * module_instantiation;
    ast_module_item              * module_item;
    ast_mos_switch_instance      * mos_switch_instance  ;
    ast_n_input_gate_instance    * n_input_gate_instance;
    ast_n_input_gate_instances   * n_input_gate_instances;
    ast_n_output_gate_instance   * n_output_gate_instance;
    ast_n_output_gate_instances  * n_output_gate_instances;
    ast_n_output_gatetype          n_output_gatetype;
    ast_net_type                   net_type;
    ast_node                     * node;
    ast_node_attributes          * node_attributes;
    ast_operator                   operator;
    ast_parameter_declarations   * parameter_declaration;
    ast_parameter_type             parameter_type;
    ast_pass_enable_switch       * pass_enable_switch   ;
    ast_pass_enable_switches     * pass_enable_switches;
    ast_pass_switch_instance     * pass_switch_instance ;
    ast_path_declaration         * path_declaration;
    ast_port_connection          * port_connection;
    ast_port_declaration         * port_declaration;
    ast_port_direction             port_direction;
    ast_primary                  * primary;
    ast_primitive_pull_strength  * primitive_pull;
    ast_primitive_strength         primitive_strength;
    ast_pull_gate_instance       * pull_gate_instance   ;
    ast_pulse_control_specparam  * pulse_control_specparam;
    ast_range                    * range;
    ast_range_or_type            * range_or_type;
    ast_single_assignment        * single_assignment;
    ast_source_item              * source_item;
    ast_statement                * generate_item;
    ast_statement                * statement;
    ast_statement_block          * statement_block;
    ast_switch_gate              * switch_gate;
    ast_task_declaration         * task_declaration;
    ast_task_enable_statement    * task_enable_statement;
    ast_task_port                * task_port;
    ast_task_port_type             task_port_type;
    ast_timing_control_statement * timing_control_statement;
    ast_type_declaration         * type_declaration;
    ast_udp_body                 * udp_body;
    ast_udp_combinatorial_entry  * udp_combinatorial_entry;
    ast_udp_declaration          * udp_declaration;
    ast_udp_initial_statement    * udp_initial;
    ast_udp_instance             * udp_instance;
    ast_udp_instantiation        * udp_instantiation;
    ast_udp_next_state             udp_next_state;
    ast_udp_port                 * udp_port;
    ast_udp_sequential_entry     * udp_seqential_entry;
    ast_wait_statement           * wait_statement;

    char                   boolean;
    char                 * string;
    ast_number           * number;
    char                 * term;
    char                 * keyword;
}

%token <string> ANY
%token END
%token <string> NEWLINE
%token <string> SPACE
%token <string> TAB

%token <string> AT
%token <string> COMMA
%token <string> HASH               
%token <string> DOT                
%token <string> EQ
%token <string> COLON              
%token <string> IDX_PRT_SEL
%token <string> SEMICOLON          
%token <string> OPEN_BRACKET       
%token <string> CLOSE_BRACKET      
%token <string> OPEN_SQ_BRACKET    
%token <string> CLOSE_SQ_BRACKET   
%token <string> OPEN_SQ_BRACE      
%token <string> CLOSE_SQ_BRACE     

%token <string> BIN_VALUE
%token <string> OCT_VALUE
%token <string> HEX_VALUE

%token <string> DEC_BASE
%token <string> BIN_BASE
%token <string> OCT_BASE
%token <string> HEX_BASE

%token <string> NUM_REAL
%token <string> NUM_SIZE
%token <string> UNSIGNED_NUMBER

%type  <number> decimal_number
%type  <number> binary_number
%type  <number> hex_number
%type  <number> octal_number
%type  <number> real_number

%token <identifier> SYSTEM_ID
%token <identifier> SIMPLE_ID
%token <identifier> ESCAPED_ID
%token <identifier> DEFINE_ID

%token <string> ATTRIBUTE_START
%token <string> ATTRIBUTE_END

%token <string> COMMENT_LINE
%token <string> COMMENT_BLOCK

%token <string> STRING

/* Operators Precedence */

%token <operator> STAR
%token <operator> PLUS
%token <operator> MINUS
%token <operator> ASL     
%token <operator> ASR     
%token <operator> LSL     
%token <operator> LSR     
%token <operator> DIV     
%token <operator> POW     
%token <operator> MOD     
%token <operator> GTE     
%token <operator> LTE     
%token <operator> GT      
%token <operator> LT      
%token <operator> L_NEG   
%token <operator> L_AND   
%token <operator> L_OR    
%token <operator> C_EQ    
%token <operator> L_EQ    
%token <operator> C_NEQ   
%token <operator> L_NEQ   
%token <operator> B_NEG   
%token <operator> B_AND   
%token <operator> B_OR    
%token <operator> B_XOR   
%token <operator> B_EQU   
%token <operator> B_NAND  
%token <operator> B_NOR   
%token <operator> TERNARY 

%token <operator> UNARY_OP

/* Operator Precedence */


%right  TERNARY                 /* Lowest Precedence */
%left   L_OR
%left   L_AND
%left   B_OR B_NOR
%left   B_EQU B_XOR
%left   B_NAND B_AND
%left   L_EQ C_EQ L_NEQ C_NEQ
%left   GT LT GTE LTE
%left   LSL LSR ASR ASL
%left   PLUS MINUS
%left   STAR DIV MOD
%left   POW
%right  L_NEG B_NEG UNARY_OP    /* Highest Precedence. */


/* Compiler / Preprocessor tokens */

%token <string>     MACRO_TEXT
%token <identifier> MACRO_IDENTIFIER

%token <keyword> KW_ALWAYS
%token <keyword> KW_AND
%token <keyword> KW_ASSIGN
%token <keyword> KW_AUTOMATIC
%token <keyword> KW_BEGIN
%token <keyword> KW_BUF
%token <keyword> KW_BUFIF0
%token <keyword> KW_BUFIF1
%token <keyword> KW_CASE
%token <keyword> KW_CASEX
%token <keyword> KW_CASEZ
%token <keyword> KW_CELL
%token <keyword> KW_CMOS
%token <keyword> KW_CONFIG
%token <keyword> KW_DEASSIGN
%token <keyword> KW_DEFAULT
%token <keyword> KW_DEFPARAM
%token <keyword> KW_DESIGN
%token <keyword> KW_DISABLE
%token <keyword> KW_EDGE
%token <keyword> KW_ELSE
%token <keyword> KW_END
%token <keyword> KW_ENDCASE
%token <keyword> KW_ENDCONFIG
%token <keyword> KW_ENDFUNCTION
%token <keyword> KW_ENDGENERATE
%token <keyword> KW_ENDMODULE
%token <keyword> KW_ENDPRIMITIVE
%token <keyword> KW_ENDSPECIFY
%token <keyword> KW_ENDTABLE
%token <keyword> KW_ENDTASK
%token <keyword> KW_EVENT
%token <keyword> KW_FOR
%token <keyword> KW_FORCE
%token <keyword> KW_FOREVER
%token <keyword> KW_FORK
%token <keyword> KW_FUNCTION
%token <keyword> KW_GENERATE
%token <keyword> KW_GENVAR
%token <keyword> KW_HIGHZ0
%token <keyword> KW_HIGHZ1
%token <keyword> KW_IF
%token <keyword> KW_IFNONE
%token <keyword> KW_INCDIR
%token <keyword> KW_INCLUDE
%token <keyword> KW_INITIAL
%token <keyword> KW_INOUT
%token <keyword> KW_INPUT
%token <keyword> KW_INSTANCE
%token <keyword> KW_INTEGER
%token <keyword> KW_JOIN
%token <keyword> KW_LARGE
%token <keyword> KW_LIBLIST
%token <keyword> KW_LIBRARY
%token <keyword> KW_LOCALPARAM
%token <keyword> KW_MACROMODULE
%token <keyword> KW_MEDIUM
%token <keyword> KW_MODULE
%token <keyword> KW_NAND
%token <keyword> KW_NEGEDGE
%token <keyword> KW_NMOS
%token <keyword> KW_NOR
%token <keyword> KW_NOSHOWCANCELLED
%token <keyword> KW_NOT
%token <keyword> KW_NOTIF0
%token <keyword> KW_NOTIF1
%token <keyword> KW_OR
%token <keyword> KW_OUTPUT
%token <keyword> KW_PARAMETER
%token <keyword> KW_PATHPULSE
%token <keyword> KW_PMOS
%token <keyword> KW_POSEDGE
%token <keyword> KW_PRIMITIVE
%token <keyword> KW_PULL0
%token <keyword> KW_PULL1
%token <keyword> KW_PULLDOWN
%token <keyword> KW_PULLUP
%token <keyword> KW_PULSESTYLE_ONEVENT
%token <keyword> KW_PULSESTYLE_ONDETECT
%token <keyword> KW_RCMOS
%token <keyword> KW_REAL
%token <keyword> KW_REALTIME
%token <keyword> KW_REG
%token <keyword> KW_RELEASE
%token <keyword> KW_REPEAT
%token <keyword> KW_RNMOS
%token <keyword> KW_RPMOS
%token <keyword> KW_RTRAN
%token <keyword> KW_RTRANIF0
%token <keyword> KW_RTRANIF1
%token <keyword> KW_SCALARED
%token <keyword> KW_SHOWCANCELLED
%token <keyword> KW_SIGNED
%token <keyword> KW_SMALL
%token <keyword> KW_SPECIFY
%token <keyword> KW_SPECPARAM
%token <keyword> KW_STRONG0
%token <keyword> KW_STRONG1
%token <keyword> KW_SUPPLY0
%token <keyword> KW_SUPPLY1
%token <keyword> KW_TABLE
%token <keyword> KW_TASK
%token <keyword> KW_TIME
%token <keyword> KW_TRAN
%token <keyword> KW_TRANIF0
%token <keyword> KW_TRANIF1
%token <keyword> KW_TRI
%token <keyword> KW_TRI0
%token <keyword> KW_TRI1
%token <keyword> KW_TRIAND
%token <keyword> KW_TRIOR
%token <keyword> KW_TRIREG
%token <keyword> KW_UNSIGNED
%token <keyword> KW_USE
%token <keyword> KW_VECTORED
%token <keyword> KW_WAIT
%token <keyword> KW_WAND
%token <keyword> KW_WEAK0
%token <keyword> KW_WEAK1
%token <keyword> KW_WHILE
%token <keyword> KW_WIRE
%token <keyword> KW_WOR
%token <keyword> KW_XNOR
%token <keyword> KW_XOR

%start grammar_begin

%type   <assignment>                 blocking_assignment
%type   <assignment>                 continuous_assign
%type   <assignment>                 nonblocking_assignment
%type   <assignment>                 procedural_continuous_assignments
%type   <block_item_declaration>     block_item_declaration
%type   <block_reg_declaration>      block_reg_declaration
%type   <boolean>                    automatic_o
%type   <boolean>                    reg_o
%type   <boolean>                    signed_o
%type   <call_function>              constant_function_call
%type   <call_function>              constant_function_call_pid
%type   <call_function>              function_call
%type   <call_function>              system_function_call
%type   <case_item>                  case_item
%type   <case_item>                  function_case_item
%type   <case_item>                  genvar_case_item
%type   <case_statement>             case_statement
%type   <case_statement>             function_case_statement
%type   <case_statement>             generate_case_statement
%type   <charge_strength>            charge_strength
%type   <cmos_switch_instance>       cmos_switch_instance
%type   <concatenation>              concatenation
%type   <concatenation>              concatenation_cont
%type   <concatenation>              constant_concatenation
%type   <concatenation>              constant_concatenation_cont
%type   <concatenation>              constant_multiple_concatenation
%type   <concatenation>              modpath_concatenation_cont
%type   <concatenation>              module_path_concatenation
%type   <concatenation>              module_path_multiple_concatenation
%type   <concatenation>              multiple_concatenation
%type   <concatenation>              net_concatenation
%type   <concatenation>              net_concatenation_cont
%type   <concatenation>              net_concatenation_value
%type   <concatenation>              variable_concatenation
%type   <concatenation>              variable_concatenation_cont
%type   <concatenation>              variable_concatenation_value
%type   <config_declaration>         config_declaration
%type   <config_rule_statement>      config_rule_statement
%type   <delay2>                     delay2
%type   <delay2>                     delay2_o
%type   <delay3>                     delay3
%type   <delay3>                     delay3_o
%type   <delay_control>              delay_control
%type   <delay_value>                delay_value
%type   <disable_statement>          disable_statement
%type   <drive_strength>             drive_strength
%type   <drive_strength>             drive_strength_o
%type   <edge>                       edge_identifier
%type   <edge>                       edge_identifier_o
%type   <edge>                       edge_indicator
%type   <edge>                       edge_symbol
%type   <enable_gate>                enable_gate_instance
%type   <enable_gates>               gate_enable
%type   <enable_gatetype>            enable_gatetype
%type   <event_control>              event_control
%type   <event_expression>           event_expression
%type   <expression>                 conditional_expression
%type   <expression>                 constant_expression
%type   <expression>                 constant_mintypmax_expression
%type   <expression>                 constant_range_expression
%type   <expression>                 data_source_expression
%type   <expression>                 enable_terminal
%type   <expression>                 eq_const_exp_o
%type   <expression>                 error_limit_value
%type   <expression>                 error_limit_value_o
%type   <expression>                 expression
%type   <expression>                 expression_o
%type   <expression>                 input_terminal
%type   <expression>                 limit_value
%type   <expression>                 mintypmax_expression
%type   <expression>                 module_path_conditional_expression
%type   <expression>                 module_path_expression
%type   <expression>                 module_path_mintypemax_expression
%type   <expression>                 ncontrol_terminal
%type   <expression>                 ordered_parameter_assignment
%type   <expression>                 ordered_port_connection
%type   <expression>                 path_delay_expression
%type   <expression>                 pcontrol_terminal
%type   <expression>                 range_expression
%type   <expression>                 reject_limit_value
%type   <function_declaration>       function_declaration
%type   <function_or_task_item>      function_item_declaration
%type   <function_or_task_item>      task_item_declaration
%type   <gate_instantiation>         gate_instantiation
%type   <generate_block>             generate_block
%type   <generate_block>             generated_instantiation
%type   <generate_item>              generate_item
%type   <generate_item>              generate_item_or_null
%type   <identifier>                 arrayed_identifier
%type   <identifier>                 attr_name
%type   <identifier>                 block_identifier
%type   <identifier>                 block_variable_type
%type   <identifier>                 cell_clause
%type   <identifier>                 cell_identifier
%type   <identifier>                 config_identifier
%type   <identifier>                 design_statement
%type   <identifier>                 escaped_arrayed_identifier
%type   <identifier>                 escaped_hierarchical_branch
%type   <identifier>                 escaped_hierarchical_identifier
%type   <identifier>                 escaped_hierarchical_identifiers
%type   <identifier>                 escaped_identifier
%type   <identifier>                 event_identifier
%type   <identifier>                 event_trigger
%type   <identifier>                 function_identifier
%type   <identifier>                 gate_instance_identifier
%type   <identifier>                 generate_block_identifier
%type   <identifier>                 genvar_identifier
%type   <identifier>                 hierarchical_block_identifier
%type   <identifier>                 hierarchical_event_identifier
%type   <identifier>                 hierarchical_function_identifier
%type   <identifier>                 hierarchical_identifier
%type   <identifier>                 hierarchical_net_identifier
%type   <identifier>                 hierarchical_task_identifier
%type   <identifier>                 hierarchical_variable_identifier
%type   <identifier>                 identifier
%type   <list>                       identifier_csv
%type   <identifier>                 inout_port_identifier
%type   <identifier>                 input_identifier
%type   <identifier>                 input_port_identifier
%type   <identifier>                 inst_clause
%type   <identifier>                 inst_name
%type   <identifier>                 instance_identifier
%type   <identifier>                 instance_identifier_os
%type   <identifier>                 lib_cell_identifier_os
%type   <identifier>                 library_identifier
%type   <identifier>                 module_identifier
%type   <identifier>                 module_instance_identifier
%type   <identifier>                 name_of_gate_instance
%type   <identifier>                 name_of_instance
%type   <identifier>                 net_identifier
%type   <identifier>                 output_identifier
%type   <identifier>                 output_port_identifier
%type   <identifier>                 parameter_identifier
%type   <identifier>                 port
%type   <identifier>                 port_identifier
%type   <identifier>                 port_reference
%type   <identifier>                 real_identifier
%type   <identifier>                 real_type
%type   <identifier>                 simple_arrayed_identifier
%type   <identifier>                 simple_hierarchical_branch
%type   <identifier>                 simple_hierarchical_identifier
%type   <identifier>                 simple_identifier
%type   <identifier>                 specify_input_terminal_descriptor
%type   <identifier>                 specify_output_terminal_descriptor
%type   <identifier>                 specparam_identifier
%type   <identifier>                 system_function_identifier
%type   <identifier>                 system_task_identifier
%type   <identifier>                 task_identifier
%type   <identifier>                 text_macro_usage
%type   <identifier>                 topmodule_identifier
%type   <identifier>                 udp_identifier
%type   <identifier>                 udp_instance_identifier
%type   <identifier>                 use_clause
%type   <identifier>                 variable_identifier
%type   <identifier>                 variable_type
%type   <ifelse>                     conditional_statement
%type   <ifelse>                     function_conditional_statement
%type   <ifelse>                     function_if_else_if_statement
%type   <ifelse>                     generate_conditional_statement
%type   <ifelse>                     if_else_if_statement
%type   <level_symbol>               level_symbol
%type   <library_declaration>        library_declaration
%type   <library_descriptions>       library_descriptions
%type   <list>                       block_item_declarations
%type   <list>                       case_items
%type   <list>                       cmos_switch_instances
%type   <list>                       combinational_entrys
%type   <list>                       config_rule_statement_os
%type   <list>                       constant_expressions
%type   <list>                       dimensions
%type   <list>                       dimensions_o
%type   <list>                       edge_input_list
%type   <list>                       else_if_statements
%type   <list>                       enable_gate_instances
%type   <list>                       expressions
%type   <list>                       expressions_o
%type   <list>                       file_path_specs
%type   <list>                       function_case_items
%type   <list>                       function_else_if_statements
%type   <list>                       function_item_declarations
%type   <list>                       function_port_list
%type   <list>                       function_statements
%type   <list>                       function_statements_o
%type   <list>                       gate_n_output_a_id
%type   <list>                       generate_items
%type   <list>                       genvar_case_items
%type   <list>                       grammar_begin
%type   <list>                       input_port_identifiers
%type   <list>                       input_terminals
%type   <list>                       level_symbols
%type   <list>                       level_symbols_o
%type   <list>                       liblist_clause
%type   <list>                       library_identifier_os
%type   <list>                       library_text
%type   <list>                       list_of_actual_arguments
%type   <list>                       list_of_block_variable_identifiers
%type   <list>                       list_of_event_identifiers
%type   <list>                       list_of_genvar_identifiers
%type   <list>                       list_of_net_assignments
%type   <list>                       list_of_net_decl_assignments
%type   <list>                       list_of_net_identifiers
%type   <list>                       list_of_param_assignments
%type   <list>                       list_of_parameter_assignments
%type   <list>                       list_of_path_delay_expressions
%type   <list>                       list_of_path_inputs
%type   <list>                       list_of_path_outputs
%type   <list>                       list_of_port_connections
%type   <list>                       list_of_port_declarations
%type   <list>                       list_of_port_identifiers
%type   <list>                       list_of_ports
%type   <list>                       list_of_real_identifiers
%type   <list>                       list_of_specparam_assignments
%type   <list>                       list_of_variable_identifiers
%type   <list>                       list_of_variable_port_identifiers
%type   <list>                       module_instances
%type   <list>                       module_item_os
%type   <list>                       module_parameter_port_list
%type   <list>                       module_params
%type   <list>                       mos_switch_instances
%type   <list>                       n_input_gate_instances
%type   <list>                       n_output_gate_instances
%type   <list>                       named_parameter_assignments
%type   <list>                       named_port_connections
%type   <list>                       non_port_module_item_os
%type   <list>                       ordered_parameter_assignments
%type   <list>                       ordered_port_connections
%type   <list>                       output_terminals
%type   <list>                       parameter_override
%type   <list>                       parameter_value_assignment
%type   <list>                       parameter_value_assignment_o
%type   <list>                       pass_enable_switch_instances
%type   <list>                       pass_switch_instances
%type   <list>                       path_delay_value
%type   <list>                       port_declarations
%type   <list>                       port_expression
%type   <list>                       ports
%type   <list>                       pull_gate_instances
%type   <list>                       sequential_entrys
%type   <list>                       source_text
%type   <list>                       specify_block
%type   <list>                       specify_items
%type   <list>                       specify_items_o
%type   <list>                       sq_bracket_constant_expressions
%type   <list>                       sq_bracket_expressions
%type   <list>                       statements
%type   <list>                       statements_o
%type   <list>                       task_item_declarations
%type   <list>                       task_port_list
%type   <list>                       tf_input_declarations
%type   <list>                       udp_declaration_port_list
%type   <list>                       udp_input_declarations
%type   <list>                       udp_instances
%type   <list>                       udp_port_declarations
%type   <list>                       udp_port_list
%type   <loop_statement>             function_loop_statement
%type   <loop_statement>             generate_loop_statement
%type   <loop_statement>             loop_statement
%type   <lvalue>                     inout_terminal
%type   <lvalue>                     net_lvalue
%type   <lvalue>                     output_terminal
%type   <lvalue>                     variable_lvalue
%type   <module_declaration>         module_declaration
%type   <module_instance>            module_instance
%type   <module_instantiation>       module_instantiation
%type   <module_item>                module_item
%type   <module_item>                module_or_generate_item
%type   <module_item>                module_or_generate_item_declaration
%type   <module_item>                non_port_module_item
%type   <mos_switch_instance>        mos_switch_instance
%type   <n_input_gate_instance>      n_input_gate_instance
%type   <n_input_gate_instances>     gate_n_input
%type   <n_input_gatetype>           gatetype_n_input
%type   <n_output_gate_instance>     n_output_gate_instance
%type   <n_output_gate_instances>    gate_n_output
%type   <n_output_gatetype>          gatetype_n_output
%type   <net_type>                   net_type
%type   <net_type>                   net_type_o
%type   <node>                       actual_argument
%type   <node>                       pulsestyle_declaration
%type   <node>                       showcancelled_declaration
%type   <node>                       specify_item
%type   <node>                       system_timing_check
%type   <node_attributes>            attr_spec
%type   <node_attributes>            attr_specs
%type   <node_attributes>            attribute_instances
%type   <node_attributes>            list_of_attribute_instances
%type   <number>                     init_val
%type   <number>                     number
%type   <number>                     unsigned_number
%type   <operator>                   binary_module_path_operator
%type   <operator>                   polarity_operator
%type   <operator>                   polarity_operator_o
%type   <operator>                   unary_module_path_operator
%type   <operator>                   unary_operator
%type   <parameter_declaration>      local_parameter_declaration
%type   <parameter_declaration>      parameter_declaration
%type   <parameter_declaration>      specparam_declaration
%type   <parameter_type>             output_variable_type
%type   <parameter_type>             output_variable_type_o
%type   <pass_enable_switch>         pass_enable_switch_instance
%type   <pass_enable_switches>       gate_pass_en_switch
%type   <pass_switch_instance>       pass_switch_instance
%type   <path_declaration>           edge_sensitive_path_declaration
%type   <path_declaration>           path_declaration
%type   <path_declaration>           simple_path_declaration
%type   <path_declaration>           state_dependent_path_declaration
%type   <port_connection>            named_parameter_assignment
%type   <port_connection>            named_port_connection
%type   <port_declaration>           inout_declaration
%type   <port_declaration>           input_declaration
%type   <port_declaration>           output_declaration
%type   <port_declaration>           port_declaration
%type   <port_declaration>           port_declaration_l
%type   <port_direction>             port_dir
%type   <primary>                    constant_primary
%type   <primary>                    module_path_primary
%type   <primary>                    primary
%type   <primitive_pull>             pulldown_strength
%type   <primitive_pull>             pulldown_strength_o
%type   <primitive_pull>             pullup_strength
%type   <primitive_pull>             pullup_strength_o
%type   <primitive_strength>         strength0
%type   <primitive_strength>         strength1
%type   <pull_gate_instance>         pull_gate_instance
%type   <pulse_control_specparam>    pulse_control_specparam
%type   <range>                      dimension
%type   <range>                      range
%type   <range>                      range_o
%type   <range_or_type>              range_or_type
%type   <range_or_type>              range_or_type_o
%type   <single_assignment>          function_blocking_assignment
%type   <single_assignment>          genvar_assignment
%type   <single_assignment>          net_assignment
%type   <single_assignment>          net_decl_assignment
%type   <single_assignment>          param_assignment
%type   <single_assignment>          specparam_assignment
%type   <single_assignment>          variable_assignment
%type   <source_item>                description
%type   <statement>                  always_construct
%type   <statement>                  function_statement
%type   <statement>                  function_statement_or_null
%type   <statement>                  initial_construct
%type   <statement>                  statement
%type   <statement>                  statement_or_null
%type   <statement_block>            function_seq_block
%type   <statement_block>            par_block
%type   <statement_block>            seq_block
%type   <string>                     anys
%type   <string>                     block_comment
%type   <string>                     comment
%type   <string>                     file_path
%type   <string>                     file_path_spec
%type   <string>                     include_statement
%type   <string>                     one_line_comment
%type   <string>                     string
%type   <string>                     white_space
%type   <switch_gate>                cmos_switchtype
%type   <switch_gate>                mos_switchtype
%type   <switch_gate>                pass_switchtype
%type   <task_declaration>           task_declaration
%type   <task_enable_statement>      system_task_enable
%type   <task_enable_statement>      task_enable
%type   <task_port>                  task_port_item
%type   <task_port>                  tf_inout_declaration
%type   <task_port>                  tf_input_declaration
%type   <task_port>                  tf_output_declaration
%type   <task_port_type>             task_port_type
%type   <task_port_type>             task_port_type_o
%type   <timing_control_statement>   delay_or_event_control
%type   <timing_control_statement>   delay_or_event_control_o
%type   <timing_control_statement>   procedural_timing_control_statement
%type   <type_declaration>           event_declaration
%type   <type_declaration>           genvar_declaration
%type   <type_declaration>           integer_declaration
%type   <type_declaration>           net_dec_p_delay
%type   <type_declaration>           net_dec_p_ds
%type   <type_declaration>           net_dec_p_range
%type   <type_declaration>           net_dec_p_si
%type   <type_declaration>           net_dec_p_vs
%type   <type_declaration>           net_declaration
%type   <type_declaration>           real_declaration
%type   <type_declaration>           realtime_declaration
%type   <type_declaration>           reg_dec_p_range
%type   <type_declaration>           reg_dec_p_signed
%type   <type_declaration>           reg_declaration
%type   <type_declaration>           time_declaration
%type   <udp_body>                   udp_body
%type   <udp_combinatorial_entry>    combinational_entry
%type   <udp_declaration>            udp_declaration
%type   <udp_initial>                udp_initial_statement
%type   <udp_instance>               udp_instance
%type   <udp_instantiation>          udp_instantiation
%type   <udp_next_state>             next_state
%type   <udp_next_state>             output_symbol
%type   <udp_port>                   udp_input_declaration
%type   <udp_port>                   udp_output_declaration
%type   <udp_port>                   udp_port_declaration
%type   <udp_port>                   udp_reg_declaration
%type   <udp_seqential_entry>        sequential_entry
%type   <wait_statement>             wait_statement

%%
/* Start variables */

grammar_begin : 
  library_text {
    assert(yy_verilog_source_tree != NULL);
    yy_verilog_source_tree -> libraries = 
        ast_list_concat(yy_verilog_source_tree -> libraries, $1);
}
| config_declaration {
    assert(yy_verilog_source_tree != NULL);
    ast_list_append(yy_verilog_source_tree -> configs, $1);
}
| source_text {
    assert(yy_verilog_source_tree != NULL);

    unsigned int i;
    for(i  = 0; i < $1 -> items; i ++)
    {
        ast_source_item * toadd = ast_list_get($1, i);

        if(toadd -> type == SOURCE_MODULE)
        {
            ast_list_append(yy_verilog_source_tree -> modules, 
                toadd -> module);
        }
        else if (toadd -> type == SOURCE_UDP)
        {
            ast_list_append(yy_verilog_source_tree -> primitives, 
                toadd -> udp);
        }
        else
        {
            // Do nothing / unknown / unsupported type.
            printf("line %d of %s - Unknown source item type: %d",
                __LINE__,
                __FILE__,
                toadd -> type);
        }
    }
}
| {
    // Do nothing, it's an empty file.
}
;

/* 19.0 Compiler Directives */


text_macro_usage : MACRO_IDENTIFIER list_of_actual_arguments
                 | MACRO_IDENTIFIER
                 ;

list_of_actual_arguments : actual_argument
                         | list_of_actual_arguments COMMA actual_argument
                         ;

actual_argument : expression
                ; 


/* A.1.1 Library Source Text */

library_text : 
  library_descriptions{
    $$ = ast_list_new();
    ast_list_append($$,$1);
  }
| library_text library_descriptions{
    $$ = $1;
    ast_list_append($$,$2);
}
;

library_descriptions : 
  library_declaration{
    $$ = ast_new_library_description(LIB_LIBRARY);
    $$ -> library = $1;
  }
| include_statement{
    $$ = ast_new_library_description(LIB_INCLUDE);
    $$ -> include = $1;
  }
| config_declaration{
    $$ = ast_new_library_description(LIB_CONFIG);
    $$ -> config = $1;
  }
;

library_declaration : 
  KW_LIBRARY library_identifier file_path_specs SEMICOLON{
    $$ = ast_new_library_declaration($2,$3,ast_list_new());
  }
| KW_LIBRARY library_identifier file_path_specs KW_INCDIR file_path_specs 
  SEMICOLON{
    $$ = ast_new_library_declaration($2,$3,$5);
  }
;

file_path_specs : 
  file_path_spec{
    $$ = ast_list_new();
    ast_list_append($$,$1);
  }
| file_path_specs COMMA file_path_spec{
    $$ = $1;
    ast_list_append($$,$3);
  }
;

file_path_spec : file_path{$$=$1;}
               ;

file_path : string {$$=$1;};

include_statement : KW_INCLUDE file_path_spec SEMICOLON{$$=$2;}
                  ;
   
/* A.1.2 Configuration Source Text */

config_declaration : 
 KW_CONFIG config_identifier SEMICOLON design_statement
 config_rule_statement_os KW_ENDCONFIG{
    $$ = ast_new_config_declaration($2,$4,$5);
  }
;

design_statement : KW_DESIGN lib_cell_identifier_os SEMICOLON{
    $$ = $2;
}
;

lib_cell_identifier_os :
  {$$ =NULL;}
| cell_identifier {
    $$ = $1;
  }
| library_identifier DOT cell_identifier{
    $$ = ast_append_identifier($1,$3);
}
| lib_cell_identifier_os cell_identifier{
    if($1 == NULL){
        $$ = $2;
    } else {
        $$ = ast_append_identifier($1,$2);
    }
}
| lib_cell_identifier_os library_identifier DOT cell_identifier{
    if($1 == NULL){
        $$ = ast_append_identifier($2,$4);
    } else {
        $2 = ast_append_identifier($2,$4);
        $$ = ast_append_identifier($1,$2);
    }
}
;

config_rule_statement_os : {
    $$ = ast_list_new();
}
| config_rule_statement{
    $$ = ast_list_new();
    ast_list_append($$,$1);
}
| config_rule_statement_os config_rule_statement{
    $$ = $1;
    ast_list_append($$,$2);
}
;

config_rule_statement : 
  KW_DEFAULT liblist_clause{
    $$ = ast_new_config_rule_statement(AST_TRUE,NULL,NULL);
    $$ -> multiple_clauses = AST_TRUE;
    $$ -> clauses = $2;
  }
| inst_clause liblist_clause{
    $$ = ast_new_config_rule_statement(AST_FALSE,NULL,NULL);
    $$ -> multiple_clauses = AST_TRUE;
    $$ -> clauses = $2;
  }
| inst_clause use_clause{
    $$ = ast_new_config_rule_statement(AST_FALSE,$1,$2);
  }
| cell_clause liblist_clause{
    $$ = ast_new_config_rule_statement(AST_FALSE,NULL,NULL);
    $$ -> multiple_clauses = AST_TRUE;
    $$ -> clauses = $2;
  }
| cell_clause use_clause{
    $$ = ast_new_config_rule_statement(AST_FALSE,$1,$2);
  }
;

inst_clause : KW_INSTANCE inst_name {$$=$2;}
            ;

inst_name   : 
  topmodule_identifier instance_identifier_os{
    $$ = $1;
    if($2 != NULL)
        ast_append_identifier($$,$2);
  }
;

instance_identifier_os  :
  {$$ = NULL;}
| DOT instance_identifier{$$ = $2;}
| instance_identifier_os DOT instance_identifier{
    if($1 == NULL){
        $$ = $3;
    } else {
        $$ = $1;
        ast_append_identifier($$,$3);
    }
}
;

cell_clause : 
  KW_CELL cell_identifier {
    $$ = $2;
  }
| KW_CELL library_identifier DOT cell_identifier{
    $$ = $2;
    ast_append_identifier($$,$4);
}
;

liblist_clause  : KW_LIBLIST library_identifier_os{$$ = $2;}
                ;

library_identifier_os :
  {$$ = ast_list_new();}
| library_identifier{
    $$ = ast_list_new();
    ast_list_append($$,$1);
}
| library_identifier_os library_identifier{
    $$ = $1;
    ast_list_append($$,$2);
}
;

use_clause : 
  KW_USE library_identifier DOT cell_identifier COLON KW_CONFIG{
    $$ = $2;
    ast_append_identifier($$,$4);
  }
| KW_USE library_identifier DOT cell_identifier{
    $$ = $2;
    ast_append_identifier($$,$4);
  }
| KW_USE cell_identifier COLON KW_CONFIG{
    $$ = $2;
  }
| KW_USE cell_identifier{
    $$ = $2;
  }
;

/* A.1.3 Module and primitive source text. */

source_text : 
  description {
    $$ = ast_list_new();
    ast_list_append($$,$1);
}
| source_text description{
    $$ = $1;
    ast_list_append($$,$2);
}
;

description : 
  module_declaration{
    $$ = ast_new_source_item(SOURCE_MODULE);
    $$ -> module = $1;
}
| udp_declaration     {
    $$ = ast_new_source_item(SOURCE_UDP);
    $$ -> udp = $1;
}
;

module_declaration : 
  attribute_instances
  module_keyword
  module_identifier
  module_parameter_port_list
  list_of_port_declarations
  SEMICOLON
  non_port_module_item_os
  KW_ENDMODULE{
    $$ = ast_new_module_declaration($1,$3,$4,$5,$7);
}
| attribute_instances
  module_keyword
  module_identifier
  module_parameter_port_list
  list_of_ports
  SEMICOLON
  module_item_os
  KW_ENDMODULE{
    // Old style of port declaration, don't pass them directly into the 
    // function.
    $$ = ast_new_module_declaration($1,$3,$4,NULL,$7);
}
;

module_keyword     : KW_MODULE
                   | KW_MACROMODULE
                   ;

/* A.1.4 Module parameters and ports */

module_parameter_port_list  : {
    $$ = ast_list_new();
}
| HASH OPEN_BRACKET module_params CLOSE_BRACKET{
    $$ = $3;
}
;

module_params     : 
  parameter_declaration{
    $$ = ast_list_new();
    ast_list_append($$, $1);
  }
| module_params COMMA parameter_declaration{
    $$ = $1;
    ast_list_append($$,$3);
}
;

list_of_ports   : {$$ = ast_list_new();}
| OPEN_BRACKET ports CLOSE_BRACKET {
    $$ = $2;
}
;

list_of_port_declarations   : 
  OPEN_BRACKET CLOSE_BRACKET{
    $$ = ast_list_new();
  }
| OPEN_BRACKET port_declarations CLOSE_BRACKET{
    $$ = $2;
}
;

port_declarations : 
  port_declarations COMMA port_dir port_declaration_l{
    $$ = $1;
    $4 -> direction = $3;
    ast_list_append($$,$4);
}
| port_declarations COMMA identifier_csv port_dir port_declaration_l{
    $$ = $1;
    $5 -> direction = $4;
    ast_list_append($$,$5);
}
| port_dir port_declaration_l{
    $$ = ast_list_new();
    $2 -> direction = $1;
    ast_list_append($$,$2);
}
;

port_declaration_l: 
  net_type_o signed_o range_o port_identifier{
    ast_list * names = ast_list_new();
    ast_list_append(names, $4);
    $$ = ast_new_port_declaration(PORT_NONE, $1, $2,
    AST_FALSE,AST_FALSE,NULL,names);
}
|            signed_o range_o port_identifier{
    ast_list * names = ast_list_new();
    ast_list_append(names, $3);
    $$ = ast_new_port_declaration(PORT_NONE, NET_TYPE_NONE, $1,
    AST_FALSE,AST_FALSE,NULL,names);
}
| KW_REG     signed_o range_o port_identifier eq_const_exp_o{
    ast_list * names = ast_list_new();
    ast_list_append(names, $4);
    $$ = ast_new_port_declaration(PORT_NONE, NET_TYPE_NONE, AST_FALSE,
    AST_TRUE,AST_FALSE,NULL,names);
}
| output_variable_type_o      port_identifier{
    ast_list * names = ast_list_new();
    ast_list_append(names, $2);
    $$ = ast_new_port_declaration(PORT_NONE, NET_TYPE_NONE, AST_FALSE,
    AST_FALSE,AST_TRUE,NULL,names);
}
| output_variable_type        port_identifier eq_const_exp_o{
    ast_list * names = ast_list_new();
    ast_list_append(names, $2);
    $$ = ast_new_port_declaration(PORT_NONE, NET_TYPE_NONE, AST_FALSE,
    AST_FALSE,AST_TRUE,NULL,names);
}
;

identifier_csv    : {$$ = ast_list_new();}
| identifier{
    $$ = ast_list_new();
    ast_list_append($$,$1);
}
| COMMA identifier identifier_csv{
    $$ = $3;
    ast_list_append($$,$2);
}
;

port_dir          : 
  attribute_instances KW_OUTPUT{$$ = PORT_OUTPUT;}
| attribute_instances KW_INPUT {$$ = PORT_INPUT;}
| attribute_instances KW_INOUT {$$ = PORT_INOUT;}
;

port_declaration  : 
  inout_declaration {$$ = $1;}
| input_declaration {$$ = $1;}
| output_declaration {$$ = $1;}
;

ports           : {$$ = ast_list_new();}
| ports COMMA port{
    $$ = $1;
    ast_list_append($$,$3);
}
| port {
    $$ = ast_list_new();
    ast_list_append($$,$1);
}
;

port            : 
  port_expression{
    $<list>$ = $1;
  }
| DOT port_identifier OPEN_BRACKET port_expression CLOSE_BRACKET{
    $$ = $2;
}
;

port_expression : 
  port_reference {
    $$ = ast_list_new();
    ast_list_append($$,$1);
  }
| port_expression COMMA port_reference{
    $$ = $1;
    ast_list_append($$,$3);
}
;

port_reference  : 
  port_identifier{
    $$ = $1;
}
| port_identifier OPEN_SQ_BRACKET constant_expression CLOSE_SQ_BRACKET {
    $$ = $1;
}
| port_identifier OPEN_SQ_BRACKET range_expression CLOSE_SQ_BRACKET{
    $$ = $1;
}
;

/* A.1.5 Module Items */

module_item_os : {$$ = ast_list_new();}
| module_item{
    $$ = ast_list_new();
    ast_list_append($$,$1);
}
| module_item_os module_item{
    $$ = $1;
    ast_list_append($$,$2);
}
;

non_port_module_item_os : {$$ = ast_list_new();}
 | non_port_module_item{
    $$ = ast_list_new();
    ast_list_append($$,$1);
 }
 | non_port_module_item_os non_port_module_item{
    $$ = $1;
    ast_list_append($$,$2);
 }
;

module_item : 
   module_or_generate_item{
    $$ = $1;
 }
 | port_declaration SEMICOLON{
    $$ = ast_new_module_item(NULL, MOD_ITEM_PORT_DECLARATION);
    $$ -> port_declaration = $1;
 }
 | attribute_instances generated_instantiation{
    $$ = ast_new_module_item($1, MOD_ITEM_GENERATED_INSTANTIATION);
    $$ -> generated_instantiation = $2;
 }
 | attribute_instances local_parameter_declaration{
    $$ = ast_new_module_item($1, MOD_ITEM_PARAMETER_DECLARATION);
    $$ -> parameter_declaration = $2;
 }
 | attribute_instances parameter_declaration SEMICOLON{
    $$ = ast_new_module_item($1, MOD_ITEM_PARAMETER_DECLARATION);
    $$ -> parameter_declaration = $2;
 }
 | attribute_instances specify_block{
    $$ = ast_new_module_item($1, MOD_ITEM_SPECIFY_BLOCK);
    $$ -> specify_block = $2;
 }
 | attribute_instances specparam_declaration{
    $$ = ast_new_module_item($1, MOD_ITEM_SPECPARAM_DECLARATION);
    $$ -> specparam_declaration = $2;
 }
 ;

module_or_generate_item : 
  attribute_instances module_or_generate_item_declaration{
    $$ = $2;
  }
| attribute_instances parameter_override{
    $$ = ast_new_module_item($1, MOD_ITEM_PARAMETER_OVERRIDE);
    $$ -> parameter_override = $2;
  }
| attribute_instances continuous_assign{
    $$ = ast_new_module_item($1, MOD_ITEM_CONTINOUS_ASSIGNMENT);
    $$ -> continuous_assignment = $2 -> continuous;
  }
| attribute_instances gate_instantiation{
    $$ = ast_new_module_item($1, MOD_ITEM_GATE_INSTANTIATION);
    $$ -> gate_instantiation = $2;
  }
| attribute_instances udp_instantiation{
    $$ = ast_new_module_item($1, MOD_ITEM_UDP_INSTANTIATION);
    $$ -> udp_instantiation = $2;
  }
| attribute_instances module_instantiation{
    $$ = ast_new_module_item($1, MOD_ITEM_MODULE_INSTANTIATION);
    $$ -> module_instantiation = $2;
  }
| attribute_instances initial_construct{
    $$ = ast_new_module_item($1, MOD_ITEM_INITIAL_CONSTRUCT);
    $$ -> initial_construct = $2;
  }
| attribute_instances always_construct{
    $$ = ast_new_module_item($1, MOD_ITEM_ALWAYS_CONSTRUCT);
    $$ -> always_construct = $2;
  }
;

module_or_generate_item_declaration : 
   net_declaration{
    $$ = ast_new_module_item(NULL,MOD_ITEM_NET_DECLARATION);
    $$ -> net_declaration = $1;
 }
 | reg_declaration{
    $$ = ast_new_module_item(NULL,MOD_ITEM_REG_DECLARATION);
    $$ -> reg_declaration = $1;
 }
 | integer_declaration{
    $$ = ast_new_module_item(NULL, MOD_ITEM_INTEGER_DECLARATION);
    $$ -> integer_declaration = $1;
 }
 | real_declaration{
    $$ = ast_new_module_item(NULL,MOD_ITEM_REAL_DECLARATION);
    $$ -> real_declaration = $1;
 }
 | time_declaration{
    $$ = ast_new_module_item(NULL,MOD_ITEM_TIME_DECLARATION);
    $$ -> time_declaration = $1;
 }
 | realtime_declaration{
    $$ = ast_new_module_item(NULL, MOD_ITEM_REALTIME_DECLARATION);
    $$ -> realtime_declaration = $1;
 }
 | event_declaration{
    $$ = ast_new_module_item(NULL,MOD_ITEM_EVENT_DECLARATION);
    $$ -> event_declaration = $1;
 }
 | genvar_declaration{
    $$ = ast_new_module_item(NULL,MOD_ITEM_GENVAR_DECLARATION);
    $$ -> genvar_declaration = $1;
 }
 | task_declaration{
    $$ = ast_new_module_item(NULL,MOD_ITEM_TASK_DECLARATION);
    $$ -> task_declaration = $1;
 }
 | function_declaration{
    $$ = ast_new_module_item(NULL,MOD_ITEM_FUNCTION_DECLARATION);
    $$ -> function_declaration = $1;
 }
 ;

non_port_module_item : 
  attribute_instances generated_instantiation{
    $$ = ast_new_module_item($1, MOD_ITEM_GENERATED_INSTANTIATION);
    $$ -> generated_instantiation = $2;
  }
| attribute_instances local_parameter_declaration{
    $$ = ast_new_module_item($1,MOD_ITEM_PARAMETER_DECLARATION);
    $$ -> parameter_declaration = $2;
}
| attribute_instances module_or_generate_item{
    $$ = $2;
}
| attribute_instances parameter_declaration SEMICOLON{
    $$ = ast_new_module_item($1,MOD_ITEM_PARAMETER_DECLARATION);
    $$ -> parameter_declaration = $2;
}
| attribute_instances specify_block{
    $$ = ast_new_module_item($1,MOD_ITEM_SPECIFY_BLOCK);
    $$ -> specify_block = $2;
}
| attribute_instances specparam_declaration{
    $$ = ast_new_module_item($1,MOD_ITEM_PORT_DECLARATION);
    $$ -> specparam_declaration = $2;
}
;

parameter_override  : 
  KW_DEFPARAM list_of_param_assignments SEMICOLON{$$ = $2;}
;

/* A.2.1.1 Module Parameter Declarations */

signed_o : KW_SIGNED {$$=1;}|{$$=0;} ;
range_o  : range {$$=$1;}    | {$$=NULL;} ;

local_parameter_declaration : 
  KW_LOCALPARAM signed_o range_o list_of_param_assignments SEMICOLON{
    $$ = ast_new_parameter_declarations($4,$2,AST_TRUE,$3,PARAM_GENERIC);
  }
| KW_LOCALPARAM KW_INTEGER       list_of_param_assignments SEMICOLON{
    $$ = ast_new_parameter_declarations($3,AST_FALSE,AST_TRUE,NULL,
        PARAM_INTEGER);
  }
| KW_LOCALPARAM KW_REAL          list_of_param_assignments SEMICOLON{
    $$ = ast_new_parameter_declarations($3,AST_FALSE,AST_TRUE,NULL,
        PARAM_REAL);
  }
| KW_LOCALPARAM KW_REALTIME      list_of_param_assignments SEMICOLON{
    $$ = ast_new_parameter_declarations($3,AST_FALSE,AST_TRUE,NULL,
        PARAM_REALTIME);
  }
| KW_LOCALPARAM KW_TIME          list_of_param_assignments SEMICOLON{
    $$ = ast_new_parameter_declarations($3,AST_FALSE,AST_TRUE,NULL,
        PARAM_TIME);
  }
;

parameter_declaration : 
  KW_PARAMETER signed_o range_o list_of_param_assignments {
    $$ = ast_new_parameter_declarations($4,$2,AST_FALSE,$3,PARAM_GENERIC);
  }
| KW_PARAMETER KW_INTEGER       list_of_param_assignments {
    $$ = ast_new_parameter_declarations($3,AST_FALSE,AST_FALSE,NULL,
        PARAM_INTEGER);
  }
| KW_PARAMETER KW_REAL          list_of_param_assignments {
    $$ = ast_new_parameter_declarations($3,AST_FALSE,AST_FALSE,NULL,
        PARAM_REAL);
  }
| KW_PARAMETER KW_REALTIME      list_of_param_assignments {
    $$ = ast_new_parameter_declarations($3,AST_FALSE,AST_FALSE,NULL,
        PARAM_REALTIME);
  }
| KW_PARAMETER KW_TIME          list_of_param_assignments {
    $$ = ast_new_parameter_declarations($3,AST_FALSE,AST_FALSE,NULL,
        PARAM_TIME);
  }
;

specparam_declaration : 
  KW_SPECPARAM range_o list_of_specparam_assignments SEMICOLON{
    $$ = ast_new_parameter_declarations($3,AST_FALSE,AST_FALSE,$2,
        PARAM_SPECPARAM);
  } 
;

/* A.2.1.2 Port declarations */

net_type_o  : net_type {$$=$1;} | {$$ = NET_TYPE_NONE;} ;
reg_o       : KW_REG   {$$=1;}| {$$=0;};

inout_declaration : 
  KW_INOUT net_type_o signed_o range_o list_of_port_identifiers{
$$ = ast_new_port_declaration(PORT_INOUT, $2,$3,AST_FALSE,AST_FALSE,$4,$5);
  }
;

input_declaration : 
  KW_INPUT net_type_o signed_o range_o list_of_port_identifiers{
$$ = ast_new_port_declaration(PORT_INPUT, $2,$3,AST_FALSE,AST_FALSE,$4,$5);
  }
;

output_declaration: 
  KW_OUTPUT net_type_o signed_o range_o list_of_port_identifiers{
$$ = ast_new_port_declaration(PORT_OUTPUT, $2,$3,AST_FALSE,AST_FALSE,$4,$5);
  }
| KW_OUTPUT reg_o signed_o range_o list_of_port_identifiers{
$$ = ast_new_port_declaration(PORT_OUTPUT,
NET_TYPE_NONE,$3,$2,AST_FALSE,$4,$5);
  }
| KW_OUTPUT output_variable_type_o list_of_port_identifiers{
    $$ = ast_new_port_declaration(PORT_OUTPUT, NET_TYPE_NONE,
        AST_FALSE,
        AST_FALSE,
        AST_TRUE,
        NULL,
        $3);
  }
| KW_OUTPUT output_variable_type list_of_variable_port_identifiers{
    $$ = ast_new_port_declaration(PORT_OUTPUT, NET_TYPE_NONE,
        AST_FALSE,
        AST_FALSE,
        AST_TRUE,
        NULL,
        $3);
  }
| KW_OUTPUT KW_REG signed_o range_o list_of_variable_port_identifiers{
    $$ = ast_new_port_declaration(PORT_OUTPUT,
                                  NET_TYPE_NONE,
                                  $3, AST_TRUE,
                                  AST_FALSE,
                                  $4, $5);
  }
;

/* A.2.1.3 Type declarations */

event_declaration   : KW_EVENT list_of_event_identifiers SEMICOLON {
    $$ = ast_new_type_declaration(DECLARE_EVENT);   
    $$ -> identifiers = $2;
};
genvar_declaration  : KW_GENVAR list_of_genvar_identifiers SEMICOLON {
    $$ = ast_new_type_declaration(DECLARE_GENVAR);   
    $$ -> identifiers = $2;
};
integer_declaration : KW_INTEGER list_of_variable_identifiers SEMICOLON{
    $$ = ast_new_type_declaration(DECLARE_INTEGER);   
    $$ -> identifiers = $2;
} ;
time_declaration    : KW_TIME list_of_variable_identifiers SEMICOLON{
    $$ = ast_new_type_declaration(DECLARE_TIME);   
    $$ -> identifiers = $2;
} ;
real_declaration    : KW_REAL list_of_real_identifiers SEMICOLON{
    $$ = ast_new_type_declaration(DECLARE_REAL);   
    $$ -> identifiers = $2;
} ;
realtime_declaration: KW_REALTIME list_of_real_identifiers SEMICOLON{
    $$ = ast_new_type_declaration(DECLARE_REALTIME);   
    $$ -> identifiers = $2;
} ;

delay3_o            : delay3 {$$=$1;}| {$$=NULL;};
drive_strength_o    : OPEN_BRACKET drive_strength {$$=$2;}| {$$=NULL;};

net_declaration : 
  net_type                  net_dec_p_ds{
    $$ = $2;
    $$ -> net_type = $1;
  }
| net_type OPEN_BRACKET  drive_strength  net_dec_p_ds{
    $$ = $4;
    $$ -> net_type = $1;
    $$ -> drive_strength = $3;
  }
| KW_TRIREG                 net_dec_p_ds{
    $$ = $2;
    $$ -> net_type = NET_TYPE_TRIREG;
  }
| KW_TRIREG OPEN_BRACKET drive_strength  net_dec_p_ds{
    $$ = $4;
    $$ -> drive_strength = $3;
    $$ -> net_type = NET_TYPE_TRIREG;
  }
| KW_TRIREG charge_strength net_dec_p_ds{
    $$ = $3;
    $$ -> charge_strength = $2;
    $$ -> net_type = NET_TYPE_TRIREG;
  }
;

net_dec_p_ds    : 
  KW_VECTORED net_dec_p_vs{
    $$ = $2;
    $$ -> vectored = AST_TRUE;
  }
| KW_SCALARED net_dec_p_vs {
    $$ = $2;
    $$ -> scalared = AST_TRUE;
  }
| net_dec_p_vs{ $$= $1;}
;

net_dec_p_vs    : 
  KW_SIGNED net_dec_p_si {
    $$ = $2;
    $$ -> is_signed = AST_TRUE;
  }
| net_dec_p_si {$$=$1;}
;

net_dec_p_si    : 
  range net_dec_p_range{
    $$ = $2;
    $$ -> range = $1;
  }
| net_dec_p_range {$$ =$1;}
;

net_dec_p_range : 
  delay3  net_dec_p_delay{
    $$ = $2;
    $$ -> delay = $1;
  }
| net_dec_p_delay {$$ = $1;}
;

net_dec_p_delay : 
  list_of_net_identifiers  SEMICOLON{
    $$ = ast_new_type_declaration(DECLARE_NET);
    $$ -> identifiers = $1;
  }
| list_of_net_decl_assignments  SEMICOLON{
    $$ = ast_new_type_declaration(DECLARE_NET);
    $$ -> identifiers = $1;
  }
;



reg_declaration     : 
  KW_REG KW_SIGNED reg_dec_p_signed{
    $$ = $3;
    $$ -> is_signed = AST_TRUE;
  }
| KW_REG reg_dec_p_signed{
    $$ = $2;
    $$ -> is_signed = AST_FALSE;
  }
;

reg_dec_p_signed    : 
  range reg_dec_p_range {
      $$ = $2;
      $$ -> range = $1;
  }
| reg_dec_p_range {$$=$1;}
;

reg_dec_p_range     : list_of_variable_identifiers SEMICOLON{
    $$ = ast_new_type_declaration(DECLARE_REG);
    $$ -> identifiers = $1;
}
                    ;


/* 2.2.1 Net and variable types */

net_type            : 
  KW_SUPPLY0 { $$ = NET_TYPE_SUPPLY0 ;}
| KW_SUPPLY1 { $$ = NET_TYPE_SUPPLY1 ;}
| KW_TRI     { $$ = NET_TYPE_TRI     ;}
| KW_TRIAND  { $$ = NET_TYPE_TRIAND  ;}
| KW_TRIOR   { $$ = NET_TYPE_TRIOR   ;}
| KW_WIRE    { $$ = NET_TYPE_WIRE    ;}
| KW_WAND    { $$ = NET_TYPE_WAND    ;}
| KW_WOR     { $$ = NET_TYPE_WOR     ;}
;

output_variable_type_o : output_variable_type {$$= $1;} |{$$=PARAM_GENERIC;};
output_variable_type: KW_INTEGER{$$=PARAM_INTEGER;}
                    | KW_TIME{$$=PARAM_INTEGER;}
                    ;

real_type : real_identifier {$$=$1; /* TODO FIXME */}
          | real_identifier EQ constant_expression{$$=$1; /* TODO FIXME */}
          | real_identifier dimension dimensions{
    $$=$1; 
    $$ -> range_or_idx = ID_HAS_RANGES;
    ast_list_preappend($3,$2);
    $$ -> ranges = $3; 
  }          ;

dimensions          : 
  dimension {
    $$=ast_list_new();
    ast_list_append($$,$1);
   }
 | dimensions dimension {
    $$ = $1;
    ast_list_append($$,$2);
   }
 | {$$ = ast_list_new();}
 ;

variable_type : 
  variable_identifier {
      $$=$1; 
  }
| variable_identifier EQ constant_expression{
    $$=$1; /* TODO FIXME */
  }
| variable_identifier dimension dimensions{
    $$=$1; 
    $$ -> range_or_idx = ID_HAS_RANGES;
    ast_list_preappend($3,$2);
    $$ -> ranges = $3; 
  }
;

/* A.2.2.2 Strengths */

drive_strength      : 
  strength0 COMMA strength1 CLOSE_BRACKET{
      $$ = ast_new_pull_stregth($1,$3);
  }
| strength1 COMMA strength0 CLOSE_BRACKET{
      $$ = ast_new_pull_stregth($1,$3);
  }
| strength0 COMMA KW_HIGHZ1 CLOSE_BRACKET{
      $$ = ast_new_pull_stregth($1,STRENGTH_HIGHZ1);
  }
| strength1 COMMA KW_HIGHZ0 CLOSE_BRACKET{
      $$ = ast_new_pull_stregth($1,STRENGTH_HIGHZ0);
  }
| KW_HIGHZ0 COMMA strength1 CLOSE_BRACKET{
      $$ = ast_new_pull_stregth(STRENGTH_HIGHZ0, $3);
  }
| KW_HIGHZ1 COMMA strength0 CLOSE_BRACKET{
      $$ = ast_new_pull_stregth(STRENGTH_HIGHZ1, $3);
  }
;

strength0           : 
  KW_SUPPLY0 { $$ = STRENGTH_SUPPLY0;}
| KW_STRONG0 { $$ = STRENGTH_STRONG0;}
| KW_PULL0   { $$ = STRENGTH_PULL0  ;}
| KW_WEAK0   { $$ = STRENGTH_WEAK0  ;}
;

strength1           : 
  KW_SUPPLY1 { $$ = STRENGTH_SUPPLY1;}
| KW_STRONG1 { $$ = STRENGTH_STRONG1;}
| KW_PULL1   { $$ = STRENGTH_PULL1  ;}
| KW_WEAK1   { $$ = STRENGTH_WEAK1  ;}
;

charge_strength : OPEN_BRACKET KW_SMALL CLOSE_BRACKET  {$$=CHARGE_SMALL;}
                | OPEN_BRACKET KW_MEDIUM CLOSE_BRACKET {$$=CHARGE_MEDIUM;}
                | OPEN_BRACKET KW_LARGE CLOSE_BRACKET  {$$=CHARGE_LARGE;}
                ;

/* A.2.2.3 Delays */

delay3 :
  HASH delay_value{
    $$ = ast_new_delay3($2,$2,$2);
  }
| HASH OPEN_BRACKET delay_value CLOSE_BRACKET{
    $$ = ast_new_delay3($3,$3,$3);
  }
| HASH OPEN_BRACKET delay_value COMMA delay_value CLOSE_BRACKET{
    $$ = ast_new_delay3($3,NULL,$5);
  }
| HASH OPEN_BRACKET delay_value COMMA delay_value COMMA delay_value CB{
    $$ = ast_new_delay3($3,$5,$7);
  }
| {$$ = ast_new_delay3(NULL,NULL,NULL);}
;

delay2    : 
  HASH delay_value{
    $$ = ast_new_delay2($2,$2);
  }
| HASH OPEN_BRACKET delay_value CLOSE_BRACKET{
    $$ = ast_new_delay2($3,$3);
  }
| HASH OPEN_BRACKET delay_value COMMA delay_value CLOSE_BRACKET{
    $$ = ast_new_delay2($3,$5);
  }
| {$$ = ast_new_delay2(NULL,NULL);}
;

delay_value : 
  unsigned_number {
      $$ = ast_new_delay_value(DELAY_VAL_NUMBER, $1);
  }
| parameter_identifier{
      $$ = ast_new_delay_value(DELAY_VAL_PARAMETER, $1);
  }
| specparam_identifier{
      $$ = ast_new_delay_value(DELAY_VAL_SPECPARAM, $1);
  }
| mintypmax_expression{
      $$ = ast_new_delay_value(DELAY_VAL_MINTYPMAX, $1);
  }
;

/* A.2.3 Declaration Lists */

dimensions_o        : dimensions {$$ = $1;}
                    | {$$=NULL;}
                    ;

list_of_event_identifiers : 
  event_identifier dimensions_o{
    $$ = ast_list_new();
    ast_list_append($$,$1);
  }
| list_of_event_identifiers COMMA event_identifier dimensions_o{
    $$ = $1;
    ast_list_append($$,$3);
}
;

list_of_genvar_identifiers: 
  genvar_identifier{
    $$ = ast_list_new();
    ast_list_append($$,$1);
  }
| list_of_genvar_identifiers COMMA genvar_identifier{
    $$ = $1;
    ast_list_append($$,$3);
}
;

list_of_net_decl_assignments : 
  net_decl_assignment{
    $$ = ast_list_new();
    ast_list_append($$,$1);
  }
| list_of_net_decl_assignments COMMA net_decl_assignment{
    $$= $1;
    ast_list_append($$,$3);
}
;

list_of_net_identifiers      :
  net_identifier dimensions_o{
    $$ = ast_list_new();
    ast_list_append($$,$1);
  }
| list_of_net_identifiers COMMA net_identifier dimensions_o{
    $$ = $1;
    ast_list_append($$,$3);
}
;

list_of_param_assignments    : 
   param_assignment{
    $$ = ast_list_new();
    ast_list_append($$,$1);
   }
 | list_of_param_assignments COMMA param_assignment{
    $$ = $1;
    ast_list_append($$,$3);
 }
 | list_of_param_assignments COMMA KW_PARAMETER param_assignment{
    $$ = $1;
    ast_list_append($$,$3);
 }
 ;

list_of_port_identifiers     : 
  port_identifier{
    $$ = ast_list_new();
    ast_list_append($$,$1);
  }
| port_identifier OPEN_SQ_BRACKET constant_expression CLOSE_SQ_BRACKET {
    ast_identifier_set_index($1,$3);
    $$ = ast_list_new();
    ast_list_append($$,$1);
}
| list_of_port_identifiers COMMA port_identifier{
    $$ = $1;
    ast_list_append($$,$3);
}
| list_of_port_identifiers COMMA port_identifier OPEN_SQ_BRACKET 
  constant_expression CLOSE_SQ_BRACKET {
    ast_identifier_set_index($3,$5);
    $$ = $1;
    ast_list_append($$,$3);
}
;

list_of_real_identifiers     : 
  real_type{
      $$ = ast_list_new();
      ast_list_append($$,$1);
  }
| list_of_real_identifiers COMMA real_type{
    $$ = $1;
    ast_list_append($$,$3);
}
;

list_of_specparam_assignments: 
  specparam_assignment{
    $$ = ast_list_new();
    ast_list_append($$,$1);
  }
| list_of_specparam_assignments COMMA specparam_assignment{
    $$ = $1;
    ast_list_append($$,$3);
}
;

list_of_variable_identifiers : 
  variable_type{
    $$ = ast_list_new();
    ast_list_append($$,$1);
  }
| list_of_variable_identifiers COMMA variable_type{
    $$ = $1;
    ast_list_append($$,$3);
}
;

eq_const_exp_o : 
  EQ constant_expression {$$ = $2;}
| {$$ = NULL;}
;

list_of_variable_port_identifiers : 
  port_identifier eq_const_exp_o {
    $$ = ast_list_new();
    ast_list_append($$, 
        ast_new_single_assignment(ast_new_lvalue_id(VAR_IDENTIFIER,$1),$2));
  }
| list_of_variable_port_identifiers COMMA port_identifier eq_const_exp_o{
    $$ = $1;
    ast_list_append($$, 
        ast_new_single_assignment(ast_new_lvalue_id(VAR_IDENTIFIER,$3),$4));
}
;

/* A.2.4 Declaration Assignments */

net_decl_assignment     : 
  net_identifier EQ expression {
    $$ = ast_new_single_assignment(ast_new_lvalue_id(NET_IDENTIFIER,$1),$3);
  }
| net_identifier{
    $$ = ast_new_single_assignment(ast_new_lvalue_id(NET_IDENTIFIER,$1),NULL);
}   
;

param_assignment        : parameter_identifier EQ constant_expression {
    $$ = ast_new_single_assignment(ast_new_lvalue_id(PARAM_ID,$1),$3);   
};

specparam_assignment    : 
  specparam_identifier EQ constant_mintypmax_expression{
    $$= ast_new_single_assignment(ast_new_lvalue_id(SPECPARAM_ID,$1),$3);
  }
| pulse_control_specparam{
    $<pulse_control_specparam>$ = $1;
}
;

error_limit_value_o     : COMMA error_limit_value {$$=$2;}
                        |   {$$ =NULL;}
                        ;

pulse_control_specparam : 
  KW_PATHPULSE EQ OPEN_BRACKET reject_limit_value error_limit_value_o
  CLOSE_BRACKET SEMICOLON {
    $$ = ast_new_pulse_control_specparam($4,$5);
  }
| KW_PATHPULSE specify_input_terminal_descriptor '$'
  specify_output_terminal_descriptor EQ OPEN_BRACKET reject_limit_value
  error_limit_value_o CLOSE_BRACKET SEMICOLON{
    $$ = ast_new_pulse_control_specparam($7,$8);
    $$ -> input_terminal = $2;
    $$ -> output_terminal = $4;
  }
;

error_limit_value       : limit_value {$$=$1;};
reject_limit_value      : limit_value {$$=$1;};
limit_value             : constant_mintypmax_expression {$$=$1;};

/* A.2.5 Declaration ranges */

dimension : OPEN_SQ_BRACKET constant_expression COLON constant_expression
CLOSE_SQ_BRACKET{
    $$ = ast_new_range($2,$4);
};

range     : OPEN_SQ_BRACKET constant_expression COLON constant_expression
CLOSE_SQ_BRACKET{
    $$ = ast_new_range($2,$4);
};

/* A.2.6 Function Declarations */

automatic_o         : KW_AUTOMATIC {$$=AST_TRUE;} | {$$=AST_FALSE;};

function_declaration : 
  KW_FUNCTION automatic_o signed_o range_or_type_o function_identifier
  SEMICOLON function_item_declarations function_statement KW_ENDFUNCTION{
    $$ = ast_new_function_declaration($2,$3,AST_TRUE,$4,$5,$7,$8);
  }
| KW_FUNCTION automatic_o signed_o range_or_type_o function_identifier
  OPEN_BRACKET function_port_list CLOSE_BRACKET SEMICOLON
  block_item_declarations function_statement KW_ENDFUNCTION{
    $$ = ast_new_function_declaration($2,$3,AST_FALSE,$4,$5,$10,$11);
  }
;

block_item_declarations    : 
  block_item_declaration{
    $$ = ast_list_new();
    ast_list_append($$,$1);
  }
| block_item_declarations block_item_declaration{
    $$ = $1;
    ast_list_append($$,$2);
}
| {$$ = ast_list_new();}
;

function_item_declarations : 
   function_item_declaration{
    $$ = ast_list_new();
    ast_list_append($$,$1);
   }
 | function_item_declarations function_item_declaration{
    $$ = $1;
    ast_list_append($$,$2);
 }
 | {$$ = ast_list_new();}
 ;

function_item_declaration  : 
  block_item_declaration {
    $$ = ast_new_function_item_declaration();
    $$ -> is_port_declaration = AST_FALSE;
    $$ -> block_item = $1;
}
| tf_input_declaration SEMICOLON{
    $$ = ast_new_function_item_declaration();
    $$ -> is_port_declaration = AST_TRUE;
    $$ -> port_declaration    = $1;
}
;

function_port_list         : 
attribute_instances tf_input_declaration tf_input_declarations{
    $$ = $3;
    ast_list_preappend($$,$2);
};

tf_input_declarations      : {
    $$ = ast_list_new();
}
| COMMA attribute_instances tf_input_declaration tf_input_declarations{
    $$ = $4;
    ast_list_preappend($$,$3);
}
;

range_or_type_o            : range_or_type {$$=$1;} | {$$=NULL;};

range_or_type              : 
  range      {
    $$ = ast_new_range_or_type(AST_TRUE);
    $$ -> range = $1;
  }
| KW_INTEGER{
    $$ = ast_new_range_or_type(AST_FALSE);
    $$ -> type = PORT_TYPE_INTEGER;
  }
| KW_REAL{
    $$ = ast_new_range_or_type(AST_FALSE);
    $$ -> type = PORT_TYPE_REAL;
  }
| KW_REALTIME{
    $$ = ast_new_range_or_type(AST_FALSE);
    $$ -> type = PORT_TYPE_REALTIME;
  }
| KW_TIME{
    $$ = ast_new_range_or_type(AST_FALSE);
    $$ -> type = PORT_TYPE_TIME;
  }
;

/* A.2.7 Task Declarations */

task_declaration    : 
  KW_TASK automatic_o task_identifier SEMICOLON task_item_declarations 
  statement KW_ENDTASK{
    $$ = ast_new_task_declaration($2,$3,NULL,$5,$6);
  }
| KW_TASK automatic_o task_identifier OPEN_BRACKET task_port_list 
  CLOSE_BRACKET SEMICOLON block_item_declarations statement KW_ENDTASK{
    $$ = ast_new_task_declaration($2,$3,$5,$8,$9);
  }
;

task_item_declarations : 
 { $$ = ast_list_new();}
| task_item_declaration{
    $$ = ast_list_new();
    ast_list_append($$,$1);
  }
| task_item_declarations task_item_declaration{
    $$ = $1;
    ast_list_append($$,$2);
 }
;

task_item_declaration : 
  block_item_declaration{
    $$ = ast_new_function_item_declaration();
    $$ -> is_port_declaration = AST_FALSE;
    $$ -> block_item = $1;
}
| attribute_instances tf_input_declaration SEMICOLON{
    $$ = ast_new_function_item_declaration();
    $$ -> is_port_declaration = AST_TRUE;
    $$ -> port_declaration = $2;
}
| attribute_instances tf_output_declaration SEMICOLON{
    $$ = ast_new_function_item_declaration();
    $$ -> is_port_declaration = AST_TRUE;
    $$ -> port_declaration = $2;
}
| attribute_instances tf_inout_declaration SEMICOLON{
    $$ = ast_new_function_item_declaration();
    $$ -> is_port_declaration = AST_TRUE;
    $$ -> port_declaration = $2;
}
;

task_port_list  : 
   task_port_item{
    $$ = ast_list_new();
    ast_list_append($$,$1);
  }
 | task_port_list COMMA task_port_item{
    $$ = $1;
    ast_list_append($$,$3);
 }
 ;

task_port_item  : 
  attribute_instances tf_input_declaration  SEMICOLON {$$=$2;}
| attribute_instances tf_output_declaration SEMICOLON {$$=$2;}
| attribute_instances tf_inout_declaration  SEMICOLON {$$=$2;}
;

tf_input_declaration : 
  KW_INPUT reg_o signed_o range_o list_of_port_identifiers{
    $$ = ast_new_task_port(PORT_INPUT, $2,$3,$4,PORT_TYPE_NONE,$5);
  }
| KW_INPUT task_port_type_o list_of_port_identifiers{
    $$ = ast_new_task_port(PORT_INPUT,AST_FALSE,AST_FALSE,NULL,
        $2,$3);
}
;

tf_output_declaration : 
  KW_OUTPUT reg_o signed_o range_o list_of_port_identifiers{
    $$ = ast_new_task_port(PORT_OUTPUT, $2,$3,$4,PORT_TYPE_NONE,$5);
  }
| KW_OUTPUT task_port_type_o list_of_port_identifiers{
    $$ = ast_new_task_port(PORT_OUTPUT,AST_FALSE,AST_FALSE,NULL,
        $2,$3);
}
;

tf_inout_declaration : 
  KW_INOUT reg_o signed_o range_o list_of_port_identifiers{
    $$ = ast_new_task_port(PORT_INOUT, $2,$3,$4,PORT_TYPE_NONE,$5);
  }
| KW_INOUT task_port_type_o list_of_port_identifiers{
    $$ = ast_new_task_port(PORT_INOUT,AST_FALSE,AST_FALSE,NULL,
        $2,$3);
}
;

task_port_type_o : task_port_type {$$=$1;} | {$$=PORT_TYPE_NONE;} ;
task_port_type   : KW_TIME      {$$ = PORT_TYPE_TIME;}
                 | KW_REAL      {$$ = PORT_TYPE_REAL;}
                 | KW_REALTIME  {$$ = PORT_TYPE_REALTIME;}
                 | KW_INTEGER   {$$ = PORT_TYPE_INTEGER;}
                 ;


/* A.2.8 Block item declarations */

block_item_declaration : 
  attribute_instances block_reg_declaration{
    $$ = ast_new_block_item_declaration(BLOCK_ITEM_REG, $1);
    $$ -> reg = $2;
  }
| attribute_instances event_declaration{
    $$ = ast_new_block_item_declaration(BLOCK_ITEM_TYPE, $1);
    $$ -> event_or_var = $2;
  }
| attribute_instances integer_declaration{
    $$ = ast_new_block_item_declaration(BLOCK_ITEM_TYPE, $1);
    $$ -> event_or_var = $2;
  }
| attribute_instances local_parameter_declaration{
    $$ = ast_new_block_item_declaration(BLOCK_ITEM_PARAM, $1);
    $$ -> parameters = $2;
  }
| attribute_instances parameter_declaration SEMICOLON{
    $$ = ast_new_block_item_declaration(BLOCK_ITEM_PARAM, $1);
    $$ -> parameters = $2;
  }
| attribute_instances real_declaration{
    $$ = ast_new_block_item_declaration(BLOCK_ITEM_TYPE, $1);
    $$ -> event_or_var = $2;
  }
| attribute_instances realtime_declaration{
    $$ = ast_new_block_item_declaration(BLOCK_ITEM_TYPE, $1);
    $$ -> event_or_var = $2;
  }
| attribute_instances time_declaration{
    $$ = ast_new_block_item_declaration(BLOCK_ITEM_TYPE, $1);
    $$ -> event_or_var = $2;
  }
;

block_reg_declaration : 
  KW_REG signed_o range_o list_of_block_variable_identifiers SEMICOLON{
    $$ = ast_new_block_reg_declaration($2,$3,$4);
  }
;

list_of_block_variable_identifiers : 
  block_variable_type{
    $$ = ast_list_new();
    ast_list_append($$,$1);
  }
| list_of_block_variable_identifiers COMMA block_variable_type{
    $$ = $1;
    ast_list_append($$,$3);
}
;

block_variable_type : variable_identifier {$$=$1;}
                    | variable_identifier dimensions{$$=$1;}
                    ;

/* A.3.1 primitive instantiation and instances */

delay2_o : delay2 {$$=$1;}| {$$=NULL;};

gate_instantiation      : 
  cmos_switchtype cmos_switch_instances SEMICOLON{
    $$ = ast_new_gate_instantiation(GATE_CMOS);
    $$ -> switches = ast_new_switches($1,$2);
  }
| mos_switchtype mos_switch_instances SEMICOLON{
    $$ = ast_new_gate_instantiation(GATE_MOS);
    $$ -> switches = ast_new_switches($1,$2);
  }
| pass_switchtype pass_switch_instances SEMICOLON{
    $$ = ast_new_gate_instantiation(GATE_PASS);
    $$ -> switches = ast_new_switches($1,$2);
  }
| gate_enable SEMICOLON{
    $$ = ast_new_gate_instantiation(GATE_ENABLE);
    $$ -> enable = $1;
  }
| gate_n_output SEMICOLON {
    $$ = ast_new_gate_instantiation(GATE_N_OUT);
    $$ -> n_out = $1;
  }
| gate_pass_en_switch SEMICOLON{
    $$ = ast_new_gate_instantiation(GATE_PASS_EN);
    $$ -> pass_en = $1;
  }
| gate_n_input SEMICOLON{
    $$ = ast_new_gate_instantiation(GATE_N_IN);
    $$ -> n_in = $1;
  }
| KW_PULLDOWN pulldown_strength_o pull_gate_instances SEMICOLON{
    $$ = ast_new_gate_instantiation(GATE_PULL_UP);
    $$ -> pull_strength  = $2;
    $$ -> pull_gates     = $3;
  }
| KW_PULLUP pullup_strength_o pull_gate_instances SEMICOLON{
    $$ = ast_new_gate_instantiation(GATE_PULL_DOWN);
    $$ -> pull_strength  = $2;
    $$ -> pull_gates     = $3;
  }
;

/* -------------------------------------------------------------------------*/

OB : OPEN_BRACKET;
CB : CLOSE_BRACKET;

gate_n_output : 
  gatetype_n_output n_output_gate_instances{
    $$ = ast_new_n_output_gate_instances($1,NULL,NULL,$2);
  }
| gatetype_n_output OB drive_strength delay2 n_output_gate_instances{
    $$ = ast_new_n_output_gate_instances($1,$4,$3,$5);
  }
| gatetype_n_output OB drive_strength n_output_gate_instances{
    $$ = ast_new_n_output_gate_instances($1,NULL,$3,$4);
  }
| gatetype_n_output delay2 n_output_gate_instances {
    $$ = ast_new_n_output_gate_instances($1,$2,NULL,$3);
  }
| gatetype_n_output OB output_terminal COMMA input_terminal CB
  gate_n_output_a_id{
    $$ = ast_new_n_output_gate_instances($1,NULL,NULL,$7);
  }
;

gate_n_output_a_id  : {$$ = NULL;}
                    | COMMA n_output_gate_instances {$$=$2;}
                    ;

gatetype_n_output       : KW_BUF {$$ = N_OUT_BUF;}
                        | KW_NOT {$$ = N_OUT_NOT;}
                        ;

n_output_gate_instances : 
  n_output_gate_instance{
    $$ = ast_list_new();
    ast_list_append($$,$1);
  }
| n_output_gate_instances COMMA 
  n_output_gate_instance{
    $$ = $1;
    ast_list_append($$,$3);
  }
;

n_output_gate_instance  : 
  name_of_gate_instance OPEN_BRACKET output_terminals COMMA
  input_terminal CLOSE_BRACKET{
    $$ = ast_new_n_output_gate_instance($1,$3,$5);
  }
;

/* -------------------------------------------------------------------------*/

gate_enable : 
  enable_gatetype enable_gate_instances{
    $$ = ast_new_enable_gate_instances($1,NULL,NULL,$2);
}
| enable_gatetype OB drive_strength delay2 enable_gate_instances{
    $$ = ast_new_enable_gate_instances($1,NULL,NULL,$5);
}
| enable_gatetype OB drive_strength enable_gate_instances{
    $$ = ast_new_enable_gate_instances($1,NULL,$3,$4);
}
| enable_gatetype OB output_terminal COMMA input_terminal COMMA 
  enable_terminal CB COMMA n_output_gate_instances{
    ast_enable_gate_instance * gate = ast_new_enable_gate_instance(
        ast_new_identifier("unamed_gate",yylineno), $3,$7,$5);
    ast_list_preappend($10,gate);
    $$ = ast_new_enable_gate_instances($1,NULL,NULL,$10);
}
| enable_gatetype OB output_terminal COMMA input_terminal COMMA 
  enable_terminal CB{
    ast_enable_gate_instance * gate = ast_new_enable_gate_instance(
        ast_new_identifier("unamed_gate",yylineno), $3,$7,$5);
    ast_list * list = ast_list_new();
    ast_list_append(list,gate);
    $$ = ast_new_enable_gate_instances($1,NULL,NULL,list);
}
| enable_gatetype delay3 enable_gate_instances{
    $$ = ast_new_enable_gate_instances($1,$2,NULL,$3);
}
;

enable_gate_instances : 
  enable_gate_instance{
    $$ = ast_list_new();
    ast_list_append($$,$1);
  }
| enable_gate_instances COMMA enable_gate_instance {
    $$ = $1;
    ast_list_append($$,$3);
}
;

enable_gate_instance  : 
name_of_gate_instance OPEN_BRACKET output_terminal COMMA
input_terminal COMMA enable_terminal CLOSE_BRACKET{
    $$ = ast_new_enable_gate_instance($1,$3,$7,$5);
}
;

enable_gatetype     : KW_BUFIF0 {$$ = EN_BUFIF0;}
                    | KW_BUFIF1 {$$ = EN_BUFIF1;}
                    | KW_NOTIF0 {$$ = EN_NOTIF0;}
                    | KW_NOTIF1 {$$ = EN_NOTIF1;}
                    ;

/* -------------------------------------------------------------------------*/

gate_n_input : 
  gatetype_n_input n_input_gate_instances{
    $$ = ast_new_n_input_gate_instances($1,NULL,NULL,$2);
  }
| gatetype_n_input OB drive_strength delay2 n_input_gate_instances{
    $$ = ast_new_n_input_gate_instances($1,NULL,$3,$5);
  }
| gatetype_n_input OB drive_strength n_input_gate_instances {
    $$ = ast_new_n_input_gate_instances($1,NULL,$3,$4);
  }
| gatetype_n_input OB output_terminal COMMA input_terminals CB {
    ast_n_input_gate_instance * gate = ast_new_n_input_gate_instance(
        ast_new_identifier("unamed_gate",yylineno), $5,$3);
    ast_list * list = ast_list_new();
    ast_list_append(list,gate);
    $$ = ast_new_n_input_gate_instances($1,NULL,NULL,list);
  }
| gatetype_n_input OB output_terminal COMMA input_terminals CB 
  COMMA n_input_gate_instances{
    
    ast_n_input_gate_instance * gate = ast_new_n_input_gate_instance(
        ast_new_identifier("unamed_gate",yylineno), $5,$3);
    ast_list * list = $8;
    ast_list_preappend(list,gate);
    $$ = ast_new_n_input_gate_instances($1,NULL,NULL,list);
  }
| gatetype_n_input delay3 n_input_gate_instances{
    $$ = ast_new_n_input_gate_instances($1,$2,NULL,$3);
}
             ;


gatetype_n_input    : KW_AND  { $$ = N_IN_AND ;}
                    | KW_NAND { $$ = N_IN_NAND;}
                    | KW_OR   { $$ = N_IN_OR  ;}
                    | KW_NOR  { $$ = N_IN_NOR ;}
                    | KW_XOR  { $$ = N_IN_XOR ;}
                    | KW_XNOR { $$ = N_IN_XNOR;}
                    ;

/* -------------------------------------------------------------------------*/

gate_pass_en_switch : 
  KW_TRANIF0  delay2 pass_enable_switch_instances{
      $$ = ast_new_pass_enable_switches(PASS_EN_TRANIF0,$2,$3);
  }
| KW_TRANIF1  delay2 pass_enable_switch_instances{
      $$ = ast_new_pass_enable_switches(PASS_EN_TRANIF1,$2,$3);
  }
| KW_RTRANIF1 delay2 pass_enable_switch_instances{
      $$ = ast_new_pass_enable_switches(PASS_EN_RTRANIF0,$2,$3);
  }
| KW_RTRANIF0 delay2 pass_enable_switch_instances{
      $$ = ast_new_pass_enable_switches(PASS_EN_RTRANIF1,$2,$3);
  }
;

pass_enable_switch_instances : 
  pass_enable_switch_instance{
    $$ = ast_list_new();
    ast_list_append($$,$1);
  }
| pass_enable_switch_instances COMMA pass_enable_switch_instance{
    $$ = ast_list_new();
    ast_list_append($$,$1);
  }
;


pass_enable_switch_instance  : 
 name_of_gate_instance OPEN_BRACKET inout_terminal COMMA inout_terminal COMMA
 enable_terminal CLOSE_BRACKET{
    $$ = ast_new_pass_enable_switch($1,$3,$5,$7);
 }
;


/* -------------------------------------------------------------------------*/

pull_gate_instances : 
  pull_gate_instance{
    $$ = ast_list_new();
    ast_list_append($$,$1);
  }
| pull_gate_instances COMMA pull_gate_instance{
    $$ = ast_list_new();
    ast_list_append($$,$1);
  }
;

pass_switch_instances : 
  pass_switch_instance{
    $$ = ast_list_new();
    ast_list_append($$,$1);
  }
| pass_switch_instances COMMA pass_switch_instance{
    $$ = ast_list_new();
    ast_list_append($$,$1);
  }
;

n_input_gate_instances : 
   n_input_gate_instance{
    $$ = ast_list_new();
    ast_list_append($$,$1);
  }
 | n_input_gate_instances COMMA n_input_gate_instance{
    $$ = ast_list_new();
    ast_list_append($$,$1);
  }
 ;

mos_switch_instances : 
  mos_switch_instance{
    $$ = ast_list_new();
    ast_list_append($$,$1);
  }
| mos_switch_instances COMMA mos_switch_instance{
    $$ = ast_list_new();
    ast_list_append($$,$1);
  }
;

cmos_switch_instances : 
  cmos_switch_instance{
    $$ = ast_list_new();
    ast_list_append($$,$1);
  }
| cmos_switch_instances COMMA cmos_switch_instance{
    $$ = ast_list_new();
    ast_list_append($$,$1);
  }
;


pull_gate_instance           : 
  name_of_gate_instance OPEN_BRACKET output_terminal CLOSE_BRACKET{
    $$ = ast_new_pull_gate_instance($1,$3);
  }
;

pass_switch_instance         : 
  name_of_gate_instance OPEN_BRACKET inout_terminal COMMA inout_terminal 
  CLOSE_BRACKET{
    $$ = ast_new_pass_switch_instance($1,$3,$5);
  }
;


n_input_gate_instance        : 
  name_of_gate_instance OPEN_BRACKET output_terminal COMMA input_terminals 
  CLOSE_BRACKET{
    $$ = ast_new_n_input_gate_instance($1,$5,$3);
  }
;

mos_switch_instance          : 
  name_of_gate_instance OPEN_BRACKET output_terminal COMMA input_terminal 
  COMMA enable_terminal CLOSE_BRACKET {
    $$ = ast_new_mos_switch_instance($1,$3,$7,$5);
  }
;

cmos_switch_instance         : 
  name_of_gate_instance OPEN_BRACKET output_terminal COMMA input_terminal
  COMMA ncontrol_terminal COMMA pcontrol_terminal CLOSE_BRACKET{
    $$ = ast_new_cmos_switch_instance($1,$3,$7,$9,$5);
  }
;

output_terminals             : 
  output_terminals COMMA output_terminal{
    $$ = $1;
    ast_list_append($$,$3);
  }
 | output_terminal{
    $$ = ast_list_new();
    ast_list_append($$,$1);
  }
 ;

input_terminals              : 
input_terminal{
    $$ = ast_list_new();
    ast_list_append($$,$1);
  }
| input_terminals COMMA input_terminal{
    $$ = $1;
    ast_list_append($$,$3);
  }
;

/* A.3.2 primitive strengths */

pulldown_strength_o : pulldown_strength {$$=$1;}
| { 
$$ = ast_new_primitive_pull_strength(PULL_NONE,STRENGTH_NONE,STRENGTH_NONE); 
};

pulldown_strength           : 
   OPEN_BRACKET strength0 COMMA strength1 CLOSE_BRACKET{
    $$ = ast_new_primitive_pull_strength(PULL_DOWN,$2,$4);
 }
 | OPEN_BRACKET strength1 COMMA strength0 CLOSE_BRACKET{
    $$ = ast_new_primitive_pull_strength(PULL_DOWN,$2,$4);
 }
 | OPEN_BRACKET strength1 CLOSE_BRACKET{
    $$ = ast_new_primitive_pull_strength(PULL_DOWN,$2,$2);
 }
 ;

pullup_strength_o : pullup_strength {$$=$1;}
| { 
$$ = ast_new_primitive_pull_strength(PULL_NONE,STRENGTH_NONE,STRENGTH_NONE); 
};

pullup_strength             : 
   OPEN_BRACKET strength0 COMMA strength1 CLOSE_BRACKET{
    $$ = ast_new_primitive_pull_strength(PULL_UP,$2,$4);
 }
 | OPEN_BRACKET strength1 COMMA strength0 CLOSE_BRACKET{
    $$ = ast_new_primitive_pull_strength(PULL_UP,$2,$4);
 }
 | OPEN_BRACKET strength1 CLOSE_BRACKET{
    $$ = ast_new_primitive_pull_strength(PULL_UP,$2,$2);
 }
 ;


name_of_gate_instance   : 
  gate_instance_identifier range_o {$$ = $1;}
| {$$ = ast_new_identifier("Unnamed gate instance", yylineno);}
;

/* A.3.3 primitive terminals */

enable_terminal     : expression {$$=$1;};
input_terminal      : expression {$$=$1;};
ncontrol_terminal   : expression {$$=$1;};
pcontrol_terminal   : expression {$$=$1;};
inout_terminal      : net_lvalue {$$=$1;};
output_terminal     : net_lvalue {$$=$1;}; 

/* A.3.4 primitive gate and switch types */

cmos_switchtype     : 
  KW_CMOS  delay3 {$$ = ast_new_switch_gate_d3(SWITCH_CMOS ,$2);}
| KW_RCMOS delay3 {$$ = ast_new_switch_gate_d3(SWITCH_RCMOS,$2);}
;

mos_switchtype      : 
  KW_NMOS  delay3 {$$ = ast_new_switch_gate_d3(SWITCH_NMOS ,$2);}
| KW_PMOS  delay3 {$$ = ast_new_switch_gate_d3(SWITCH_PMOS ,$2);}
| KW_RNMOS delay3 {$$ = ast_new_switch_gate_d3(SWITCH_RNMOS,$2);}
| KW_RPMOS delay3 {$$ = ast_new_switch_gate_d3(SWITCH_RPMOS,$2);}
;

pass_switchtype     : 
  KW_TRAN  delay2 {$$ = ast_new_switch_gate_d2(SWITCH_TRAN ,$2);}
| KW_RTRAN delay2 {$$ = ast_new_switch_gate_d2(SWITCH_RTRAN,$2);}
;

/* A.4.1 module instantiation */

module_instantiation: 
  module_identifier HASH delay_value parameter_value_assignment_o module_instances 
  SEMICOLON{
     $$ = ast_new_module_instantiation($1,$4,$5);
   }
| module_identifier parameter_value_assignment_o module_instances SEMICOLON{
     $$ = ast_new_module_instantiation($1,$2,$3);
   }
;

parameter_value_assignment_o : parameter_value_assignment {$$=$1;} 
                             | {$$=NULL;};

parameter_value_assignment : 
HASH OPEN_BRACKET list_of_parameter_assignments CLOSE_BRACKET {$$=$3;}
;

list_of_parameter_assignments : 
   ordered_parameter_assignments {$$=$1;}
 | named_parameter_assignments {$$=$1;}
 ;

ordered_parameter_assignments : 
  ordered_parameter_assignment{
    $$ = ast_list_new();
    ast_list_append($$,$1);
  }
| ordered_parameter_assignments COMMA ordered_parameter_assignment{
    $$ = $1;
    ast_list_append($$,$3);
  }
;
named_parameter_assignments   : 
  named_parameter_assignment{
    $$ = ast_list_new();
    ast_list_append($$,$1);
  }
| named_parameter_assignments COMMA named_parameter_assignment{
    $$ = $1;
    ast_list_append($$,$3);
  }
;

module_instances : module_instance{
    $$ = ast_list_new();
    ast_list_append($$,$1);
  }
| module_instances COMMA module_instance{
    $$ = $1;
    ast_list_append($$,$3);
  }
;

ordered_parameter_assignment : expression{
    $$=$1;
};

named_parameter_assignment : 
DOT parameter_identifier OPEN_BRACKET expression_o CLOSE_BRACKET {
    $$ = ast_new_named_port_connection($2,$4);
}
;

module_instance : 
  name_of_instance OPEN_BRACKET list_of_port_connections CLOSE_BRACKET{
    $$ = ast_new_module_instance($1,$3);
  }
;

name_of_instance : module_instance_identifier range_o {$$=$1;}
                 ;

list_of_port_connections : {$$=NULL;}
                         | ordered_port_connections {$$=$1;}
                         | named_port_connections {$$=$1;}
                         ;

ordered_port_connections : 
  ordered_port_connection{
    $$ = ast_list_new();
    ast_list_append($$,$1);
  }
| ordered_port_connections COMMA ordered_port_connection{
    $$ = $1;
    ast_list_append($$,$3);
  }
;

named_port_connections   : 
  named_port_connection {
    $$ = ast_list_new();
    ast_list_append($$,$1);
  }
| named_port_connections COMMA named_port_connection{
    $$ = $1;
    ast_list_append($$,$3);
}
;

ordered_port_connection : attribute_instances expression_o{
    if($2 == NULL){ $$ = NULL;}
    else{
        $2 -> attributes = $1;
        $$ = $2;
    }
}
;

named_port_connection : 
  DOT port_identifier OPEN_BRACKET expression_o CLOSE_BRACKET {
    $$ = ast_new_named_port_connection($2,$4);
  }
;

expression_o : expression {$$=$1;}  
             | {$$=NULL;};

/* A.4.2 Generated instantiation */

generated_instantiation : KW_GENERATE generate_items KW_ENDGENERATE {
    char * id = calloc(25,sizeof(char));
    sprintf(id,"gen_%d",yylineno);
    ast_identifier new_id = ast_new_identifier(id,yylineno);
    $$ = ast_new_generate_block(new_id,$2);
};

generate_items : 
  generate_item{
      $$ = ast_list_new();
      ast_list_append($$,$1);
  }
| generate_items generate_item{
    $$ = $1;
    ast_list_append($$,$2);
  }
;

generate_item_or_null: generate_item {$$=$1;}| {$$=NULL;};

generate_item : 
  generate_conditional_statement{
    $$ = ast_new_generate_item(STM_CONDITIONAL,$1);
  }
| generate_case_statement{
    $$ = ast_new_generate_item(STM_CASE,$1);
  }
| generate_loop_statement{
    $$ = ast_new_generate_item(STM_LOOP,$1);
  }
| generate_block{
    $$ = ast_new_generate_item(STM_GENERATE,$1);
  }
| module_or_generate_item{
    if($1 != NULL){
        $$ = ast_new_generate_item(STM_MODULE_ITEM,$1);
    } else{
        $$ = NULL;
    }
  }
;

generate_conditional_statement : 
  KW_IF OPEN_BRACKET constant_expression CLOSE_BRACKET generate_item_or_null
  KW_ELSE generate_item_or_null{
    ast_conditional_statement * c1 = ast_new_conditional_statement($5,$3);
    $$ = ast_new_if_else(c1,$7);
  }
| KW_IF OPEN_BRACKET constant_expression CLOSE_BRACKET generate_item_or_null{
    ast_conditional_statement * c1 = ast_new_conditional_statement($5,$3);
    $$ = ast_new_if_else(c1,NULL);
  }
;

generate_case_statement : 
KW_CASE OPEN_BRACKET constant_expression CLOSE_BRACKET genvar_case_items 
KW_ENDCASE{
    $$ = ast_new_case_statement($3,$5,CASE);
}
;

genvar_case_items : 
  genvar_case_item{
    $$ = ast_list_new();
    ast_list_append($$,$1);
  }
| genvar_case_items genvar_case_item{
    $$ = $1;
    ast_list_append($$,$2);
  }
| {$$=NULL;}
;

genvar_case_item : 
  constant_expressions COLON generate_item_or_null{
    $$ = ast_new_case_item($1,$3);
  }
| KW_DEFAULT COLON generate_item_or_null{
    $$ = ast_new_case_item(NULL,$3);
    $$ -> is_default = AST_TRUE;
  }
| KW_DEFAULT generate_item_or_null{
    $$ = ast_new_case_item(NULL,$2);
    $$ -> is_default = AST_TRUE;
  }
;

generate_loop_statement : 
 KW_FOR OPEN_BRACKET genvar_assignment SEMICOLON 
 constant_expression
 SEMICOLON genvar_assignment CLOSE_BRACKET KW_BEGIN COLON
 generate_block_identifier generate_items KW_END{
    $$ = ast_new_generate_loop_statement($12, $3,$7,$5);
 }
;

genvar_assignment : genvar_identifier EQ constant_expression{
    ast_lvalue * lv = ast_new_lvalue_id(GENVAR_IDENTIFIER,$1);
    $$ = ast_new_single_assignment(lv, $3);
};

generate_block : 
  KW_BEGIN generate_items KW_END{
    char * id = calloc(25,sizeof(char));
    sprintf(id,"gen_%d",yylineno);
    ast_identifier new_id = ast_new_identifier(id,yylineno);
    $$ = ast_new_generate_block(new_id, $2);
  }
| KW_BEGIN COLON generate_block_identifier generate_items KW_END{
    $$ = ast_new_generate_block($3, $4);
  }
;

/* A.5.1 UDP Declaration */

udp_declaration : 
  attribute_instances KW_PRIMITIVE udp_identifier OPEN_BRACKET udp_port_list
  CLOSE_BRACKET SEMICOLON udp_port_declarations udp_body KW_ENDPRIMITIVE{
    printf("%d %s Need to re-write this rule.\n",__LINE__,__FILE__);

    ast_node_attributes * attrs      = $1;
    ast_identifier        id         = $3;
    ast_list            * ports      = $8;
    ast_udp_body        * body       = $9;

    $$ = ast_new_udp_declaration(attrs,id,ports,body);

  }
| attribute_instances KW_PRIMITIVE udp_identifier OPEN_BRACKET
  udp_declaration_port_list CLOSE_BRACKET SEMICOLON udp_body KW_ENDPRIMITIVE{
    $$ = ast_new_udp_declaration($1,$3,$5,$8);
  }
;

udp_port_declarations : 
  udp_port_declaration{
    $$ = ast_list_new();
    ast_list_append($$,$1);
  }
| udp_port_declarations udp_port_declaration{
    $$ = $1;
    ast_list_append($$,$1);
  }
;

/* A.5.2 UDP Ports */

udp_port_list : output_port_identifier COMMA input_port_identifiers{
    $$ = $3;
    ast_list_preappend($$,$1);
};

input_port_identifiers : 
  input_port_identifier{
    $$ = ast_list_new();
    ast_list_append($$,$1);
  }
| input_port_identifiers COMMA input_port_identifier{
    $$ = $1;
    ast_list_append($$,$3);
  }
;

udp_declaration_port_list :
  udp_output_declaration COMMA udp_input_declarations{
    $$ = $3;
    ast_list_preappend($$,$1);
  }
;

udp_input_declarations  : 
  udp_input_declaration{
    $$ = ast_list_new();
    ast_list_append($$,$1);
  }
| udp_input_declarations udp_input_declaration{
    $$ = $1;
    ast_list_append($$,$1);
  }
;

udp_port_declaration : 
  udp_output_declaration SEMICOLON {$$=$1;}
| udp_input_declaration SEMICOLON {$$=$1;}
| udp_reg_declaration SEMICOLON {$$=$1;}
;

udp_output_declaration : 
  attribute_instances KW_OUTPUT port_identifier{
    $$ = ast_new_udp_port(PORT_OUTPUT, $3,$1,AST_FALSE, NULL);
  }
| attribute_instances KW_OUTPUT KW_REG port_identifier{
    $$ = ast_new_udp_port(PORT_OUTPUT, $4,$1,AST_TRUE, NULL);
  }
|attribute_instances KW_OUTPUT KW_REG port_identifier EQ constant_expression{
    $$ = ast_new_udp_port(PORT_OUTPUT, $4,$1,AST_TRUE, $6);
  }
;

udp_input_declaration : 
    attribute_instances KW_INPUT list_of_port_identifiers{
        $$ = ast_new_udp_input_port($3,$1);
    }
;

udp_reg_declaration : attribute_instances KW_REG variable_identifier{
        $$ = ast_new_udp_port(PORT_NONE,$3,$1,AST_TRUE,NULL);
    }
;

/* A.5.3 UDP body */

udp_body            : 
  KW_TABLE combinational_entrys KW_ENDTABLE{
    $$ = ast_new_udp_combinatoral_body($2);
  }
| udp_initial_statement KW_TABLE sequential_entrys KW_ENDTABLE{
    $$ = ast_new_udp_sequential_body($1,$3);
  }
| KW_TABLE sequential_entrys KW_ENDTABLE{
    $$ = ast_new_udp_sequential_body(NULL,$2);
  }
;

sequential_entrys     : sequential_entry{
    $$ = ast_list_new();
    ast_list_append($$,$1);
}
| sequential_entrys sequential_entry{
    $$ = $1;
    ast_list_append($$,$2);
};

combinational_entrys : 
  combinational_entry{
    $$ = ast_list_new();
    ast_list_append($$,$1);
  }
| combinational_entrys combinational_entry{
    $$ = $1;
    ast_list_append($$,$2);
  }
;

combinational_entry : level_symbols COLON output_symbol SEMICOLON{
    $$ = ast_new_udp_combinatoral_entry($1,$3);   
};

sequential_entry      : 
  level_symbols   COLON level_symbol COLON next_state SEMICOLON{
    $$ = ast_new_udp_sequential_entry(PREFIX_LEVELS, $1, $3, $5);
  }
| edge_input_list COLON level_symbol COLON next_state SEMICOLON{
    $$ = ast_new_udp_sequential_entry(PREFIX_EDGES, $1, $3, $5);
  }
;

udp_initial_statement : 
    KW_INITIAL output_port_identifier EQ init_val SEMICOLON{
        $$ = ast_new_udp_initial_statement($2,$4);
    }
;

init_val              : unsigned_number { $$ = $1; }
                      | number          { $$ = $1; }
                      ;

level_symbols_o       : level_symbols {$$=$1;} | {$$=NULL;} ;

level_symbols         : 
  level_symbol {
    $$ = ast_list_new();
    ast_list_append($$,&$1);
  }
| level_symbols level_symbol{
    $$= $1;
    ast_list_append($$,&$2);
  }
;

edge_input_list       :  level_symbols_o edge_indicator level_symbols_o{
    $$ = ast_list_new(); /** TODO FIX THIS */
};

edge_indicator        : 
  OPEN_BRACKET level_symbol level_symbol CLOSE_BRACKET {
    $2 == LEVEL_0 && $3 == LEVEL_1 ? $$ = EDGE_POS:
    $2 == LEVEL_1 && $3 == LEVEL_0 ? $$ = EDGE_NEG:
                                          EDGE_ANY     ;
  }
 | edge_symbol {$$ = $1;}
 ;

next_state            : output_symbol  {$$=$1;}
                      | MINUS {$$=UDP_NEXT_STATE_DC;}
                      ;

output_symbol : 
  unsigned_number {$$ = UDP_NEXT_STATE_X; /*TODO FIX THIS*/}
| 'X'       {$$ = UDP_NEXT_STATE_X;}
| 'x'       {$$ = UDP_NEXT_STATE_X;}
| TERNARY   {$$ = UDP_NEXT_STATE_QM;}
| SIMPLE_ID {$$ = UDP_NEXT_STATE_X;}
;

level_symbol :
  unsigned_number {$$ = LEVEL_X;}
| 'X'             {$$ = LEVEL_X;}
| 'x'             {$$ = LEVEL_X;}
| TERNARY         {$$ = LEVEL_Q;}
| 'B'             {$$ = LEVEL_B;}
| 'b'             {$$ = LEVEL_B;}
| SIMPLE_ID       {$$ = LEVEL_X;}
;

edge_symbol : /* can be r,f,p,n or star in any case. */
  'r'   {$$ = EDGE_POS;}
| 'R'   {$$ = EDGE_POS;}
| 'f'   {$$ = EDGE_NEG;}
| 'F'   {$$ = EDGE_NEG;}
| 'p'   {$$ = EDGE_POS;}
| 'P'   {$$ = EDGE_POS;}
| 'n'   {$$ = EDGE_NEG;}
| 'N'   {$$ = EDGE_NEG;}
| SIMPLE_ID {      if (strcmp(yylval.string,"r") == 0) $$ = EDGE_POS ;
              else if (strcmp(yylval.string,"R") == 0) $$ = EDGE_POS ;
              else if (strcmp(yylval.string,"f") == 0) $$ = EDGE_NEG ;
              else if (strcmp(yylval.string,"F") == 0) $$ = EDGE_NEG ;
              else if (strcmp(yylval.string,"p") == 0) $$ = EDGE_POS ;
              else if (strcmp(yylval.string,"P") == 0) $$ = EDGE_POS ;
              else if (strcmp(yylval.string,"n") == 0) $$ = EDGE_NEG ;
              else                                     $$ = EDGE_NEG ;
  }
| STAR {$$ = EDGE_ANY;}
;

/* A.5.4 UDP instantiation */

udp_instantiation : 
  udp_identifier drive_strength_o delay2_o udp_instances SEMICOLON{
    $$ = ast_new_udp_instantiation($4,$1,$2,$3);
  }
;

udp_instances : 
  udp_instance{
    $$ = ast_list_new();
    ast_list_append($$,$1);
  }
| udp_instances COMMA udp_instance{
    $$ = $1;
    ast_list_append($$,$3);
}
;

udp_instance : 
  udp_instance_identifier range_o OPEN_BRACKET output_terminal COMMA
  input_terminals CLOSE_BRACKET{
    $$ = ast_new_udp_instance($1,$2,$4,$6);
  }
 | OPEN_BRACKET output_terminal COMMA input_terminals CLOSE_BRACKET{
    $$ = ast_new_udp_instance(NULL,NULL,$2,$4);
  }
 ;


/* A.6.1 Continuous assignment statements */

continuous_assign : 
    KW_ASSIGN drive_strength_o delay3_o list_of_net_assignments SEMICOLON{
      $$ = ast_new_continuous_assignment($4,$2,$3);
    }
;

list_of_net_assignments : 
  net_assignment{
    $$ = ast_list_new();
    ast_list_append($$,$1);
  }
| list_of_net_assignments COMMA net_assignment{
    $$ = $1;
    ast_list_append($$,$3);
  }
;

net_assignment : net_lvalue EQ expression{
    $$ = ast_new_single_assignment($1,$3);   
};

/* A.6.2 Procedural blocks and assignments */

initial_construct   : KW_INITIAL statement{$$ = $2;};
always_construct    : KW_ALWAYS statement {$$ = $2;};

blocking_assignment : variable_lvalue EQ delay_or_event_control_o expression{
    $$ = ast_new_blocking_assignment($1,$4,$3);   
};

nonblocking_assignment : variable_lvalue LTE delay_or_event_control_o 
                      expression{
    $$ = ast_new_nonblocking_assignment($1,$4,$3);   
};

delay_or_event_control_o : delay_or_event_control{$$=$1;} | {$$=NULL;};

procedural_continuous_assignments : 
  KW_ASSIGN variable_assignment{
      $$ = ast_new_hybrid_assignment(HYBRID_ASSIGNMENT_ASSIGN, $2);
  }
| KW_DEASSIGN variable_lvalue{
      $$ = ast_new_hybrid_lval_assignment(HYBRID_ASSIGNMENT_DEASSIGN, $2);
  }
| KW_FORCE variable_assignment{
      $$ = ast_new_hybrid_assignment(HYBRID_ASSIGNMENT_FORCE_VAR, $2);
  }
| KW_FORCE net_assignment{
      $$ = ast_new_hybrid_assignment(HYBRID_ASSIGNMENT_FORCE_NET, $2);
  }
| KW_RELEASE variable_lvalue{
      $$ = ast_new_hybrid_lval_assignment(HYBRID_ASSIGNMENT_RELEASE_VAR, $2);
  }
| KW_RELEASE net_lvalue{
      $$ = ast_new_hybrid_lval_assignment(HYBRID_ASSIGNMENT_RELEASE_NET, $2);
  }
;

function_blocking_assignment : variable_lvalue EQ expression{
    $$ = ast_new_single_assignment($1,$3);
};

function_statement_or_null : function_statement {$$ =$1;}
                           | attribute_instances SEMICOLON {$$=NULL;}
                           ;

/* A.6.3 Parallel and sequential blocks */

block_item_declarations     : 
  block_item_declaration{
    $$ = ast_list_new();
    ast_list_append($$,$1);
  }
| block_item_declarations block_item_declaration{
    $$ = $1;
    ast_list_append($$,$2);
}
;

function_statements_o   : function_statements {$$=$1;} | {$$=NULL;};

function_statements     : 
  function_statement{
    $$ = ast_list_new();
    ast_list_append($$,$1);
  }
| function_statements function_statement{
    $$ = $1;
    ast_list_append($$,$2);
}
;

function_seq_block : 
  KW_BEGIN function_statements_o KW_END{
    $$ = ast_new_statement_block(BLOCK_FUNCTION_SEQUENTIAL,NULL,NULL,$2);
  }
| KW_BEGIN COLON block_identifier block_item_declarations
  function_statements_o KW_END{
    $$ = ast_new_statement_block(BLOCK_FUNCTION_SEQUENTIAL,$3,$4,$5);
  }
;

variable_assignment : variable_lvalue EQ expression{
    $$ = ast_new_single_assignment($1,$3);
};

par_block : 
  KW_FORK statements_o KW_JOIN{
    $$ = ast_new_statement_block(BLOCK_PARALLEL,NULL,NULL,$2);
  }
| KW_FORK COLON block_identifier block_item_declarations statements_o KW_JOIN{
    $$ = ast_new_statement_block(BLOCK_PARALLEL,$3,$4,$5);
  }
;

seq_block : 
  KW_BEGIN statements_o KW_END{
    $$ = ast_new_statement_block(BLOCK_SEQUENTIAL,NULL,NULL,$2);
  }
| KW_BEGIN COLON block_identifier block_item_declarations statements_o KW_END{
    $$ = ast_new_statement_block(BLOCK_SEQUENTIAL,$3,$4,$5);
  }
;

/* A.6.4 Statements */

statements_o : statements {$$=$1;} | {$$=NULL;} ;

statements   : 
statement{
    $$ = ast_list_new();
    ast_list_append($$,$1);
  }
| statements statement{
    $$ = $1;
    ast_list_append($$,$2);
}
             ;

statement : 
  attribute_instances blocking_assignment SEMICOLON{
    $$ = ast_new_statement($1,AST_FALSE, $2, STM_ASSIGNMENT);
  }
| attribute_instances task_enable{
    $$ = ast_new_statement($1,AST_FALSE, $2, STM_TASK_ENABLE);
  }
| attribute_instances nonblocking_assignment SEMICOLON{
    $$ = ast_new_statement($1,AST_FALSE, $2, STM_ASSIGNMENT);
  }
| attribute_instances case_statement{
    $$ = ast_new_statement($1,AST_FALSE, $2, STM_CASE);
  }
| attribute_instances conditional_statement{
    $$ = ast_new_statement($1,AST_FALSE, $2, STM_CONDITIONAL);
  }
| attribute_instances disable_statement{
    $$ = ast_new_statement($1,AST_FALSE, $2, STM_DISABLE);
  }
| attribute_instances event_trigger{
    $$ = ast_new_statement($1,AST_FALSE, $2, STM_EVENT_TRIGGER);
  }
| attribute_instances loop_statement{
    $$ = ast_new_statement($1,AST_FALSE, $2, STM_LOOP);
  }
| attribute_instances par_block{
    $$ = ast_new_statement($1,AST_FALSE, $2, STM_BLOCK);
  }
| attribute_instances procedural_continuous_assignments SEMICOLON{
    $$ = ast_new_statement($1,AST_FALSE, $2, STM_ASSIGNMENT);
  }
| attribute_instances procedural_timing_control_statement{
    $$ = ast_new_statement($1,AST_FALSE, $2, STM_TIMING_CONTROL);
  }
| attribute_instances seq_block{
    $$ = ast_new_statement($1,AST_FALSE, $2, STM_BLOCK);
  }
| attribute_instances system_function_call SEMICOLON{
    $$ = ast_new_statement($1,AST_FALSE, $2, STM_FUNCTION_CALL);
  }
| attribute_instances system_task_enable{
    $$ = ast_new_statement($1,AST_FALSE, $2, STM_TASK_ENABLE);
  }
| attribute_instances wait_statement{
    $$ = ast_new_statement($1,AST_FALSE, $2, STM_WAIT);
  }
;

statement_or_null : statement {$$=$1;}
                  | attribute_instances SEMICOLON{$$=NULL;}
                  | SEMICOLON{$$=NULL;}
                  ;
                  
function_statement : 
  attribute_instances function_blocking_assignment SEMICOLON{
    $$ = ast_new_statement($1,AST_TRUE, $2, STM_ASSIGNMENT);
  }
| attribute_instances function_case_statement{
    $$ = ast_new_statement($1,AST_TRUE, $2, STM_CASE);
  }
| attribute_instances function_conditional_statement{
    $$ = ast_new_statement($1,AST_TRUE, $2, STM_CONDITIONAL);
  }
| attribute_instances function_loop_statement{
    $$ = ast_new_statement($1,AST_TRUE, $2, STM_LOOP);
  }
| attribute_instances function_seq_block{
    $$ = ast_new_statement($1,AST_TRUE, $2, STM_BLOCK);
  }
| attribute_instances disable_statement{
    $$ = ast_new_statement($1,AST_TRUE, $2, STM_DISABLE);
  }
| attribute_instances system_function_call SEMICOLON{
    $$ = ast_new_statement($1,AST_TRUE, $2, STM_FUNCTION_CALL);
  }
| attribute_instances system_task_enable{
    $$ = ast_new_statement($1,AST_TRUE, $2, STM_TASK_ENABLE);
  }
;

/* A.6.5 Timing control statements */


procedural_timing_control_statement : 
  delay_or_event_control statement_or_null{
    $$ = $1;
    $$ -> statement = $2;
  }
;

delay_or_event_control : 
  delay_control{
    $$ = ast_new_timing_control_statement_delay(
         TIMING_CTRL_DELAY_CONTROL,
         NULL,
         $1
    );
  }
| event_control{
    $$ = ast_new_timing_control_statement_event(
         TIMING_CTRL_EVENT_CONTROL,
         NULL,
         NULL,
         $1
    );
  }
| KW_REPEAT OPEN_BRACKET expression CLOSE_BRACKET event_control{
    $$ = ast_new_timing_control_statement_event(
         TIMING_CTRL_EVENT_CONTROL_REPEAT,
         $3,
         NULL,
         $5
    );
}
;

delay_control : 
  HASH delay_value{
    $$ = ast_new_delay_ctrl_value($2);
  }
| HASH OPEN_BRACKET mintypmax_expression CLOSE_BRACKET{
    $$ = ast_new_delay_ctrl_mintypmax($3);
  }
;


disable_statement : 
  KW_DISABLE hierarchical_task_identifier SEMICOLON{
      $$ = ast_new_disable_statement($2);
  }
| KW_DISABLE hierarchical_block_identifier SEMICOLON{
      $$ = ast_new_disable_statement($2);
  }
;

event_control : 
  AT event_identifier{
    ast_primary * p = ast_new_primary(PRIMARY_IDENTIFIER);
    p -> value.identifier = $2;
    ast_expression * id = ast_new_expression_primary(p);
    ast_event_expression * ct = ast_new_event_expression(EVENT_CTRL_TRIGGERS,
        id);
    $$ = ast_new_event_control(EVENT_CTRL_TRIGGERS, ct);
  }
| AT OPEN_BRACKET event_expression CLOSE_BRACKET{
    $$ = ast_new_event_control(EVENT_CTRL_TRIGGERS, $3);
  }
| AT STAR{
    $$ = ast_new_event_control(EVENT_CTRL_ANY, NULL);
  }
/* Add attribute_start here since the tokeniser may return it an it still be
 * valid.*/
| AT ATTRIBUTE_START CLOSE_BRACKET {
    $$ = ast_new_event_control(EVENT_CTRL_ANY, NULL);
  }
| AT OPEN_BRACKET STAR CLOSE_BRACKET{
    $$ = ast_new_event_control(EVENT_CTRL_ANY, NULL);
  }
;

event_trigger : 
  MINUS GT hierarchical_event_identifier {$$=$3;}
;

event_expression : 
  expression{
    $$ = ast_new_event_expression(EDGE_ANY, $1);
}
| KW_POSEDGE expression{
    $$ = ast_new_event_expression(EDGE_POS, $2);
}
| KW_NEGEDGE expression{
    $$ = ast_new_event_expression(EDGE_NEG, $2);
}
| event_expression KW_OR event_expression{
    $$ = ast_new_event_expression_sequence($1,$3);
}
| event_expression COMMA event_expression{
    $$ = ast_new_event_expression_sequence($1,$3);
}
;

wait_statement : 
  KW_WAIT OPEN_BRACKET expression CLOSE_BRACKET statement_or_null{
    $$ = ast_new_wait_statement($3,$5);
  }
;

/* A.6.6 Conditional Statemnets */

conditional_statement : 
  KW_IF OPEN_BRACKET expression CLOSE_BRACKET statement_or_null{
    ast_conditional_statement * first = ast_new_conditional_statement($5,$3);
    $$ = ast_new_if_else(first,NULL);
   }
| KW_IF OPEN_BRACKET expression CLOSE_BRACKET statement_or_null KW_ELSE 
  statement_or_null{
    ast_conditional_statement * first = ast_new_conditional_statement($5,$3);
    $$ = ast_new_if_else(first,$7);
   }
| if_else_if_statement {$$ = $1;}
;

if_else_if_statement : 
  KW_IF OPEN_BRACKET expression CLOSE_BRACKET statement_or_null 
  else_if_statements{
    ast_conditional_statement * first = ast_new_conditional_statement($5,$3);
    $$ = ast_new_if_else(first, NULL);
    ast_extend_if_else($$,$6);
  }
| KW_IF OPEN_BRACKET expression CLOSE_BRACKET statement_or_null 
  else_if_statements KW_ELSE statement_or_null{
    ast_conditional_statement * first = ast_new_conditional_statement($5,$3);
    $$ = ast_new_if_else(first, $8);
    ast_extend_if_else($$,$6);
  }
;

else_if_statements : 
  KW_ELSE KW_IF OPEN_BRACKET expression CLOSE_BRACKET statement_or_null{
    $$ = ast_list_new();
    ast_list_append($$, ast_new_conditional_statement($6,$4));
  }
| else_if_statements KW_ELSE KW_IF OPEN_BRACKET expression
  CLOSE_BRACKET statement_or_null{
    $$ = $1;
    ast_list_append($$,ast_new_conditional_statement($7,$5));
  }
;

function_conditional_statement : 
   KW_IF OPEN_BRACKET expression CLOSE_BRACKET function_statement_or_null{
    ast_conditional_statement * first = ast_new_conditional_statement($5,$3);
    $$ = ast_new_if_else(first,NULL);
   }
 | KW_IF OPEN_BRACKET expression CLOSE_BRACKET function_statement_or_null 
   KW_ELSE function_statement_or_null{
    ast_conditional_statement * first = ast_new_conditional_statement($5,$3);
    $$ = ast_new_if_else(first,$7);
   }
 | function_if_else_if_statement{
    $$ = $1;
 }
 ;

function_else_if_statements   : 
  KW_ELSE KW_IF OPEN_BRACKET expression CLOSE_BRACKET 
  function_statement_or_null{
    $$ = ast_list_new();
    ast_list_append($$, ast_new_conditional_statement($6,$4));
  }
| function_else_if_statements KW_ELSE KW_IF OPEN_BRACKET expression 
  CLOSE_BRACKET function_statement_or_null{
    $$ = $1;
    ast_list_append($$,ast_new_conditional_statement($7,$5));
  }
;

function_if_else_if_statement : 
  KW_IF OPEN_BRACKET expression CLOSE_BRACKET function_statement_or_null
  function_else_if_statements{
    ast_conditional_statement * first = ast_new_conditional_statement($5,$3);
    $$ = ast_new_if_else(first, NULL);
    ast_extend_if_else($$,$6);
  }
| KW_IF OPEN_BRACKET expression CLOSE_BRACKET function_statement_or_null
  function_else_if_statements KW_ELSE function_statement_or_null{
    ast_conditional_statement * first = ast_new_conditional_statement($5,$3);
    $$ = ast_new_if_else(first, $8);
    ast_extend_if_else($$,$6);
  }
;

/* A.6.7 Case Statements */

case_statement  : 
  KW_CASE OPEN_BRACKET expression CLOSE_BRACKET case_items KW_ENDCASE{
    $$ = ast_new_case_statement($3, $5, CASE);
  }
| KW_CASEZ OPEN_BRACKET expression CLOSE_BRACKET case_items KW_ENDCASE{
    $$ = ast_new_case_statement($3, $5, CASEZ);
  }
| KW_CASEX OPEN_BRACKET expression CLOSE_BRACKET case_items KW_ENDCASE{
    $$ = ast_new_case_statement($3, $5, CASEX);
  }
;

case_items      : 
  case_item{
    $$ = ast_list_new();
    ast_list_append($$, $1);
  }
| case_items case_item{
    $$ = $1;
    ast_list_append($$, $2);
  }
                ;

expressions_o   : expressions {$$ = $1;} |{$$=ast_list_new();}
                ;


case_item       : 
  expressions COLON statement_or_null{
    $$ = ast_new_case_item($1,$3);
  }
| KW_DEFAULT statement_or_null{
    $$ = ast_new_case_item(NULL,$2);
    $$ -> is_default = AST_TRUE;
  }
| KW_DEFAULT COLON statement_or_null{
    $$ = ast_new_case_item(NULL,$3);
    $$ -> is_default = AST_TRUE;
  }
;

function_case_statement : 
  KW_CASE OPEN_BRACKET expression CLOSE_BRACKET  function_case_items 
  KW_ENDCASE{
    $$ = ast_new_case_statement($3, $5, CASE);
    $$ -> is_function = AST_TRUE;
  }
| KW_CASEZ OPEN_BRACKET expression CLOSE_BRACKET function_case_items
  KW_ENDCASE{
    $$ = ast_new_case_statement($3, $5, CASEZ);
    $$ -> is_function = AST_TRUE;
  }
| KW_CASEX OPEN_BRACKET expression CLOSE_BRACKET function_case_items
  KW_ENDCASE{
    $$ = ast_new_case_statement($3, $5, CASEX);
    $$ -> is_function = AST_TRUE;
  }
;

function_case_items     : 
  function_case_item {
    $$ = ast_list_new();
    ast_list_append($$, $1);
  }
| function_case_items function_case_item{
    $$ = $1;
    ast_list_append($$, $2);
  }
;

function_case_item      : 
  expressions COLON function_statement_or_null{
    $$ = ast_new_case_item($1, $3);
    $$ -> is_default = AST_FALSE;
  }
| KW_DEFAULT function_statement_or_null{
    $$ = ast_new_case_item(NULL, $2);
    $$ -> is_default = AST_TRUE;
  }
| KW_DEFAULT COLON function_statement_or_null{
    $$ = ast_new_case_item(NULL, $3);
    $$ -> is_default = AST_TRUE;
  }
;

/* A.6.8 looping statements */

function_loop_statement : 
  KW_FOREVER function_statement{
    $$ = ast_new_forever_loop_statement($2);
  }
| KW_REPEAT OPEN_BRACKET expression CLOSE_BRACKET function_statement{
    $$ = ast_new_repeat_loop_statement($5,$3);
  }
| KW_WHILE OPEN_BRACKET expression CLOSE_BRACKET function_statement{
    $$ = ast_new_while_loop_statement($5,$3);
  }
| KW_FOR OPEN_BRACKET variable_assignment SEMICOLON expression
  SEMICOLON variable_assignment  CLOSE_BRACKET function_statement{
    $$ = ast_new_for_loop_statement($9, $3, $7,$5);
  }
;

loop_statement          : 
  KW_FOREVER statement{
    $$ = ast_new_forever_loop_statement($2);
  }
| KW_REPEAT OPEN_BRACKET expression CLOSE_BRACKET statement{
    $$ = ast_new_repeat_loop_statement($5,$3);
  }
| KW_WHILE OPEN_BRACKET expression CLOSE_BRACKET statement{
    $$ = ast_new_while_loop_statement($5,$3);
  }
| KW_FOR OPEN_BRACKET variable_assignment SEMICOLON expression SEMICOLON
  variable_assignment  CLOSE_BRACKET statement{
    $$ = ast_new_for_loop_statement($9, $3, $7,$5);
  }
;


/* A.6.9 task enable statements */

system_task_enable      : 
    system_task_identifier OPEN_BRACKET expressions CLOSE_BRACKET SEMICOLON {
        $$ = ast_new_task_enable_statement($3,$1,AST_TRUE);
    }
|   system_task_identifier SEMICOLON {
        $$ = ast_new_task_enable_statement(NULL,$1,AST_TRUE);
    }
    ;

task_enable             : 
    hierarchical_task_identifier SEMICOLON{
        $$ = ast_new_task_enable_statement(NULL,$1,AST_FALSE);
    }
|   hierarchical_task_identifier OPEN_BRACKET expressions CLOSE_BRACKET 
    SEMICOLON{
        $$ = ast_new_task_enable_statement($3,$1,AST_FALSE);
    }
;

/* A.7.1 specify block declaration */

specify_block           : KW_SPECIFY specify_items_o KW_ENDSPECIFY {$$ = $2;}
                        ;

specify_items_o         : specify_items {$$ = $1;}
                        | {$$ = ast_list_new();}
                        ;

specify_items           : specify_item{
                            $$ = ast_list_new();
                            ast_list_append($$,$1);
                        }
                        | specify_items specify_item{
                            $$ = $1;
                            ast_list_append($$,$2);
                        }
                        ;

specify_item            : specparam_declaration
                        | pulsestyle_declaration
                        | showcancelled_declaration
                        | path_declaration
                        | system_timing_check {printf("%s:%d: System Timing check not supported\n", __FILE__, __LINE__);}
                        ;

pulsestyle_declaration  : KW_PULSESTYLE_ONEVENT list_of_path_outputs SEMICOLON
                        | KW_PULSESTYLE_ONDETECT list_of_path_outputs SEMICOLON
                        ;

showcancelled_declaration   : KW_SHOWCANCELLED list_of_path_outputs SEMICOLON
                            | KW_NOSHOWCANCELLED list_of_path_outputs SEMICOLON
                            ;

/* A.7.2 specify path declarations */

path_declaration : simple_path_declaration          SEMICOLON {$$=$1;}
                 | edge_sensitive_path_declaration  SEMICOLON {$$=$1;}
                 | state_dependent_path_declaration SEMICOLON {$$=$1;}
                 ;

simple_path_declaration : 
  OPEN_BRACKET specify_input_terminal_descriptor polarity_operator_o EQ GT
  specify_output_terminal_descriptor CLOSE_BRACKET EQ path_delay_value{
    $$ = ast_new_path_declaration(SIMPLE_PARALLEL_PATH);
    $$ -> parallel = ast_new_simple_parallel_path_declaration(
        $2,$3,$6,$9
    );
  }
| OPEN_BRACKET list_of_path_inputs polarity_operator_o STAR GT 
  list_of_path_outputs CLOSE_BRACKET EQ path_delay_value{
    $$ = ast_new_path_declaration(SIMPLE_FULL_PATH);
    $$ -> full = ast_new_simple_full_path_declaration(
        $2,$3,$6,$9
    );
  }
;


list_of_path_inputs   : 
  specify_input_terminal_descriptor {
    $$ = ast_list_new();
    ast_list_append($$,$1);
  }
| list_of_path_inputs COMMA specify_input_terminal_descriptor{
    $$ = $1;
    ast_list_append($$,$3);
  }
;

list_of_path_outputs  : 
  specify_output_terminal_descriptor {
    $$ = ast_list_new();
    ast_list_append($$,$1);
  }
| list_of_path_outputs COMMA specify_output_terminal_descriptor{
    $$ = $1;
    ast_list_append($$,$3);
  }
;

/* A.7.3 specify block terminals */

specify_input_terminal_descriptor :/* TODO FIX THIS */
  input_identifier {$$ = $1;}
| input_identifier constant_expression {$$ = $1;}
| input_identifier range_expression {$$ = $1;}
;

specify_output_terminal_descriptor :
  output_identifier {$$ = $1;}
| output_identifier constant_expression {$$ = $1;}
| output_identifier range_expression {$$ = $1;}
;

input_identifier : input_port_identifier {$$ = $1;}
                 | inout_port_identifier {$$ = $1;}
                 ;

output_identifier : output_port_identifier  {$$ = $1;}
                  | inout_port_identifier {$$ = $1;}
                  ;

/* A.7.4 specify path delays */

path_delay_value : list_of_path_delay_expressions {$$=$1;}
                 | OPEN_BRACKET list_of_path_delay_expressions CLOSE_BRACKET
                   {$$=$2;}
                 ;

list_of_path_delay_expressions : 
  path_delay_expression{
    $$ = ast_list_new();
    ast_list_append($$,$1);
  }
| path_delay_expression COMMA
  path_delay_expression {
    $$ = ast_list_new(); ast_list_append($$,$1); ast_list_append($$,$3);
  }
| path_delay_expression COMMA
  path_delay_expression COMMA
  path_delay_expression{
    $$ = ast_list_new(); ast_list_append($$,$1); ast_list_append($$,$3);
    ast_list_append($$,$5);
  }
| path_delay_expression COMMA
  path_delay_expression COMMA
  path_delay_expression COMMA
  path_delay_expression COMMA
  path_delay_expression COMMA
  path_delay_expression{
    $$ = ast_list_new(); ast_list_append($$,$1); ast_list_append($$,$3);
    ast_list_append($$,$5); ast_list_append($$,$7); ast_list_append($$,$9);
    ast_list_append($$,$11);
  }
| path_delay_expression COMMA
  path_delay_expression COMMA
  path_delay_expression COMMA
  path_delay_expression COMMA
  path_delay_expression COMMA
  path_delay_expression COMMA
  path_delay_expression COMMA
  path_delay_expression COMMA
  path_delay_expression COMMA
  path_delay_expression COMMA
  path_delay_expression COMMA
  path_delay_expression{
    $$ = ast_list_new();  ast_list_append($$,$1);  ast_list_append($$,$3);
    ast_list_append($$,$5);  ast_list_append($$,$7);  ast_list_append($$,$9);
    ast_list_append($$,$11); ast_list_append($$,$13); ast_list_append($$,$15);
    ast_list_append($$,$17); ast_list_append($$,$19); ast_list_append($$,$21);
    ast_list_append($$,$23);

  }
;

path_delay_expression : constant_mintypmax_expression  {$$=$1;};

edge_sensitive_path_declaration : 
  OPEN_BRACKET edge_identifier_o specify_input_terminal_descriptor EQ GT
  specify_output_terminal_descriptor polarity_operator_o COLON
  data_source_expression CLOSE_BRACKET EQ path_delay_value{
    $$ = ast_new_path_declaration(EDGE_SENSITIVE_PARALLEL_PATH);
    $$ -> es_parallel = 
        ast_new_edge_sensitive_parallel_path_declaration($2,$3,$7,$6,$9,$12);
  }
| OPEN_BRACKET edge_identifier_o list_of_path_inputs STAR GT
  list_of_path_outputs polarity_operator_o COLON data_source_expression
  CLOSE_BRACKET EQ path_delay_value{
    $$ = ast_new_path_declaration(EDGE_SENSITIVE_FULL_PATH);
    $$ -> es_full= 
        ast_new_edge_sensitive_full_path_declaration($2,$3,$7,$6,$9,$12);
  }
;

data_source_expression : expression  {$$=$1;};

edge_identifier_o : edge_identifier  {$$=$1;}
                  | {$$ = EDGE_NONE;}
                  ;
edge_identifier   : KW_POSEDGE {$$=EDGE_POS;} 
                  | KW_NEGEDGE {$$=EDGE_NEG;}
                  ;

state_dependent_path_declaration : 
  KW_IF OPEN_BRACKET module_path_expression CLOSE_BRACKET
  simple_path_declaration{
    $$ = $5;
    if($$ -> type == SIMPLE_PARALLEL_PATH)
        $$ -> type = STATE_DEPENDENT_PARALLEL_PATH;
    else if($$ -> type == SIMPLE_FULL_PATH)
        $$ -> type = STATE_DEPENDENT_FULL_PATH;
    else
        printf("%s:%d ERROR, invalid path declaration type when state dependent\n",
            __FILE__,__LINE__);
  }
| KW_IF OPEN_BRACKET module_path_expression CLOSE_BRACKET 
  edge_sensitive_path_declaration{
    $$ = $5;
    if($$ -> type == EDGE_SENSITIVE_PARALLEL_PATH)
        $$ -> type = STATE_DEPENDENT_EDGE_PARALLEL_PATH;
    else if($$ -> type == EDGE_SENSITIVE_FULL_PATH)
        $$ -> type = STATE_DEPENDENT_EDGE_FULL_PATH;
    else
        printf("%s:%d ERROR, invalid path declaration type when state dependent\n",
            __FILE__,__LINE__);
  }

| KW_IFNONE simple_path_declaration{
    $$ = $2;
    }
;

polarity_operator_o : polarity_operator  {$$=$1;}
                    |  {$$=OPERATOR_NONE;}
                    ;

polarity_operator : PLUS  {$$=$1;}
                  | MINUS {$$=$1;}
                  ;

/* A.7.5.1 System timing check commands */

system_timing_check : {printf("%s:%d Not Supported\n",__FILE__,__LINE__);};

/* A.7.5.2 System timing check command arguments */

/* A.7.5.3 System timing check evet definitions */

/* A.8.1 Concatenations */

concatenation : 
  OPEN_SQ_BRACE expression concatenation_cont{
    $$ = $3;
    ast_extend_concatenation($3,NULL,$2);
  }
;

concatenation_cont :
  CLOSE_SQ_BRACE {
      $$ = ast_new_empty_concatenation(CONCATENATION_EXPRESSION);
  }
| COMMA expression concatenation_cont{
      $$ = $3;
      ast_extend_concatenation($3,NULL,$2);
  }
;

constant_concatenation : 
  OPEN_SQ_BRACE expression constant_concatenation_cont{
    $$ = $3;
    ast_extend_concatenation($3,NULL,$2);
  }
;

constant_concatenation_cont : 
  CLOSE_SQ_BRACE{
      $$ = ast_new_empty_concatenation(CONCATENATION_EXPRESSION);
  }
| COMMA expression concatenation_cont{
      $$ = $3;
      ast_extend_concatenation($3,NULL,$2);
  }
;

multiple_concatenation :
  OPEN_SQ_BRACE constant_expression concatenation CLOSE_SQ_BRACE{
    $$ = $3;
    $$ -> repeat = $2;
  }
| OPEN_SQ_BRACE constant_expression concatenation_cont{
    $$ = $3;
    $$ -> repeat = $2;
  }
;

constant_multiple_concatenation : 
  OPEN_SQ_BRACE constant_expression constant_concatenation CLOSE_SQ_BRACE{
    $$ = $3;
    $$ -> repeat = $2;
  }
| OPEN_SQ_BRACE constant_expression constant_concatenation_cont{
    $$ = $3;
    $$ -> repeat = $2;
  }
;

module_path_concatenation : 
  OPEN_SQ_BRACE module_path_expression modpath_concatenation_cont{
      $$ = $3;
      ast_extend_concatenation($3,NULL,$2);
  }
;

modpath_concatenation_cont : 
  CLOSE_SQ_BRACE{
      $$ = ast_new_empty_concatenation(CONCATENATION_MODULE_PATH);
  }
| COMMA module_path_expression modpath_concatenation_cont{
      $$ = $3;
      ast_extend_concatenation($3,NULL,$2);
  }
;

module_path_multiple_concatenation : 
  OPEN_SQ_BRACE constant_expression module_path_concatenation CLOSE_SQ_BRACE{
      $$ = $3;
      $3 -> repeat = $2;
  }
;

net_concatenation :
  OPEN_SQ_BRACE net_concatenation_value net_concatenation_cont{
      $$ = $3;
      ast_extend_concatenation($3,NULL,$2);
  }
;

net_concatenation_cont :
  CLOSE_SQ_BRACE{
      $$ = ast_new_empty_concatenation(CONCATENATION_NET);
  }
| COMMA net_concatenation_value net_concatenation_cont{
      $$ = $3;
      ast_extend_concatenation($3,NULL,$2);
  }
;

sq_bracket_expressions :
  OPEN_SQ_BRACKET expression CLOSE_SQ_BRACKET{
      $$ = ast_list_new();
      ast_list_append($$,$2);
  }
| OPEN_SQ_BRACKET range_expression CLOSE_SQ_BRACKET{
      $$ = ast_list_new();
      ast_list_append($$,$2);
  }
| OPEN_SQ_BRACKET expression CLOSE_SQ_BRACKET sq_bracket_expressions{
      $$ = $4;
      ast_list_preappend($$,$2);
  }
;

net_concatenation_value : /* TODO - fix proper identifier stuff. */
  hierarchical_net_identifier {
      $$ = ast_new_concatenation(CONCATENATION_NET,NULL,$1);
  }
| hierarchical_net_identifier sq_bracket_expressions {
      $$ = ast_new_concatenation(CONCATENATION_NET,NULL,$1);
  }
| hierarchical_net_identifier sq_bracket_expressions range_expression {
      $$ = ast_new_concatenation(CONCATENATION_NET,NULL,$1);
  }
| hierarchical_net_identifier range_expression {
      $$ = ast_new_concatenation(CONCATENATION_NET,NULL,$1);
  }
| net_concatenation {
      $$ = $1;
  }
;

variable_concatenation :
  OPEN_SQ_BRACE variable_concatenation_value variable_concatenation_cont{
      $$ = $3;
      ast_extend_concatenation($3,NULL,$2);
  }
;

variable_concatenation_cont :
  CLOSE_SQ_BRACE{
      $$ = ast_new_empty_concatenation(CONCATENATION_VARIABLE);
  }
| COMMA variable_concatenation_value variable_concatenation_cont{
      $$ = $3;
      ast_extend_concatenation($3,NULL,$2);
  }
;

variable_concatenation_value : /* TODO - fix proper identifier stuff. */
  hierarchical_variable_identifier {
      $$ = ast_new_concatenation(CONCATENATION_NET,NULL,$1);
  }
| hierarchical_variable_identifier sq_bracket_expressions {
      $$ = ast_new_concatenation(CONCATENATION_NET,NULL,$1);
  }
| hierarchical_variable_identifier sq_bracket_expressions range_expression {
      $$ = ast_new_concatenation(CONCATENATION_NET,NULL,$1);
  }
| hierarchical_variable_identifier range_expression {
      $$ = ast_new_concatenation(CONCATENATION_NET,NULL,$1);
  }
| variable_concatenation {
      $$ = $1;
  }
;


/* A.8.2 Function calls */

constant_expressions :
  constant_expression{
        $$ = ast_list_new();
        ast_list_append($$,$1);
  }
| constant_expressions COMMA constant_expression{
        $$ = $1;
        ast_list_append($$,$3);
  }
;

expressions :
  expression {
        $$ = ast_list_new();
        ast_list_append($$,$1);
  }
| expressions COMMA expression{
        $$ = $1;
        ast_list_append($$,$3);
  }
;

constant_function_call :
  function_identifier attribute_instances OPEN_BRACKET constant_expressions 
  CLOSE_BRACKET{
    $$ = ast_new_function_call($1,AST_FALSE,AST_FALSE,$2,$4);
 }
;

constant_function_call_pid :
  attribute_instances OPEN_BRACKET constant_expressions CLOSE_BRACKET{
    $$ = ast_new_function_call(NULL,AST_TRUE,AST_FALSE,$1,$3);
 }
;

function_call : hierarchical_function_identifier
 attribute_instances OPEN_BRACKET expressions CLOSE_BRACKET{
    $$ = ast_new_function_call($1,AST_FALSE,AST_FALSE,$2,$4);
 }
;

system_function_call : 
  system_function_identifier{
    $$ = ast_new_function_call($1,AST_FALSE,AST_TRUE,NULL,NULL);
  }
| system_function_identifier OPEN_BRACKET CLOSE_BRACKET{
    $$ = ast_new_function_call($1,AST_FALSE,AST_TRUE,NULL,NULL);
  }
| system_function_identifier OPEN_BRACKET expressions CLOSE_BRACKET{
    $$ = ast_new_function_call($1,AST_FALSE,AST_TRUE,NULL,$3);
  }
;


/* A.8.3 Expressions */

conditional_expression : 
  expression TERNARY attribute_instances expression COLON expression{
    $$ = ast_new_conditional_expression($1,$4,$6,$3);
  }

;

constant_expression:
  constant_primary {$$ = ast_new_expression_primary($1);}
| unary_operator attribute_instances constant_primary{
    $$ = ast_new_unary_expression($3,$1,$2,AST_TRUE);
  }
| constant_expression PLUS  attribute_instances constant_expression{
    $$ = ast_new_binary_expression($1,$4,$2,$3,AST_TRUE);
  }
| constant_expression MINUS attribute_instances constant_expression{
    $$ = ast_new_binary_expression($1,$4,$2,$3,AST_TRUE);
  }
| constant_expression STAR  attribute_instances constant_expression{
    $$ = ast_new_binary_expression($1,$4,$2,$3,AST_TRUE);
  }
| constant_expression DIV   attribute_instances constant_expression{
    $$ = ast_new_binary_expression($1,$4,$2,$3,AST_TRUE);
  }
| constant_expression MOD   attribute_instances constant_expression{
    $$ = ast_new_binary_expression($1,$4,$2,$3,AST_TRUE);
  }
| constant_expression L_EQ  attribute_instances constant_expression{
    $$ = ast_new_binary_expression($1,$4,$2,$3,AST_TRUE);
  }
| constant_expression L_NEQ attribute_instances constant_expression{
    $$ = ast_new_binary_expression($1,$4,$2,$3,AST_TRUE);
  }
| constant_expression C_EQ  attribute_instances constant_expression{
    $$ = ast_new_binary_expression($1,$4,$2,$3,AST_TRUE);
  }
| constant_expression C_NEQ attribute_instances constant_expression{
    $$ = ast_new_binary_expression($1,$4,$2,$3,AST_TRUE);
  }
| constant_expression L_AND attribute_instances constant_expression{
    $$ = ast_new_binary_expression($1,$4,$2,$3,AST_TRUE);
  }
| constant_expression L_OR  attribute_instances constant_expression{
    $$ = ast_new_binary_expression($1,$4,$2,$3,AST_TRUE);
  }
| constant_expression POW   attribute_instances constant_expression{
    $$ = ast_new_binary_expression($1,$4,$2,$3,AST_TRUE);
  }
| constant_expression LT    attribute_instances constant_expression{
    $$ = ast_new_binary_expression($1,$4,$2,$3,AST_TRUE);
  }
| constant_expression LTE   attribute_instances constant_expression{
    $$ = ast_new_binary_expression($1,$4,$2,$3,AST_TRUE);
  }
| constant_expression GT    attribute_instances constant_expression{
    $$ = ast_new_binary_expression($1,$4,$2,$3,AST_TRUE);
  }
| constant_expression GTE   attribute_instances constant_expression{
    $$ = ast_new_binary_expression($1,$4,$2,$3,AST_TRUE);
  }
| constant_expression B_AND attribute_instances constant_expression{
    $$ = ast_new_binary_expression($1,$4,$2,$3,AST_TRUE);
  }
| constant_expression B_OR  attribute_instances constant_expression{
    $$ = ast_new_binary_expression($1,$4,$2,$3,AST_TRUE);
  }
| constant_expression B_XOR attribute_instances constant_expression{
    $$ = ast_new_binary_expression($1,$4,$2,$3,AST_TRUE);
  }
| constant_expression B_EQU attribute_instances constant_expression{
    $$ = ast_new_binary_expression($1,$4,$2,$3,AST_TRUE);
  }
| constant_expression LSR   attribute_instances constant_expression{
    $$ = ast_new_binary_expression($1,$4,$2,$3,AST_TRUE);
  }
| constant_expression LSL   attribute_instances constant_expression{
    $$ = ast_new_binary_expression($1,$4,$2,$3,AST_TRUE);
  }
| constant_expression ASR   attribute_instances constant_expression{
    $$ = ast_new_binary_expression($1,$4,$2,$3,AST_TRUE);
  }
| constant_expression ASL   attribute_instances constant_expression{
    $$ = ast_new_binary_expression($1,$4,$2,$3,AST_TRUE);
  }
| constant_expression TERNARY attribute_instances constant_expression COLON
  constant_expression{
    $$ = ast_new_conditional_expression($1,$4,$6,$3);
  }
| string { $$ = ast_new_string_expression($1);}
;

constant_mintypmax_expression :
  constant_expression{
      $$ = ast_new_mintypmax_expression(NULL,$1,NULL);
  }
| constant_expression COLON constant_expression COLON constant_expression{
      $$ = ast_new_mintypmax_expression($1,$3,$5);
  }
;

constant_range_expression :
  constant_expression{
    $$ = ast_new_index_expression($1);
  }

| constant_expression COLON       constant_expression{
    $$ = ast_new_range_expression($1,$3);
  }
| constant_expression IDX_PRT_SEL constant_expression{
    $$ = ast_new_range_expression($1,$3);
  }
;

expression :
  primary {
    $$ = ast_new_expression_primary($1);
  }
| unary_operator attribute_instances primary{
    $$ = ast_new_unary_expression($3,$1,$2, AST_FALSE);
  }
| expression PLUS  attribute_instances expression{
    $$ = ast_new_binary_expression($1,$4,$2,$3,AST_FALSE);
  }
| expression MINUS attribute_instances expression{
    $$ = ast_new_binary_expression($1,$4,$2,$3,AST_FALSE);
  }
| expression STAR  attribute_instances expression{
    $$ = ast_new_binary_expression($1,$4,$2,$3,AST_FALSE);
  }
| expression DIV   attribute_instances expression{
    $$ = ast_new_binary_expression($1,$4,$2,$3,AST_FALSE);
  }
| expression MOD   attribute_instances expression{
    $$ = ast_new_binary_expression($1,$4,$2,$3,AST_FALSE);
  }
| expression L_EQ  attribute_instances expression{
    $$ = ast_new_binary_expression($1,$4,$2,$3,AST_FALSE);
  }
| expression L_NEQ attribute_instances expression{
    $$ = ast_new_binary_expression($1,$4,$2,$3,AST_FALSE);
  }
| expression C_EQ  attribute_instances expression{
    $$ = ast_new_binary_expression($1,$4,$2,$3,AST_FALSE);
  }
| expression C_NEQ attribute_instances expression{
    $$ = ast_new_binary_expression($1,$4,$2,$3,AST_FALSE);
  }
| expression L_AND attribute_instances expression{
    $$ = ast_new_binary_expression($1,$4,$2,$3,AST_FALSE);
  }
| expression L_OR  attribute_instances expression{
    $$ = ast_new_binary_expression($1,$4,$2,$3,AST_FALSE);
  }
| expression POW   attribute_instances expression{
    $$ = ast_new_binary_expression($1,$4,$2,$3,AST_FALSE);
  }
| expression LT    attribute_instances expression{
    $$ = ast_new_binary_expression($1,$4,$2,$3,AST_FALSE);
  }
| expression LTE   attribute_instances expression{
    $$ = ast_new_binary_expression($1,$4,$2,$3,AST_FALSE);
  }
| expression GT    attribute_instances expression{
    $$ = ast_new_binary_expression($1,$4,$2,$3,AST_FALSE);
  }
| expression GTE   attribute_instances expression{
    $$ = ast_new_binary_expression($1,$4,$2,$3,AST_FALSE);
  }
| expression B_AND attribute_instances expression{
    $$ = ast_new_binary_expression($1,$4,$2,$3,AST_FALSE);
  }
| expression B_OR  attribute_instances expression{
    $$ = ast_new_binary_expression($1,$4,$2,$3,AST_FALSE);
  }
| expression B_XOR attribute_instances expression{
    $$ = ast_new_binary_expression($1,$4,$2,$3,AST_FALSE);
  }
| expression B_NOR attribute_instances expression{
    $$ = ast_new_binary_expression($1,$4,$2,$3,AST_FALSE);
  }
| expression B_NAND attribute_instances expression{
    $$ = ast_new_binary_expression($1,$4,$2,$3,AST_FALSE);
  }
| expression B_EQU attribute_instances expression{
    $$ = ast_new_binary_expression($1,$4,$2,$3,AST_FALSE);
  }
| expression LSR   attribute_instances expression{
    $$ = ast_new_binary_expression($1,$4,$2,$3,AST_FALSE);
  }
| expression LSL   attribute_instances expression{
    $$ = ast_new_binary_expression($1,$4,$2,$3,AST_FALSE);
  }
| expression ASR   attribute_instances expression{
    $$ = ast_new_binary_expression($1,$4,$2,$3,AST_FALSE);
  }
| expression ASL   attribute_instances expression{
    $$ = ast_new_binary_expression($1,$4,$2,$3,AST_FALSE);
  }
| conditional_expression {$$=$1;}
| string {$$ = ast_new_string_expression($1);}
;

mintypmax_expression :
  expression{
      $$ = ast_new_mintypmax_expression(NULL,$1,NULL);
  }
| expression COLON expression COLON expression{
      $$ = ast_new_mintypmax_expression($1,$3,$5);
  }
;

module_path_conditional_expression :
  module_path_expression TERNARY attribute_instances module_path_expression
  COLON module_path_expression{
    $$ = ast_new_conditional_expression($1, $4, $6, $3);
    $$ -> type = MODULE_PATH_CONDITIONAL_EXPRESSION;
  }
;

module_path_expression :
  module_path_primary{
    $$ = ast_new_expression_primary($1);
    $$ -> type = MODULE_PATH_PRIMARY_EXPRESSION;
  }
| unary_module_path_operator attribute_instances module_path_primary{
    $$ = ast_new_unary_expression($3,$1,$2,AST_FALSE);
    $$ -> type = MODULE_PATH_UNARY_EXPRESSION;
}
| module_path_expression binary_module_path_operator attribute_instances
  module_path_expression{
    $$ = ast_new_binary_expression($1,$4,$2,$3,AST_FALSE);
    $$ -> type = MODULE_PATH_BINARY_EXPRESSION;
  }
| module_path_conditional_expression {$$ = $1;}
;

module_path_mintypemax_expression :
  module_path_expression {
      $$ = ast_new_mintypmax_expression(NULL,$1,NULL);
      $$ -> type = MODULE_PATH_MINTYPMAX_EXPRESSION;
  }
| module_path_expression COLON module_path_expression COLON 
  module_path_expression {
      $$ = ast_new_mintypmax_expression($1,$3,$5);
      $$ -> type = MODULE_PATH_MINTYPMAX_EXPRESSION;
  }

;

range_expression :
  expression {
    $$ = ast_new_index_expression($1);
  }
| expression COLON       constant_expression{
    $$ = ast_new_range_expression($1,$3);
  }

| expression IDX_PRT_SEL constant_expression %prec IDX_PRT_SEL{
    $$ = ast_new_range_expression($1,$3);
  }

;

/* A.8.4 Primaries */

constant_primary :
  constant_concatenation {
      $$ = ast_new_constant_primary(PRIMARY_CONCATENATION);
      $$ -> value.concatenation = $1;
}
| constant_function_call{
      $$ = ast_new_primary_function_call($1);
}
| OPEN_BRACKET constant_mintypmax_expression CLOSE_BRACKET{
      $$ = ast_new_constant_primary(PRIMARY_MINMAX_EXP);
      $$ -> value.minmax = $2;
}
| constant_multiple_concatenation{
      $$ = ast_new_constant_primary(PRIMARY_CONCATENATION);
      $$ -> value.concatenation = $1;
}
| genvar_identifier{
      $$ = ast_new_constant_primary(PRIMARY_IDENTIFIER);
      $$ -> value.identifier = $1;
}
| number{
      $$ = ast_new_constant_primary(PRIMARY_NUMBER);
      $$ -> value.number = $1;
}
| parameter_identifier{
      $$ = ast_new_constant_primary(PRIMARY_IDENTIFIER);
      $$ -> value.identifier = $1;
}
| specparam_identifier{
      $$ = ast_new_constant_primary(PRIMARY_IDENTIFIER);
      $$ -> value.identifier = $1;
}
| text_macro_usage{
      $$ = ast_new_constant_primary(PRIMARY_MACRO_USAGE);
      $$ -> value.identifier = $1;
}
;

primary :
  number{
      $$ = ast_new_primary(PRIMARY_NUMBER);
      $$ -> value.number = $1;
  }
| function_call{
      $$ = ast_new_primary_function_call($1);
  }
| hierarchical_identifier constant_function_call_pid{
      $2 -> function= $1;
      $$ = ast_new_primary_function_call($2);
  }
| SIMPLE_ID constant_function_call_pid{ // Weird quick, but it works.
      $2 -> function= $1;
      $$ = ast_new_primary_function_call($2);
  }
| system_function_call{
      $$ = ast_new_primary_function_call($1);
  }
| hierarchical_identifier sq_bracket_expressions{
      $$ = ast_new_primary(PRIMARY_IDENTIFIER);
      $$ -> value.identifier = $1;
  }
| hierarchical_identifier sq_bracket_expressions OPEN_SQ_BRACKET
  range_expression CLOSE_SQ_BRACKET{
      $$ = ast_new_primary(PRIMARY_IDENTIFIER);
      $$ -> value.identifier = $1;
  }
| concatenation{
      $$ = ast_new_primary(PRIMARY_CONCATENATION);
      $$ -> value.concatenation = $1;
  }
| multiple_concatenation{
      $$ = ast_new_primary(PRIMARY_CONCATENATION);
      $$ -> value.concatenation = $1;
  }
| hierarchical_identifier{
      $$ = ast_new_primary(PRIMARY_IDENTIFIER);
      $$ -> value.identifier = $1;
  }
| OPEN_BRACKET mintypmax_expression CLOSE_BRACKET{
      $$ = ast_new_primary(PRIMARY_MINMAX_EXP);
      $$ -> value.minmax = $2;
  }
| text_macro_usage{
      $$ = ast_new_primary(PRIMARY_MACRO_USAGE);
      $$ -> value.macro = $1;
  }
;

module_path_primary :
  number{
      $$ = ast_new_module_path_primary(PRIMARY_NUMBER);
      $$ -> value.number = $1;
  }

| identifier{
      $$ = ast_new_module_path_primary(PRIMARY_IDENTIFIER);
      $$ -> value.identifier= $1;
  }

| module_path_concatenation{
      $$ = ast_new_module_path_primary(PRIMARY_CONCATENATION);
      $$ -> value.concatenation = $1;
  }

| module_path_multiple_concatenation{
      $$ = ast_new_module_path_primary(PRIMARY_CONCATENATION);
      $$ -> value.concatenation = $1;
  }

| function_call{
      $$ = ast_new_primary_function_call($1);
  }
| system_function_call{
      $$ = ast_new_primary_function_call($1);
  }
| constant_function_call{
      $$ = ast_new_primary_function_call($1);
  }
| OPEN_BRACKET module_path_mintypemax_expression CLOSE_BRACKET{
      $$ = ast_new_module_path_primary(PRIMARY_MINMAX_EXP);
      $$ -> value.minmax = $2;
  }
| text_macro_usage{
      $$ = ast_new_module_path_primary(PRIMARY_MACRO_USAGE);
      $$ -> value.macro = $1;
  }
;

/* A.8.5 Expression left-side values */

sq_bracket_constant_expressions :
  OPEN_SQ_BRACKET constant_expression CLOSE_SQ_BRACKET
| OPEN_SQ_BRACKET constant_expression CLOSE_SQ_BRACKET 
  sq_bracket_constant_expressions
;

net_lvalue :
  hierarchical_net_identifier{
    $$ = ast_new_lvalue_id(NET_IDENTIFIER, $1);
  }
| hierarchical_net_identifier sq_bracket_constant_expressions{
    $$ = ast_new_lvalue_id(NET_IDENTIFIER, $1);
  }
| hierarchical_net_identifier sq_bracket_constant_expressions 
  OPEN_SQ_BRACKET constant_range_expression CLOSE_SQ_BRACKET{
    $$ = ast_new_lvalue_id(NET_IDENTIFIER, $1);
  }
| hierarchical_net_identifier OPEN_SQ_BRACKET constant_range_expression 
  CLOSE_SQ_BRACKET{
    $$ = ast_new_lvalue_id(NET_IDENTIFIER, $1);
  }
| net_concatenation {
    $$ = ast_new_lvalue_concat(NET_CONCATENATION, $1);
  }
;

variable_lvalue :
  hierarchical_variable_identifier{
    $$ = ast_new_lvalue_id(VAR_IDENTIFIER, $1);
  }
| hierarchical_variable_identifier sq_bracket_constant_expressions{
    $$ = ast_new_lvalue_id(VAR_IDENTIFIER, $1);
  }
| hierarchical_variable_identifier sq_bracket_constant_expressions 
  OPEN_SQ_BRACKET constant_range_expression CLOSE_SQ_BRACKET{
    $$ = ast_new_lvalue_id(VAR_IDENTIFIER, $1);
  }
| hierarchical_variable_identifier OPEN_SQ_BRACKET constant_range_expression 
  CLOSE_SQ_BRACKET{
    $$ = ast_new_lvalue_id(VAR_IDENTIFIER, $1);
  }
| variable_concatenation{
    $$ = ast_new_lvalue_concat(VAR_CONCATENATION, $1);
  }

;

/* A.8.6 Operators */

unary_operator : PLUS    {$$ = $1;}
               | MINUS   {$$ = $1;}
               | L_NEG   {$$ = $1;}
               | B_NEG   {$$ = $1;}
               | B_AND   {$$ = $1;}
               | B_NAND  {$$ = $1;}
               | B_OR    {$$ = $1;}
               | B_NOR   {$$ = $1;}
               | B_XOR   {$$ = $1;}
               | B_EQU   {$$ = $1;}
               ;


unary_module_path_operator  : L_NEG  {$$=$1;}
                            | B_NEG  {$$=$1;}
                            | B_AND  {$$=$1;}
                            | B_NAND {$$=$1;}
                            | B_OR   {$$=$1;}
                            | B_NOR  {$$=$1;}
                            | B_XOR  {$$=$1;}
                            | B_EQU  {$$=$1;}
                            ;

binary_module_path_operator : L_EQ   {$$=$1;}
                            | L_NEQ  {$$=$1;}
                            | L_AND  {$$=$1;}
                            | L_OR   {$$=$1;}
                            | B_AND  {$$=$1;}
                            | B_OR   {$$=$1;}                    
                            | B_XOR  {$$=$1;}                    
                            | B_EQU  {$$=$1;}
                            ;

/* A.8.7 Numbers */

unsigned_number :
  UNSIGNED_NUMBER {
    $$ = ast_new_number(BASE_DECIMAL, REP_BITS, $1);
  }
;

number :
  NUM_REAL{
    $$ = ast_new_number(BASE_DECIMAL,REP_BITS,$1);
  }
| BIN_BASE BIN_VALUE {
    $$ = ast_new_number(BASE_BINARY, REP_BITS, $2);
}
| HEX_BASE HEX_VALUE {
    $$ = ast_new_number(BASE_HEX, REP_BITS, $2);
}
| OCT_BASE OCT_VALUE {
    $$ = ast_new_number(BASE_OCTAL, REP_BITS, $2);
}
| DEC_BASE UNSIGNED_NUMBER{
    $$ = ast_new_number(BASE_DECIMAL, REP_BITS, $2);
}
| UNSIGNED_NUMBER BIN_BASE BIN_VALUE {
    $$ = ast_new_number(BASE_BINARY, REP_BITS, $3);
}
| UNSIGNED_NUMBER HEX_BASE HEX_VALUE {
    $$ = ast_new_number(BASE_HEX, REP_BITS, $3);
}
| UNSIGNED_NUMBER OCT_BASE OCT_VALUE {
    $$ = ast_new_number(BASE_OCTAL, REP_BITS, $3);
}
| UNSIGNED_NUMBER DEC_BASE UNSIGNED_NUMBER{
    $$ = ast_new_number(BASE_DECIMAL, REP_BITS, $3);
}
| unsigned_number {$$ = $1;}
;


/* A.8.8 Strings */

string : STRING;

/* A.9.1 Attributes */

attribute_instances : {$$=NULL;}
                    | list_of_attribute_instances {$$=$1;}
                    ;

list_of_attribute_instances : 
  ATTRIBUTE_START attr_specs ATTRIBUTE_END {
      $$ = $2;
  }
| attribute_instances ATTRIBUTE_START attr_specs ATTRIBUTE_END{
    if($1 != NULL){
        ast_append_attribute($1, $3);
        $$ = $1;
    } else {
        $$ = $3;
    }
  }
                            ;

attr_specs : {$$ = NULL;}
           | attr_spec {
               $$ = $1;
           }
           | attr_specs COMMA attr_spec {
               // Append the new item to the existing list and return.
               ast_append_attribute($1,$3);
               $$ = $1;
           }
           ;

attr_spec : attr_name EQ constant_expression
                {$$ = ast_new_attributes($1,$3);}
          | attr_name 
                {$$ = ast_new_attributes($1, NULL);}
          ;

attr_name : identifier {$$=$1;};

/* A.9.2 Comments */

comment             : one_line_comment {$$=$1;}
                    | block_comment    {$$=$1;}
                    ;

one_line_comment    : COMMENT_LINE {$$=$1;};

block_comment       : COMMENT_BLOCK {$$=$1;};

/* A.9.3 Identifiers */

escaped_arrayed_identifier      : escaped_identifier range_o{ 
    $$ = $1;
    if($2 != NULL){
        ast_identifier_set_range($$,$2);
    }
};

escaped_hierarchical_identifier : 
  escaped_hierarchical_branch escaped_hierarchical_identifiers{
    $$ = ast_append_identifier($1,$2);
}
| escaped_hierarchical_branch {
    $$ = $1;
}
;

escaped_hierarchical_identifiers: 
  DOT simple_hierarchical_identifier {$$=$2;}
| DOT escaped_hierarchical_identifier {$$=$2;}
| escaped_hierarchical_identifiers DOT simple_hierarchical_identifier {
    $$=ast_append_identifier($1,$3);
  }
| escaped_hierarchical_identifier DOT escaped_hierarchical_identifiers {
    $$=ast_append_identifier($1,$3);
  }
;

anys : anys ANY {$$=$2;}
     | ANY {$$ = $1;}
     ;


arrayed_identifier              : simple_arrayed_identifier     {$$=$1;}
                                | escaped_arrayed_identifier    {$$=$1;}
                                ;


hierarchical_identifier         : simple_hierarchical_identifier {$$=$1;}
                                | escaped_hierarchical_identifier{$$=$1;}
                                ;

hierarchical_net_identifier     : hierarchical_identifier
    {$$=$1; $$ -> type = ID_HIERARCHICAL_NET;};
hierarchical_variable_identifier: hierarchical_identifier
    {$$=$1; $$ -> type = ID_HIERARCHICAL_VARIABLE;};
hierarchical_task_identifier    : hierarchical_identifier
    {$$=$1; $$ -> type = ID_HIERARCHICAL_TASK;};
hierarchical_block_identifier   : hierarchical_identifier
    {$$=$1; $$ -> type = ID_HIERARCHICAL_BLOCK;};
hierarchical_event_identifier   : hierarchical_identifier
    {$$=$1; $$ -> type = ID_HIERARCHICAL_EVENT;};
hierarchical_function_identifier: hierarchical_identifier
    {$$=$1; $$ -> type = ID_FUNCTION;};
gate_instance_identifier        : arrayed_identifier
    {$$=$1; $$ -> type = ID_GATE_INSTANCE;};
module_instance_identifier      : arrayed_identifier
    {$$=$1; $$ -> type = ID_MODULE_INSTANCE;};
udp_instance_identifier         : arrayed_identifier
    {$$=$1; $$ -> type = ID_UDP_INSTANCE;};
block_identifier                : identifier 
    {$$=$1; $$ -> type = ID_BLOCK;};
cell_identifier                 : identifier 
    {$$=$1; $$ -> type = ID_CELL;};
config_identifier               : identifier 
    {$$=$1; $$ -> type = ID_CONFIG;};
event_identifier                : identifier 
    {$$=$1; $$ -> type = ID_EVENT;};
function_identifier             : identifier 
    {$$=$1; $$ -> type = ID_FUNCTION;};
generate_block_identifier       : identifier 
    {$$=$1; $$ -> type = ID_GENERATE_BLOCK;};
genvar_identifier               : identifier 
    {$$=$1; $$ -> type = ID_GENVAR;};
inout_port_identifier           : identifier 
    {$$=$1; $$ -> type = ID_INOUT_PORT;};
input_port_identifier           : identifier 
    {$$=$1; $$ -> type = ID_INPUT_PORT;};
instance_identifier             : identifier 
    {$$=$1; $$ -> type = ID_INSTANCE;};
library_identifier              : identifier 
    {$$=$1; $$ -> type = ID_LIBRARY;};
module_identifier               : identifier 
    {$$=$1; $$ -> type = ID_MODULE;};
net_identifier                  : 
  identifier {
    $$=$1; $$ -> type = ID_NET;
  }
| hierarchical_identifier {
    $$=$1; $$ -> type = ID_NET;
}
;
output_port_identifier          : identifier 
    {$$=$1; $$ -> type = ID_OUTPUT_PORT;};
specparam_identifier            : identifier 
    {$$=$1; $$ -> type = ID_SPECPARAM;};
task_identifier                 : identifier 
    {$$=$1; $$ -> type = ID_TASK;};
topmodule_identifier            : identifier 
    {$$=$1; $$ -> type = ID_TOPMODULE;};
udp_identifier                  : identifier 
    {$$=$1; $$ -> type = ID_UDP;};
variable_identifier             : identifier 
    {$$=$1; $$ -> type = ID_VARIABLE;};
parameter_identifier            : identifier 
    {$$=$1; $$ -> type = ID_PARAMETER;}
                                | hierarchical_identifier
    {$$=$1; $$ -> type = ID_PARAMETER;}
                                ;
port_identifier                 : 
 identifier {
     $$=$1; $$ -> type = ID_PORT;
  }
;

real_identifier                 : identifier 
    {$$=$1; $$ -> type = ID_REAL;};

identifier : 
  simple_identifier  {$$=$1;}
| escaped_identifier {$$=$1;}
| text_macro_usage {$$=$1;}
;

simple_identifier: 
  SIMPLE_ID {
    $$ = $1;
}
| text_macro_usage {
    $$ = $1;
    $$ -> type = ID_UNEXPANDED_MACRO;
}
;

escaped_identifier  : ESCAPED_ID {
    $$=$1;
};

simple_arrayed_identifier       : simple_identifier range_o {
    $$ = $1;
    if($2 != NULL){
        ast_identifier_set_range($$,$2);
    }
};

simple_hierarchical_identifier  : 
  simple_hierarchical_branch {$$=$1;}
| simple_hierarchical_branch DOT escaped_identifier {
    $$ = ast_append_identifier($1,$3);
  }
;

system_function_identifier      : SYSTEM_ID {
    $$ = $1;
    $$ -> type = ID_SYSTEM_FUNCTION;
};
system_task_identifier          : SYSTEM_ID {
    $$ = $1;
    $$ -> type = ID_SYSTEM_TASK;
};

/* A.9.4 Identifier Branches */

/* Semantic checking needed to make sure that the "expression"
in the closed brackets reduces to an "unsigned_number" */

simple_hierarchical_branch : 
  SIMPLE_ID {
      $$ = $1;
  }
| SIMPLE_ID OPEN_SQ_BRACKET expression CLOSE_SQ_BRACKET{
      $$=$1;
      ast_identifier_set_index($$,$3);
  }
| SIMPLE_ID OPEN_SQ_BRACKET range_expression CLOSE_SQ_BRACKET{
      $$=$1;
      ast_identifier_set_index($$,$3);
  }
| simple_hierarchical_branch DOT simple_identifier{
      $$ = ast_append_identifier($1,$3);
  }
| simple_hierarchical_branch DOT SIMPLE_ID OPEN_SQ_BRACKET expression 
  CLOSE_SQ_BRACKET {
      $$=$3;
      ast_identifier_set_index($$,$5);
      $$ = ast_append_identifier($1,$$);
  }
| simple_hierarchical_branch DOT SIMPLE_ID OPEN_SQ_BRACKET range_expression 
  CLOSE_SQ_BRACKET{
      $$=$3;
      ast_identifier_set_index($$,$5);
      $$ = ast_append_identifier($1,$$);
  }
;


/* Semantic checking needed to make sure that the "expression"
in the closed brackets reduces to an "unsigned_number" */

escaped_hierarchical_branch :
  escaped_hierarchical_branch DOT escaped_identifier {
      $$ = ast_append_identifier($1,$3);
  }
| escaped_hierarchical_branch DOT escaped_identifier OPEN_SQ_BRACKET 
  expression CLOSE_SQ_BRACKET {
      ast_identifier_set_index($3,$5);
      $$ = ast_append_identifier($1,$3);
  }
| escaped_identifier{
    $$=$1;
  }
| escaped_identifier OPEN_SQ_BRACKET expression CLOSE_SQ_BRACKET{
    ast_identifier_set_index($1,$3);
    $$=$1;
  }
| escaped_identifier OPEN_SQ_BRACKET range_expression CLOSE_SQ_BRACKET{
    ast_identifier_set_index($1,$3);
    $$=$1;
  };

white_space : SPACE | TAB | NEWLINE;

%%
