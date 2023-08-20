resource "aws_route53_zone" "r53_zone" {
  name = local.domain_name
  tags = local.commonTags
}

resource "aws_route53_record" "r53_record_root" {
  zone_id = aws_route53_zone.r53_zone.id
  name    = local.domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.cloudfront.domain_name
    zone_id                = aws_cloudfront_distribution.cloudfront.hosted_zone_id
    evaluate_target_health = true
  }
}


resource "aws_route53_record" "r53_record_www" {
  zone_id = aws_route53_zone.r53_zone.id
  name    = "www.${local.domain_name}"
  type    = "A"

  alias {
    name                   = aws_s3_bucket_website_configuration.config_www.website_domain
    zone_id                = aws_s3_bucket.root_bucket.hosted_zone_id
    evaluate_target_health = true
  }
}


# Validation du certificat par DNS ; 
# Faut ajouter des records dans notre zone
resource "aws_route53_record" "acm_certificat_cname" {
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
  zone_id         = aws_route53_zone.r53_zone.zone_id
}