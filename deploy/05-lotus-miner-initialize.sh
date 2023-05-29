#!/usr/bin/bash

source $HOME/.bashrc
source ./variables

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
  lotus-miner fetch-params ${SIZE}

  echo "Initializing lotus-miner..."
  lotus-miner init --no-local-storage --owner=$OWNER_WALLET --worker=$WORKER_WALLET --sector-size=${SIZE}
}

start_miner() {
  DIR=$1
  WAIT_TIME_SEC=180
  source ./variables
  echo "Miner repo will be created at ${LOTUS_MINER_PATH}"
  nohup lotus-miner run > ${DIR}/lotusminer.log 2>&1 &
  echo "Starting lotus-miner"
  sleep ${WAIT_TIME_SEC}
  lotus-miner info

  echo "Miner running"
  }

configure_miner() {
    IP=$1
    PORT=$2
    DIR=$3
    
    mv ${DIR}/config.toml ${DIR}/config.toml.backup

    printf "
[API]\n
  ListenAddress = \"/ip4/0.0.0.0/tcp/${PORT}/http\"\n
  RemoteListenAddress = \"${IP}:${PORT}\"\n
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

restart_miner(){
  lotus-miner stop
  sleep 5
  lotus-miner run > ${DIR}/lotusminer.log 2>&1 &
}

wait_for_miner(){
  while ! grep -q "starting up miner" ${LOG}/lotusminer.log; do
    sleep 1
  done
  
}

lotus_miner_api() {
  MINER_API=$(lotus-miner auth create-token --perm admin)
  echo "export MINER_API_INFO=${MINER_API}:/ip4/${MINER_IP}/tcp/${MINER_PORT}/http" >> $HOME/.bashrc
}


initialize_sp ${SECTOR_SIZE}
start_miner ${LOG_DIR}
configure_miner ${MINER_IP} ${MINER_PORT} ${LOTUS_MINER_PATH}
lotus_miner_api
restart_miner
wait_for_miner