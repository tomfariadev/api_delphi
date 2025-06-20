object DM: TDM
  Height = 213
  Width = 571
  object RESTClient1: TRESTClient
    BaseURL = 'http://localhost:9000'
    Params = <>
    Left = 40
    Top = 24
  end
  object ReqTarefaGet: TRESTRequest
    AssignedValues = [rvConnectTimeout, rvReadTimeout]
    Client = RESTClient1
    Params = <>
    Resource = 'tarefas'
    SynchronizedEvents = False
    Left = 40
    Top = 88
  end
  object ReqTarefaPost: TRESTRequest
    AssignedValues = [rvConnectTimeout, rvReadTimeout]
    Client = RESTClient1
    Method = rmPOST
    Params = <
      item
        Kind = pkREQUESTBODY
        Name = 'body4C80237A27FF4348A1E5DC7C65B07503'
        Value = 
          '{'#13#10'  "titulo": "Teste",'#13#10'  "descricao": "Nova tarefa criada para' +
          ' teste",'#13#10'  "prioridade": 5'#13#10'}'
        ContentTypeStr = 'application/json'
      end>
    Resource = 'tarefas'
    SynchronizedEvents = False
    Left = 136
    Top = 88
  end
  object ReqTarefaDelete: TRESTRequest
    AssignedValues = [rvConnectTimeout, rvReadTimeout]
    Client = RESTClient1
    Method = rmDELETE
    Params = <
      item
        Kind = pkREQUESTBODY
        Name = 'bodyF22054C79BE74408A450A763EF427263'
        Value = '{'#13#10'  "status": "C"'#13#10'}'
        ContentTypeStr = 'application/json'
      end
      item
        Kind = pkURLSEGMENT
        Name = 'id'
        Options = [poAutoCreated]
      end>
    Resource = 'tarefas/{id}'
    SynchronizedEvents = False
    Left = 232
    Top = 88
  end
  object ReqTarefaPut: TRESTRequest
    AssignedValues = [rvConnectTimeout, rvReadTimeout]
    Client = RESTClient1
    Method = rmPUT
    Params = <
      item
        Kind = pkREQUESTBODY
        Name = 'bodyF22054C79BE74408A450A763EF427263'
        Value = '{'#13#10'  "status": "C"'#13#10'}'
        ContentTypeStr = 'application/json'
      end
      item
        Kind = pkURLSEGMENT
        Name = 'id'
        Options = [poAutoCreated]
      end>
    Resource = 'tarefas/{id}/status'
    SynchronizedEvents = False
    Left = 336
    Top = 88
  end
  object ReqTarefaStats: TRESTRequest
    AssignedValues = [rvConnectTimeout, rvReadTimeout]
    Client = RESTClient1
    Params = <>
    Resource = 'stats'
    SynchronizedEvents = False
    Left = 432
    Top = 88
  end
end
