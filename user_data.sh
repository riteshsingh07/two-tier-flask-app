#!/bin/bash

# Fail on errors
set -e

# Update packages
apt-get update -y

# -----------------------------
# Install dependencies
# -----------------------------
apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    unzip

# -----------------------------
# Install Docker
# -----------------------------
# Add Docker's official GPG key
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

# Add Docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker packages
apt-get update -y
apt-get install -y docker.io

# Enable and start Docker
systemctl enable docker
systemctl start docker

# Add ubuntu user to docker group
usermod -aG docker ubuntu

# -----------------------------
# Install AWS CLI v2
# -----------------------------
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install 

# Install mysql
apt install mysql-server -y
systemctl start mysql

# Docker to ECR Login 
aws ecr get-login-password --region us-east-1| docker login --username AWS --password-stdin 705307574472.dkr.ecr.us-east-1.amazonaws.com

#Image URL stored in ECR
IMAGE_URI="705307574472.dkr.ecr.us-east-1.amazonaws.com/flask-app-ecr:latest"

#Pulling the Image from ECR
docker pull $IMAGE_URI

# EC2 to RDS Connectivity check
nc -zv flask-app-database.cavaa6wiclrh.us-east-1.rds.amazonaws.com 3306

# Creating DB in RDS
mysql -h flask-app-database.cavaa6wiclrh.us-east-1.rds.amazonaws.com \
    -u admin -padmin0406 \
    -e "CREATE DATABASE IF NOT EXISTS devops;"

# Running the container
docker run -d \
    --name flaskapp \
    -e MYSQL_HOST=flask-app-database.cavaa6wiclrh.us-east-1.rds.amazonaws.com \
    -e MYSQL_USER=admin \
    -e MYSQL_PASSWORD=admin0406 \
    -e MYSQL_DB=devops \
    -p 5000:5000 \
    $IMAGE_URI

echo "App is Live"