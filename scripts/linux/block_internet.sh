#!/bin/sh

if [ $# -lt 1 ]; then
    echo "usage $0 block | allow | list"
fi

case $1 in
    block)
        echo "block"
        sudo iptables -A OUTPUT -p tcp --dport 443 -j DROP
        sudo iptables -A OUTPUT -p tcp --dport 80 -j DROP
        ;;
    allow)
        echo "allow"
        sudo iptables -D OUTPUT 1
        sudo iptables -D OUTPUT 1
        ;;
    list)
        echo "list"
        sudo iptables --list
        ;;
    *)
        echo "usage $0 block | allow | list"
        ;;
esac
