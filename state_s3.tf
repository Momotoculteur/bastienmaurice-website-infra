resource "aws_s3_bucket" "s3_state" {
  bucket = local.bucket_state_name
  tags   = local.commonTags

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "s3_versionning" {
  bucket = aws_s3_bucket.s3_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_encryption" {
  bucket = aws_s3_bucket.s3_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


/*
resource "aws_s3_bucket_policy" "policy_s3_state" {
  bucket = aws_s3_bucket.s3_state.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Principal = "*"
        "Effect" : "Allow",
        "Action" : "s3:ListBucket",
        "Resource" : aws_s3_bucket.s3_state.arn
      },
      {
        Principal = "*"
        "Effect" : "Allow",
        "Action" : ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"],
        "Resource" : [aws_s3_bucket.s3_state.arn, "${aws_s3_bucket.s3_state.arn}/*"]
      }
    ]
  })
}
*/

resource "aws_s3_bucket_public_access_block" "s3_access" {
  bucket = aws_s3_bucket.s3_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
