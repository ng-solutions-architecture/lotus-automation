#!/usr/bin/env bash

run_step() {
  STEP=$1

  chmod +x ./$STEP
  ./$STEP
}

echo "Installing lotus prerequisites..."
run_step 01-lotus-prereqs.sh

echo "Installing lotus..."
run_step 02-lotus-install.sh

echo "Importing lotus snapshot..."
run_step 03-lotus-import-snapshot.sh

echo "Initializing lotus..."
run_step 04-lotus-initialize.sh

echo "Initializing lotus miner..."
run_step 05-lotus-miner-initialize.sh

echo "Done!"
