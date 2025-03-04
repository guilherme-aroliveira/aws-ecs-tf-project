# Create Load balancer for ECS Cluster
resource "aws_lb" "ecs_cluster_lb" {
  name            = "${var.ecs_cluster_name}-lb"
  internal        = false
  security_groups = [aws_security_group.ecs_lb_sg.id]
  subnets         = var.public_subnets

  tags = merge(
    local.tags,
    {
      Name        = "ecs-${var.ecs_cluster_name}-lb"
      Environment = var.environment
    }
  )
}

# Create a target group for the ECS Cluster
resource "aws_lb_target_group" "ecs_tg" {
  name     = "${var.ecs_cluster_name}-tg"
  vpc_id   = var.vpc_id
  port     = 80
  protocol = "HTTP"

  tags = merge(
    local.tags,
    {
      Name        = "ecs-${var.ecs_cluster_name}-tg"
      Environment = var.environment
    }
  )
}

resource "aws_lb_listener" "ecs_lb_listener" {
  load_balancer_arn = aws_lb.ecs_cluster_lb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.ecs_acm_cert_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_tg.arn
  }

  depends_on = [
    aws_lb_target_group.ecs_tg,
    var.ecs_acm_cert_resource
  ]
}

### Create a target group for the application #####
resource "aws_lb_target_group" "ecs_app_tg" {
  name        = "${var.ecs_service_name}-tg"
  vpc_id      = var.vpc_id
  port        = 8080
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
      Name        = "${var.ecs_service_name}-${var.ecs_cluster_name}-tg"
      Environment = var.environment
    }
  )
}

resource "aws_lb_listener_rule" "ecs_lb_listener_rule" {
  listener_arn = aws_lb_listener.ecs_lb_listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_app_tg.arn
  }

  condition {
    host_header {
      values = ["${var.ecs_service_name}.${var.domain_name}"]
    }
  }
}


#### Security Groups ####

# Create the load balancer security group
resource "aws_security_group" "ecs_lb_sg" {
  name        = "${var.ecs_cluster_name}-lb-sg"
  description = "Security Group for LB to traffic for ECS Cluster"
  vpc_id      = var.vpc_id

  tags = merge(
    local.tags,
    {
      Name        = "ecs-${var.ecs_cluster_name}-sg"
      Environment = var.environment
    }
  )
}

resource "aws_vpc_security_group_egress_rule" "ecs_lb_sg_egress" {
  security_group_id = aws_security_group.ecs_lb_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 0
  to_port     = 0
  ip_protocol = "tcp"

  tags = merge(
    local.tags,
    {
      Name        = "ecs-${var.ecs_cluster_name}-sg"
      Environment = var.environment
    }
  )
}

resource "aws_vpc_security_group_ingress_rule" "ecs_lb_sg_ingress" {
  security_group_id = aws_security_group.ecs_lb_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  to_port     = 443
  ip_protocol = "-1"

  tags = merge(
    local.tags,
    {
      Name        = "ecs-${var.ecs_cluster_name}-sg"
      Environment = var.environment
    }
  )
}

# Create a security group for the application
resource "aws_security_group" "ecs_app_sg" {
  name        = "${var.ecs_service_name}-sg"
  description = "Security group for springboot application to communicate in and out"
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "ecs_app_sg_ingress" {
  security_group_id = aws_security_group.ecs_app_sg.id

  cidr_ipv4   = var.vpc_cidr
  from_port   = 8080
  to_port     = 8080
  ip_protocol = "tcp"

  tags = merge(
    local.tags,
    {
      Name        = "ecs-${var.ecs_cluster_name}-sg"
      Environment = var.environment
    }
  )
}

resource "aws_vpc_security_group_egress_rule" "ecs_app_sg_egress" {
  security_group_id = aws_security_group.ecs_app_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 0
  to_port     = 0
  ip_protocol = "-1"

  tags = merge(
    local.tags,
    {
      Name        = "ecs-${var.ecs_cluster_name}-sg"
      Environment = var.environment
    }
  )
}
