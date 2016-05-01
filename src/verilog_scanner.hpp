#ifndef __VLSCANNER_HPP__
#define __VLSCANNER_HPP__ 1

#if ! defined(yyFlexLexerOnce)
#include <FlexLexer.h>
#endif

#undef  YY_DECL
#define YY_DECL int  VL::VerilogScanner::yylex()

#include "verilog_parser.tab.hh"

namespace VL
{
    /*!
    @brief This is the class we will use to instance and run the verilog
    lexer.
    */
    class VerilogScanner : public yyFlexLexer
    {
        public:

            VerilogScanner(std::istream *in) : yyFlexLexer(in),
            yylval( NULL ){};

            int yylex(VL::VerilogParser::semantic_type *lval)
            {
                yylval = lval;
                printf("\t\tLEX: '%s'\n", yytext);
                return( yylex() ); 
            }


        private:
            /* hide this one from public view */
            int yylex();
            /* yyval ptr */
            VL::VerilogParser::semantic_type *yylval;
    };

} /* end namespace VL */

#endif /* END __VLSCANNER_HPP__ */
