
MODULE_DIRS = $(wildcard modules/*)
MODULES = $(notdir $(MODULE_DIRS))

#
# Default deplyment target.
#
TARGET = /kb/deployment
DEPLOY_RUNTIME = /kb/runtime

all: build_modules

what:
	@echo dirs $(MODULE_DIRS)
	@echo modules $(MODULES)

deploy:
	-mkdir $(TARGET)
	-mkdir $(TARGET)/bin
	-mkdir $(TARGET)/lib
	-mkdir $(TARGET)/plbin
	-mkdir $(TARGET)/services

	for m in $(MODULE_DIRS); do \
		if [ -d $$m ] ; then \
			(cd $$m; make deploy TARGET=$(TARGET) DEPLOY_RUNTIME=$(DEPLOY_RUNTIME) ); \
		fi \
	done



build_modules:
	if [ ! -d bin ] ; then mkdir bin ; fi
	for m in $(MODULE_DIRS); do \
		if [ -d $$m ] ; then \
			(cd $$m; make ) ; \
		fi \
	done

