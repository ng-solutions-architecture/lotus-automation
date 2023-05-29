#!/bin/bash

source $HOME/.bashrc
source ./variables

announce_miner() {
  PUB_IP=$1
  P2P_PORT=$2

  lotus-miner actor set-addrs /ip4/${PUB_IP}/tcp/${P2P_PORT}
}

add_miner_storage() {
  STORAGE=$1
  sudo chown $(whoami) ${STORAGE}
  lotus-miner storage attach --init --store ${STORAGE}
  lotus-miner storage list
}

announce_miner ${PUBLIC_IP} ${P2P_PORT}
add_miner_storage ${SEALED_STORAGE}