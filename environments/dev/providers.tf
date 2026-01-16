terraform {
  required_providers {
    google = {
        source = "hashicorp/google"
        version = "~> 5.0"
    }
  }

  backend "gcs" {
    bucket = "learn-2612-tf-state"
    prefix = "environments/dev/terraform.tfstate"
  }
}

provider "google" {
    project = var.project_id
    region = var.region
}