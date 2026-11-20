variable "aws_region" {
  description = "AWS Region for the deployment"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name prefix for all resources."
  type        = string
  default     = "aws-containerized-app"
}
variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability Zones for the deployment."
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_app_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "private_db_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.21.0/24", "10.0.22.0/24"]
}

variable "enable_nat_gateway" {
  description = "Whether to create NAT Gateways."
  type        = bool
  default     = true
}

variable "common_tags" {
  description = "Common tags for all infrastructure resources."
  type        = map(string)

  default = {
    Project     = "containerized-webapp-aws"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

variable "database_name" {
  type    = string
  default = "appdb"
}

variable "database_username" {
  type    = string
  default = "dbadmin"
}

variable "database_instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "database_allocated_storage" {
  type    = number
  default = 20
}

variable "database_multi_az" {
  type    = bool
  default = false
}

variable "alarm_email" {
  description = "Email address for CloudWatch alarm notifications."
  type        = string
  default     = ""
}