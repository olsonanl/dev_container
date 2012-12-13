
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

deploy: deploy-user-env
	# make the necessary deployment directories
	# loop over each module and call its make deploy
	# create a user-env.sh and put it in the deployment
	# location (TARGET)


	-mkdir $(TARGET)
	-mkdir $(TARGET)/bin
	-mkdir $(TARGET)/lib
	-mkdir $(TARGET)/plbin $(TARGET)/pybin
	-mkdir $(TARGET)/services

	for m in $(MODULE_DIRS); do \
		if [ -d $$m ] ; then \
			(cd $$m; make deploy TARGET=$(TARGET) DEPLOY_RUNTIME=$(DEPLOY_RUNTIME) ); \
			if [ $$? -ne 0 ] ; then \
				exit 1 ; \
			fi  \
		fi \
	done

deploy-all: deploy-user-env
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
			(cd $$m; make deploy-all TARGET=$(TARGET) DEPLOY_RUNTIME=$(DEPLOY_RUNTIME) ); \
			if [ $$? -ne 0 ] ; then \
				exit 1 ; \
			fi  \
		fi \
	done

deploy-user-env:
	-mkdir $(TARGET)

	dest=$(TARGET)/user-env.sh; \
	q='"'; \
	echo "export KB_TOP=$$q$(TARGET)$$q" > $$dest; \
	echo "export KB_RUNTIME=$$q$(DEPLOY_RUNTIME)$$q" >> $$dest; \
	echo "export PATH=$$q\$$KB_TOP/bin:\$$KB_RUNTIME/bin:\$$PATH$$q" >> $$dest; \
	echo "export KB_PERL_PATH=$$q$(TARGET)/lib$$q" >> $$dest; \
	echo "export PERL5LIB=\$$KB_PERL_PATH:\$$KB_PERL_PATH/perl5" >> $$dest; \
	echo "export PYTHONPATH=$$q\$$KB_PERL_PATH:\$$PYTHONPATH$$q" >> $$dest;

	dest=$(TARGET)/user-env.csh; \
	q='"'; \
	echo "setenv KB_TOP $$q$(TARGET)$$q" > $$dest; \
	echo "setenv KB_RUNTIME $$q$(DEPLOY_RUNTIME)$$q" >> $$dest; \
	echo "setenv PATH $$q\$$KB_TOP/bin:\$$KB_RUNTIME/bin:\$$PATH$$q" >> $$dest; \
	echo "setenv KB_PERL_PATH $$q$(TARGET)/lib$$q" >> $$dest; \
	echo "setenv PERL5LIB \$$KB_PERL_PATH:\$$KB_PERL_PATH/perl5" >> $$dest; \
	echo "setenv PYTHONPATH $$q\$$KB_PERL_PATH:\$$PYTHONPATH$$q" >> $$dest;


build_modules:
	# this is called by the default target (make with no target provided)
	# the modules will be deployed in the dev_container
	# make the necessary directories
	# loop over each module and call its make with no target (default target)
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
