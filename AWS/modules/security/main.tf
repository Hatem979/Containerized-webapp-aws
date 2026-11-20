
locals {
  common_tags = merge(var.tags, {
    Project = var.project_name
  })
}

# 1. ALB Security Group
resource "aws_security_group" "alb" {
  name        = "${var.project_name}-alb-sg"
  description = "Security group for Application Load Balancer"
  vpc_id      = var.vpc_id

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-alb-sg"
  })
}

# 2. Frontend ECS Security Group
resource "aws_security_group" "frontend" {
  name        = "${var.project_name}-frontend-sg"
  description = "Security group for frontend ECS tasks"
  vpc_id      = var.vpc_id

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-frontend-sg"
  })
}

# 3. Backend ECS Security Group
resource "aws_security_group" "backend" {
  name        = "${var.project_name}-backend-sg"
  description = "Security group for backend ECS tasks"
  vpc_id      = var.vpc_id

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-backend-sg"
  })
}

# 4. RDS PostgreSQL Security Group
resource "aws_security_group" "database" {
  name        = "${var.project_name}-database-sg"
  description = "Security group for RDS PostgreSQL"
  vpc_id      = var.vpc_id

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-database-sg"
  })
}

# ALB: Allow HTTP from the internet
resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb.id

  description = "Allow HTTP traffic from internet"
  ip_protocol = "tcp"
  from_port   = 80
  to_port     = 80

  cidr_ipv4 = "0.0.0.0/0"

  tags = local.common_tags
}

# Frontend: Allow traffic only from ALB
resource "aws_vpc_security_group_ingress_rule" "frontend_from_alb" {
  security_group_id = aws_security_group.frontend.id

  description = "Allow frontend traffic from ALB"
  ip_protocol = "tcp"
  from_port   = var.frontend_port
  to_port     = var.frontend_port

  referenced_security_group_id = aws_security_group.alb.id

  tags = local.common_tags
}

# Backend: allow traffic only from the ALB (path-based routing /api/*)
resource "aws_vpc_security_group_ingress_rule" "backend_from_alb" {
  security_group_id = aws_security_group.backend.id

  description = "Allow Flask API traffic from ALB"
  ip_protocol = "tcp"
  from_port   = var.backend_port
  to_port     = var.backend_port

  referenced_security_group_id = aws_security_group.alb.id

  tags = local.common_tags
}

# Database: Allow PostgreSQL only from Backend
resource "aws_vpc_security_group_ingress_rule" "database_from_backend" {
  security_group_id = aws_security_group.database.id

  description = "Allow PostgreSQL traffic from backend"
  ip_protocol = "tcp"
  from_port   = var.database_port
  to_port     = var.database_port

  referenced_security_group_id = aws_security_group.backend.id

  tags = local.common_tags
}

# ALB: only to the two target ports
resource "aws_vpc_security_group_egress_rule" "alb_to_frontend" {
  security_group_id            = aws_security_group.alb.id
  description                  = "ALB to frontend tasks"
  ip_protocol                  = "tcp"
  from_port                    = var.frontend_port
  to_port                      = var.frontend_port
  referenced_security_group_id = aws_security_group.frontend.id
  tags                         = local.common_tags
}

resource "aws_vpc_security_group_egress_rule" "alb_to_backend" {
  security_group_id            = aws_security_group.alb.id
  description                  = "ALB to backend tasks"
  ip_protocol                  = "tcp"
  from_port                    = var.backend_port
  to_port                      = var.backend_port
  referenced_security_group_id = aws_security_group.backend.id
  tags                         = local.common_tags
}

# Frontend and backend: HTTPS out (ECR, CloudWatch Logs, Secrets Manager, S3)
resource "aws_vpc_security_group_egress_rule" "frontend_https_out" {
  security_group_id = aws_security_group.frontend.id
  description       = "HTTPS to AWS services"
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_ipv4         = "0.0.0.0/0"
  tags              = local.common_tags
}

resource "aws_vpc_security_group_egress_rule" "backend_https_out" {
  security_group_id = aws_security_group.backend.id
  description       = "HTTPS to AWS services"
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_ipv4         = "0.0.0.0/0"
  tags              = local.common_tags
}

# Backend: PostgreSQL
resource "aws_vpc_security_group_egress_rule" "backend_to_database" {
  security_group_id            = aws_security_group.backend.id
  description                  = "Backend to PostgreSQL"
  ip_protocol                  = "tcp"
  from_port                    = var.database_port
  to_port                      = var.database_port
  referenced_security_group_id = aws_security_group.database.id
  tags                         = local.common_tags
}