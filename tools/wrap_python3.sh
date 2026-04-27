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

if [ "$KB_OVERRIDE_PYTHON_PATH" != "" ] ; then
    pythonpath=$KB_OVERRIDE_PYTHON_PATH
else
    pythonpath=$KB_PYTHON_PATH
fi


cat > $dst <<EOF1
#!/bin/bash
export KB_TOP=$top
export KB_RUNTIME=$runtime
export KB_PYTHON_PATH=$pythonpath
export PATH="$runtime/bin:$top/bin:\$PATH"
export PYTHONPATH=$pythonpath:\$PYTHONPATH
EOF1

if [ "$KB_CONDA_ENV" != "" ] ; then
    cat >> $dst <<'CONDA_ACTIVATE'
# Activate conda environment by discovering conda base from environment path
ENV_PATH="__KB_CONDA_ENV__"
CONDA_BASE=$(grep '# cmd:' "${ENV_PATH}/conda-meta/history" | head -1 | awk '{print $3}' | sed 's|/bin/conda||')
if [ -z "$CONDA_BASE" ]; then
    echo "ERROR: Could not determine conda base path from ${ENV_PATH}/conda-meta/history" >&2
    exit 1
fi
CONDA_SH="${CONDA_BASE}/etc/profile.d/conda.sh"
if [ ! -f "$CONDA_SH" ]; then
    echo "ERROR: conda.sh not found at ${CONDA_SH}" >&2
    exit 1
fi
. "$CONDA_SH"
conda activate "$ENV_PATH"
CONDA_ACTIVATE
    # Replace placeholder with actual value
    sed -i "s|__KB_CONDA_ENV__|$KB_CONDA_ENV|g" $dst
fi
for var in $PATH_ADDITIONS ; do
    echo "export PATH=$var:\$PATH" >> $dst
done

cat >> $dst <<EOF
exec python3 $src "\$@"
EOF

chmod +x $dst
