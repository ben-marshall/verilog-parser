
# Verilog Parser

![Build Status](https://travis-ci.org/ben-marshall/verilog-parser.svg?branch=master) [Build & CI Information](https://travis-ci.org/ben-marshall/verilog-parser)

This repository contains a flex / bison parser for the IEEE 1364-2001 Verilog
Standard.

- [Getting Started](#getting-started)
- [Testing](#testing)
- [Contributing](#contributing)
- [Design Choices](#design-choices)
- [Todo List](#todo)

---

## Getting Started

This will get you going.

    ```sh
    $> source bin/project.sh
    $> cd build
    $> make docs
    $> make
    $> make test
    ```

The `project.sh` script will also call the script which downloads the tests
from asic-world.com. The project uses CMake as it's build system, and
CTest for running the various test programs.

## Testing

The test suite is comprised of example code taken from
the fantastic [ASIC World](http://www.asic-world.com/) tutorial on Verilog.
The idea being that by using a well-known and comprehensive set of
tutorial examples, almost all of the syntactic features of the language can be
hit very easily with little effort.

## Contributing

Ofcourse, the current test suite does not test **everything** and I expect
there to be awkward bugs. This is the first time I have written a parser of
this size and complexity.

If you find a bug, or otherwise want to contribute, then please don't
hesitate to file a pull request. If you have found a bug, please add a test
for the bug in the `tests/` folder. This should trigger the bug in the orignal
code, and ideally, not trigger in you're submitted fix! I'm open to people
just submitting bugs as well, but it might take longer for me to get round to
fixing it!

## Design Choices

### Why C, why not something more modern?

This comes down to who will use this tool, and who will develop this tool.
Ideally, these are the same people. The current demographic of people working
in ASIC / RTL design is that of (please excuse my generalising) electronic
engineers, with (again, sorry) little experience of recent programming language
technologies like Haskell (great for parsing and formal/state-based assertions)
and Python (perl is still king in ASIC design flows, but this is changing).
Further, the size and complexity of many RTL designs means you need a language
that has lots of low-level acceleration potential, as well as being
tried-and-tested. C meets most of these points, while also being something that
eletronics engineers are more likely to be familiar with and comfortable using.

### Why flex/bison, why not Boost::Sprint, ANTLR, or something custom?

Similar to the above answer. These are tools that are *very* old, and *very*
stable. They are more likely to be available and supported for the kinds
of developement environments RTL designers work in which are often at least
a decade old. What flex and bison loose in terms of nice fetures, syntactic
sugar, and, sadly, ease of use - they make up for in stability and
likelihood of familiarity for the people I hope will use this project.
Many of the design decisions around this project have been equal parts
social and engineering in their justification.

### Why CMake?

Because I am not a total masochist, despite the above. I will probably end up
creating a pure Make build system though, and adding a minimal CMake wrapper
around it. This will make building on old systems where a recent CMake version
doesn't exist easier, while also making integration into other projects
possible and a little less painful.


---


## Todo

There are some things that the parser does not support:

- SystemVerilog. Sorry folks, its another language completely. This parser
  should serve as a very good starting point if you want to build one though,
  since Verilog is a subset of SystemVerilog.
- System timing checks. See Annex 7.5.1 of the specification for what this
  omits. It hopefully won't be long before I get round to adding it though.
- Abstract Syntax Trees. This is a work in progress, but it will be in there
  eventually.

## Wishlist

This is a wishlist of tools that I would like to use the parser in. If
anyone else would like to use the parser as the basis for their own tools
like this, I am more than happy to help!

- A code indenter / style format checker.
- A pre-processed source checker (expand macros and parameters, etc) for easy
  browsing of generic logic blocks and cores.
- Something to highlight when signals cross clock domains.
- Critical path identifier (something which doesn't take 20 minuets to run on 
  a grid engine) 
- A switching probability analysis tool. 
- This could even feed into a rough power & energy estimation tool. 
- A simple hierarchy visualiser, which you can feed all your project files into 
  and which will spit out a digested view of the module hierarchy. 
- Proper Doxygen support for Verilog. This will be the first thing I try after 
  the parser is finished. 
