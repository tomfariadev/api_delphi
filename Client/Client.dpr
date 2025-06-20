program Client;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {FMain},
  uAdicionar in 'uAdicionar.pas' {FAdicionar},
  uDM in 'uDM.pas' {DM: TDataModule},
  uEstatisticas in 'uEstatisticas.pas' {FEstatisticas};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TFMain, FMain);
  Application.Run;
end.
