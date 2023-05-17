#!/usr/bin/bash

run_step() {
  STEP=$1

  chmod +x ./$STEP
  ./$STEP
}

run_step 01-lotus-prereqs.sh
run_step 02-lotus-install.sh
run_step 03-lotus-import-snapshot.sh
run_step 04-lotus-initialize.sh
run_step 05-lotus-miner-initialize.sh
