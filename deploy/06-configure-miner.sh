#!/bin/bash

bash -c 'source $HOME/.bashrc'
bash -c 'source ./variables'

add_miner_storage() {
  STORAGE=$1
  sudo chown $(whoami) ${STORAGE}
  lotus-miner storage attach --init --store ${STORAGE}
  lotus-miner storage list
}

lotus_miner_api() {
  MINER_API=$(lotus-miner auth create-token --perm admin)
  export MINER_API_INFO=${MINER_API}:/ip4/${MINER_IP}/tcp/${MINER_PORT/http}
  echo "export MINER_API_INFO=${MINER_API}:/ip4/${MINER_IP}/tcp/${MINER_PORT}/http" >> $HOME/.bashrc
}

add_miner_storage ${SEALED_STORAGE}
lotus_miner_api
