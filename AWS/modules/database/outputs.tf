output "database_endpoint" {
  description = "RDS endpoint address."
  value       = aws_db_instance.db_instance.endpoint
}

output "database_address" {
  description = "RDS hostname."
  value       = aws_db_instance.db_instance.address
}

output "database_port" {
  description = "RDS PostgreSQL port."
  value       = aws_db_instance.db_instance.port
}

output "database_name" {
  description = "Initial database name."
  value       = aws_db_instance.db_instance.db_name
}

output "database_identifier" {
  description = "RDS instance identifier."
  value       = aws_db_instance.db_instance.identifier
}
output "database_secret_arn" {
  description = "ARN of the RDS managed master password secret."
  value       = aws_db_instance.db_instance.master_user_secret[0].secret_arn
}