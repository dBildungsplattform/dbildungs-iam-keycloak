FROM debian:12-slim AS base

# prepare base, as both build and final layer need java
RUN apt-get update && \
  apt-get install -y --no-install-recommends openjdk-17-jre-headless && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

FROM base AS build

ARG KEYCLOAK_VERSION="26.2.5"
ARG KEYCLOAK_VARIANT="generic"

RUN echo "Building variant $KEYCLOAK_VARIANT"

RUN apt-get update && apt-get install -y --no-install-recommends curl tar

RUN mkdir /tmp/keycloak && \
    curl --location --fail \
    --request GET \
    https://github.com/keycloak/keycloak/releases/download/${KEYCLOAK_VERSION}/keycloak-${KEYCLOAK_VERSION}.tar.gz \
    --output /tmp/keycloak/keycloak-${KEYCLOAK_VERSION}.tar.gz && \
    curl --location --fail \
    --request GET \
    https://github.com/keycloak/keycloak/releases/download/${KEYCLOAK_VERSION}/keycloak-${KEYCLOAK_VERSION}.tar.gz.sha1 \
    --output /tmp/keycloak/keycloak-${KEYCLOAK_VERSION}.tar.gz.sha1 && \
    cd /tmp/keycloak && \
    # Format the .sha1 file for sha1sum -c
    echo "$(cat keycloak-${KEYCLOAK_VERSION}.tar.gz.sha1)  keycloak-${KEYCLOAK_VERSION}.tar.gz" > keycloak-${KEYCLOAK_VERSION}.tar.gz.sha1 && \
    sha1sum -c keycloak-${KEYCLOAK_VERSION}.tar.gz.sha1 && \
    tar -xvf keycloak-${KEYCLOAK_VERSION}.tar.gz && \
    rm keycloak-${KEYCLOAK_VERSION}.tar.gz keycloak-${KEYCLOAK_VERSION}.tar.gz.sha1 && \
    mv keycloak-* /opt/keycloak && \
    mkdir -p /opt/keycloak/data && \
    mkdir -p /opt/keycloak/themes && \
    mkdir -p /opt/keycloak/providers && \
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

RUN echo "Built variant $KEYCLOAK_VARIANT"
# build final image
FROM base AS final

COPY --from=build --chown=65532:65532 /opt/ /opt/
WORKDIR /opt/keycloak
USER 65532
ENTRYPOINT [ "/opt/keycloak/bin/kc.sh", "start" , "--optimized" ]
