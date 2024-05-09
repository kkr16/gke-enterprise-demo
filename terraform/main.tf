terraform {
  backend "gcs" {
    bucket = "gke-demo-ec92_tfstate"
  }
}

data "google_project" "project" {
  project_id = var.project_id
}

provider "google" {
  project = var.project_id
}

provider "google-beta" {
  project = var.project_id
}