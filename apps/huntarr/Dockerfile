# syntax=docker/dockerfile:1

FROM ghcr.io/astral-sh/uv:python3.13-alpine
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
    PYTHONPATH=/app

USER root
WORKDIR /app

RUN \
    apk add --no-cache \
        bash \
        ca-certificates \
        catatonit \
        coreutils \
        curl \
        jq \
        tzdata \
    && \
    curl -fsSL "https://github.com/plexguide/Huntarr.io/archive/refs/tags/${VERSION}.tar.gz" \
        | tar xzf - -C /app --strip-components=1 \
    && chown -R root:root /app && chmod -R 755 /app \
    && uv pip install -r requirements.txt \
    && mkdir -p /config/settings /config/stateful /config/user /config/logs

COPY . /

USER nobody:nogroup
WORKDIR /config
VOLUME ["/config", "/data"]

EXPOSE 9705

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]