#!/usr/bin/env bash
set -eu

# Script to update bundle references - will be nudged by Konflux
echo "=== Updating Bundle Configuration ==="

# These image references will be updated by Konflux nudging
export KONFLUX_TEST_OPERATOR_IMAGE_PULLSPEC="quay.io/redhat-user-workloads/amcdermo-tenant/konflux-test-c794b@sha256:337734355c538af1ac269a8088405871fb7a7230f56c83210cfcb50a374e5b54"
#
export KONFLUX_TEST_BUNDLE_IMAGE_PULLSPEC="quay.io/redhat-user-workloads/amcdermo-tenant/konflux-test-b058a-c2@sha256:3cea6a74d702213c26a542c514b2ca15e673380e9af5de9d24b27018d03482e4"
#

echo "Using operator image: ${KONFLUX_TEST_OPERATOR_IMAGE_PULLSPEC}"
echo "Using bundle image: ${KONFLUX_TEST_BUNDLE_IMAGE_PULLSPEC}"

# Update sample TestBundle resource
SAMPLE_FILE="config/samples/catalog_v1_testbundle.yaml"

if [[ -f "${SAMPLE_FILE}" ]]; then
    echo "Updating sample file: ${SAMPLE_FILE}"
    
    # Update the operator and bundle image references
    sed -i -E \
        -e "s|operatorImage: .*$|operatorImage: ${KONFLUX_TEST_OPERATOR_IMAGE_PULLSPEC}|" \
        -e "s|bundleImage: .*$|bundleImage: ${KONFLUX_TEST_BUNDLE_IMAGE_PULLSPEC}|" \
        "${SAMPLE_FILE}"
        
    echo "Sample file updated successfully"
else
    echo "Sample file not found: ${SAMPLE_FILE}"
fi

echo "=== Bundle Update Complete ==="