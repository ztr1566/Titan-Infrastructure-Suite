variable "project_id" { type = string }
variable "region" { type = string }
variable "env_prefix" { type = string }

variable "db_password" {
  type      = string
  sensitive = true
}
