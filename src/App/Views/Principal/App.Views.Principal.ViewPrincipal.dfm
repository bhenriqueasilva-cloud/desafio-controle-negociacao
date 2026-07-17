object ViewPrincipal: TViewPrincipal
  Left = 0
  Top = 0
  Align = alClient
  Caption = 'Controle de Negocia'#231#245'es - Aliare'
  ClientHeight = 613
  ClientWidth = 1095
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIForm
  Menu = mMenu
  Position = poScreenCenter
  StyleElements = [seFont, seBorder]
  OnCreate = FormCreate
  TextHeight = 13
  object pnlTitulo: TPanel
    Left = 0
    Top = 0
    Width = 1095
    Height = 57
    Align = alTop
    BevelOuter = bvLowered
    Color = 12615808
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 0
    object lblTitulo: TLabel
      Left = 16
      Top = 16
      Width = 354
      Height = 23
      Caption = 'Sistema de Controle de  Negocia'#231#245'es'
    end
  end
  object mMenu: TMainMenu
    Left = 24
    Top = 80
    object Cadastros: TMenuItem
      Caption = 'Cadastros'
      object Produtor: TMenuItem
        Caption = 'Produtor'
        OnClick = ProdutorClick
      end
      object Distribuidor: TMenuItem
        Caption = 'Distribuidor'
        OnClick = DistribuidorClick
      end
      object Produto: TMenuItem
        Caption = 'Produto'
        OnClick = ProdutoClick
      end
    end
    object Negociacoes: TMenuItem
      Caption = 'Negocia'#231#245'es'
      object NovaNegociacao: TMenuItem
        Caption = 'Nova Negocia'#231#245'es'
        OnClick = NovaNegociacaoClick
      end
      object ConsultarNegociacoes: TMenuItem
        Caption = 'Consultar Negocia'#231#245'es'
        OnClick = ConsultarNegociacoesClick
      end
      object AlterarStatus: TMenuItem
        Caption = 'Alterar Status'
        OnClick = AlterarStatusClick
      end
    end
    object Sair: TMenuItem
      Caption = 'Sair'
      OnClick = SairClick
    end
  end
end
