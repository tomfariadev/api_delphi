# API Delphi

API escrita em Delphi utilizando o framework **Horse** para gerenciar informações sobre tarefas. O sistema é composto por duas aplicações:

---

## 🖥️ API (Aplicação Console)

Aplicação console que utiliza o framework **Horse**, oferecendo as seguintes funcionalidades:

- 🔍 Consultar e retornar a lista de todas as tarefas.
- ➕ Adicionar uma nova tarefa.
- 🔄 Atualizar o status de uma tarefa.
- ❌ Remover uma tarefa pelo seu ID.
- 📊 Obter o número total de tarefas.
- 📈 Calcular a média de prioridade das tarefas pendentes.
- ✅ Obter a quantidade de tarefas concluídas nos últimos **7 dias**.

---

## 📱 Aplicação Cliente

Aplicação desenvolvida em Delphi, que consome a API utilizando a biblioteca **REST Client** para realizar as chamadas HTTP.

---

## 🗄️ Estrutura da Base de Dados (SQL Server)

Tabela utilizada para armazenar as informações das tarefas:

```sql
CREATE TABLE TAREFA (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    TITULO NVARCHAR(32) NOT NULL,
    DESCRICAO NVARCHAR(MAX),
    PRIORIDADE INT NOT NULL CHECK (PRIORIDADE IN (1,2,3,4,5)),
    STATUS CHAR(1) NOT NULL CHECK (STATUS IN ('A', 'C', 'E', 'P', 'X')),
    DATA_INSERT DATETIME NOT NULL,
    DATA_CONCLUSAO DATETIME
);
