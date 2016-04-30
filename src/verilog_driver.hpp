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

   bool parse( const char *filename );

private:
   
   VL::VerilogParser *parser;
   VL::VerilogScanner *scanner;
};

} /* end namespace VL */
#endif /* END __VLDRIVER_HPP__ */
