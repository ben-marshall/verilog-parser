#ifndef __VLDRIVER_HPP__
#define __VLDRIVER_HPP__ 1

#include <string>
#include "verilog_scanner.hpp"
#include "verilog_parser.tab.hh"

namespace VL{

class VerilogDriver{
public:
   VerilogDriver() : parser( NULL    ),
                     scanner( NULL    ){};

   virtual ~VerilogDriver();

   void parse( const char *filename );

   void add_oneline_comment(const char * m);
   void add_block_comment  (const char * m);
   void add_preproc_define (const char * m);

private:
   
   VL::VerilogParser *parser;
   VL::VerilogScanner *scanner;
};

} /* end namespace VL */
#endif /* END __VLDRIVER_HPP__ */
