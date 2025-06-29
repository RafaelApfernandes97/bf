# Configuração do Login com Google

Este documento explica como configurar o login com Google no sistema.

## 1. Configurar o Projeto no Google Cloud Console

### Passo 1: Acessar o Google Cloud Console
1. Vá para [Google Cloud Console](https://console.cloud.google.com/)
2. Faça login com sua conta Google
3. Crie um novo projeto ou selecione um existente

### Passo 2: Habilitar a API do Google+ 
1. No menu lateral, vá para "APIs e Serviços" > "Biblioteca"
2. Procure por "Google+ API" ou "Google Identity"
3. Clique em "Habilitar"

### Passo 3: Configurar as Credenciais OAuth
1. Vá para "APIs e Serviços" > "Credenciais"
2. Clique em "Criar Credenciais" > "ID do Cliente OAuth 2.0"
3. Selecione "Aplicativo da Web"
4. Configure as URLs autorizadas:
   - **Origens JavaScript autorizadas**: `http://localhost:3000`
   - **URIs de redirecionamento autorizados**: `http://localhost:3000`

### Passo 4: Obter o Client ID
1. Após criar as credenciais, você receberá um Client ID
2. Copie este ID para usar na configuração

## 2. Configurar as Variáveis de Ambiente

### Frontend
No arquivo `frontend-fotos/src/App.js`, substitua `YOUR_GOOGLE_CLIENT_ID` pelo seu Client ID real:

```javascript
<GoogleOAuthProvider clientId="SEU_CLIENT_ID_AQUI">
```

### Backend
Crie um arquivo `.env` na raiz do projeto com as seguintes variáveis:

```env
GOOGLE_CLIENT_ID=seu_client_id_aqui
JWT_SECRET=sua_chave_secreta_jwt_aqui
```

## 3. Funcionalidades Implementadas

### Frontend
- ✅ Botão de login com Google no modal de login
- ✅ Integração com @react-oauth/google
- ✅ Tratamento de erros
- ✅ Interface responsiva

### Backend
- ✅ Rota `/api/usuarios/google-login`
- ✅ Verificação de tokens do Google
- ✅ Criação automática de usuários
- ✅ Geração de JWT tokens
- ✅ Modelo de usuário atualizado

## 4. Como Funciona

1. **Login Inicial**: O usuário clica no botão "Continuar com Google"
2. **Autenticação Google**: O Google autentica o usuário e retorna um token
3. **Verificação Backend**: O backend verifica o token com o Google
4. **Criação/Atualização**: Se o usuário não existir, é criado automaticamente
5. **Token JWT**: O backend gera um token JWT para sessão
6. **Login Completo**: O usuário é logado no sistema

## 5. Campos do Usuário Google

Usuários que fazem login com Google terão:
- `email`: Email do Google
- `nome`: Nome do Google
- `googleId`: ID único do Google
- `isGoogleUser`: Flag indicando que é usuário Google
- `cpfCnpj`: Vazio (pode ser preenchido depois)
- `telefone`: Vazio (pode ser preenchido depois)

## 6. Segurança

- Tokens do Google são verificados no backend
- JWT tokens têm expiração de 7 dias
- Usuários Google podem atualizar dados pessoais posteriormente
- Sistema mantém compatibilidade com login tradicional

## 7. Troubleshooting

### Erro: "Invalid Client ID"
- Verifique se o Client ID está correto no frontend
- Confirme se as URLs autorizadas estão configuradas corretamente

### Erro: "Token verification failed"
- Verifique se o GOOGLE_CLIENT_ID está configurado no backend
- Confirme se a API do Google+ está habilitada

### Erro: "CORS"
- Verifique se as origens JavaScript estão configuradas corretamente
- Confirme se o backend está rodando na porta correta

## 8. Produção

Para produção, lembre-se de:
1. Configurar URLs de produção no Google Cloud Console
2. Usar variáveis de ambiente seguras
3. Configurar HTTPS
4. Atualizar as origens JavaScript autorizadas 