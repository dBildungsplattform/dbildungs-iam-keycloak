# Keycloak base image with dbildungs-iam-keycloak extensions
FROM quay.io/keycloak/keycloak:26.2.5 AS base

# Copy dbildungs-iam-keycloak specific extensions (providers, themes, etc.)
COPY src/providers/ /opt/keycloak/providers/
COPY src/themes/ /opt/keycloak/themes/

#  Build Stage
FROM base AS build

# Set Keycloak settings for developer mode
ENV KC_HEALTH_ENABLED=true \
    KC_METRICS_ENABLED=true \
    KC_DB=dev-file \
    KC_CACHE=local \
    KC_FEATURES_DISABLED=impersonation,par

# Build Keycloak
RUN /opt/keycloak/bin/kc.sh build

# Development Run Stage
FROM build as development

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
FROM deployment-build as deployment

# Set work directory
WORKDIR /opt/keycloak

# Copy necessary files
COPY --from=deployment-build /opt/keycloak/lib/quarkus/ /opt/keycloak/lib/quarkus/

# Set entrypoint for deployment mode
ENTRYPOINT ["/opt/keycloak/bin/kc.sh", "start"]
