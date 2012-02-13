
MODULE_DIRS = $(wildcard modules/*)
MODULES = $(notdir $(MODULE_DIRS))

all: build_modules

what:
	@echo dirs $(MODULE_DIRS)
	@echo modules $(MODULES)



build_modules:
	if [ ! -d bin ] ; then mkdir bin ; fi
	for m in $(MODULE_DIRS); do \
		if [ -d $$m ] ; then \
			(cd $$m; make ) ; \
		fi \
	done

