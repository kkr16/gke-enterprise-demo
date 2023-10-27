resource "google_project_iam_member" "default_sa" {
  project = var.project_id
  role    = "roles/owner"
  member  = "serviceAccount:${data.google_project.project.number}-compute@developer.gserviceaccount.com"
}
