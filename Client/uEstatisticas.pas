unit uEstatisticas;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.JSON, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Buttons, VclTee.TeeGDIPlus, VCLTee.TeEngine, VCLTee.TeeProcs, VCLTee.Chart,
  VCLTee.Series;

type
  TFEstatisticas = class(TForm)
    PTotal: TPanel;
    PMedia: TPanel;
    LblMedia: TLabel;
    LblTotal: TLabel;
    PConcluidos: TPanel;
    LblConcluidos: TLabel;
    LblConcluidosDesc: TLabel;
    LblMediaDesc: TLabel;
    LblTotalDesc: TLabel;
    procedure FormShow(Sender: TObject);
  private
    procedure MostarEstatisticas;
  public
    { Public declarations }
  end;

var
  FEstatisticas: TFEstatisticas;

implementation

{$R *.dfm}

uses uDM;

{ TFEstatisticas }

procedure TFEstatisticas.FormShow(Sender: TObject);
begin
  MostarEstatisticas;
end;

procedure TFEstatisticas.MostarEstatisticas;
var
  Json: TJSONObject;
begin
  try
    DM.ReqTarefaStats.Params.Clear;
    DM.ReqTarefaStats.Execute;

    if DM.ReqTarefaStats.Response.StatusCode = 200 then
    begin
      Json := DM.ReqTarefaStats.Response.JSONValue as TJSONObject;

      LblTotal.Caption      := Json.GetValue<Integer>('TotalTarefas').ToString;
      LblMedia.Caption      := FormatFloat('0.00', Json.GetValue<Double>('MediaPrioridadePendentes'));
      LblConcluidos.Caption := Json.GetValue<Integer>('ConcluidaUltimos7Dias').ToString;
    end
    else
      ShowMessage('Erro ao obter estatísticas: ' + DM.ReqTarefaStats.Response.Content);
  except
    on E: Exception do
      ShowMessage('Erro na requisição: ' + E.Message);
  end;
end;

end.
