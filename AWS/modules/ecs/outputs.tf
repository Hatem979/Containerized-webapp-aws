
output "ecs_cluster_id" {
  description = "ID of the ECS Cluster."
  value       = aws_ecs_cluster.ecs_clu.id
}

output "ecs_cluster_name" {
  description = "Name of the ECS Cluster."
  value       = aws_ecs_cluster.ecs_clu.name
}

output "ecs_cluster_arn" {
  description = "ARN of the ECS Cluster."
  value       = aws_ecs_cluster.ecs_clu.arn
}

output "ecs_task_execution_role_arn" {
  description = "ARN of the ECS Task Execution Role."
  value       = aws_iam_role.ecs_task_execution.arn
}

output "ecs_task_role_arn" {
  description = "ARN of the ECS Task Role."
  value       = aws_iam_role.ecs_task.arn
}

output "alb_arn" {
  description = "ARN of the Application Load Balancer."
  value       = aws_lb.alb.arn
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer."
  value       = aws_lb.alb.dns_name
}

output "frontend_target_group_arn" {
  description = "ARN of the frontend target group."
  value       = aws_lb_target_group.frontend.arn
}
output "frontend_service_name" {
  value = aws_ecs_service.frontend.name
}

output "backend_service_name" {
  value = aws_ecs_service.backend.name
}

output "frontend_task_definition_arn" {
  value = aws_ecs_task_definition.frontend.arn
}

output "backend_task_definition_arn" {
  value = aws_ecs_task_definition.backend.arn
}
output "alb_arn_suffix" {
  description = "ARN suffix of the Application Load Balancer."
  value       = aws_lb.alb.arn_suffix
}

output "frontend_target_group_arn_suffix" {
  description = "ARN suffix of the frontend target group."
  value       = aws_lb_target_group.frontend.arn_suffix
}

output "backend_target_group_arn" {
  description = "ARN of the backend target group."
  value       = aws_lb_target_group.backend.arn
}

output "backend_target_group_arn_suffix" {
  description = "ARN suffix of the backend target group."
  value       = aws_lb_target_group.backend.arn_suffix
}