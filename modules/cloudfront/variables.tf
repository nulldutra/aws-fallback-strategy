variable "origins" {
  description = "Configuration for the origins associated with the CloudFront distribution. This can include details such as domain names, origin paths, and other origin-specific settings."
  type        = any
}

variable "aliases" {
  description = "List of CNAMEs that CloudFront uses to route requests to the distribution. This is useful for setting up custom domains."
  type        = list(string)
  default     = null
}

variable "acm_certificate_arn" {
  description = "The ARN of the AWS Certificate Manager (ACM) certificate that CloudFront will use for HTTPS connections."
  type        = string
}

variable "ssl_support_method" {
  description = "The SSL support method for the CloudFront distribution."
  type        = string
}

variable "minimum_protocol_version" {
  description = "The minimum version of the SSL/TLS protocol that CloudFront will use to communicate with clients. This ensures that only secure versions of the protocol are used."
  type        = string
}

variable "target_origin_id" {
  description = "The unique identifier for the origin that CloudFront will use to route requests."
  type        = string
}
