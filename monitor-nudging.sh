#!/bin/bash

echo "=== Monitoring Konflux Nudging Workflow ==="
echo "Started: $(date)"
echo

COMPONENT_A="konflux-test-c794b"
COMPONENT_B="konflux-test-b058a-c2"
NAMESPACE="amcdermo-tenant"
REPO="frobware/konflux-test"

# Get initial state
INITIAL_IMAGE=$(oc get component $COMPONENT_A -n $NAMESPACE -o jsonpath='{.status.lastPromotedImage}')
echo "Initial Component A image: $INITIAL_IMAGE"
echo

while true; do
    echo "--- Check $(date) ---"
    
    # 1. Check Component A build status
    PIPELINE_STATUS=$(oc get pipelineruns -n $NAMESPACE -l appstudio.openshift.io/component=$COMPONENT_A --sort-by=.metadata.creationTimestamp -o jsonpath='{.items[-1:].status.conditions[0].reason}:{.items[-1:].status.conditions[0].message}' 2>/dev/null)
    echo "Latest Component A pipeline: $PIPELINE_STATUS"
    
    # 2. Check current image
    CURRENT_IMAGE=$(oc get component $COMPONENT_A -n $NAMESPACE -o jsonpath='{.status.lastPromotedImage}')
    echo "Current Component A image: $CURRENT_IMAGE"
    
    # 3. Check if image changed
    if [[ "$CURRENT_IMAGE" != "$INITIAL_IMAGE" ]]; then
        echo "🔄 NEW IMAGE DETECTED! Old: $INITIAL_IMAGE"
        echo "🔄 NEW IMAGE DETECTED! New: $CURRENT_IMAGE"
        INITIAL_IMAGE=$CURRENT_IMAGE
    fi
    
    # 4. Check for new PRs
    OPEN_PRS=$(gh pr list --repo $REPO --state open --json number,title,author,createdAt --limit 5 2>/dev/null)
    if [[ -n "$OPEN_PRS" ]] && [[ "$OPEN_PRS" != "[]" ]]; then
        echo "📋 Open PRs:"
        echo "$OPEN_PRS" | jq -r '.[] | "  #\(.number): \(.title) by \(.author.login) at \(.createdAt)"'
    else
        echo "📋 No open PRs"
    fi
    
    echo
    sleep 30
done