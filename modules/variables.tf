variable "tls-algorithm" {
    type = string
    default = "RSA"
}

variable "GITHUB_OWNER" {
    type = string
    nullable = false
}

variable "GITHUB_TOKEN" {
    type = string
    nullable = false
    sensitive = true
}

variable "FLUX_GITHUB_REPO" {
    type = string
    default = "generated-by-flux-prometheus-kbot"
    nullable = false
    description = "Flux infra repo"
}

variable "FLUX_GITHUB_TARGET_PATH" {
    type        = string
    default     = "clusters"
    description = "Flux manifests subdirectory"
}

variable "CLUSTER_NAME" {
    type        = string
    default     = "kind-flux-kbot"
    description = "Cluster name"
}
