
#
# This is a simple top-level wrapper makefile for the rest of the project.
#

all: docs debug release coverage

.PHONY: docs setup clean

setup:
	./bin/project.sh

docs:
	$(MAKE) -C ./build/debug -B verilogparser-docs

debug:
	$(MAKE) -C ./build/debug parser

release:
	$(MAKE) -C ./build/release parser

coverage:
	$(MAKE) -C ./build/coverage parser

clean:
	$(MAKE) -C ./build/coverage clean
	$(MAKE) -C ./build/debug    clean
	$(MAKE) -C ./build/release  clean
	rm -rf ./build/docs


test-all: test-debug test-release test-coverage
	
test-debug: debug
	$(MAKE) -C ./build/debug test
	
test-release: release
	$(MAKE) -C ./build/release test
	
test-coverage: coverage 
	$(MAKE) -C ./build/coverage test

test-coverage-report: test-coverage
	cd ./build/coverage/src/CMakeFiles/verilogparser.dir/ ; \
	gcov -abcf *.o  ; \
    lcov --directory . -c -o cov.info -t "verilogparser" ; \
	genhtml -o ../../../../cov-report -t "verilogparser" --num-spaces 4 cov.info
	@echo "Coverage report available in:"
	@echo "./build/cov-report/index.html"
