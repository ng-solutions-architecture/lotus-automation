#!/bin/bash

set -x
set -e
shopt -s nullglob

source $HOME/.bashrc
source ./variables

install_software_deps() {
  echo "Installing all software dependencies."

  sudo apt update && sudo apt upgrade -y
  sudo apt install mesa-opencl-icd ocl-icd-opencl-dev gcc git bzr jq pkg-config curl clang build-essential hwloc libhwloc-dev git-all wget -y
}

install_rust() {
  echo "Installing rust."

  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  source "$HOME/.cargo/env"
}

install_go() {
  VERSION=$1

  echo "Installing GO, Version=${VERSION}"
  sudo bash -c "rm -rf /usr/local/go"
  wget -c https://golang.org/dl/go${VERSION}.linux-amd64.tar.gz -O - | sudo tar -xz -C /usr/local
  echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
  source ~/.bashrc
}

create_dirs() {
  INSTALL=$1
  LOGS=$2
  USER=$(whoami)

  mkdir -p ${INSTALL}
  sudo bash -c "mkdir -p ${LOGS}"
  sudo bash -c "chown $USER ${LOGS}"
}

set_limits() {
  sudo bash -c "echo \* soft nofile 256000 >> /etc/security/limits.conf"
  sudo bash -c "echo \* hard nofile 512000 >> /etc/security/limits.conf"
  sudo bash -c "echo fs.nr_open=128000000 >> /etc/sysctl.conf"
  sudo bash -c "echo fs.file-max=128000000 >> /etc/sysctl.conf"
  sudo sysctl -p
}

# Install prerequisites
create_dirs ${INSTALL_DIR} ${LOG_DIR}
install_software_deps
install_rust
install_go ${GO_VERSION}
set_limits