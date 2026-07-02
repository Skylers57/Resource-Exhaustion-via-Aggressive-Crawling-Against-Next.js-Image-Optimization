#!/bin/bash
set -euo pipefail

TARGET_URL="${1:-https://target-web.com/}"
OUTPUT_DIR="${2:-./output}"
USER_AGENT="${3:-Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/120.0.0.0}"

if [[ ! -d "$OUTPUT_DIR" ]]; then
  mkdir -p "$OUTPUT_DIR"
fi

echo "[INFO] Menjalankan mirror crawl ke $TARGET_URL"
echo "[INFO] Output disimpan di $OUTPUT_DIR"

echo "[INFO] Catatan: gunakan hanya pada target yang Anda miliki izin untuk diuji"

wget \
  --mirror \
  --page-requisites \
  --adjust-extension \
  --convert-links \
  --no-parent \
  --user-agent="$USER_AGENT" \
  --wait=2 \
  --limit-rate=200k \
  --directory-prefix="$OUTPUT_DIR" \
  "$TARGET_URL"

echo "[INFO] Selesai. Hasil tersimpan di $OUTPUT_DIR"
