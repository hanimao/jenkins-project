variable "azs" {
  type = list(string)
  default = ["eu-west-2a", "eu-west-2b"]
}

variable "security_group_id_ec2" {
  type = string
  description = "EC2 security group allowing traffic only from ALB"
}
