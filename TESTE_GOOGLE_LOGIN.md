# Teste do Login com Google

## Pré-requisitos

1. ✅ Google Cloud Console configurado
2. ✅ Client ID configurado no frontend
3. ✅ Variáveis de ambiente configuradas no backend
4. ✅ Dependências instaladas

## Passos para Testar

### 1. Iniciar o Backend
```bash
cd backend-fotos
npm start
```

### 2. Iniciar o Frontend
```bash
cd frontend-fotos
npm start
```

### 3. Testar o Login

1. Acesse `http://localhost:3000`
2. Clique no botão de login no header
3. Você verá o botão "Continuar com Google" no topo do modal
4. Clique no botão do Google
5. Selecione sua conta Google
6. Autorize o acesso
7. Você deve ser logado automaticamente

## Verificações

### Frontend
- ✅ Botão do Google aparece no modal de login
- ✅ Botão tem o estilo correto
- ✅ Separador "ou" aparece entre os métodos de login
- ✅ Login tradicional ainda funciona

### Backend
- ✅ Rota `/api/usuarios/google-login` responde
- ✅ Token do Google é verificado
- ✅ Usuário é criado/atualizado no banco
- ✅ JWT token é retornado

### Banco de Dados
- ✅ Usuário Google é criado com campos corretos
- ✅ `googleId` é salvo
- ✅ `isGoogleUser` é marcado como `true`
- ✅ Campos obrigatórios vazios são aceitos

## Logs para Verificar

### Backend
```
POST /api/usuarios/google-login - 200 - XXXms
```

### Console do Navegador
- Verificar se não há erros de CORS
- Verificar se o token JWT é salvo no localStorage

## Problemas Comuns

### "Invalid Client ID"
- Verifique se o Client ID está correto no `App.js`
- Confirme se as URLs autorizadas incluem `http://localhost:3000`

### "Token verification failed"
- Verifique se `GOOGLE_CLIENT_ID` está no arquivo `.env`
- Confirme se a API do Google+ está habilitada

### "CORS error"
- Verifique se o backend está rodando na porta 3001
- Confirme se as origens JavaScript estão configuradas

### "User not found"
- Verifique se o MongoDB está conectado
- Confirme se o modelo de usuário foi atualizado

## Próximos Passos

Após o teste bem-sucedido:

1. **Completar Perfil**: Usuários Google podem completar CPF e telefone
2. **Testar Pedidos**: Verificar se usuários Google podem fazer pedidos
3. **Produção**: Configurar URLs de produção no Google Cloud Console 