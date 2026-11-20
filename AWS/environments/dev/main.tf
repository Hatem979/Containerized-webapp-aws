module "networking" {
  source = "../../modules/networking"

  project_name             = var.project_name
  vpc_cidr                 = var.vpc_cidr
  availability_zones       = var.availability_zones
  public_subnet_cidrs      = var.public_subnet_cidrs
  private_app_subnet_cidrs = var.private_app_subnet_cidrs
  private_db_subnet_cidrs  = var.private_db_subnet_cidrs
  enable_nat_gateway       = var.enable_nat_gateway
  tags                     = var.common_tags
}

module "security" {
  source = "../../modules/security"

  project_name  = var.project_name
  vpc_id        = module.networking.vpc_id
  frontend_port = 80
  backend_port  = 5000
  database_port = 5432
  tags          = var.common_tags
}


module "ecr" {
  source = "../../modules/ecr"

  project_name = var.project_name

  repository_names = [
    "frontend",
    "backend"
  ]

  tags = var.common_tags
}

module "ecs" {
  source = "../../modules/ecs"

  project_name = var.project_name
  tags         = var.common_tags

  # Networking
  vpc_id                 = module.networking.vpc_id
  public_subnet_ids      = module.networking.public_subnet_ids
  private_app_subnet_ids = module.networking.private_app_subnet_ids

  # Security Groups
  alb_security_group_id      = module.security.alb_security_group_id
  frontend_security_group_id = module.security.frontend_security_group_id
  backend_security_group_id  = module.security.backend_security_group_id

  # Container Images from ECR
  frontend_image = format(
    "%s:v1",
    module.ecr.repository_urls["frontend"]
  )

  backend_image = format(
    "%s:v1",
    module.ecr.repository_urls["backend"]
  )

  # Database Secret ARN
  database_secret_arn = module.database.database_secret_arn

  # Database Connection Details
  database_host = module.database.database_address
  database_port = module.database.database_port
  database_name = module.database.database_name
}

module "database" {
  source = "../../modules/database"

  project_name = var.project_name

  vpc_id = module.networking.vpc_id

  private_db_subnet_ids = module.networking.private_db_subnet_ids

  database_security_group_id = module.security.database_security_group_id

  database_name     = var.database_name
  database_username = var.database_username

  instance_class    = var.database_instance_class
  allocated_storage = var.database_allocated_storage
  multi_az          = var.database_multi_az

  tags = var.common_tags
}

module "monitoring" {
  source = "../../modules/monitoring"

  project_name = var.project_name
  aws_region   = var.aws_region
  tags         = var.common_tags

  # ECS
  ecs_cluster_name      = module.ecs.ecs_cluster_name
  frontend_service_name = module.ecs.frontend_service_name
  backend_service_name  = module.ecs.backend_service_name

  # Application Load Balancer
  alb_arn_suffix = module.ecs.alb_arn_suffix

  frontend_target_group_arn_suffix = (
    module.ecs.frontend_target_group_arn_suffix
  )

  backend_target_group_arn_suffix = (
    module.ecs.backend_target_group_arn_suffix
  )

  # RDS
  database_identifier = module.database.database_identifier

  # Notifications
  alarm_email = var.alarm_email
}