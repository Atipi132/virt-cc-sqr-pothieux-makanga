# README for the Terraform part of the project
# Foundation - Infrastructure as Code

This directory contains the **Terraform** code used to provision the necessary infrastructure on **Scaleway**.

## Infrastructure Overview

We use the Scaleway Terraform provider to create a complete environment hosted in France (Region: `fr-par`).

### Resources Created

Based on the `main.tf` file, the following resources are provisioned:

* **Container Registry:**
    * `scaleway_registry_namespace`: A private registry named `main-cr` to store our Docker images.
* **Network:**
    * `scaleway_vpc_private_network`: A private network to isolate our cluster and databases.
* **Kubernetes Cluster:**
    * `scaleway_k8s_cluster`: A Kapsule cluster (version 1.32.3) using Cilium CNI.
    * `scaleway_k8s_pool`: A node pool using `DEV1-M` instances.
* **Databases:**
    * `scaleway_rdb_instance`: A PostgreSQL instance (`db-dev-s`) configured for High Availability (HA).
    * `scaleway_rdb_database`: Two logical databases created: `development` and `production`.
* **Load Balancers:**
    * Two Load Balancers (`development` and `production`) with dedicated IPs in `fr-par-1`.
* **DNS Records:**
    * Configuration of `A` records pointing to the Load Balancers:
        * `calculatrice-POTIEUX-MAKANGA.polytech-dijon.kiowy.net` (Prod)
        * `calculatrice-dev-POTIEUX-MAKANGA.polytech-dijon.kiowy.net` (Dev)

