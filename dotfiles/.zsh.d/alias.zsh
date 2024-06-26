bindkey -v

plugins=(
  vi-mode
)

# List directory
alias l='ls'
alias ll='ls -l'
alias lh='ls -lh'
alias la='ls -la'
alias lah='ls -lah'
alias lha='ls -lha'

# du
alias dh='du -h'

# Parent directory
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'

# Docker
alias dc='docker-compose'

# Screen
alias sr='screen -r'
alias sS='screen -S'

# peco
alias pecopy='peco | pbcopy'
alias pexec='peco | zsh'

# copy previous command
alias cpc='history| cut -c 8-| tail -n1| pbcopy'

source $ZSH_D/utils/ccc.zsh
source $ZSH_D/utils/peco_commands.zsh
source $ZSH_D/utils/peco_dirs.zsh
source $ZSH_D/utils/peco_gits.zsh
source $ZSH_D/utils/git.zsh
source $ZSH_D/utils/safe_rm.zsh
