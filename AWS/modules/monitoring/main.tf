
# SNS Topic for CloudWatch Alarm Notifications
resource "aws_sns_topic" "monitoring_alerts" {
  name = "${var.project_name}-monitoring-alerts"

  tags = var.tags
}

# Email Subscription
resource "aws_sns_topic_subscription" "email" {
  count = var.alarm_email != "" ? 1 : 0

  topic_arn = aws_sns_topic.monitoring_alerts.arn
  protocol  = "email"
  endpoint  = var.alarm_email
}

# CloudWatch Dashboard
resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.project_name}-monitoring"

  dashboard_body = jsonencode({
    widgets = [

      # ECS CPU Utilization
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          title  = "ECS CPU Utilization"
          region = var.aws_region
          period = 300
          stat   = "Average"

          metrics = [
            [
              "AWS/ECS",
              "CPUUtilization",
              "ClusterName",
              var.ecs_cluster_name,
              "ServiceName",
              var.frontend_service_name
            ],
            [
              "AWS/ECS",
              "CPUUtilization",
              "ClusterName",
              var.ecs_cluster_name,
              "ServiceName",
              var.backend_service_name
            ]
          ]
        }
      },

      # ECS Memory Utilization
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6

        properties = {
          title  = "ECS Memory Utilization"
          region = var.aws_region
          period = 300
          stat   = "Average"

          metrics = [
            [
              "AWS/ECS",
              "MemoryUtilization",
              "ClusterName",
              var.ecs_cluster_name,
              "ServiceName",
              var.frontend_service_name
            ],
            [
              "AWS/ECS",
              "MemoryUtilization",
              "ClusterName",
              var.ecs_cluster_name,
              "ServiceName",
              var.backend_service_name
            ]
          ]
        }
      },

      # ALB Request Count
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 12
        height = 6

        properties = {
          title  = "ALB Request Count"
          region = var.aws_region
          period = 300
          stat   = "Sum"

          metrics = [
            [
              "AWS/ApplicationELB",
              "RequestCount",
              "LoadBalancer",
              var.alb_arn_suffix
            ]
          ]
        }
      },

      # ALB HTTP 5XX Errors
      {
        type   = "metric"
        x      = 12
        y      = 6
        width  = 12
        height = 6

        properties = {
          title  = "ALB HTTP 5XX Errors"
          region = var.aws_region
          period = 300
          stat   = "Sum"

          metrics = [
            [
              "AWS/ApplicationELB",
              "HTTPCode_ELB_5XX_Count",
              "LoadBalancer",
              var.alb_arn_suffix
            ],
            [
              "AWS/ApplicationELB",
              "HTTPCode_Target_5XX_Count",
              "LoadBalancer",
              var.alb_arn_suffix,
              "TargetGroup",
              var.frontend_target_group_arn_suffix
            ],
            [
              "AWS/ApplicationELB",
              "HTTPCode_Target_5XX_Count",
              "LoadBalancer",
              var.alb_arn_suffix,
              "TargetGroup",
              var.backend_target_group_arn_suffix
            ]
          ]
        }
      },

      # Frontend and Backend Response Time
      {
        type   = "metric"
        x      = 0
        y      = 12
        width  = 12
        height = 6

        properties = {
          title  = "Target Response Time"
          region = var.aws_region
          period = 300
          stat   = "Average"

          metrics = [
            [
              "AWS/ApplicationELB",
              "TargetResponseTime",
              "LoadBalancer",
              var.alb_arn_suffix,
              "TargetGroup",
              var.frontend_target_group_arn_suffix
            ],
            [
              "AWS/ApplicationELB",
              "TargetResponseTime",
              "LoadBalancer",
              var.alb_arn_suffix,
              "TargetGroup",
              var.backend_target_group_arn_suffix
            ]
          ]
        }
      },

      # Healthy Hosts
      {
        type   = "metric"
        x      = 12
        y      = 12
        width  = 12
        height = 6

        properties = {
          title  = "Healthy Target Hosts"
          region = var.aws_region
          period = 300
          stat   = "Average"

          metrics = [
            [
              "AWS/ApplicationELB",
              "HealthyHostCount",
              "LoadBalancer",
              var.alb_arn_suffix,
              "TargetGroup",
              var.frontend_target_group_arn_suffix
            ],
            [
              "AWS/ApplicationELB",
              "HealthyHostCount",
              "LoadBalancer",
              var.alb_arn_suffix,
              "TargetGroup",
              var.backend_target_group_arn_suffix
            ]
          ]
        }
      },

      # RDS CPU Utilization
      {
        type   = "metric"
        x      = 0
        y      = 18
        width  = 8
        height = 6

        properties = {
          title  = "RDS CPU Utilization"
          region = var.aws_region
          period = 300
          stat   = "Average"

          metrics = [
            [
              "AWS/RDS",
              "CPUUtilization",
              "DBInstanceIdentifier",
              var.database_identifier
            ]
          ]
        }
      },

      # RDS Database Connections
      {
        type   = "metric"
        x      = 8
        y      = 18
        width  = 8
        height = 6

        properties = {
          title  = "RDS Database Connections"
          region = var.aws_region
          period = 300
          stat   = "Average"

          metrics = [
            [
              "AWS/RDS",
              "DatabaseConnections",
              "DBInstanceIdentifier",
              var.database_identifier
            ]
          ]
        }
      },

      # RDS Free Storage
      {
        type   = "metric"
        x      = 16
        y      = 18
        width  = 8
        height = 6

        properties = {
          title  = "RDS Free Storage"
          region = var.aws_region
          period = 300
          stat   = "Average"

          metrics = [
            [
              "AWS/RDS",
              "FreeStorageSpace",
              "DBInstanceIdentifier",
              var.database_identifier
            ]
          ]
        }
      }
    ]
  })
}

