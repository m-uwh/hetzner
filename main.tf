resource "hcloud_ssh_key" "root" {
  name       = local.kube_cluster_name
  public_key = var.HCLOUD_SSH_ROOT_PUBLIC_KEY
}

resource "hcloud_network" "network" {
  name     = local.kube_cluster_name
  ip_range = local.ip_range
}

resource "hcloud_network_subnet" "network_subnet" {
  network_id   = hcloud_network.network.id
  type         = "server"
  network_zone = local.network_zone
  ip_range     = local.ip_range
}

resource "hcloud_server" "kube_control_plane" {
  count       = local.kube_control_plane_count
  name        = local.kube_hostname
  server_type = local.hetzner_server_type
  image       = local.hetzner_image
  location    = local.hetzner_datacenter
  user_data   = data.template_file.cloud_init.rendered

  network {
    network_id = hcloud_network.network.id
  }

  ssh_keys = [
    hcloud_ssh_key.root.id
  ]

  # **Note**: the depends_on is important when directly attaching the
  # server to a network. Otherwise Terraform will attempt to create
  # server and sub-network in parallel. This may result in the server
  # creation failing randomly.
  depends_on = [
    hcloud_network_subnet.network_subnet
  ]
}
