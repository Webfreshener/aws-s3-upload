variable "region" {
  default = "AWS Bucket Region"
  type = "string"
}

variable "api_id" {
  description = "API Gateway identifier"
  type = string
}

# var.api_resource_id
variable "api_resource_id" {
  description = "API resource identifier"
  type = string
}

variable "path_part" {
  description = "API Path Part"
  type = string
  default = "upload"
}

variable "authorization" {
  description = "Method Authorization"
  type = string
  default = "NONE"
}

variable "create_bucket" {
  description = "Create S3 Bucket"
  type = string
  default = true
}
variable "s3_bucket_name" {

}

variable "object_prefix" {
  description = "S3 Bucket Object Prefix (eg: 'uploads')"
  type = string
  default = ""
}
