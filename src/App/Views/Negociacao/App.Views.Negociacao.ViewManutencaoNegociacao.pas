unit App.Views.Negociacao.ViewManutencaoNegociacao;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  System.Generics.Collections, System.TypInfo, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Grids, Data.DB,
  Datasnap.DBClient,
  Core.Entities.Negociacao,
  Core.Entities.NegociacaoItem,
  Core.Entities.Produtor,
  Core.Entities.Distribuidor,
  Core.Entities.Produto,
  Core.Enums.TipoStatus,
  Infra.IoC.Container,
  Infra.CrossCutting.Validation.MessageValidation;

type
  TViewManutencaoNegociacao = class(TForm)
    pnlTitulo: TPanel;
    lblTitulo: TLabel;
    grpBusca: TGroupBox;
    lblCodigoBusca: TLabel;
    edtCodigoBusca: TEdit;
    btnBuscar: TButton;
    grpDados: TGroupBox;
    lblProdutor: TLabel;
    cbxProdutor: TComboBox;
    lblDistribuidor: TLabel;
    cbxDistribuidor: TComboBox;
    grpItens: TGroupBox;
    lblProduto: TLabel;
    cbxProduto: TComboBox;
    lblQuantidade: TLabel;
    edtQuantidade: TEdit;
    lblPrecoUnitario: TLabel;
    edtPrecoUnitario: TEdit;
    btnAdicionarItem: TButton;
    btnRemoverItem: TButton;
    grdItens: TStringGrid;
    grpTotal: TGroupBox;
    lblValorTotal: TLabel;
    edtValorTotal: TEdit;
    lblStatus: TLabel;
    edtStatus: TEdit;
    btnSalvar: TButton;
    btnCancelar: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnAdicionarItemClick(Sender: TObject);
    procedure btnRemoverItemClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnBuscarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure cbxProdutorChange(Sender: TObject);
    procedure cbxDistribuidorChange(Sender: TObject);
    procedure cbxProdutoChange(Sender: TObject);
  private
    FItens: TList<TNegociacaoItem>;
    FIdNegociacao: Integer;
    FStatusAtual: TTipoStatus;
    FCDSProdutos: TclientDataSet;
    procedure CalcularValorTotal;
    procedure CarregarProdutores;
    procedure CarregarDistribuidores;
    procedure CarregarProdutos;
    procedure AtualizarGrid;
    procedure CarregarNegociacaoParaEdicao;
    procedure SetarIndexComboPorId(ACombo: TComboBox; AId: Integer);
    function ObterNomeProduto(AIdProduto: Integer): string;
    function StringParaMoeda(const ATexto: string): Currency;
  public
    property IdNegociacao: Integer read FIdNegociacao write FIdNegociacao;
  end;

var
  ViewManutencaoNegociacao: TViewManutencaoNegociacao;

implementation

{$R *.dfm}

function CleanStringNum(const ATexto: string): string;
var
  I: Integer;
  LChar: Char;
begin
  Result := '';
  for I := 1 to Length(ATexto) do
  begin
    LChar := ATexto[I];
    if CharInSet(LChar, ['0'..'9', ',', '.']) then
      Result := Result + LChar;
  end;

  if FormatSettings.DecimalSeparator = ',' then
    Result := StringReplace(Result, '.', ',', [rfReplaceAll]);
end;

procedure TViewManutencaoNegociacao.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TViewManutencaoNegociacao.FormCreate(Sender: TObject);
begin
  FItens := TList<TNegociacaoItem>.Create;
  FIdNegociacao := 0;
  FStatusAtual := tsPendente;

  edtStatus.ReadOnly := True;
  edtValorTotal.ReadOnly := True;

  grdItens.ColCount := 4;
  grdItens.FixedRows := 1;
  grdItens.Cells[0, 0] := 'Produto';
  grdItens.Cells[1, 0] := 'Quantidade';
  grdItens.Cells[2, 0] := 'Preço Unit.';
  grdItens.Cells[3, 0] := 'Valor Total';

  FCDSProdutos := TClientDataSet.Create(Self);
  FCDSProdutos.FieldDefs.Add('ID', ftInteger);
  FCDSProdutos.FieldDefs.Add('PRECO_VENDA', ftCurrency);
  FCDSProdutos.CreateDataSet;

  CarregarProdutores;

  cbxDistribuidor.Items.Clear;
  cbxDistribuidor.Items.Add('Selecione...');
  cbxDistribuidor.ItemIndex := 0;

  cbxProduto.Items.Clear;
  cbxProduto.Items.Add('Selecione...');
  cbxProduto.ItemIndex := 0;
