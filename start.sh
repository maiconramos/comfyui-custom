#!/bin/bash
set -e

echo "--- INICIANDO WORKER (RUN-TIME) ---"
# O WORKDIR do Dockerfile garante que este script já executa dentro de /ComfyUI

echo "Iniciando ComfyUI na porta 8000..."
python3 main.py --listen 0.0.0.0 --port 8000