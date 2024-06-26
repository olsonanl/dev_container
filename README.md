# Development Container

## Overview

In the BV-BRC project we employ an opinionated build system that is centered
around what we call a "dev container", short for development container. This
is not a container in the sense of a Docker or Singularity container (we started
using the terminology before this technology was commonplace); rather it is a
container directory for code and other resources that are components of a larger build.

The build system uses the dev container as a wrapper around a set of
modules; typically each of these modules is maintained as a github repository.
The dev container provides an overall Makefile and set of inclusions for the
module Makefiles to support both of the following:

- Development builds such that when the dev container user environment
  shell include file (`user-env.sh`) is sourced by the developer, all
  executable scripts are included in the user's path and do not need to
  be invoked with either the language interpreter (e.g. python or perl)
  and do not have to have a full path specified. When changes are made
  to either scripts or included libraries no rerun of the build process
  is required to see the changes take effect. Of course if there are
  modules that use compiled languages such as C++ or Java, a build step
  is required.
- Production deployments where all required assets are copied to a production
  deployment directory and are executable without access to the original
  source directory.

This infrastructure enables the entire application development process
to be performed on the developer's own environment with a solid expectation
that when the code is deployed in a production environment no issues
will arise in the transition from development to production.

The dev container model assumes that there is a runtime directory available
that includes all the third-party software and language interpreters
that are required for the development work. On a Linux development machine
with a full installation of software installed it may be possible to
use the `/usr` directory on Linux as a runtime. However, it is likely
that the required language interpreters and the corresponding libraries
are not available there. For work on the BV-BRC system we typically use
a runtime environment that is built from source, using a runtime build
system found at https://github.com/BV-BRC/runtime_build.

Inside the dev container is a directory called `modules`. This directory will
hold the modules that are to be included in the container build.

There is a set of standard modules that are required for each standard BV-BRC build. They include the following:

