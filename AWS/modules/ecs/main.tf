
locals {
  common_tags = merge(var.tags, {
    Project = var.project_name
  })
}

resource "aws_ecs_cluster" "ecs_clu" {
  name = "${var.project_name}-cluster"

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-cluster"
  })
}

resource "aws_ecs_cluster_capacity_providers" "ecs_cp" {
  cluster_name = aws_ecs_cluster.ecs_clu.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = 1
  }
}
