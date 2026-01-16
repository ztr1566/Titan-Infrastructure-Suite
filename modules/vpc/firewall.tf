resource "google_compute_firewall" "allow_iap_ports" {
  name    = "${var.network_name}-firewall-iap-ports"
  network = google_compute_network.my_network.id
  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443"]
  }

  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["allow-iap"]
}

resource "google_compute_firewall" "allow_internal" {
  name    = "${var.network_name}-firewall-internal"
  network = google_compute_network.my_network.id
  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  source_ranges = [var.network_cidr]
}

