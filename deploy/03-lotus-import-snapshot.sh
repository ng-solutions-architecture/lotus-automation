#!/usr/bin/env bash

source $HOME/.bashrc
source ./variables

download_snapshot() {
  DIR=$1
  rm ${DIR}/latest-lotus-snapshot.zst*
  echo "Downloading latest chain snapshot"

  if [ $USE_CALIBNET == "y" ];
  then aria2c -x5 https://snapshots.calibrationnet.filops.net/minimal/latest.zst -d ${DIR} -o latest-lotus-snapshot.zst
    else aria2c -x5 https://snapshots.mainnet.filops.net/minimal/latest.zst -d ${DIR} -o latest-lotus-snapshot.zst
  fi
}

import_snapshot() {
  DIR=$1
  LOG=$2

  echo "Importing chain snapshot. This takes ~30min for mainnet."
  echo "Current time is $(date +%T)"

  export LOTUS_PATH=$LOTUS_DIR
  echo "export LOTUS_PATH=$LOTUS_DIR" >> $HOME/.bashrc
  nohup lotus daemon --import-snapshot ${DIR}/latest-lotus-snapshot.zst > ${LOG}/lotus.log 2>&1 &

  while ! grep -q "100.00%" ${LOG}/lotus.log; do
    sleep 60
  done
}

sync_chain() {
  echo "Syncing the chain..."
  lotus sync wait
}

download_snapshot ${INSTALL_DIR}
import_snapshot ${INSTALL_DIR} ${LOG_DIR}
sync_chain