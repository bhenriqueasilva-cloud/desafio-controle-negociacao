object ViewAlteracaoStatusNegociacao: TViewAlteracaoStatusNegociacao
  Left = 0
  Top = 0
  ClientHeight = 350
  ClientWidth = 500
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIChild
  Position = poScreenCenter
  Visible = True
  OnClose = FormClose
  OnDestroy = FormDestroy
  TextHeight = 13
  object pnlTitulo: TPanel
    Left = 0
    Top = 0
    Width = 500
    Height = 50
    Align = alTop
    BevelOuter = bvLowered
    Color = 12615808
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 0
    object lblTitulo: TLabel
      Left = 16
      Top = 12
      Width = 284
      Height = 19
      Caption = 'Altera'#231#227'o de Status de Negocia'#231#227'o'
    end
  end
  object grpDados: TGroupBox
    Left = 16
    Top = 64
    Width = 468
    Height = 80
    Caption = 'Buscar Negocia'#231#227'o'
    TabOrder = 1
    object lblCodigo: TLabel
      Left = 16
      Top = 24
      Width = 37
      Height = 13
      Caption = 'C'#243'digo:'
    end
    object edtCodigo: TEdit
      Left = 16
      Top = 40
      Width = 250
      Height = 21
      TabOrder = 0
    end
    object btnBuscar: TButton
      Left = 280
      Top = 38
      Width = 90
      Height = 25
      Caption = 'Buscar'
      TabOrder = 1
      OnClick = btnBuscarClick
    end
  end
  object grpStatus: TGroupBox
    Left = 16
    Top = 152
    Width = 468
    Height = 130
    Caption = 'Alterar Status'
    TabOrder = 2
    object lblStatusAtual: TLabel
      Left = 16
      Top = 24
      Width = 63
      Height = 13
      Caption = 'Status Atual:'
    end
    object edtStatusAtual: TEdit
      Left = 16
      Top = 40
      Width = 250
      Height = 21
      ReadOnly = True
      TabOrder = 0
    end
    object btnAprovar: TButton
      Left = 16
      Top = 72
      Width = 90
      Height = 30
      Caption = 'Aprovar'
      TabOrder = 1
      OnClick = btnAprovarClick
    end
    object btnConcluir: TButton
      Left = 120
      Top = 72
      Width = 90
      Height = 30
      Caption = 'Concluir'
      TabOrder = 2
      OnClick = btnConcluirClick
    end
    object btnCancelar: TButton
      Left = 224
      Top = 72
      Width = 90
      Height = 30
      Caption = 'Cancelar'
      TabOrder = 3
      OnClick = btnCancelarClick
    end
  end
  object btnFechar: TButton
    Left = 380
    Top = 300
    Width = 90
    Height = 30
    Caption = 'Fechar'
    TabOrder = 3
    OnClick = btnFecharClick
  end
end
