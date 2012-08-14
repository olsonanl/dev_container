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

1. Run the *bootstrap* script with the path to a "runtime directory"
as the first argument.

    $ ./bootstrap /kb/runtime

2. Optionally set a "deployment directory". If you skip this step,
your code will be deployed to the `/kb/deployment` directory. To
change this, open the "Makefile" and replace:

    TARGET = /kb/deployment

With the path to where you would like to deploy.

3. Source the *user-env.sh* script in the "deployment directory".
This file is created during the bootstrap script in step 1.

    $ source /kb/deployment/user-env.sh

4. Clone "module repositories" into the modules directory:

    $ cd modules
    $ git clone kbase@git.kbase.us:idserver.git

5. Do development work in a module.

6. Run `make deploy` to deploy modules into the "deployment directory"

7. Goto 4.

Definitions
-----------

* runtime directory: This is a directory that contains "bin", "lib",
"man", "etc" subdirectories containing third-party software that
KBase repositories depend upon. E.g. a perl binary and Perl modules.
See the [bootstrap repository][1] for what normally goes here.

* deployment directory: This is the directory that contains "bin",
"lib", "man", "etc" subdirectories for KBase developed code.

[1] : https://git.kbase.us/bootstrap.git/ "bootstrap repository"
