#!/bin/bash

source ./variables

cleanup_install_dirs () {
    echo "removing temporary install dirs"
    rm -rf $INSTALL_DIR/lotus
    rm -rf $INSTALL_DIR/boost
}

cleanup_install_dirs