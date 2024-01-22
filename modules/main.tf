module "gke_cluster" {
    source              = "github.com/den-vasyliev/tf-google-gke-cluster"
    GOOGLE_REGION       = var.GOOGLE_REGION
    GOOGLE_PROJECT      = var.GOOGLE_PROJECT
    GKE_MACHINE_TYPE    = var.GKE_MACHINE_TYPE
    GKE_NUM_NODES       = 1
}


module "github_repository" {
    source                   = "github.com/den-vasyliev/tf-github-repository"
    github_owner             = var.GITHUB_OWNER
    github_token             = var.GITHUB_TOKEN
    repository_name          = var.FLUX_GITHUB_REPO
    public_key_openssh       = module.tls_private_key.public_key_openssh
    public_key_openssh_title = "flux"
}

module "tls_private_key" {
    source      = "github.com/den-vasyliev/tf-hashicorp-tls-keys"
    algorithm   = var.tls-algorithm
}

provider "flux" {
  kubernetes = {
    config_path = module.gke_cluster.kubeconfig
  }
  git = {
    url = "https://github.com/${var.GITHUB_OWNER}/${var.FLUX_GITHUB_REPO}.git"
    http = {
      username = "git"
      password = var.GITHUB_TOKEN
    }
  }
}
resource "flux_bootstrap_git" "this" {
    depends_on = [ module.gke_cluster ]
    path = "clusters"
}
