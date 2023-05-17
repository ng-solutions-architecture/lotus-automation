#!/usr/bin/bash

#echo "Provide your wallet addresses"
#read -p "Provide your owner wallet address: " owner
#    if [ "$owner" != " " ]; then
#        read -p "Provide your worker wallet address: " worker
#		if [ "$worker" != " " ]; then
#			echo -e "Initializing lotus miner"
#		else
#			echo "Error"
#		fi
#	fi

source /opt/wallet_addresses

#Initialize a 32GiB SP
export LOTUS_SEALING_AGGREGATECOMMITS=false
export LOTUS_SEALING_BATCHPRECOMMITS=false
lotus-miner init --owner=$owner --worker=$worker --sector-size=32GiB

#Start the lotus-miner
nohup lotus-miner run > /opt/lotusminer.log 2>&1 &
echo "Starting lotus-miner"
sleep 45
lotus-miner info
echo "Miner running"
