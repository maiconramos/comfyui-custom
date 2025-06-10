# 1. Imagem Base
FROM hearmeman/comfyui-flux-pulid:v1

# 2. Argumento de build para o token.
ARG HUGGING_FACE_TOKEN

# 3. Define o WORKDIR diretamente para a pasta do ComfyUI que já existe na imagem.
#    Isso simplifica todos os caminhos nos scripts.
WORKDIR /ComfyUI

# 4. Copia seus scripts para o diretório de trabalho atual (/ComfyUI)
#    E os workflows para a pasta de workflows correta.
COPY install.sh start.sh ./
COPY *.json ./user/workflows/

# 5. ETAPA DE BUILD: Dá permissão e executa o script de instalação.
RUN chmod +x install.sh start.sh && /bin/bash ./install.sh

# 6. ETAPA DE EXECUÇÃO: Define a porta e o comando de inicialização.
EXPOSE 8000
CMD ["/bin/bash", "./start.sh"]