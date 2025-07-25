unit uConexao;

interface

uses
  System.SysUtils, Data.Win.ADODB, IniFiles;

type
  TConexao = class
  public
    class function GetConnection: TADOConnection;
  end;

implementation

{ TConexao }

class function TConexao.GetConnection: TADOConnection;
var
  Conexao: TADOConnection;
  Ini: TIniFile;
  Server, Database, UserName, Password: string;
  ConnString: string;
  IniPath: string;
begin
  Ini := Nil;

  try
    // Leitura do arquivo de configura��o
    IniPath := ExtractFilePath(ParamStr(0)) + 'Config.ini';

    if not FileExists(IniPath) then
      raise Exception.Create('Arquivo "Config.ini" n�o encontrado.');

    Ini := TIniFile.Create(IniPath);
    Server   := Ini.ReadString('DATABASE', 'Server', '');
    Database := Ini.ReadString('DATABASE', 'Database', '');
    UserName := Ini.ReadString('DATABASE', 'User', '');
    Password := Ini.ReadString('DATABASE', 'Password', '');

    if (Server = '') or (Database = '') then
      raise Exception.Create('Par�metros de conex�o incompletos, configure o arquivo Config.ini');

    // Connection String
    ConnString :=
      'Provider=SQLOLEDB;' +
      'Data Source=' + Server + ';' +
      'Initial Catalog=' + Database + ';' +
      'User ID=' + UserName + ';' +
      'Password=' + Password + ';' +
      'Persist Security Info=True;';

    Conexao := TADOConnection.Create(nil);
    try
      Conexao.ConnectionString := ConnString;
      Conexao.LoginPrompt      := False;
      Conexao.Connected        := True;
      Result := Conexao;
    except
      on E: Exception do
      begin
        Conexao.Free;
        raise Exception.Create('Erro na conex�o: ' + E.Message);
      end;
    end;
  finally
    Ini.Free;
  end;
end;

end.
