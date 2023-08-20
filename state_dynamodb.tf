# Gère le lock du tf.state via une db
resource "aws_dynamodb_table" "tf_lock" {
    name = local.dynamodb_state_name
    tags = local.commonTags
    
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"
    attribute {
        name = "LockID"
        type = "S"
    }
}