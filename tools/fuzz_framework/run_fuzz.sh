#!/bin/bash
echo "💥💥💥💥💥💥💥💥 THIS IS REAL run_fuzz.sh BEING EXECUTED💥💥💥💥💥"
set -e

PROJECT_NAME=fuzzdemo
PROJECT_DIR=$(pwd)/tools/fuzz_framework
OSS_FUZZ_DIR=/tmp/oss-fuzz
PROJECT_TARGET="$OSS_FUZZ_DIR/projects/$PROJECT_NAME"

echo "[*] Rebuilding OSS-Fuzz......"
rm -rf "$OSS_FUZZ_DIR"
git clone https://github.com/google/oss-fuzz.git "$OSS_FUZZ_DIR"

echo "[*] Preparing OSS-Fuzz project dir..."
rm -rf "$PROJECT_TARGET"
mkdir -p "$PROJECT_TARGET"

cp "$PROJECT_DIR/build.sh" "$PROJECT_TARGET/"
cp "$PROJECT_DIR/project.yaml" "$PROJECT_TARGET/"
mkdir -p "$PROJECT_TARGET/fuzz_targets"
cp "$PROJECT_DIR/fuzz_targets/calc_fuzzer.py" "$PROJECT_TARGET/fuzz_targets/"

rm -f "$PROJECT_TARGET/Dockerfile"

chmod +x "$PROJECT_TARGET/build.sh"

mkdir -p "$PROJECT_DIR/logs"

echo "[*] Building fuzzers for project: $PROJECT_NAME"
cd "$OSS_FUZZ_DIR"
python3 infra/helper.py build_fuzzers "$PROJECT_NAME"

echo "[*] Running fuzzer..."
python3 infra/helper.py run_fuzzer "$PROJECT_NAME" calc_fuzzer -- --runs=10000 2>&1 | tee "$PROJECT_DIR/logs/fuzz_log.txt"

echo "[*] Fuzzing completed. Crash log (if any) saved to $PROJECT_DIR/logs/fuzz_log.txt"