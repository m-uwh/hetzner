data "template_file" "cloud_init" {
  template = file("${path.module}/files/cloud-config.yaml")
  vars = {
    hcloud_ssh_warmichi_public_key  = var.hcloud_ssh_warmichi_public_key
  }
}