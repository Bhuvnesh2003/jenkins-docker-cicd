#!/usr/bin/env bash
set -Eeuo pipefail

IMAGE="${IMAGE:-docker.io/bhuvnesh15/jenkins-docker-cicd}"
TAG="${TAG:?TAG is required}"
DIR="/var/lib/jenkins/rolling-deploy"
STATE="$DIR/last-good-tag"
CONFIG_DIR="$DIR/nginx"

mkdir -p "$CONFIG_DIR"

cat > "$CONFIG_DIR/app-a.conf" <<'NGINX_A'
server {
    listen 18081;
    server_name localhost;
    root /usr/share/nginx/html;
    index index.html;
    location / { try_files $uri $uri/ =404; }
}
NGINX_A

cat > "$CONFIG_DIR/app-b.conf" <<'NGINX_B'
server {
    listen 18082;
    server_name localhost;
    root /usr/share/nginx/html;
    index index.html;
    location / { try_files $uri $uri/ =404; }
}
NGINX_B

PREVIOUS_TAG="$(cat "$STATE" 2>/dev/null || echo 10)"

wait_healthy() {
    local port="$1"
    local attempt
    for attempt in $(seq 1 30); do
        if curl -fsS --max-time 2 "http://127.0.0.1:${port}/" >/dev/null; then
            return 0
        fi
        sleep 2
    done
    return 1
}

replace_slot() {
    local name="$1"
    local port="$2"
    local config="$3"
    local image="$4"

    podman rm -f "$name" >/dev/null 2>&1 || true

    podman run -d \
        --name "$name" \
        -p "127.0.0.1:${port}:8080" \
        --security-opt label=disable \
        "$image"

    wait_healthy "$port"
}
ensure_proxy() {
    if podman ps --format '{{.Names}}' | grep -qx rolling-proxy2; then
        :
    elif podman ps -a --format '{{.Names}}' | grep -qx rolling-proxy2; then
        podman start rolling-proxy2 || true
    else
        podman run -d \
            --name rolling-proxy2 \
            --network host \
            --security-opt label=disable \
            -v "$CONFIG_DIR/default.conf:/etc/nginx/conf.d/default.conf:ro" \
            docker.io/library/nginx:alpine
    fi
    local attempt
    for attempt in $(seq 1 15); do
        if curl -fsS --max-time 2 "http://127.0.0.1:18083/" >/dev/null; then
            return 0
        fi
        sleep 2
    done
    return 1
}

rollback() {
    echo "Rolling back to release $PREVIOUS_TAG"
    local previous_image="$IMAGE:$PREVIOUS_TAG"

    podman pull "$previous_image"

    replace_slot rolling-app-a 18081 "$CONFIG_DIR/app-a.conf" "$previous_image"
    replace_slot rolling-app-b 18082 "$CONFIG_DIR/app-b.conf" "$previous_image"

    ensure_proxy || echo "WARNING: proxy could not be started during rollback"
    curl -fsS --max-time 5 http://127.0.0.1:18083/ >/dev/null || echo "WARNING: proxy check failed after rollback"

    printf '%s\n' "$PREVIOUS_TAG" > "$STATE"
    echo "Rollback verified: $previous_image"
}

podman pull "$IMAGE:$TAG"

if ! replace_slot rolling-app-a 18081 "$CONFIG_DIR/app-a.conf" "$IMAGE:$TAG"; then
    echo "App A failed health check"
    rollback
    exit 1
fi

echo "Instance A healthy on release $TAG"
if [[ "${TEST_FORCE_FAILURE:-0}" == "1" ]]; then
    echo "Simulated failure after App A; triggering rollback"
    rollback
    exit 1
fi

if ! replace_slot rolling-app-b 18082 "$CONFIG_DIR/app-b.conf" "$IMAGE:$TAG"; then
    echo "App B failed health check"
    rollback
    exit 1
fi

echo "Instance B healthy on release $TAG"
if ! ensure_proxy; then
    echo "Proxy failed to start"
    rollback
    exit 1
fi

if ! curl -fsS --max-time 5 http://127.0.0.1:18083/ | grep -Fq "Release: $TAG"; then
    echo "Proxy verification failed"
    rollback
    exit 1
fi

printf '%s\n' "$TAG" > "$STATE"
echo "Deployment successful: $IMAGE:$TAG"
