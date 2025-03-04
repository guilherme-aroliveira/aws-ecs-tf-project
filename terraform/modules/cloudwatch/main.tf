resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "${var.ecs_cluster_name}-LogGroup"
  skip_destroy      = false
  log_group_class   = "STANDARD"
  retention_in_days = 120

  tags = merge(
    local.tags,
    {
      Name        = "ecs-${var.ecs_cluster_name}-log"
      Environment = var.environment
    }
  )
}
