#!/bin/bash

source ./variables
source $HOME/.bashrc

create_env_file () {
    cat $HOME/.bashrc | grep export | awk '{split($0,a," "); print a[2]}' | sudo tee /etc/lotus_env > /dev/null
}

install_systemd_daemon () {
    printf "
[Unit]\n
Description=Lotus Daemon\n
After=network-online.target\n
Requires=network-online.target\n\n

[Service]\n
Environment=GOLOG_FILE=\"/var/log/lotus/lotus.log\"\n
EnvironmentFile=/etc/lotus_env\n
User=$(whoami)\n
Group=$(whoami)\n
ExecStart=/usr/local/bin/lotus daemon\n
Restart=always\n
RestartSec=10\n\n

MemoryAccounting=true\n
MemoryHigh=8G\n
MemoryMax=10G\n
LimitNOFILE=8192:10240\n\n

[Install]\n
WantedBy=multi-user.target\n
" | sudo tee /etc/systemd/system/lotus-daemon.service > /dev/null

    sudo chmod 0644 /etc/systemd/system/lotus-daemon.service
}

install_systemd_miner () {
    printf "
[Unit]\n
Description=Lotus Miner\n
After=lotus-daemon.service\n
Requires=network-online.target\n\n

[Service]\n
Environment=GOLOG_FILE=\"/var/log/lotus/lotusminer.log\"\n
EnvironmentFile=/etc/lotus_env\n
User=$(whoami)\n
Group=$(whoami)\n
ExecStart=/usr/local/bin/lotus-miner run\n\n

[Install]\n
WantedBy=multi-user.target\n
" | sudo tee /etc/systemd/system/lotus-miner.service > /dev/null

    sudo chmod 0644 /etc/systemd/system/lotus-miner.service
}

install_systemd_boostd () {
    printf "
[Unit]\n
Description=Boostd\n
After=lotus-miner.service\n
Requires=network-online.target\n\n

[Service]\n
EnvironmentFile=/etc/lotus_env\n
User=$(whoami)\n
Group=$(whoami)\n
ExecStart=/usr/local/bin/boostd --vv run > /var/log/lotus/boostd.log 2>&1\n\n

[Install]\n
WantedBy=multi-user.target\n
" | sudo tee /etc/systemd/system/boostd.service > /dev/null

    sudo chmod 0644 /etc/systemd/system/boostd.service
}

install_systemd_booster () {
    printf "
[Unit]\n
Description=Booster-HTTP\n
After=boostd.service\n
Requires=network-online.target\n\n

[Service]\n
EnvironmentFile=/etc/lotus_env\n
User=$(whoami)\n
Group=$(whoami)\n
ExecStart=/usr/local/bin/booster-http run --api-boost=$BOOST_API_INFO --api-fullnode=$FULLNODE_API_INFO --api-storage=$MINER_API_INFO > /var/log/lotus/booster-http.log 2>&1\n\n

[Install]\n
WantedBy=multi-user.target\n
" | sudo tee /etc/systemd/system/booster-http.service > /dev/null

    sudo chmod 0644 /etc/systemd/system/booster-http.service
}

reload_systemd () {
    sudo systemctl daemon-reload
}

create_env_file
install_systemd_daemon
install_systemd_miner
install_systemd_boostd

if [ ${USE_BOOSTER_HTTP} == "y" ]; then
    install_systemd_booster
fi

reload_systemd