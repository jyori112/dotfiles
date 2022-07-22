# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"

#export LANG=C

ZSH_THEME="powerlevel10k/powerlevel10k"
ZSH_DISABLE_COMPFIX=true

plugins=(
  git
  jump
)

# Start on-my-zsh
source $ZSH/oh-my-zsh.sh

ZSH_D=$HOME/.zsh.d

LOCAL_ZSH_D=$HOME/.zsh.local.d

# Local install directory
export LOCAL=$HOME/local

# Default Setup
source $ZSH_D/default_setup.zsh

# Local Setup
if [ -f $LOCAL_ZSH_D/setup.zsh ]; then
    source $LOCAL_ZSH_D/setup.zsh
fi

########## Set PATH and LD_LIBRARY PATH ##########
# Local install setting
export LD_LIBRARY_PATH=$LOCAL/lib:$LD_LIBRARY_PATH
export PATH=$LOCAL/bin:$PATH

########## Load Design ##########
source $ZSH_D/design.zsh

########## Set various aliases and functions ##########
source $ZSH_D/alias.zsh

########## Application specific configuration ##########
# Config GPU related
source $ZSH_D/specifics/cuda.zsh

# Config pyenv related
source $ZSH_D/specifics/pyenv.zsh

# Config rbenv related
source $ZSH_D/specifics/rbenv.zsh

# Config openjdk related
source $ZSH_D/specifics/openjdk.zsh

# Config nvim related
source $ZSH_D/specifics/nvim.zsh

# Config direnv related
source $ZSH_D/specifics/direnv.zsh

source $ZSH_D/specifics/nodebrew.zsh

source $ZSH_D/sdkman.zsh

########## Start powerlevel ##########
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
