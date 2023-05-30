#!/bin/bash

source ../variables

# Stopping all daemons
sudo systemctl disable lotus-daemon
sudo systemctl disable lotus-miner
sudo systemctl stop lotus-miner
sudo systemctl stop lotus-daemon
lotus daemon stop
lotus-miner stop
killall lotus-miner
killall lotus
killall boostd
killall booster-http

# Removing all files & directories
rm -rf /opt/.boost
rm -rf /opt/.lotus*
sudo rm -rf /var/log/lotus
rm -rf ~/lotus
sudo rm /etc/lotus_env
sudo rm /etc/systemd/system/boost*
sudo rm /etc/systemd/system/lotus*
rm -rf /opt/seal/*
sudo rm -rf /etc/nginx/ipfs-gateway.conf.d
cp ~/bashrc.bckp ~/.bashrc
