#!/bin/sh

pdftk_cmd=/usr/bin/pdftk
if [ ! -f $pdftk_cmd ]
then
    echo "error: executable '$pdftk_cmd' does not exists, please install package 'pdftk'"
    exit 1
fi

if [ $# -lt 2 ]
then
    echo "usage: $0 /path/to/pdffiles output"
    exit 1
fi

if [ ! -d $1 ]
then
    echo "error: directory '$1' does not exist"
    exit 2
fi

pdffiles=$(find $1 -name *.pdf -type f | sort)
test -z "$pdffiles" && echo "no files found" && exit 0
$pdftk_cmd $pdffiles output $2
