#!/bin/bash

RECORDINGS_PATH=/srv/datadisk/recordings
SINCE=1440 # 24 hours

set -e

for recording in $(find $RECORDINGS_PATH -mmin $SINCE -type f -name *.mkv)
do
    dir=$(dirname $recording)
    file=$(basename $recording)
    mp4=${file%.mkv}.mp4
    compressed="$dir/$mp4"
    rm -f $compressed
    #ffmpeg -i $recording -vcodec libx264 -b:v 2496k -acodec libmp3lame -ar 44100 -ab 128k -ac 2 -preset veryfast $compressed
    ffmpeg -i $recording -vcodec libx264 -b:v 2496k -acodec aac -strict -2 -ar 48000 -ab 96k -ac 2 -preset veryfast $compressed
done
