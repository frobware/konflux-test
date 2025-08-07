FROM registry.access.redhat.com/ubi8/ubi-minimal:latest

# Reference to Component A's image that should be nudged by Renovate
# This digest should be automatically updated when konflux-test-c794b builds
ARG COMPONENT_A_IMAGE=quay.io/redhat-user-workloads/amcdermo-tenant/konflux-test-c794b@sha256:a1211ac09eea7503e16cc2ef2348b2c3b73eca3720ff82b77f6487413c69104b

# Load component-1 image reference  
COPY nudge-files/component-1.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/component-1.sh

# Add version file (no package installs for speed)
RUN echo "konflux-test-component-2-1.0.0" > /version.txt

# Simple entrypoint that shows nudged image
CMD ["sh", "-c", "source /usr/local/bin/component-1.sh && echo Component-1 image: $COMPONENT_1_IMAGE_PULLSPEC && cat /version.txt"]