#!/usr/bin/env bash
#shellcheck disable=SC2086

if [ -S /var/run/docker.sock ]; then
    if ! docker ps >/dev/null 2>&1; then
        echo "ERROR: Cannot access Docker socket. Please set the correct DOCKER_GID environment variable."
        echo "You can find your Docker GID by running 'getent group docker' on your host system."
        echo "Current DOCKER_GID is set to: ${DOCKER_GID}"
    fi
fi

exec /app/main "$@"