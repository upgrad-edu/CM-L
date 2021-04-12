#!/bin/bash
sudo rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
cat << HERE > kibana.repo
[kibana-7.x]
name=Kibana repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
HERE
sudo cp kibana.repo /etc/yum.repos.d/
sudo yum install -y kibana