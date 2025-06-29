# Script para testar o build do Docker (PowerShell)
Write-Host "🐳 Iniciando build do Docker..." -ForegroundColor Green

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

# Verificar se o Docker está instalado
try {
    docker --version | Out-Null
} catch {
    Write-Error "Docker não está instalado"
    exit 1
}

# Verificar se estamos no diretório correto
if (-not (Test-Path "package.json")) {
    Write-Error "Execute este script na raiz do projeto"
    exit 1
}

# Verificar se o Dockerfile existe
if (-not (Test-Path "Dockerfile")) {
    Write-Error "Dockerfile não encontrado"
    exit 1
}

# Nome da imagem
$IMAGE_NAME = "site-fotos"
$TAG = "latest"

Write-Log "Construindo imagem Docker..."
try {
    docker build -t "$IMAGE_NAME`:$TAG" .
    if ($LASTEXITCODE -eq 0) {
        Write-Log "✅ Build do Docker concluído com sucesso!"
        
        Write-Log "📋 Informações da imagem:"
        docker images "$IMAGE_NAME`:$TAG"
        
        Write-Log "🚀 Para executar localmente:"
        Write-Host "   docker run -p 3001:3001 --env-file .env $IMAGE_NAME`:$TAG" -ForegroundColor Cyan
        
        Write-Log "📦 Para fazer push para o registry:"
        Write-Host "   docker tag $IMAGE_NAME`:$TAG seu-registry/$IMAGE_NAME`:$TAG" -ForegroundColor Cyan
        Write-Host "   docker push seu-registry/$IMAGE_NAME`:$TAG" -ForegroundColor Cyan
        
        Write-Log "🧪 Para testar a aplicação:"
        Write-Host "   docker run -p 3001:3001 --env-file .env $IMAGE_NAME`:$TAG" -ForegroundColor Cyan
        
    } else {
        Write-Error "❌ Build do Docker falhou"
        exit 1
    }
} catch {
    Write-Error "❌ Erro durante o build do Docker: $($_.Exception.Message)"
    exit 1
} 