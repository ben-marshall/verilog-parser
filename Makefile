

##------------------------------------------------------------------------
## Auxiliary Rules and Actions
##------------------------------------------------------------------------

.PHONY : docs

all: app docs

app:
	$(MAKE) -C build/ all

app-with-coverage:
	$(MAKE) -C build/ with-coverage

coverage-report:
	bin/test-coverage.sh

view-coverage-report: coverage-report
	xdg-open ./build/cov-report/index.html

clean:
	$(MAKE) -C build/ clean
	$(MAKE) -C docs/ clean

docs:
	$(MAKE) -C docs/ docs

test: app
	bin/run-tests.sh

setup:
	bin/project.sh

fromclean: clean all

