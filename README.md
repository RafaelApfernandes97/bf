# Sistema de Fotos de Ballet

Sistema completo para gerenciamento e visualização de fotos de eventos de ballet, com frontend React e backend Node.js.

## 🏗️ Estrutura do Projeto

```
├── backend/          # API Node.js/Express
│   ├── src/         # Código fonte
│   ├── Dockerfile   # Configuração Docker
│   └── package.json # Dependências
├── frontend/        # Interface React
│   ├── src/         # Código fonte
│   ├── Dockerfile   # Configuração Docker
│   └── package.json # Dependências
└── docker-compose.yml # Orquestração local
```

## 🚀 Funcionalidades

### Backend
- API RESTful para gerenciamento de fotos
- Autenticação com Google OAuth
- Integração com MinIO/S3 para armazenamento
- Cache com Redis
- MongoDB para dados de usuários

### Frontend
- Interface responsiva e moderna
- Visualização de fotos por evento/coreografia
- Autenticação com Google
- Carrinho de compras
- PWA (Progressive Web App)

## 🛠️ Instalação e Execução

### Opção 1: Docker Compose (Recomendado)

1. Clone o repositório
2. Configure as variáveis de ambiente:
   ```bash
   cp backend/config.env.example backend/.env
   cp frontend/env.example frontend/.env
   ```

3. Execute com Docker Compose:
   ```bash
   docker-compose up --build
   ```

4. Acesse:
   - Frontend: http://localhost:3000
   - Backend: http://localhost:3001

### Opção 2: Desenvolvimento Local

#### Backend
```bash
cd backend
npm install
npm run dev
```

#### Frontend
```bash
cd frontend
npm install
npm start
```

## 🌐 Deploy

### Easy Panel

1. **Backend**: Use o arquivo `backend/easypanel.json`
2. **Frontend**: Use o arquivo `frontend/easypanel.json`

### Docker

Cada parte pode ser deployada independentemente:

```bash
# Backend
cd backend
docker build -t backend-fotos .
docker push your-registry/backend-fotos

# Frontend
cd frontend
docker build -t frontend-fotos .
docker push your-registry/frontend-fotos
```

## 📋 Variáveis de Ambiente

### Backend
- `MINIO_ENDPOINT` - Endpoint do MinIO/S3
- `MINIO_ACCESS_KEY` - Chave de acesso
- `MINIO_SECRET_KEY` - Chave secreta
- `MINIO_BUCKET` - Nome do bucket
- `MONGODB_URI` - URI do MongoDB
- `JWT_SECRET` - Chave secreta do JWT
- `GOOGLE_CLIENT_ID` - ID do cliente Google OAuth
- `REDIS_URL` - URL do Redis

### Frontend
- `REACT_APP_API_URL` - URL da API backend
- `REACT_APP_GOOGLE_CLIENT_ID` - ID do cliente Google OAuth

## 🔧 Tecnologias

### Backend
- Node.js
- Express
- MongoDB (Mongoose)
- Redis
- AWS SDK (MinIO/S3)
- Google Auth Library
- JWT

### Frontend
- React 18
- React Router DOM
- Axios
- @react-oauth/google
- CSS3

## 📚 Documentação

- [Backend](./backend/README.md)
- [Frontend](./frontend/README.md)
- [Deploy no Easy Panel](./DEPLOY_EASYPANEL.md)
- [Configuração Google OAuth](./GOOGLE_OAUTH_SETUP.md)
