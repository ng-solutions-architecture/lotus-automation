#!/bin/bash

set -x
set -e
shopt -s nullglob

source $HOME/.bashrc > /dev/null 2>&1
source ./variables > /dev/null 2>&1

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

set_boost_config() {
    sed -i -e "/ListenAddress =/ s/= .*/= \"\/ip4\/0.0.0.0\/tcp\/${BOOST_PORT}\/http\"/" ${BOOST_DIR}/config.toml
    sed -i -e "/RemoteListenAddress =/ s/= .*/= \"\/ip4\/${BOOST_IP}\/tcp\/${BOOST_PORT}\/http\"/" ${BOOST_DIR}/config.toml
    sed -i -e "/ListenAddresses =/ s/= .*/= \[\"\/ip4\/0.0.0.0\/tcp\/${BOOST_P2P_PORT}\"\]/" ${BOOST_DIR}/config.toml
    sed -i -e "/AnnounceAddresses =/ s/= .*/= \[\"\/ip4\/${BOOST_PUB_IP}\/tcp\/${BOOST_P2P_PORT}\"\]/" ${BOOST_DIR}/config.toml
    sed -i -e "/NoAnnounceAddresses =/ s/= .*/= \[\]/" ${BOOST_DIR}/config.toml
}

run_boost() {
    DIR=$1
    boostd --vv run > ${DIR}/boost.log 2>&1 &
    sleep 10s
    ENV_BOOST_API_INFO=$(boostd auth api-info --perm=admin)
    export BOOST_API_INFO=$(echo $ENV_BOOST_API_INFO | awk '{split($0,a,"="); print a[2]}')
    echo "export BOOST_API_INFO=$(echo $ENV_BOOST_API_INFO | awk '{split($0,a,"="); print a[2]}')" >> $HOME/.bashrc
    echo "Boost API env is: $ENV_BOOST_API_INFO"
    echo "Boost API is:$BOOST_API_INFO"    
}

set_boost_api () {
    ENV_BOOST_API_INFO=$(boostd auth api-info --perm=admin)
    export BOOST_API_INFO=$(echo $ENV_BOOST_API_INFO | awk '{split($0,a,"="); print a[2]}')
    echo "export BOOST_API_INFO=$(echo $ENV_BOOST_API_INFO | awk '{split($0,a,"="); print a[2]}')" >> $HOME/.bashrc
    echo "Boost API env is: $ENV_BOOST_API_INFO"
    echo "Boost API is:$BOOST_API_INFO"
}

set_extra_boost_vars
initialize_boost
set_boost_config
run_boost ${LOG_DIR}
#set_boost_api
