#!/bin/bash

# Update the package index
sudo apt-get update

# Install Docker
sudo apt-get install -y docker.io

# Start the Docker service
sudo systemctl start docker

# Enable Docker to start at boot time
sudo systemctl enable docker

# Create the first Docker network
sudo docker network create --subnet=10.0.1.0/24 my_network1

# Connect the Docker network to the first subnet
sudo docker network connect my_network1 app_subnet

# Create the second Docker network
sudo docker network create --subnet=10.0.2.0/24 my_network2

# Connect the Docker network to the second subnet
sudo docker network connect my_network2 app_subnet2
