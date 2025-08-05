#!/bin/bash

set -e  # Parar se ocorrer qualquer erro

# Detecta se docker-compose deve ser chamado com hífen ou espaço
if command -v docker-compose >/dev/null 2>&1; then
    DOCKER_COMPOSE_COMMAND="docker-compose"
elif docker compose version >/dev/null 2>&1; then
    DOCKER_COMPOSE_COMMAND="docker compose"
else
    echo "Erro: docker-compose não encontrado."
    exit 1
fi

# URLs dos repositórios
REPO_LOGIN="https://github.com/FIAP-Pos-Arq-e-Dev-Java/ms-login"
REPO_RESTAURANTE="https://github.com/FIAP-Pos-Arq-e-Dev-Java/ms-restaurante"

# Clonar se os diretórios não existirem
[ ! -d "ms-login" ] && git clone "$REPO_LOGIN"
[ ! -d "ms-restaurante" ] && git clone "$REPO_RESTAURANTE"

# URL do Gist
GIST_RAW_URL="https://gist.githubusercontent.com/Ghustavo516/887bd750beb6a79caecf314a503e5ab3/raw/050670da36d1baa591e6e7fe099fb3af1e6cb26c/docker-compose.yaml"

# Baixar docker-compose.yaml
if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$GIST_RAW_URL" -o docker-compose.yaml
else
    echo "Erro: curl não está instalado"
    exit 1
fi

# Subir containers
$DOCKER_COMPOSE_COMMAND up -d