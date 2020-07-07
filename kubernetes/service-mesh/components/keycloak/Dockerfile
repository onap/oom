FROM alpine:3.12.1
RUN apk add wget openjdk11
WORKDIR /tmp
RUN wget https://downloads.jboss.org/keycloak/6.0.1/keycloak-6.0.1.tar.gz
RUN tar -xvzf keycloak-6.0.1.tar.gz
RUN rm keycloak-6.0.1.tar.gz
RUN mv keycloak-6.0.1 /keycloak
WORKDIR /keycloak
# RUN chown -R keycloak: keycloak
RUN chmod o+x /keycloak/bin