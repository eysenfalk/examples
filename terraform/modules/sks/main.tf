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

resource "exoscale_security_group_rule" "nodepool_ingress" {
  security_group_id = exoscale_security_group.nodepool.id
  type             = "INGRESS"
  protocol         = "tcp"
  cidr            = "0.0.0.0/0"
  start_port      = 30000
  end_port        = 32767
  description     = "Kubernetes NodePort Services"
}

resource "exoscale_security_group_rule" "nodepool_egress" {
  security_group_id = exoscale_security_group.nodepool.id
  type             = "EGRESS"
  protocol         = "tcp"
  cidr            = "0.0.0.0/0"
  start_port      = 1
  end_port        = 65535
  description     = "Allow all TCP egress traffic"
}

resource "exoscale_security_group_rule" "nodepool_egress_udp" {
  security_group_id = exoscale_security_group.nodepool.id
  type             = "EGRESS"
  protocol         = "udp"
  cidr            = "0.0.0.0/0"
  start_port      = 1
  end_port        = 65535
  description     = "Allow all UDP egress traffic"
}

resource "exoscale_security_group_rule" "nodepool_egress_icmp" {
  security_group_id = exoscale_security_group.nodepool.id
  type             = "EGRESS"
  protocol         = "icmp"
  cidr            = "0.0.0.0/0"
  description     = "Allow all ICMP egress traffic"
}

resource "exoscale_security_group_rule" "nodepool_ingress_kubelet" {
  security_group_id = exoscale_security_group.nodepool.id
  type             = "INGRESS"
  protocol         = "tcp"
  cidr            = "0.0.0.0/0"
  start_port      = 10250
  end_port        = 10250
  description     = "Kubelet API"
}

resource "exoscale_security_group_rule" "nodepool_ingress_calico" {
  security_group_id = exoscale_security_group.nodepool.id
  type             = "INGRESS"
  protocol         = "tcp"
  cidr            = "0.0.0.0/0"
  start_port      = 179
  end_port        = 179
  description     = "Calico BGP"
} 