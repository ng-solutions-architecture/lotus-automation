#!/bin/bash

source ./variables
source $HOME/.bashrc

create_boost_wallets() {
  DIR=$1

  echo "Creating deals and collateral wallets"
  DEALS_WALLET=$(lotus wallet new bls)
  COLLATERAL_WALLET=$(lotus wallet new bls)

  export PUBLISH_STORAGE_DEALS_WALLET=${DEALS_WALLET}
  echo "export PUBLISH_STORAGE_DEALS_WALLET=${DEALS_WALLET}" >> $HOME/.bashrc
  export COLLAT_WALLET=${COLLATERAL_WALLET}
  echo "export COLLAT_WALLET=${COLLATERAL_WALLET}" >> $HOME/.bashrc
}

set_boost_vars() {
  export BOOST_CLIENT_REPO=${BOOST_CLIENT}
  echo "export BOOST_CLIENT_REPO=${BOOST_CLIENT}" >> $HOME/.bashrc
  export BOOST_BITSWAP_REP=${BOOST_BITSWAP}
  echo "export BOOST_BITSWAP_REP=${BOOST_BITSWAP}" >> $HOME/.bashrc
  export BOOST_PATH=${BOOST_DIR}
  echo "export BOOST_PATH=${BOOST_DIR}" >> $HOME/.bashrc
  export APISEALER=${MINER_API_INFO}
  export APISECTORINDEX=${MINER_API_INFO}
  }

send_funds_to_boost() {
  lotus send --from ${OWNER_WALLET} ${PUBLISH_STORAGE_DEALS_WALLET} 0.2
  lotus send --from ${OWNER_WALLET} ${COLLAT_WALLET} 0.2
  echo "Waiting 3 minutes for funds to arrive"
  sleep 3m
}

set_boost_control_wallet() {
    lotus-miner actor control set --really-do-it ${PUBLISH_STORAGE_DEALS_WALLET}
}

build_boost() {
    DIR=$1

    cd ${DIR}
    git clone https://github.com/filecoin-project/boost
    cd boost
    git checkout ${BOOST_VERSION}

    if [ $USE_CALIBNET == "y" ];
        then make clean calibnet
    else 
      make clean build
  fi

    sudo make install
}

create_boost_wallets ${INSTALL_DIR}
set_boost_vars
send_funds_to_boost
set_boost_control_wallet
build_boost ${INSTALL_DIR}
