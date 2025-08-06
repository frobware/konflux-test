#!/bin/bash
# Deploy test Konflux application and components

set -euo pipefail

NAMESPACE=${NAMESPACE:-amcdermo-tenant}

echo "Deploying Konflux test application to namespace: $NAMESPACE"

# Apply application
echo "Creating application..."
kubectl apply -f application.yaml

# Apply components
echo "Creating components..."
kubectl apply -f component.yaml
kubectl apply -f component-2.yaml

# Check status
echo "Checking deployment status..."
kubectl get applications,components -n "$NAMESPACE" -l 'app.kubernetes.io/part-of=konflux-test' || true
kubectl get applications,components -n "$NAMESPACE" | grep konflux-test || true

echo "Deployment complete!"
echo ""
echo "To check status:"
echo "  kubectl get applications,components -n $NAMESPACE"
echo ""
echo "To check nudging:"
echo "  kubectl get components -n $NAMESPACE -o jsonpath='{range .items[*]}{.metadata.name}{\"\t\"}{.metadata.annotations.build\.appstudio\.openshift\.io/build-nudge-files}{\"\n\"}{end}'"