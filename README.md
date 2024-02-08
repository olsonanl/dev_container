# Development Container

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

## Usage

1. Shell into a container with a recent image.
   ```bash
   LATEST_SIF="$(ls -t /vol/patric3/production/containers/bvbrc-dev-*.sif | head -n 1)"
   TMP="/disks/tmp"
   [ $(hostname) == bio-gp1.mcs.anl.gov ] && TMP="/tmp"
   echo shelling into $LATEST_SIF
   singularity shell --bind $TMP:/tmp,/vol,/home,/homes $LATEST_SIF
   ```

2. Clone this repository onto your development host.
   ```bash
   git clone https://github.com/PATRIC3/dev_container
   cd dev_container
   ```

3. Clone "module repositories" into the [modules](modules) directory. If you have
a common set of modules you often need, you can create a script to
clone all of those first, like [checkout-p3-modules](checkout-p3-modules).
You could add an additional helper script like that to include any modules
you need for current development. Otherwise just manually clone the addition(s).
E.g.:
   ```bash
    ./checkout-p3-modules
    # Manual clone
    cd modules
    git clone git@github.com:PATRIC3/p3_fqutils.git
   ```

4. Run the [bootstrap](bootstrap) script with the path to a "runtime directory"
as the first argument (E.g. `/kb/runtime`). The following `DEPLOY_RUNTIME` variable
also appears to be relevant for the deployment targets in the [Makefile](Makefile).
E.g.:
   ```bash
    export DEPLOY_RUNTIME="/opt/patric-common/runtime"
    KB_IGNORE_MISSING_DEPENDENCIES=1 ./bootstrap $DEPLOY_RUNTIME
   ```

5. Source the `user-env.sh` script in the "development directory".
This file is created during the bootstrap script step.
   ```bash
    source user-env.sh
    ```

6. Build the modules. The current [Makefile](Makefile) default target (`all`) runs the `build_modules` target.
    ```bash
    # if these steps were run before, start with an empty bin dir
    rm /bin/*
    make
    # same as . . .
    # make build_modules
    ```

7. **Optional:** Deploy. The "deployment directory" needs to be a directory where you
have permissions to write. By default, this is a directory called
/kb/deployment.  If you have sufficient permissions to create this
directory, then you may skip this step. To override that default
set in the [Makefile](Makefile), you can set your own `TARGET`.
E.g.:
   ```bash
   export TARGET="deployment"
   ```

   . . . with the path to where you would like to deploy.

    If no modules have been cloned into the modules
sub directory, this will create directories and files in the deployment
directory for every module. It might be best to skip this step right now,
as the current Makefile appears to not work.
   ```bash
   make deploy
   ```

8. Do development work in a module.

9. Repeat steps 4 - 6. (7?) as necessary. E.g., if you clone in a new repo.

### Definitions

* runtime directory: By default this is /kb/runtime.  
This is a directory that contains "bin", "lib",
"man", "etc" subdirectories containing third*party software that
KBase repositories depend upon. E.g. a perl binary and Perl modules.
See the [bootstrap repository](https://github.com/olsonanl/bootstrap.git) for what normally goes here.

* deployment directory: This is the directory that contains "bin",
"lib", "man", "etc" subdirectories for KBase developed code.

* development directory: This is the directory where new code is
written and developed.  It is customary for modules to be cloned
from the git repository into the [modules](modules) directory of the 
development directory. As code is modified, it is pushed back
to the git repository.