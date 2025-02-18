terraform {
  required_providers {
    exoscale = {
      source  = "exoscale/exoscale"
      version = "~> 0.62.3"
    }
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
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4.0"
    }
  }
  required_version = ">= 1.0.0"
}

provider "exoscale" {
  key    = var.exoscale_api_key
  secret = var.exoscale_api_secret
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

resource "local_file" "kubeconfig" {
  content  = module.sks_cluster.kubeconfig
  filename = "${path.root}/kubeconfig"
}

provider "kubernetes" {
  config_path = local_file.kubeconfig.filename
}

provider "helm" {
  kubernetes {
    config_path = local_file.kubeconfig.filename
  }
}

provider "kubectl" {
  config_path = local_file.kubeconfig.filename
}

