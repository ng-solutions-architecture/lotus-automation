#!/bin/bash

source $HOME/.bashrc
source ./variables

start_lotus_worker () {
    lotus-worker run "${worker_tasks[@]}" --name="${LOTUS_WORKER_NAME}" > ${LOG_DIR}/lotus-worker.log 2>&1 &
}

start_lotus_worker