# If pyenv need to be os/host specific, symlink to os/host specific version
# Otherwise, symlink to $HOME/.pyenv
export PYENV_ROOT=$HOME/.pyenv

if [[ -d $PYENV_ROOT ]]; then
    export PATH=$PYENV_ROOT/bin:$PATH
    eval "$(pyenv init --path)"
    eval "$(pyenv virtualenv-init -)"
fi
