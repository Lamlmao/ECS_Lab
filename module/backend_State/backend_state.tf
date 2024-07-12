resource "aws_dynamodb_table" "dynamodb_table" {
  name         = var.name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = var.hash_key
  tags         = local.tags
  attribute {
    name = var.attribute_name
    type = var.type
  }
}

resource "aws_s3_bucket" "mybucket" {
  bucket        = var.resource_uid
  tags          = local.tags
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "mybucket" {
  count  = var.bucket_versioning ? 1 : 0
  bucket = aws_s3_bucket.mybucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  count  = var.bucket_versioning ? 1 : 0
  bucket = aws_s3_bucket.mybucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

