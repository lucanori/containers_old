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
    PYTHONPATH=/app \
    TZ=UTC

USER root
WORKDIR /app

RUN \
    apk add --no-cache \
        bash \
        ca-certificates \
        catatonit \
        coreutils \
        jq \
        smartmontools \
        tzdata \
    && \
    wget -O - "https://github.com/lucanori/web2md/archive/refs/tags/${VERSION}.tar.gz" \
        | tar xzf - -C /app --strip-components=1 \
    && chown -R root:root /app && chmod -R 755 /app \
    && rm -rf /app/searxng /app/dev \
    && pip install uv \
    && uv pip install -r requirements.txt \
    && uv pip install watchgod \
    && chown -R nobody:nogroup /app && chmod -R 755 /app

COPY . /
RUN chmod +x /entrypoint.sh

USER nobody:nogroup

EXPOSE 8000

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]