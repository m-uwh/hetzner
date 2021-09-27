resource "random_id" "id" {
  byte_length = 8
}

locals {
  kube_cluster_name        = "first"
  kube_control_plane_count = 1
  kube_hostname            = "${local.kube_cluster_name}-${random_id.id.hex}"

  hetzner_server_type = "cx21"
  hetzner_image       = "ubuntu-20.04"
  hetzner_datacenter  = "nbg1"
  hetzener_ssh_user   = "root"

  ip_range     = "192.168.0.0/16"
  network_zone = "eu-central"
  domain       = "uwannah.com"
}