# ECS Frontend CPU Alarm
resource "aws_cloudwatch_metric_alarm" "frontend_cpu" {
  alarm_name          = "${var.project_name}-frontend-high-cpu"
  alarm_description   = "Frontend ECS service CPU utilization is above 80%."
  namespace           = "AWS/ECS"
  metric_name         = "CPUUtilization"
  statistic           = "Average"
  period              = 300
  evaluation_periods  = 2
  datapoints_to_alarm = 2
  threshold           = 80
  comparison_operator = "GreaterThanThreshold"

  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = var.frontend_service_name
  }

  treat_missing_data = "notBreaching"

  alarm_actions = [aws_sns_topic.monitoring_alerts.arn]

  tags = var.tags
}

# ECS Backend CPU Alarm
resource "aws_cloudwatch_metric_alarm" "backend_cpu" {
  alarm_name          = "${var.project_name}-backend-high-cpu"
  alarm_description   = "Backend ECS service CPU utilization is above 80%."
  namespace           = "AWS/ECS"
  metric_name         = "CPUUtilization"
  statistic           = "Average"
  period              = 300
  evaluation_periods  = 2
  datapoints_to_alarm = 2
  threshold           = 80
  comparison_operator = "GreaterThanThreshold"

  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = var.backend_service_name
  }

  treat_missing_data = "notBreaching"

  alarm_actions = [aws_sns_topic.monitoring_alerts.arn]

  tags = var.tags
}

# ECS Frontend Memory Alarm
resource "aws_cloudwatch_metric_alarm" "frontend_memory" {
  alarm_name          = "${var.project_name}-frontend-high-memory"
  alarm_description   = "Frontend ECS service memory utilization is above 80%."
  namespace           = "AWS/ECS"
  metric_name         = "MemoryUtilization"
  statistic           = "Average"
  period              = 300
  evaluation_periods  = 2
  datapoints_to_alarm = 2
  threshold           = 80
  comparison_operator = "GreaterThanThreshold"

  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = var.frontend_service_name
  }

  treat_missing_data = "notBreaching"

  alarm_actions = [aws_sns_topic.monitoring_alerts.arn]

  tags = var.tags
}

# ECS Backend Memory Alarm
resource "aws_cloudwatch_metric_alarm" "backend_memory" {
  alarm_name          = "${var.project_name}-backend-high-memory"
  alarm_description   = "Backend ECS service memory utilization is above 80%."
  namespace           = "AWS/ECS"
  metric_name         = "MemoryUtilization"
  statistic           = "Average"
  period              = 300
  evaluation_periods  = 2
  datapoints_to_alarm = 2
  threshold           = 80
  comparison_operator = "GreaterThanThreshold"

  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = var.backend_service_name
  }

  treat_missing_data = "notBreaching"

  alarm_actions = [aws_sns_topic.monitoring_alerts.arn]

  tags = var.tags
}

