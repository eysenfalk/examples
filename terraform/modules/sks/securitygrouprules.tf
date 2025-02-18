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