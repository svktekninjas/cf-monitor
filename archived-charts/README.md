# Archived Helm Charts

## namespace-chart-20250911

This directory contains the archived namespace Helm chart that was previously used for creating the cf-monitor namespace and RBAC resources.

**Reason for archival:** Namespace and RBAC management has been moved to Ansible for better infrastructure-as-code practices and to decouple infrastructure setup from application deployment.

**New approach:** 
- Namespace and RBAC resources are now managed by the `cf-monitor` Ansible role
- Helm charts now assume the namespace exists and focus only on application deployment
- This provides better separation of concerns and more reliable infrastructure management

**Migration date:** September 11, 2025

**Files archived:**
- Chart.yaml - Namespace chart metadata
- values.yaml - Default namespace configuration
- templates/ - All namespace and RBAC templates
  - namespace.yaml
  - rbac.yaml
  - openshift-monitoring-rbac.yaml
  - _helpers.tpl

**Note:** These files are kept for reference only and should not be used in production.
