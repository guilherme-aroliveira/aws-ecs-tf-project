resource "aws_lb" "ecs_cluster_lb" {
  name            = "${var.ecs_cluster_name}-lb"
  internal        = false
  security_groups = [aws_security_group.ecs_lb_sg.id]
  subnets = [
    var.public_subnet_1,
    var.public_subnet_2,
    var.public_subnet_3
  ]

  tags = merge(
    local.tags,
    {
      Name = "ecs-${var.ecs_cluster_name}-lb"
      Environment = var.environment
    }
  )
}

resource "aws_lb_target_group" "name" {
  name     = "ecs-cluster-tg"
  vpc_id   = var.vpc_id
  port     = 80
  protocol = "HTTP"

  tags = merge(
    local.tags,
    {
      Name = "ecs-${var.ecs_cluster_name}-tg"
      Environment = var.environment
    }
  )
}

resource "aws_lb_listener" "ecs_lb_listener" {
  load_balancer_arn = aws_lb.ecs_cluster_lb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = ""

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.name.arn
  }

  depends_on = [aws_lb_target_group.name]
}

### App target group #####
resource "aws_lb_target_group" "ecs_app_tg" {
  name        = "ecs-springboot-app-tg"
  vpc_id      = var.vpc_id
  port        = "docker_port"
  protocol    = "HTTP"
  target_type = "ip"

  health_check {
    path                = "/actuator/health"
    protocol            = "HTTP"
    matcher             = "2000"
    interval            = 60
    timeout             = 30
    healthy_threshold   = "3"
    unhealthy_threshold = "3"
  }

  
  tags = merge(
    local.tags,
    {
      Name = "ecs-springboot-app-${var.ecs_cluster_name}-tg"
      Environment = var.environment
    }
  )
}

resource "aws_lb_listener_rule" "ecs_lb_listener_rule" {
  listener_arn = aws_lb_listener.ecs_lb_listener.arn

  action {
    type             = "forward"
    target_group_arn = ""
  }

  condition {
    host_header {
      values = ["ecs_service.name.domain_name"]
    }
  }
}


#### Security Groups ####
resource "aws_security_group" "ecs_lb_sg" {
  name        = "${var.ecs_cluster_name}-lb-sg"
  description = "Security Group for LB to traffic for ECS Cluster"
  vpc_id      = var.vpc_id

  tags = merge(
    local.tags,
    {
      Name = "ecs-${var.ecs_cluster_name}-sg"
      Environment = var.environment
    }
  )
}

resource "aws_vpc_security_group_egress_rule" "name" {
  security_group_id = aws_security_group.ecs_lb_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 0
  to_port     = 0
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "name" {
  security_group_id = aws_security_group.ecs_lb_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  to_port     = 443
  ip_protocol = "-1"
}

resource "aws_security_group" "app_sg" {
  name        = "ecs-service-name-sg"
  description = "security group fro springboot application communicate in and out"
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "app_sg_ingress" {
  security_group_id = aws_security_group.ecs_lb_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 8080
  to_port     = 8080
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "app_sg_egress" {
  security_group_id = aws_security_group.ecs_lb_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 0
  to_port     = 0
  ip_protocol = "-1"
}
