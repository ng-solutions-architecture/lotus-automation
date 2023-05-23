#!/bin/bash

run_task() {
  TASK=$1

  chmod +x ./upgrade/$TASK
  ./upgrade/$TASK
}

press_key() {
  read -n 1 -s -r -p "Press any key to continue
"
}

echo "Checking Lotus version..."
run_task 01-lotus-daemon-upgrade.sh
press_key