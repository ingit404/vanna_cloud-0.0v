#!/usr/bin/env bash
set -e

echo "🔍 Checking model directory..."
python - <<'PY'
import os
from huggingface_hub import snapshot_download

path = '/opt/huggingface/models/intfloat/e5-large-v2'
if not os.path.exists(path):
    print('📥 Downloading model for the first time...')
    snapshot_download('intfloat/e5-large-v2', local_dir=path, local_dir_use_symlinks=False)
else:
    print('✅ Model already exists. Skipping download.')
PY

echo "🚀 Starting Vanna app..."
exec python -m src.main_vanna
