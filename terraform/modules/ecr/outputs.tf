output "ecr_uri" {
  description = "The ECR repo URI"
  value = aws_ecr_repository.ecr_repo.repository_url
}