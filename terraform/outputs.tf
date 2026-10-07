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

output "ecr_repository_name" {
  description = "Name of the application ECR repository"
  value       = aws_ecr_repository.app.name
}

output "ecr_repository_url" {
  description = "URL of the application ECR repository"
  value       = aws_ecr_repository.app.repository_url
}

output "alb_dns_name" {
  description = "DNS name of the application load balancer"
  value       = aws_lb.app.dns_name
}

output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.main.name
}

output "ecs_service_name" {
  description = "Name of the ECS application service"
  value       = aws_ecs_service.app.name
}

output "github_deploy_role_arn" {
  description = "IAM role assumed by GitHub Actions through OIDC"
  value       = aws_iam_role.github_deploy.arn
}
