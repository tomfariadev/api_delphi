unit uDM;

interface

uses
  System.SysUtils, System.Classes, REST.Types, REST.Client,
  Data.Bind.Components, Data.Bind.ObjectScope;

type
  TDM = class(TDataModule)
    RESTClient1: TRESTClient;
    ReqTarefaGet: TRESTRequest;
    ReqTarefaPost: TRESTRequest;
    ReqTarefaDelete: TRESTRequest;
    ReqTarefaPut: TRESTRequest;
    ReqTarefaStats: TRESTRequest;
  private
    { Private declarations }
  public
    function StringToDateTimeSafe(const ADateStr: string): TDateTime;
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TDM }

{ TDM }

function TDM.StringToDateTimeSafe(const ADateStr: string): TDateTime;
var
  FS: TFormatSettings;
  DataHora: TDateTime;
begin
  if ADateStr.Trim.IsEmpty then
    Exit(0);

  FS := TFormatSettings.Create;
  FS.ShortDateFormat := 'dd/MM/yyyy';
  FS.DateSeparator := '/';
  FS.TimeSeparator := ':';
  FS.LongTimeFormat := 'hh:nn:ss';

  if not TryStrToDateTime(ADateStr, DataHora, FS) then
    raise Exception.CreateFmt('Data inv�lida: %s', [ADateStr]);

  Result := DataHora;
end;

end.
