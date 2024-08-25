variable "zone_id" {
  type        = string
  description = "Route 53 DNS Zone ID"
}

variable "name" {
  type        = string
  description = "The name of DNS Record"
}

variable "alias_name" {
  type        = string
  description = "The name of DNS alias"
}

variable "alias_zone_id" {
  type        = string
  description = "The zone id of DNS alias"
}

variable "type" {
  type        = string
  description = "Type of DNS Record to create"
}

variable "ttl" {
  type        = number
  description = "The TTL of the record to add to the DNS zone to complete certificate validation"
  default     = 300
}
