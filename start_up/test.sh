#!/bin/sh
#test.sh

mkdir /tmp/stream
raspistill -tl 1000 -t 100000 -o /tmp/stream/test.jpg -q 1 -n