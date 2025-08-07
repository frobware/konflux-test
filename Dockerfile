# Simple build - just use echo for testing
FROM registry.access.redhat.com/ubi8/ubi-minimal:latest

# Add version info
RUN echo "konflux-test-operator-1.0.0" > /version.txt

# Simple entrypoint for testing
CMD ["sh", "-c", "echo 'Konflux test operator' && cat /version.txt && sleep 3600"]
