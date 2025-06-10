# 1. Imagem Base
FROM hearmeman/comfyui-flux-pulid:v1

# 2. Argumento de build para o token do Hugging Face.
#    Você vai configurar isso nas variáveis de ambiente do seu endpoint no RunPod.
ARG HUGGING_FACE_TOKEN

# 3. Copia todos os seus arquivos (scripts, workflows) para dentro da imagem.
COPY . /app

# 4. Define o diretório de trabalho.
WORKDIR /app

# 5. ETAPA DE BUILD: Dá permissão e executa o script de INSTALAÇÃO.
#    Isso acontece uma vez, quando o RunPod constrói a imagem para você.
RUN chmod +x install.sh start.sh && \
    /bin/bash ./install.sh

# 6. ETAPA DE EXECUÇÃO: Define o comando que será executado quando um worker iniciar.
EXPOSE 3000
CMD ["/bin/bash", "./start.sh"]