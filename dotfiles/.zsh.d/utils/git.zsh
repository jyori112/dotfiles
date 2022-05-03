# Git
alias gwip='git checkout ${$(git rev-parse --abbrev-ref HEAD)%_wip}_wip  2> /dev/null || git checkout -b ${$(git rev-parse --abbrev-ref HEAD)%_wip}_wip'
alias gwipb='git checkout ${$(git rev-parse --abbrev-ref HEAD)%_wip}'
alias gp='git push'
alias gpo='git push origin HEAD'


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
