#
# Wrap a shell script for execution in the development runtime environment.
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


cat > $dst <<EOF1
#!/bin/bash
export KB_TOP=$top
export KB_RUNTIME=$runtime
export PATH="$runtime/bin:$top/bin:\$PATH"
EOF1
for var in $WRAP_VARIABLES ; do
	val=${!var}
	if [ "$val" != "" ] ; then
		echo "export $var='$val'" >> $dst
	fi
done
cat >> $dst <<EOF
/bin/bash $src "\$@"
EOF

chmod +x $dst
