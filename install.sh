#!/bin/bash
set -e

echo "--- INICIANDO SCRIPT DE INSTALAÇÃO (BUILD-TIME) ---"
# O WORKDIR no Dockerfile garante que já estamos em /ComfyUI.
# A pasta ./custom_nodes já existe aqui.

# 1. Instala pacotes do sistema
echo "Instalando pacotes do sistema..."
apt-get update && apt-get install -y --no-install-recommends git wget ffmpeg

# 2. Instala Custom Nodes e suas dependências
echo "Instalando Custom Nodes..."
cd ./custom_nodes

# Node: PuLID (se a variável de ambiente for verdadeira)
if [[ "${install_pulid}" == "true" ]]; then
    echo "Instalando PuLID..."
    if [ ! -d "ComfyUI_PuLID_Flux_ll" ]; then git clone https://github.com/lldacing/ComfyUI_PuLID_Flux_ll.git; fi
    pip install -r ComfyUI_PuLID_Flux_ll/requirements.txt
    pip install --no-cache-dir insightface==0.7.3 facexlib onnxruntime-gpu timm
fi

# Node: Kokoro
echo "Instalando comfyui-kokoro..."
if [ ! -d "comfyui-kokoro" ]; then git clone https://github.com/stavsap/comfyui-kokoro.git; fi
pip install -r comfyui-kokoro/requirements.txt || echo "AVISO: Kokoro não tem requirements.txt ou falhou."

# Node: Whisper
echo "Instalando ComfyUI-Whisper..."
if [ ! -d "ComfyUI-Whisper" ]; then git clone https://github.com/yuvraj108c/ComfyUI-Whisper.git; fi
pip install -r ComfyUI-Whisper/requirements.txt || echo "AVISO: Whisper não tem requirements.txt ou falhou."

# Node: Save_Flux_Image
echo "Instalando ComfyUI_Save_Flux_Image..."
if [ ! -d "ComfyUI_Save_Flux_Image" ]; then git clone https://github.com/tc888/ComfyUI_Save_Flux_Image.git; fi
pip install -r ComfyUI_Save_Flux_Image/requirements.txt || echo "AVISO: Save_Flux_Image não tem requirements.txt ou falhou."

# Node: comfy-image-saver
echo "Instalando comfy-image-saver..."
if [ ! -d "comfy-image-saver" ]; then git clone https://github.com/giriss/comfy-image-saver.git; fi
pip install -r comfy-image-saver/requirements.txt || echo "AVISO: comfy-image-saver não tem requirements.txt ou falhou."

# 3. Baixa modelos (se necessário)
echo "Baixando modelos (se configurado)..."
cd /ComfyUI # Volta para a pasta principal do ComfyUI
# (Toda a sua lógica de wget para baixar modelos permanece aqui)
# Exemplo: wget -O ./models/pulid/modelo.safetensors ...

# 4. Limpa o cache do apt para reduzir o tamanho final da imagem
apt-get clean && rm -rf /var/lib/apt/lists/*

echo "--- SCRIPT DE INSTALAÇÃO CONCLUÍDO COM SUCESSO! ---"