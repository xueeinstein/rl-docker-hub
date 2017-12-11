#!/bin/bash
# Currently, only for Ubuntu 16.04
sudo apt-get remove docker docker-engine docker.io -y
sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo apt-key fingerprint 0EBFCD88

ARCH=`dpkg --print-architecture`
sudo add-apt-repository \
     "deb [arch=$ARCH] https://download.docker.com/linux/ubuntu \
     $(lsb_release -cs) stable"

sudo apt-get update
sudo apt-get install docker-ce
sudo docker run hello-world