end;

procedure TViewManutencaoNegociacao.FormShow(Sender: TObject);
begin
  if FIdNegociacao > 0 then
  begin
    lblTitulo.Caption := 'Alteração de Negociação';
    CarregarNegociacaoParaEdicao;
  end
  else
  begin
    lblTitulo.Caption := 'Nova Negociação';
    edtStatus.Text := 'Pendente';
    FStatusAtual := tsPendente;
    AtualizarGrid;
    CalcularValorTotal;
  end;
end;

procedure TViewManutencaoNegociacao.FormDestroy(Sender: TObject);
var
  LItem: TNegociacaoItem;
begin
  if Assigned(FCDSProdutos) then
  begin
    FCDSProdutos.Close;
    FreeAndNil(FCDSProdutos);
  end;

  if Assigned(FItens) then
  begin
    for LItem in FItens do
      if Assigned(LItem) then LItem.Free;
    FItens.Free;
  end;
end;

procedure TViewManutencaoNegociacao.CarregarNegociacaoParaEdicao;
var
  LNegociacao: TNegociacao;
  LItem: TNegociacaoItem;
  LItemClone: TNegociacaoItem;
begin
  LNegociacao := TIoCContainer.NegociacaoService.ObterPorId(FIdNegociacao);
  if not Assigned(LNegociacao) then
  begin
    TMessageValidation.Aviso('Negociação não encontrada.');
    FIdNegociacao := 0;
    Exit;
  end;

  try
    SetarIndexComboPorId(cbxProdutor, LNegociacao.IdProdutor);
    CarregarDistribuidores;
    SetarIndexComboPorId(cbxDistribuidor, LNegociacao.IdDistribuidor);
    CarregarProdutos;
    FStatusAtual := LNegociacao.Status;
    edtStatus.Text := GetEnumName(TypeInfo(TTipoStatus), Integer(FStatusAtual));

    if Assigned(FItens) then
    begin
      for LItem in FItens do
        if Assigned(LItem) then LItem.Free;
      FItens.Clear;
    end;

    if Assigned(LNegociacao.Itens) then
    begin
      for LItem in LNegociacao.Itens do
      begin
        LItemClone := TNegociacaoItem.Create;
        LItemClone.Id := LItem.Id;
        LItemClone.IdProduto := LItem.IdProduto;
        LItemClone.Quantidade := LItem.Quantidade;
        LItemClone.PrecoUnitario := LItem.PrecoUnitario;
        LItemClone.ValorTotal := LItem.ValorTotal;
        FItens.Add(LItemClone);
      end;
    end;

    AtualizarGrid;
    CalcularValorTotal;
  finally
    if Assigned(LNegociacao) then
      LNegociacao.Free;
  end;
end;


procedure TViewManutencaoNegociacao.SetarIndexComboPorId(ACombo: TComboBox; AId: Integer);
var
  I: Integer;
begin
  for I := 0 to ACombo.Items.Count - 1 do
  begin
    if Integer(ACombo.Items.Objects[I]) = AId then
    begin
      ACombo.ItemIndex := I;
      Break;
    end;
  end;
end;

function TViewManutencaoNegociacao.ObterNomeProduto(AIdProduto: Integer): string;
var
  I: Integer;
begin
  Result := 'Produto (' + IntToStr(AIdProduto) + ')';
  for I := 0 to cbxProduto.Items.Count - 1 do
  begin
    if Integer(cbxProduto.Items.Objects[I]) = AIdProduto then
    begin
      Result := cbxProduto.Items[I];
      Break;
    end;
  end;
end;

procedure TViewManutencaoNegociacao.AtualizarGrid;
var
  I: Integer;
