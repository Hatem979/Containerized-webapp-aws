
variable "project_name" {
  description = "Project name prefix for ECS resources."
  type        = string
}

variable "tags" {
  description = "Common tags for ECS resources."
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "VPC ID where ECS and ALB will be deployed."
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs for the ALB."
  type        = list(string)
}

variable "private_app_subnet_ids" {
  description = "Private subnet IDs for ECS tasks."
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "Security Group ID for the ALB."
  type        = string
}

variable "frontend_security_group_id" {
  description = "Security Group ID for frontend ECS tasks."
  type        = string
}

variable "backend_security_group_id" {
  description = "Security Group ID for backend ECS tasks."
  type        = string
}

variable "frontend_image" {
  description = "ECR image URI for the frontend."
  type        = string
}

variable "backend_image" {
  description = "ECR image URI for the backend."
  type        = string
}

variable "frontend_port" {
  description = "Port exposed by the frontend container."
  type        = number
  default     = 80
}

variable "backend_port" {
  description = "Port exposed by the backend container."
  type        = number
  default     = 5000
}

variable "frontend_cpu" {
  description = "CPU units for frontend task."
  type        = number
  default     = 256
}

variable "frontend_memory" {
  description = "Memory in MiB for frontend task."
  type        = number
  default     = 512
}

variable "backend_cpu" {
  description = "CPU units for backend task."
  type        = number
  default     = 256
}

variable "backend_memory" {
  description = "Memory in MiB for backend task."
  type        = number
  default     = 512
}

variable "desired_count" {
  description = "Desired number of ECS tasks per service."
  type        = number
  default     = 1
}
variable "database_secret_arn" {
  description = "ARN of the RDS managed master password secret."
  type        = string
}
variable "database_host" {
  description = "RDS database hostname."
  type        = string
}

variable "database_port" {
  description = "RDS database port."
  type        = number
}

variable "database_name" {
  description = "Application database name."
  type        = string
}