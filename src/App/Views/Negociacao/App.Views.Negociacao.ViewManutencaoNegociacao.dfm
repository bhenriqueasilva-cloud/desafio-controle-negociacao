object ViewManutencaoNegociacao: TViewManutencaoNegociacao
  Left = 0
  Top = 0
  ClientHeight = 570
  ClientWidth = 700
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
  OnDestroy = FormDestroy
  OnShow = FormShow
  TextHeight = 13
  object pnlTitulo: TPanel
    Left = 0
    Top = 0
    Width = 700
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
      Width = 222
      Height = 19
      Caption = 'Manuten'#231#227'o de Negocia'#231#227'o'
    end
  end
  object grpBusca: TGroupBox
    Left = 16
    Top = 64
    Width = 668
    Height = 55
    Caption = 'Buscar Negocia'#231#227'o para Altera'#231#227'o'
    TabOrder = 1
    object lblCodigoBusca: TLabel
      Left = 16
      Top = 24
      Width = 37
      Height = 13
      Caption = 'C'#243'digo:'
    end
    object edtCodigoBusca: TEdit
      Left = 80
      Top = 21
      Width = 100
      Height = 21
      TabOrder = 0
    end
    object btnBuscar: TButton
      Left = 190
      Top = 19
      Width = 75
      Height = 25
      Caption = 'Buscar'
      TabOrder = 1
      OnClick = btnBuscarClick
    end
  end
  object grpDados: TGroupBox
    Left = 16
    Top = 130
    Width = 668
    Height = 80
    Caption = 'Dados da Negoci'#231#227'o'
    TabOrder = 2
    object lblProdutor: TLabel
      Left = 16
      Top = 24
      Width = 46
      Height = 13
      Caption = 'Produtor:'
    end
    object lblDistribuidor: TLabel
      Left = 16
      Top = 48
      Width = 58
      Height = 13
      Caption = 'Distribuidor:'
    end
    object cbxProdutor: TComboBox
      Left = 80
      Top = 21
      Width = 465
      Height = 21
      TabOrder = 0
      OnChange = cbxProdutorChange
    end
    object cbxDistribuidor: TComboBox
      Left = 80
      Top = 48
      Width = 465
      Height = 21
      TabOrder = 1
      OnChange = cbxDistribuidorChange
    end
  end
  object grpItens: TGroupBox
    Left = 16
    Top = 220
    Width = 668
    Height = 200
    Caption = 'Itens da Negocia'#231#227'o'
    TabOrder = 3
    object lblProduto: TLabel
      Left = 16
      Top = 24
      Width = 42
      Height = 13
      Caption = 'Produto:'
    end
    object lblQuantidade: TLabel
      Left = 280
      Top = 24
      Width = 60
      Height = 13
      Caption = 'Quantidade:'
    end
    object lblPrecoUnitario: TLabel
      Left = 380
      Top = 24
      Width = 71
      Height = 13
      Caption = 'Pre'#231'o Unit'#225'rio:'
    end
    object cbxProduto: TComboBox
      Left = 16
      Top = 40
      Width = 250
      Height = 21
      TabOrder = 0
      OnChange = cbxProdutoChange
    end
    object edtQuantidade: TEdit
      Left = 280
      Top = 40
      Width = 90
      Height = 21
      TabOrder = 1
    end
    object edtPrecoUnitario: TEdit
      Left = 380
      Top = 40
      Width = 90
      Height = 21
      Color = clBisque
      Enabled = False
      TabOrder = 2
    end
    object btnAdicionarItem: TButton
      Left = 480
      Top = 38
      Width = 90
      Height = 25
      Caption = 'Adicionar'
      TabOrder = 3
      OnClick = btnAdicionarItemClick
    end
    object btnRemoverItem: TButton
      Left = 580
      Top = 38
      Width = 75
      Height = 25
      Caption = 'Remover'
      TabOrder = 4
      OnClick = btnRemoverItemClick
    end
    object grdItens: TStringGrid
      Left = 16
      Top = 72
      Width = 640
      Height = 115
      ColCount = 4
      DefaultRowHeight = 20
      FixedCols = 0
      RowCount = 2
      TabOrder = 5
      ColWidths = (
        200
        100
        100
        120)
    end
  end
  object grpTotal: TGroupBox
    Left = 16
    Top = 430
    Width = 668
    Height = 70
    Caption = 'Resumo'
    TabOrder = 4
    object lblValorTotal: TLabel
      Left = 16
      Top = 24
      Width = 55
      Height = 13
      Caption = 'Valor Total:'
    end
    object lblStatus: TLabel
      Left = 300
      Top = 24
      Width = 35
      Height = 13
      Caption = 'Status:'
    end
    object edtValorTotal: TEdit
      Left = 85
      Top = 21
      Width = 150
      Height = 21
      TabOrder = 0
    end
    object edtStatus: TEdit
      Left = 343
      Top = 21
      Width = 150
      Height = 21
      TabOrder = 1
    end
  end
  object btnSalvar: TButton
    Left = 480
    Top = 515
    Width = 90
    Height = 30
    Caption = 'Salvar'
    TabOrder = 5
    OnClick = btnSalvarClick
  end
  object btnCancelar: TButton
    Left = 590
    Top = 515
    Width = 90
    Height = 30
    Caption = 'Cancelar'
    TabOrder = 6
    OnClick = btnCancelarClick
  end
end
