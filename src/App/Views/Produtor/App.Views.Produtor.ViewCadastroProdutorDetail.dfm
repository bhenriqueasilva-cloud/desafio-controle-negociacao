inherited ViewCadastroProdutorDetail: TViewCadastroProdutorDetail
  Caption = ''
  StyleElements = [seFont, seClient, seBorder]
  TextHeight = 15
  inherited pgcPrincipal: TPageControl
    inherited tsConsulta: TTabSheet
      inherited gridConsulta: TDBGrid
        Columns = <
          item
            Alignment = taRightJustify
            Expanded = False
            FieldName = 'ID'
            Title.Caption = 'C'#243'digo'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'NOME'
            Title.Caption = 'Nome do Produtor'
            Width = 268
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CPF_CNPJ'
            Title.Caption = 'CPF / CNPJ'
            Width = 180
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
      object lblNome: TLabel [0]
        Left = 20
        Top = 20
        Width = 38
        Height = 15
        Caption = 'Nome*'
      end
      object lblCpfCnpj: TLabel [1]
        Left = 20
        Top = 80
        Width = 64
        Height = 15
        Caption = 'CPF / CNPJ*'
      end
      inherited gbDetail: TGroupBox
        inherited gridDetail: TDBGrid
          Width = 630
          Columns = <
            item
              Expanded = False
              FieldName = 'NOME_DISTRIBUIDOR'
              Title.Caption = 'Distribuidor'
              Width = 359
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'VALOR_LIMITE'
              Title.Caption = 'Valor'
              Width = 90
              Visible = True
            end>
        end
        inherited pnlButtonDetail: TPanel
          Left = 641
          Width = 31
          StyleElements = [seFont, seClient, seBorder]
          ExplicitLeft = 641
          ExplicitWidth = 31
          inherited btnIncluirDetail: TSpeedButton
            Width = 31
            Height = 31
            OnClick = btnIncluirDetailClick
            ExplicitLeft = 2
            ExplicitTop = 2
            ExplicitWidth = 28
            ExplicitHeight = 31
          end
          inherited brnExcluirDetail: TSpeedButton
            Top = 31
            Width = 31
            Height = 31
            OnClick = brnExcluirDetailClick
            ExplicitTop = 31
            ExplicitWidth = 31
            ExplicitHeight = 31
          end
        end
      end
      object edtNome: TEdit
        Left = 20
        Top = 40
        Width = 400
        Height = 23
        Hint = 'Informe o nome do produtor.'
        MaxLength = 100
        TabOrder = 1
      end
      object edtCpfCnpj: TEdit
        Left = 20
        Top = 100
        Width = 200
        Height = 23
        Hint = 'Informe um CPF/CNPJ v'#225'lido.'
        MaxLength = 18
        TabOrder = 2
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
