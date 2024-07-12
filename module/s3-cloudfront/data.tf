data "aws_iam_policy_document" "policy_doc_bucket" {
  count = var.enable_cf ? 1 : 0
  statement {
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.cloudfront_oai.iam_arn]
    }
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.bucket.arn}/*"]
  }
}

data "aws_route53_zone" "hosted_zone" {
  name = var.hosted_zone_name
}