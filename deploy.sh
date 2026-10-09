#!/usr/bin/env bash
set -Eeuo pipefail

IMAGE="${IMAGE:-docker.io/bhuvnesh15/jenkins-docker-cicd}"
TAG="${TAG:?TAG is required}"
DIR="/var/lib/jenkins/rolling-deploy"
STATE="$DIR/last-good-tag"

PREVIOUS_TAG="$(cat "$STATE" 2>/dev/null || echo 10)"

wait_healthy() {
    local port="$1"
    local attempt

    for attempt in $(seq 1 30); do
        if curl -fsS --max-time 2 \
            "http://127.0.0.1:${port}/" >/dev/null; then
            return 0
        fi
        sleep 2
    done
    return 1
}

replace_slot() {
    local name="$1"
    local port="$2"
    local image="$3"

    podman rm -f "$name" >/dev/null 2>&1 || true

    podman run -d \
        --name "$name" \
        -p "127.0.0.1:${port}:80" \
        "$image"

    wait_healthy "$port"
}

rollback() {
    echo "Rolling back to release $PREVIOUS_TAG"
    local previous_image="$IMAGE:$PREVIOUS_TAG"

    podman pull "$previous_image"

    replace_slot rolling-app-a 18081 "$previous_image"
    replace_slot rolling-app-b 18082 "$previous_image"

    curl -fsS http://127.0.0.1:18083/ >/dev/null
    printf '%s\n' "$PREVIOUS_TAG" > "$STATE"
    echo "Rollback verified: $previous_image"
}

mkdir -p "$DIR"
podman pull "$IMAGE:$TAG"

if ! replace_slot rolling-app-a 18081 "$IMAGE:$TAG"; then
    rollback
    exit 1
fi

echo "Instance A healthy on release $TAG"

if ! replace_slot rolling-app-b 18082 "$IMAGE:$TAG"; then
    rollback
    exit 1
fi

echo "Instance B healthy on release $TAG"

if ! curl -fsS http://127.0.0.1:18083/ >/dev/null; then
    rollback
    exit 1
fi

printf '%s\n' "$TAG" > "$STATE"
echo "Deployment successful: $IMAGE:$TAG"
