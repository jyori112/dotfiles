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

# Git
alias gwip='git checkout ${$(git rev-parse --abbrev-ref HEAD)%_wip}_wip  2> /dev/null || git checkout -b ${$(git rev-parse --abbrev-ref HEAD)%_wip}_wip'
alias gwipb='git checkout ${$(git rev-parse --abbrev-ref HEAD)%_wip}'

# Docker
alias dm='docker-machine'
alias dc='docker-compose'

# pvlbzip
pvlbzip2() {
    pv -s `stat -L $1 -c "%s"` $1 | lbzip2 -dc
}

# Make
remake() {
    SAVE_LOG="true"
    NOTIFY="true"

    for OPT in "$@";
    do
        if [ $OPT = '--help' ] || [ $OPT = '-n' ] || [ $OPT = '--just-print' ] || [ $OPT = '--dry-run' ] || [ $OPT = '--recon' ] || [ $OPT = '-p' ] || [ $OPT = '--print-date-base' ];
        then
            SAVE_LOG="false"
            NOTIFY="false"
        fi
    done

    if [ ! -z "$(git status --porcelain)" ] && $SAVE_LOG;
    then
        echo -n "There are uncommited changes, commit? (y/n): "

        local ch

        read ch

        if [ $ch = 'Y' ] || [ $ch = 'y' ];
        then
            git add .
            git commit -m "Auto commit $(date '+%Y/%m/%d %H:%M:%S %Z')"
        fi
    fi

    if $SAVE_LOG;
    then
        echo -n "[$(date '+%Y/%m/%d %H:%M:%S')] " >> .make.log
        echo -n "($(git rev-parse --short HEAD), " >> .make.log

        if [ -z "$(git status --porcelain)" ];
        then
            echo -n "clean): " >> .make.log
        else
            echo -n "dirty): " >> .make.log
        fi

        echo $@ >> .make.log
    fi

    make $@

    if $NOTIFY;
    then
        echo remake $@| python ~/scripts/remake_notification.py --success=$?
    fi
}

# #times-jin
#export SLACK_WEBHOOK=https://hooks.slack.com/services/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
# #jin-notify
export SLACK_WEBHOOK=https://hooks.slack.com/services/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

if [ "$OSNAME" = "macos" ];
then
    alias logtime='while read -r line; do echo "[$(date '+%Y/%m/%d-%H:%M:%S')] $(echo $line)"; done'
else
    alias logtime='while read -r line; do echo "[$(date '+%Y/%m/%d-%H:%M:%S.%3N')] $(echo $line)"; done'
fi

# Screen
alias sr='screen -r'
alias sS='screen -S'

# Local install
alias config='./configure --prefix=$HOME/local'
alias host_config='./configure --prefix=$HOME/locals/$HOSTNAME'
alias os_config='./configure --prefix=$HOME/locals/$OSNAME'

# Jump to root directory of git
cdgit() {
    if git rev-parse --git-fir > /dev/null 2>&1; then
        GitDir=$(git rev-parse --show-toplevel)
    else
        echo "Not in git repository" >&2
        return
    fi

    cd $GitDir
}

# Make rm safe
export TRASH_PATH=$HOME/.trash

alias rm='safe_rm'
alias size_trash='du $TRASH_PATH'

function safe_rm() {
    if [ -z $TRASH_PATH ]; then
        echo "$TRASH_PATH not set" 1>&2
        return 1
    fi

    if [ ! -e $TRASH_PATH ]; then
        echo "Trash path '$TRASH_PATH' not found" 1>&2
        return 1
    fi

    echo $@| grep -Gq "^/"
    if [ $? -eq 0 ]; then
        echo "You cannot remove /... files" 1>&2
        return 1
    fi

    trash_dir=$TRASH_PATH/$(date +%Y%m%d/%H%M)

    if [ ! -e $trash_dir ]; then
        mkdir -p $trash_dir
    fi

    for file in "$@";
    do
        if [ -d $file ]; then
            echo -n "$file is a directory, are you sure? (Y/n): "

            local ch

            while : ; do
                read ch
                if [ "${ch}" = "Y" ]; then
                    mv -f $file $trash_dir
                    break
                elif [ "${ch}" = "N" ] || [ "${ch}" = "n" ]; then
                    break
                else
                    echo -n "(Y/n): "
                fi
            done
        else
            mv $file $trash_dir
        fi
    done
}

function rmrm() {
    echo $@| grep -Gq "^/"

    if [ $? -eq 0 ]; then
        echo "You cannot remove /... files" 1>&2
        return 1
    fi

    # Show files about to be removed
    ls $@
    if [ $? -ne 0 ]; then
        return 1
    fi

    # Confirm message
    echo -n "Are you sure? (Y/n): "

    while : ; do
        read ch
        if [ "${ch}" = "Y" ]; then
            command rm $@
            return 0
        elif [ "${ch}" = "n" ] || [ "${ch}" = "N" ]; then
            return 1
        else
            echo "(Y/n): "
        fi
    done
}

function peco-src () {
  local selected_dir=$(ghq list -p | peco --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N peco-src
bindkey '^]' peco-src

setopt hist_ignore_all_dups

function peco_select_history() {
  local tac
  if which tac > /dev/null; then
    tac="tac"
  else
    tac="tail -r"
  fi
  BUFFER=$(fc -l -n 1 | eval $tac | peco --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle clear-screen
}
zle -N peco_select_history
bindkey '^r' peco_select_history

function change-codecommit-credential(){
  local selected_dir=$(find ~ -maxdepth 1 |grep netrc | peco --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
	  cp ${selected_dir} ~/.netrc
	fi
	echo '-----------------------------'
	echo 'view current "~/.netrc" settings'
	echo '-----------------------------'
	sed -n 1,3p ~/.netrc
}
alias ccc='change-codecommit-credential'