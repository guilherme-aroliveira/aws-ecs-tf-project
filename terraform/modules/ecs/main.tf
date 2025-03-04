resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.ecs_cluster_name

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  configuration {
    execute_command_configuration {
      log_configuration {
        cloud_watch_log_group_name = var.ecs_cloudwatch_log
      }
    }
  }

  tags = merge(
    local.tags,
    {
      Name        = "ecs-${var.ecs_cluster_name}"
      Environment = var.environment
    }
  )
}

resource "aws_ecs_cluster_capacity_providers" "ecs_cluster_providers" {
  cluster_name       = aws_ecs_cluster.ecs_cluster.name
  capacity_providers = ["FARGATE", "FARGATE_SPOT"]

  default_capacity_provider_strategy {
    base              = 1
    capacity_provider = "FARGATE_SPOT"
    weight            = 100
  }
}

resource "aws_ecs_service" "ecs_service" {
  name            = var.ecs_service_name
  task_definition = aws_ecs_task_definition.ecs_task_springboot.arn
  desired_count   = var.task_numbers
  cluster         = aws_ecs_cluster.ecs_cluster.name
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [var.public_subnets]
    security_groups  = [var.ecs_app_sg]
    assign_public_ip = true
  }

  load_balancer {
    container_name   = var.ecs_service_name
    container_port   = 0
    target_group_arn = var.ecs_app_tg
  }

  depends_on = [aws_ecs_cluster.ecs_cluster]
}

data "template_file" "ecs_task_file" {
  template = "${path.module}/task_definition.json"

  vars = {
    task_definition_name = var.task_definition_name
    ecr_uri              = var.ecr_uri
    spring_profile       = var.spring_profile
    ecs_service_name     = var.ecs_service_name
    region               = var.region
  }
}

resource "aws_ecs_task_definition" "ecs_task_springboot" {
  container_definitions    = data.template_file.ecs_task_file.rendered
  family                   = var.task_definition_name
  cpu                      = 512
  memory                   = 1024
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = var.fargate_role
  task_role_arn            = var.fargate_role
}
