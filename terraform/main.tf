# Bucket S3 pour héberger l'application React
resource "aws_s3_bucket" "react_app" {
  bucket = "${var.bucket_name}-${random_string.bucket_suffix.result}"
}

resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

# Configuration du bucket S3 pour l'hébergement web statique
resource "aws_s3_bucket_website_configuration" "react_app" {
  bucket = aws_s3_bucket.react_app.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

# Configuration de la politique de bucket publique
resource "aws_s3_bucket_public_access_block" "react_app" {
  bucket = aws_s3_bucket.react_app.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Politique de bucket pour permettre l'accès public en lecture
resource "aws_s3_bucket_policy" "react_app" {
  bucket = aws_s3_bucket.react_app.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.react_app.arn}/*"
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.react_app]
}

# Origin Access Control pour CloudFront
resource "aws_cloudfront_origin_access_control" "react_app" {
  name                              = "react-app-oac"
  description                       = "Origin Access Control for React App"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# Distribution CloudFront
resource "aws_cloudfront_distribution" "react_app" {
  origin {
    domain_name              = aws_s3_bucket.react_app.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.react_app.id
    origin_id                = "S3-${aws_s3_bucket.react_app.bucket}"
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "React App CloudFront Distribution"
  default_root_object = "index.html"

  # Gestion des erreurs pour les SPA (Single Page Applications)
  custom_error_response {
    error_code         = 404
    response_code      = 200
    response_page_path = "/index.html"
  }

  custom_error_response {
    error_code         = 403
    response_code      = 200
    response_page_path = "/index.html"
  }

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${aws_s3_bucket.react_app.bucket}"

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

  # Configuration pour les assets statiques (CSS, JS, images)
  ordered_cache_behavior {
    path_pattern     = "/assets/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${aws_s3_bucket.react_app.bucket}"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    min_ttl                = 31536000  # 1 an
    default_ttl            = 31536000  # 1 an
    max_ttl                = 31536000  # 1 an
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = {
    Name        = "React App Distribution"
    Environment = "production"
  }
}

# Politique de bucket mise à jour pour CloudFront
resource "aws_s3_bucket_policy" "cloudfront_oac" {
  bucket = aws_s3_bucket.react_app.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowCloudFrontServicePrincipal"
        Effect    = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.react_app.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.react_app.arn
          }
        }
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.react_app]
}
