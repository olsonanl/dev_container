#
# Wrap a perl script for execution in the development runtime environment.
#

if [ $# -ne 2 ] ; then
    echo "Usage: $0 source dest" 1>&2 
    exit 1
fi

src=$1
dst=$2


if [ "$KB_OVERRIDE_TOP" != "" ] ; then
    top=$KB_OVERRIDE_TOP
else
    top=$KB_TOP
fi

if [ "$KB_OVERRIDE_RUNTIME" != "" ] ; then
    runtime=$KB_OVERRIDE_RUNTIME
else
    runtime=$KB_RUNTIME
fi

if [ "$KB_OVERRIDE_PERL_PATH" != "" ] ; then
    perlpath=$KB_OVERRIDE_PERL_PATH
else
    perlpath=$KB_PERL_PATH
fi


cat > $dst <<EOF
#!/bin/bash
export KB_TOP=$top
export KB_RUNTIME=$runtime
export PATH="$runtime/bin:$top/bin:\$PATH"
export PERL5LIB=$perlpath

if [ \$# gt 0 ] ; then
	pidarg="--pid \$1"
	shift
fi

exec $runtime/bin/starman \$pidarg $src
EOF

chmod +x $dst
