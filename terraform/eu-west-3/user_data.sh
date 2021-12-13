#!/bin/bash 
# Some dependencies
 sudo apt-get update
 sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install docker
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io 

# Install docker-compose actual version
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Clone development branch of our repository
git clone --branch development https://github.com/greykurotsuki/kittens_store.git
cd kittens_store/

# Run our application on port 1234 with database
sudo docker-compose up -d
sudo docker-compose run web bundle exec rake db:create db:migrate db:seed

sleep 172800
shutdown now
