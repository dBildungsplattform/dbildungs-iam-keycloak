FROM registry.access.redhat.com/ubi8/ubi:8.10-1132.1733300785 AS base

USER root
RUN yum install -y java-17-openjdk-headless && \
    yum clean all
    
ADD https://archive.apache.org/dist/maven/maven-3/3.9.4/binaries/apache-maven-3.9.4-bin.tar.gz /tmp/maven.tar.gz
RUN tar xzf /tmp/maven.tar.gz -C /opt && \
    mv /opt/apache-maven-3.9.4 /opt/maven && \
    ln -s /opt/maven/bin/mvn /usr/bin/mvn && \
    rm -rf /tmp/maven.tar.gz

ADD https://github.com/keycloak/keycloak/releases/download/25.0.1/keycloak-25.0.1.tar.gz /opt/keycloak.tar.gz
RUN tar xzf /opt/keycloak.tar.gz -C /opt/ \
    && mv /opt/keycloak-25.0.1 /opt/keycloak

ENV KC_HEALTH_ENABLED=true \
    KC_METRICS_ENABLED=true \
    KC_DB=dev-file \
    KC_CACHE=local \
    KC_FEATURES_DISABLED=impersonation,par

COPY providers/privacyidea /tmp/privacyidea

WORKDIR /tmp/privacyidea/java-client
RUN mvn clean install -DskipTests && \
    cd /tmp/privacyidea && \
    mvn clean install -DskipTests && \
    cp /tmp/privacyidea/target/PrivacyIDEA-Provider.jar /opt/keycloak/providers/

WORKDIR /opt/keycloak

COPY src/providers/ /opt/keycloak/providers/
COPY src/themes/ /opt/keycloak/themes/

FROM base AS build
RUN /opt/keycloak/bin/kc.sh build

FROM build AS development

WORKDIR /opt/keycloak

COPY --from=build /opt/keycloak/lib/quarkus/ /opt/keycloak/lib/quarkus/

RUN keytool -genkeypair -storepass password -storetype PKCS12 -keyalg RSA -keysize 2048 \
    -dname "CN=dbildungs-iam-server" -alias dbildungs-iam-server \
    -ext "SAN:c=DNS:localhost,IP:127.0.0.1" -validity 365 -keystore conf/server.keystore

ENTRYPOINT ["/opt/keycloak/bin/kc.sh", "start-dev"]

FROM base AS deployment-build

ENV KC_HEALTH_ENABLED=true \
    KC_METRICS_ENABLED=true \
    KC_DB=postgres \
    KC_FEATURES_DISABLED=impersonation,par \
    KC_CACHE=ispn \
    KC_CACHE_STACK=kubernetes \
    DISABLE_EXTERNAL_ACCESS=true

RUN /opt/keycloak/bin/kc.sh build

FROM deployment-build AS deployment

WORKDIR /opt/keycloak

COPY --from=deployment-build /opt/keycloak/lib/quarkus/ /opt/keycloak/lib/quarkus/

ENTRYPOINT ["/opt/keycloak/bin/kc.sh", "start"]

