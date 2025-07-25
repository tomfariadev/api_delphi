unit uAdicionar;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons,
  REST.Client, REST.Types, System.JSON;

type
  TFAdicionar = class(TForm)
    edtTitulo: TEdit;
    lblTitulo: TLabel;
    edtDescricao: TEdit;
    Label1: TLabel;
    rgPrioridade: TRadioGroup;
    BAdicionar: TBitBtn;
    procedure BAdicionarClick(Sender: TObject);
  private

  public

  end;

var
  FAdicionar: TFAdicionar;

implementation

{$R *.dfm}

uses uDM;

procedure TFAdicionar.BAdicionarClick(Sender: TObject);
var
  JsonBody: TJSONObject;
begin
  if Trim(edtTitulo.Text) = '' then
  begin
    ShowMessage('O t�tulo � obrigat�rio');
    edtTitulo.SetFocus;
    Exit;
  end;

  if Trim(edtDescricao.Text) = '' then
  begin
    ShowMessage('Descri��o � obrigat�ria.');
    edtDescricao.SetFocus;
    Exit;
  end;

  JsonBody := TJSONObject.Create;

  try
    JsonBody.AddPair('titulo', EdtTitulo.Text);
    JsonBody.AddPair('descricao', EdtDescricao.Text);
    JsonBody.AddPair('prioridade', TJSONNumber.Create(rgPrioridade.ItemIndex + 1));

    // Limpa requisi��o anterior
    DM.ReqTarefaPost.Params.Clear;
    DM.ReqTarefaPost.Body.ClearBody;

    // Adiciona o body JSON
    DM.ReqTarefaPost.AddBody(JsonBody.ToString, ctAPPLICATION_JSON);

    DM.ReqTarefaPost.Execute;

    if DM.ReqTarefaPost.Response.StatusCode in [200, 201] then
    begin
      ShowMessage('Tarefa adicionada com sucesso!');
      ModalResult := mrOk;
    end
    else
      ShowMessage('Erro: ' + DM.ReqTarefaPost.Response.Content);

  finally
    JsonBody.Free;
  end;
end;


end.
