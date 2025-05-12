# syntax=docker/dockerfile:1

FROM docker.io/library/python:3.13-alpine3.21
ARG VERSION

ENV \
    CRYPTOGRAPHY_DONT_BUILD_RUST=1 \
    PIP_BREAK_SYSTEM_PACKAGES=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_ROOT_USER_ACTION=ignore \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    UV_NO_CACHE=true \
    UV_SYSTEM_PYTHON=true \
    CONFIG_DIR=/config \
    CONFIG_FILE=/config/arrranger_instances.json \
    CRON_SCHEDULE="0 * * * *" \
    DATA_DIR=/data \
    DB_NAME=/data/arrranger.db

USER root
WORKDIR /app

RUN \
    apk add --no-cache \
        bash \
        ca-certificates \
        catatonit \
        coreutils \
        cronie \
        jq \
        smartmontools \
        sqlite-libs \
        tzdata \
    && \
    wget -O - "https://github.com/lucanori/arrranger/archive/refs/tags/${VERSION}.tar.gz" \
        | tar xzf - -C /app --strip-components=1 \
    && pip install uv \
    && chown -R root:root /app && chmod -R 755 /app \
    && ls -la /app \
    && cd /app \
    && uv sync --frozen \
    && mkdir -p /config /data

COPY . /

USER nobody:nogroup
WORKDIR /config
VOLUME ["/config", "/data"]

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]