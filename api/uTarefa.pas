unit uTarefa;

interface

uses
  System.Classes, SysUtils;

type
  TStatusTarefa = (stAberta, stConcluida, stCancelada);

  TTarefa = Class
    private
      FID: Integer;
      FTitulo: String;
      FDescricao: string;
      FPrioridade: Integer;
      FStatus: string;
      FDataInsert: TDateTime;
      FDataConclusao: TDateTime;
    public
      constructor Create;
      destructor Destroy; override;

      property ID: Integer              read FID            write FID;
      property Titulo: String           read FTitulo        write FTitulo;
      property Descricao: string        read FDescricao     write FDescricao;
      property Prioridade: Integer      read FPrioridade    write FPrioridade;
      property Status: string           read FStatus        write FStatus;
      property DataInsert: TDateTime    read FDataInsert    write FDataInsert;
      property DataConclusao: TDateTime read FDataConclusao write FDataConclusao;
  End;

implementation

{ TTarefa }

constructor TTarefa.Create;
begin
  inherited;
  FStatus := 'A';
  FDataInsert := Now;
  FDataConclusao := 0;
end;

destructor TTarefa.Destroy;
begin

  inherited;
end;

end.
