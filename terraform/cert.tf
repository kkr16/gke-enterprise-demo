resource "google_certificate_manager_certificate" "default" {
  name        = "bookinfo-cert"
  scope       = "DEFAULT"
  managed {
    domains = [
      google_certificate_manager_dns_authorization.bookinfo.domain,
      ]
    dns_authorizations = [
      google_certificate_manager_dns_authorization.bookinfo.id,
      ]
  }
}

resource "google_certificate_manager_dns_authorization" "bookinfo" {
  name        = "dns-auth"
  domain      = "bookinfo.${var.fqdn_suffix}"
  depends_on = [ 
    google_project_service.service["certificatemanager.googleapis.com"]
    ]
}

resource "google_dns_record_set" "managed_cert_record" {
  name = google_certificate_manager_dns_authorization.bookinfo.dns_resource_record.0.name
  type = google_certificate_manager_dns_authorization.bookinfo.dns_resource_record.0.type
  ttl  = 300

  managed_zone = data.google_dns_managed_zone.env_dns_zone.name

  rrdatas = [google_certificate_manager_dns_authorization.bookinfo.dns_resource_record.0.data]
}

resource "google_certificate_manager_certificate_map" "bookinfo_certmap" {
  name        = "bookinfo-certmap"
}

resource "google_certificate_manager_certificate_map_entry" "bookinfo_entry" {
  name        = "bookinfo-mapentry"
  map = google_certificate_manager_certificate_map.bookinfo_certmap.name 
  certificates = [google_certificate_manager_certificate.default.id]
  matcher = "PRIMARY"
}
