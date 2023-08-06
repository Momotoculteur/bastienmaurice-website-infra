resource "aws_route53_zone" "r53_zone" {
  name = var.domain_name
  tags = {
    terraform = "true"
    type      = "website-infra"
  }
}

resource "aws_route53_record" "r53_record" {
  zone_id = aws_route53_zone.r53_zone.id
  name    = var.domain_name
  type    = "A"
  alias {
    name                   = aws_s3_bucket.root_bucket.website_endpoint
    zone_id                = aws_s3_bucket.root_bucket.hosted_zone_id
    evaluate_target_health = ""
  }
}
