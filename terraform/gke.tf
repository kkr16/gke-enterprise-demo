
resource "google_container_cluster" "cluster" {
  provider = google-beta
  for_each            = var.regions
  name                = each.value.region_name
  location            = each.key
  deletion_protection = false
  
  remove_default_node_pool = true
  initial_node_count       = 3

  network    = google_compute_network.vpc_network.id
  subnetwork = google_compute_subnetwork.subnet[each.key].id

  workload_identity_config {
    workload_pool = "${data.google_project.project.project_id}.svc.id.goog"
  }
  resource_labels = {
    mesh_id    = "proj-${data.google_project.project.number}"
    mci_config = var.mci_config_cluster == each.key ? true : false
  }
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
  gateway_api_config {
    channel = "CHANNEL_STANDARD"
  }
  addons_config {
    config_connector_config {
      enabled = true
    }
  }
  cluster_autoscaling {
    enabled = true
    resource_limits {
      resource_type = "cpu"
      minimum = 1
      maximum = 32
    }
    resource_limits {
      resource_type = "memory"
      minimum = 4
      maximum = 128
    }
    auto_provisioning_defaults {
      shielded_instance_config {
      enable_secure_boot          = true
      enable_integrity_monitoring = true
      }
    }
    
  }


  depends_on = [google_certificate_manager_certificate_map.bookinfo_certmap]
}


resource "google_container_node_pool" "sandbox_node_pool" {
  provider = google-beta
  for_each = google_container_cluster.cluster
  name     = "${each.value.name}-sandbox-nodepool"
  location = each.value.location
  cluster  = google_container_cluster.cluster[each.key].id

  initial_node_count = 1

  autoscaling {
    total_min_node_count = 1
    total_max_node_count = 3
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
    sandbox_config {
      sandbox_type = "gvisor"
    }

  }

}