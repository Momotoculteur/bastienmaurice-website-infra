resource "aws_route53_zone" "r53_zone" {
  name = local.domain_name
  tags = {
    terraform = "true"
    type      = "website-infra"
  }
}

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
