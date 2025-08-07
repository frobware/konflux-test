# Konflux Test Operator

This is a sample Kubernetes operator built with controller-runtime that demonstrates the **operator → bundle → catalog** pattern commonly used in OpenShift operators.

## Purpose

This operator serves as a realistic example for Konflux nudging mechanisms, showing how:

1. **Operator Component** builds and produces new image digests
2. **Bundle Component** references the operator image and gets nudged when operator builds
3. **Catalog Component** references the bundle image and gets nudged when bundle builds

This mirrors the pattern used by real OpenShift operators like BPFman.

## Architecture

### Custom Resource: TestBundle

The `TestBundle` CRD represents an operator bundle configuration:

```yaml
apiVersion: catalog.konflux.example.com/v1
kind: TestBundle
metadata:
  name: testbundle-sample
spec:
  operatorImage: "quay.io/redhat-user-workloads/amcdermo-tenant/konflux-test-c794b@sha256:..."
  bundleImage: "quay.io/redhat-user-workloads/amcdermo-tenant/konflux-test-b058a-c2@sha256:..."
  version: "v1.0.0"
  channel: "stable"
```

### Nudging Pattern

The operator includes shell scripts in `hack/` that follow BPFman's nudging pattern:

- **`hack/update_bundle.sh`**: Contains image references that get updated by Konflux nudging
- **`config/samples/catalog_v1_testbundle.yaml`**: Sample resource with image digests

When components build new images, Konflux nudging will:
1. Detect the new image digests
2. Create PRs to update the shell scripts
3. Update the sample YAML files with new references

## Usage

### Building and Running

```bash
# Generate manifests and build
make manifests generate build

# Install CRDs into cluster
make install

# Run the operator locally
make run

# Or build and deploy as container
make docker-build IMG=controller:latest
make docker-push IMG=controller:latest
make deploy IMG=controller:latest
```

### Creating TestBundle Resources

```bash
# Apply the sample TestBundle
kubectl apply -f config/samples/catalog_v1_testbundle.yaml

# Check the resource
kubectl get testbundles.catalog.konflux.example.com
```

## Konflux Integration

This operator demonstrates how real OpenShift operators integrate with Konflux:

1. **Component Structure**: Separate components for operator, bundle, and catalog
2. **Nudging Scripts**: Shell scripts with image references that get updated
3. **Build Triggers**: Components build when their dependencies update
4. **Realistic Workflow**: Mirrors production operator development patterns

The nudging mechanism ensures that when the operator image changes, all dependent components (bundle, catalog) automatically get updated with the new image references.