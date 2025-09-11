# Archived Harness Services

## namespace-service-20250911.yaml

This file contains the archived Harness service definition for namespace creation that was previously used in the cf-monitor deployment pipeline.

**Reason for archival:** Namespace and RBAC management has been moved to Ansible to decouple infrastructure setup from application deployment.

**New approach:** 
- Namespace and RBAC resources are now managed by the `cf-monitor` Ansible role
- Harness pipelines now assume the namespace exists and focus only on application deployment
- This provides better separation of concerns and more reliable infrastructure management

**Migration date:** September 11, 2025

**Impact on pipeline:**
- The "Deploy Namespace" stage has been removed from the pipeline
- All other deployment stages now assume the namespace exists
- Pipeline execution is faster and more reliable

**Note:** This file is kept for reference only and should not be used in production.
