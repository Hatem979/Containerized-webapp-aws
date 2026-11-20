variable "project_name" {
  description = "Name of the project."
  type        = string
}

variable "vpc_id" {
  description = "ID of the project VPC."
  type        = string
}

variable "private_db_subnet_ids" {
  description = "Private database subnet IDs."
  type        = list(string)
}

variable "database_security_group_id" {
  description = "Security group ID for RDS."
  type        = string
}

variable "database_name" {
  description = "Initial database name."
  type        = string
  default     = "appdb"
}

variable "database_username" {
  description = "Master username for PostgreSQL."
  type        = string
  default     = "dbadmin"
}

variable "engine_version" {
  description = "PostgreSQL engine version. Null uses the AWS default."
  type        = string
  default     = null
}

variable "instance_class" {
  description = "RDS instance class."
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Initial storage size in GiB."
  type        = number
  default     = 20
}

variable "multi_az" {
  description = "Whether to deploy RDS in Multi-AZ."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags for database resources."
  type        = map(string)
  default     = {}
}