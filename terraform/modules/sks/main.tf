resource "exoscale_sks_cluster" "cluster" {
  name           = var.cluster_name
  version        = var.cluster_version
  zone           = var.zone
  service_level  = "starter" # cheaper option
  cni           = "calico" # simpel enough for our workloads
  
  auto_upgrade = true
  exoscale_ccm = true 
  metrics_server = true
}



resource "exoscale_sks_nodepool" "nodepool" {
  for_each = var.node_pools

  cluster_id          = exoscale_sks_cluster.cluster.id
  name                = each.key
  instance_type       = each.value.size
  size                = each.value.node_count
  disk_size          = each.value.disk_size
  description        = each.value.description
  zone               = var.zone

  security_group_ids = [
    exoscale_security_group.nodepool.id
  ]

  instance_prefix = "node"

  labels = {
    "role" = each.key
  }

  depends_on = [
    exoscale_security_group.nodepool
  ]
}

resource "exoscale_sks_kubeconfig" "kubeconfig" {
  cluster_id = exoscale_sks_cluster.cluster.id
  zone       = var.zone
  user       = "kubernetes-admin"
  groups     = ["system:masters"]
}

resource "exoscale_security_group" "nodepool" {
  name = "${var.cluster_name}-nodepool"
}

