#!/bin/sh

if [ $# -lt 1 ]
then
    echo "usage $0 pattern [path] [-d]"
    echo "-d find in depends"
    exit 1
fi

filepath="."
if [ $# -ge 2 ]
then
    test -d $2 && filepath="$2"
fi

content=1
if [ $# -eq 3 ] && [ $3 = "-d" ]
then
    content=0
fi

for file in $(find $filepath -name *.ipk)
do
    test -d $file && continue
    if [ $content -eq 1 ]
    then
        dpkg-deb -c $file | grep $1 > /dev/null
        if [ $? -eq 0 ]
        then
            echo "$1 found in $file"
        fi
    else
        dpkg-deb -I $file | grep $1 > /dev/null
        if [ $? -eq 0 ]
        then
            echo "$1 found in $file"
        fi
    fi
done
