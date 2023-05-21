#!/bin/bash

source ./variables
source $HOME/.bashrc

set_boost_config () {
    sed -i -e '/ListenAddress =/ s/= .*/= "\/ip4\/0.0.0.0\/tcp\/${BOOST_PORT}\/http"/' ${BOOST_DIR}/config.toml
    sed -i -e '/RemoteListenAddress =/ s/= .*/= "\/ip4\/${BOOST_IP}\/tcp\/${BOOST_PORT}\/http"/' ${BOOST_DIR}/config.toml
    sed -i -e '/ListenAddresses =/ s/= .*/= \["\/ip4\/0.0.0.0\/tcp\/${BOOST_P2P_PORT}"\]/' ${BOOST_DIR}/config.toml
    sed -i -e '/AnnounceAddresses =/ s/= .*/= \["\/ip4\/${BOOST_PUB_IP}\/tcp\/${BOOST_P2P_PORT}"\]/' ${BOOST_DIR}/config.toml
    sed -i -e '/NoAnnounceAddresses =/ s/= .*/= \[\]/' ${BOOST_DIR}/config.toml
}

restart_boost () {
    DIR=$1

    killall boostd
    boostd --vv run >> $1/boost.log 2>&1 &
}

set_boost_config
restart_boost ${LOG_DIR}