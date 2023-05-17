#!/usr/bin/env bash

source ./variables.sh

create_wallet() {
  DIR=$1

  echo "Creating owner and worker wallets"
  owner=$(lotus wallet new bls)
  worker=$(lotus wallet new bls)
  
  echo "owner=$owner" > ${DIR}/wallet_addresses.txt
  echo "worker=$worker" >> ${DIR}/wallet_addresses.txt

}

transfer_funds() {
  echo "Transfer funds to $owner and $worker "
  while true; do
      read -p "Have you transfered funds for the given wallet? (y/n) " choice
      if [ "$choice" == "y" ]; then
          echo "Waiting for funds to arrive. It might take a couple of minutes..."
          break
      elif [ "$choice" == "n" ]; then
          echo -e "Please transfer funds for the given wallet to continue. \nIf you wish stop the installation, press ctrl-c"
      else
          echo "Invalid input"
      fi
  done
}

wait_for_funds() {
  prev_balance=$(lotus wallet list | awk '{print $2}')
  while true; do
      current_balance=$(lotus wallet list | awk '{print $2}')
      if [ "${current_balance}" != "${prev_balance}" ]; then
          echo "The test FIL has arrived. Continuing.."
          prev_balance=${current_balance}
          break
      else
          echo "The FIL has not arrived yet. Waiting.."
      fi
      sleep 1m
  done
}

create_wallet ${INSTALL_DIR}
transfer_funds
wait_for_funds
