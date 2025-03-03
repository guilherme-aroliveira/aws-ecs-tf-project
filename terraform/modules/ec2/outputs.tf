output "ecs_lb" {
  description = "value"
  value = aws_lb.ecs_cluster_lb
}

output "ecs_app_sg" {
  description = "value"
  value = aws_security_group.ecs_app_sg.id
}

output "ecs_app_tg" {
  description = "value"
  value = aws_lb_target_group.ecs_app_tg.arn
}