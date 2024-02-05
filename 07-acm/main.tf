resource "aws_acm_certificate" "saachi" {
  domain_name       = "saachi.online"
  validation_method = "DNS"

  tags = merge(
    var.common_tags,
    var.tags
  )

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_route53_record" "saachi" {
  for_each = {
    for dvo in aws_acm_certificate.saachi.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.saachi.zone_id
}

resource "aws_acm_certificate_validation" "saachi" {
  certificate_arn         = aws_acm_certificate.saachi.arn
  validation_record_fqdns = [for record in aws_route53_record.saachi : record.fqdn]
}

