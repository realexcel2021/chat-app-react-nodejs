# S3 bucket for the frontend and some rules on it

module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket                  = var.frontend_bucket_name
  acl                     = "private"
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
  website = {
    index_document = "index.html"
    error_document = "error.html"
  }

  cors_rule = [
    {
      allowed_methods = ["PUT", "POST"]
      allowed_origins = ["*"]
      allowed_headers = ["*"]

    },
  ]

  attach_policy            = true
  policy                   = data.aws_iam_policy_document.allow_access.json
  control_object_ownership = true
  object_ownership         = "ObjectWriter"
  force_destroy            = true

  versioning = {
    enabled = true
  }
}


data "aws_iam_policy_document" "allow_access" {
  policy_id = "PolicyForCloudFrontPrivateContent"
  statement {
    sid       = "AllowCloudFrontServicePrincipal"
    actions   = ["s3:GetObject"]
    resources = ["${module.s3_bucket.s3_bucket_arn}/*"]

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