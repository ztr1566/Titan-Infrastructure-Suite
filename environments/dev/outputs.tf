output "public_instance_public_ip" {
  value = module.public_instance.instance_public_ip
}

output "private_instance_private_ip" {
  value = module.private_instance.instance_private_ip
}
