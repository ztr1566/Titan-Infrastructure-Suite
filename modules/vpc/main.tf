resource "google_project_service" "servicenetworking" {
  service            = "servicenetworking.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "sqladmin" {
  service            = "sqladmin.googleapis.com"
  disable_on_destroy = false
}

resource "google_compute_network" "my_network" {
  name                    = var.network_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "public_subnet" {
  name          = var.public_subnet_name
  network       = google_compute_network.my_network.id
  ip_cidr_range = var.public_subnet_cidr
  region        = var.region
}

resource "google_compute_subnetwork" "private_subnet" {
  name          = var.private_subnet_name
  network       = google_compute_network.my_network.id
  ip_cidr_range = var.private_subnet_cidr
  region        = var.region
}

resource "google_compute_router" "my_router" {
  name    = "${var.network_name}-router"
  network = google_compute_network.my_network.id
  region  = var.region
}

resource "google_compute_router_nat" "nat_gateway" {
  name                               = "${var.network_name}-nat"
  router                             = google_compute_router.my_router.name
  region                             = google_compute_router.my_router.region
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  nat_ip_allocate_option             = "AUTO_ONLY"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

resource "google_compute_global_address" "private_ip_address" {
  name          = "google-managed-services-${google_compute_network.my_network.name}"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.my_network.id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.my_network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
  depends_on              = [google_project_service.servicenetworking]
}
