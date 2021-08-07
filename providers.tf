provider "hcloud" {
}

provider "rancher2" {
  alias = "admin"

  api_url   = rancher2_bootstrap.admin.url
  token_key = rancher2_bootstrap.admin.token
  insecure  = true
}

provider "rke" {
}

provider "helm" {
  kubernetes {
    config_path = local_file.kube_cluster_yaml.filename
  }
}
