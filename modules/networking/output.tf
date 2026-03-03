output "vpc_id" {
    value = aws_vpc.jenkin.id
  
}

output "subnet_ids" {
    value = aws_subnet.public[*].id 
  
}

output "instance" {
  value = aws_instance.example.id 
}