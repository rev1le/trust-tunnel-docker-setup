#!/bin/bash
set -e

CONTAINER_NAME="trust-tunnel"
FLAG="${1:-false}"

if docker inspect "$CONTAINER_NAME" > /dev/null 2>&1; then
    echo "Останавливаем контейнер: $CONTAINER_NAME"
    docker rm -f "$CONTAINER_NAME"
else
    echo "Контейнер '$CONTAINER_NAME' не найден, пропускаем"
fi

docker build -t trust-tunnel-docker:latest .

if [ "$FLAG" = "true" ]; then
    docker run \
        --name "$CONTAINER_NAME" \
        -v ./configs:/app/configs \
        -v ./certs:/app/certs \
        -p 443:443 \
        -it \
        --entrypoint "bash" \
        trust-tunnel-docker:latest \
        -c "/app/trusttunnel/setup_wizard"
    # Действия для true
fi

# if ["$FLAG" = "true" ]
# then
#     echo "Hello"
# fi

docker run \
    --name "$CONTAINER_NAME" \
    -v ./configs:/app/configs \
    -v ./certs:/app/certs \
    -p 443:443 \
    -d \
    --entrypoint "bash" \
    trust-tunnel-docker:latest \
    -c "/app/trusttunnel/trusttunnel_endpoint -l debug /app/configs/vpn.toml /app/configs/hosts.toml"
