locals {
  tags = {
    Environment = "${var.Environment}"
    Application = "${var.Application}"
  }
  header = "${var.Application}-${var.Environment}"
}

locals {
  cloudfront_website_bucket_access = jsonencode({
    "Version" : "2012-10-17",
    "Id" : "CloudfrontAccess to Website Files",
    "Statement" : [
      {
        "Sid" : "1",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "${aws_cloudfront_origin_access_identity.cloudfront_oai.iam_arn}"
        },
        "Action" : "s3:GetObject",
        "Resource" : "arn:aws:s3:::${aws_s3_bucket.bucket.id}/*"
      }
    ]
  })
}


