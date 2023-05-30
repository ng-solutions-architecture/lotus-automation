#!/bin/bash

source ../variables

# Stopping all daemons
sudo systemctl disable lotus-daemon
sudo systemctl disable lotus-miner
sudo systemctl disable boostd
sudo systemctl disable booster-http
sudo systemctl disable nginx
sudo systemctl stop boostd
sudo systemctl stop booster-http
sudo systemctl stop lotus-miner
sudo systemctl stop lotus-daemon
sudo systemctl stop nginx
lotus daemon stop
lotus-miner stop
killall lotus-miner
killall lotus
killall boostd
killall booster-http

# Removing all files & directories
rm -rf ${BOOST_DIR}
rm -rf ${LOTUS_PATH}
rm -rf ${LOTUS_MINER_PATH}
sudo rm -rf ${LOG_DIR}
rm -rf ~/lotus
sudo rm /etc/lotus_env
sudo rm /etc/systemd/system/boost*
sudo rm /etc/systemd/system/lotus*
rm -rf {SEALED_STORAGE}/*
sudo rm -rf /etc/nginx/ipfs-gateway.conf.d
cp ~/bashrc.bckp ~/.bashrc
