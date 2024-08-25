resource "aws_cloudfront_distribution" "main" {
  dynamic "origin" {
    for_each = var.origins
    content {
      domain_name = lookup(origin.value, "domain_name", null)
      origin_id   = lookup(origin.value, "origin_id", null)

      custom_origin_config {
        http_port                = "80"
        https_port               = "443"
        origin_protocol_policy   = "https-only"
        origin_ssl_protocols     = ["TLSv1.2"]
        origin_keepalive_timeout = 30
        origin_read_timeout      = 30
      }

    }
  }

  enabled         = true
  is_ipv6_enabled = true
  aliases         = var.aliases

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.target_origin_id

    forwarded_values {
      query_string = true

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
  }

  viewer_certificate {
    acm_certificate_arn      = var.acm_certificate_arn
    ssl_support_method       = var.ssl_support_method
    minimum_protocol_version = var.minimum_protocol_version
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}
