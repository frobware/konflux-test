FROM registry.access.redhat.com/ubi8/ubi-minimal:latest

# Load component-1 image reference
COPY nudge-files/component-1.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/component-1.sh

# Add version file (no package installs for speed)
RUN echo "konflux-test-component-2-1.0.0" > /version.txt

# Simple entrypoint that shows nudged image
CMD ["sh", "-c", "source /usr/local/bin/component-1.sh && echo Component-1 image: $COMPONENT_1_IMAGE_PULLSPEC && cat /version.txt"]