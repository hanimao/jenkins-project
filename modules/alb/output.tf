output "lb_arn" {
    description = "ARN of a load balancer"
    value = aws_lb.test.arn 
}

output "target_group" {
    value = aws_lb_target_group.test
  
}

output "lb_name" {
    value = aws_lb.test.dns_name 
  
}

output "lb_hosted_zone" {
    value = aws_lb.test.zone_id
  
}