export HOSTNAME=$(hostname)

case "$HOSTNAME" in
setagaya | kamiya | hoya | tokyo100 )
    export OSNAME="centos6"
;;
chitose | kyoto | kobe | ishikari | muroran | tokyo101 | tokyo102 | tokyo103 )
    export OSNAME="ubuntu16"
;;
tokyo199 )
    export OSNAME="ubuntu18"
;;
kanagawa | nabari )
    export OSNAME="ubuntu20"
esac

export LOCAL=$HOME/locals/$OSNAME