#!/bin/bash 
sudo apt -y update
sudo apt -y install ruby
sudo apt -y install wget
cd ~
wget https://aws-codedeploy-eu-west-3.s3.eu-west-3.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto
sudo service codedeploy-agent start
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -