object ViewConsultaNegociacoes: TViewConsultaNegociacoes
  Left = 0
  Top = 0
  ClientHeight = 473
  ClientWidth = 956
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
  OnCreate = FormCreate
  TextHeight = 13
  object pnlTitulo: TPanel
    Left = 0
    Top = 0
    Width = 956
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
      Width = 202
      Height = 19
      Caption = 'Consulta de Negocia'#231#245'es'
    end
  end
  object grpFiltros: TGroupBox
    Left = 16
    Top = 64
    Width = 921
    Height = 80
    Caption = 'Filtros'
    TabOrder = 1
    object lblProdutor: TLabel
      Left = 16
      Top = 24
      Width = 46
      Height = 13
      Caption = 'Produtor:'
    end
    object lblDistribuidor: TLabel
      Left = 300
      Top = 24
      Width = 58
      Height = 13
      Caption = 'Distribuidor:'
    end
    object cbxProdutor: TComboBox
      Left = 16
      Top = 40
      Width = 250
      Height = 21
      TabOrder = 0
    end
    object cbxDistribuidor: TComboBox
      Left = 300
      Top = 40
      Width = 250
      Height = 21
      TabOrder = 1
    end
    object btnFiltrar: TButton
      Left = 580
      Top = 38
      Width = 75
      Height = 25
      Caption = 'Filtrar'
      TabOrder = 2
      OnClick = btnFiltrarClick
    end
    object btnLimpar: TButton
      Left = 670
      Top = 38
      Width = 75
      Height = 25
      Caption = 'Limpar'
      TabOrder = 3
      OnClick = btnLimparClick
    end
  end
  object grpResultados: TGroupBox
    Left = 16
    Top = 152
    Width = 921
    Height = 230
    Caption = 'Resultados'
    TabOrder = 2
    object grdNegociacoes: TStringGrid
      Left = 16
      Top = 24
      Width = 889
      Height = 190
      ColCount = 7
      DefaultRowHeight = 20
      FixedCols = 0
      RowCount = 2
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
      TabOrder = 0
      ColWidths = (
        60
        150
        150
        100
        100
        80
        100)
    end
  end
  object btnAlterarStatus: TButton
    Left = 640
    Top = 388
    Width = 105
    Height = 30
    Caption = 'Alterar Status'
    TabOrder = 3
    OnClick = btnAlterarStatusClick
  end
  object btnImprimir: TButton
    Left = 751
    Top = 388
    Width = 90
    Height = 30
    Caption = 'Imprimir'
    TabOrder = 4
    OnClick = btnImprimirClick
  end
  object btnFechar: TButton
    Left = 847
    Top = 388
    Width = 90
    Height = 30
    Caption = 'Fechar'
    TabOrder = 5
    OnClick = btnFecharClick
  end
end
