# Script de Deploy para Easy Panel (PowerShell)
# Autor: Sistema de Fotos
# Data: $(Get-Date)

Write-Host "🚀 Iniciando deploy no Easy Panel..." -ForegroundColor Green

# Função para log
function Write-Log {
    param([string]$Message)
    Write-Host "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $Message" -ForegroundColor Green
}

function Write-Error {
    param([string]$Message)
    Write-Host "[ERRO] $Message" -ForegroundColor Red
}

function Write-Warning {
    param([string]$Message)
    Write-Host "[AVISO] $Message" -ForegroundColor Yellow
}

# Verificar se estamos no diretório correto
if (-not (Test-Path "package.json")) {
    Write-Error "Execute este script na raiz do projeto"
    exit 1
}

# Verificar se o .env existe
if (-not (Test-Path ".env")) {
    Write-Warning "Arquivo .env não encontrado. Criando exemplo..."
    Copy-Item "config.env.example" ".env"
    Write-Error "Configure as variáveis de ambiente no arquivo .env antes de continuar"
    exit 1
}

# Verificar se o git está configurado
try {
    git rev-parse --git-dir | Out-Null
} catch {
    Write-Error "Este diretório não é um repositório git"
    exit 1
}

# Verificar se há mudanças não commitadas
$gitStatus = git status --porcelain
if ($gitStatus) {
    Write-Warning "Há mudanças não commitadas. Deseja continuar? (y/N)"
    $response = Read-Host
    if ($response -notmatch "^[Yy]$") {
        Write-Log "Deploy cancelado"
        exit 0
    }
}

# Build do frontend
Write-Log "Construindo frontend..."
Set-Location "frontend-fotos"
try {
    npm run build
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Erro ao construir o frontend"
        exit 1
    }
} catch {
    Write-Error "Erro ao construir o frontend"
    exit 1
}
Set-Location ".."

# Testar se o backend inicia
Write-Log "Testando backend..."
try {
    # Verificar se o package.json tem o script start
    $packageJson = Get-Content "package.json" | ConvertFrom-Json
    if (-not $packageJson.scripts.start) {
        Write-Error "Script 'start' não encontrado no package.json"
        exit 1
    }
} catch {
    Write-Error "Erro ao testar o backend"
    exit 1
}

# Commit das mudanças
Write-Log "Fazendo commit das mudanças..."
git add .
git commit -m "Deploy: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"

# Push para o repositório
Write-Log "Enviando para o repositório..."
try {
    git push origin main
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Erro ao fazer push para o repositório"
        exit 1
    }
} catch {
    Write-Error "Erro ao fazer push para o repositório"
    exit 1
}

Write-Log "✅ Deploy iniciado com sucesso!"
Write-Log "📋 Próximos passos:"
Write-Host "   1. Acesse o Easy Panel" -ForegroundColor Cyan
Write-Host "   2. Verifique se o deploy está em andamento" -ForegroundColor Cyan
Write-Host "   3. Configure as variáveis de ambiente" -ForegroundColor Cyan
Write-Host "   4. Configure os domínios" -ForegroundColor Cyan
Write-Host "   5. Teste a aplicação" -ForegroundColor Cyan

Write-Log "🔗 URLs esperadas:"
Write-Host "   - Frontend: https://app.seudominio.com" -ForegroundColor Cyan
Write-Host "   - API: https://api.seudominio.com" -ForegroundColor Cyan
Write-Host "   - Health Check: https://api.seudominio.com/health" -ForegroundColor Cyan

Write-Log "📚 Documentação:"
Write-Host "   - Deploy: DEPLOY_EASYPANEL.md" -ForegroundColor Cyan
Write-Host "   - Google OAuth: GOOGLE_OAUTH_SETUP.md" -ForegroundColor Cyan
Write-Host "   - Testes: TESTE_GOOGLE_LOGIN.md" -ForegroundColor Cyan 