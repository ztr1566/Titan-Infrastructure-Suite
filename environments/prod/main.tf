data "google_compute_image" "my_image" {
  family  = "debian-11"
  project = "debian-cloud"
}

module "public_instance" {
  source           = "../../modules/instances"
  subnet_id        = module.vpc.public_subnet_id
  zone             = "europe-west1-b"
  instance_name    = "${var.env_prefix}-public-vm"
  machine_type     = "e2-medium"
  image            = data.google_compute_image.my_image.self_link
  assign_public_ip = true
}

module "private_instance" {
  source           = "../../modules/instances"
  subnet_id        = module.vpc.private_subnet_id
  zone             = "europe-west1-c"
  instance_name    = "${var.env_prefix}-private-vm"
  machine_type     = "e2-medium"
  image            = data.google_compute_image.my_image.self_link
  assign_public_ip = false
}

module "vpc" {
  source                 = "../../modules/vpc"
  network_name           = "${var.env_prefix}-network"
  region                 = var.region
  public_subnet_name     = "${var.env_prefix}-public-subnet"
  public_subnet_cidr     = "192.168.0.0/24"
  private_subnet_name    = "${var.env_prefix}-private-subnet"
  private_subnet_cidr    = "192.168.1.0/24"
  firewall_name          = "${var.env_prefix}-firewall"
  firewall_ports         = ["22", "80", "443"]
  firewall_source_ranges = ["0.0.0.0/0"]
}

