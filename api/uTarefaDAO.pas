unit uTarefaDAO;

interface

uses
  System.SysUtils, System.Generics.Collections, Data.Win.ADODB,
  uTarefa, uConexao;

type
  TTarefaDAO = Class
    private
      FConexao: TADOConnection;

    public
      constructor Create;
      destructor Destroy; override;

      function GetTarefas: TObjectList<TTarefa>;
      procedure Add(ATarefa: TTarefa);
      procedure UpdateStatus(ID: Integer; Status: string = '');
      procedure Delete(ID: Integer);

      function GetTotalTarefas: Integer;
      function GetMediaPrioridadePendentes: Double;
      function GetConcluidaUltimos7Dias: Integer;
  End;

implementation

{ TTarefaDAO }

procedure TTarefaDAO.Add(ATarefa: TTarefa);
var
  Query: TADOQuery;
begin
  //  Insere uma nova tarefa no banco de dados
  Query := TADOQuery.Create(nil);
  try
    Query.Connection := FConexao;

    Query.SQL.Text := 'INSERT INTO TAREFA (TITULO, DESCRICAO, PRIORIDADE, STATUS, DATA_INSERT) ' +
                      'VALUES (:TITULO, :DESCRICAO, :PRIORIDADE, :STATUS, :DATA_INSERT)';

    Query.Parameters.ParamByName('TITULO').Value      := ATarefa.Titulo;
    Query.Parameters.ParamByName('DESCRICAO').Value   := ATarefa.Descricao;
    Query.Parameters.ParamByName('PRIORIDADE').Value  := ATarefa.Prioridade;
    Query.Parameters.ParamByName('STATUS').Value      := ATarefa.Status;
    Query.Parameters.ParamByName('DATA_INSERT').Value := Now;
    Query.ExecSQL;
  finally
    Query.Free;
  end;
end;

constructor TTarefaDAO.Create;
begin
  FConexao := TConexao.GetConnection;
end;

procedure TTarefaDAO.Delete(ID: Integer);
var
  Query: TADOQuery;
begin
  // Exclui uma tarefa do banco de dados usando o ID
  Query := TADOQuery.Create(nil);
  try
    Query.Connection := FConexao;
    Query.SQL.Text := 'DELETE FROM TAREFA WHERE ID = :ID';
    Query.Parameters.ParamByName('ID').Value := ID;
    Query.ExecSQL;
  finally
    Query.Free;
  end;
end;

destructor TTarefaDAO.Destroy;
begin
  if Assigned(FConexao) then
    FreeAndNil(FConexao);

  inherited;
end;

function TTarefaDAO.GetConcluidaUltimos7Dias: Integer;
var
  Query: TADOQuery;
begin
  Query := TADOQuery.Create(nil);

  try
    Query.Connection := FConexao;

    Query.SQL.Text := ('SELECT COUNT(*) TOTAL FROM TAREFA '+
                       ' WHERE STATUS =  ''C'' ' + // Completa
                       ' AND DATA_CONCLUSAO >= DATEADD(DAY, -7, GETDATE())');
    Query.Open;

    Result := Query.FieldByName('TOTAL').AsInteger;
  finally
    Query.Free;
  end;

end;

function TTarefaDAO.GetMediaPrioridadePendentes: Double;
var
  Query: TADOQuery;
begin
  Query := TADOQuery.Create(nil);

  try
    Query.Connection := FConexao;
    Query.SQL.Text   := 'SELECT AVG(PRIORIDADE) MEDIA FROM TAREFA WHERE STATUS = ''P'' '; //Pendente
    Query.Open;

    Result := Query.FieldByName('MEDIA').AsFloat;
  finally
    Query.Free;
  end;
end;

function TTarefaDAO.GetTarefas: TObjectList<TTarefa>;
var
  Query: TADOQuery;
  Tarefa: TTarefa;
begin
  Result := TObjectList<TTarefa>.Create;

  Query := TADOQuery.Create(nil);

  try
    Query.Connection := FConexao;
    Query.SQL.Text := 'SELECT ID, TITULO, DESCRICAO, PRIORIDADE, STATUS, DATA_INSERT, DATA_CONCLUSAO FROM TAREFA';
    Query.Open;

    while not Query.Eof do
    begin
      Tarefa := TTarefa.Create;
      Tarefa.ID            := Query.FieldByName('ID').AsInteger;
      Tarefa.Titulo        := Query.FieldByName('TITULO').AsString;
      Tarefa.Descricao     := Query.FieldByName('DESCRICAO').AsString;
      Tarefa.Prioridade    := Query.FieldByName('PRIORIDADE').AsInteger;
      Tarefa.Status        := Query.FieldByName('STATUS').AsString;
      Tarefa.DataInsert    := Query.FieldByName('DATA_INSERT').AsDateTime;
      Tarefa.DataConclusao := Query.FieldByName('DATA_CONCLUSAO').AsDateTime;
      Result.Add(Tarefa);

      Query.Next;
    end;
  finally
    Query.Free;
  end;
end;

function TTarefaDAO.GetTotalTarefas: Integer;
var
  Query: TADOQuery;
begin
  Query := TADOQuery.Create(nil);
  try
    Query.Connection := FConexao;
    Query.SQL.Text   := 'SELECT COUNT(*) TOTAL FROM TAREFA';
    Query.Open;

    Result := Query.FieldByName('TOTAL').AsInteger;
  finally
    Query.Free;
  end;
end;

procedure TTarefaDAO.UpdateStatus(ID: Integer; Status: string);
var
  Query: TADOQuery;
begin
  // Atualiza o status de uma tarefa com base no ID
  Query := TADOQuery.Create(nil);
  try
    Query.Connection := FConexao;


    // Se o status for 'C' (Conclu�da), grava DATA_CONCLUSAO com a data/hora atual
    if Status = 'C' then
    begin
      Query.SQL.Text := 'UPDATE TAREFA SET STATUS = :STATUS, DATA_CONCLUSAO = :DATA_CONCLUSAO WHERE ID = :ID';
      Query.Parameters.ParamByName('DATA_CONCLUSAO').Value := Now;
    end
    else
      Query.SQL.Text := 'UPDATE TAREFA SET STATUS = :STATUS WHERE ID = :ID';

    Query.Parameters.ParamByName('STATUS').Value := Status;
    Query.Parameters.ParamByName('ID').Value     := ID;
    Query.ExecSQL;
  finally
    Query.Free;
  end;
end;

end.
