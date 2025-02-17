variable "cluster_name" {
  description = "Name of the Kubernetes cluster"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version"
  type        = string
}

variable "zone" {
  description = "Exoscale zone"
  type        = string
}

variable "node_pools" {
  description = "Node pool configurations"
  type = map(object({
    size        = string
    node_count  = number
    disk_size   = number
    description = string
  }))
} 