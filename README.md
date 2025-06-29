# Marketplace de Fotos - Backend Otimizado

Backend otimizado para marketplace de fotos com cache Redis e MinIO para armazenamento.

## 🚀 Funcionalidades

- **Cache Inteligente**: Redis + cache em memória para máxima performance
- **Pré-carregamento**: Dados populares carregados automaticamente
- **URLs Assinadas**: URLs temporárias para acesso seguro às imagens
- **Monitoramento**: Logs de performance em tempo real
- **Fallback**: Funciona mesmo sem Redis (usa cache em memória)

## 📦 Instalação

### 1. Instalar dependências
```bash
npm install
```

### 2. Configurar variáveis de ambiente
Copie o arquivo `config.env.example` para `.env` e configure:

```bash
cp config.env.example .env
```

Edite o arquivo `.env` com suas configurações:
```env
# MinIO
MINIO_ENDPOINT=http://localhost:9000
MINIO_ACCESS_KEY=sua_access_key
MINIO_SECRET_KEY=sua_secret_key
MINIO_BUCKET=fotos

# Redis (opcional)
REDIS_URL=redis://localhost:6379

# Servidor
PORT=3001
NODE_ENV=development
```

### 3. Instalar Redis (opcional)
```bash
# Ubuntu/Debian
sudo apt-get install redis-server

# macOS
brew install redis

# Windows
# Baixe o Redis para Windows ou use WSL
```

### 4. Executar o projeto
```bash
# Desenvolvimento
npm run dev

# Produção
npm start
```

## 🔧 Estrutura do Projeto

```
backend-fotos/
├── src/
│   ├── app.js              # Configuração principal
│   ├── routes/
│   │   └── photos.js       # Rotas da API
│   └── services/
│       ├── cache.js        # Serviço de cache (Redis + memória)
│       └── minio.js        # Serviço MinIO otimizado
├── server.js               # Servidor principal
└── package.json
```

## 📡 Endpoints da API

### Eventos
- `GET /api/eventos` - Lista todos os eventos

### Coreografias
- `GET /api/eventos/:evento/coreografias` - Lista coreografias de um evento

### Fotos
- `GET /api/eventos/:evento/:coreografia/fotos` - Lista fotos de uma coreografia

### Cache e Performance
- `POST /api/pre-carregar` - Pré-carrega dados populares
- `DELETE /api/cache?pattern=*` - Invalida cache
- `GET /api/cache/stats` - Estatísticas do cache
- `GET /health` - Health check da aplicação

## ⚡ Otimizações Implementadas

### 1. Cache em Camadas
- **Redis**: Cache persistente para dados estáticos
- **Memória**: Cache rápido para dados muito acessados
- **Fallback**: Funciona sem Redis usando apenas memória

### 2. TTLs Inteligentes
- **Eventos**: 1 hora (dados raramente mudam)
- **Coreografias**: 30 minutos (mudanças ocasionais)
- **Fotos**: 15 minutos (URLs assinadas expiram em 1h)

### 3. Pré-carregamento
- Carrega automaticamente dados populares
- Executa em background sem bloquear o servidor
- Melhora experiência do primeiro usuário

### 4. URLs Assinadas Otimizadas
- URLs com expiração configurável
- Reduz carga no MinIO
- Mantém segurança

### 5. Monitoramento
- Logs de performance em tempo real
- Estatísticas de cache
- Health check endpoint

## 🔄 Fluxo de Dados

1. **Primeira requisição**: Busca no MinIO → Salva no cache → Retorna dados
2. **Requisições subsequentes**: Busca no cache → Retorna dados (muito mais rápido)
3. **Cache expira**: Busca novamente no MinIO → Atualiza cache

## 📊 Performance

### Antes da otimização:
- Cada requisição: 500ms - 2s (dependendo do MinIO)
- Sem cache: reprocessamento a cada requisição

### Após otimização:
- **Primeira requisição**: 500ms - 2s
- **Requisições em cache**: 5ms - 50ms (10x - 100x mais rápido)
- **Pré-carregamento**: Dados já disponíveis na inicialização

## 🛠️ Comandos Úteis

```bash
# Instalar dependências
npm install

# Executar em desenvolvimento
npm run dev

# Executar em produção
npm start

# Pré-carregar dados manualmente
curl -X POST http://localhost:3001/api/pre-carregar

# Ver estatísticas do cache
curl http://localhost:3001/api/cache/stats

# Invalidar cache
curl -X DELETE http://localhost:3001/api/cache
```

## 🔧 Configuração do MinIO

Certifique-se de que seu MinIO está configurado com a estrutura:
```
bucket: fotos/
├── evento1/
│   ├── coreografia1/
│   │   ├── foto1.jpg
│   │   └── foto2.jpg
│   └── coreografia2/
└── evento2/
```

## 🚨 Troubleshooting

### Redis não conecta
- O sistema funciona com cache em memória
- Verifique se o Redis está rodando: `redis-cli ping`
- Verifique a URL do Redis no `.env`

### MinIO não conecta
- Verifique as credenciais no `.env`
- Teste a conexão: `aws s3 ls --endpoint-url http://localhost:9000`

### Performance lenta
- Execute o pré-carregamento: `POST /api/pre-carregar`
- Verifique os logs de performance
- Monitore as estatísticas do cache

## 📈 Próximos Passos

1. **Frontend**: Implementar interface de usuário
2. **Autenticação**: Sistema de login/registro
3. **Pagamentos**: Integração com gateway de pagamento
4. **CDN**: Distribuição de conteúdo global
5. **Métricas**: Dashboard de analytics

---

Desenvolvido com ❤️ para otimizar a experiência do marketplace de fotos! 