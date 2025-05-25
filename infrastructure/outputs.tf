output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.healthcare_vpc.id
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public_subnet.id
}

output "instance_public_ips" {
  description = "Public IPs of the EC2 instances"
  value       = aws_instance.healthcare_servers[*].public_ip
}

output "instance_private_ips" {
  description = "Private IPs of the EC2 instances"
  value       = aws_instance.healthcare_servers[*].private_ip
}
