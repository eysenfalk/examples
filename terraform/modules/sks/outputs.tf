output "cluster_endpoint" {
  description = "Kubernetes cluster API endpoint"
  value       = exoscale_sks_cluster.cluster.endpoint
}

output "kubeconfig" {
  description = "Kubernetes kubeconfig file content"
  value       = exoscale_sks_kubeconfig.kubeconfig.kubeconfig
  sensitive   = true
}