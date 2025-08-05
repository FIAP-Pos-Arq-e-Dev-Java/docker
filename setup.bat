@echo off
setlocal enabledelayedexpansion

:: Parar se ocorrer qualquer erro
set "ERRORLEVEL_CHECK=0"

:: Detectar se docker-compose existe (com ou sem hífen)
where docker-compose >nul 2>nul
if %ERRORLEVEL%==0 (
    set "DOCKER_COMPOSE_COMMAND=docker-compose"
) else (
    docker compose version >nul 2>nul
    if %ERRORLEVEL%==0 (
        set "DOCKER_COMPOSE_COMMAND=docker compose"
    ) else (
        echo Erro: docker-compose não encontrado.
        exit /b 1
    )
)

:: URLs dos repositórios
set "REPO_LOGIN=https://github.com/FIAP-Pos-Arq-e-Dev-Java/ms-login"
set "REPO_RESTAURANTE=https://github.com/FIAP-Pos-Arq-e-Dev-Java/ms-restaurante"

:: Clonar se os diretórios não existirem
if not exist "ms-login" (
    git clone %REPO_LOGIN%
)
if not exist "ms-restaurante" (
    git clone %REPO_RESTAURANTE%
)

:: URL do docker-compose.yaml
set "GIST_RAW_URL=https://gist.githubusercontent.com/Ghustavo516/887bd750beb6a79caecf314a503e5ab3/raw/050670da36d1baa591e6e7fe099fb3af1e6cb26c/docker-compose.yaml"

:: Verifica se curl está disponível
where curl >nul 2>nul
if %ERRORLEVEL%==0 (
    curl -fsSL %GIST_RAW_URL% -o docker-compose.yaml
) else (
    echo Erro: curl não está instalado.
    exit /b 1
)

:: Subir containers
%DOCKER_COMPOSE_COMMAND% up -d
