if [ -d $PYENV_ROOT ]; then
	export NVIM_PYTHON3=$PYENV_ROOT/versions/neovim-py3/bin/python
    export NVIM_PYTHON2=$PYENV_ROOT/versions/neovim-py2/bin/python
fi
