#
# Wrap a python script for execution in a mac .app wrapper
#

if [ $# -ne 2 ] ; then
    echo "Usage: $0 script-name dest" 1>&2 
    exit 1
fi

script=`basename $1`
dst=$2

cat > $dst <<EOF
#!/bin/bash
dir=\`dirname "\$0"\`
dir=\`cd "\$dir/../.."; pwd\`

export KB_TOP="\$dir/deployment"
export KB_RUNTIME="\$dir/runtime"
export PATH="\$KB_RUNTIME/bin:\$KB_TOP/bin:\$PATH"
export PYTHONPATH"\$KB_TOP/lib"
"\$KB_RUNTIME/bin/perl" "\$KB_TOP/pybin/$script" "\$@"
EOF

chmod +x $dst
