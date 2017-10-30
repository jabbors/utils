#!/bin/bash

if [ $# -ne 3 ]; then
    echo "usage: $0 input1 input2 output"
    exit 1
fi

if [ ! -f $1 ]; then
    echo "error: input file $1 does not exist"
    exit 2
fi

if [ ! -f $2 ]; then
    echo "error: input file $1 does not exist"
    exit 2
fi

set -e

echo "file '$1'" > input.txt
echo "file '$2'" >> input.txt
ffmpeg -f concat -i input.txt -vcodec libx264 -b:v 2496k -acodec aac -strict -2 -ar 48000 -ab 96k -ac 2 -preset veryfast $3
rm input.txt
