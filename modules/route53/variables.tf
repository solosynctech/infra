variable "domain_name" {
  description = "The domain name for the hosted zone"
  type        = string
}

variable "create_zone" {
  description = "Whether to create a new hosted zone"
  type        = bool
  default     = true
}

variable "vpc_id" {
  description = "VPC ID to associate with private hosted zone"
  type        = string
  default     = null
}

variable "private_zone" {
  description = "Whether this is a private hosted zone"
  type        = bool
  default     = false
}

variable "force_destroy" {
  description = "Whether to destroy all records in the zone when deleting"
  type        = bool
  default     = false
}

variable "a_records" {
  description = "Map of A records to create"
  type = map(object({
    ttl     = number
    records = list(string)
  }))
  default = {}
}

variable "cname_records" {
  description = "Map of CNAME records to create"
  type = map(object({
    ttl    = number
    record = string
  }))
  default = {}
}

variable "alias_records" {
  description = "Map of alias records to create"
  type = map(object({
    type                   = string
    target_dns_name        = string
    target_zone_id         = string
    evaluate_target_health = bool
  }))
  default = {}
}

variable "mx_records" {
  description = "Map of MX records to create"
  type = map(object({
    ttl     = number
    records = list(string)
  }))
  default = {}
}

variable "txt_records" {
  description = "Map of TXT records to create"
  type = map(object({
    ttl     = number
    records = list(string)
  }))
  default = {}
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
