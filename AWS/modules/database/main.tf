locals {
  common_tags = merge(var.tags, {
    Project   = var.project_name
    Component = "database"
  })
}

resource "aws_db_subnet_group" "db_sub" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = var.private_db_subnet_ids

  tags = local.common_tags
}

resource "aws_db_instance" "db_instance" {
  identifier = "${var.project_name}-postgres"

  engine         = "postgres"
  engine_version = var.engine_version

  instance_class = var.instance_class

  allocated_storage = var.allocated_storage
  storage_type      = "gp3"
  storage_encrypted = true

  db_name  = var.database_name
  username = var.database_username
  manage_master_user_password = true

  db_subnet_group_name   = aws_db_subnet_group.db_sub.name
  vpc_security_group_ids = [var.database_security_group_id]

  publicly_accessible = false

  multi_az = var.multi_az

  backup_retention_period = 1

  auto_minor_version_upgrade = true

  deletion_protection = false
  skip_final_snapshot = true

  tags = local.common_tags
}