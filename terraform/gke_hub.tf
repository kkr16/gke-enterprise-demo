resource "google_gke_hub_feature" "acm" {
  project    = var.project_id
  name       = "configmanagement"
  location   = "global"
  depends_on = [google_project_service.service]
}

resource "google_gke_hub_fleet" "default" {
  project = var.project_id

  depends_on = [google_project_service.service["gkehub.googleapis.com"]]
}

resource "google_gke_hub_membership" "membership" {
  for_each      = google_container_cluster.cluster
  membership_id = each.value.name
  endpoint {
    gke_cluster {
      resource_link = "//container.googleapis.com/${google_container_cluster.cluster[each.key].id}"
    }
  }
  depends_on = [google_gke_hub_fleet.default,
  google_container_cluster.cluster]
}

resource "google_gke_hub_feature_membership" "feature_member" {
  for_each   = google_gke_hub_membership.membership
  location   = "global"
  feature    = google_gke_hub_feature.acm.name
  membership = each.value.membership_id
  configmanagement {
    config_sync {
      git {
        sync_repo   = "https://github.com/kkr16/gke-enterprise-demo.git"
        sync_branch = "main"
        policy_dir  = "config/rootsync"
        secret_type = "none"
      }
      source_format = "unstructured"
    }
    policy_controller {
      enabled                    = true
      template_library_installed = true
      referential_rules_enabled  = true
    }
  }
depends_on = [ google_container_cluster.cluster ]
}

resource "google_gke_hub_feature" "mesh" {
  name     = "servicemesh"
  location = "global"

  provider = google-beta

  depends_on = [google_project_service.service,
    google_gke_hub_membership.membership
  ]

}

resource "google_gke_hub_feature_membership" "mesh_feature_member" {
  for_each = google_gke_hub_membership.membership

  location   = "global"
  feature    = google_gke_hub_feature.mesh.name
  membership = each.value.membership_id
  mesh {
    management = "MANAGEMENT_AUTOMATIC"
  }
  provider = google-beta

  depends_on = [google_gke_hub_feature.mesh]
}

resource "google_gke_hub_feature" "mcs_feature" {
  name       = "multiclusterservicediscovery"
  location   = "global"
  depends_on = [google_project_service.service]
}

resource "google_gke_hub_feature" "mci_feature" {
  count    = length(var.regions) > 0 ? 1 : 0
  name     = "multiclusteringress"
  location = "global"
  spec {
    multiclusteringress {
      config_membership = google_gke_hub_membership.membership[var.mci_config_cluster].id
    }
  }
  depends_on = [google_gke_hub_feature_membership.feature_member,
  google_project_service.service]
}
