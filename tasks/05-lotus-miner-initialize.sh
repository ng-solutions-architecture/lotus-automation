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

  echo "Fetching +100GB parameter files. This might take a long time..."
  lotus-miner fetch-params ${SIZE}

  echo "Initializing lotus-miner..."
  lotus-miner init --no-local-storage --owner=$owner --worker=$worker --sector-size=${SIZE}
}

configure_miner() {
    IP=$1
    PORT=$2
    DIR=$3
    PUB_IP=$4
    P2P_PORT=$5
    
    mv ${DIR}/config.toml ${DIR}/config.toml.backup

    printf "
[API] \n
  ListenAddress = \"/ip4/${IP}/tcp/${PORT}/http\" \n
  RemoteListenAddress = \"${IP}:${PORT}\"\n\n

[Libp2p]\n
  ListenAddresses = [\"/ip4/0.0.0.0/tcp/${P2P_PORT}\"]\n
  AnnounceAddresses = [\"/ip4/${PUB_IP}/tcp/${P2P_PORT}\"]\n\n

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

announce_miner() {
  PUB_IP=$1
  P2P_PORT=$2

  lotus-miner actor set-addrs /ip4/${PUB_IP}/tcp/${P2P_PORT}
}

add_miner_storage() {
  STORAGE=$1
  lotus-miner storage attach --init --store ${STORAGE}
  lotus-miner storage list
}

initialize_sp ${SECTOR_SIZE}
configure_miner ${MINER_IP} ${MINER_PORT} ${LOTUS_MINER_DIR} ${MINER_PUBLIC_IP} ${MINER_P2P_PORT}
start_miner ${LOG_DIR}
announce_miner ${MINER_PUBLIC_IP} ${MINER_P2P_PORT}
add_miner_storage ${SEALED_STORAGE}