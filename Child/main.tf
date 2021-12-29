provider "aws" {
  region = var.region1
  alias = var.alias1
}

provider "aws" {
  region = var.region2
  alias = var.alias2
}

resource "aws_cloudfront_origin_access_identity" "this" {
  comment = "access-identity-${aws_s3_bucket.this.bucket_regional_domain_name}"
}

resource "aws_cloudfront_distribution" "this" {
  enabled = true
  aliases = [var.domain_name]
  price_class = var.price_class
  default_root_object = var.default_root_object
  is_ipv6_enabled = true
  default_cache_behavior {
    allowed_methods        = var.allowed_methods
    cached_methods         = var.cached_methods
    target_origin_id       =  var.origin_id
    viewer_protocol_policy = var.viewer_protocol_policy
    compress = true
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }
  origin {
    domain_name = aws_s3_bucket.this.bucket_regional_domain_name
    origin_id   = var.origin_id
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.this.cloudfront_access_identity_path
    }
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.this.arn
    minimum_protocol_version = "TLSv1.2_2019"
    ssl_support_method = "sni-only"
  }
}

resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
  request_payer = "BucketOwner"
  tags = {}
  cors_rule {
    allowed_methods = var.allowed_methods
    allowed_headers = var.allowed_headers
    allowed_origins = var.allowed_origins
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.bucket
  policy = jsonencode(
  {
    Id        = "PolicyForCloudFrontPrivateContent"
    Statement = [
      {
        Action    = "s3:GetObject"
        Effect    = "Allow"
        Principal = {
          AWS = aws_cloudfront_origin_access_identity.this.iam_arn
        }
        Resource  = "${aws_s3_bucket.this.arn}/*"
        Sid       = "1"
      },
    ]
    Version   = "2008-10-17"
  }
  )
}

resource "aws_acm_certificate" "this" {
  domain_name = var.domain_name
  validation_method = "DNS"
  provider = aws.east-1
}