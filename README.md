# Project Overview

This repository deploys a jenkins server on AWS on an AWS Amazon Linux EC2 instance launch template to deploy a dockerised application to an AWS ECS. The source code and ECS infra will be stored in a GitHub repository, and the pipeline will be triggered on any commit to the repository. The pipeline will build a Docker image, push it to the AWS Elastic Container Registry (ECR), and deploy it to ECS.

Jenkins is a self-contained, open source automation server. The goal was to automate the entire software delivery process from code integration to deployment ensuring fast, reliable, and scalable application delivery.


---

# Key Features 


This project demonstrates a **jenkin server** deployed on AWS using **Terraform**.  
 
1. **ALB**
   - Sits in the public subnet and listens for traffic on Port 80 (HTTP) and Port 443 (HTTPS). The ALB pings /login path to see if the instance is healthy. 
2. **Route53**
   - Serves as the domain name system (DNS) for the application. It routes traffic from your sub domain (**jenkins.hanimao.com**) to the load balance DNS name. 
3. **EC2 and Launch Template**
   - Defines the attributes of your server: the AMI, instance type, and the User Data script that installs Jenkins.
4. **User Data Script**
   - Automates the installation of Java and Jenkins when the instance starts 
5. **Security Groups & VPC**
   - Acts as a firewall that controlls the traffic allowed to reach one or more EC2 instances. To access Jenkins ensure Port 8080 (Jenkins) and Port 22 (SSH) is open on your instance. 
6. **Jenkins**
   - CI/CD pipeline automation

---

# Architecture  

![architecture diagram](<images/Jenkins.svg>)

---

# Workflow


### Pre-requisites 

- An AWS account
- An Amazon EC2 key pair
- Java (JDK) Installed
---

### Install Jenkins and Java

Use a user data script to automate the installation. Go to the userdata.sh folder.


### **Here's what it will look like**


![jenkins-server](images/jenkins-server.png)

Connect to http://<your_server_public_DNS> from your browser. You will be able to access Jenkins through its management interface:

- Connect to the EC2 instance and enter the password found in sudo cat **/var/lib/jenkins/secrets/initialAdminPassword**
- Then Click on Install suggested Pluggins
- Create First Admin User
- Once the set up is done, the jenkins Dashboard will appear.

![jenkins-server](images/dashboard.png)



### Docker Slave Configuration

Run the below command to Install Docker for an Amazon Linux 2023 Instance

`sudo yum install git -y`
 
 `sudo dnf update -y`

 `sudo dnf install docker -y`
 
 `sudo systemctl start docker`
 
 `sudo systemctl enable docker`
 
 ### Grant Jenkins user permission to docker deamon 

`sudo usermod -aG docker jenkins`

`sudo usermod -aG docker ec2-user`

`sudo su -s /bin/bash jenkins`

`sudo systemctl restart docker`

The docker agent config is now successful. 


### Install Docker Pipeline and ECR Plugin in Jenkins

- Log in to Jenkins.
- Go to Manage Jenkins > Manage Plugins.
- In the Available tab, search for "Docker Pipeline" and "ECR".
- Select the plugin and click the Install button.
- Restart Jenkins after the plugin is installed.

### Set Up Credentials 

- Go to Manage Jenkins > Manage Credentials.
- Add the following credentials: AWS Access Key ID and Secret Access Key.

### Jenkins Pipeline

This Jenkins pipeline automates the process of bulding a Docker image and pushes the image to AWS Elastic Container Registry (ECR).

- Create the Image Repository on ECR and Project Repository on GitHub with Webhook
- Create a jenkinsfile that shows your steps and jobs
- Define your jenkins Pipeline script from SCM
- Clean up the Image Repository on AWS ECR


![pipeline](images/pipeline.png)


## Troubleshoot

Build Executor Status - Make sure the agent is online and not offline.