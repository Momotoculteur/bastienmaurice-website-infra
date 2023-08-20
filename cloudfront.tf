locals {
  # Déf une origin cloudfront vers notre bucket S3 principal
  s3_origin_id = "primaryS3"
}

# Managed policy par AWS pour l'opti du cache pour les S3
data "aws_cloudfront_cache_policy" "cache_policy" {
  name = "Managed-CachingOptimized"
}

# CDN
resource "aws_cloudfront_distribution" "cloudfront" {
  tags = local.commonTags

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  origin {
    domain_name              = aws_s3_bucket.root_bucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.s3_root_bucket_oac.id
    origin_id                = local.s3_origin_id
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  aliases             = [local.domain_name]
  price_class         = "PriceClass_100"


  # Gestion du certificat provider par ACM
  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.certificate.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"

  }

  custom_error_response {
    error_caching_min_ttl = 3000
    error_code            = 404
  }

  default_cache_behavior {
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = local.s3_origin_id
    viewer_protocol_policy = "redirect-to-https"
    cache_policy_id        = data.aws_cloudfront_cache_policy.cache_policy.id

    # Function custom pour modificer les URI entre user <-> Cloudfront <-> S3 bucket
    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.cloudfront_lambda_function_html_redirect.arn
    }
  }

  # Cache behavior with precedence 0
  ordered_cache_behavior {
    path_pattern           = "/*"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    target_origin_id       = local.s3_origin_id
    viewer_protocol_policy = "redirect-to-https"
    cache_policy_id        = data.aws_cloudfront_cache_policy.cache_policy.id

    # Function custom pour modificer les URI entre user <-> Cloudfront <-> S3 bucket
    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.cloudfront_lambda_function_html_redirect.arn
    }
  }
}

# Origin Access Control : défini l'accès au bucket que par une distri Cloudfront
resource "aws_cloudfront_origin_access_control" "s3_root_bucket_oac" {
  name                              = "origin_access_website_bucket_s3"
  description                       = "oac permet cloudfront d'acceder au bucket bastienmaurice.fr"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# Bind la fonction lambda de redirect html à nos deux cache behavior
resource "aws_cloudfront_function" "cloudfront_lambda_function_html_redirect" {
  name    = "cloudfront-lambda-function-html-redirect"
  runtime = "cloudfront-js-1.0"
  comment = "permet de rediriger les folders de mkdocs vers le /index.html associé sans l'afficher dans la barre de recherche"
  publish = true
  code    = file("${path.module}/lambda-js-code/cloudfront-lambda-redirection-html-to-bucket.js")
}

