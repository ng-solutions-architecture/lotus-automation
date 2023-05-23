#!/usr/bin/bash

source $HOME/.bashrc
source ./variables

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
    echo "No SHA256 extensions found on CPU."
    echo "*** Do not use this server as a PC1 worker! ***"
  fi

  export FIL_PROOFS_USE_GPU_COLUMN_BUILDER=$FIL_PROOFS_USE_GPU_COLUMN_BUILDER
  echo "export FIL_PROOFS_USE_GPU_COLUMN_BUILDER=$FIL_PROOFS_USE_GPU_COLUMN_BUILDER" >> $HOME/.bashrc
  export FIL_PROOFS_USE_GPU_TREE_BUILDER=$FIL_PROOFS_USE_GPU_TREE_BUILDER
  echo "export FIL_PROOFS_USE_GPU_TREE_BUILDER=$FIL_PROOFS_USE_GPU_TREE_BUILDER" >> $HOME/.bashrc
  export FFI_USE_MULTICORE_SDR=$FFI_USE_MULTICORE_SDR
  echo "export FFI_USE_MULTICORE_SDR=$FFI_USE_MULTICORE_SDR" >> $HOME/.bashrc
  export RUST_GPU_TOOLS_CUSTOM_GPU="${GPU_TYPE}:${CUDA_CORES}"
  echo 'RUST_GPU_TOOLS_CUSTOM_GPU="${GPU_TYPE}:${CUDA_CORES}"' >> $HOME/.bashrc
  echo LOTUS_WORKER_NAME=$LOTUS_WORKER_NAME"
  export echo LOTUS_WORKER_NAME=$WORKER_NAME" >> $HOME/.bashrc
  echo "export FULLNODE_API_INFO=$FULLNODE_API_INFO" >> $HOME/.bashrc

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

cleanup_lotus() {
  rm -rf $INSTALL_DIR/lotus
}

echo "Building lotus."
build_lotus ${INSTALL_DIR}

echo "Installing lotus."
install_lotus

echo "Clean up."
cleanup_lotus