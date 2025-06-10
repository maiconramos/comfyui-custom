#!/bin/bash
set -e

echo "--- INICIANDO WORKER (RUN-TIME) ---"

# Navega para o diretório do ComfyUI
cd /app/ComfyUI

# Inicia o ComfyUI para o RunPod Serverless
# O RunPod gerencia as portas, então usamos --port 8000 como padrão para o handler.
# O --listen 0.0.0.0 garante que ele aceite conexões de fora do contêiner.
echo "Iniciando ComfyUI na porta 8000..."
python3 main.py --listen 0.0.0.0 --port 8000