# Terraform Configuration for OpenTelemetry Demo on Exoscale

This Terraform configuration deploys a production-ready Kubernetes environment on Exoscale, complete with a managed PostgreSQL database and observability stack.

## 🏗️ Architecture

The configuration creates:
- Exoscale SKS (Kubernetes) cluster
- Managed PostgreSQL database
- Grafana Operator with monitoring stack
- OpenTelemetry Demo application

## 📋 Prerequisites

- Terraform 1.0.0+
- Exoscale account and API credentials
- `kubectl` installed locally
- Helm 3.x installed locally

## 🚀 Quick Start

1. **Clone the Repository**
   ```bash
   git clone <repository-url>
   cd <repository-name>/terraform
   ```

2. **Configure Variables**
   Create a `terraform.tfvars` file:
   ```hcl
   exoscale_api_key    = "your-api-key"
   exoscale_api_secret = "your-api-secret"
   db_password         = "your-secure-password"
   ```

3. **Initialize Terraform**
   ```bash
   terraform init
   ```

4. **Review the Plan**
   ```bash
   terraform plan
   ```

5. **Apply the Configuration**
   ```bash
   terraform apply
   ```

## 📝 Configuration Options

### Required Variables
- `exoscale_api_key` - Exoscale API key
- `exoscale_api_secret` - Exoscale API secret
- `db_password` - Password for the database

### Optional Variables
- `zone` - Exoscale zone (default: "ch-gva-2")
- `cluster_name` - Name of the Kubernetes cluster (default: "otel-demo-cluster")
- `cluster_version` - Kubernetes version (default: "1.27.5")
- `grafana_admin_password` - Grafana admin password (default: "admin123")

### Node Pool Configuration
```hcl
node_pools = {
  "general" = {
    size        = "standard.4"
    node_count  = 3
    disk_size   = 50
    description = "General purpose nodes"
  }
}
```

### Database Configuration
```hcl
database = {
  name         = "otel-demo-db"
  type         = "pg"
  version      = "15"
  size         = "hobbyist-2"
  storage_size = 10
  node_count   = 1
}
```

## 🔧 Maintenance

### Scaling the Cluster
To modify the node count:
```hcl
node_pools = {
  "general" = {
    size        = "standard.4"
    node_count  = 5  # Increase node count
    disk_size   = 50
    description = "General purpose nodes"
  }
}
```

### Upgrading Kubernetes
Update the `cluster_version` variable and apply:
```hcl
cluster_version = "1.28.0"
```

## 🔍 Troubleshooting

1. **Connection Issues**
   - Verify Exoscale credentials
   - Check security group rules
   - Ensure VPC connectivity

2. **Database Issues**
   - Check database status in Exoscale console
   - Verify connection strings
   - Check database logs

3. **Kubernetes Issues**
   - Use `kubectl get nodes` to check node status
   - Check pod logs with `kubectl logs`
   - Verify cluster endpoint accessibility

## 🔐 Security Notes

- API credentials are marked as sensitive
- Database passwords are encrypted
- Node pools are in private networks
- Security groups limit access
- Kubernetes RBAC is enabled

## 📈 Performance Considerations

- Node pool sizing is optimized for production
- Database is properly sized for the workload
- Monitoring is configured for optimal performance
- Auto-scaling is enabled where appropriate

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details. 