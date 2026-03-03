output "security_group_id_lb" {
    value = aws_security_group.alb.id 
  
}

output "security_group_id_ec2" {
    value = aws_security_group.ec2.id 
  
}

