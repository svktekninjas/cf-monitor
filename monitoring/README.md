# CF Monitoring Helm Chart

This Helm chart deploys a complete monitoring stack on OpenShift/ROSA clusters, including Prometheus, Grafana, and Node Exporter.

## Components

### Prometheus
- **Location**: `charts/prometheus/`
- **Purpose**: Time-series database and monitoring system
- **Features**:
  - StatefulSet deployment with persistent storage
  - Automatic service discovery for Kubernetes resources
  - ConfigMap-based configuration
  - ServiceMonitor for self-monitoring
  - OpenShift Route support

### Grafana
- **Location**: `charts/grafana/`
- **Purpose**: Visualization and dashboards
- **Features**:
  - Deployment with optional persistence
  - Pre-configured Prometheus datasource
  - Default ROSA cluster dashboard
  - Plugin support
  - Ingress and OpenShift Route support
  - ServiceMonitor for metrics collection

### Node Exporter
- **Location**: `charts/node-exporter/`
- **Purpose**: Hardware and OS metrics from nodes
- **Features**:
  - DaemonSet deployment on all nodes
  - Host network access for system metrics
  - ServiceMonitor for Prometheus scraping
  - Tolerations for all node taints

## Prerequisites

- Kubernetes 1.19+ or OpenShift 4.x
- Helm 3.x
- (Optional) Prometheus Operator for ServiceMonitor support

## Installation

### Basic Installation

```bash
# Install with default values
helm install monitoring ./monitoring

# Install with specific environment
helm install monitoring ./monitoring -f environments/dev/monitoring-variables.yml

# Install in specific namespace
helm install monitoring ./monitoring --namespace monitoring --create-namespace
```

### Production Installation

```bash
# Install with production values
helm install monitoring ./monitoring \
  -f environments/prod/monitoring-variables.yml \
  --namespace monitoring-prod \
  --create-namespace
```

## Configuration

### Environment-Specific Values

The chart includes pre-configured environment files:

- **Development**: `environments/dev/monitoring-variables.yml`
  - Minimal resources
  - No persistence
  - 7-day retention

- **Test**: `environments/test/monitoring-variables.yml`
  - Moderate resources
  - Persistence enabled
  - 15-day retention

- **Production**: `environments/prod/monitoring-variables.yml`
  - High availability
  - Full persistence
  - 30-day retention
  - CloudWatch integration

### Key Configuration Options

```yaml
# Enable/disable components
prometheus:
  enabled: true
  retention: 15d
  storage:
    size: 10Gi

grafana:
  enabled: true
  adminPassword: "secure-password"  # Change this!
  persistence:
    enabled: true
    size: 5Gi

nodeExporter:
  enabled: true

# RBAC
rbac:
  create: true

# Network Policies
networkPolicy:
  enabled: false  # Set to true for enhanced security

# ServiceMonitor (requires Prometheus Operator)
serviceMonitor:
  enabled: false
  interval: 30s
```

## Accessing Services

### Prometheus

```bash
# Port-forward
kubectl port-forward -n monitoring svc/monitoring-cf-monitoring-prometheus 9090:9090

# OpenShift Route
oc get route monitoring-cf-monitoring-prometheus -n monitoring
```

### Grafana

```bash
# Port-forward
kubectl port-forward -n monitoring svc/monitoring-cf-monitoring-grafana 3000:3000

# Default credentials
Username: admin
Password: Check values.yaml or environment file

# OpenShift Route
oc get route monitoring-cf-monitoring-grafana -n monitoring
```

## Monitoring Targets

The default configuration monitors:

1. **Cluster Metrics**:
   - Node CPU, memory, disk, network
   - Pod and container metrics
   - Kubernetes API metrics

2. **Application Metrics**:
   - Services annotated with `prometheus.io/scrape: "true"`
   - Pods annotated with `prometheus.io/scrape: "true"`

3. **Self-Monitoring**:
   - Prometheus metrics
   - Grafana metrics
   - Node Exporter metrics

## Adding Custom Dashboards

1. Create a ConfigMap with your dashboard JSON:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: custom-dashboard
  namespace: monitoring
data:
  my-dashboard.json: |
    {
      "dashboard": {
        "title": "My Custom Dashboard",
        ...
      }
    }
```

2. Mount it in Grafana deployment by modifying values.yaml

## Troubleshooting

### Prometheus Not Scraping Targets

```bash
# Check ServiceMonitor
kubectl get servicemonitor -n monitoring

# Check Prometheus targets
kubectl port-forward -n monitoring svc/monitoring-cf-monitoring-prometheus 9090:9090
# Visit http://localhost:9090/targets
```

### Grafana Dashboard Not Loading

```bash
# Check Grafana logs
kubectl logs -n monitoring deployment/monitoring-cf-monitoring-grafana

# Verify datasource
kubectl get cm monitoring-cf-monitoring-grafana-datasources -n monitoring -o yaml
```

### Node Exporter Permission Issues

```bash
# Check SecurityContextConstraints (OpenShift)
oc adm policy add-scc-to-user privileged -z monitoring-cf-monitoring-node-exporter -n monitoring
```

## Uninstallation

```bash
# Uninstall the release
helm uninstall monitoring -n monitoring

# Clean up namespace
kubectl delete namespace monitoring
```

## Security Considerations

1. **Change default passwords** in production
2. **Enable NetworkPolicies** for network segmentation
3. **Use TLS** for ingress/routes
4. **Implement RBAC** properly (enabled by default)
5. **Regular updates** of container images

## Support

For issues or questions:
- Check the troubleshooting section
- Review Helm values and environment files
- Check component logs using `kubectl logs`

## License

This Helm chart is provided as-is for internal use.