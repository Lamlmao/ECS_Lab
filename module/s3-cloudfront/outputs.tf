output "s3" {
  value = aws_s3_bucket.bucket
}
output "cloudfront" {
  value = aws_cloudfront_distribution.bucket
}