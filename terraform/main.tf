# SKS Cluster
module "sks_cluster" {
  source = "./modules/sks"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  zone           = var.zone
  node_pools     = var.node_pools
}

# Database
module "database" {
  source = "./modules/database"

  zone           = var.zone
  database       = var.database
  db_password    = var.db_password
}

# Kubernetes Resources
module "kubernetes_resources" {
  source = "./modules/kubernetes"

  depends_on = [
    module.sks_cluster,
    module.database
  ]

  grafana_admin_password = var.grafana_admin_password
  db_host               = module.database.uri
  db_port               = module.database.port
  db_name               = module.database.name
  db_user               = module.database.user
  db_password           = var.db_password
  letsencrypt_email     = var.letsencrypt_email
  cloudflare_zone_id    = var.cloudflare_zone_id
  domain_name           = var.domain_name
  cloudflare_api_token  = var.cloudflare_api_token
  cluster_name          = var.cluster_name
  zone                  = var.zone
  instance_pool_size  = 2
} 