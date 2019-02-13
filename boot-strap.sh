#!/usr/bin/env bash
!/bin/sh
yum update -y
yum install java -y
yum install docker -y
service docker start
yum install wget -y
groupadd docker
usermod -aG docker ec2-user
docker run -d -p 80:80 -p 443:443 vynu/go-web-app:v1