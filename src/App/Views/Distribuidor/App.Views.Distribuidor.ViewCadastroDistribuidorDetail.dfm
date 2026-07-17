inherited ViewCadastroDistribuidorDetail: TViewCadastroDistribuidorDetail
  Caption = ''
  StyleElements = [seFont, seClient, seBorder]
  TextHeight = 15
  inherited pgcPrincipal: TPageControl
    inherited tsConsulta: TTabSheet
      inherited pnlFiltro: TPanel
        StyleElements = [seFont, seClient, seBorder]
        inherited edtPesquisa: TEdit
          StyleElements = [seFont, seClient, seBorder]
        end
      end
    end
    inherited tsDados: TTabSheet
      object lblNome: TLabel [0]
        Left = 24
        Top = 24
        Width = 38
        Height = 15
        Caption = 'Nome*'
      end
      object lblCnpj: TLabel [1]
        Left = 24
        Top = 72
        Width = 32
        Height = 15
        Caption = 'CNPJ*'
      end
      object edtNome: TEdit [2]
        Left = 24
        Top = 43
        Width = 400
        Height = 23
        CharCase = ecUpperCase
        MaxLength = 100
        TabOrder = 0
      end
      object edtCnpj: TEdit [3]
        Left = 24
        Top = 91
        Width = 200
        Height = 23
        MaxLength = 18
        TabOrder = 1
      end
      inherited gbDetail: TGroupBox
        TabOrder = 2
        inherited gridDetail: TDBGrid
          Columns = <
            item
              Expanded = False
              FieldName = 'NOME_PRODUTO'
              Title.Caption = 'Produto'
              Width = 387
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'VALOR_PRODUTO'
              Title.Caption = 'Valor'
              Width = 107
              Visible = True
            end>
        end
        inherited pnlButtonDetail: TPanel
          StyleElements = [seFont, seClient, seBorder]
          inherited btnIncluirDetail: TSpeedButton
            OnClick = btnIncluirDetailClick
          end
          inherited brnExcluirDetail: TSpeedButton
            OnClick = brnExcluirDetailClick
            ExplicitTop = 41
          end
        end
      end
    end
  end
  inherited pnlBotoes: TPanel
    StyleElements = [seFont, seClient, seBorder]
  end
  inherited pnlTitulo: TPanel
    StyleElements = [seFont, seClient, seBorder]
    inherited lblTitulo: TLabel
      StyleElements = [seFont, seClient, seBorder]
    end
  end
end
