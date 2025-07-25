unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics,  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  Data.Bind.Components, Data.Bind.ObjectScope, Vcl.ExtCtrls, Vcl.Grids,
  REST.Client, REST.Types, System.JSON,
  REST.Response.Adapter, Vcl.DBGrids, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  System.DateUtils, System.Generics.Collections, System.UITypes;

type
  TFMain = class(TForm)
    PBottom: TPanel;
    PButtons: TPanel;
    BAdicionar: TBitBtn;
    BRemover: TBitBtn;
    BEstatisticas: TBitBtn;
    BRefresh: TBitBtn;
    tbTarefa: TFDMemTable;
    grdTarefas: TDBGrid;
    ComboStatus: TComboBox;
    BAtualizarStatus: TBitBtn;
    dsTarefa: TDataSource;
    tbTarefaID: TIntegerField;
    tbTarefaTitulo: TStringField;
    tbTarefaDescricao: TStringField;
    tbTarefaStatus: TStringField;
    tbTarefaPrioridade: TIntegerField;
    tbTarefaDataCriacao: TDateField;
    tbTarefaDataConclusao: TDateField;
    procedure BRefreshClick(Sender: TObject);
    procedure BAtualizarStatusClick(Sender: TObject);
    procedure BAdicionarClick(Sender: TObject);
    procedure BRemoverClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BEstatisticasClick(Sender: TObject);
    procedure tbTarefaDataConclusaoGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);

  private
    procedure AlterarStatus(ID: Integer; NovoStatus: string);

  public
    procedure ProcessarGET;
    procedure ProcessarGETErro(Sender: TObject);
  end;

var
  FMain: TFMain;

implementation

{$R *.dfm}

uses uAdicionar, uDM, uEstatisticas;

procedure TFMain.AlterarStatus(ID: Integer; NovoStatus: string);
var
  Json: TJSONObject;
  Stream: TStringStream;
begin
  // Atualiza o status de uma tarefa espec�fica na API
  Json := TJSONObject.Create;
  Stream := TStringStream.Create(Json.ToJSON, TEncoding.UTF8);
  try
    // Monta um JSON com o novo status
    Json.AddPair('status', NovoStatus);

    DM.ReqTarefaPut.Params.Clear;
    DM.ReqTarefaPut.Body.ClearBody;
    DM.ReqTarefaPut.Resource := Format('tarefas/%d/status', [ID]);
    DM.ReqTarefaPut.AddBody(Stream, ctAPPLICATION_JSON);

    // requisi��o PUT na API
    DM.ReqTarefaPut.Execute;

    if DM.ReqTarefaPut.Response.StatusCode = 200 then
      ShowMessage('Status atualizado!')
    else
      ShowMessage('Erro: ' + DM.ReqTarefaPut.Response.Content);
  finally
    Json.Free;
    Stream.Free;
    DM.ReqTarefaPut.Resource := '';
  end;
end;

procedure TFMain.BAdicionarClick(Sender: TObject);
begin
  FAdicionar := TFAdicionar.Create(Self);
  try
    FAdicionar.ShowModal;
  finally
    FAdicionar.Free;
  end;
end;

procedure TFMain.BAtualizarStatusClick(Sender: TObject);
var
  ID: Integer;
  NovoStatus: string;
begin
  if tbTarefa.IsEmpty then
  begin
    ShowMessage('Nenhuma tarefa selecionada.');
    Exit;
  end;

  ID := tbTarefa.FieldByName('ID').AsInteger;
  NovoStatus := Copy(ComboStatus.Text, 1, 1);

  AlterarStatus(ID, NovoStatus);
  BRefresh.Click;
end;

procedure TFMain.BEstatisticasClick(Sender: TObject);
begin
  FEstatisticas := TFEstatisticas.Create(Self);
  try
    FEstatisticas.ShowModal;
  finally
    FEstatisticas.Free;
  end;
end;

procedure TFMain.ProcessarGET;
var
  JsonValue: TJSONValue;
  JsonArray: TJSONArray;
  JsonObject: TJSONObject;
  I: Integer;
  DataStr: string;
