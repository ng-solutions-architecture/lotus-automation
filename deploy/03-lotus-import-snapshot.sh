#!/usr/bin/env bash

bash -c 'source $HOME/.bashrc'
bash -c 'source ./variables'

import_snapshot() {
  DIR=$1
  LOG=$2

  echo "Importing chain snapshot. This takes ~30min for mainnet."
  echo "Current time is $(date +%T)"

  export LOTUS_PATH=$LOTUS_DIR
  echo "export LOTUS_PATH=$LOTUS_DIR" >> $HOME/.bashrc
  nohup lotus daemon --import-snapshot ${DIR}/latest-lotus-snapshot.zst >> ${LOG}/lotus.log 2>&1 &

  while true; do
        if [[ $(lotus info | grep "sync ok") ]]; then
                break
        else
                echo "Waiting for snapshot to be imported and chain to be synced..."
        fi
  done


}

import_snapshot ${INSTALL_DIR} ${LOG_DIR}
