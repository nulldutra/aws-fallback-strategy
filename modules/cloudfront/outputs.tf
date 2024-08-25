output "domain_name" {
  value       = aws_cloudfront_distribution.main.domain_name
  description = "Domain name corresponding to the distribution"
}

output "hosted_zone_id" {
  value       = aws_cloudfront_distribution.main.hosted_zone_id
  description = "CloudFront Route 53 zone ID that can be used to route an Alias"
}
