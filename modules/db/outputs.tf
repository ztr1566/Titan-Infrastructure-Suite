output "db_instance_private_ip" {
  value = google_sql_database_instance.main.private_ip_address
}

output "db_instance_name" {
  value = google_sql_database_instance.main.name
}
