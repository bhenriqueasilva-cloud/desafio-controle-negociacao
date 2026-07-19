object ViewBaseCadastro: TViewBaseCadastro
  Left = 0
  Top = 0
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  FormStyle = fsMDIChild
  Position = poScreenCenter
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  TextHeight = 15
  object pgcPrincipal: TPageControl
    Left = 0
    Top = 35
    Width = 624
    Height = 365
    ActivePage = tsConsulta
    Align = alClient
    TabOrder = 0
    object tsConsulta: TTabSheet
      Caption = 'Consulta'
      object gridConsulta: TDBGrid
        Left = 0
        Top = 41
        Width = 616
        Height = 294
        Align = alClient
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -12
        TitleFont.Name = 'Segoe UI'
        TitleFont.Style = []
        OnDblClick = gridConsultaDblClick
      end
      object pnlFiltro: TPanel
        Left = 0
        Top = 0
        Width = 616
        Height = 41
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        object edtPesquisa: TEdit
          Left = 10
          Top = 9
          Width = 350
          Height = 23
          TabOrder = 0
          TextHint = 'Digite para pesquisar...'
        end
        object btnPesquisar: TButton
          Left = 368
          Top = 8
          Width = 85
          Height = 25
          Caption = 'Pesquisar'
          TabOrder = 1
          OnClick = btnPesquisarClick
        end
      end
    end
    object tsDados: TTabSheet
      Caption = 'Dados'
      ImageIndex = 1
    end
  end
  object pnlBotoes: TPanel
    Left = 0
    Top = 400
    Width = 624
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object btnNovo: TButton
      Left = 10
      Top = 8
      Width = 85
      Height = 25
      Caption = 'Novo'
      TabOrder = 0
      OnClick = btnNovoClick
    end
    object btnEditar: TButton
      Left = 101
      Top = 8
      Width = 85
      Height = 25
      Caption = 'Editar'
      TabOrder = 1
      OnClick = btnEditarClick
    end
    object btnDeletar: TButton
      Left = 192
      Top = 8
      Width = 85
      Height = 25
      Caption = 'Deletar'
      TabOrder = 2
      OnClick = btnDeletarClick
    end
    object btnSalvar: TButton
      Left = 283
      Top = 8
      Width = 85
      Height = 25
      Caption = 'Salvar'
      TabOrder = 3
      OnClick = btnSalvarClick
    end
    object btnCancelar: TButton
      Left = 374
      Top = 8
      Width = 85
      Height = 25
      Caption = 'Cancelar'
      TabOrder = 4
      OnClick = btnCancelarClick
    end
  end
  object pnlTitulo: TPanel
    Left = 0
    Top = 0
    Width = 624
    Height = 35
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
    TabOrder = 2
    ExplicitTop = -6
    object lblTitulo: TLabel
      Left = 16
      Top = 7
      Width = 5
      Height = 19
    end
  end
end
