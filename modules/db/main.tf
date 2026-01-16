resource "google_project_service" "sqladmin" {
  project            = "learn-2612"
  service            = "sqladmin.googleapis.com"
  disable_on_destroy = false
}

resource "google_sql_database_instance" "main" {
  name                = "testing-db-${var.env_name}"
  database_version    = "MYSQL_8_0"
  region              = var.region
  depends_on          = [var.vpc_connection]
  deletion_protection = false
  settings {
    tier              = "db-f1-micro"
    activation_policy = "ALWAYS"
    ip_configuration {
      ipv4_enabled = true
    }
  }
}

resource "google_sql_database" "inventory_db" {
  name     = "inventory_db"
  instance = google_sql_database_instance.main.name
}



resource "google_sql_user" "db_user" {
  name     = "admin"
  instance = google_sql_database_instance.main.name
  host     = "%"
  password = var.db_password
}


resource "google_project_iam_member" "cloud_sql_client_sa" {
  for_each = var.authorized_service_accounts
  project  = "learn-2612"
  role     = "roles/cloudsql.client"
  member   = "serviceAccount:${each.value}"
}
