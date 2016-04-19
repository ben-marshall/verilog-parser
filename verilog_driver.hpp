#ifndef __VLDRIVER_HPP__
#define __VLDRIVER_HPP__ 1

#include <string>
#include "verilog_scanner.hpp"
#include "verilog_parser.tab.hh"

namespace VL{

class VerilogDriver{
public:
   VerilogDriver() : chars(0),
                     words(0),
                     lines(0),
                     uppercase(0),
                     lowercase(0),
                     parser( NULL    ),
                     scanner( NULL    ){};

   virtual ~VerilogDriver();

   void parse( const char *filename );
  

   void add_upper();
   void add_lower();
   void add_word( const std::string &word );
   void add_newline();
   void add_char();

   std::ostream& print(std::ostream &stream);
private:
   int chars;
   int words;
   int lines;
   int uppercase;
   int lowercase;
   VL::VerilogParser *parser;
   VL::VerilogScanner *scanner;
};

} /* end namespace VL */
#endif /* END __VLDRIVER_HPP__ */
