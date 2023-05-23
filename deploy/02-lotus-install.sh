#!/usr/bin/bash

bash -c 'source $HOME/.bashrc'
bash -c 'source ./variables'

clone_lotus() {
  git clone https://github.com/filecoin-project/lotus.git
  git checkout $LOTUS_VERSION
}

set_build_flags() {
  if [[ $(cat /proc/cpuinfo | grep -i -E 'sha256|sha_ni') ]]; then
    echo "SHA256 extensions found on CPU"
    export RUSTFLAGS="-C target-cpu=native -g"
    echo 'export RUSTFLAGS="-C target-cpu=native -g"' >> $HOME/.bashrc
    export FFI_BUILD_FROM_SOURCE=1
    echo 'export FFI_BUILD_FROM_SOURCE=1' >> $HOME/.bashrc
  else
    echo "No SHA256 extensions found on CPU"
  fi

  export FFI_USE_MULTICORE_SDR=0
  echo 'export FFI_USE_MULTICORE_SDR=0' >> $HOME/.bashrc

  export RUST_GPU_TOOLS_CUSTOM_GPU="${GPU_TYPE}:${CUDA_CORES}"
  echo 'RUST_GPU_TOOLS_CUSTOM_GPU="${GPU_TYPE}:${CUDA_CORES}"' >> $HOME/.bashrc
}

build_lotus() {
  DIR=$1
  cd ${DIR}

  clone_lotus
  cd ${DIR}/lotus
  set_build_flags

  if [ $USE_CALIBNET == "y" ];
    then make clean calibnet
    else 
      make clean all
  fi
}

install_lotus() {
   sudo make install
}


echo "Building lotus."
build_lotus ${INSTALL_DIR}

echo "Installing lotus."
install_lotus
