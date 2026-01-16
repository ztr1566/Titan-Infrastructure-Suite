data "google_compute_image" "my_image" {
  family  = "debian-11"
  project = "debian-cloud"
}

module "public_instance" {
  source           = "../../modules/instances"
  subnet_id        = module.vpc.public_subnet_id
  zone             = "europe-west3-c"
  instance_name    = "${var.env_prefix}-public-vm"
  machine_type     = "e2-micro"
  image            = data.google_compute_image.my_image.self_link
  assign_public_ip = true
  target_tags      = ["allow-iap"]
  db_host          = ""
}

module "private_instance" {
  source           = "../../modules/instances"
  subnet_id        = module.vpc.private_subnet_id
  zone             = "europe-west3-a"
  instance_name    = "${var.env_prefix}-private-vm"
  machine_type     = "e2-micro"
  image            = data.google_compute_image.my_image.self_link
  assign_public_ip = false
  target_tags      = ["allow-iap"]
  db_host          = ""
}

module "vpc" {
  source              = "../../modules/vpc"
  network_name        = "${var.env_prefix}-network"
  network_cidr        = "172.16.0.0/16"
  region              = var.region
  public_subnet_name  = "${var.env_prefix}-public-subnet"
  public_subnet_cidr  = "172.16.0.0/24"
  private_subnet_name = "${var.env_prefix}-private-subnet"
  private_subnet_cidr = "172.16.1.0/24"
}

module "database" {
  source         = "../../modules/db"
  env_name       = "dev"
  region         = var.region
  vpc_id         = module.vpc.vpc_id
  vpc_connection = module.vpc.vpc_connection_id
  db_password    = var.db_password

  authorized_service_accounts = {
    "private-vm" = module.private_instance.service_account_email,
    "backend-vm" = module.backend_vm.service_account_email
  }
}

module "backend_vm" {
  source           = "../../modules/instances"
  instance_name    = "backend-server"
  subnet_id        = module.vpc.private_subnet_id
  zone             = "europe-west3-a"
  machine_type     = "e2-micro"
  image            = data.google_compute_image.my_image.self_link
  assign_public_ip = false
  target_tags      = ["allow-iap"]
  db_host          = module.database.db_instance_private_ip
}
