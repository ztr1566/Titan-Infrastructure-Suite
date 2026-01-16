output "instance_public_ip" {
  value = try(google_compute_instance.vm.network_interface[0].access_config[0].nat_ip, null)
}

output "instance_private_ip" {
  value = try(google_compute_instance.vm.network_interface[0].network_ip, null)
}

output "db_host" {
  value = var.db_host
}