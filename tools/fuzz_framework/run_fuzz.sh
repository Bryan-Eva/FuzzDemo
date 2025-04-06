#!/bin/bash

set -e

PROJECT_NAME=FuzzDemo
PROJECT_DIR=$(pwd)/tools/fuzz/frame
OSS_FUZZ_DIR=/tmp/oss-fuzz
LINK_PATH="$OSS_FUZZ_DIR/projects/$PROJECT_NAME"

echo "[*] Preparing OSS-Fuzz framework..."

if [ ! -d "$OSS_FUZZ_DIR" ]; then
    echo "[*] Cloning OSS-Fuzz to $OSS_FUZZ_DIR..."
    git clone https://github.com/google/oss-fuzz.git $OSS_FUZZ_DIR
else
    echo "[*] OSS-Fuzz already exists at $OSS_FUZZ_DIR. Skipping clone."
fi

echo "[*] Linking project to oss-fuzz/projects/$PROJECT_NAME"
mkdir -p "$OSS_FUZZ_DIR/projects"
rm -rf "$LINK_PATH"
ln -s "$PROJECT_DIR" "$LINK_PATH"

mkdir -p "$PROJECT_DIR/logs"

echo "[*] Building Docker fuzz image for project: $PROJECT_NAME"

cd "$OSS_FUZZ_DIR"
python3 infra/helper.py build_image "$PROJECT_NAME"

echo "[*] Running fuzzer..."
python3 infra/helper.py run_fuzzer "$PROJECT_NAME" fuzz_calc -- --runs=10000 2>&1 | tee "$PROJECT_DIR/logs/fuzz_log.txt"

echo "[*] Fuzzing completed. Crash log (if any) saved to $PROJECT_DIR/logs/fuzz_log.txt"