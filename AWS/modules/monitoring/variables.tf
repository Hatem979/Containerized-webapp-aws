variable "aws_region" {
  description = "AWS region used by CloudWatch dashboard."
  type        = string
}

variable "project_name" {
  description = "Name of the project."
  type        = string
}

variable "ecs_cluster_name" {
  description = "Name of the ECS cluster."
  type        = string
}

variable "frontend_service_name" {
  description = "Name of the frontend ECS service."
  type        = string
}

variable "backend_service_name" {
  description = "Name of the backend ECS service."
  type        = string
}

variable "alb_arn_suffix" {
  description = "ARN suffix of the Application Load Balancer."
  type        = string
}

variable "frontend_target_group_arn_suffix" {
  description = "ARN suffix of the frontend target group."
  type        = string
}

variable "backend_target_group_arn_suffix" {
  description = "ARN suffix of the backend target group."
  type        = string
}

variable "database_identifier" {
  description = "RDS database instance identifier."
  type        = string
}

variable "alarm_email" {
  description = "Email address for CloudWatch alarm notifications."
  type        = string
  default     = ""
}

variable "tags" {
  description = "Common resource tags."
  type        = map(string)
  default     = {}
}