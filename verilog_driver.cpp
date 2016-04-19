#include <cctype>
#include <fstream>
#include <cassert>
#include <cstdlib>

#include "verilog_driver.hpp"

VL::VerilogDriver::~VerilogDriver(){ 
   delete(scanner);
   scanner = NULL;
   delete(parser);
   parser = NULL;
}

void 
VL::VerilogDriver::parse( const char *filename )
{
   assert( filename != NULL);
   std::ifstream in_file( filename );
   if( ! in_file.good() ) exit(1);
   
   delete(scanner);
   try
   {
      scanner = new VL::VerilogScanner( &in_file );
   }
   catch( std::bad_alloc &ba )
   {
      std::cerr << "Failed to allocate scanner: (" <<
         ba.what() << "), exiting!!\n";
      exit(1);
   }
   
   delete(parser); 
   try
   {
      parser = new VL::VerilogParser( (*scanner) /* scanner */, 
                                  (*this) /* driver */ );
   }
   catch( std::bad_alloc &ba )
   {
      std::cerr << "Failed to allocate parser: (" << 
         ba.what() << "), exiting!!\n";
      exit( 1 );
   }
   const int accept( 0 );
   if( parser->parse() != accept )
   {
      std::cerr << "Parse failed!!\n";
   }
}

void 
VL::VerilogDriver::add_upper()
{ 
   uppercase++; 
   chars++; 
   words++; 
}

void 
VL::VerilogDriver::add_lower()
{ 
   lowercase++; 
   chars++; 
   words++; 
}

void 
VL::VerilogDriver::add_word( const std::string &word )
{
   words++; 
   chars += word.length();
}

void 
VL::VerilogDriver::add_newline()
{ 
   lines++; 
   chars++; 
}

void 
VL::VerilogDriver::add_char()
{ 
   chars++; 
}


std::ostream& 
VL::VerilogDriver::print( std::ostream &stream )
{
   stream << "Uppercase: " << uppercase << "\n";
   stream << "Lowercase: " << lowercase << "\n";
   stream << "Lines: " << lines << "\n";
   stream << "Words: " << words << "\n";
   stream << "Characters: " << chars << "\n";
   return(stream);
}
