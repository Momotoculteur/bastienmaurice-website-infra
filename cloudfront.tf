locals {
  s3_origin_id = "myS3Origin"
}

resource "aws_cloudfront_distribution" "cloudfront" {
  tags = local.commonTags
  
  origin {
    domain_name = aws_s3_bucket.root_bucket.bucket_domain_name
    origin_id   = local.domain_name
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  aliases             = ["${local.domain_name}", "www.${local.domain_name}"]
  price_class         = "PriceClass_100"

  viewer_certificate {
    #cloudfront_default_certificate = true
    acm_certificate_arn      = aws_acm_certificate_validation.certificate_validator.certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.1_2016"

  }


  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.domain_name

    forwarded_values {
      query_string = true

      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

}
