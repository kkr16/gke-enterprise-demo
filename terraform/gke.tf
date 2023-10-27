
resource "google_container_cluster" "cluster" {
  for_each            = var.regions
  name                = each.value.region_name
  location            = each.key
  deletion_protection = false
  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  network    = google_compute_network.vpc_network.id
  subnetwork = google_compute_subnetwork.subnet[each.key].id

  node_config {
    shielded_instance_config {
      enable_secure_boot          = true
      enable_integrity_monitoring = true
    }

  }
  private_cluster_config {
    enable_private_nodes   = true
    master_ipv4_cidr_block = each.value.master_ipv4_cidr_block
  }
}

resource "google_container_node_pool" "primary_node_pool" {
  for_each = var.regions
  name     = "${each.value.region_name}-nodepool"
  location = each.key
  cluster  = google_container_cluster.cluster[each.key].id

  autoscaling {
    total_min_node_count = 3
    total_max_node_count = 10
    location_policy      = "BALANCED"
  }
  node_config {

    labels = {
      env = var.project_id
    }

    machine_type = "e2-standard-2"
    metadata = {
      disable-legacy-endpoints = "true"
    }

    shielded_instance_config {
      enable_secure_boot          = true
      enable_integrity_monitoring = true
    }

  }
}
