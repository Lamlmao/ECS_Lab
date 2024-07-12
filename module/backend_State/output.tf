output "dynamodb_table_name" {
  value = aws_dynamodb_table.dynamodb_table.name
}

output "s3_bucket_id" {
  description = "The id of the bucket."
  value       = aws_s3_bucket.mybucket.id
}

output "s3_bucket_arn" {
  description = "The arn of the bucket."
  value       = aws_s3_bucket.mybucket.arn
}
