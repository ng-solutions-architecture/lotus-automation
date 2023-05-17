#!/usr/bin/bash

#Build and install Lotus
cd /opt
git clone https://github.com/filecoin-project/lotus.git
dir=/opt/lotus
git checkout releases
export RUSTFLAGS="-C target-cpu=native -g"
export FFI_BUILD_FROM_SOURCE=1
export FFI_USE_MULTICORE_SDR=0
make clean all
sudo make install
