#!/usr/bin/env bash

set -x
set -e
shopt -s nullglob

run_task() {
  TASK=$1

  chmod +x ./deploy/$TASK
  bash -i ./deploy/$TASK
}

press_key() {
  read -n 1 -s -r -p "Press any key to continue
"
}

echo "Installing lotus prerequisites..."
run_task 01-lotus-prereqs.sh

echo "Installing lotus..."
run_task 02-lotus-install.sh

echo "Initializing lotus miner..."
run_task 05-lotus-miner-initialize.sh

echo "Configuring lotus miner..."
run_task 06-configure-miner.sh

echo "Configuring systemd..."
run_task 11-systemd-unit-files.sh

echo "Cleaning up..."
run_task 12-cleanup.sh

echo "Done!"
