#
# Wrap a python script for execution in the development runtime environment.
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

if [ "$KB_OVERRIDE_PYTHONPATH" != "" ] ; then
    pythonpath=$KB_OVERRIDE_PYTHONPATH
else
    pythonpath=$KB_PYTHONPATH
fi


cat > $dst <<EOF
#!/bin/sh
export KB_TOP=$top
export KB_RUNTIME=$runtime
export KB_PYTHON_PATH=$pythonpath
export PATH=$runtime/bin:$top/bin:\$PATH
export PYTHONPATH=$pythonpath:\$PYTHONPATH
python $src "\$@"
EOF

chmod +x $dst