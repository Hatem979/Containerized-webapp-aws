
output "vpc_id" {
  description = "ID of the VPC."
  value       = module.networking.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets."
  value       = module.networking.public_subnet_ids
}

output "private_app_subnet_ids" {
  description = "IDs of the private application subnets."
  value       = module.networking.private_app_subnet_ids
}

output "private_db_subnet_ids" {
  description = "IDs of the private database subnets."
  value       = module.networking.private_db_subnet_ids
}

output "nat_gateway_ids" {
  description = "IDs of the NAT Gateways."
  value       = module.networking.nat_gateway_ids
}

output "alb_security_group_id" {
  description = "ID of the ALB Security Group."
  value       = module.security.alb_security_group_id
}

output "frontend_security_group_id" {
  description = "ID of the Frontend ECS Security Group."
  value       = module.security.frontend_security_group_id
}

output "backend_security_group_id" {
  description = "ID of the Backend ECS Security Group."
  value       = module.security.backend_security_group_id
}

output "database_security_group_id" {
  description = "ID of the RDS Security Group."
  value       = module.security.database_security_group_id
}

output "ecr_repository_urls" {
  description = "URLs of the ECR repositories."
  value       = module.ecr.repository_urls
}

output "ecr_repository_arns" {
  description = "ARNs of the ECR repositories."
  value       = module.ecr.repository_arns
}

output "ecs_cluster_name" {
  description = "ECS cluster name."
  value       = module.ecs.ecs_cluster_name
}

output "ecs_cluster_arn" {
  description = "ECS cluster ARN."
  value       = module.ecs.ecs_cluster_arn
}

output "alb_dns_name" {
  description = "Application Load Balancer DNS name."
  value       = module.ecs.alb_dns_name
}

output "frontend_service_name" {
  description = "Frontend ECS service name."
  value       = module.ecs.frontend_service_name
}

output "backend_service_name" {
  description = "Backend ECS service name."
  value       = module.ecs.backend_service_name
}

output "database_endpoint" {
  description = "RDS PostgreSQL endpoint."
  value       = module.database.database_endpoint
}

output "database_port" {
  description = "RDS PostgreSQL port."
  value       = module.database.database_port
}

output "database_name" {
  description = "Application database name."
  value       = module.database.database_name
}