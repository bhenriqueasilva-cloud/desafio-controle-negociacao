inherited ViewCadastroProdutor: TViewCadastroProdutor
  StyleElements = [seFont, seClient, seBorder]
  TextHeight = 15
  inherited pgcPrincipal: TPageControl
    Top = 29
    Height = 371
    ExplicitTop = 29
    ExplicitHeight = 363
    inherited tsConsulta: TTabSheet
      ExplicitHeight = 341
      inherited gridConsulta: TDBGrid
        Height = 300
        Columns = <
          item
            Expanded = False
            FieldName = 'ID'
            Title.Caption = 'C'#243'digo'
            Width = 60
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'NOME'
            Title.Caption = 'Nome do Produtor'
            Width = 320
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CPF_CNPJ'
            Title.Caption = 'CPF / CNPJ'
            Width = 150
            Visible = True
          end>
      end
      inherited pnlFiltro: TPanel
        StyleElements = [seFont, seClient, seBorder]
        ExplicitWidth = 616
        inherited edtPesquisa: TEdit
          StyleElements = [seFont, seClient, seBorder]
        end
      end
    end
    inherited tsDados: TTabSheet
      ExplicitHeight = 341
      object lblNome: TLabel
        Left = 20
        Top = 20
        Width = 100
        Height = 15
        Caption = 'Nome do Produtor'
      end
      object lblCpfCnpj: TLabel
        Left = 20
        Top = 80
        Width = 59
        Height = 15
        Caption = 'CPF / CNPJ'
      end
      object edtNome: TEdit
        Left = 20
        Top = 40
        Width = 400
        Height = 23
        Hint = 'Informe o nome do produtor.'
        MaxLength = 100
        TabOrder = 0
      end
      object edtCpfCnpj: TEdit
        Left = 20
        Top = 100
        Width = 200
        Height = 23
        Hint = 'Informe um CPF/CNPJ v'#225'lido.'
        MaxLength = 18
        TabOrder = 1
      end
      object pnlLimite: TPanel
        Left = 0
        Top = 160
        Width = 616
        Height = 181
        Align = alBottom
        BevelOuter = bvNone
        Caption = 'pnlLimite'
        TabOrder = 2
        ExplicitTop = 152
        ExplicitWidth = 614
        object gridLimite: TDBGrid
          Left = 0
          Top = 0
          Width = 576
          Height = 181
          Align = alClient
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -12
          TitleFont.Name = 'Segoe UI'
          TitleFont.Style = []
          OnColEnter = gridLimiteColEnter
          OnColExit = gridLimiteColExit
          OnDrawColumnCell = gridLimiteDrawColumnCell
          Columns = <
            item
              Expanded = False
              FieldName = 'NOME_DISTRIBUIDOR'
              Title.Caption = 'Distribuidor'
              Width = 438
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'VALOR_LIMITE'
              Title.Caption = 'Valor'
              Width = 101
              Visible = True
            end>
        end
        object pnlBotoesLimite: TPanel
          Left = 576
          Top = 0
          Width = 40
          Height = 181
          Align = alRight
          BevelKind = bkFlat
          TabOrder = 1
          ExplicitLeft = 574
          object btnAdicionarLimite: TSpeedButton
            Left = 1
            Top = 1
            Width = 34
            Height = 22
            Align = alTop
            Glyph.Data = {
              96010000424D9601000000000000760000002800000018000000180000000100
              0400000000002001000000000000000000001000000000000000000000000000
              80000080000000808000800000008000800080800000C0C0C000808080000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
              33333333333333333333333333333333333333F88888888888888888833333FA
              AAAA0EEEEE0DDDDD833333FAAAAA0EEEEE0DDDDD833333FAAAAA0EEEEE0DDDDD
              833333FAAAAA0EEEEE0DDDDD833333FAAAAA0EEEEE0DDDDD833333F000000000
              00000000833333F888880FFFFF000000833333F888880FFFFF000000833333F8
              88880FFFFF000000833333F888880FFFFF000000833333F888880FFFFF000000
              833333F00000000000000000833333F999990BBBBB0CCCCC833333F999990BBB
              BB0CCCCC833333F999990BBBBB0CCCCC833333F999990BBBBB0CCCCC833333F9
              99990BBBBB0CCCCC833333FFFFFFFFFFFFFFFFFFF33333333333333333333333
              3333333333333333333333333333333333333333333333333333}
            OnClick = btnAdicionarLimiteClick
            ExplicitLeft = 16
            ExplicitTop = 24
            ExplicitWidth = 23
          end
          object btnRemoverLimite: TSpeedButton
            Left = 1
            Top = 23
            Width = 34
            Height = 22
            Align = alTop
            Glyph.Data = {
              96010000424D9601000000000000760000002800000018000000180000000100
              0400000000002001000000000000000000001000000000000000000000000000
              80000080000000808000800000008000800080800000C0C0C000808080000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
              33333333333333333333333333333333333333F88888888888888888833333FA
              AAAA0EEEEE0DDDDD833333FAAAAA0EEEEE0DDDDD833333FAAAAA0EEEEE0DDDDD
              833333FAAAAA0EEEEE0DDDDD833333FAAAAA0EEEEE0DDDDD833333F000000000
              00000000833333F888880FFFFF000000833333F888880FFFFF000000833333F8
              88880FFFFF000000833333F888880FFFFF000000833333F888880FFFFF000000
              833333F00000000000000000833333F999990BBBBB0CCCCC833333F999990BBB
              BB0CCCCC833333F999990BBBBB0CCCCC833333F999990BBBBB0CCCCC833333F9
              99990BBBBB0CCCCC833333FFFFFFFFFFFFFFFFFFF33333333333333333333333
              3333333333333333333333333333333333333333333333333333}
            OnClick = btnRemoverLimiteClick
            ExplicitLeft = 4
            ExplicitTop = 51
          end
        end
      end
    end
  end
  inherited pnlBotoes: TPanel
    StyleElements = [seFont, seClient, seBorder]
  end
  inherited pnlTitulo: TPanel
    Height = 29
    StyleElements = [seFont, seClient, seBorder]
    ExplicitHeight = 29
    inherited lblTitulo: TLabel
      Left = 4
      Top = 4
      Width = 193
      Caption = 'Cadastro de Produtores'
      StyleElements = [seFont, seClient, seBorder]
      ExplicitLeft = 4
      ExplicitTop = 4
      ExplicitWidth = 193
    end
  end
end
