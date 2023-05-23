#!/bin/bash

run_task() {
  TASK=$1

  chmod +x ./worker/$TASK
  ./worker/$TASK
}

echo "Installing prerequisites..."
run_task 01-prereqs.sh
read -n 1 -s -r -p "Press any key to continue"

