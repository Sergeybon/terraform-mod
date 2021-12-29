
variable "region1" {
  description = "first region AWS"
  type        = string
  default     = "us-east-2"
}

variable "alias1" {
  description = "first alias AWS"
  type        = string
  default     = "east-2"
}

variable "region2" {
  description = "second region AWS"
  type        = string
  default     = "us-east-1"
}

variable "alias2" {
  description = "second alias AWS"
  type        = string
  default     = "east-1"
}

variable "price_class" {
  description = "price class"
  type        = string
  default     = " "
}

variable "default_root_object" {
  description = "default root object"
  type        = string
  default     = ""
}

variable "allowed_methods" {
  description = " "
  type        = list (string)
  default     = " "
}

variable "cached_methods" {
  description = " "
  type        = list (string)
  default     = " "
}

variable "origin_id" {
  description = " "
  type        = string
  default     = " "
}

variable "viewer_protocol_policy" {
  description = " "
  type        = string
  default     = " "
}

variable "bucket_name" {
  description = " "
  type        = string
  default     = " "
}

variable "allowed_headers" {
  description = " "
  type        = list (string)
  default     = " "
}

variable "allowed_origins" {
  description = " "
  type        = list (string)
  default     = " "
}

variable "domain_name" {
  description = " "
  type        = string
  default     = " "
}