The result of _terraform plan_ is :


Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # scaleway_domain_record.development will be created
  + resource "scaleway_domain_record" "development" {
      + data       = (known after apply)
      + dns_zone   = "polytech-dijon.kiowy.net"
      + fqdn       = (known after apply)
      + id         = (known after apply)
      + name       = "calculatrice-dev-POTIEUX-MAKANGA"
      + priority   = (known after apply)
      + project_id = (known after apply)
      + root_zone  = (known after apply)
      + ttl        = 3600
      + type       = "A"
    }

  # scaleway_domain_record.production will be created
  + resource "scaleway_domain_record" "production" {
      + data       = (known after apply)
      + dns_zone   = "polytech-dijon.kiowy.net"
      + fqdn       = (known after apply)
      + id         = (known after apply)
      + name       = "calculatrice-POTIEUX-MAKANGA"
      + priority   = (known after apply)
      + project_id = (known after apply)
      + root_zone  = (known after apply)
      + ttl        = 3600
      + type       = "A"
    }

  # scaleway_k8s_cluster.cluster will be created
  + resource "scaleway_k8s_cluster" "cluster" {
      + apiserver_url               = (known after apply)
      + cni                         = "cilium"
      + created_at                  = (known after apply)
      + delete_additional_resources = false
      + id                          = (known after apply)
      + kubeconfig                  = (sensitive value)
      + name                        = "tf-cluster"
      + organization_id             = (known after apply)
      + pod_cidr                    = (known after apply)
      + private_network_id          = (known after apply)
      + project_id                  = (known after apply)
      + service_cidr                = (known after apply)
      + service_dns_ip              = (known after apply)
      + status                      = (known after apply)
      + type                        = (known after apply)
      + updated_at                  = (known after apply)
      + upgrade_available           = (known after apply)
      + version                     = "1.32.3"
      + wildcard_dns                = (known after apply)

      + auto_upgrade (known after apply)

      + autoscaler_config (known after apply)

      + open_id_connect_config (known after apply)
    }

  # scaleway_k8s_pool.pool will be created
  + resource "scaleway_k8s_pool" "pool" {
      + autohealing            = false
      + autoscaling            = false
      + cluster_id             = (known after apply)
      + container_runtime      = "containerd"
      + created_at             = (known after apply)
      + current_size           = (known after apply)
      + id                     = (known after apply)
      + max_size               = (known after apply)
      + min_size               = 1
      + name                   = "tf-pool"
      + node_type              = "DEV1-M"
      + nodes                  = (known after apply)
      + public_ip_disabled     = false
      + root_volume_size_in_gb = (known after apply)
      + root_volume_type       = (known after apply)
      + security_group_id      = (known after apply)
      + size                   = 1
      + status                 = (known after apply)
      + updated_at             = (known after apply)
      + version                = (known after apply)
      + wait_for_pool_ready    = true

      + upgrade_policy (known after apply)
    }

  # scaleway_lb.development will be created
  + resource "scaleway_lb" "development" {
      + external_private_networks = false
      + id                        = (known after apply)
      + ip_address                = (known after apply)
      + ip_id                     = (known after apply)
      + ip_ids                    = [
          + (known after apply),
        ]
      + ipv6_address              = (known after apply)
      + name                      = (known after apply)
      + organization_id           = (known after apply)
      + private_ips               = (known after apply)
      + project_id                = (known after apply)
      + region                    = (known after apply)
      + ssl_compatibility_level   = "ssl_compatibility_level_intermediate"
      + type                      = "LB-S"

      + private_network (known after apply)
    }

  # scaleway_lb.production will be created
  + resource "scaleway_lb" "production" {
      + external_private_networks = false
      + id                        = (known after apply)
      + ip_address                = (known after apply)
      + ip_id                     = (known after apply)
      + ip_ids                    = [
          + (known after apply),
        ]
      + ipv6_address              = (known after apply)
      + name                      = (known after apply)
      + organization_id           = (known after apply)
      + private_ips               = (known after apply)
      + project_id                = (known after apply)
      + region                    = (known after apply)
      + ssl_compatibility_level   = "ssl_compatibility_level_intermediate"
      + type                      = "LB-S"

      + private_network (known after apply)
    }

  # scaleway_lb_ip.dev will be created
  + resource "scaleway_lb_ip" "dev" {
      + id              = (known after apply)
      + ip_address      = (known after apply)
      + is_ipv6         = false
      + lb_id           = (known after apply)
      + organization_id = (known after apply)
      + project_id      = (known after apply)
      + region          = (known after apply)
      + reverse         = (known after apply)
    }

  # scaleway_lb_ip.prod will be created
  + resource "scaleway_lb_ip" "prod" {
      + id              = (known after apply)
      + ip_address      = (known after apply)
      + is_ipv6         = false
      + lb_id           = (known after apply)
      + organization_id = (known after apply)
      + project_id      = (known after apply)
      + region          = (known after apply)
      + reverse         = (known after apply)
    }

  # scaleway_rdb_database.development will be created
  + resource "scaleway_rdb_database" "development" {
      + id          = (known after apply)
      + instance_id = (known after apply)
      + managed     = (known after apply)
      + name        = "development"
      + owner       = (known after apply)
      + size        = (known after apply)
    }

  # scaleway_rdb_database.production will be created
  + resource "scaleway_rdb_database" "production" {
      + id          = (known after apply)
      + instance_id = (known after apply)
      + managed     = (known after apply)
      + name        = "production"
      + owner       = (known after apply)
      + size        = (known after apply)
    }

  # scaleway_rdb_instance.main will be created
  + resource "scaleway_rdb_instance" "main" {
      + backup_same_region        = (known after apply)
      + backup_schedule_frequency = (known after apply)
      + backup_schedule_retention = (known after apply)
      + certificate               = (known after apply)
      + disable_backup            = false
      + endpoint_ip               = (known after apply)
      + endpoint_port             = (known after apply)
      + engine                    = "PostgreSQL-15"
      + id                        = (known after apply)
      + is_ha_cluster             = true
      + name                      = "test-rdb"
      + node_type                 = "DB-DEV-S"
      + organization_id           = (known after apply)
      + password                  = (sensitive value)
      + project_id                = (known after apply)
      + read_replicas             = (known after apply)
      + settings                  = (known after apply)
      + upgradable_versions       = (known after apply)
      + user_name                 = "user"
      + volume_size_in_gb         = (known after apply)
      + volume_type               = "lssd"

      + logs_policy (known after apply)

      + private_ip (known after apply)
    }

  # scaleway_registry_namespace.main will be created
  + resource "scaleway_registry_namespace" "main" {
      + description     = "Main container registry"
      + endpoint        = (known after apply)
      + id              = (known after apply)
      + is_public       = false
      + name            = "main-cr"
      + organization_id = (known after apply)
      + project_id      = (known after apply)
    }

  # scaleway_vpc_private_network.pn will be created
  + resource "scaleway_vpc_private_network" "pn" {
      + created_at                       = (known after apply)
      + enable_default_route_propagation = (known after apply)
      + id                               = (known after apply)
      + is_regional                      = (known after apply)
      + name                             = (known after apply)
      + organization_id                  = (known after apply)
      + project_id                       = (known after apply)
      + updated_at                       = (known after apply)
      + vpc_id                           = (known after apply)
      + zone                             = (known after apply)

      + ipv4_subnet (known after apply)

      + ipv6_subnets (known after apply)
    }

Plan: 13 to add, 0 to change, 0 to destroy.
