#!/bin/bash

echo "Downloading latest chain snapshot"
aria2c -x5 https://snapshots.mainnet.filops.net/minimal/latest.zst -d /opt -o latest-lotus-snapshot.zst

echo "Importing chain snapshot"
nohup lotus daemon --import-snapshot /opt/latest-lotus-snapshot.zst > /opt/lotus.log 2>&1 &
