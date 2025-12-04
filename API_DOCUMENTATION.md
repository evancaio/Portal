# 📚 Documentação da API - Portal de Clientes

## 🎯 Visão Geral

API REST para sincronização de clientes capturados no Telegram via Latenode.

**URL Base:** `http://127.0.0.1:8001` (desenvolvimento) ou seu domínio em produção

---

## 📝 Endpoints

### 1. Criar/Atualizar Cliente (Sync)

**Descrição:** Cria um novo cliente ou atualiza se já existir (baseado no telefone)

**Método:** `POST`

**URL:** `/api/customers/sync`

**Headers:**
```
Content-Type: application/json
```

**Body (JSON):**
```json
{
  "name": "João Silva",
  "phone": "5511987654321",
  "email": "joao@example.com",
  "plan_name": "Premium",
  "status": "active",
  "started_at": "2025-12-04T10:30:00Z"
}
```

**Campos Obrigatórios:**
- `name` (string, máx 255 caracteres) - Nome completo do cliente
- `phone` (string) - Telefone único do cliente (identificador)

**Campos Opcionais:**
- `email` (string, formato de email) - Email do cliente
- `plan_name` (string, máx 255 caracteres) - Nome do plano (ex: "Básico", "Premium", "Enterprise")
- `status` (string) - Status do cliente. Valores válidos:
  - `active` (padrão) - Cliente ativo
  - `trial` - Cliente em período de teste
  - `cancelled` - Cliente cancelado
  - `pending` - Cliente aguardando ativação
- `started_at` (ISO 8601) - Data e hora de início (formato: `YYYY-MM-DDTHH:mm:ssZ`)

**Resposta (Sucesso - 200):**
```json
{
  "success": true,
  "message": "Cliente sincronizado com sucesso.",
  "customer": {
    "id": 1,
    "name": "João Silva",
    "phone": "5511987654321",
    "email": "joao@example.com",
    "plan_name": "Premium",
    "status": "active",
    "started_at": "2025-12-04T10:30:00.000000Z",
    "created_at": "2025-12-04T15:20:10.000000Z",
    "updated_at": "2025-12-04T15:20:10.000000Z"
  }
}
```

**Resposta (Erro - 400):**
```json
{
  "success": false,
  "message": "Erro ao sincronizar cliente: [descrição do erro]"
}
```

---

### 2. Deletar Cliente

**Descrição:** Remove um cliente da base de dados

**Método:** `DELETE`

**URL:** `/api/customers/{phone}`

**Exemplo:**
```
DELETE /api/customers/5511987654321
```

**Resposta (Sucesso - 200):**
```json
{
  "success": true,
  "message": "Cliente deletado com sucesso."
}
```

**Resposta (Erro - 404):**
```json
{
  "success": false,
  "message": "Cliente não encontrado."
}
```

---

### 3. Listar Todos os Clientes

**Descrição:** Retorna lista de todos os clientes (para visualização no dashboard)

**Método:** `GET`

**URL:** `/customers`

**Resposta (200):**
```json
[
  {
    "id": 1,
    "name": "João Silva",
    "phone": "5511987654321",
    "email": "joao@example.com",
    "plan_name": "Premium",
    "status": "active",
    "started_at": "2025-12-04T10:30:00.000000Z",
    "created_at": "2025-12-04T15:20:10.000000Z",
    "updated_at": "2025-12-04T15:20:10.000000Z"
  },
  {
    "id": 2,
    "name": "Maria Santos",
    "phone": "5521999887766",
    "email": "maria@example.com",
    "plan_name": "Básico",
    "status": "trial",
    "started_at": "2025-12-03T14:15:00.000000Z",
    "created_at": "2025-12-03T14:15:00.000000Z",
    "updated_at": "2025-12-03T14:15:00.000000Z"
  }
]
```

---

## 🔌 Integração Latenode - Passo a Passo

### Configuração no Latenode

#### **Passo 1: Adicionar Nó HTTP Request**

1. No seu fluxo do Latenode, após o bot coletar os dados do cliente
2. Clique em **"+"** para adicionar um novo nó
3. Procure por **"HTTP Request"** ou **"Webhook"** e selecione
4. Configure como segue:

#### **Passo 2: Configurar Requisição HTTP**

**Método:** `POST`

**URL:**
```
http://127.0.0.1:8001/api/customers/sync
```

*Em produção, substitua `http://127.0.0.1:8001` pelo seu domínio, ex: `https://seudominio.com`*

**Headers:**
```
Content-Type: application/json
```

#### **Passo 3: Mapear Dados do Telegram para o Portal**

