variable "security_group_id_lb" {
  type = string
  description = "ALB security group allowing HTTP and HTTPS"
}

variable "vpc_id" {
  type = string
  description = "ID of the VPC"
}

variable "subnet_ids" {
  type = list(string)
  description = "ID of the public subnets"
}

variable "instance" {
  type = string
  description = "Target Group ID"
}