#!/bin/bash

sudo ip a flush eth0
sudo systemctl restart networking.service
