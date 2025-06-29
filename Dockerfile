FROM node:18-alpine

# Instalar dependências do sistema
RUN apk add --no-cache git

# Criar diretório da aplicação
WORKDIR /app

# Copiar package.json e package-lock.json do backend
COPY package*.json ./

# Instalar dependências do backend
RUN npm ci --only=production

# Copiar código fonte do backend
COPY . .

# Instalar dependências do frontend e fazer build
WORKDIR /app/frontend-fotos
RUN npm install
RUN npx react-scripts build

# Voltar para o diretório raiz
WORKDIR /app

# Criar diretório para uploads
RUN mkdir -p uploads

# Expor porta
EXPOSE 3001

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3001/health', (res) => { process.exit(res.statusCode === 200 ? 0 : 1) })"

# Comando para iniciar a aplicação
CMD ["npm", "start"] 