object FAdicionar: TFAdicionar
  Left = 0
  Top = 0
  Caption = 'Adicionar nova tarefa'
  ClientHeight = 301
  ClientWidth = 284
  Color = clBtnFace
  Constraints.MaxHeight = 340
  Constraints.MaxWidth = 300
  Constraints.MinHeight = 340
  Constraints.MinWidth = 300
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  TextHeight = 15
  object lblTitulo: TLabel
    Left = 24
    Top = 24
    Width = 30
    Height = 15
    Caption = 'T'#237'tulo'
  end
  object Label1: TLabel
    Left = 24
    Top = 80
    Width = 51
    Height = 15
    Caption = 'Descri'#231#227'o'
  end
  object edtTitulo: TEdit
    Left = 24
    Top = 45
    Width = 237
    Height = 23
    TabOrder = 0
  end
  object edtDescricao: TEdit
    Left = 24
    Top = 101
    Width = 237
    Height = 23
    TabOrder = 1
  end
  object rgPrioridade: TRadioGroup
    Left = 24
    Top = 138
    Width = 237
    Height = 76
    Caption = 'Prioridade'
    Columns = 5
    ItemIndex = 0
    Items.Strings = (
      '1'
      '2'
      '3'
      '4'
      '5')
    TabOrder = 2
  end
  object BAdicionar: TBitBtn
    Left = 24
    Top = 240
    Width = 237
    Height = 33
    Caption = 'Adicionar'
    TabOrder = 3
    OnClick = BAdicionarClick
  end
end
