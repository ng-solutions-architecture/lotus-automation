#!/usr/bin/env bash

run_task() {
  TASK=$1

  chmod +x ./tasks/$TASK
  ./tasks/$TASK
}

echo "Installing lotus prerequisites..."
run_task 01-lotus-prereqs.sh

echo "Installing lotus..."
run_task 02-lotus-install.sh

echo "Importing lotus snapshot..."
run_task 03-lotus-import-snapshot.sh

echo "Initializing lotus..."
run_task 04-lotus-initialize.sh

echo "Initializing lotus miner..."
run_task 05-lotus-miner-initialize.sh

echo "Done!"
