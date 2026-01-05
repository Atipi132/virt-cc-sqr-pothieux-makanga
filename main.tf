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

resource "scaleway_registry_namespace" "main" {
  name        = "main-cr"
  description = "Main container registry"
  is_public   = false
}

//terraform import scaleway_registry_namespace.main fr-par/11111111-1111-1111-1111-111111111111


resource "scaleway_rdb_instance" "main" {
  name           = "test-rdb"
  node_type      = "DB-DEV-S"
  engine         = "PostgreSQL-15"
  is_ha_cluster  = true
  disable_backup = true
  user_name      = "my_initial_user"
  password       = "thiZ_is_v&ry_s3cret"
}

resource "scaleway_rdb_database" "main" {
  instance_id = scaleway_rdb_instance.main.id
  name        = "my-new-database"
}

//terraform import scaleway_rdb_database.rdb01_mydb fr-par/11111111-1111-1111-1111-111111111111/mydb


resource "scaleway_domain_record" "www" {
  dns_zone = "domain.tld"
  name     = "www"
  type     = "A"
  data     = "1.2.3.4"
  ttl      = 3600
}

resource "scaleway_lb_backend" "backend01" {
  lb_id            = scaleway_lb.lb01.id
  name             = "backend01"
  forward_protocol = "http"
  forward_port     = "80"

  health_check_http {
    uri = "/health"
  }
}

resource "scaleway_lb_ip" "ip01" {}

resource "scaleway_lb" "lb01" {
  ip_id = scaleway_lb_ip.ip01.id
  name  = "test-lb"
  type  = "lb-s"
}

resource "scaleway_lb_backend" "bkd01" {
  lb_id            = scaleway_lb.lb01.id
  forward_protocol = "tcp"
  forward_port     = 443
  proxy_protocol   = "none"
}

resource "scaleway_lb_certificate" "cert01" {
  lb_id = scaleway_lb.lb01.id
  name  = "test-cert-front-end"
  letsencrypt {
    common_name = "${replace(scaleway_lb_ip.ip01.ip_address, ".", "-")}.lb.${scaleway_lb.lb01.region}.scw.cloud"
  }
  # Make sure the new certificate is created before the old one can be replaced
  lifecycle {
    create_before_destroy = true
  }
}

resource "scaleway_lb_frontend" "frt01" {
  lb_id           = scaleway_lb.lb01.id
  backend_id      = scaleway_lb_backend.bkd01.id
  inbound_port    = 443
  certificate_ids = [scaleway_lb_certificate.cert01.id]
}