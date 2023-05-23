#!/bin/bash

source ./variables

check_lotus_daemon_version () {
  INSTALLED_VERSION=$(lotus version | awk '{print $2}'  | cut -d"-" -f1 | grep -v lotus)
  if [[ ${INSTALLED_VERSION} == ${LOTUS_VERSION} ]]; then
    echo "The desired lotus version is already installed."
    else
        echo "Lotus daemon will be upgraded to ${LOTUS_VERSION}"
    fi
}

check_lotus_daemon_version