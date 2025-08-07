# Konflux YAML Component Creation - Complete Guide

## Critical Discovery: ImageRepository + Component Pattern

YAML-created Konflux components require **both** resources to work properly:

1. **ImageRepository** - Provisions the quay.io repository and robot accounts
2. **Component** - Defines the build configuration with `spec.containerImage`

The Konflux UI creates the ImageRepository automatically, but YAML creation requires explicit definition.

## Complete Working Pattern

Each component needs both resources in a single YAML file:

```yaml
apiVersion: appstudio.redhat.com/v1alpha1
kind: ImageRepository
metadata:
  labels:
    appstudio.redhat.com/application: konflux-test
    appstudio.redhat.com/component: your-component-name
  name: your-component-name
  namespace: your-tenant-namespace
spec:
  image:
    name: your-tenant-namespace/your-component-name
    visibility: public
---
apiVersion: appstudio.redhat.com/v1alpha1
kind: Component
metadata:
  annotations:
    build.appstudio.openshift.io/request: configure-pac
  name: your-component-name
  namespace: your-tenant-namespace
spec:
  application: your-application
  componentName: your-component-name
  containerImage: quay.io/redhat-user-workloads/your-tenant-namespace/your-component-name
  source:
    git:
      dockerfileUrl: Dockerfile
      url: https://github.com/your-repo
      revision: main
```

## Key Fields Required

### ImageRepository:
- `spec.image.name`: `{tenant-namespace}/{component-name}` (no quay.io prefix)
- `spec.image.visibility`: `public` or `private`
- `metadata.labels`: Link to application and component

### Component:
- `spec.containerImage`: `quay.io/redhat-user-workloads/{tenant-namespace}/{component-name}`
- `metadata.annotations["build.appstudio.openshift.io/request"]`: Set to `configure-pac`

### For Nudging (optional):
- `metadata.annotations["build.appstudio.openshift.io/build-nudge-files"]`: Files to update with image references

## Error Symptoms

### Without ImageRepository:
- 401 Unauthorized errors during builds
- "Failed to get registry token" messages  
- Builds failing at container push stage

### Without containerImage:
- Component stuck in "waiting for spec.containerImage" state
- No PAC PR generated
- No pipeline runs triggered

## Verification
After applying the YAML:
1. ImageRepository provisions quay.io repository
2. Component gets PAC status: `"state": "enabled"`
3. GitHub PR created with `.tekton` pipeline files
4. Build pipeline runs successfully

## OLM Pipeline Example
This repository demonstrates a complete 3-component OLM pipeline:
1. **Operator** (`konflux-component-operator.yaml`)
2. **Bundle** (`konflux-component-bundle.yaml`) - nudges on operator CSV changes
3. **Catalog** (`konflux-component-catalog.yaml`) - nudges on bundle FBC changes

Each component follows the ImageRepository + Component pattern for reliable YAML-based creation.