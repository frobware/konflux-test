FROM registry.access.redhat.com/ubi8/ubi-minimal:latest

# Add version file (no package installs for speed)
RUN echo "konflux-test-1.0.0" > /version.txt

# Simple entrypoint
CMD ["cat", "/version.txt"]