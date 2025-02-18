# data "kubectl_path_documents" "ingress_ip" {
#   pattern = "kubectl get svc -n ingress-nginx ingress-nginx-controller -o jsonpath='{.status.loadBalancer.ingress[0].ip}'"

#   depends_on = [
#     kubectl_manifest.ingress_controller
#   ]
# }

# output "ingress_ip" {
#   value = data.kubectl_path_documents.ingress_ip.documents[0]
# }