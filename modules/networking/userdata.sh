#!/bin/bash
sudo dnf update -y
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/rpm-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/rpm-stable/jenkins.io-2023.key
sudo dnf upgrade -y
sudo dnf install java-21-amazon-corretto -y
sudo dnf install jenkins -y
sudo systemctl enable jenkins
sudo systemctl start jenkins