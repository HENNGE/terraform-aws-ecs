variable "availability_zones" {
  description = "Override automatic detection of availability zones"
  default     = []
  type        = list(string)
}

variable "enable_ipv6" {
  description = "Enable IPv6?"
  default     = true
  type        = bool
}
