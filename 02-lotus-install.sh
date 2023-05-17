#!/usr/bin/bash

#Build and install Lotus
cd /opt
git clone https://github.com/filecoin-project/lotus.git
git checkout releases
export RUSTFLAGS="-C target-cpu=native -g"
echo 'export RUSTFLAGS="-C target-cpu=native -g"' >> $HOME/.bashrc
export FFI_BUILD_FROM_SOURCE=1
echo export FFI_BUILD_FROM_SOURCE=1 >> $HOME/.bashrc
export FFI_USE_MULTICORE_SDR=0
make clean all
sudo make install
