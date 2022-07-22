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

