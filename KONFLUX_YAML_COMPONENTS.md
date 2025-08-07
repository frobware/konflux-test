# Konflux YAML Component Creation - Key Findings

## Problem
YAML-created Konflux components were getting stuck in "waiting for spec.containerImage to be set" state and not generating PAC (Pipelines as Code) PRs for `.tekton` pipeline files.

## Root Cause
The missing field was `spec.containerImage` in the component YAML definition.

## Solution
Always include `spec.containerImage` when creating components via YAML:

```yaml
apiVersion: appstudio.redhat.com/v1alpha1
kind: Component
metadata:
  annotations:
    build.appstudio.openshift.io/request: configure-pac
    build.appstudio.openshift.io/pipeline: '{"name":"docker-build-oci-ta","bundle":"latest"}'
    git-provider: github
    git-provider-url: https://github.com
  name: your-component-name
  namespace: your-tenant-namespace
spec:
  application: your-application
  componentName: your-component-name
  containerImage: quay.io/redhat-user-workloads/{tenant-namespace}/{component-name}
  source:
    git:
      dockerfileUrl: Dockerfile  # or path to your Dockerfile
      url: https://github.com/your-repo
      revision: main
```

## Key Fields Required

### Mandatory for PAC Integration:
- `spec.containerImage`: Registry path where built images will be pushed
  - Pattern: `quay.io/redhat-user-workloads/{tenant-namespace}/{component-name}`
- `metadata.annotations["build.appstudio.openshift.io/request"]`: Set to `configure-pac`
- `metadata.annotations["git-provider"]`: Set to `github` or `gitlab`
- `metadata.annotations["git-provider-url"]`: Git provider URL

### For Nudging:
- `metadata.annotations["build.appstudio.openshift.io/build-nudge-files"]`: Comma-separated list of files to update with image references
- `spec.build-nudges-ref`: Array of component names that should nudge this component

## Verification
After applying the YAML, the component should immediately get:
- PAC status: `"state": "enabled"`
- GitHub PR created with `.tekton` pipeline files
- Status message: `"done"`

## Testing Results
- ❌ **Without `containerImage`**: Component stuck in waiting state, no PAC PR
- ✅ **With `containerImage`**: Immediate PAC integration and PR creation
- ✅ **Post-patching existing components**: Adding `containerImage` via `kubectl patch` also works

## UI vs YAML Comparison
- **UI-created components**: Automatically get `containerImage` set
- **YAML-created components**: Must explicitly include `containerImage`
- Both approaches result in identical working components once properly configured

## Current OLM Pipeline Status
Successfully created 3-component OLM pipeline:
1. `konflux-test-operator` (operator container)
2. `konflux-test-bundle` (OLM bundle) 
3. `konflux-test-catalog` (OLM catalog)

All components now have PAC integration working with PRs:
- PR #12: operator pipeline files
- PR #13: bundle pipeline files  
- PR #14: catalog pipeline files (pending)