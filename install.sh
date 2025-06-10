#!/bin/bash
set -e

echo "--- INICIANDO SCRIPT DE INSTALAÇÃO (BUILD-TIME) ---"

# 1. Instala pacotes do sistema
echo "Instalando pacotes do sistema..."
apt-get update && apt-get install -y --no-install-recommends git wget ffmpeg

# 2. Instala Custom Nodes e suas dependências
echo "Instalando Custom Nodes..."
cd /app/ComfyUI/custom_nodes

# Node: PuLID
echo "Instalando PuLID..."
git clone https://github.com/lldacing/ComfyUI_PuLID_Flux_ll.git
pip install -r ComfyUI_PuLID_Flux_ll/requirements.txt
pip install --no-cache-dir insightface==0.7.3 facexlib onnxruntime-gpu timm

# Node: Kokoro
echo "Instalando comfyui-kokoro..."
git clone https://github.com/stavsap/comfyui-kokoro.git
pip install -r comfyui-kokoro/requirements.txt || echo "AVISO: Kokoro não tem requirements.txt ou falhou."

# Node: Whisper
echo "Instalando ComfyUI-Whisper..."
git clone https://github.com/yuvraj108c/ComfyUI-Whisper.git
pip install -r ComfyUI-Whisper/requirements.txt || echo "AVISO: Whisper não tem requirements.txt ou falhou."

# Node: Save_Flux_Image
echo "Instalando ComfyUI_Save_Flux_Image..."
git clone https://github.com/tc888/ComfyUI_Save_Flux_Image.git
pip install -r ComfyUI_Save_Flux_Image/requirements.txt || echo "AVISO: Save_Flux_Image não tem requirements.txt ou falhou."

# Node: comfy-image-saver
echo "Instalando comfy-image-saver..."
git clone https://github.com/giriss/comfy-image-saver.git
pip install -r comfy-image-saver/requirements.txt || echo "AVISO: comfy-image-saver não tem requirements.txt ou falhou."

# 3. Baixa todos os modelos para dentro da imagem
echo "Baixando modelos... (Isso pode demorar bastante)"
cd /app/ComfyUI
mkdir -p models/insightface models/pulid models/diffusion_models models/text_encoders models/vae models/upscale_models models/loras

# Baixa InsightFace
git clone https://huggingface.co/Aitrepreneur/insightface ./models/insightface

# Baixa PuLID
wget -O ./models/pulid/pulid_flux_v0.9.0.safetensors "https://huggingface.co/guozinan/PuLID/resolve/main/pulid_flux_v0.9.0.safetensors?download=true"

# Baixa Modelos FLUX (Usa o token passado no build)
wget -O ./models/diffusion_models/flux1-dev.safetensors --header="Authorization: Bearer ${HUGGING_FACE_TOKEN}" https://huggingface.co/black-forest-labs/FLUX.1-dev/resolve/main/flux1-dev.safetensors
# ... e os outros wgets ...

# 4. Limpa o cache do apt para reduzir o tamanho final da imagem
apt-get clean && rm -rf /var/lib/apt/lists/*

echo "--- SCRIPT DE INSTALAÇÃO CONCLUÍDO ---"