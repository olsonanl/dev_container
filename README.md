Development Container
=====================

This repository is a container for developing KBase modules.
A “dev container” can be thought of as a directory in the
file system where developers develop code. A clone of this repo
will become a dev container you can work from within.
To use this, you must already have a "runtime" directory, which
contains the neccesary binaries and libraries. One way to get/have this
is from a Singularity image file (sif) with one packaged inside.
(E.g. /vol/patric3/production/containers/bvbrc-build-352.sif)
For an idea of
what is expected to be in this runtime, consult the [bootstrap
repository](https://github.com/olsonanl/bootstrap).

Usage
-----

0. Clone this repository onto your development machine:

        $ git clone https://github.com/PATRIC3/dev_container
        $ cd dev_container

1. The "deployment directory" needs to be a directory where you
have permissions to write. By default, this is a directory called
/kb/deployment.  If you have sufficient permissions to create this
directory, then you may skip this step. To override that default
set in the [Makefile](Makefile), you can set your own `TARGET`.
E.g.:

        export TARGET="deployment"

    . . . with the path to where you would like to deploy.

2. Run the [bootstrap](bootstrap) script with the path to a "runtime directory"
as the first argument (E.g. `/kb/runtime`). The following variable
also appears to be relevant for the Makefile.
E.g.:

        $ export DEPLOY_RUNTIME="/opt/patric-common/runtime"
        $ ./bootstrap $DEPLOY_RUNTIME

3. Source the *user-env.sh* script in the "development directory".
This file is created during the bootstrap script in step 2.

        $ source user-env.sh

4.	Optional step if no modules have been cloned into the modules
sub directory. This will create directories and files in the deployment
directory for every module. It might be best to skip this step right now,
as the current Makefile appears to not work.

        $ make deploy

5. Clone "module repositories" into the modules directory. If you have
a common set of modules you often need, you can create a script to
clone all of those first, like [checkout-p3-modules](checkout-p3-modules).
You can add an additional helper script like that, including any modules
you need for current development. Otherwise just manually clone, like so:

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