begin
  // Processa a resposta da requisi��o GET que busca as tarefas na API

  if DM.ReqTarefaGet.Response.StatusCode <> 200 then
  begin
    Showmessage('Erro na consulta: ' +
                DM.ReqTarefaGet.Response.StatusCode.ToString);
    Exit;
  end;

  //Limpa e recarrega o MemTable
  tbTarefa.DisableControls;
  tbTarefa.Close;
  tbTarefa.Open;

  try
    JsonValue := DM.ReqTarefaGet.Response.JSONValue;

    if not (JsonValue is TJSONArray) then
    begin
      ShowMessage('Formato de resposta inv�lido');
      Exit;
    end;

    JsonArray := JsonValue as TJSONArray;

    for I := 0 to JsonArray.Count - 1 do
    begin
      // Converte o JSON retornado da API em registros no grid.
      JsonObject := JsonArray.Items[I] as TJSONObject;

      tbTarefa.Append;
      tbTarefa.FieldByName('ID').AsInteger             := JsonObject.GetValue<Integer>('ID');
      tbTarefa.FieldByName('Titulo').AsString          := JsonObject.GetValue<string>('TITULO');
      tbTarefa.FieldByName('Descricao').AsString       := JsonObject.GetValue<string>('DESCRICAO');
      tbTarefa.FieldByName('Prioridade').AsInteger     := JsonObject.GetValue<Integer>('PRIORIDADE');
      tbTarefa.FieldByName('Status').AsString          := JsonObject.GetValue<string>('STATUS');

      tbTarefa.FieldByName('Datacriacao').AsDateTime   := dm.StringToDateTimeSafe(
                                                            JsonObject.GetValue<String>('DATA_INSERT'));

      // Faz parsing da datas de cria��o para tratar valor vazio
      DataStr := JsonObject.GetValue<String>('DATA_CONCLUSAO');
      if DataStr.Trim = '' then
        tbTarefa.FieldByName('DataConclusao').Clear
      else
        tbTarefa.FieldByName('DataConclusao').AsDateTime := DM.StringToDateTimeSafe(DataStr);

      tbTarefa.Post;
    end;

  finally
    tbTarefa.EnableControls;
    tbTarefa.First;
  end;
end;

procedure TFMain.ProcessarGETErro(Sender: TObject);
begin
  //  Trata erros que ocorrem durante a execu��o ass�ncrona da requisi��o GET
  if Assigned(Sender) and (Sender is Exception) then
    ShowMessage(Exception(Sender).Message);
end;

procedure TFMain.tbTarefaDataConclusaoGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  if Sender.IsNull then
    Text := ''
  else
    Text := FormatDateTime('dd/mm/yyyy', Sender.AsDateTime);
end;

procedure TFMain.BRefreshClick(Sender: TObject);
begin
  // requisi��o GET de forma ass�ncrona
  // Ao receber a resposta, chama ProcessarGET
  // Em caso de erro, chama ProcessarGETErro
  try
    DM.ReqTarefaGet.ExecuteAsync(ProcessarGET, True, True, ProcessarGETErro);
  except
    on E: Exception do
      ShowMessage('Erro ao listar tarefas: ' + E.Message);
  end;
end;

procedure TFMain.BRemoverClick(Sender: TObject);
var
  ID: Integer;
begin
  // requisi��o DELETE na API para remover a tarefa selecionada na grid
  if tbTarefa.IsEmpty then
  begin
    ShowMessage('Nenhuma tarefa selecionada para exclus�o.');
    Exit;
  end;

  ID := tbTarefa.FieldByName('ID').AsInteger;

  if MessageDlg(Format('Deseja realmente excluir a tarefa ID %d?', [ID]),
                 mtConfirmation, [mbYes, mbNo], 0) = mrNo then
    Exit;

  DM.ReqTarefaDelete.Resource := Format('tarefas/%d', [ID]);

  try
    DM.ReqTarefaDelete.Execute;

    if DM.ReqTarefaDelete.Response.StatusCode in [200, 204] then
    begin
      ShowMessage('Tarefa exclu�da com sucesso!');
      BRefresh.Click;
    end;
  except
    on E: Exception do
    begin
      ShowMessage('Erro na requisi��o DELETE: ' + E.Message);
      Exit;
    end;
  end;
end;

procedure TFMain.FormCreate(Sender: TObject);
begin
  BRefresh.Click;
end;

end.
