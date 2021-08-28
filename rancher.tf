resource "null_resource" "run_ansible" {
  provisioner "local-exec" {
  command = "ansible-playbook -i ~/inventory ~/ansible/playbook.yml "
  }
  depends_on = [
    hetznerdns_record.rancher
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

