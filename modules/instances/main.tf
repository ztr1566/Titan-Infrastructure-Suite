resource "google_service_account" "vm_sa" {
  account_id   = "${var.instance_name}-sa"
  display_name = "Service Account for ${var.instance_name}"
}

resource "google_compute_instance" "vm" {
  name                      = var.instance_name
  machine_type              = var.machine_type
  zone                      = var.zone
  tags                      = var.target_tags
  deletion_protection       = false
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = var.image
    }
  }
  network_interface {
    subnetwork = var.subnet_id
    dynamic "access_config" {
      for_each = var.assign_public_ip ? [1] : []
      content {

      }
    }
  }

  service_account {
    email  = google_service_account.vm_sa.email
    scopes = ["cloud-platform"]
  }
}

