variable "env_name" {
  type = string
}

variable "region" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "vpc_connection" {
  type = any
}

variable "db_password" {
  type = string
  sensitive = true
}