| Module                                                   | Purpose                                        |
| -------------------------------------------------------- | ---------------------------------------------- |
| [p3_auth](https://github.com/BV-BRC/p3_auth)             | User authentication support                    |
| [app_service](https://github.com/BV-BRC/app_service)     | Utilities related to application submission    |
| [p3_cli](https://github.com/BV-BRC/p3_cli)               | BV-BRC command line scripts                    |
| [p3_core](https://github.com/BV-BRC/p3_core)             | Key common core BV-BRC code modules            |
| [sra_import](https://github.com/BV-BRC/sra_import)       | Code for SRA import utilities                  |
| [p3_deployment](https://github.com/BV-BRC/p3_deployment) | BV-BRC deployment support routines             |
| [typecomp](https://github.com/BV-BRC/typecomp)           | BV-BRC RPC type compiler                       |
| [Workspace](https://github.com/BV-BRC/Workspace)         | BV-BRC Workspace code support                  |
| [seed_gjo](https://github.com/TheSEED/seed_gjo)          | Bioinformatics utilities from the SEED project |
| [seed_core](https://github.com/TheSEED/seed_core)        | Bioinformatics utilities from the SEED project |

The Github repository paths for these modules may be found in
the file [core-modules](core-modules).

## Configuring a Development Container

The workflow for setting up a dev container for the purpose of working
on BV-BRC code development is as follows:

- Clone the dev_container repository. It isn't necessary to fork the
  module for this work; since the dev_container repository contains the
  build boilerplate you won't need to make any changes to that need to persist.
- Determine the set of modules needed to clone into the dev_container. The
  `core-modules` file discussed above is a good starting pont.
- Clone each of those modules into the `modules` directory
- In the root of the `dev_container` directory, run the `bootstrap` script
  to link the configuration of the dev container to the runtime and set up
  configuration files
- Source the `user-env.sh` script to initialize the user environment to use this
  dev container.
- Run `make` to perform the initial build.

## Setup Examples

We will work through several examples of configuring a development container.

### Linux, with a runtime in the shared filesystem

In the BV-BRC project development environment, we maintain a build of the
BV-BRC standard runtime in a shared NFS volume called `/vol/patric3/cli/ubuntu-runtime`.
We'll set a shell variable to store that value so that if you are working through this
example on your own system you can just redefine that variable to the correct value for your
environment

```bash
RT=/vol/patric3/cli/ubuntu-runtime
```

Now we can check out the dev container and the standard set of modules:

```bash
$ mkdir brc-work
$ cd brc-work
$ git clone https://github.com/BV-BRC/dev_container
Cloning into 'dev_container'...
remote: Enumerating objects: 1339, done.
remote: Counting objects: 100% (222/222), done.
remote: Compressing objects: 100% (81/81), done.
remote: Total 1339 (delta 146), reused 198 (delta 141), pack-reused 1117
Receiving objects: 100% (1339/1339), 175.69 KiB | 2.31 MiB/s, done.
Resolving deltas: 100% (818/818), done.
$ cd dev_container/
$ ./checkout-bvbrc-modules
```

The `checkout-bvbrc-modules` script simply clones each of the modules in the `core-modules` file
into the `modules` subdirectory of the dev container:

```bash
$ ls modules
app_service  p3_auth  p3_cli  p3_core  p3_deployment  README  sra_import  typecomp
```

Now we may do the bootstrap and build:

```bash
$ ./bootstrap $RT
$ source user-env.sh
$ make
if [ ! -d bin ] ; then mkdir bin ; fi
if [ ! -d cgi-bin ] ; then mkdir cgi-bin ; fi
[[ much more output]]
```

With the build complete, we can run standard BV-BRC programs:

```bash
$ p3-login olson
Password: *********
Logged in with username olson@patricbrc.org
$ p3-ls /olson@patricbrc.org/home
[[ my home directory]]
$ p3-echo 83332.12 | p3-get-genome-data --attr genome_name
id	genome.genome_name
83332.12	Mycobacterium tuberculosis H37Rv
```

At this point you can check out the set of modules you need to work on
for your development work. For example, if you wish to work on the fastq utilities module
you would run the following:

```bash
pushd modules
git clone https://github.com/BV-BRC/p3_fqutils
popd
```

If you add new modules to the modules directory, you will need to rerun
the bootstrap to inform the dev container that its configuration changed and then
reload the `user-env.sh` so your shell environment contains the corresponding changes. It
is also best to clear out the contents of the toplevel `bin` directory so that
any changes to the environment are propagated there.

```bash
$ ./bootstrap
$ rm bin/*
$ source user-env.sh
$ make
[output]
```

### Linux, using a BV-BRC Singularity container

The standard BV-BRC deployment utilizes a Singularity container that holds a standard
BV-BRC runtime. We can utilize this to create a dev container environment. It is essentially the
same process as above, only we need to bind our work directory into the Singularity container
when we start it up.

This example will use a one-liner to find the latest development version of the BV-BRC
Singularity container inside the BV-BRC development system environment.

```bash
$ LATEST_SIF="$(ls -t /vol/patric3/production/containers/bvbrc-dev-*.sif | head -n 1)"
$ echo $LATEST_SIF
/vol/patric3/production/containers/bvbrc-dev-389.sif
$ singularity shell --bind `pwd` $LATEST_SIF
Singularity> git clone https://github.com/BV-BRC/dev_container
[clone output]
Singularity> cd dev_container/
Singularity> ./checkout-bvbrc-modules
[clone output]
Singularity> RT=/opt/patric-common/runtime
Singularity> ./bootstrap $RT
Singularity> source user-env.sh
Singularity> make
```

At this point you can use this configuration as in the prior section.

### MacOS, using the BV-BRC Command Line Interface release

The BV-BRC project makes available MacOS builds of the BV-BRC toolkit, including a runtime. For
development where the tools included in that release are sufficient (due to space considerations, there
is not a complete set of the third-party bioinformatics tools included in the MacOS release) this
is a good option for local development.

To start with this, install the command-line interface package using the instructions found
[at the BV-BRC Command Line Interface github repository](https://github.com/BV-BRC/BV-BRC-CLI).

All that is required to use this version is to run the `bootstrap` script with the appropriate runtime.

```bash
RT=/Applications/BV-BRC.app/runtime
```

The rest of the linux instructions will work as described above.

## Usage

1.  Shell into a container with a recent development image.

    ```bash
    LATEST_SIF="$(ls -t /vol/patric3/production/containers/bvbrc-dev-*.sif | head -n 1)"
    echo shelling into $LATEST_SIF
    singularity shell --bind /disks/tmp:/tmp,/vol,/home,/homes $LATEST_SIF
    ```

2.  Clone this repository onto your development host.

    ```bash
    git clone https://github.com/BV-BRC/dev_container
    cd dev_container
    ```

3.  Clone "module repositories" into the [modules](modules) directory. If you have
    a common set of modules you often need, you can create a script to
    clone all of those first, like [checkout-p3-modules](checkout-p3-modules).
    You could add an additional helper script like that to include any modules
    you need for current development. Otherwise just manually clone the addition(s).
    E.g.:

    ```bash
     ./checkout-p3-modules
     # Manual clone
     pushd modules
     git clone git@github.com:PATRIC3/p3_fqutils.git
     popd
    ```

4.  Run the [bootstrap](bootstrap) script with the path to a "runtime directory"
    as the first argument. Here we will use the one provisioned
    inside the sif image. The following `DEPLOY_RUNTIME` variable
    also appears to be relevant for the deployment targets in the [Makefile](Makefile).
    E.g.:

    ```bash
     export DEPLOY_RUNTIME="/opt/patric-common/runtime"
     KB_IGNORE_MISSING_DEPENDENCIES=1 ./bootstrap $DEPLOY_RUNTIME
    ```

5.  Source the `user-env.sh` script in the "development directory".
    This file is created during the bootstrap script step.

```bash
source user-env.sh
```

6.  Build the modules. The current [Makefile](Makefile) default target (`all`) runs the `build_modules` target.

    ```bash
    # if these steps were run before, start with an empty bin dir
    rm /bin/*
    make
    # same as . . .
    # make build_modules
    ```

7.  **Optional:** Deploy. The "deployment directory" needs to be a directory where you
    have permissions to write. By default, this is a directory called
    /kb/deployment. If you have sufficient permissions to create this
    directory, then you may skip this step. To override that default
    set in the [Makefile](Makefile), you can set your own `TARGET`.
    E.g.:

    ```bash
    export TARGET="deployment"
    ```

    . . . with the path to where you would like to deploy.

If no modules have been cloned into the modules sub directory, this will create directories and files in the deployment
directory for every module. It might be best to skip this step right now,
as the current Makefile appears to not work.

```bash
    make deploy
```

8.  Develop and test (a) module(s). Repeat steps 4 - 6. (7?) as necessary.
    - Any new scripts in any module `script` directories will require a `make` run for/in that module.
      This would always be the case when a new module is added.
    - Re-run the `bootstrap` and `user-env.*` sourcing when adding modules to [modules](modules).
    - **Note:** Run any module `script`s using their generated wrapper, which should be in the executable `PATH`.
      E.g. `run-me.pl` should be run with `run-me`. This will test the intended call stack, as well as
      testing this `make` machinery. Apparently this is required, as well: `export KB_INTERACTIVE=1`

## Definitions

- runtime directory: This is a directory that contains "bin", "lib",
  "man", "etc" subdirectories containing third\*party software that
  BV-BRC repositories depend upon (default: `/kb/runtime`). E.g. a perl binary and Perl modules.
  See the [bootstrap repository](https://github.com/olsonanl/bootstrap.git) for what normally goes here.

- deployment directory: This is the directory that contains "bin",
  "lib", "man", "etc" subdirectories for BV-BRC developed code.

- development directory: This is the directory where new code is
  written and developed. It is customary for modules to be cloned
  from the git repository into the [modules](modules) directory of the
  development directory. As code is modified, it is pushed back
  to the git repository.

```

```
