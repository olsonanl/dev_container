
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
	echo "export PERL5LIB=\$$KB_PERL_PATH" >> $$dest; 
	echo "export PYTHONPATH=\$$KB_PERL_PATH:\$$PYTHONPATH" >> $$dest;

	dest=$(TARGET)/user-env.csh; \
	q='"'; \
	echo "setenv KB_TOP $$q$(TARGET)$$q" > $$dest; \
	echo "setenv KB_RUNTIME $$q$(DEPLOY_RUNTIME)$$q" >> $$dest; \
	echo "setenv PATH $$q\$$KB_TOP/bin:\$$KB_RUNTIME/bin:\$$PATH$$q" >> $$dest; \
	echo "setenv KB_PERL_PATH $$q$(TARGET)/lib$$q" >> $$dest; \
	echo "setenv PERL5LIB \$$KB_PERL_PATH" >> $$dest; 
	echo "setenv PYTHONPATH \$$KB_PERL_PATH:\$$PYTHONPATH" >> $$dest; 

build_modules:
	if [ ! -d bin ] ; then mkdir bin ; fi
	for m in $(MODULE_DIRS); do \
		if [ -d $$m ] ; then \
			(cd $$m; make ) ; \
		fi \
	done

