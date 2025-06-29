#!/bin/bash

# Script de Deploy para Easy Panel
# Autor: Sistema de Fotos
# Data: $(date)

echo "🚀 Iniciando deploy no Easy Panel..."

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

# Verificar se estamos no diretório correto
if [ ! -f "package.json" ]; then
    error "Execute este script na raiz do projeto"
    exit 1
fi

# Verificar se o .env existe
if [ ! -f ".env" ]; then
    warning "Arquivo .env não encontrado. Criando exemplo..."
    cp config.env.example .env
    error "Configure as variáveis de ambiente no arquivo .env antes de continuar"
    exit 1
fi

# Verificar se o git está configurado
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    error "Este diretório não é um repositório git"
    exit 1
fi

# Verificar se há mudanças não commitadas
if [ -n "$(git status --porcelain)" ]; then
    warning "Há mudanças não commitadas. Deseja continuar? (y/N)"
    read -r response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        log "Deploy cancelado"
        exit 0
    fi
fi

# Build do frontend
log "Construindo frontend..."
cd frontend-fotos
if ! npm run build; then
    error "Erro ao construir o frontend"
    exit 1
fi
cd ..

# Testar se o backend inicia
log "Testando backend..."
if ! npm start --dry-run > /dev/null 2>&1; then
    error "Erro ao testar o backend"
    exit 1
fi

# Commit das mudanças
log "Fazendo commit das mudanças..."
git add .
git commit -m "Deploy: $(date +'%Y-%m-%d %H:%M:%S')"

# Push para o repositório
log "Enviando para o repositório..."
if ! git push origin main; then
    error "Erro ao fazer push para o repositório"
    exit 1
fi

log "✅ Deploy iniciado com sucesso!"
log "📋 Próximos passos:"
echo "   1. Acesse o Easy Panel"
echo "   2. Verifique se o deploy está em andamento"
echo "   3. Configure as variáveis de ambiente"
echo "   4. Configure os domínios"
echo "   5. Teste a aplicação"

log "🔗 URLs esperadas:"
echo "   - Frontend: https://app.seudominio.com"
echo "   - API: https://api.seudominio.com"
echo "   - Health Check: https://api.seudominio.com/health"

log "📚 Documentação:"
echo "   - Deploy: DEPLOY_EASYPANEL.md"
echo "   - Google OAuth: GOOGLE_OAUTH_SETUP.md"
echo "   - Testes: TESTE_GOOGLE_LOGIN.md" 