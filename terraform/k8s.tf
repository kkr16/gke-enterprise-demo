# # Retrieve an access token as the Terraform runner
# data "google_client_config" "provider" {}


# provider "kubernetes" {
#   host  = "https://${google_container_cluster.cluster[var.mci_config_cluster].endpoint}"
#   token = data.google_client_config.provider.access_token
#   cluster_ca_certificate = base64decode(
#     google_container_cluster.cluster[var.mci_config_cluster].master_auth[0].cluster_ca_certificate,
#   )
# }

# resource "kubernetes_labels" "mci_config" {
#   api_version = "clusterregistry.k8s.io/v1alpha1"
#   kind        = "Cluster"
#   metadata {
#     name = google_container_cluster.cluster[var.mci_config_cluster].name
#   }
#   labels = {
#     "mci_config" = "true"
#   }
# }
