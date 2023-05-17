#!/usr/bin/bash

INSTALL_DIR="/opt"

build_lotus() {
  DIR=$1

  cd $DIR
  git clone https://github.com/filecoin-project/lotus.git
  git checkout releases

  export RUSTFLAGS="-C target-cpu=native -g"
  export FFI_BUILD_FROM_SOURCE=1
  export FFI_USE_MULTICORE_SDR=0
  make clean all
}

install_lotus() {
  sudo make install
}

build_lotus $INSTALL_DIR
install_lotus
