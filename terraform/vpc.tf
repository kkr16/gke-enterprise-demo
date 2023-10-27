resource "google_compute_network" "vpc_network" {
  name                    = "vpc"
  auto_create_subnetworks = false

  depends_on = [google_project_service.service]
}

resource "google_compute_subnetwork" "subnet" {
  for_each = var.regions

  name          = each.value.region_name
  ip_cidr_range = each.value.subnet_cidr
  region        = each.key
  network       = google_compute_network.vpc_network.id

}

