#!/bin/bash

run_task() {
  TASK=$1

  chmod +x ./worker/$TASK
  ./worker/$TASK
}

press_key() {
  read -n 1 -s -r -p "Press any key to continue
"
}

echo "Installing prerequisites..."
run_task 01-prereqs.sh
press_key

echo "Installing Lotus..."
run_task 02-lotus-install.sh
press_key

echo "Running lotus-worker..."
run_task 03-run-lotus-worker.sh
press_key