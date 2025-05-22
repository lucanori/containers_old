# syntax=docker/dockerfile:1

FROM docker.io/library/alpine:3.21
ARG VERSION

ENV DOCKER_GID=281 \
    HEALTH_SERVER_ADDRESS=127.0.0.1:9999 \
    LOG_LEVEL=info \
    TZ=UTC

USER root
WORKDIR /app

RUN \
    apk add --no-cache \
        bash \
        ca-certificates \
        catatonit \
        coreutils \
        docker-cli \
        go \
        jq \
        shadow \
        tzdata \
    && \
    wget -O - "https://github.com/qdm12/deunhealth/archive/refs/tags/${VERSION}.tar.gz" \
        | tar xzf - -C /app --strip-components=1 \
    && cd /app \
    && go build cmd/app/main.go \
    && addgroup -S -g ${DOCKER_GID} docker \
    && adduser nobody docker \
    && chown -R nobody:nogroup /app && chmod -R 755 /app

COPY . /
RUN chmod +x /entrypoint.sh

USER nobody:nogroup

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]