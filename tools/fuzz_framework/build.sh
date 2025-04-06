#!/bin/bash -eu

pip3 install --upgrade pip
pip3 install atheris

cp $SRC/tools/fuzz_framework/fuzz_targets/calc_fuzzer.py $OUT/

echo "[*] Listing files in $OUT"
ls -lh $OUT