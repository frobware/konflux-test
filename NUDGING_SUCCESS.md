# Nudging Success Documentation

**Date**: 2025-08-07  
**First Successful Nudging PR**: #4 "Update konflux-test-c794b to 3377343"

## Working Configuration Summary

### Components
- **konflux-test-c794b** (Component A): Source component that triggers nudging
- **konflux-test-b058a-c2** (Component B): Target component that gets nudged

### Nudging Relationship
- Component A has `build-nudges-ref: [konflux-test-b058a-c2]` (A nudges B)
- Component B shows `build-nudged-by: [konflux-test-c794b]` (B is nudged by A)

### Working Pipeline Configuration
- Component B pipeline includes: `build.appstudio.openshift.io/build-nudge-files: "nudge-files/component-1.sh"`
- Both components use `docker-build-oci-ta` pipeline

### Successful Nudging Flow
1. Component A (konflux-test-c794b) builds new image: `@sha256:337734355c538af1ac269a8088405871fb7a7230f56c83210cfcb50a374e5b54`
2. Renovate detects Component B references the old digest
3. PR #4 created by `app/red-hat-konflux` to update Component B
4. PR updates `component-2/Dockerfile` with new digest

### Files Updated by Nudging
The PR updated the Dockerfile rather than the shell script, showing Renovate found the image reference in:
```dockerfile
# Before
ARG COMPONENT_A_IMAGE=quay.io/redhat-user-workloads/amcdermo-tenant/konflux-test-c794b@sha256:90c2e4451ced...
# After  
ARG COMPONENT_A_IMAGE=quay.io/redhat-user-workloads/amcdermo-tenant/konflux-test-c794b@sha256:337734355c538af1ac269a8088405871fb7a7230f56c83210cfcb50a374e5b54
```

### Key Learnings
- Nudging works with explicit file paths in `build-nudge-files` annotation
- Renovate automatically detects image digest references in Dockerfiles
- The relationship direction is: source component nudges target component
- Nudging appears within 5-10 minutes after successful build completion

### Working YAML Files
- `konflux-test-c794b-working.yaml` - Component A configuration
- `konflux-test-b058a-c2-working.yaml` - Component B configuration  
- `konflux-test-application-working.yaml` - Application configuration