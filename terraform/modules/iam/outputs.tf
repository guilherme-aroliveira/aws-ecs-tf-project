output "fargate_role" {
  description = "The fargate service iam role"
  value = aws_iam_role.iam_fargate_role.arn
}