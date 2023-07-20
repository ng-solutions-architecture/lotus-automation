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

set_boost_config() {
    sed -i -e "/ListenAddress =/ s/= .*/= \"\/ip4\/0.0.0.0\/tcp\/${BOOST_PORT}\/http\"/" ${BOOST_DIR}/config.toml
    sed -i -e "/RemoteListenAddress =/ s/= .*/= \"\/ip4\/${BOOST_IP}\/tcp\/${BOOST_PORT}\/http\"/" ${BOOST_DIR}/config.toml
    sed -i -e "/ListenAddresses =/ s/= .*/= \[\"\/ip4\/0.0.0.0\/tcp\/${BOOST_P2P_PORT}\"\]/" ${BOOST_DIR}/config.toml
    sed -i -e "/AnnounceAddresses =/ s/= .*/= \[\"\/ip4\/${BOOST_PUB_IP}\/tcp\/${BOOST_P2P_PORT}\"\]/" ${BOOST_DIR}/config.toml
    sed -i -e "/NoAnnounceAddresses =/ s/= .*/= \[\]/" ${BOOST_DIR}/config.toml
}

restart_boost() {
    DIR=$1

    killall boostd
    boostd --vv run >> ${DIR}/boost.log 2>&1 &
    sleep 10
}

start_booster_http() {
    DIR=$1

    if [ ${USE_BOOSTER_HTTP} == "y" ]; 
    then booster-http run --api-boost=${BOOST_API_INFO} --api-fullnode=${FULLNODE_API_INFO} --api-storage=${MINER_API_INFO} --port=${HTTP_PORT}>> ${DIR}/booster-http.log 2>&1 &
    else echo "Booster-HTTP is not started in this configuration."
    fi
}

set_boost_config
restart_boost ${LOG_DIR}
announce_boost ${BOOST_PUB_IP} ${BOOST_P2P_PORT}
start_booster_http ${LOG_DIR}
