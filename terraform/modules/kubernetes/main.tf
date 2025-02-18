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

# # Install NGINX Ingress Controller
# resource "helm_release" "nginx_ingress" {
#   name       = "nginx-ingress"
#   repository = "https://kubernetes.github.io/ingress-nginx"
#   chart      = "ingress-nginx"
#   namespace  = "kube-system"

#   set {
#     name  = "controller.service.type"
#     value = "LoadBalancer"
#   }

#   set {
#     name  = "controller.metrics.enabled"
#     value = "true"
#   }

#   wait = true
#   timeout = 300
# }

# Install cert-manager using Helm
resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  namespace        = "cert-manager"
  create_namespace = true
  version          = "v1.17.1"

  set {
    name  = "crds.enabled"
    value = "true"
  }

  # Optional: Add Prometheus monitoring
  set {
    name  = "prometheus.enabled"
    value = "true"
  }
}

# Increase the wait time for CRDs
resource "time_sleep" "wait_for_cert_manager_crds" {
  depends_on = [helm_release.cert_manager]
  create_duration = "60s"
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

# Update the cluster issuer to depend on the time_sleep
resource "kubectl_manifest" "cluster_issuer" {
  yaml_body = <<YAML
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    email: ${var.letsencrypt_email}
    server: https://acme-v02.api.letsencrypt.org/directory
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
    kubernetes_secret.cloudflare_api_token,
    time_sleep.wait_for_cert_manager_crds
  ]
}

# Deploy monitoring stack
resource "kubectl_manifest" "monitoring_stack" {
  yaml_body = file("${path.module}/manifests/monitoring.yaml")

  depends_on = [
    kubernetes_namespace.monitoring,
    helm_release.cert_manager,
    kubernetes_secret.cloudflare_api_token,
    kubectl_manifest.ingress_controller
  ]
}

# Deploy NGINX ingress controller
resource "kubectl_manifest" "ingress_controller" {
  yaml_body = file("${path.module}/manifests/ingress-controller.yaml")
  
}