#!/bin/bash

set -x
set -e
shopt -s nullglob

run_task() {
  TASK=$1

  chmod +x ./upgrade/$TASK
  ./upgrade/$TASK
}

press_key() {
  read -n 1 -s -r -p "Press any key to continue
"
}

exit_code_check() {
  if [[ $exit_code -eq 1 ]]; then
    echo "Exiting upgrade script because the desired version is already installed."
    exit 1
  fi
}

echo "Checking Lotus version..."
run_task 01-lotus-daemon-upgrade.sh
exit_code=$?
exit_code_check

echo "Continuing upgrade..."
# more tasks to follow

echo "done!"