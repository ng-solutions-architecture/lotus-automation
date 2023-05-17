#!/usr/bin/env bash

source ./variables

download_snapshot() {
  DIR=$1
  
  echo "Downloading latest chain snapshot"
  aria2c -x5 https://snapshots.mainnet.filops.net/minimal/latest.zst -d ${DIR} -o latest-lotus-snapshot.zst
}

import_snapshot() {
  DIR=$1

  echo "Importing chain snapshot"
  nohup lotus daemon --import-snapshot ${DIR}/latest-lotus-snapshot.zst >> ${DIR}/lotus.log 2>&1 &

}

download_snapshot ${INSTALL_DIR}
import_snapshot ${INSTALL_DIR}
