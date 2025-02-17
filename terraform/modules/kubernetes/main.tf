resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

resource "kubernetes_namespace" "demo" {
  metadata {
    name = "demo"
  }
}

# Create Cloudflare API token secret for cert-manager
resource "kubernetes_secret" "cloudflare_api_token" {
  metadata {
    name      = "cloudflare-api-token"
    namespace = "cert-manager"
  }

  data = {
    api-token = var.cloudflare_api_token
  }

  depends_on = [
    helm_release.cert_manager
  ]
}

# Install NGINX Ingress Controller
resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = "kube-system"

  set {
    name  = "controller.service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "controller.metrics.enabled"
    value = "true"
  }
}

# Install cert-manager
resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace  = "cert-manager"
  create_namespace = true

  set {
    name  = "installCRDs"
    value = "true"
  }
}

# Create Let's Encrypt ClusterIssuer with DNS01 challenge
resource "kubectl_manifest" "cluster_issuer" {
  yaml_body = <<-YAML
    apiVersion: cert-manager.io/v1
    kind: ClusterIssuer
    metadata:
      name: letsencrypt-prod
    spec:
      acme:
        server: https://acme-v02.api.letsencrypt.org/directory
        email: ${var.letsencrypt_email}
        privateKeySecretRef:
          name: letsencrypt-prod
        solvers:
        - dns01:
            cloudflare:
              apiTokenSecretRef:
                name: cloudflare-api-token
                key: api-token
  YAML

  depends_on = [
    helm_release.cert_manager,
    kubernetes_secret.cloudflare_api_token
  ]
}

# Grafana Operator CRDs and deployment
resource "helm_release" "grafana_operator" {
  name       = "grafana-operator"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana-operator"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name

  set {
    name  = "operator.enabled"
    value = "true"
  }
}

# Create secrets
resource "kubernetes_secret" "grafana_credentials" {
  metadata {
    name      = "grafana-admin-credentials"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
  }

  data = {
    "admin-user"     = "admin"
    "admin-password" = var.grafana_admin_password
  }
}

resource "kubernetes_secret" "db_credentials" {
  metadata {
    name      = "db-credentials"
    namespace = kubernetes_namespace.demo.metadata[0].name
  }

  data = {
    POSTGRES_USER     = base64encode(var.db_user)
    POSTGRES_PASSWORD = base64encode(var.db_password)
    POSTGRES_DB       = base64encode(var.db_name)
  }
}

resource "kubernetes_config_map" "db_config" {
  metadata {
    name      = "db-config"
    namespace = kubernetes_namespace.demo.metadata[0].name
  }

  data = {
    POSTGRES_HOST = var.db_host
    POSTGRES_PORT = var.db_port
  }
}

# Apply Kubernetes manifests
resource "kubectl_manifest" "monitoring" {
  yaml_body = file("${path.module}/manifests/monitoring.yaml")

  depends_on = [
    helm_release.grafana_operator
  ]
}

resource "kubectl_manifest" "otel_collector" {
  yaml_body = file("${path.module}/manifests/otel-collector.yaml")

  depends_on = [
    kubernetes_config_map.db_config
  ]
}

resource "kubectl_manifest" "demo_app" {
  yaml_body = file("${path.module}/manifests/demo-app.yaml")

  depends_on = [
    kubectl_manifest.otel_collector
  ]
}

resource "kubectl_manifest" "dashboards" {
  yaml_body = file("${path.module}/manifests/dashboards.yaml")

  depends_on = [
    helm_release.grafana_operator
  ]
}

resource "kubectl_manifest" "ingress" {
  yaml_body = file("${path.module}/manifests/ingress.yaml")

  depends_on = [
    helm_release.nginx_ingress,
    helm_release.cert_manager,
    kubectl_manifest.cluster_issuer
  ]
} 