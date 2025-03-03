data "aws_route53_zone" "route53_zone" {
  name         = var.domain_name
  private_zone = false
}


resource "aws_route53_record" "route53_record" {
  for_each = {
    for dvo in var.ecs_acm_cert : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.id
  zone_id         = data.aws_route53_zone.route53_zone.zone_id

  alias {
    evaluate_target_health = false
    name                   = var.ecs_lb.dns_name
    zone_id                = var.ecs_lb.zone_id
  }
}

