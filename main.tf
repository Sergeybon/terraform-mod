
provider "aws" {
  region = "us-east-2"
  alias = "east-2"
}
provider "aws" {
  region = "us-east-1"
  alias = "east-1"
}
locals {
  environment  = terraform.workspace
  tfenvfile    = "${path.module}/config/tfenv-${local.environment}.json"
  tfenv        = jsondecode(file(local.tfenvfile))
}
resource "aws_cloudfront_origin_access_identity" "this" {
  comment = "access-identity-${aws_s3_bucket.this.bucket_regional_domain_name}"
}

resource "aws_cloudfront_distribution" "this" {
  enabled = true
  aliases = [local.tfenv.domain_name]
  price_class = local.tfenv.price_class
  default_root_object = local.tfenv.default_root_object
  is_ipv6_enabled = true
  default_cache_behavior {
    allowed_methods        = local.tfenv.cache.allowed_methods
    cached_methods         = local.tfenv.cache.cached_methods
    target_origin_id       =  local.tfenv.origin_id
    viewer_protocol_policy = local.tfenv.viewer_protocol_policy
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
    origin_id   = local.tfenv.origin_id
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
  bucket = local.tfenv.bucket_name
  request_payer = "BucketOwner"
  tags = {}
  cors_rule {
    allowed_methods = local.tfenv.cors.allowed_methods
    allowed_headers = local.tfenv.cors.allowed_headers
    allowed_origins = local.tfenv.cors.allowed_origins
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
  domain_name = local.tfenv.domain_name
  validation_method = "DNS"
  provider = aws.east-1
}