# api_delphi
API escrita em Delphi + Horse
Sistema em Delphi, para gerenciar informações sobre tarefas.
Sendo dividida em 2 aplicações:

	# A api uma aplicação console que utiliza o framework Horse, oferecendo as seguintes funcionalidades:
	- Consultar e retornar a lista de todas as tarefas.
	- Adicionar uma nova tarefa.
	- Atualizar o status de uma tarefa.
	- Remover uma tarefa pelo seu ID.
	- O número total de tarefas.
	- A média de prioridade das tarefas pendentes.
	- A quantidade de tarefas concluídas nos últimos 7 dias.
	
	# Aplicação cliente para consumir a api.
	- Foi utilizado a biblioteca REST para realizar as chamadas a api.
	
	# Abaixo a estrutura de dados utilizada para armazenar as informações das tarefas, criada especificamente para SQL Server.
	
	CREATE TABLE TAREFA (
		ID INT IDENTITY(1,1) PRIMARY KEY,
		TITULO NVARCHAR(32) NOT NULL,
		DESCRICAO NVARCHAR(MAX),
		PRIORIDADE INT NOT NULL CHECK (PRIORIDADE IN (1,2,3,4,5)),
		STATUS CHAR(1) NOT NULL CHECK (STATUS IN ('A', 'C', 'E', 'P','X')),
		DATA_INSERT DATETIME NOT NULL,
		DATA_CONCLUSAO DATETIME
	);
