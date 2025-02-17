#!/bin/bash

# Create namespaces
kubectl apply -f k8s/namespaces.yaml

# Create secrets and configmaps
kubectl apply -f k8s/grafana-credentials.yaml
kubectl apply -f k8s/secrets.yaml

# Deploy database
kubectl apply -f k8s/postgres.yaml

# Deploy monitoring stack
kubectl apply -f k8s/monitoring.yaml
kubectl apply -f k8s/dashboards.yaml

# Deploy OpenTelemetry collector
kubectl apply -f k8s/otel-collector.yaml

# Deploy demo application
kubectl apply -f k8s/demo-app.yaml

# Wait for deployments
echo "Waiting for deployments to be ready..."
kubectl wait --for=condition=ready pod -l app=postgres -n demo --timeout=300s
kubectl wait --for=condition=ready pod -l app=otel-collector -n demo --timeout=300s
kubectl wait --for=condition=ready pod -l app=otel-demo -n demo --timeout=300s

# Get service URLs
echo "Services:"
echo "Demo App: $(kubectl get svc otel-demo -n demo -o jsonpath='{.status.loadBalancer.ingress[0].ip}'):8080"
echo "Grafana: http://grafana.local"

# Print Grafana credentials
echo "Grafana Credentials:"
echo "Username: admin"
echo "Password: admin123" 