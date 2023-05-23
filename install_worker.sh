#!/bin/bash

run_task() {
  TASK=$1

  chmod +x ./worker/$TASK
  ./worker/$TASK
}

echo "Installing prerequisites..."
run_task 01-prereqs.sh
read -n 1 -s -r -p "Press any key to continue"

echo "Installing Lotus..."
run_task 02-lotus-install.sh
read -n 1 -s -r -p "Press any key to continue"

echo "Running lotus-worker..."
run_task 03-run-lotus-worker.sh
read -n 1 -s -r -p "Press any key to continue"