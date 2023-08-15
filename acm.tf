resource "aws_acm_certificate" "certificate" {
  provider = aws.acm_provider
  domain_name       = local.domain_name
  validation_method = "DNS"
  subject_alternative_names = [ "www.${local.domain_name}" ]
  tags = local.commonTags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "certificate_validator" {
  provider = aws.acm_provider
  certificate_arn = aws_acm_certificate.certificate.arn
  #validation_record_fqdns = [ aws_route53_record.r53_record_root.fqdn ]
  #validation_record_fqdns = [ aws_route53_record.record_validator.*.fqdn ]
  validation_record_fqdns = [for record in aws_route53_record.record_validator : record.fqdn]

}