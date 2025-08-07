FROM registry.access.redhat.com/ubi8/ubi-minimal:latest

# Install opm tool for File-Based Catalog
RUN microdnf install -y curl tar gzip && \
    curl -L https://github.com/operator-framework/operator-registry/releases/download/v1.45.0/linux-amd64-opm > /usr/local/bin/opm && \
    chmod +x /usr/local/bin/opm && \
    microdnf clean all

# Copy catalog definition
COPY catalog /catalog

# Set up the catalog
WORKDIR /
EXPOSE 50051
ENTRYPOINT ["/usr/local/bin/opm", "serve", "/catalog"]