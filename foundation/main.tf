

terraform {
  required_providers {
    scaleway = {
      source = "scaleway/scaleway"
    }
  }
  required_version = ">= 0.13"
}


resource "scaleway_registry_namespace" "main" {
  name        = "main-cr"
  description = "Main container registry"
  is_public   = false
}

resource "scaleway_vpc_private_network" "pn" {}

resource "scaleway_k8s_cluster" "cluster" {
  name                        = "tf-cluster"
  version                     = "1.32.3"
  cni                         = "cilium"
  private_network_id          = scaleway_vpc_private_network.pn.id
  delete_additional_resources = false
}

resource "scaleway_k8s_pool" "pool" {
  cluster_id = scaleway_k8s_cluster.cluster.id
  name       = "tf-pool"
  node_type  = "DEV1-M"
  size       = 1
}

resource "scaleway_rdb_instance" "main" {
  name          = "test-rdb"
  node_type     = "DB-DEV-S"
  engine        = "PostgreSQL-15"
  is_ha_cluster = true
  user_name     = "user"
  password      = "s3cret"
}


resource "scaleway_lb_ip" "dev" {
  zone = "fr-par-1"
}

resource "scaleway_lb_ip" "prod" {
  zone = "fr-par-1"
}

resource "scaleway_lb" "development" {
  ip_ids = [scaleway_lb_ip.dev.id]
  zone   = "fr-par-1"
  type   = "LB-S"
}

resource "scaleway_lb" "production" {
  ip_ids = [scaleway_lb_ip.prod.id]
  zone   = "fr-par-1"
  type   = "LB-S"
}

resource "scaleway_rdb_database" "development" {
  instance_id = scaleway_rdb_instance.main.id
  name        = "development"
}

resource "scaleway_rdb_database" "production" {
  instance_id = scaleway_rdb_instance.main.id
  name        = "production"
}


resource "scaleway_domain_record" "production" {
  dns_zone = "polytech-dijon.kiowy.net"
  name     = "calculatrice-POTIEUX-MAKANGA"
  type     = "A"
  data     = scaleway_lb_ip.dev.ip_address
  ttl      = 3600
}


resource "scaleway_domain_record" "development" {
  dns_zone = "polytech-dijon.kiowy.net"
  name     = "calculatrice-dev-POTIEUX-MAKANGA"
  type     = "A"
  data     = scaleway_lb_ip.prod.ip_address
  ttl      = 3600
}





