variable "origins" {
  type = any
}

variable "aliases" {
  description = "Alternate domain names"
  type        = list(string)
  default     = null
}

variable "acm_certificate_arn" {
  type = string
}

variable "ssl_support_method" {
  type = string
}

variable "minimum_protocol_version" {
  type = string
}

variable "target_origin_id" {
  type = string
}
