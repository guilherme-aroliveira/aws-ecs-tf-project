resource "aws_route53_record" "ecs_record" {
  name = ""
  type = ""
  zone_id = ""
  records = ""
  ttl = 60
  allow_overwrite = true
}

resource "aws_route53_record" "ecs_lb_record" {
  name = "guilhermeoliveira.ch"
  type = "A"
  zone_id = "aws_route53_zone.ecs_domain.zone_id"
  
  alias {
    evaluate_target_health = false
    name = "aws_lb.ecs_cluster.dns_name"
    zone_id = "aws_lb.ecs_cluster.zone_id"
  }
}


resource "aws_acm_certificate_validation" "name" {
  certificate_arn = "acm_certificate.ecs_domain"
  validation_record_fqdns = [ aws_route53_record.name.fqdn ]
}