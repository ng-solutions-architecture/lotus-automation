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

echo "Importing lotus snapshot..."
run_task 03-lotus-import-snapshot.sh

echo "Initializing lotus..."
run_task 04-lotus-initialize.sh

echo "Configuring systemd..."
run_task 11-systemd-lotus.sh

echo "Cleaning up..."
run_task 14-cleanup.sh

echo "Done!"
