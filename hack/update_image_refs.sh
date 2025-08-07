#!/usr/bin/env bash
set -eu

# Script to update plain file image references - can be run manually or by CI
echo "=== Updating Image Reference Files ==="

# Current image references (would normally be passed as environment variables)
OPERATOR_IMAGE="${KONFLUX_TEST_OPERATOR_IMAGE_PULLSPEC:-quay.io/redhat-user-workloads/amcdermo-tenant/konflux-test-c794b@sha256:337734355c538af1ac269a8088405871fb7a7230f56c83210cfcb50a374e5b54}"
BUNDLE_IMAGE="${KONFLUX_TEST_BUNDLE_IMAGE_PULLSPEC:-quay.io/redhat-user-workloads/amcdermo-tenant/konflux-test-b058a-c2@sha256:3cea6a74d702213c26a542c514b2ca15e673380e9af5de9d24b27018d03482e4}"

echo "Updating operator-image-ref.txt with: ${OPERATOR_IMAGE}"
cat > operator-image-ref.txt << EOF
# Operator image reference - updated by Konflux nudging
# This file contains the operator component image digest
${OPERATOR_IMAGE}
EOF

echo "Updating bundle-image-ref.txt with: ${BUNDLE_IMAGE}"  
cat > bundle-image-ref.txt << EOF
# Bundle image reference - updated by Konflux nudging  
# This file contains the bundle component image digest
${BUNDLE_IMAGE}
EOF

echo "=== Image Reference Files Updated ==="
echo "operator-image-ref.txt: $(cat operator-image-ref.txt | tail -1)"
echo "bundle-image-ref.txt: $(cat bundle-image-ref.txt | tail -1)"