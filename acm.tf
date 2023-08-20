#V2 
# https://github.com/gsweene2/terraform-s3-website-react/blob/master/full.tf

resource "aws_acm_certificate" "certificate" {
  provider = aws.acm_provider
  domain_name       = local.domain_name
  validation_method = "DNS"
  tags = local.commonTags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "certificate_validator" {
  provider = aws.acm_provider
  certificate_arn = aws_acm_certificate.certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.acm_certificat_cname : record.fqdn]
  #validation_record_fqdns = [ aws_route53_record.r53_record_root.fqdn ]

}
