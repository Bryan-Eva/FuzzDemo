#!/bin/bash

set -e

PROJECT_NAME=fuzzdemo
PROJECT_DIR=$(pwd)/tools/fuzz_framework
OSS_FUZZ_DIR=/tmp/oss-fuzz
LINK_PATH="$OSS_FUZZ_DIR/projects/$PROJECT_NAME"

echo "[*] Full clean of oss-fuzz and linked project"
rm -rf "$OSS_FUZZ_DIR"

echo "[*] Preparing OSS-Fuzz framework..."
if [ ! -d "$OSS_FUZZ_DIR" ]; then
    echo "[*] Cloning OSS-Fuzz to $OSS_FUZZ_DIR..."
    git clone https://github.com/google/oss-fuzz.git "$OSS_FUZZ_DIR"
else
    echo "[*] OSS-Fuzz already exists at $OSS_FUZZ_DIR. Skipping clone."
fi

rm -f "$PROJECT_DIR/Dockerfile"
rm -f "$PROJECT_DIR/project.yaml"
echo "language: python" > "$PROJECT_DIR/project.yaml"

echo "[*] Linking project to oss-fuzz/projects/$PROJECT_NAME"
mkdir -p "$OSS_FUZZ_DIR/projects"
rm -rf "$OSS_FUZZ_DIR/projects/$PROJECT_NAME"
ln -s "$PROJECT_DIR" "$OSS_FUZZ_DIR/projects/$PROJECT_NAME"

echo "[*] Final check for Dockerfile and project.yaml"
ls -lh "$OSS_FUZZ_DIR/projects/$PROJECT_NAME"
cat "$OSS_FUZZ_DIR/projects/$PROJECT_NAME/project.yaml" || echo "❌ project.yaml MISSING"

chmod +x "$OSS_FUZZ_DIR/projects/$PROJECT_NAME/build.sh"

echo "[*] Verifying build.sh in linked path:"
ls -l "$OSS_FUZZ_DIR/projects/$PROJECT_NAME/build.sh"

mkdir -p "$PROJECT_DIR/logs"

echo "[*] Building fuzzers for project: $PROJECT_NAME"

cd "$OSS_FUZZ_DIR"
python3 infra/helper.py build_fuzzers "$PROJECT_NAME"

echo "[*] Running fuzzer..."
python3 infra/helper.py run_fuzzer "$PROJECT_NAME" calc_fuzzer -- --runs=10000 2>&1 | tee "$PROJECT_DIR/logs/fuzz_log.txt"

echo "[*] Fuzzing completed. Crash log (if any) saved to $PROJECT_DIR/logs/fuzz_log.txt"