#!/bin/bash
# Cleanup test Konflux application and components

set -euo pipefail

NAMESPACE=${NAMESPACE:-amcdermo-tenant}

echo "Cleaning up Konflux test application from namespace: $NAMESPACE"

# Delete components first (they have owner references)
echo "Deleting components..."
kubectl delete -f component-2.yaml --ignore-not-found=true
kubectl delete -f component.yaml --ignore-not-found=true

# Delete application
echo "Deleting application..."
kubectl delete -f application.yaml --ignore-not-found=true

echo "Cleanup complete!"
echo ""
echo "Remaining resources:"
kubectl get applications,components -n "$NAMESPACE" | grep konflux-test || echo "  No konflux-test resources remaining"