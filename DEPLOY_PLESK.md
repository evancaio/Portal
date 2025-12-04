# Deploy no Plesk (Windows) — Portal Laravel

Este guia assume que você tem acesso ao painel Plesk para o domínio `PortalBemEnergia.easywebhost.app`.
Seguem passos detalhados para implantar o projeto Laravel usando SQLite.

## Pré-requisitos
- Acesso ao Plesk (painel) com usuário que possa gerenciar o domínio
- PHP 8.2+ disponível no Plesk
- Extensão `pdo_sqlite` / `sqlite3` habilitada no PHP

---

## 1) Fazer upload do projeto
Opções:
- Via Git (recomendado): configurar Git no Plesk e deploy automático para `httpdocs`
- Via File Manager do Plesk: enviar ZIP e descompactar em `httpdocs`

Dica: mantenha a estrutura do Laravel como está. O importante é apontar o Document Root para a pasta `public`.

---

## 2) Configurar Document Root
1. Acesse **Websites & Domains → Hosting Settings** para `PortalBemEnergia.easywebhost.app`.
2. Em **Document root** (ou `Site root`), configure para `httpdocs\public` (ou o caminho equivalente) — assim o `index.php` do Laravel será servido corretamente.
3. Salve as configurações.

---

## 3) PHP e extensões
1. Em **PHP Settings** do domínio, selecione **PHP 8.2** (ou 8.1+ mínimo, mas preferível 8.2).
2. Verifique se a extensão `pdo_sqlite` e/ou `sqlite3` está habilitada. Se não estiver, habilite-a.
3. Configure `display_errors = Off` para produção.

---

## 4) Criar arquivo SQLite
1. No Plesk **File Manager**, navegue até a raiz do projeto (pasta que contém `artisan`).
2. Dentro da pasta `database`, crie um arquivo vazio chamado `database.sqlite`.
   - Em Plesk: botão **+ New** → **Create File** → nomeie `database.sqlite`.

---

## 5) Configurar `.env`
No root do projeto, faça uma cópia de `.env.example` para `.env` (ou crie `.env`) com as seguintes chaves mínimas:

```
APP_ENV=production
APP_DEBUG=false
APP_URL=https://PortalBemEnergia.easywebhost.app

DB_CONNECTION=sqlite
DB_DATABASE=database/database.sqlite

# MAIL settings (opcional)
# ...
```

- No Windows com Plesk, o caminho relativo `database/database.sqlite` costuma funcionar.
- Se preferir, use o caminho absoluto: `DB_DATABASE=C:\path\to\httpdocs\yourproject\database\database.sqlite` (verificar caminho via File Manager).

---

## 6) Permissões
1. Ainda no **File Manager**, ajuste permissões para que o processo PHP consiga escrever em:
   - `storage/` (toda a pasta)
   - `bootstrap/cache`
2. Em Plesk, ajuste permissões do usuário do site (normalmente `IIS_IUSRS`/`IUSR` ou o usuário do pool do app) para ter permissão de escrita.

---

## 7) Rodar migrations / criar tabela
Você precisa rodar `php artisan migrate` no servidor. Opções:

A) **SSH** (se ativado)
- Conecte via SSH ao servidor (usuário do Plesk se permitido) e rode:

```powershell
cd "%plesk_site_root_path%"   # exemplo: cd C:\Inetpub\vhosts\example.com\httpdocs
php artisan migrate --force
```

B) **Plesk Scheduled Task** (se sem SSH)
- Em Plesk, vá em **Scheduled Tasks** do domínio
- Adicione uma tarefa do tipo **Run a command** com:

```
php "C:\Inetpub\vhosts\yourdomain\httpdocs\artisan" migrate --force
```

- Execute a tarefa manualmente para aplicar as migrations.

C) **Rodar local e subir o arquivo SQLite**
- Como alternativa, rode migrations localmente para gerar o `database.sqlite` e faça upload do arquivo na pasta `database/` via File Manager.

---

## 8) Testar aplicação
- Acesse `https://PortalBemEnergia.easywebhost.app`
- Verifique logs em `storage/logs/laravel.log` se houver erro
- Console do navegador: F12 → Console / Network para ver respostas da API

---

## 9) (Opcional) Forçar HTTPS
- No Plesk, habilite SSL/TLS para o domínio (Let's Encrypt) e configure redirecionamento HTTP → HTTPS.

---

## 10) Segurança recomendada
- Configure regras de IP se for necessário restringir chamadas de API (por exemplo do Latenode)
- Considere adicionar um token simples (API key) no header das requisições: `X-API-KEY: <token>` e validar no `CustomerApiController`

---

## Problemas comuns
- *500 Internal Server Error*: ver `storage/logs/laravel.log` e `Event Viewer` do Windows
- *SQLite não gravando*: problema de permissões na pasta `database` ou `storage`
- *Rewrite não funcionando*: confirme que `web.config` existe em `public/` e `Document root` aponta para `public`

---

Se quiser, eu posso:
- Gerar um `web.config` (já adicionei) — pronto no projeto
- Gerar instruções para adicionar verificação simples de API key no `CustomerApiController`
- Ajudar a montar a linha de comando exata para o seu caminho no Plesk se você me informar o caminho absoluto do `httpdocs` (posso te mostrar como descobrir no File Manager)

