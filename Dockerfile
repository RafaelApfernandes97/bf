# Multi-stage build para otimizar o tamanho da imagem
FROM node:18-alpine AS builder

# Instalar dependências do sistema
RUN apk add --no-cache git

# Stage 1: Build do frontend
FROM builder AS frontend-builder
WORKDIR /app/frontend
COPY frontend-fotos/package.json ./
COPY frontend-fotos/package-lock.json* ./
RUN npm install
COPY frontend-fotos/ .
RUN npm run build

# Stage 2: Build final
FROM node:18-alpine AS production

# Criar usuário não-root para segurança
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nodejs -u 1001

# Criar diretório da aplicação
WORKDIR /app

# Copiar package.json e package-lock.json do backend
COPY package*.json ./

# Instalar dependências do backend (incluindo axios)
RUN npm ci --only=production

# Copiar código fonte do backend
COPY . .

# Copiar build do frontend
COPY --from=frontend-builder /app/frontend/build ./frontend-fotos/build

# Criar diretório para uploads
RUN mkdir -p uploads

# Mudar propriedade dos arquivos para o usuário nodejs
RUN chown -R nodejs:nodejs /app

# Mudar para usuário não-root
USER nodejs

# Expor porta
EXPOSE 3001

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3001/health', (res) => { process.exit(res.statusCode === 200 ? 0 : 1) })"

# Comando para iniciar a aplicação
CMD ["npm", "start"] 