if [ -d $HOSTLOCAL/cuda ]; then
    export CUDA_PATH=$HOSTLOCAL/cuda
elif [ -d $OSLOCAL/cuda ]; then
    export CUDA_PATH=$OSLOCAL/cuda
fi

export PATH=$CUDA_PATH/bin:$PATH
export LD_LIBRARY_PATH=$CUDA_PATH/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$CUDA_PATH/lib64:$LD_LIBRARY_PATH

alias monitor_cuda='watch -n 1 nvidia-smi'

# Don't use gpu by default
export CUDA_VISIBLE_DEVICES=-1

