
output "dashboard_name" {
  description = "Name of the CloudWatch monitoring dashboard."
  value       = aws_cloudwatch_dashboard.main.dashboard_name
}

output "sns_topic_arn" {
  description = "ARN of the SNS monitoring alerts topic."
  value       = aws_sns_topic.monitoring_alerts.arn
}
