resource "google_project_service" "service" {
  project = var.project_id
  for_each = toset([
    "compute.googleapis.com",
    "container.googleapis.com",
    "artifactregistry.googleapis.com",
    "gkehub.googleapis.com",
    "containersecurity.googleapis.com",
    "gkeconnect.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
    "anthosconfigmanagement.googleapis.com",
    "multiclusteringress.googleapis.com",
    "anthosconfigmanagement.googleapis.com",
    "multiclusterservicediscovery.googleapis.com",
    "meshconfig.googleapis.com",
    "anthos.googleapis.com",
    "mesh.googleapis.com"
  ])
  service = each.value
}
