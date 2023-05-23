#!/bin/bash

check_lotus_daemon_version () {
  installed_version=$(lotus version | awk '{print $2}'  | cut -d"-" -f1 | grep -v lotus)
  if [ ${installed_version} == ${LOTUS_VERSION} ]; then
    echo "The desired lotus version is already installed."
    else
        echo "Lotus daemon will be upgraded to ${LOTUS_VERSION}"
    fi
}

check_lotus_daemon_version