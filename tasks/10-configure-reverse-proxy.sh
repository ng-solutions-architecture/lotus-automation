#!/bin/bash

source ./variables
source $HOME/.bashrc

install_nginx () {
    sudo apt update
    sudo apt install openssl nginx -y
}

configure_reverse_proxy () {
    sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/ipfs.key -out /etc/ssl/certs/ipfs.crt

    sudo printf "
# ipfs gateway config\n
server \{\n
        listen 8443 ssl;\n
        listen [::]:8443 ssl;\n\n

        server_name ${BOOSTER_HTTP_DNS};\n\n
        
        ssl_certificate /etc/ssl/certs/ipfs.crt;\n
        ssl_certificate_key /etc/ssl/private/ipfs.key;\n
        ssl_protocols TLSv1.2;\n
        ssl_prefer_server_ciphers on;\n
        ssl_ciphers ECDHE-RSA-AES256-GCM-SHA512:DHE-RSA-AES256-GCM-SHA512:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-SHA384;\n\n

        location /ipfs/ \{\n
                proxy_pass http://127.0.0.1:7777;\n
        \}\n
\}\n
    " > /etc/nginx/sites-enabled/ipfs
}

start_nginx () {
    sudo systemctl stop apache2
    sudo sysmtectl disable apache2
    sudo systemctl start nginx
    sudo systemctl enable nginx
}

set_booster_http_retrievals () {
      sed -i -e "/HTTPRetrievalMultiaddr =/ s/= .*/= \"\/dns\/${BOOSTER_HTTP_DNS}\/tcp\/${PROXY_PORT}\/https\"/" ${BOOST_DIR}/config.toml  
}

if [ ${USE_BOOSTER_HTTP} == "y" ]; then
    install_nginx
    configure_reverse_proxy
    start_nginx
fi