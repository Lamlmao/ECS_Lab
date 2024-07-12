#CloudFront
resource "aws_cloudfront_origin_access_identity" "cloudfront_oai" {
  comment = "${var.bucket_name}_OAI"
}

resource "aws_cloudfront_distribution" "bucket" {
  origin {
    domain_name = aws_s3_bucket.bucket.bucket_regional_domain_name
    origin_id   = var.bucket_name
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.cloudfront_oai.cloudfront_access_identity_path
    }
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  comment     = var.bucket_name
  enabled     = true
  price_class = var.price_class

  viewer_certificate {
    acm_certificate_arn            = var.enable_aliases ? var.acm_certificate_arn : null
    ssl_support_method             = var.enable_aliases ? "sni-only" : null
    cloudfront_default_certificate = var.enable_aliases ? false : true
  }
  default_root_object = var.default_root_object
  aliases             = var.enable_aliases ? var.aliases : null
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = var.bucket_name
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 60
    default_ttl            = 3600
    max_ttl                = 86400
  }
  tags = local.tags
}

#S3 bucket
resource "aws_s3_bucket" "bucket" {
  bucket        = var.bucket_name
  tags          = local.tags
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "bucket" {
  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    status     = "Enabled"
    mfa_delete = "Disabled"
  }
}

resource "aws_s3_bucket_ownership_controls" "bucket" {
  bucket = aws_s3_bucket.bucket.id
  rule {
    object_ownership = var.object_ownership
  }
}

resource "aws_s3_bucket_acl" "bucket" {
  depends_on = [aws_s3_bucket_ownership_controls.bucket]
  bucket     = aws_s3_bucket.bucket.id
  acl        = "private"
}

resource "aws_s3_bucket_policy" "policy_bucket" {
  count  = var.enable_cf ? 1 : 0
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.policy_doc_bucket[count.index].json
}

resource "aws_s3_object" "object" {
  bucket       = var.bucket_name
  key          = var.object_key
  source       = var.fe_path
  content_type = "text/html"
  etag         = filemd5(var.fe_path)
  depends_on   = [aws_s3_bucket.bucket]
}

# Provide Permissions to allow the Cloudfront distribution to access the S3 bucket
resource "aws_s3_bucket_policy" "website_files" {
  bucket = aws_s3_bucket.bucket.id
  policy = local.cloudfront_website_bucket_access
}

resource "aws_route53_record" "root-a" {
  zone_id = data.aws_route53_zone.hosted_zone.id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.bucket.domain_name
    zone_id                = aws_cloudfront_distribution.bucket.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www-a" {
  zone_id = data.aws_route53_zone.hosted_zone.id
  name    = "www.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.bucket.domain_name
    zone_id                = aws_cloudfront_distribution.bucket.hosted_zone_id
    evaluate_target_health = false
  }
}
