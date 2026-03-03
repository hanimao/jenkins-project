resource "aws_security_group" "alb" {
  name        = "ALB-SG"
  description = "SG for the application load balancer. Allows HTTP & HTTPS from the internet"
  vpc_id      = var.vpc_id
  tags = {
    Name = "example"
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}


resource "aws_vpc_security_group_ingress_rule" "alb_2" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  ip_protocol = "tcp"
  to_port     = 443
}



resource "aws_vpc_security_group_egress_rule" "alb" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port   = 8080
  ip_protocol = "tcp"
  to_port     = 8080
}


resource "aws_security_group" "ec2" {
  name        = "ECS-SG"
  description = "The SG for the EC2 instance. Allows traffic from the ALB only."
  vpc_id      = var.vpc_id
  tags = {
    Name = "example"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ec2" {
  security_group_id = aws_security_group.ec2.id
  referenced_security_group_id = aws_security_group.alb.id 
  
  from_port   = 8080
  ip_protocol = "tcp"
  to_port     = 8080
}

resource "aws_vpc_security_group_ingress_rule" "ec2_2" {
  security_group_id = aws_security_group.ec2.id
  
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
  cidr_ipv4 = "0.0.0.0/0"
}


resource "aws_vpc_security_group_egress_rule" "ec2" {
  security_group_id = aws_security_group.ec2.id
  ip_protocol       = -1
  cidr_ipv4         = "0.0.0.0/0"
}