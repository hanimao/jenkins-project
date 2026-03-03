# Project Overview

This repository deploys a jenkins server on AWS using an EC2 instance launch template. Jenkins is a self-contained, open source automation server which can be used to automate all sorts of tasks related to building, testing, and delivering or deploying software.


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
   - Acts as a firewall that controlls the traffic allowed to reach one or more EC2 instances. Ensure Port 8080 (Jenkins) and Port 22 (SSH) is open

---

# Directory Structure

```text

jenkins/
├── .terraform/                
├──  modules/               
│       ├── alb/              
│       ├── networking/        
│       ├── route53/           
│       └── securitygroup/     
├── .gitignore                 
├── .pre-commit-config        
├── backend            
├── main.tf                    
├── provider.tf               
├── README.md                  
└── variables.tf               
   
```

---

# Architecture  

![architecture diagram](<images/jenkins.svg>)

---

# Workflow

### Health Checks 

| Route      | Description |
|------------|-------------|
| `/login`   | Checks to see if the instance is health |


### Pre-requisites 

- An AWS account
- An Amazon EC2 key pair. If you don’t have one, refer to Creating a key pair.
- An AWS IAM User with programmatic key access and permissions to launch EC2 instances









---

### **Here's what it will look like**


![jenkins-server](images/jenkins-server.png)

Connect to http://<your_server_public_DNS> from your browser. You will be able to access Jenkins through its management interface:

- SSH into the EC2 instance and enter the password found in **/var/lib/jenkins/secrets/initialAdminPassword**.
- Create First Admin User
- Select Manage Jenkins, and then select Manage Plugins.
- Select the Available tab,then enter Amazon EC2 plugin at the top right.
- Select the checkbox next to Amazon EC2 plugin, and then select install without restart.
- Once the installation is done, select Back to Dashboard.

![jenkins-server](images/dashboard.png)



