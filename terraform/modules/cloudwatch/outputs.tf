output "ecs_cloudwatch_log" {
  description = "The name of cloudwatch log group"
  value = aws_cloudwatch_log_group.ecs_log_group.name
}

output "ecs_cloudwatch_log_resource" {
  description = "The cloudwatch log resource"
  value = aws_cloudwatch_log_group.ecs_log_group
}