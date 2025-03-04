output "fargate_role_resource" {
  description = "The fargate role iam resource"
  value = aws_iam_role.iam_fargate_role
}

output "fargate_role" {
  description = "The fargate service iam role"
  value = aws_iam_role.iam_fargate_role.arn
}