inherited ViewCadastroDistribuidor: TViewCadastroDistribuidor
  Caption = 'Cadastro de Distribuidores'
  StyleElements = [seFont, seClient, seBorder]
  TextHeight = 15
  inherited pgcPrincipal: TPageControl
    ActivePage = tsDados
    inherited tsConsulta: TTabSheet
      inherited gridConsulta: TDBGrid
        Columns = <
          item
            Expanded = False
            FieldName = 'ID'
            Title.Caption = 'C'#243'digo'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'NOME'
            Title.Caption = 'Nome'
            Width = 300
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CNPJ'
            Width = 150
            Visible = True
          end>
      end
      inherited pnlFiltro: TPanel
        StyleElements = [seFont, seClient, seBorder]
        inherited edtPesquisa: TEdit
          StyleElements = [seFont, seClient, seBorder]
        end
      end
    end
    inherited tsDados: TTabSheet
      object lblNome: TLabel
        Left = 24
        Top = 24
        Width = 38
        Height = 15
        Caption = 'Nome*'
      end
      object lblCnpj: TLabel
        Left = 24
        Top = 72
        Width = 32
        Height = 15
        Caption = 'CNPJ*'
      end
      object edtNome: TEdit
        Left = 24
        Top = 43
        Width = 400
        Height = 23
        CharCase = ecUpperCase
        MaxLength = 100
        TabOrder = 0
      end
      object edtCnpj: TEdit
        Left = 24
        Top = 91
        Width = 200
        Height = 23
        MaxLength = 18
        TabOrder = 1
      end
    end
  end
  inherited pnlBotoes: TPanel
    StyleElements = [seFont, seClient, seBorder]
  end
  inherited pnlTitulo: TPanel
    StyleElements = [seFont, seClient, seBorder]
    inherited lblTitulo: TLabel
      Width = 315
      Caption = 'Cadastro de Distribuidores de Insumos'
      StyleElements = [seFont, seClient, seBorder]
      ExplicitWidth = 315
    end
  end
end
