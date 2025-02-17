resource "cloudflare_dns_record" "demo_app" {
  zone_id = var.cloudflare_zone_id
  name    = "demo"
  content = data.kubernetes_service.nginx_ingress.status.0.load_balancer.0.ingress.0.ip
  type    = "A"
  proxied = true
  ttl     = 1  # Auto TTL
}

resource "cloudflare_dns_record" "grafana" {
  zone_id = var.cloudflare_zone_id
  name    = "grafana"
  content = data.kubernetes_service.nginx_ingress.status.0.load_balancer.0.ingress.0.ip
  type    = "A"
  proxied = true
  ttl     = 1  # Auto TTL
}

data "kubernetes_service" "nginx_ingress" {
  metadata {
    name      = "nginx-ingress-controller"
    namespace = "kube-system"
  }

  depends_on = [
    helm_release.nginx_ingress
  ]
} 