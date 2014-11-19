#!/bin/sh

RULES_FILE=/tmp/rules.fw

add=0
delete=0
list=0
restore=0
mac=''

usage()
{
    echo ""
    echo "Usage: $0 -[ad] -m XX:XX:XX:XX:XX:XX"
    echo "       $0 -l"
    echo "       $0 -r /path/to/rules"
    echo "       $0 -h"
    echo ""
    echo "Commands:"
    echo " -a             Add mac to white-list"
    echo " -d             Delete mac from white-list"
    echo " -l             List rules"
    echo " -r             Restore rules"
    echo " -m address     Address to add or remove"
    echo " -h             Print this help information"
    exit 0
}

set -- $(getopt adlrm:h "$@")
while [ $# -gt 0 ]
    do
    case "$1" in
    (-a) add=1;;
    (-d) delete=1;;
    (-l) list=1;;
    (-r) restore=1;;
    (-m) mac="$2"; shift;;
    (-h) usage;;
    (--) shift; break;;
    (-*) echo "$0: error - unrecognized option $1" 1>&2; exit 1;;
    (*)  break;;
    esac
    shift
done

flags=$(($add + $delete + $list + $restore))
if [ $flags -eq 0 ] || [ $flags -gt 1 ]
then
    usage
fi

if [ $list -eq 1 ]
then
    sudo iptables -L INPUT
    exit 0
fi

if [ $restore -eq 1 ]
then
    if [ ! -f $RULES_FILE ]
    then
        echo "error: file $RULES_FILE does not exist"
        exit 1
    fi
    echo "restoring rule in file $RULES_FILE"
    sudo iptables-restore < $RULES_FILE
    exit 0
fi

mac_length=$(expr length "$mac")
if [ $mac_length != 17 ]
then
    usage
fi

mac_match_length=$(expr match "$mac" "[0-9A-Fa-f]\{2\}:[0-9A-Fa-f]\{2\}:[0-9A-Fa-f]\{2\}:[0-9A-Fa-f]\{2\}:[0-9A-Fa-f]\{2\}:[0-9A-Fa-f]\{2\}")
if [ $mac_match_length != 17 ]
then
    echo "error: invalid mac address"
    usage
fi

if [ $add -eq 1 ]
then
    sudo iptables -D INPUT -p tcp --dport 80 -j DROP
    sudo iptables -A INPUT -p tcp --dport 80 -m mac --mac-source $mac -j ACCEPT
    sudo iptables -A INPUT -p tcp --dport 80 -j DROP
    sudo iptables-save > $RULES_FILE
elif [ $delete -eq 1 ]
then
    sudo iptables -D INPUT -p tcp --dport 80 -j DROP
    sudo iptables -D INPUT -p tcp --dport 80 -m mac --mac-source $mac -j ACCEPT
    sudo iptables -A INPUT -p tcp --dport 80 -j DROP
    sudo iptables-save > $RULES_FILE
fi
