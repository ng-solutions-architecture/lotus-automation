#!/bin/bash

source ./variables
source $HOME/.bashrc

set_extra_boost_vars() {
  export APISEALER=${MINER_API_INFO}
  export APISECTORINDEX=${MINER_API_INFO}
}

initialize_boost() {
    boostd --vv init \
       --api-sealer=$APISEALER \
       --api-sector-index=$APISECTORINDEX \
       --wallet-publish-storage-deals=$PUBLISH_STORAGE_DEALS_WALLET \
       --wallet-deal-collateral=$COLLAT_WALLET \
       --max-staging-deals-bytes=50000000000   
}

run_boost() {
    DIR=$1
    boostd --vv run > ${DIR}/boost.log 2>&1 &
}

set_extra_boost_vars
initialize_boost
run_boost ${LOG_DIR}