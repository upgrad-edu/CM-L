#!/bin/bash
sudo rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
cat << HERE > elasticsearch.repo
[elasticsearch]
name=Elasticsearch repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=0
autorefresh=1
type=rpm-md
HERE
sudo cp elasticsearch.repo /etc/yum.repos.d/
sudo yum install -y --enablerepo=elasticsearch elasticsearch