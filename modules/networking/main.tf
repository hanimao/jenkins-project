resource "aws_vpc" "jenkin" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.jenkin.id
  count      = 2
  cidr_block = cidrsubnet("10.0.0.0/16", 8, count.index)
  availability_zone = element(var.azs, count.index)

  tags = {
    Name = "subnet-${count.index}"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.jenkin.id

  tags = {
    Name = "main"
  }
}


resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.jenkin.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "example"
  }
}

resource "aws_route_table_association" "a" {
  count          = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.rt.id
}


resource "aws_launch_template" "jenkins" {
  name = "jenkins-template"


  block_device_mappings {
    device_name = "/dev/sdf"

    ebs {
      volume_size = 20
    }
  }

  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }


  credit_specification {
    cpu_credits = "standard"
  }

  # disable_api_stop        = true
  # disable_api_termination = true

  ebs_optimized = true

 iam_instance_profile {
    name = aws_iam_instance_profile.profile.name

 }
  image_id = "ami-0ba0c1a358147d1a8"

  instance_initiated_shutdown_behavior = "terminate"

  instance_market_options {
    market_type = "spot"
  }

  instance_type = "t3.micro"


  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  monitoring {
    enabled = true
  }

  # network_interfaces {
  #   associate_public_ip_address = true
  #   # security_groups = [var.security_group_id_ec2]
  # }

  placement {
    availability_zone = "eu-west-2b"
  }



  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "jenkin-server"
    }
  }

  user_data = filebase64("${path.module}/userdata.sh")
}

resource "aws_instance" "example" {
 launch_template {
   id = aws_launch_template.jenkins.id 
   version = "$Latest"
 }
  instance_type = "t3.micro"
  depends_on = [aws_iam_instance_profile.profile]
   subnet_id = aws_subnet.public[0].id 
   vpc_security_group_ids = [var.security_group_id_ec2]
  associate_public_ip_address = true
   user_data_replace_on_change = true 
  lifecycle {
    # Optional: ensure the new one works before killing the old one
    create_before_destroy = true
  }

  tags = {
    Name = "testing"
  }
}
resource "aws_iam_instance_profile" "profile" {
  name = "profile"
  role = aws_iam_role.jenkins_role.name 

}

resource "aws_iam_role" "jenkins_role" {
  name = "jenkins-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}