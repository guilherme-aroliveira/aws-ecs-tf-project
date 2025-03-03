output "ecs_acm_cert" {
  description = "value"
  value = aws_acm_certificate.acm_certificate.domain_validation_options
}

output "ecs_acm_cert_arn" {
  description = "value"
  value = aws_acm_certificate.acm_certificate.arn
}