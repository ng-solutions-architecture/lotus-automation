#!/bin/bash

check_lotus_daemon_version () {
  installed_version=$(lotus version | awk \'{print $2}\'  | cut -d"-" -f1 | grep -v lotus)
  echo $installed_version
}

check_lotus_daemon_version