FROM debian:12-slim AS base

# prepare base, as both build and final layer need java
RUN apt-get update && \
  apt-get install -y --no-install-recommends openjdk-17-jre-headless && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

FROM base AS build

ARG KEYCLOAK_VERSION="26.2.5"
ARG KEYCLOAK_VARIANT="generic"

RUN apt-get update && apt-get install -y --no-install-recommends curl tar

RUN mkdir /tmp/keycloak && \
      curl \
      --location \
      --fail \
      --request GET \
      https://github.com/keycloak/keycloak/releases/download/${KEYCLOAK_VERSION}/keycloak-${KEYCLOAK_VERSION}.tar.gz \
      --output /tmp/keycloak/keycloak-${KEYCLOAK_VERSION}.tar.gz && \
    cd /tmp/keycloak && \
    tar -xvf /tmp/keycloak/keycloak-*.tar.gz && \
    rm /tmp/keycloak/keycloak-*.tar.gz && \
    mv /tmp/keycloak/keycloak-* /opt/keycloak && \
    mkdir -p /opt/keycloak/data && \
    mkdir -p /opt/keycloak/themes && \
    chmod -R g+rwX /opt/keycloak
  
# load files and env vars for base and the selected variant
COPY ./variants/base/files/ /opt/keycloak/
COPY ./variants/${KEYCLOAK_VARIANT}/files/ /opt/keycloak/
COPY ./variants/base/env /tmp/env-base
COPY ./variants/${KEYCLOAK_VARIANT}/env /tmp/env-variant

# remove unused .gitkeep files
RUN rm -f /opt/keycloak/.gitkeep 

# generate ssl cert for dev
WORKDIR /opt/keycloak/
RUN keytool -genkeypair -storepass password -storetype PKCS12 -keyalg RSA -keysize 2048 -dname "CN=keycloak" -alias keycloak -ext "SAN:c=DNS:localhost,IP:127.0.0.1" -validity 365 -keystore conf/server.keystore

# load env vars and execute build
RUN set -o allexport && \
    . /tmp/env-base && \
    . /tmp/env-variant && \
    set +a && \
    env && \
    /opt/keycloak/bin/kc.sh build && \
    /opt/keycloak/bin/kc.sh show-config


# build final image
FROM base AS final

COPY --from=build /opt/ /opt/
WORKDIR /opt/keycloak
ENTRYPOINT [ "/opt/keycloak/bin/kc.sh", "start" , "--optimized" ]
