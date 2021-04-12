#!/bin/bash
set -eufx

#sudo yum install -y curl

NODE_EXPORTER_VERSION="1.1.2"
sudo useradd -rs /bin/false node_exporter
cd /tmp
curl -LO https://github.com/prometheus/node_exporter/releases/download/v"$NODE_EXPORTER_VERSION"/node_exporter-"$NODE_EXPORTER_VERSION".linux-amd64.tar.gz
tar -xvf node_exporter-"$NODE_EXPORTER_VERSION".linux-amd64.tar.gz
sudo mv node_exporter-"$NODE_EXPORTER_VERSION".linux-amd64/node_exporter /usr/local/bin/
sudo cat << HERE > node_exporter.service
[Unit]
Description=Node Exporter
After=network.target
 
[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter
 
[Install]
WantedBy=multi-user.target
HERE
sudo mv /tmp/node_exporter.service /etc/systemd/system/node_exporter.service
sudo systemctl daemon-reload
sudo systemctl start node_exporter
sudo systemctl enable node_exporter