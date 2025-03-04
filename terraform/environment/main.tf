module "vpc" {
  source      = "../modules/vpc"
  environment = "dev"
}

module "acm" {
  source         = "../modules/acm"
  route53_record = module.route53.route53_record
}

module "route53" {
  source       = "../modules/route53"
  ecs_acm_cert = module.acm.ecs_acm_cert
  ecs_lb       = module.ec2.ecs_lb
}

module "ec2" {
  source                = "../modules/ec2"
  environment           = "dev"
  vpc_id                = module.vpc.vpc_id
  vpc_cidr              = module.vpc.vpc_cidr
  public_subnets        = module.vpc.public_subnets
  ecs_acm_cert_resource = module.acm.ecs_acm_cert_resource
  ecs_acm_cert_arn      = module.acm.ecs_acm_cert_arn
}

module "ecs" {
  source                      = "../modules/ecs"
  environment                 = "dev"
  ecs_cloudwatch_log_resource = module.ecs.ecs_cloudwatch_log_resource
  ecs_cloudwatch_log          = module.cloudwatch.ecs_cloudwatch_log
  public_subnets              = module.vpc.public_subnets
  ecs_app_sg                  = module.ec2.ecs_app_sg
  fargate_role_resource       = module.ecs.fargate_role_resource
  fargate_role                = module.iam.fargate_role
  ecs_app_tg                  = module.ec2.ecs_app_tg
}

module "cloudwatch" {
  source      = "../modules/cloudwatch"
  environment = "dev"
}

module "iam" {
  source = "../modules/iam"
}
