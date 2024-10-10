#!/bin/bash

cd /cvat

docker compose -f docker-compose.yml -f docker-compose.dev.yml -f components/serverless/docker-compose.serverless.yml up -d --build

docker compose -f docker-compose.yml -f docker-compose.dev.yml -f components/serverless/docker-compose.serverless.yml down

wget https://github.com/nuclio/nuclio/releases/download/1.8.14/nuctl-1.8.14-linux-amd64

chmod +x nuctl-1.8.14-linux-amd64

ln -sf $(pwd)/nuctl-1.8.14-linux-amd64 /usr/local/bin/nuctl

docker compose -f docker-compose.yml -f docker-compose.dev.yml -f components/serverless/docker-compose.serverless.yml up -d

./serverless/deploy_cpu.sh serverless/pytorch/facebookresearch/sam/nuclio/
