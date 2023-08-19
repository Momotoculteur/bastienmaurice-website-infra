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

resource "aws_s3_bucket_public_access_block" "s3_access" {
  bucket = aws_s3_bucket.s3_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