No campo **Body** (ou **Payload**), use o seguinte JSON e mapeie as variáveis capturadas:

```json
{
  "name": "{{ telegram_message_user_name }}",
  "phone": "{{ telegram_message_user_phone }}",
  "email": "{{ telegram_message_user_email }}",
  "plan_name": "{{ calculated_plan }}",
  "status": "active",
  "started_at": "{{ current_timestamp_iso }}"
}
```

**Mapeamento de Variáveis:**

| Campo do Portal | Variável Latenode | Descrição |
|---|---|---|
| `name` | Nome capturado no Telegram | Nome completo do usuário |
| `phone` | Telefone capturado no Telegram | Número do telefone (com DDD) |
| `email` | Email capturado no Telegram | Email fornecido pelo usuário |
| `plan_name` | Resultado do cálculo | O plano que foi calculado (ex: "Premium", "Básico") |
| `status` | `"active"` (fixo) | Pode ser alterado se necessário |
| `started_at` | Data/hora atual | Momento da inscrição |

**Exemplo Concreto (substituindo variáveis reais):**
```json
{
  "name": "João Silva",
  "phone": "5511987654321",
  "email": "joao@example.com",
  "plan_name": "Premium",
  "status": "active",
  "started_at": "2025-12-04T15:30:00Z"
}
```

#### **Passo 4: Testar a Integração**

1. No Latenode, clique em **"Test"** para testar o nó
2. Verifique se recebe resposta **200** com `"success": true`
3. Vá para o dashboard em `http://127.0.0.1:8001` e confirme se o cliente apareceu

#### **Passo 5: Ativar o Fluxo**

1. Após confirmação, ative o fluxo
2. Teste com um usuário real no Telegram
3. Verifique no portal se o cliente foi armazenado

---

## 🧪 Exemplos de Payload

### Exemplo 1: Cliente Premium
```json
{
  "name": "Ana Costa",
  "phone": "5585988776655",
  "email": "ana.costa@email.com",
  "plan_name": "Premium",
  "status": "active",
  "started_at": "2025-12-04T09:00:00Z"
}
```

### Exemplo 2: Cliente em Trial
```json
{
  "name": "Carlos Mendes",
  "phone": "5531987654321",
  "email": "carlos@email.com",
  "plan_name": "Básico",
  "status": "trial",
  "started_at": "2025-12-04T14:30:00Z"
}
```

### Exemplo 3: Apenas Nome e Telefone (Mínimo)
```json
{
  "name": "Pedro Silva",
  "phone": "5521996633440"
}
```

---

## 🛠️ Troubleshooting

### Erro: "Unexpected token '<', "<!DOCTYPE "... is not valid JSON"

**Causa:** Servidor retornando HTML (erro 500)

**Solução:**
1. Verifique se a URL está correta
2. Verifique se o servidor Laravel está rodando
3. Verifique se os dados enviados têm formato JSON válido

### Erro: "Cliente não encontrado" ao tentar deletar

**Causa:** O telefone não existe na base de dados

**Solução:**
1. Verifique o número do telefone
2. Garanta que o cliente foi criado antes

### Cliente não aparece no dashboard

**Causa:** Possível erro de sincronização

**Solução:**
1. Verifique a resposta do endpoint (status 200)
2. Atualize o dashboard (F5)
3. Verifique se a data/hora do servidor está correta

---

## 📊 Campos do Cliente

| Campo | Tipo | Descrição |
|---|---|---|
| `id` | Integer | ID único (gerado automaticamente) |
| `name` | String | Nome do cliente |
| `phone` | String | Telefone (identificador único) |
| `email` | String | Email do cliente |
| `plan_name` | String | Nome do plano contratado |
| `status` | String | Status (active, trial, cancelled, pending) |
| `started_at` | DateTime | Data de início |
| `created_at` | DateTime | Data de criação (auto) |
| `updated_at` | DateTime | Data da última atualização (auto) |

---

## 🔐 Segurança em Produção

Antes de colocar em produção:

1. **SSL/HTTPS** - Use certificado SSL
2. **IP Whitelist** - Restrinja a origem das requisições (IPs do Latenode)
3. **Rate Limiting** - Implemente limite de requisições
4. **Autenticação** - Considere adicionar token de API
5. **Validação** - Sempre valide dados no servidor

---

## 📞 Suporte

Para dúvidas ou problemas, verifique:
1. Logs do Laravel: `storage/logs/`
2. Logs do Latenode: Dashboard de logs do workflow
3. Console do navegador: F12 > Console

