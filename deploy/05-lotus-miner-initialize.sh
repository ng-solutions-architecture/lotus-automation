#!/usr/bin/bash

set -x
set -e
shopt -s nullglob

source $HOME/.bashrc > /dev/null 2>&1
source ./variables > /dev/null 2>&1

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
  
  export LOTUS_MINER_PATH=${LOTUS_MINER_PATH}
  echo "export LOTUS_MINER_PATH=${LOTUS_MINER_PATH}" >> $HOME/.bashrc

  echo "Fetching +100GB parameter files. This might take a long time..."
  #lotus-miner fetch-params ${SIZE}

  echo "Initializing lotus-miner..."
  lotus-miner init --no-local-storage --owner=$OWNER_WALLET --worker=$WORKER_WALLET --sector-size=${SIZE}
}

start_miner() {
  DIR=$1
  nohup lotus-miner run > ${DIR}/lotusminer.log 2>&1 &
  echo "Starting lotus-miner"
  }

configure_miner() {
    IP=$1
    PORT=$2
    DIR=$3
    
    mv ${DIR}/config.toml ${DIR}/config.toml.backup

    printf "
[API]\n
  ListenAddress = \"/ip4/0.0.0.0/tcp/${PORT}/http\"\n
  Timeout = \"30s\"\n\n

[Storage]\n
  AllowAddPiece = false\n
  AllowPreCommit1 = false\n
  AllowPreCommit2 = false\n
  AllowCommit = true\n
  AllowUnseal = true\n
  AllowReplicaUpdate = true\n
  AllowProveReplicaUpdate2 = true\n
  " > ${DIR}/config.toml
}

stop_miner(){
  lotus-miner stop
  sleep 15
}

wait_for_miner(){
  LOG=$1
  while ! grep -q "starting up miner" ${LOG}/lotusminer.log; do
    sleep 1
  done
  lotus-miner info
  sleep 5 
}

initialize_sp ${SECTOR_SIZE}
configure_miner ${MINER_IP} ${MINER_PORT} ${LOTUS_MINER_PATH}
start_miner ${LOG_DIR}
#stop_miner
#start_miner ${LOG_DIR}
wait_for_miner ${LOG_DIR}
