variable "project_name" {
  description = "project name prefix for all  ECR respositories"
  type        = string
}
variable "repository_names" {
  description = "list of ECR repository names to create"
  type        = set(string)
  default    = [
    "frontend",
    "backend"   
  ]
}
variable "tags" {
  description = "common tags for  ECR resources"
  type        = map(string)
  default     = {}
}