#!/usr/bin/bash

source ./variables
source $HOME/.bashrc

clone_lotus() {
  git clone https://github.com/filecoin-project/lotus.git
  git checkout $LOTUS_VERSION
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

  if [ $USE_CALIBNET == "y" ];
    then bash -c make clean calibnet
    else 
      bash -c make clean all
  fi
}

install_lotus() {
   sudo make install
}


echo "Building lotus."
build_lotus ${INSTALL_DIR}

echo "Installing lotus."
install_lotus
