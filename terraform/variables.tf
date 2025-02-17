variable "exoscale_api_key" {
  description = "Exoscale API key"
  type        = string
  sensitive   = true
}

variable "exoscale_api_secret" {
  description = "Exoscale API secret"
  type        = string
  sensitive   = true
}

variable "cloudflare_api_token" {
  description = "Cloudflare API token with DNS edit permissions"
  type        = string
  sensitive   = true
}

variable "cloudflare_zone_id" {
  description = "Cloudflare Zone ID for your domain"
  type        = string
}

variable "domain_name" {
  description = "Your domain name (e.g., example.com)"
  type        = string
}

variable "zone" {
  description = "Exoscale zone"
  type        = string
  default     = "ch-gva-2"
}

variable "cluster_name" {
  description = "Name of the Kubernetes cluster"
  type        = string
  default     = "otel-demo-cluster"
}

variable "cluster_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.32.2"
}

variable "node_pools" {
  description = "Node pool configurations"
  type = map(object({
    size        = string
    node_count  = number
    disk_size   = number
    description = string
  }))
  default = {
    "general" = {
      size        = "standard.small"
      node_count  = 3
      disk_size   = 50
      description = "General purpose nodes"
    }
  }
}

variable "database" {
  description = "Database configuration"
  type = object({
    name           = string
    type           = string
    version        = string
    size          = string
    storage_size  = number
    node_count    = number
  })
  default = {
    name          = "otel-demo-db"
    type          = "pg"
    version       = "15"
    size          = "hobbyist-2"
    storage_size  = 10
    node_count    = 1
  }
}

variable "grafana_admin_password" {
  description = "Grafana admin password"
  type        = string
  default     = "admin123"
  sensitive   = true
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "letsencrypt_email" {
  description = "Email address for Let's Encrypt notifications"
  type        = string
} 