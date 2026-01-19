terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.8.0"
    }
  }
}

provider "google" {
  credentials = "./my-creds.json"
  project     = "instant-maxim-461311-p6"
  region      = "us-central1"
  zone        = "us-central1-c"
}

resource "google_storage_bucket" "demo-bucket" {
  name          = "instant-maxim-461311-p6-terra-bucket"
  location      = "US"
  force_destroy = true

  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
}

resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}
