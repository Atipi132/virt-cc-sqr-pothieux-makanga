terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "6.12.0"
    }
  }
}

provider "google" {
  project = "testtest"
  region  = "europe-west9"
}

resource "google_compute_network" "vpc_1"{
    name= "vpc-1"
}

resource "google_compute_instance" "vm_pc1"{
    name= "vm-pc1"
    machine_type = "n2-standard-2"
    boot_disk {
      initialize_params {
        image = "debian-cloud/debian-11"
      }
    }

    network_interface {
      network = "default"
      access_config {
      }
    }
}

resource "google_sql_database_instance" "vbdd_1" {
  name = "vbdd-1"
  region = "europe-west9"
  database_version = "MYSQL_5_7"

  settings {
    tier = "db-f1-micro"
  }
}
resource "google_dns_managed_zone" "prod" {
  name     = "prod-zone"
  dns_name = "prod.mydomain.com."
}

resource "google_dns_record_set" "frontend" {
  name = "frontend.${google_dns_managed_zone.prod.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = google_dns_managed_zone.prod.name

  rrdatas = [google_compute_instance.vm_pc1.network_interface[0].access_config[0].nat_ip]
}