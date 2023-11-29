resource "google_project_iam_member" "default_sa" {
  project    = var.project_id
  role       = "roles/owner"
  member     = "serviceAccount:${data.google_project.project.number}-compute@developer.gserviceaccount.com"
  depends_on = [google_project_service.service["compute.googleapis.com"]]
}

resource "time_sleep" "wait_30_seconds" {
  depends_on = [
    google_gke_hub_feature.mesh,
    google_project_service.service,
    google_container_cluster.cluster,
    google_gke_hub_feature_membership.mesh_feature_member
  ]

  create_duration = "30s"
}


resource "google_project_iam_member" "mesh_serviceagent" {
  project = var.project_id
  role    = "roles/anthosservicemesh.serviceAgent"
  member  = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-servicemesh.iam.gserviceaccount.com"

  depends_on = [ time_sleep.wait_30_seconds ]
}

resource "google_project_iam_member" "mci_serviceagent" {
  project = var.project_id
  role    = "roles/container.admin"
  member  = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-multiclusteringress.iam.gserviceaccount.com"
  depends_on = [google_gke_hub_feature.mci_feature,
  google_project_service.service["multiclusteringress.googleapis.com"]]
}