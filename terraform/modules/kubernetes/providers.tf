terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.11.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.14.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.1.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.9.0"
    }
    exoscale = {
      source  = "exoscale/exoscale"
      version = "~> 0.62.3"
    }
  }
} 