#!/usr/bin/env bash

# This script is still in development stage.
# You need to set the FULLNODE_API_INFO and MINER_API_INFO in ~/.bashrc for it to work!

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

echo "Installing Boost..."
run_task 07-install-boost.sh

echo "Initializing Boost..."
run_task 08-initialize-boost.sh

echo "Configuring Boost..."
run_task 09-configure-boost.sh

echo "Configuring NGINX..."
run_task 10-configure-reverse-proxy.sh

echo "Configuring systemd..."
run_task 13-systemd-boost.sh

echo "Cleaning up..."
run_task 14-cleanup.sh

echo "Done!"
