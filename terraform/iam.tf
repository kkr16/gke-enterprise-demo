resource "google_project_iam_member" "default_sa" {
  project = var.project_id
  role    = "roles/owner"
  member  = "serviceAccount:${data.google_project.project.number}-compute@developer.gserviceaccount.com"
}

resource "google_project_iam_member" "mesh_serviceagent" {
  project = var.project_id
  role    = "roles/anthosservicemesh.serviceAgent"
  member  = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-servicemesh.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "mci_serviceagent" {
  project = var.project_id
  role    = "roles/container.admin"
  member  = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-multiclusteringress.iam.gserviceaccount.com"
}