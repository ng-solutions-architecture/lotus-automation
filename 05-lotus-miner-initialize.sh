#!/usr/bin/bash

source ./variables
source ${INSTALL_DIR}/wallet_addresses

initialize_sp() {
  SIZE=$1

  export LOTUS_SEALING_AGGREGATECOMMITS=false
  export LOTUS_SEALING_BATCHPRECOMMITS=false
  lotus-miner init --owner=$owner --worker=$worker --sector-size=${SIZE}
}

start_miner() {
  DIR=$1
  WAIT_TIME_SEC=45

  nohup lotus-miner run > ${DIR}/lotusminer.log 2>&1 &
  echo "Starting lotus-miner"
  sleep ${WAIT_TIME_SEC}
  lotus-miner info
  echo "Miner running"
}

initialize_sp ${SECTOR_SIZE}
start_miner ${INSTALl_DIR}
