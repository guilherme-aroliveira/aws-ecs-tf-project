resource "aws_acm_certificate" "ecs_cert" {
  domain_name = "*.${var.ecs_domain}"
  validation_method = "DNS"

  tags = {
    
  }
}