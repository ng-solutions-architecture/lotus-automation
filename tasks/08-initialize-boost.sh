#!/bin/bash

source ./variables
source $HOME/.bashrc

set_extra_boost_vars() {
  export APISEALER=${MINER_API_INFO}
  export APISECTORINDEX=${MINER_API_INFO}
}

initialize_boost() {
    boostd --vv init \
       --api-sealer=$APISEALER \
       --api-sector-index=$APISECTORINDEX \
       --wallet-publish-storage-deals=$PUBLISH_STORAGE_DEALS_WALLET \
       --wallet-deal-collateral=$COLLAT_WALLET \
       --max-staging-deals-bytes=50000000000   
}

run_boost() {
    DIR=$1
    boostd --vv run > ${DIR}/boost.log 2>&1 &
    sleep 10s
}

announce_boost() {
  IP=$1
  PORT=$2
  PEERID=$(boostd net id)
  
  lotus-miner actor set-addrs /ip4/${IP}/tcp/${PORT}
  lotus-miner actor set-peer-id ${PEERID}
}

set_boost_api() {
  API_IP=$1
  API_PORT=$2

  TOKEN=$(boostd auth api-info --perm=admin)
  export BOOST_API_INFO=${TOKEN}:/ip4/${API_IP}/tcp/${API_PORT/http}
  echo "export BOOST_API_INFO=${TOKEN}:/ip4/${API_IP}/tcp/${API_PORT/http}" >> $HOME/.bashrc
}

set_extra_boost_vars
initialize_boost
run_boost ${LOG_DIR}
announce_boost ${BOOST_PUB_IP} ${BOOST_P2P_PORT}
set_boost_api ${BOOST_IP} ${BOOST_PORT}