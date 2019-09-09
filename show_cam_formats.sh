#!/bin/bash
DEVICE=$1
echo input device arg
v4l2-ctl -d $DEVICE --list-formats-ext
