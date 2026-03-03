variable "security_group_id_lb" {
  type = string
  description = "alb sg"
}

variable "vpc_id" {
  type = string
  description = "ID of the VPC"
}

variable "subnet_ids" {
  type = list(string)
  description = "ID of the subnets"
}

variable "instance" {
  type = string
}