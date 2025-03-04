output "ecs_acm_cert_resource" {
  description = "The acm certificate resource"
  value = aws_acm_certificate.acm_certificate
}

output "ecs_acm_cert" {
  description = "The acm certification validation"
  value = aws_acm_certificate.acm_certificate.domain_validation_options
}

output "ecs_acm_cert_arn" {
  description = "The certificate arn"
  value = aws_acm_certificate.acm_certificate.arn
}