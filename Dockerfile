FROM python:3.11-slim-bookworm


RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates git git-lfs && \
    rm -rf /var/lib/apt/lists/*

#ADDING THE FORTINET ROOT CA
COPY fortinet_root.pem /usr/local/share/ca-certificates/fortinet_root.crt
RUN update-ca-certificates


#Install Python Dependencies

COPY requirements.txt .
RUN pip install --no-cache-dir --index-url https://download.pytorch.org/whl/cpu torch==2.8.0
RUN pip install --no-cache-dir -r  requirements.txt

#sentence transformers

ENV HF_HOME=/opt/huggingface \
    TRANSFORMERS_CACHE=/opt/huggingface \
    SENTENCE_TRANSFORMERS_HOME=/opt/huggingface


COPY src/ /app/src/
COPY config.yaml /app/config.yaml
WORKDIR /app

EXPOSE 8080

# Startup: download model once if not present, then run app
CMD ["bash", "-c", "\
python - <<'PY'\n\
import os\n\
from huggingface_hub import snapshot_download\n\
path='/opt/huggingface/models/intfloat/e5-large-v2'\n\
if not os.path.exists(path):\n\
    print('Downloading model for the first time...')\n\
    snapshot_download('intfloat/e5-large-v2', local_dir=path, local_dir_use_symlinks=False)\n\
else:\n\
    print('Model already exists. Skipping download.')\n\
PY\n\
&& python -m src.main_vanna"]