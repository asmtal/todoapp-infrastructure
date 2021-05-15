resource "aws_s3_bucket" "tf-state" {
    bucket = var.bucket_name
    acl    = "private"
    versioning {
        enabled = true
    }
    server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default {
                sse_algorithm = "AES256"
            }
        }
    }
}

resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name = var.table_name
  hash_key = "LockID"
  read_capacity = 20
  write_capacity = 20
 
  attribute {
    name = "LockID"
    type = "S"
  }
}