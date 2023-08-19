resource "aws_route53_zone" "r53_zone" {
  name = local.domain_name
  tags = local.commonTags
}

/*
resource "aws_route53_record" "record_validator" {
  
  count   = 2
  zone_id = aws_route53_zone.r53_zone.id

  name    = element(aws_acm_certificate.certificate.domain_validation_options.*.reource_record_name, count.index)
  type    = element(aws_acm_certificate.certificate.domain_validation_options.*.reource_record_type, count.index)
  records = [element(aws_acm_certificate.certificate.domain_validation_options.*.reource_record_value, count.index)]
  



  for_each = {
    for dvo in aws_acm_certificate.certificate.domain_validation_options : dvo.domain_name => {
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
  zone_id         = aws_route53_zone.r53_zone.id

}

*/



resource "aws_route53_record" "r53_record_root" {
  zone_id = aws_route53_zone.r53_zone.id
  name    = local.domain_name
  type    = "A"

  alias {
    name                   = aws_s3_bucket_website_configuration.config_root.website_domain
    zone_id                = aws_s3_bucket.root_bucket.hosted_zone_id
    evaluate_target_health = true
  }
}

/*
resource "aws_route53_record" "r53_record_www" {
  zone_id = aws_route53_zone.r53_zone.id
  name    = "www.${local.domain_name}"
  type    = "A"

  alias {
    name                   = aws_s3_bucket_website_configuration.config_root.website_domain
    zone_id                = aws_s3_bucket.root_bucket.hosted_zone_id
    evaluate_target_health = true
  }
}
*/
