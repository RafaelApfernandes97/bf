# Deploy no Easy Panel

Este guia explica como fazer o deploy do projeto no Easy Panel.

## 📋 Pré-requisitos

1. ✅ Conta no Easy Panel
2. ✅ Domínio configurado (opcional)
3. ✅ Variáveis de ambiente preparadas
4. ✅ Google Cloud Console configurado

## 🚀 Passos para Deploy

### 1. Preparar o Repositório

Certifique-se de que todos os arquivos estão commitados:

```bash
git add .
git commit -m "Preparando para deploy no Easy Panel"
git push origin main
```

### 2. Configurar Variáveis de Ambiente

Crie um arquivo `.env` na raiz do projeto com as seguintes variáveis:

```env
# Configurações do MinIO
MINIO_ENDPOINT=https://seu-minio-endpoint.com
MINIO_ACCESS_KEY=sua_access_key
MINIO_SECRET_KEY=sua_secret_key
MINIO_BUCKET=fotos

# Configurações do Redis
REDIS_URL=redis://default:sua_senha@seu_redis_host:porta

# Configurações do Servidor
PORT=3001
NODE_ENV=production

# Configurações do Google OAuth
GOOGLE_CLIENT_ID=seu_google_client_id
JWT_SECRET=sua_chave_secreta_jwt

# Configurações do MongoDB
MONGODB_URI=mongodb://usuario:senha@host:porta/database
```

### 3. Configurar Easy Panel

#### 3.1 Criar Novo Projeto

1. Acesse o Easy Panel
2. Clique em "Novo Projeto"
3. Selecione "Git Repository"
4. Conecte seu repositório GitHub/GitLab

#### 3.2 Configurar Serviços

**Backend Service:**
- **Nome**: `backend`
- **Tipo**: Node.js
- **Porta**: `3001`
- **Build Command**: `npm install`
- **Start Command**: `npm start`
- **Environment Variables**: Adicione todas as variáveis do `.env`

**Frontend Service:**
- **Nome**: `frontend`
- **Tipo**: Static Site
- **Build Command**: `cd frontend-fotos && npm install && npm run build`
- **Output Directory**: `frontend-fotos/build`
- **Environment Variables**:
  - `REACT_APP_API_URL`: `https://api.seudominio.com`

#### 3.3 Configurar Domínios

**API Domain:**
- **Nome**: `api.seudominio.com`
- **Service**: `backend`
- **Path**: `/api`

**App Domain:**
- **Nome**: `app.seudominio.com` ou `seudominio.com`
- **Service**: `frontend`

### 4. Configurar Google OAuth para Produção

#### 4.1 Atualizar Google Cloud Console

1. Acesse [Google Cloud Console](https://console.cloud.google.com/)
2. Vá para "APIs e Serviços" > "Credenciais"
3. Edite suas credenciais OAuth 2.0
4. Adicione as URLs de produção:
   - **Origens JavaScript autorizadas**:
     - `https://app.seudominio.com`
     - `https://seudominio.com`
   - **URIs de redirecionamento autorizados**:
     - `https://app.seudominio.com`
     - `https://seudominio.com`

#### 4.2 Atualizar Frontend

No arquivo `frontend-fotos/src/App.js`, substitua:

```javascript
<GoogleOAuthProvider clientId="SEU_GOOGLE_CLIENT_ID_PRODUCAO">
```

### 5. Configurar SSL/HTTPS

O Easy Panel geralmente configura SSL automaticamente, mas verifique:

1. **Certificados SSL**: Devem ser configurados automaticamente
2. **Redirecionamento HTTPS**: Configure redirecionamento automático
3. **Headers de Segurança**: Adicione headers de segurança

### 6. Configurar Banco de Dados

#### 6.1 MongoDB

Se estiver usando MongoDB Atlas ou outro serviço:

1. Configure a string de conexão no `.env`
2. Certifique-se de que o IP do Easy Panel está liberado
3. Teste a conexão

#### 6.2 Redis

Se estiver usando Redis Cloud ou outro serviço:

1. Configure a URL do Redis no `.env`
2. Teste a conexão

### 7. Configurar MinIO/S3

Para armazenamento de imagens:

1. Configure o endpoint do MinIO/S3
2. Configure as credenciais de acesso
3. Teste o upload de imagens

## 🔧 Configurações Específicas do Easy Panel

### Dockerfile (Opcional)

Se precisar de configurações específicas, use o `Dockerfile` incluído:

```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
RUN mkdir -p uploads
EXPOSE 3001
CMD ["npm", "start"]
```

### Health Check

Adicione um endpoint de health check no backend:

```javascript
app.get('/health', (req, res) => {
  res.json({ 
    status: 'OK', 
    timestamp: new Date().toISOString(),
    uptime: process.uptime()
  });
});
```

## 🧪 Testando o Deploy

### 1. Verificar Backend

```bash
curl https://api.seudominio.com/health
```

### 2. Verificar Frontend

Acesse `https://app.seudominio.com` e verifique:

- ✅ Página carrega corretamente
- ✅ Login com Google funciona
- ✅ API está respondendo
- ✅ Imagens carregam

### 3. Verificar Logs

No Easy Panel, verifique os logs de ambos os serviços:

- **Backend**: Logs de inicialização e erros
- **Frontend**: Logs de build e deploy

## 🚨 Troubleshooting

### Erro: "Build Failed"

1. Verifique se todas as dependências estão no `package.json`
2. Confirme se os scripts estão corretos
3. Verifique os logs de build

### Erro: "Connection Refused"

1. Verifique se a porta está correta (3001)
2. Confirme se o serviço está rodando
3. Verifique as variáveis de ambiente

### Erro: "CORS"

1. Configure o CORS no backend para os domínios de produção
2. Verifique se as URLs da API estão corretas

### Erro: "Google OAuth"

1. Verifique se o Client ID está correto
2. Confirme se as URLs autorizadas incluem o domínio de produção
3. Teste o login em modo incógnito

## 📊 Monitoramento

### Logs

Configure monitoramento de logs:

1. **Backend Logs**: Erros, requisições, performance
2. **Frontend Logs**: Erros de JavaScript, performance
3. **Database Logs**: Conexões, queries lentas

### Métricas

Monitore:

- **Uptime**: Disponibilidade do serviço
- **Response Time**: Tempo de resposta da API
- **Error Rate**: Taxa de erros
- **Memory Usage**: Uso de memória

## 🔄 Atualizações

Para atualizar o deploy:

1. Faça as alterações no código
2. Commit e push para o repositório
3. O Easy Panel fará deploy automático
4. Verifique se tudo está funcionando

## 📞 Suporte

Se encontrar problemas:

1. Verifique os logs no Easy Panel
2. Teste localmente primeiro
3. Consulte a documentação do Easy Panel
4. Entre em contato com o suporte se necessário 