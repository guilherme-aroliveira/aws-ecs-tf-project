output "ecs_cloudwatch_log" {
  description = "The name of cloudwatch log group"
  value = aws_cloudwatch_log_group.ecs_log_group.name
}