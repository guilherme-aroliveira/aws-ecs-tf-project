resource "aws_iam_role" "iam_cluster_role" {
  name = "ecs_cluster-Name-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = [
            "ecs.amazonaws.com",
            "ec2.amazonaws.com",
            "application-autoscaling.amazonaws.com"
          ]
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "iam_ecs_cluster_role_policy" {
  name = "ecs-cluster-name-iam-policy"
  role = aws_iam_role.iam_cluster_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecs:*",
          "ec2:*",
          "ecr:*",
          "ecs:elasticloadbalacing:*",
          "dynamodb:*",
          "cloudwatch:*",
          "s3:*",
          "rds:*",
          "sqs:*",
          "sns:*",
          "logs:*",
          "ssm:*"
        ]
      }
    ]
    Resource = "*"
  })
}

resource "aws_iam_role" "iam_fargate_role" {
  name = "${var.ecs_service_name}-IAM-Rome"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = [
          "ecs.amazonaws.com", "ecs-task.amazonaws.com"
        ]
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "iam_fargate_role_policy" {
  name = "ecs-cluster-name-iam-policy"
  role = aws_iam_role.iam_cluster_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecs:*",
          "ecr:*",
          "logs:*",
          "cloudwatch:*",
          "ecs:elasticloadbalacing:*",
        ]
      }
    ]
    Resource = "*"
  })
}