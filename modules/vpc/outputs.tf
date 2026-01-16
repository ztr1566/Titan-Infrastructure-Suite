output "vpc_id" {
  value = google_compute_network.my_network.id
}

output "public_subnet_id" {
  value = google_compute_subnetwork.public_subnet.id
}

output "private_subnet_id" {
  value = google_compute_subnetwork.private_subnet.id
}

output "vpc_connection_id" {
  value = google_service_networking_connection.private_vpc_connection.id
}