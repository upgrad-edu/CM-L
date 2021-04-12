#!/bin/bash
set -eux
PROMETHEUS_VERSION="2.26.0"

sudo useradd --no-create-home prometheus && true
sudo mkdir -p /etc/prometheus
sudo mkdir -p /var/lib/prometheus

# Download and inatall
cd /tmp
curl -LO https://github.com/prometheus/prometheus/releases/download/v"$PROMETHEUS_VERSION"/prometheus-"$PROMETHEUS_VERSION".linux-amd64.tar.gz
tar xvf prometheus-"$PROMETHEUS_VERSION".linux-amd64.tar.gz

sudo cp prometheus-"$PROMETHEUS_VERSION".linux-amd64/prometheus /usr/local/bin
sudo cp prometheus-"$PROMETHEUS_VERSION".linux-amd64/promtool /usr/local/bin/
sudo cp -r prometheus-"$PROMETHEUS_VERSION".linux-amd64/consoles /etc/prometheus
sudo cp -r prometheus-"$PROMETHEUS_VERSION".linux-amd64/console_libraries /etc/prometheus

sudo cp prometheus-"$PROMETHEUS_VERSION".linux-amd64/promtool /usr/local/bin/
rm -rf prometheus-"$PROMETHEUS_VERSION".linux-amd64.tar.gz prometheus-"$PROMETHEUS_VERSION".linux-amd64


# prometheus systemd service
cat <<HERE > prometheus.service
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
    --config.file /etc/prometheus/prometheus.yml \
    --storage.tsdb.path /var/lib/prometheus/ \
    --web.console.templates=/etc/prometheus/consoles \
    --web.console.libraries=/etc/prometheus/console_libraries

[Install]
WantedBy=multi-user.target
HERE
cat << HERE > prometheus.yml
global:
  scrape_interval: 15s
  external_labels:
    monitor: 'prometheus'

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']
HERE


# copy prometheus conf file and change ownership of files
sudo cp prometheus.yml /etc/prometheus/prometheus.yml       
sudo chown -R prometheus:prometheus /etc/prometheus
sudo chown -R prometheus:prometheus /var/lib/prometheus




sudo cp /tmp/prometheus.service /etc/systemd/system/prometheus.service
sudo systemctl daemon-reload
sudo systemctl enable prometheus
sudo systemctl start prometheus