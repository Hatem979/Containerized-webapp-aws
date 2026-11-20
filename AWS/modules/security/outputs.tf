
output "alb_security_group_id" {
  description = "Security Group ID for the ALB."
  value       = aws_security_group.alb.id
}

output "frontend_security_group_id" {
  description = "Security Group ID for frontend ECS tasks."
  value       = aws_security_group.frontend.id
}

output "backend_security_group_id" {
  description = "Security Group ID for backend ECS tasks."
  value       = aws_security_group.backend.id
}

output "database_security_group_id" {
  description = "Security Group ID for RDS PostgreSQL."
  value       = aws_security_group.database.id
}
