#
# Wrap a perl script for execution in the development runtime environment.
# Ultimately should be able to emit warnings about deprecated script
# names to stderr
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

cat > $dst <<EOF1
#!/bin/sh
export KB_TOP=$top
export KB_RUNTIME=$runtime
export PATH="$runtime/bin:$top/bin:\$PATH"
export PERL5LIB=$perlpath
EOF1
for var in $WRAP_VARIABLES ; do
	val=${!var}
	if [ "$val" != "" ] ; then
		echo "export $var='$val'" >> $dst
	fi
done
for var in $PATH_ADDITIONS ; do
    echo "export PATH=$var:\$PATH" >> $dst
done
for var in $PERL5LIB_ADDITIONS ; do
    echo "export PERL5LIB=$var:\$PERL5LIB" >> $dst
done
cat >> $dst <<EOF
$runtime/bin/perl $src "\$@"
EOF

chmod +x $dst
