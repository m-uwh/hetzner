resource "random_id" "id" {
  byte_length = 8
}

locals {
  rancher_cluster_name = "rancher"
  rancher_version      = "v2.5.9"
  rancher_node_count   = 1
  rancher_hostname     = "${local.rancher_cluster_name}-${random_id.id.hex}"
  rancher_api_url      = "https://${local.rancher_hostname}.${local.domain}:8443"

  hetzner_server_type = "cx21"
  hetzner_image       = "ubuntu-20.04"
  hetzner_datacenter  = "nbg1"

  ip_range     = "192.168.0.0/16"
  network_zone = "eu-central"
  domain       = "uwannah.com"
}