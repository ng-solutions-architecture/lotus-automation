#!/usr/bin/env bash

source ./variables

create_wallet() {
  DIR=$1
  
  lotus sync wait

  echo "Creating owner and worker wallets"
  owner=$(lotus wallet new bls)
  worker=$(lotus wallet new bls)
  
  echo "owner=$owner" > ${DIR}/wallet_addresses
  echo "worker=$worker" >> ${DIR}/wallet_addresses

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
          echo "The FIL has arrived. Continuing.."
          prev_balance=${current_balance}
          break
      else
          echo "The FIL has not arrived yet. Waiting.."
      fi
      sleep 1m
  done
}

create_api_token() {
    TOKEN=$(lotus auth api-info --perm admin)
    echo "export ${TOKEN}" >> $HOME/.bashrc
    export ${TOKEN}
}

create_daemon_config() {
    PORT=$2
    IP=$1
    PUB_IP=$3
    P2P_PORT=$4
    
    mv $LOTUS_DIR/config.toml $LOTUS_DIR/config.toml.backup

    printf "
[API]\n
  ListenAddress = \"/ip4/0.0.0.0/tcp/$PORT/http\"\n
  RemoteListenAddress = \"$IP:$PORT\"\n\n

[Libp2p]\n
  ListenAddresses = [\"/ip4/0.0.0.0/tcp/${P2P_PORT}\"]\n
  AnnounceAddresses = [\"/ip4/${PUB_IP}/tcp/${P2P_PORT}\"]\n
  NoAnnounceAddresses = []\n
  DisableNatPortMap = false\n
  ConnMgrLow = 100\n
  ConnMgrHigh = 500\n
  ConnMgrGrace = \"30s\"\n\n

[Chainstore]\n
  # type: bool\n
  # env var: LOTUS_CHAINSTORE_ENABLESPLITSTORE\n
  EnableSplitstore = true\n
  " > $LOTUS_DIR/config.toml
}

lotus_daemon_restart() {
  LOG=$1
  lotus daemon stop
  sleep 15
  nohup lotus daemon >> ${LOG}/lotus.log 2>&1 &
  sleep 15
  lotus sync wait
}

check_libp2p() {
  IP=$1
  PORT=$2

  while true; do   
      if [[ $(lotus net reachability | grep "Public") ]]; then
          echo "Lotus daemon is visible on the public network. Continuing..."
          break
      else
          echo "Lotus daemon is not visible via port ${PORT} on ${IP}. Check your firewall settings.\n
          The installation will continue once your lotus daemon is reachable."
      fi
      sleep 1m
  done
}

create_wallet ${INSTALL_DIR}
transfer_funds
wait_for_funds
create_api_token ${DAEMON_IP} ${DAEMON_PORT} ${INSTALL_DIR}
create_daemon_config ${DAEMON_IP} ${DAEMON_PORT} ${PUBLIC_IP} ${P2P_PORT}
lotus_daemon_restart ${LOG_DIR}
check_libp2p ${PUBLIC_IP} ${P2P_PORT}
