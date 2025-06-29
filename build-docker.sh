#!/bin/bash

# Script para testar o build do Docker
echo "🐳 Iniciando build do Docker..."

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Função para log
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

error() {
    echo -e "${RED}[ERRO] $1${NC}"
}

warning() {
    echo -e "${YELLOW}[AVISO] $1${NC}"
}

# Verificar se o Docker está instalado
if ! command -v docker &> /dev/null; then
    error "Docker não está instalado"
    exit 1
fi

# Verificar se estamos no diretório correto
if [ ! -f "package.json" ]; then
    error "Execute este script na raiz do projeto"
    exit 1
fi

# Verificar se o Dockerfile existe
if [ ! -f "Dockerfile" ]; then
    error "Dockerfile não encontrado"
    exit 1
fi

# Nome da imagem
IMAGE_NAME="site-fotos"
TAG="latest"

log "Construindo imagem Docker..."
if docker build -t $IMAGE_NAME:$TAG .; then
    log "✅ Build do Docker concluído com sucesso!"
    
    log "🧪 Testando a imagem..."
    if docker run --rm -p 3001:3001 --env-file .env $IMAGE_NAME:$TAG npm start --dry-run > /dev/null 2>&1; then
        log "✅ Teste da imagem bem-sucedido!"
    else
        warning "⚠️  Teste da imagem falhou, mas o build foi bem-sucedido"
    fi
    
    log "📋 Informações da imagem:"
    docker images $IMAGE_NAME:$TAG
    
    log "🚀 Para executar localmente:"
    echo "   docker run -p 3001:3001 --env-file .env $IMAGE_NAME:$TAG"
    
    log "📦 Para fazer push para o registry:"
    echo "   docker tag $IMAGE_NAME:$TAG seu-registry/$IMAGE_NAME:$TAG"
    echo "   docker push seu-registry/$IMAGE_NAME:$TAG"
    
else
    error "❌ Build do Docker falhou"
    exit 1
fi 