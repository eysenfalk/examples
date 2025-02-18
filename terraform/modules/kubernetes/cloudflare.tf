# resource "cloudflare_dns_record" "example_dns_record" {
#   zone_id = var.cloudflare_zone_id
#   comment = "Load balancer IP address"
#   content = data.kubectl_path_documents.ingress_ip.documents[0]
#   name    = var.domain_name
#   proxied = true
#   type    = "A"
#   ttl     = 1
# }