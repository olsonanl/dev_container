
MODULE_DIRS = $(wildcard modules/*)
MODULES = $(notdir $(MODULE_DIRS))

#
# Default deplyment target.
#
TARGET = /kb/deployment
DEPLOY_RUNTIME = /kb/runtime

WRAP_TOOL = wrap_perl
WRAP_SCRIPT = $(TOOLS_DIR)/$(WRAP_TOOL).sh

all: build_modules

what:
	@echo dirs $(MODULE_DIRS)
	@echo modules $(MODULES)

deploy:
	# make the necessary deployment directories
	# loop over each module and call its make deploy
	# create a user-env.sh and put it in the deployment
	# location (TARGET)


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

	dest=$(TARGET)/user-env.sh; \
	q='"'; \
	echo "export KB_TOP=$$q$(TARGET)$$q" > $$dest; \
	echo "export KB_RUNTIME=$$q$(DEPLOY_RUNTIME)$$q" >> $$dest; \
	echo "export PATH=$$q\$$KB_TOP/bin:\$$KB_RUNTIME/bin:\$$PATH$$q" >> $$dest; \
	echo "export KB_PERL_PATH=$$q$(TARGET)/lib$$q" >> $$dest; \
	echo "export PERL5LIB=\$$KB_PERL_PATH:\$$KB_PERL_PATH/perl5" >> $$dest; \
	echo "export PYTHONPATH=$$q\$$KB_PERL_PATH:\$$PYTHONPATH$$q" >> $$dest; \

	# user-env.csh is the same as user-env.sh except csh uses setenv instead of export
	dest=$(TARGET)/user-env.sh; \
	dest2=$(TARGET)/user-env.csh; \
	cat $$dest | sed "s/export/setenv/" > $$dest2;

build_modules:
	# this is called by the default target (make with no target provided)
	# the modules will be deployed in the dev_container
	# make the necessary directoris
	# loop over each module and call it's make file with no target (default target)
	if [ ! -d bin ] ; then mkdir bin ; fi
	for m in $(MODULE_DIRS); do \
		if [ -d $$m ] ; then \
			(cd $$m; make ) ; \
			if [ $$? -ne 0 ] ; then \
				exit 1 ; \
			fi \
		fi \
	done

test:
	# foreach module in modules, call make test on that module
	for m in $(MODULE_DIRS); do \
		if [ -d $$m ] ; then \
			(cd $$m; make test DEPLOY_RUNTIME=$(DEPLOY_RUNTIME) ) ; \
			if [ $$? -ne 0 ] ; then \
				exit 1 ; \
			fi \
		fi \
	done

clean:
	rm -rf $(TARGET)

realclean:
	-rm -rf $(TARGET)
	-rm -rf modules/*
	-rm -rf bin
	-rm runtime
	-rm user-env.*
