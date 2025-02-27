module "vpc" {
  source = "../modules/vpc"
  environment = "dev"
}

module "ecs" {
  source = "../modules/ecs"
  environment = "dev"
  ecs_cloudwatch_log = module.cloudwatch.ecs_cloudwatch_log
}

module "cloudwatch" {
  source = "../modules/cloudwatch"
  environment = "dev"
  ecs_cluster_name = module.ecs.ecs_cluster_name
}