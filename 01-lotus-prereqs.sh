#!/usr/bin/bash

GO_VERSION=1.19

install_software_deps() {
  sudo apt update
  sudo apt install mesa-opencl-icd ocl-icd-opencl-dev gcc git bzr jq pkg-config curl clang build-essential hwloc libhwloc-dev git-all wget aria2 -y && sudo apt upgrade -y
}

install_rust() {
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  source "$HOME/.cargo/env"
}

install_go() {
  VERSION=$1

  wget -c https://golang.org/dl/go${VERSION}.linux-amd64.tar.gz -O - | sudo tar -xz -C /usr/local
  export PATH=$PATH:/usr/local/go/bin
  echo 'PATH' >> ~/.bashrc && source ~/.bashrc
}


# Install prerequisites
install_software_deps
install_rust
install_go ${GO_VERSION}
