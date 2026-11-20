
variable "project_name" {
  description = "Project name prefix for security resources."
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where security groups will be created."
  type        = string
}

variable "tags" {
  description = "Common tags for security resources."
  type        = map(string)
  default     = {}
}

variable "frontend_port" {
  description = "Port used by the frontend container."
  type        = number
  default     = 80
  validation {
    condition     = var.frontend_port > 0 && var.frontend_port < 65535
    error_message = "Port must be between 1 and 65535."
  }
}

variable "backend_port" {
  description = "Port used by the Flask backend."
  type        = number
  default     = 5000
  validation {
    condition     = var.backend_port > 0 && var.backend_port < 65535
    error_message = "Port must be between 1 and 65535."
  }
}

variable "database_port" {
  description = "Port used by PostgreSQL."
  type        = number
  default     = 5432
  validation {
    condition     = var.database_port > 0 && var.database_port < 65535
    error_message = "Port must be between 1 and 65535."
  }
}
