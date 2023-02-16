variable "environment" {
  type = string
}

variable "aws_access_key" {
  type      = string
  sensitive = true
}

variable "aws_secret_key" {
  type      = string
  sensitive = true
}

variable "region" {
  type = string
}

variable "cpu" {
  type    = number
  default = 2048
}

variable "memory" {
  type    = number
  default = 4096
}

variable "desired_count" {
  type = number
}

variable "image_tag" {
  type = string
}

variable "db_user" {
  type      = string
  sensitive = true
}

variable "db_pass" {
  type      = string
  sensitive = true
}

variable "api_key" {
  type      = string
  sensitive = true
}

variable "redis_endpoint" {
  type      = string
  sensitive = true
}

variable "elastic_endpoint" {
  type      = string
  sensitive = true
}

variable "kafka_brokers" {
  type      = string
  sensitive = true
}

variable "intent_resolver_api_url" {
  type      = string
  sensitive = true
}

variable "intent_resolver_api_key" {
  type      = string
  sensitive = true
}

variable "needs_resolver_api_url" {
  type      = string
  sensitive = true
}

variable "needs_resolver_api_key" {
  type      = string
  sensitive = true
}