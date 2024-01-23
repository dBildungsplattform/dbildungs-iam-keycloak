### Keycloak base image with dbildungs-iam extensions
FROM quay.io/keycloak/keycloak:21.1.2 AS base

# dbildungs-iam specific extensions (providers, themes, etc.)
#COPY src/conf/ /opt/keycloak/conf/
COPY src/providers/ /opt/keycloak/providers/
#COPY src/themes/ /opt/keycloak/themes/

### Development image

## Build
FROM base AS development-build

# Keycloak settings for developers mode
ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true
ENV KC_DB=dev-file
ENV KC_CACHE=local
ENV KC_FEATURES_DISABLED=impersonation,ciba,par,web-authn

RUN /opt/keycloak/bin/kc.sh build

## Run
FROM development-build as development
COPY --from=development-build /opt/keycloak/lib/quarkus/ /opt/keycloak/lib/quarkus/
WORKDIR /opt/keycloak

# auto-generated keys for HTTPS in developers mode
RUN keytool -genkeypair -storepass password -storetype PKCS12 -keyalg RSA -keysize 2048 -dname "CN=dbildungs-iam-server" -alias dbildungs-iam -ext "SAN:c=DNS:localhost,IP:127.0.0.1" -validity 365 -keystore conf/server.keystore

ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
CMD ["start-dev"]

### Production image

## Build
FROM base AS production-build

# Keycloak settings for production mode
ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true
ENV KC_DB=postgres
ENV KC_FEATURES_DISABLED=impersonation,ciba,par,web-authn
ENV KC_CACHE=ispn
ENV KC_CACHE_STACK=kubernetes

RUN /opt/keycloak/bin/kc.sh build

## Run
FROM production-build as production
COPY --from=production-build /opt/keycloak/lib/quarkus/ /opt/keycloak/lib/quarkus/
WORKDIR /opt/keycloak

ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
CMD ["start"]