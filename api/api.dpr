program api;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Horse, Horse.Jhonson,
  System.SysUtils, System.JSON, System.Generics.Collections, ActiveX,
  uTarefa in 'uTarefa.pas',
  uTarefaDAO in 'uTarefaDAO.pas',
  uConexao in 'uConexao.pas';

begin
  // Permite que a API interprete e envie dados em formato JSON automaticamente
  THorse.Use(Jhonson);

  {Middleware para as Threads COM
   Faz a inicializa��o (CoInitialize) e finaliza��o (CoUninitialize) da COM em cada requisi��o,
   garantindo seguran�a na manipula��o de objetos que dependem de COM (especialmente com banco de dados)}
  THorse.Use(
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TNextProc)
    begin
      CoInitialize(nil);
      try
        Next();
      finally
        CoUninitialize;
      end;
    end
  );

  // Tratamento de erros global
  // Captura exce��es n�o tratadas e retorna um JSON com a mensagem de erro e status HTTP 500
  THorse.Use(
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TNextProc)
    begin
      try
        Next();
      except
        on E: Exception do
        begin
          Res.Status(500).Send(
            TJSONObject.Create
              .AddPair('erro', E.Message)
              .ToString
          );
        end;
      end;
    end
  );

  // Listar todas as tarefas
  // Retorna todas as tarefas cadastradas no banco
  THorse.Get('/tarefas',
    procedure(Req: THorseRequest; Res: THorseResponse)
    var
      DAO: TTarefaDAO;
      Tarefas: TObjectList<TTarefa>;
      Tarefa: TTarefa;
      JArray: TJSONArray;
      DataConclusao: String;
    begin
      DAO := TTarefaDAO.Create;
      Tarefas := DAO.GetTarefas;
      JArray := TJSONArray.Create;

      try
        if Tarefas.IsEmpty then
        begin
          Writeln('N�o existem tarefas cadastradas');
          Res.Status(404).Send('N�o existem tarefas cadastradas');
        end
        else
        begin
          for Tarefa in Tarefas do
          begin
            if Tarefa.DataConclusao > 0 then
              DataConclusao := DateTimeToStr(Tarefa.DataConclusao)
            else
              DataConclusao := '';

            JArray.AddElement(
              TJSONObject.Create
                .AddPair('ID', TJSONNumber.Create(Tarefa.ID))
                .AddPair('TITULO', Tarefa.Titulo)
                .AddPair('DESCRICAO', Tarefa.Descricao)
                .AddPair('PRIORIDADE', TJSONNumber.Create(Tarefa.Prioridade))
                .AddPair('STATUS', Tarefa.Status)
                .AddPair('DATA_INSERT', DateTimeToStr(Tarefa.DataInsert))
                .AddPair('DATA_CONCLUSAO', DataConclusao)
            );
          end;

          Res.ContentType('application/json; charset=utf-8')
             .Status(200)
             .Send(JArray.ToString);
        end;
      finally
        JArray.Free;
        DAO.Free;
      end;
    end);


  // Adicionar uma nova tarefa
  THorse.Post('/tarefas',
    procedure(Req: THorseRequest; Res: THorseResponse)
    var
      DAO: TTarefaDAO;
      Json: TJSONObject;
      Tarefa: TTarefa;
    begin
      DAO := TTarefaDAO.Create;

      try
        Json := Req.Body<TJSONObject>;
        Tarefa := TTarefa.Create;

        try
          Tarefa.Titulo     := Json.GetValue<string>('titulo');
          Tarefa.Descricao  := Json.GetValue<string>('descricao');
          Tarefa.Prioridade := Json.GetValue<Integer>('prioridade');
          Tarefa.Status     := 'A';

          DAO.Add(Tarefa);
          Res.Status(201).Send('Tarefa adicionada');
        finally
          Tarefa.Free;
        end;
      finally
        DAO.Free;
      end;
    end);

  // Atualizar status
  THorse.Put('/tarefas/:id/status',
    procedure(Req: THorseRequest; Res: THorseResponse)
    var
      DAO: TTarefaDAO;
      ID: Integer;
      Json: TJSONObject;
      Status: string;
    begin
      ID     := StrToInt(Req.Params.Items['id']);
      Json   := Req.Body<TJSONObject>;
      Status := Json.GetValue<string>('status');
      DAO    := TTarefaDAO.Create;

      try
        DAO.UpdateStatus(ID, Status);
        Res.Send('Status atualizado');
      finally
        DAO.Free;
      end;
    end);

  // DELETE tarefa
  // Exclui uma tarefa do banco pelo ID
  THorse.Delete('/tarefas/:id',
    procedure(Req: THorseRequest; Res: THorseResponse)
    var
      DAO: TTarefaDAO;
      ID: Integer;
    begin
      ID  := StrToInt(Req.Params.Items['id']);
      DAO := TTarefaDAO.Create;

      try
        DAO.Delete(ID);
        Res.Send('Tarefa excluida');
      finally
        DAO.Free;
      end;
    end);

  // Estat�sticas sobre as tarefas
  THorse.Get('/stats',
    procedure(Req: THorseRequest; Res: THorseResponse)
    var
      DAO: TTarefaDAO;
      Json: TJSONObject;
    begin
      DAO := TTarefaDAO.Create;

      try
        Json := TJSONObject.Create;
        Json.AddPair('TotalTarefas', TJSONNumber.Create(DAO.GetTotalTarefas));
        Json.AddPair('MediaPrioridadePendentes', TJSONNumber.Create(DAO.GetMediaPrioridadePendentes));
        Json.AddPair('ConcluidaUltimos7Dias', TJSONNumber.Create(DAO.GetConcluidaUltimos7Dias));

        Res.ContentType('application/json')
                       .Send(Json.ToJSON);
      finally
        DAO.Free;
      end;
    end);

  Writeln('API rodando em http://localhost:9000');
  Writeln('Pressione CTRL+C para encerrar.');
  THorse.Listen(9000);
end.

