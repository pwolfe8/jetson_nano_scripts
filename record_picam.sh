#!/bin/bash
echo ===================
echo RASPI CAM RECORDING
echo ===================

WIDTH=1280
HEIGHT=720
FPS=30
#DEVICE=/dev/video0. not needed uses nvarguscamerasrc

current_time=$(date "+%Y-%m-%d_%H.%M.%S")
echo "current time: $current_time"

mkdir -p ~/Videos
FILEOUT=~/Videos/raspi_vid_$current_time.mp4

# pi cam formats:
#ioctl: VIDIOC_ENUM_FMT
#	Index       : 0
#	Type        : Video Capture
#	Pixel Format: 'RG10'
#	Name        : 10-bit Bayer RGRG/GBGB
#		Size: Discrete 3264x2464
#			Interval: Discrete 0.048s (21.000 fps)
#		Size: Discrete 3264x1848
#			Interval: Discrete 0.036s (28.000 fps)
#		Size: Discrete 1920x1080
#			Interval: Discrete 0.033s (30.000 fps)
#		Size: Discrete 1280x720
#			Interval: Discrete 0.017s (60.000 fps)
#		Size: Discrete 1280x720
#			Interval: Discrete 0.017s (60.000 fps)

VID_FORMAT='video/x-raw(memory:NVMM), width=(int)'$WIDTH', height=(int)'$HEIGHT', format=(string)NV12, framerate=(fraction)'$FPS'/1'


#overlay cmd
#gst-launch-1.0 nvarguscamerasrc ! 'video/x-raw(memory:NVMM), width=(int)1920, height=(int)1080, format=(string)NV12, framerate=(fraction)30/1' ! nvoverlaysink -e

echo launching cmd: 


#265 encoding
gst-launch-1.0 nvarguscamerasrc maxperf=1 ! $VID_FORMAT ! nvv4l2h265enc control-rate=1 bitrate=8000000 ! 'video/x-h265, stream-format=(string)byte-stream' ! h265parse ! qtmux ! filesink location=$FILEOUT -e 

#264 encoding
#gst-launch-1.0 nvarguscamerasrc maxperf=1 ! $VID_FORMAT ! nvv4l2h264enc control-rate=1 bitrate=8000000 ! 'video/x-h264, stream-format=(string)byte-stream' ! h264parse ! qtmux ! filesink location=$FILEOUT -e 

echo
echo ===================================================
echo Finished Recording
echo Wrote to $FILEOUT
echo 