begin
  if FItens.Count = 0 then
  begin
    grdItens.RowCount := 2;
    for I := 0 to 3 do grdItens.Cells[I, 1] := '';
    Exit;
  end;

  grdItens.RowCount := FItens.Count + 1;
  for I := 0 to FItens.Count - 1 do
  begin
    grdItens.Cells[0, I + 1] := ObterNomeProduto(FItens[I].IdProduto);
    grdItens.Cells[1, I + 1] := FormatFloat('0.00', FItens[I].Quantidade);
    grdItens.Cells[2, I + 1] := FormatFloat('R$ ,0.00', FItens[I].PrecoUnitario);
    grdItens.Cells[3, I + 1] := FormatFloat('R$ ,0.00', FItens[I].ValorTotal);
  end;
end;

procedure TViewManutencaoNegociacao.CalcularValorTotal;
var
  LItem: TNegociacaoItem;
  LTotal: Currency;
begin
  LTotal := 0;
  for LItem in FItens do
    LTotal := LTotal + LItem.ValorTotal;

  edtValorTotal.Text := FormatFloat('R$ ,0.00', LTotal);
end;

procedure TViewManutencaoNegociacao.btnAdicionarItemClick(Sender: TObject);
var
  LItem: TNegociacaoItem;
begin
  if (cbxProduto.ItemIndex <= 0) or (edtQuantidade.Text = '') or (edtPrecoUnitario.Text = '') then
  begin
    TMessageValidation.Aviso('Selecione um produto válido e preencha todos os campos do item');
    Exit;
  end;

  LItem := TNegociacaoItem.Create;
  try
    LItem.IdProduto := Integer(cbxProduto.Items.Objects[cbxProduto.ItemIndex]);
    LItem.Quantidade := StrToFloatDef(CleanStringNum(edtQuantidade.Text), 0);
    LItem.PrecoUnitario := StringParaMoeda(edtPrecoUnitario.Text);
    LItem.ValorTotal := LItem.Quantidade * LItem.PrecoUnitario;

    FItens.Add(LItem);

    AtualizarGrid;
    CalcularValorTotal;

    cbxProduto.ItemIndex := 0;
    edtQuantidade.Text := '';
    edtPrecoUnitario.Text := '';
  except
    on E: Exception do
    begin
      LItem.Free;
      TMessageValidation.Erro('Verifique os valores numéricos informados: ' + E.Message);
    end;
  end;
end;

procedure TViewManutencaoNegociacao.btnRemoverItemClick(Sender: TObject);
var
  LIndex: Integer;
begin
  LIndex := grdItens.Row - 1;

  if (LIndex >= 0) and (LIndex < FItens.Count) then
  begin
    FItens[LIndex].Free;
    FItens.Delete(LIndex);

    AtualizarGrid;
    CalcularValorTotal;
  end
  else
    TMessageValidation.Aviso('Selecione uma linha válida na tabela para remover');
end;

procedure TViewManutencaoNegociacao.btnSalvarClick(Sender: TObject);
var
  LNegociacao: TNegociacao;
  LItem: TNegociacaoItem;
  LItemClone: TNegociacaoItem;
  LSucesso: Boolean;
begin
  if (cbxProdutor.ItemIndex <= 0) or (cbxDistribuidor.ItemIndex <= 0) then
  begin
    TMessageValidation.Aviso('Selecione o produtor e o distribuidor');
    Exit;
  end;
  if FItens.Count = 0 then
  begin
    TMessageValidation.Aviso('Adicione pelo menos um item negociação');
    Exit;
  end;
  try
    LNegociacao := TNegociacao.Create;
    try
      LNegociacao.Id := FIdNegociacao;
      LNegociacao.IdProdutor := Integer(cbxProdutor.Items.Objects[cbxProdutor.ItemIndex]);
      LNegociacao.IdDistribuidor := Integer(cbxDistribuidor.Items.Objects[cbxDistribuidor.ItemIndex]);
      LNegociacao.DataCadastro := Now;
      LNegociacao.Status := FStatusAtual;
      LNegociacao.ValorTotal := 0;
      for LItem in FItens do
      begin
        LItemClone := TNegociacaoItem.Create;
        LItemClone.IdProduto := LItem.IdProduto;
        LItemClone.Quantidade := LItem.Quantidade;
        LItemClone.PrecoUnitario := LItem.PrecoUnitario;
        LItemClone.ValorTotal := LItem.ValorTotal;
        LNegociacao.AdicionarItem(LItemClone);
      end;

      if FIdNegociacao = 0 then
        LSucesso := TIoCContainer.NegociacaoService.Salvar(LNegociacao)
      else
        LSucesso := TIoCContainer.NegociacaoService.Atualizar(LNegociacao);

      if LSucesso then
      begin
        if FIdNegociacao = 0 then
          TMessageValidation.Aviso('Negociação salva com sucesso!')
        else
          TMessageValidation.Aviso('Negociação alterada com sucesso!');

        if Assigned(FItens) then
        begin
          for LItem in FItens do
            if Assigned(LItem) then LItem.Free;
          FItens.Clear;
        end;

        edtCodigoBusca.Clear;
        FIdNegociacao := 0;
        lblTitulo.Caption := 'Nova Negociação';
        edtStatus.Text := 'Pendente';
        FStatusAtual := tsPendente;
        cbxProdutor.ItemIndex := 0;
        cbxDistribuidor.Items.Clear;
        cbxDistribuidor.Items.Add('Selecione...');
        cbxDistribuidor.ItemIndex := 0;
        cbxProduto.Items.Clear;
        cbxProduto.Items.Add('Selecione...');
        cbxProduto.ItemIndex := 0;
        edtQuantidade.Clear;
        edtPrecoUnitario.Clear;
        AtualizarGrid;
        CalcularValorTotal;
      end;
    finally
       if Assigned(LNegociacao) then
        LNegociacao.Free;
    end;
  except
    on E: Exception do
      TMessageValidation.Erro('Erro ao salvar negociação: ' + E.Message);
  end;