# ALB HTTP 5XX Alarm
resource "aws_cloudwatch_metric_alarm" "alb_5xx" {
  alarm_name          = "${var.project_name}-alb-high-5xx"
  alarm_description   = "The ALB is returning more than 10 HTTP 5XX errors in 5 minutes."
  namespace           = "AWS/ApplicationELB"
  metric_name         = "HTTPCode_ELB_5XX_Count"
  statistic           = "Sum"
  period              = 300
  evaluation_periods  = 1
  threshold           = 10
  comparison_operator = "GreaterThanThreshold"

  dimensions = {
    LoadBalancer = var.alb_arn_suffix
  }

  treat_missing_data = "notBreaching"

  alarm_actions = [aws_sns_topic.monitoring_alerts.arn]

  tags = var.tags
}

# RDS High CPU Alarm
resource "aws_cloudwatch_metric_alarm" "rds_cpu" {
  alarm_name          = "${var.project_name}-rds-high-cpu"
  alarm_description   = "RDS CPU utilization is above 80%."
  namespace           = "AWS/RDS"
  metric_name         = "CPUUtilization"
  statistic           = "Average"
  period              = 300
  evaluation_periods  = 2
  datapoints_to_alarm = 2
  threshold           = 80
  comparison_operator = "GreaterThanThreshold"

  dimensions = {
    DBInstanceIdentifier = var.database_identifier
  }

  treat_missing_data = "notBreaching"

  alarm_actions = [aws_sns_topic.monitoring_alerts.arn]

  tags = var.tags
}

# RDS Low Free Storage Alarm
resource "aws_cloudwatch_metric_alarm" "rds_free_storage" {
  alarm_name          = "${var.project_name}-rds-low-free-storage"
  alarm_description   = "RDS free storage is below 2 GB."
  namespace           = "AWS/RDS"
  metric_name         = "FreeStorageSpace"
  statistic           = "Average"
  period              = 300
  evaluation_periods  = 1
  threshold           = 2147483648
  comparison_operator = "LessThanThreshold"

  dimensions = {
    DBInstanceIdentifier = var.database_identifier
  }

  treat_missing_data = "notBreaching"

  alarm_actions = [aws_sns_topic.monitoring_alerts.arn]

  tags = var.tags
}


# Frontend Target 5XX Alarm
resource "aws_cloudwatch_metric_alarm" "frontend_target_5xx" {
  alarm_name          = "${var.project_name}-frontend-target-5xx"
  alarm_description   = "Frontend targets are returning more than 10 HTTP 5XX errors in 5 minutes."
  namespace           = "AWS/ApplicationELB"
  metric_name         = "HTTPCode_Target_5XX_Count"
  statistic           = "Sum"
  period              = 300
  evaluation_periods  = 1
  threshold           = 10
  comparison_operator = "GreaterThanThreshold"

  dimensions = {
    LoadBalancer = var.alb_arn_suffix
    TargetGroup  = var.frontend_target_group_arn_suffix
  }

  treat_missing_data = "notBreaching"

  alarm_actions = [aws_sns_topic.monitoring_alerts.arn]

  tags = var.tags
}

# Backend Target 5XX Alarm
resource "aws_cloudwatch_metric_alarm" "backend_target_5xx" {
  alarm_name          = "${var.project_name}-backend-target-5xx"
  alarm_description   = "Backend targets are returning more than 10 HTTP 5XX errors in 5 minutes."
  namespace           = "AWS/ApplicationELB"
  metric_name         = "HTTPCode_Target_5XX_Count"
  statistic           = "Sum"
  period              = 300
  evaluation_periods  = 1
  threshold           = 10
  comparison_operator = "GreaterThanThreshold"

  dimensions = {
    LoadBalancer = var.alb_arn_suffix
    TargetGroup  = var.backend_target_group_arn_suffix
  }

  treat_missing_data = "notBreaching"

  alarm_actions = [aws_sns_topic.monitoring_alerts.arn]

  tags = var.tags
}

