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
Environment=GOLOG_FILE=\"$LOG_DIR/lotus.log\"\n
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

StandardOutput=append:$LOG_DIR/lotus.log
StandardError=append:$LOG_DIR/lotus.log

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
Environment=GOLOG_FILE=\"$LOG_DIR/lotusminer.log\"\n
EnvironmentFile=/etc/lotus_env\n
User=$(whoami)\n
Group=$(whoami)\n
ExecStartPre=/bin/sleep 30\n
ExecStart=/usr/local/bin/lotus-miner run\n\n

StandardOutput=append:$LOG_DIR/lotusminer.log
StandardError=append:$LOG_DIR/lotusminer.log

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
ExecStart=/usr/local/bin/boostd run\n\n
StandardOutput=append:$LOG_DIR/boostd.log
StandardError=append:$LOG_DIR/boostd.log

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
ExecStart=/usr/local/bin/booster-http run --api-boost=$BOOST_API_INFO --api-fullnode=$FULLNODE_API_INFO --api-storage=$MINER_API_INFO --port=$HTTP_PORT\n\n

StandardOutput=append:$LOG_DIR/booster-http.log
StandardError=append:$LOG_DIR/booster-http.log

[Install]\n
WantedBy=multi-user.target\n
" | sudo tee /etc/systemd/system/booster-http.service > /dev/null

    sudo chmod 0644 /etc/systemd/system/booster-http.service
}

reload_systemd () {
    sudo systemctl daemon-reload
}

stop_services () {
    killall booster-http
    killall boostd
    lotus-miner stop
    sleep 5
    lotus daemon stop
    sleep 10
}
start_services () {
    sudo systemctl start lotus-daemon
    sudo systemctl start lotus-miner
    sleep 30
    sudo systemctl start boostd
    sleep 5
    sudo systemctl start booster-http
}

enable_services () {
    sudo systemctl enable lotus-daemon
    sudo systemctl enable lotus-miner
}

create_env_file
install_systemd_daemon
install_systemd_miner
install_systemd_boostd

if [ ${USE_BOOSTER_HTTP} == "y" ]; then
    install_systemd_booster
fi

reload_systemd
stop_services
start_services
enable_services