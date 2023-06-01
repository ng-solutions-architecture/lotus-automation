#!/bin/bash

set -x
set -e
shopt -s nullglob

source ./variables

INSTALLED_VERSION=v$(lotus version | awk '{print $2}'  | cut -d"-" -f1 | grep -v lotus)
if [[ "${INSTALLED_VERSION}" == "${LOTUS_VERSION}" ]]; then
  echo "The desired lotus version ${LOTUS_VERSION} is already installed."
  exit 1
  else
      echo "Lotus will be upgraded to ${LOTUS_VERSION}"
  fi
exit_code=$?

if [ $exit_code -eq 1 ]; then
  echo "Exiting upgrade script because the desired version is already installed."
  exit 1
fi