end;


procedure TViewManutencaoNegociacao.btnCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TViewManutencaoNegociacao.btnBuscarClick(Sender: TObject);
begin
  if Trim(edtCodigoBusca.Text) = '' then
  begin
    TMessageValidation.Aviso('Informe o ID da negociação para buscar.');
    if edtCodigoBusca.CanFocus then edtCodigoBusca.SetFocus;
    Exit;
  end;

  try
    FIdNegociacao := StrToInt(edtCodigoBusca.Text);
    CarregarNegociacaoParaEdicao;
    if FIdNegociacao > 0 then
      lblTitulo.Caption := 'Alteração de Negociação';
  except
    on E: Exception do
      TMessageValidation.Erro('Erro ao buscar negociação: ' + E.Message);
  end;
end;

procedure TViewManutencaoNegociacao.CarregarProdutores;
var
  LProdutores: TList<TProdutor>;
  LProdutor: TProdutor;
begin
  try
    LProdutores := TIoCContainer.ProdutorService.ObterTodos;
    try
      cbxProdutor.Items.Clear;
      cbxProdutor.Items.Add('Selecione...');

      if not Assigned(LProdutores) then
        Exit;

      for LProdutor in LProdutores do
        cbxProdutor.Items.AddObject(LProdutor.Nome, TObject(LProdutor.Id));
      cbxProdutor.ItemIndex := 0;
    finally
      if Assigned(LProdutores) then
      begin
        for LProdutor in LProdutores do
          if Assigned(LProdutor) then LProdutor.Free;
        LProdutores.Free;
      end;
    end;
  except
    on E: Exception do TMessageValidation.Erro('Erro ao carregar produtores: ' + E.Message);
  end;
end;

procedure TViewManutencaoNegociacao.CarregarDistribuidores;
var
  LDistribuidores: TList<TDistribuidor>;
  LDistribuidor: TDistribuidor;
  LIDProdutor: Integer;
begin
  try
    if (cbxProdutor.ItemIndex <= 0) or (cbxProdutor.ItemIndex >= cbxProdutor.Items.Count) then
    begin
      cbxDistribuidor.Items.Clear;
      cbxDistribuidor.Items.Add('Selecione...');
      cbxDistribuidor.ItemIndex := 0;
      Exit;
    end;
    LIDProdutor := Integer(cbxProdutor.Items.Objects[cbxProdutor.ItemIndex]);
    LDistribuidores := TIoCContainer.DistribuidorService.ObterTodosPorProdutor(LIDProdutor);
    try
      cbxDistribuidor.Items.Clear;
      cbxDistribuidor.Items.Add('Selecione...');
      for LDistribuidor in LDistribuidores do
        cbxDistribuidor.Items.AddObject(LDistribuidor.Nome, TObject(LDistribuidor.Id));
      cbxDistribuidor.ItemIndex := 0;
    finally
      if Assigned(LDistribuidores) then
      begin
        for LDistribuidor in LDistribuidores do
          if Assigned(LDistribuidor) then LDistribuidor.Free;
        LDistribuidores.Free;
      end;
    end;
  except
    on E: Exception do TMessageValidation.Erro('Erro ao carregar distribuidores: ' + E.Message);
  end;
