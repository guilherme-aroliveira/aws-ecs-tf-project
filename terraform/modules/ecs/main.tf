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

  depends_on = [ var.ecs_cloudwatch_log_resource ]
}

resource "aws_ecs_service" "ecs_service" {
  name            = var.ecs_service_name
  task_definition = aws_ecs_task_definition.ecs_task_springboot.id
  desired_count   = var.desired_task_number
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

  depends_on = [ aws_ecs_cluster.ecs_cluster ]
}

data "template_file" "ecs_task_file" {
  template = file("task_definition.json")

  vars = {
    task_definition_name  = var.task_definition_name
    ecs_service_name      = var.ecs_service_name
    docker_image_url      = var.docker_image_url
    memory                = var.memory
    docker_container_port = var.docker_container_port
    spring_profile        = var.spring_profile
    region                = var.region
  }
}

resource "aws_ecs_task_definition" "ecs_task_springboot" {
  container_definitions    = data.template_file.ecs_task_file.rendered
  family                   = aws_ecs_service.ecs_service.name
  cpu                      = 512
  memory                   = var.memory
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = var.fargate_role
  task_role_arn            = var.fargate_role

  depends_on = [ 
    aws_ecs_service.ecs_service, 
    var.fargate_role_resource 
  ]
}
