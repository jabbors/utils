#!/bin/sh

if [ $# -ne 1 ]
then
    echo "usage: $0 <string to find>"
    exit 1
fi

grep_in_deb()
{
    test $# -ne 2 && return 1
    dpkg -L $1 | grep $2 > /dev/null && return 0
    return 1
}

TMPFILE=$(mktemp)
dpkg --get-selections > $TMPFILE

while read line
do
    package=$(echo $line | cut -d' ' -f1)
    grep_in_deb $package $1 && echo "$1 found in $package"
done < $TMPFILE

rm -f $TMPFILE
