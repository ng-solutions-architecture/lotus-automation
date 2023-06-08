# lotus-automation

## What this automation is planning to do

Automation of lotus-daemon, lotus-miner and boost installation and configuration.
This is meant to be a single server deployment for starting storage providers using sealing-as-a-service.

The various steps are split out into separate scripts. This allows steps to be rerun upon failure and for additional scripts to be added.

This installer is built for Ubuntu Server LTS (minimal version 20.04).

## High level overview of the tasks

- Installation of the software prerequisites for Lotus Daemon, Lotus Miner and Boost.
- Automation of installation of lotus-daemon, lotus-miner and boost.
- Import latest chain snapshot
- Initialize lotus-daemon and create wallets
- Initialize lotus-miner
- Install and configure Boostd
- Install and configure Booster-HTTP, exposed via Nginx reverse proxy

## Assumptions

- You have read the storage provider documentation: https://docs.filecoin.io/storage-provider
- Everything runs under a single user. Run the installer script as the non-root user under which you want Lotus to run. This user needs `sudo` permissions.
- Lotus-daemon, lotus-miner, boostd and booster-http are installed on a single machine.
- Use Sealing-as-a-Service or add a sealing worker to your setup.

## Prerequisites

- You will need access to some FIL (unless you build for calibration testnet).
- Have Ubuntu Server installed (headless) with NVIDIA-drivers and CUDA if you have an NVIDIA GPU. You will need a GPU for storage proving! Verify your drivers with the command `nvidia-smi`.
- You will need 1 fixed internal IP for the services, 1 external IP and 2 external ports for public reachability.

## Getting started

```shell
    git clone https://github.com/ng-solutions-architecture/lotus-automation.git
    cd lotus-automation
    git checkout latest
```
- edit the `variables` file to match your environment
- make installer script executable
```shell 
    chmod +x ./install.sh
```
- run the installer script
```shell
    ./install.sh
```

## Cleanup script

NOTE: use with caution!
In order to clean up an entire (or failed) installation, run:

```shell
    chmod +x ./cleanup.sh
    ./cleanup.sh
```

## User feedback

If you have code suggestions, please use Pull Requests.
If you have general inquiries or feedback, please write an issue on this GitHub repo.

## Contributors
- Bob Dubois: @bobdubois
- Anjor Kanekar: @anjor
- Angelo Schalley: @Angelo-gh3990
- Orjan Roren: @rjan90
