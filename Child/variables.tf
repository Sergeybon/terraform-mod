
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
  description = "list of allowed methods"
  type        = list (string)
  default     = " "
}

variable "cached_methods" {
  description = "list of cached methods"
  type        = list (string)
  default     = " "
}

variable "origin_id" {
  description = "origin id"
  type        = string
  default     = " "
}

variable "viewer_protocol_policy" {
  description = " "
  type        = string
  default     = " "
}

variable "bucket_name" {
  description = "AWS S3 bucket name"
  type        = string
  default     = " "
}

variable "allowed_headers" {
  description = "list of allowed headers"
  type        = list (string)
  default     = " "
}

variable "allowed_origins" {
  description = "list of allowed origins"
  type        = list (string)
  default     = " "
}

variable "domain_name" {
  description = "domain name"
  type        = string
  default     = " "
}

variable "sse_algorithm" {
  description = "sse algorithm"
  type        = string
  default     = "AES256"
}

variable "minimum_protocol_version" {
  description = "minimum protocol version"
  type        = string
  default     = "TLSv1.2_2019"
}

variable "Version" {
  description = "Version"
  type        = string
  default     = "2008-10-17"
}
