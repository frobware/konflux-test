# Konflux Test Setup

This directory contains test Konflux application and component manifests for experimenting with the Application-Per-Release pattern and nudging mechanism.

## Files

### Core Manifests
- `application.yaml` - Konflux Application definition
- `component.yaml` - First test component
- `component-2.yaml` - Second test component with nudging annotation

### Nudging Files
- `nudge-files/component-1.sh` - Image reference for component-1 (updated by nudging)
- `nudge-files/component-2.sh` - Image reference for component-2 (updated by nudging)

### Container Files
- `Dockerfile` - Main component container (minimal for fast builds)
- `component-2/Dockerfile` - Component-2 container with nudging demonstration

### Build Pipelines
- `.tekton/konflux-test-component-push.yaml` - Build pipeline for component-1 on push
- `.tekton/konflux-test-component-2-push.yaml` - Build pipeline for component-2 on push (with nudging)
- `.tekton/konflux-test-component-pull-request.yaml` - Build pipeline for PR validation

### Scripts
- `deploy.sh` - Deploy all resources
- `cleanup.sh` - Clean up all resources  
- `README.md` - This documentation

## Usage

### Quick Deploy
```bash
./deploy.sh
```

### Manual Deploy
```bash
# Create application
kubectl apply -f application.yaml

# Create components
kubectl apply -f component.yaml
kubectl apply -f component-2.yaml

# Check status
kubectl get applications,components -n amcdermo-tenant
```

### Check Nudging Configuration
```bash
kubectl get components -n amcdermo-tenant -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.metadata.annotations.build\.appstudio\.openshift\.io/build-nudge-files}{"\n"}{end}'
```

### Cleanup
```bash
./cleanup.sh
```

## Nudging Test

Component-2 has a build nudge annotation pointing to `nudge-files/component-1.sh`, simulating how BPFman components would nudge each other within a release ecosystem.

When component-1 builds, Konflux will automatically update the `COMPONENT_1_IMAGE_PULLSPEC` variable in `nudge-files/component-1.sh`, which component-2 can then reference in its builds.

## Repository Reference

Both components reference `https://gitlab.cee.redhat.com/amcdermo/konflux-test` as the source repository for testing purposes. This repo will contain all these files for experimentation with Application-Per-Release patterns.