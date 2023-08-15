# Bucket pour les requêtes vers www
resource "aws_s3_bucket" "www_bucket" {
  bucket = "www.${local.bucket_name}"
  tags = local.commonTags
}

# Bucket pour les requêtes non-www
resource "aws_s3_bucket" "root_bucket" {
  bucket = local.bucket_name
}

resource "aws_s3_bucket_ownership_controls" "root_owner" {
  bucket = aws_s3_bucket.root_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "root_access" {
  bucket = aws_s3_bucket.root_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "acl_root" {
  bucket = aws_s3_bucket.root_bucket.id
  acl    = "public-read"
  depends_on = [
    aws_s3_bucket_ownership_controls.root_owner,
    aws_s3_bucket_public_access_block.root_access
  ]
}

resource "aws_s3_bucket_website_configuration" "config_root" {
  bucket = aws_s3_bucket.root_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

}

# Permer de router les requêtes bucket www vers non www
resource "aws_s3_bucket_website_configuration" "config_www" {
  bucket = aws_s3_bucket.www_bucket.id
  redirect_all_requests_to {
    host_name = local.domain_name
    protocol  = "https"
  }
}

resource "aws_s3_bucket_policy" "policy_root" {
  bucket = aws_s3_bucket.root_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action = [
          "s3:GetObject",
        ]
        Resource = [
          aws_s3_bucket.root_bucket.arn,
          "${aws_s3_bucket.root_bucket.arn}/*",
        ]
      },
    ]
  })
}
