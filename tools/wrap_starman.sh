#
# Wrap a perl script for execution in the development runtime environment.
#

if [ $# -ne 2 ] ; then
    echo "Usage: $0 source dest" 1>&2 
    exit 1
fi

src=$1
dst=$2



cat > $dst <<EOF
#!/bin/sh
export KB_TOP=$KB_TOP
export KB_RUNTIME=$KB_RUNTIME
export PATH=$KB_RUNTIME/bin:$KB_TOP/bin:\$PATH
export PERL5LIB=$KB_PERL_PATH

if [ \$# gt 0 ] ; then
	pidarg="--pid \$1"
	shift
fi

exec \$KB_RUNTIME/bin/starman \$pidarg $src
EOF

chmod +x $dst
