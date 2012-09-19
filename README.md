Development Container
=====================

This repository is a container for developing KBase modules.
To use this, you must already have a "runtime" directory, which
contains the neccesary binaries and libraries. For an idea of
what is expected to be in this runtime, consult the [bootstrap
repository](https://git.kbase.us/bootstrap.git/).

Usage
-----

0. Clone this repository onto your development machine:

    $ git clone kbase@git.kbase.us:dev_container.git
    $ cd dev_container

1. The "deployment directory" needs to be a directory where you
have permissions to write. By default, this is a directory called
/kb/deployment.  If you have sufficient permissions to create this
directory, then you may skip this step.  To change the directory, 
open the "Makefile" and replace:

    TARGET = /kb/deployment

With the path to where you would like to deploy.

2. Run the *bootstrap* script with the path to a "runtime directory"
as the first argument. 

    $ ./bootstrap /kb/runtime

3. Source the *user-env.sh* script in the "development directory".
This file is created during the bootstrap script in step 2.

    $ source user-env.sh

4.	Option step if no modules have been cloned into the modules 
sub directory. This will create directories and files in the deployment
directory for every module.

	$ make deploy

5. Clone "module repositories" into the modules directory:

    $ cd modules
    $ git clone kbase@git.kbase.us:idserver.git

6. Do development work in a module.

7. Goto 2.

Definitions
-----------

* runtime directory: By default this is /kb/runtime.  
This is a directory that contains "bin", "lib",
"man", "etc" subdirectories containing third-party software that
KBase repositories depend upon. E.g. a perl binary and Perl modules.
See the [bootstrap repository][1] for what normally goes here.

* deployment directory: This is the directory that contains "bin",
"lib", "man", "etc" subdirectories for KBase developed code.

* development directory: This is the directory where new code is
written and developed.  It is customary for modules to be cloned
from the git repository into the modules directory of the 
development directory. As code is modified, it is pushed back
to the git repository.

[1] : https://git.kbase.us/bootstrap.git/ "bootstrap repository"

