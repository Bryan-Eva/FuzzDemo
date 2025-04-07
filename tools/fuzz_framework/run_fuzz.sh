#!/bin/bash
set -e

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

# === exec fuzz task ===
echo "[*] Running ClusterFuzz fuzz bot..."
python3 "$CLUSTERFUZZ_DIR/src/python/bot/tasks/fuzz_task.py" \
    --fuzzer_name=a_atheris \
    --target_path="$FRAMEWORK_DIR/fuzz_targets/calc_fuzzer.py" \
    --max_total_time=20 \
    --output_path="$LOG_DIR"

echo "[*]Done. Crash logs (if any) are in $LOG_DIR"