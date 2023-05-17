#!/usr/bin/bash

source ./variables

clone_lotus() {
  git clone https://github.com/filecoin-project/lotus.git
  git checkout releases
}

set_build_flags() {
  export RUSTFLAGS="-C target-cpu=native -g"
  echo 'export RUSTFLAGS="-C target-cpu=native -g"' >> $HOME/.bashrc
  export FFI_BUILD_FROM_SOURCE=1
  echo export FFI_BUILD_FROM_SOURCE=1 >> $HOME/.bashrc
  export FFI_USE_MULTICORE_SDR=0
}

build_lotus() {
  DIR=$1
  cd ${DIR}

  clone_lotus
  cd ${DIR}/lotus
  set_build_flags

  make clean all
}

install_lotus() {
  sudo make install
}


build_lotus ${INSTALL_DIR}
install_lotus
