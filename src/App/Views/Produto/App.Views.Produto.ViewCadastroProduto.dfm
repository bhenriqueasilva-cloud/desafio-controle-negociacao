inherited ViewCadastroProduto: TViewCadastroProduto
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
            Title.Caption = 'Nome'
            Width = 366
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'PRECO_VENDA'
            Title.Caption = 'Pre'#231'o Venda Sugerido'
            Width = 127
            Visible = True
          end>
      end
      inherited pnlFiltro: TPanel
        StyleElements = [seFont, seClient, seBorder]
        inherited edtPesquisa: TEdit
          StyleElements = [seFont, seClient, seBorder]
        end
        inherited btnPesquisar: TButton
          Left = 366
          Top = 9
          ExplicitLeft = 366
          ExplicitTop = 9
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
      object lblPrecoVenda: TLabel
        Left = 24
        Top = 72
        Width = 120
        Height = 15
        Caption = 'Pre'#231'o Venda Sugerido*'
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
      object edtPrecoVenda: TEdit
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
    Color = 12615808
    StyleElements = [seFont, seClient, seBorder]
    inherited lblTitulo: TLabel
      StyleElements = [seFont, seClient, seBorder]
    end
  end
end
