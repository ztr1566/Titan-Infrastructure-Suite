variable "instance_name" { type = string }
variable "machine_type" { type = string }
variable "zone" { type = string }
variable "image" { type = string }
variable "subnet_id" { type = string }
variable "assign_public_ip" {
  type    = bool
  default = false
}

variable "target_tags" {
  type        = list(string)
  default     = []
}

variable "db_host" {
  type = string
}