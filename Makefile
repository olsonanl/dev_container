
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
	# loop over each module and call it's make deploy
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
	echo "export PERL5LIB=\$$KB_PERL_PATH:\$$KB_PERL_PATH/perl5" >> $$dest; 

	dest=$(TARGET)/user-env.csh; \
	q='"'; \
	echo "setenv KB_TOP $$q$(TARGET)$$q" > $$dest; \
	echo "setenv KB_RUNTIME $$q$(DEPLOY_RUNTIME)$$q" >> $$dest; \
	echo "setenv PATH $$q\$$KB_TOP/bin:\$$KB_RUNTIME/bin:\$$PATH$$q" >> $$dest; \
	echo "setenv KB_PERL_PATH $$q$(TARGET)/lib$$q" >> $$dest; \
	echo "setenv PERL5LIB \$$KB_PERL_PATH:\$$KB_PERL_PATH/perl5" >> $$dest; 

build_modules:
	# this is called by the default target (make with no target provided
	# the modules will be deployed in the dev_container
	# make the necessary directoris
	# loop over each module and call it's make file with no target (default target)
	if [ ! -d bin ] ; then mkdir bin ; fi
	for m in $(MODULE_DIRS); do \
		if [ -d $$m ] ; then \
			(cd $$m; make ) ; \
		fi \
	done

clean:
	rm -rf $(TARGET)

realclean:
	-rm -rf $(TARGET)
	-rm -rf modules/*
