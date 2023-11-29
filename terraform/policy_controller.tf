# resource "google_service_account" "gatekeeper" {
#   account_id   = "gke-gatekeeper"
#   display_name = "Service Account for WIF"
# }

# resource "google_service_account_iam_member" "gatekeeper" {
#   service_account_id = google_service_account.gatekeeper.name
#   role               = "roles/iam.workloadIdentityUser"
#   member             = "serviceAccount:${var.project_id}.svc.id.goog[gatekeeper-system/gatekeeper-admin]"
# }
resource "google_project_iam_member" "gatekeeper_metricwriter" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${var.project_id}.svc.id.goog[gatekeeper-system/gatekeeper-admin]"
  depends_on = [ google_container_cluster.cluster ]
}

resource "google_project_iam_member" "config-mgmt_metricwriter" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${var.project_id}.svc.id.goog[config-management-monitoring/default]"
  depends_on = [ google_container_cluster.cluster ]
}

resource "google_project_iam_member" "gke-mcs_networkviewer" {
  project = var.project_id
  role    = "roles/compute.networkViewer"
  member  = "serviceAccount:${var.project_id}.svc.id.goog[gke-mcs/gke-mcs-importer]"
  depends_on = [ google_container_cluster.cluster ]
}
