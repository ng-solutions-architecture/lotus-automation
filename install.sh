#!/usr/bin/env bash

run_task() {
  TASK=$1

  chmod +x ./tasks/$TASK
  ./tasks/$TASK
}

echo "Installing lotus prerequisites..."
run_task 01-lotus-prereqs.sh
read -n 1 -s -r -p "Press any key to continue"

echo "Installing lotus..."
run_task 02-lotus-install.sh
read -n 1 -s -r -p "Press any key to continue"

echo "Importing lotus snapshot..."
run_task 03-lotus-import-snapshot.sh
read -n 1 -s -r -p "Press any key to continue"

echo "Initializing lotus..."
run_task 04-lotus-initialize.sh
read -n 1 -s -r -p "Press any key to continue"

echo "Initializing lotus miner..."
run_task 05-lotus-miner-initialize.sh
read -n 1 -s -r -p "Press any key to continue"

echo "Configuring lotus miner..."
run_task 06-configure-miner.sh
read -n 1 -s -r -p "Press any key to continue"

echo "Installing Boost..."
run_task 07-install-boost.sh
read -n 1 -s -r -p "Press any key to continue"

echo "Initializing Boost..."
run_task 08-initialize-boost.sh
read -n 1 -s -r -p "Press any key to continue"

echo "Configuring Boost..."
run_task 09-configure-boost.sh
read -n 1 -s -r -p "Press any key to continue"

echo "Configuring NGINX..."
run_task 10-configure-reverse-proxy.sh
read -n 1 -s -r -p "Press any key to continue"

echo "Done!"