end;

procedure TViewManutencaoNegociacao.CarregarProdutos;
var
  LProdutos: TList<TProduto>;
  LProduto: TProduto;
  LIdDistribuidor: Integer;
begin
  try
    edtPrecoUnitario.Clear;
    if (cbxDistribuidor.ItemIndex <= 0) or (cbxDistribuidor.ItemIndex >= cbxDistribuidor.Items.Count) then
    begin
      cbxProduto.Items.Clear;
      cbxProduto.Items.Add('Selecione...');
      cbxProduto.ItemIndex := 0;
      Exit;
    end;
    LIdDistribuidor := Integer(cbxDistribuidor.Items.Objects[cbxDistribuidor.ItemIndex]);
    LProdutos := TIoCContainer.ProdutoService.ObterTodosPorDistribuidor(LIdDistribuidor);
    try
      cbxProduto.Items.Clear;
      cbxProduto.Items.Add('Selecione...');
      FCDSProdutos.EmptyDataSet;
      FCDSProdutos.DisableControls;
      try
        for LProduto in LProdutos do
        begin
          cbxProduto.Items.AddObject(LProduto.Nome, TObject(LProduto.Id));
          FCDSProdutos.Append;
          FCDSProdutos.FieldByName('ID').AsInteger := LProduto.Id;
          FCDSProdutos.FieldByName('PRECO_VENDA').AsCurrency := LProduto.PrecoVenda;
          FCDSProdutos.Post;
        end;
      finally
        FCDSProdutos.EnableControls;
      end;
      cbxProduto.ItemIndex := 0;
    finally
      if Assigned(LProdutos) then
      begin
        for LProduto in LProdutos do
          if Assigned(LProduto) then LProduto.Free;
        LProdutos.Free;
      end;
    end;
  except
    on E: Exception do TMessageValidation.Erro('Erro ao carregar produtos: ' + E.Message);
  end;
end;

procedure TViewManutencaoNegociacao.cbxDistribuidorChange(Sender: TObject);
begin
  CarregarProdutos;
end;

procedure TViewManutencaoNegociacao.cbxProdutoChange(Sender: TObject);
var
  LIdProduto: Integer;
begin
  if cbxProduto.ItemIndex <= 0 then
  begin
    edtPrecoUnitario.Clear;
    Exit;
  end;

  LIdProduto := Integer(cbxProduto.Items.Objects[cbxProduto.ItemIndex]);

  if FCDSProdutos.Locate('ID', LIdProduto, []) then
  begin
    edtPrecoUnitario.Text := FormatFloat('R$ ,0.00', FCDSProdutos.FieldByName('PRECO_VENDA').AsCurrency);
  end
  else
    edtPrecoUnitario.Clear;
end;

procedure TViewManutencaoNegociacao.cbxProdutorChange(Sender: TObject);
begin
  CarregarDistribuidores;
end;

function TViewManutencaoNegociacao.StringParaMoeda(const ATexto: string): Currency;
var
  LTextoLimpo: string;
  I: Integer;
  LChar: Char;
  LSettings: TFormatSettings;
begin
  LTextoLimpo := '';
  for I := 1 to Length(ATexto) do
  begin
    LChar := ATexto[I];
    if CharInSet(LChar, ['0'..'9', '.', ',']) then
      LTextoLimpo := LTextoLimpo + LChar;
  end;

  LSettings := TFormatSettings.Create;
  if LSettings.DecimalSeparator = ',' then
    LTextoLimpo := StringReplace(LTextoLimpo, '.', '', [rfReplaceAll])
  else
  begin
    LTextoLimpo := StringReplace(LTextoLimpo, ',', '', [rfReplaceAll]);
    LTextoLimpo := StringReplace(LTextoLimpo, '.', ',', [rfReplaceAll]);
  end;

  if (LTextoLimpo = '') or (LTextoLimpo = ',') then Exit(0);
  try
    Result := StrToCurr(LTextoLimpo);
  except
    Result := 0;
  end;
end;

end.

