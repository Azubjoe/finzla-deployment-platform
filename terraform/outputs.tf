output "vpc_id" {
  description = "ID of the Finzla VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs of the private application subnets"
  value       = aws_subnet.private[*].id
}

output "alb_security_group_id" {
  description = "Security group used by the application load balancer"
  value       = aws_security_group.alb.id
}

output "ecs_security_group_id" {
  description = "Security group used by ECS application tasks"
  value       = aws_security_group.ecs.id
}

output "nat_gateway_id" {
  description = "NAT Gateway used by private subnets"
  value       = aws_nat_gateway.main.id
}