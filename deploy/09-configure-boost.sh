#!/bin/bash

set -x
set -e
shopt -s nullglob

source $HOME/.bashrc > /dev/null 2>&1
source ./variables > /dev/null 2>&1

announce_boost() {
  IP=$1
  PORT=$2
  PEERID=$(boostd net id)
  
  lotus-miner actor set-addrs /ip4/${IP}/tcp/${PORT}
  lotus-miner actor set-peer-id ${PEERID}
}

start_booster_http() {
    DIR=$1

    if [ ${USE_BOOSTER_HTTP} == "y" ]; 
    then booster-http run --api-boost=${BOOST_API_INFO} --api-fullnode=${FULLNODE_API_INFO} --api-storage=${MINER_API_INFO} --port=${HTTP_PORT}>> ${DIR}/booster-http.log 2>&1 &
    else echo "Booster-HTTP is not started in this configuration."
    fi
}

announce_boost ${BOOST_PUB_IP} ${BOOST_P2P_PORT}
start_booster_http ${LOG_DIR}
