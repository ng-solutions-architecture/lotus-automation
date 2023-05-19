#!/usr/bin/bash

source ./variables
source ${INSTALL_DIR}/wallet_addresses

initialize_sp() {
  SIZE=$1
  export FIL_PROOFS_PARAMETER_CACHE=$PARAM_CACHE
  echo "export FIL_PROOFS_PARAMETER_CACHE=$PARAM_CACHE" >> $HOME/.bashrc
  export FIL_PROOFS_PARENT_CACHE=$PARENT_CACHE
  echo "export FIL_PROOFS_PARENT_CACHE=$PARENT_CACHE" >> $HOME/.bashrc

  export LOTUS_SEALING_AGGREGATECOMMITS=false
  echo "export LOTUS_SEALING_AGGREGATECOMMITS=false" >> $HOME/.bashrc
  export LOTUS_SEALING_BATCHPRECOMMITS=false
  echo "export LOTUS_SEALING_BATCHPRECOMMITS=false" >> $HOME/.bashrc

  lotus-miner init --no-local-storage --owner=$owner --worker=$worker --sector-size=${SIZE}
}

start_miner() {
  DIR=$1
  WAIT_TIME_SEC=120

  nohup lotus-miner run > ${DIR}/lotusminer.log 2>&1 &
  echo "Starting lotus-miner"
  sleep ${WAIT_TIME_SEC}
  lotus-miner info

  echo "Miner running"
}

initialize_sp ${SECTOR_SIZE}
start_miner ${LOG_DIR}
