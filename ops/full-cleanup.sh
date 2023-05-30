#!/bin/bash

source ../variables

warning_message (){
    
  echo "CAUTION: This script will remove ALL your Lotus and Boost configuration and services!"
  while true; do
      read -p "Do you want to continue? (y/n) " choice
      if [ "$choice" == "y" ]; then
          echo "Removing configuration and services..."
          break
      elif [ "$choice" == "n" ]; then
          echo -e "If you wish stop the removal, press ctrl-c"
      else
          echo "Invalid input"
      fi
  done
}

cleanup_all (){
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
}

warning_message
cleanup_all