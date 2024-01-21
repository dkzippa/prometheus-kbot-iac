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
    default = "prometheus-kbot-iac-by-fluxcd"
    nullable = false
    description = "Flux infra repo"
}

variable "FLUX_GITHUB_TARGET_PATH" {
    type        = string
    default     = "clusters"
    description = "Flux manifests subdirectory"
}

variable "GOOGLE_REGION" {
    type        = string
    default     = "europe-central2-b"
    description = "Google region"
}

variable "GOOGLE_PROJECT" {
    type        = string
    default     = "prometheus-407701"
    description = "Google project"
}

variable "GKE_MACHINE_TYPE" {
    type        = string
    default     = "n1-standard-2"
    description = "Google GKE node vm type"
}
