# Generation du certif, validation par records DNS à add a route53
resource "aws_acm_certificate" "certificate" {
  provider = aws.acm_provider
  domain_name       = local.domain_name
  validation_method = "DNS"
  tags = local.commonTags

  lifecycle {
    create_before_destroy = true
  }
}

# Validateur
resource "aws_acm_certificate_validation" "certificate_validator" {
  provider = aws.acm_provider
  certificate_arn = aws_acm_certificate.certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.acm_certificat_cname : record.fqdn]
}
