resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.ecs_cluster_name
}

resource "aws_ecs_service" "ecs_service" {
  name            = ""
  task_definition = aws_ecs_task_definition.ecs_task_springboot.id
  desired_count   = ""
  cluster         = aws_ecs_cluster.ecs_cluster.name
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [] # public subnets
    security_groups  = []
    assign_public_ip = true
  }

  load_balancer {
    container_name   = ""
    container_port   = 0
    target_group_arn = ""
  }
}

data "template_file" "ecs_task_file" {
  template = file("task_definition.json")

  vars = {

  }
}

resource "aws_ecs_task_definition" "ecs_task_springboot" {
  container_definitions    = data.template_file.ecs_task_file.rendered
  family                   = aws_ecs_service.ecs_service.name
  cpu                      = 512
  memory                   = "var.memory"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = ""
  task_role_arn            = ""
}
