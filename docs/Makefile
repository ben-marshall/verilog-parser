
##------------------------------------------------------------------------
## Auxiliary Rules and Actions
##------------------------------------------------------------------------

.PHONY : docs

all: docs

docs:
	doxygen Doxyfile
	egrep --color "((W|w)arning)|^" ../build/doxygen-warnings.log

clean:
	rm -rf ../build/docs

