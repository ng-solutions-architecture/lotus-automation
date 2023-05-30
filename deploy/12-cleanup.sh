#!/bin/bash

source $HOME/.bashrc
source ./variables

cleanup_install_dirs () {
    echo "removing temporary install dirs"
    rm -rf $INSTALL_DIR/lotus
    rm -rf $INSTALL_DIR/boost
}

final_notes () {
    echo "You now have Lotus Daemon, Lotus Miner running.
    Start Boost and Booster-HTTP with:
    sudo systemctl start boostd 
    sudo systemctl start booster-http"
}

cleanup_install_dirs