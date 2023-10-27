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

resource "google_compute_router" "router" {
  for_each = var.regions
  name     = each.value.region_name
  network  = google_compute_network.vpc_network.id
  region   = each.key
}


resource "google_compute_router_nat" "nat" {
  for_each = var.regions

  name                               = each.value.region_name
  router                             = google_compute_router.router[each.key].name
  region                             = google_compute_router.router[each.key].region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

resource "google_compute_global_address" "global_ip" {
  name = "mcg-global-ip"
}

data "google_dns_managed_zone" "env_dns_zone" {
  name = "gkee"
}

resource "google_dns_record_set" "dns" {
  name = "bookinfo.${data.google_dns_managed_zone.env_dns_zone.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = data.google_dns_managed_zone.env_dns_zone.name

  rrdatas = [google_compute_global_address.global_ip.address]
}

