FROM ghcr.io/astral-sh/uv:python3.12-bookworm-slim
ARG VENDOR
ARG APP_COMMIT_SHA
WORKDIR /app
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    gosu \
    tzdata \
    curl \
    unzip \
    git \
    && rm -rf /var/lib/apt/lists/*

ENV UV_COMPILE_BYTECODE=1
ENV UV_LINK_MODE=copy
ENV PYTHONUNBUFFERED=1
ENV VIRTUAL_ENV=/app/.venv
RUN uv venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

RUN git clone --depth 1 https://github.com/lucanori/arrranger.git /app_tmp \
    && cd /app_tmp \
    && ARRRANGER_COMMIT_SHA=$(git rev-parse --short HEAD) \
    && echo "Cloned arrranger commit: $ARRRANGER_COMMIT_SHA" \
    && cd / \
    && mv /app_tmp/* /app/ \
    && mv /app_tmp/.* /app/ || true \
    && rm -rf /app_tmp \
    && cd /app \
    && echo $ARRRANGER_COMMIT_SHA > /app/ARRRANGER_COMMIT_SHA.txt

ENV ARRRANGER_COMMIT_SHA_ENV=${APP_COMMIT_SHA:-$(cat /app/ARRRANGER_COMMIT_SHA.txt)}

RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen --no-install-project --no-dev

RUN mkdir -p /config /data
ENV CONFIG_DIR=/config
ENV DATA_DIR=/data
ENV CONFIG_FILE=/config/arrranger_instances.json
ENV DB_NAME=/data/arrranger.db

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

RUN chmod -R 755 /app /config /data \
    && chown -R nobody:nogroup /app /config /data

RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen --no-dev

RUN apt-get purge -y --auto-remove git curl unzip \
    && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["uv", "run", "arrranger_sync.py"]