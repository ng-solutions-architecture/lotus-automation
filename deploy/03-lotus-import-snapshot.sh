#!/usr/bin/env bash

source $HOME/.bashrc
source ./variables

import_snapshot() {
  DIR=$1
  LOG=$2

  echo "Importing chain snapshot. This takes ~30min for mainnet."
  echo "Current time is $(date +%T)"

  export LOTUS_PATH=$LOTUS_DIR
  echo "export LOTUS_PATH=$LOTUS_DIR" >> $HOME/.bashrc
  nohup lotus daemon --import-snapshot ${DIR}/latest-lotus-snapshot.zst >> ${LOG}/lotus.log 2>&1 &

  if [ $USE_CALIBNET == "y" ];
  then sleep 10m
    else sleep 30m
  fi
}

import_snapshot ${INSTALL_DIR} ${LOG_DIR}
