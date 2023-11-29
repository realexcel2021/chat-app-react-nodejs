# S3 bucket for the frontend and some rules on it

module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "my-s3-bucket"
  acl    = "private"
  website = true

  cors_rule = jsonencode([
    {
        "AllowedHeaders" : [
          "*"
        ],
        "AllowedMethods": [
            "PUT",
            "POST",
            "DELETE"
        ],
        "AllowedOrigins": [
            "*"
        ],
    }
  ])

  policy = data.aws_iam_policy_document.allow_access.json
  control_object_ownership = true
  object_ownership         = "ObjectWriter"
  force_destroy = true

  versioning = {
    enabled = true
  }
}


data "aws_iam_policy_document" "allow_access" {
  policy_id = "PolicyForCloudFrontPrivateContent"
  statement {
    sid       = "AllowCloudFrontServicePrincipal"
    actions   = ["s3:GetObject"]
    resources = ["${module.s3_bucket.bucket_arn}/*"]

    principals {
      type        = "*"
      identifiers = ["*"]
    }
    condition {
      test     = "StringLike"
      variable = "aws:Referer"
      values   = [random_password.custom_header.result]
    }
  }
}