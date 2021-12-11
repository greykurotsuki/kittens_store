#!/bin/bash 
sudo apt update -y && sudo apt install -y curl gpg2 software-properties-common
sudo apt-add-repository -y ppa:rael-gc/rvm
sudo apt-get update -y
sudo apt-get install rvm -y