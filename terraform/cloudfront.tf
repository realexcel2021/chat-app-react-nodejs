#####################################
# Cloud front for s3 bucket frontend #
#####################################

locals {
  s3_origin_id = "SnappyOriginS3Web"
}

resource "random_password" "custom_header" {
  length      = 13
  special     = false
  lower       = true
  upper       = true
  numeric     = true
  min_lower   = 1
  min_numeric = 1
  min_upper   = 1
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = module.s3_bucket.s3_bucket_website_endpoint
    origin_id   = local.s3_origin_id

    custom_header {
      name  = "Referer"
      value = random_password.custom_header.result
    }
    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_keepalive_timeout = 5
      origin_protocol_policy   = "http-only"
      origin_read_timeout      = 30
      origin_ssl_protocols = [
        "TLSv1.2",
      ]
    }
  }

  enabled         = true
  is_ipv6_enabled = true
  comment         = "CDN for snappy frontend"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_All"

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}

######################################
# Cloudfront for backend loadbalancer#
######################################

resource "aws_cloudfront_distribution" "lb_distribution" {
  origin {
    domain_name = module.alb-backend.dns_name
    origin_id   = module.alb-backend.dns_name

    custom_origin_config {
      http_port              = "80"
      https_port             = "443"
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  enabled         = true
  is_ipv6_enabled = true
  comment         = "CDN for Snappy backend"

  default_cache_behavior {
    allowed_methods  =  ["HEAD", "DELETE", "POST", "GET", "OPTIONS", "PUT", "PATCH"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = module.alb-backend.dns_name

    forwarded_values {
      query_string = true


      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }



  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }


  depends_on = [ module.alb-backend ]

}
