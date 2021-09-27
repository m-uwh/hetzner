resource "null_resource" "run_ansible" {
  triggers = {
    hcloud_server_ids = join(",", hcloud_server.kube_control_plane.*.id)
  }

  provisioner "local-exec" {
    command = "chmod 600 ${var.HCLOUD_SSH_ROOT_PRIVATE_KEY} && sleep 60 && ansible-playbook -i ${path.root}/inventory ${path.root}/ansible/playbook.yaml"
    environment = {
      ANSIBLE_PRIVATE_KEY_FILE  = "${var.HCLOUD_SSH_ROOT_PRIVATE_KEY}"
      ANSIBLE_HOST_KEY_CHECKING = "False"
    }
  }
  depends_on = [
    hetznerdns_record.kube_control_plane,
    hcloud_server.kube_control_plane,
  ]
}

# resource "null_resource" "wait_for_rancher" {
#   provisioner "local-exec" {
#     command = <<EOF
# while [ "$${resp}" != "pong" ]; do
#     resp=$(curl -sSk -m 2 "https://$${RANCHER_HOSTNAME}:8443/ping")
#     echo "Rancher Response: $${resp}"
#     if [ "$${resp}" != "pong" ]; then
#       sleep 10
#     fi
# done
# EOF


#     environment = {
#       RANCHER_HOSTNAME = "${local.rancher_hostname}.${local.domain}"
#     }
#   }
#   depends_on = [
#     hetznerdns_record.rancher
#   ]
# }

# resource "rancher2_bootstrap" "admin" {
#   provider   = rancher2.bootstrap
#   depends_on = [null_resource.wait_for_rancher]
#   password   = var.RANCHER_UI_PASSWORD
# }