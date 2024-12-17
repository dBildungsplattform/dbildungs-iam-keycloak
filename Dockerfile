# Use Red Hat UBI as the base for package support
FROM registry.access.redhat.com/ubi8/ubi:8.10-1132.1733300785 AS base

# Install necessary tools: krb5-workstation and Java
USER root
RUN yum install -y krb5-workstation krb5-libs java-17-openjdk-headless \
    && yum clean all

# Download Keycloak
RUN curl -L -o /opt/keycloak.tar.gz https://github.com/keycloak/keycloak/releases/download/25.0.1/keycloak-25.0.1.tar.gz \
    && tar xzf /opt/keycloak.tar.gz -C /opt/ \
    && mv /opt/keycloak-25.0.1 /opt/keycloak

# Set Keycloak settings for developer mode
ENV KC_HEALTH_ENABLED=true \
    KC_METRICS_ENABLED=true \
    KC_DB=dev-file \
    KC_CACHE=local \
    KC_FEATURES_DISABLED=impersonation,par

# Set Keycloak directory
WORKDIR /opt/keycloak

# Copy extensions
COPY src/providers/ /opt/keycloak/providers/
COPY src/themes/ /opt/keycloak/themes/

# Build Keycloak
FROM base AS build
RUN /opt/keycloak/bin/kc.sh build

# Development Run Stage
FROM build AS development

# Set work directory
WORKDIR /opt/keycloak

# Copy necessary files
COPY --from=build /opt/keycloak/lib/quarkus/ /opt/keycloak/lib/quarkus/

# Generate auto-generated keys for HTTPS in developer mode
RUN keytool -genkeypair -storepass password -storetype PKCS12 -keyalg RSA -keysize 2048 \
    -dname "CN=dbildungs-iam-server" -alias dbildungs-iam-server \
    -ext "SAN:c=DNS:localhost,IP:127.0.0.1" -validity 365 -keystore conf/server.keystore

# Set entrypoint for development mode
ENTRYPOINT ["/opt/keycloak/bin/kc.sh", "start-dev"]

# Deployment image
FROM base AS deployment-build

# Set Keycloak settings for deployment mode
ENV KC_HEALTH_ENABLED=true \
    KC_METRICS_ENABLED=true \
    KC_DB=postgres \
    KC_FEATURES_DISABLED=impersonation,par \
    KC_CACHE=ispn \
    KC_CACHE_STACK=kubernetes \
    DISABLE_EXTERNAL_ACCESS=true

# Build Keycloak for deployment
RUN /opt/keycloak/bin/kc.sh build

# Deployment Run Stage
FROM deployment-build AS deployment

# Set work directory
WORKDIR /opt/keycloak

# Copy necessary files
COPY --from=deployment-build /opt/keycloak/lib/quarkus/ /opt/keycloak/lib/quarkus/

# Set entrypoint for deployment mode
ENTRYPOINT ["/opt/keycloak/bin/kc.sh", "start"]
