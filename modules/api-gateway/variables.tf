variable "name" {
  type        = string
  description = "The name of the API Gateway"
}

variable "certificate_arn" {
  type        = string
  description = "The arn of the ACM certificate"
}

variable "domain_name" {
  type        = string
  description = "The domain name to API Gateway custom domain"
}

variable "integrations" {
  type        = map(any)
  default     = {}
  description = "API gateway routes with integrations"
}
