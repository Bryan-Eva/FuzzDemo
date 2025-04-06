#!/bin/bash
set -e

# === check docker login === 
echo "[DEBUG] DockerHub: Auth..."
docker info | grep bryanjhuo || echo "Not login dockerhub"

# === pull python:3.8-slim ===
docker pull python:3.8-slim || echo "[!] Docker pull default"

# === basic parameter confing ===
PROJECT_NAME="fuzzdemo"
PROJECT_DIR=$(pwd)
FRAMEWORK_DIR="$PROJECT_DIR/tools/fuzz_framework"
CLUSTERFUZZ_DIR="/tmp/clusterfuzz"
LOG_DIR="$FRAMEWORK_DIR/logs"

# === build directory ===
mkdir -p "$LOG_DIR"

# === clone ClusterFuzz(if not exists) ===
if [ ! -d "$CLUSTERFUZZ_DIR" ]; then
    echo "[*] Cloning ClusterFuzz..."
    git clone https://github.com/google/clusterfuzz.git "$CLUSTERFUZZ_DIR"
fi

# === user docker run fuzz test ===
echo "[*] Building Docker image for fuzzing..."
export DOCKER_BUILDKIT=0
docker build --pull=false -t fuzzdemo-fuzzer "$FRAMEWORK_DIR"

echo "[*] Running fuzzer container..."
docker run --rm -v "$LOG_DIR:/out" fuzzdemo-fuzzer