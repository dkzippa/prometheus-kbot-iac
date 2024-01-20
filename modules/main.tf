# provider "kind" {
# }
# resource "kind_cluster" "default" {
#     name = "kbot-tf-flux"
#     wait_for_ready = true
#     kind_config {
#         kind = "Cluster"
#         api_version = "kind.x-k8s.io/v1alpha4"

#         node {
#             role = "control-plane"
#         }
#         node {
#             role = "worker"
#         }
#     }
# }

module "kind_cluster" {
    source                   = "github.com/dkzippa/tf-kind-cluster-custom"
    cluster_name             = var.CLUSTER_NAME
}

module "github_repository" {
    source                   = "github.com/den-vasyliev/tf-github-repository"
    github_owner             = var.GITHUB_OWNER
    github_token             = var.GITHUB_TOKEN
    repository_name          = var.FLUX_GITHUB_REPO
    public_key_openssh       = module.tls_private_key.public_key_openssh
    public_key_openssh_title = "flux"
}


# module "kind_cluster" {
#     source = "github.com/den-vasyliev/tf-kind-cluster"
# }

module "tf-fluxcd-bootstrap" {
    source            = "github.com/den-vasyliev/tf-fluxcd-flux-bootstrap"
    private_key       = module.tls_private_key.private_key_pem
    github_repository = "${var.GITHUB_OWNER}/${var.FLUX_GITHUB_REPO}"
    github_token      = var.GITHUB_TOKEN
    # config_path       = module.kind_cluster.kubeconfig
    config_path       = "./${var.CLUSTER_NAME}-config"
}


module "tls_private_key" {
    source = "github.com/den-vasyliev/tf-hashicorp-tls-keys"
    algorithm   = var.tls-algorithm
}

