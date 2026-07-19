unit App.Views.Distribuidor.ViewCadastroDistribuidorDetail;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, App.Views.Base.ViewBaseCadastroDetail,
  Vcl.StdCtrls, Vcl.ExtCtrls, FireDAC.Comp.Client, System.Generics.Collections,
  Data.DB, Infra.IoC.Container, Core.Entities.Distribuidor, Core.Entities.Produto, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet, Vcl.Grids,
  Vcl.DBGrids, Vcl.ComCtrls, Vcl.Buttons;

type
  TViewCadastroDistribuidorDetail = class(TViewBaseCadastroDetail)
    lblNome: TLabel;
    lblCnpj: TLabel;
    edtNome: TEdit;
    edtCnpj: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure btnIncluirDetailClick(Sender: TObject);
    procedure brnExcluirDetailClick(Sender: TObject);
  private
    FDataSourceProdutos: TDataSource;
    FMemDetailProdutos: TFDMemTable;
    FMemDetailProdutosExcluidos: TFDMemTable;
    procedure FMemDetailBeforePost(DataSet: TDataSet);
    procedure FieldIdProdutoChange(Sender: TField);
    procedure LimparCamposInterface;
    procedure CarregarDadosObjetoParaInterface;
    procedure CarregarTabelaProdutos;
    procedure CarregarTabelaDistribuidorProdutos(AIdDistribuidor: Integer);
  protected
    procedure InicializarComponentes; override;
    procedure ExecutarPesquisa(const ATexto: string); override;
    procedure DoNovo; override;
    procedure DoEditar; override;
    procedure DoDeletar; override;
    procedure DoSalvar; override;
    procedure DoCancelar; override;
    function IsDatasetEditando: Boolean; override;
  public
  end;

var
  ViewCadastroDistribuidorDetail: TViewCadastroDistribuidorDetail;

implementation

{$R *.dfm}

uses
  Infra.CrossCutting.Validation.CNPJValidator,
  Infra.CrossCutting.Validation.MessageValidation;

procedure TViewCadastroDistribuidorDetail.InicializarComponentes;
var
  LLookupField: TStringField;
  LFieldId: TIntegerField;
  LFieldIdDist: TIntegerField;
  LFieldIdProd: TIntegerField;
  LFieldValor: TFloatField;
begin
  lblTitulo.Caption := 'Cadastro de Distribuidores de Insumos';

  FDataSource.DataSet := TFDMemTable.Create(Self);
  TFDMemTable(FDataSource.DataSet).FieldDefs.Add('ID', ftInteger);
  TFDMemTable(FDataSource.DataSet).FieldDefs.Add('NOME', ftString, 100);
  TFDMemTable(FDataSource.DataSet).FieldDefs.Add('CNPJ', ftString, 18);
  TFDMemTable(FDataSource.DataSet).CreateDataSet;

  FMemDetailProdutosExcluidos := TFDMemTable.Create(Self);
  FMemDetailProdutosExcluidos.FieldDefs.Add('ID_DISTRIBUIDOR', ftInteger);
  FMemDetailProdutosExcluidos.FieldDefs.Add('ID_PRODUTO', ftInteger);
  FMemDetailProdutosExcluidos.CreateDataSet;

  LFieldId := TIntegerField.Create(Self);
  LFieldId.FieldName := 'ID';
  LFieldId.DataSet := FMemDetail;

  LFieldIdDist := TIntegerField.Create(Self);
  LFieldIdDist.FieldName := 'ID_DISTRIBUIDOR';
  LFieldIdDist.DataSet := FMemDetail;

  LFieldIdProd := TIntegerField.Create(Self);
  LFieldIdProd.FieldName := 'ID_PRODUTO';
  LFieldIdProd.DataSet := FMemDetail;
  LFieldIdProd.OnChange := FieldIdProdutoChange;

  LFieldValor := TFloatField.Create(Self);
  LFieldValor.FieldName := 'VALOR_PRODUTO';
  LFieldValor.DataSet := FMemDetail;
  LFieldValor.DisplayLabel := 'Preço Praticado';
  LFieldValor.DisplayFormat := 'R$ ,0.00';
  LFieldValor.ReadOnly := True;

  FMemDetailProdutos.FieldDefs.Add('ID', ftInteger);
  FMemDetailProdutos.FieldDefs.Add('NOME', ftString, 100);
  FMemDetailProdutos.FieldDefs.Add('PRECO_VENDA', ftCurrency);
  FMemDetailProdutos.CreateDataSet;
  FDataSourceProdutos.DataSet := FMemDetailProdutos;

  LLookupField := TStringField.Create(Self);
  LLookupField.FieldName := 'NOME_PRODUTO';
  LLookupField.DataSet := FMemDetail;
  LLookupField.FieldKind := fkLookup;
  LLookupField.KeyFields := 'ID_PRODUTO';
  LLookupField.LookupDataSet := FMemDetailProdutos;
  LLookupField.LookupKeyFields := 'ID';
  LLookupField.LookupResultField := 'NOME';
  LLookupField.Size := 100;

  FMemDetail.BeforePost := FMemDetailBeforePost;
  FMemDetail.CreateDataSet;

  ExecutarPesquisa('');
  CarregarTabelaProdutos;
end;

procedure TViewCadastroDistribuidorDetail.ExecutarPesquisa(const ATexto: string);
var
  LLista: TList<TDistribuidor>;
  LDistribuidor: TDistribuidor;
  LMemTable: TFDMemTable;
begin
  LMemTable := TFDMemTable(FDataSource.DataSet);
  LMemTable.Close;
  LMemTable.Open;

  if ATexto = '' then
    LLista := TIoCContainer.DistribuidorService.ObterTodos
  else
    LLista := TIoCContainer.DistribuidorService.ObterPorNome(ATexto);

  try
    LMemTable.DisableControls;
    for LDistribuidor in LLista do
    begin
      LMemTable.Append;
      LMemTable.FieldByName('ID').AsInteger := LDistribuidor.Id;
      LMemTable.FieldByName('NOME').AsString := LDistribuidor.Nome;
      LMemTable.FieldByName('CNPJ').AsString := LDistribuidor.Cnpj;
      LMemTable.Post;
    end;
  finally
    LMemTable.EnableControls;

    if Assigned(LLista) then
    begin
      for LDistribuidor in LLista do
        LDistribuidor.Free;
      LLista.Free;
    end;
  end;
end;

procedure TViewCadastroDistribuidorDetail.CarregarTabelaDistribuidorProdutos(AIdDistribuidor: Integer);
var
  LListaProdutos: TList<TProduto>;
  LProduto: TProduto;
  LId: Integer;
  LValorProduto: Currency;
begin
  FMemDetail.Close;
  FMemDetail.Open;

  if AIdDistribuidor = 0 then
    Exit;

  LListaProdutos := TIoCContainer.ProdutoService.ObterTodos;
  try
    FMemDetail.DisableControls;
    for LProduto in LListaProdutos do
    begin
      LId := TIoCContainer.DistribuidorService.ObterDistribuidorProdutos(AIdDistribuidor, LProduto.Id, LValorProduto);
      if LId > 0 then
      begin
        FMemDetail.Append;
        FMemDetail.FieldByName('ID').AsInteger := LId;
        FMemDetail.FieldByName('ID_DISTRIBUIDOR').AsInteger := AIdDistribuidor;
        FMemDetail.FieldByName('ID_PRODUTO').AsInteger := LProduto.Id;
        FMemDetail.FieldByName('VALOR_PRODUTO').ReadOnly := False;
        FMemDetail.FieldByName('VALOR_PRODUTO').AsCurrency := LValorProduto;
        FMemDetail.FieldByName('VALOR_PRODUTO').ReadOnly := True;
        FMemDetail.Post;
      end;
    end;
  finally
    FMemDetail.EnableControls;

    if Assigned(LListaProdutos) then
    begin
      for LProduto in LListaProdutos do
        LProduto.Free;
      LListaProdutos.Free;
    end;
  end;
end;

procedure TViewCadastroDistribuidorDetail.CarregarTabelaProdutos;
var
  LLista: TList<TProduto>;
  LItem: TProduto;
begin
  FMemDetailProdutos.Close;
  FMemDetailProdutos.Open;

  LLista := TIoCContainer.ProdutoService.ObterTodos;
  try
    FMemDetailProdutos.DisableControls;
    for LItem in LLista do
    begin
      FMemDetailProdutos.Append;
      FMemDetailProdutos.FieldByName('ID').AsInteger := LItem.Id;
      FMemDetailProdutos.FieldByName('NOME').AsString := LItem.Nome;
      FMemDetailProdutos.FieldByName('PRECO_VENDA').AsCurrency := LItem.PrecoVenda;
      FMemDetailProdutos.Post;
    end;
  finally
    FMemDetailProdutos.EnableControls;

    if Assigned(LLista) then
    begin
      for LItem in LLista do
        LItem.Free;
      LLista.Free;
    end;
  end;
end;
procedure TViewCadastroDistribuidorDetail.FormCreate(Sender: TObject);
begin

  FMemDetailProdutos := TFDMemTable.Create(Self);
  FDataSourceProdutos := TDataSource.Create(Self);
  inherited;
end;

procedure TViewCadastroDistribuidorDetail.FMemDetailBeforePost(DataSet: TDataSet);
var
  LClone: TFDMemTable;
begin
  if DataSet.FieldByName('ID_PRODUTO').AsInteger = 0 then
    Exit;

  LClone := TFDMemTable.Create(nil);
  try
    LClone.CloneCursor(TFDMemTable(DataSet), True, True);
    LClone.First;
    while not LClone.Eof do
    begin
      if (LClone.RecNo <> DataSet.RecNo) and 
         (LClone.FieldByName('ID_PRODUTO').AsInteger = DataSet.FieldByName('ID_PRODUTO').AsInteger) then
      begin
        TMessageValidation.Aviso('O mesmo produto não pode ser adicionado mais de uma vez na lista.');
        Abort;
      end;
      LClone.Next;
    end;
  finally
    LClone.Free;
  end;
end;

procedure TViewCadastroDistribuidorDetail.FieldIdProdutoChange(Sender: TField);
begin
  if Sender.IsNull then
    Exit;

  if FMemDetailProdutos.Locate('ID', Sender.AsInteger, []) then
  begin
    FMemDetail.FieldByName('VALOR_PRODUTO').ReadOnly := False;
    FMemDetail.FieldByName('VALOR_PRODUTO').AsCurrency :=
      FMemDetailProdutos.FieldByName('PRECO_VENDA').AsCurrency;
    FMemDetail.FieldByName('VALOR_PRODUTO').ReadOnly := True;
  end;
end;

procedure TViewCadastroDistribuidorDetail.LimparCamposInterface;
begin
  edtNome.Clear;
  edtCnpj.Clear;
end;

procedure TViewCadastroDistribuidorDetail.btnIncluirDetailClick(
  Sender: TObject);
begin
  if not (FDataSource.DataSet.State in [dsInsert, dsEdit]) then
    Exit;

  if FMemDetail.State in [dsInsert, dsEdit] then
    FMemDetail.Post;

  FMemDetail.IndexFieldNames := '';
  FMemDetail.Last;

  FMemDetail.Append;
  FMemDetail.FieldByName('ID_DISTRIBUIDOR').AsInteger := FDataSource.DataSet.FieldByName('ID').AsInteger;
  FMemDetail.FieldByName('ID_PRODUTO').Clear;

  if gridDetail.CanFocus then
  begin
    gridDetail.SetFocus;
    gridDetail.SelectedIndex := 0;
    gridDetail.EditorMode := True;
  end;
end;

procedure TViewCadastroDistribuidorDetail.brnExcluirDetailClick(
  Sender: TObject);
begin
  if not (FDataSource.DataSet.State in [dsInsert, dsEdit]) then
    Exit;

  if FMemDetail.IsEmpty then
    Exit;

  if TMessageValidation.Confirmar('Deseja remover este produto do distribuidor?') then
  begin
    if FMemDetail.FieldByName('ID').AsInteger > 0 then
    begin
      FMemDetailProdutosExcluidos.Append;
      FMemDetailProdutosExcluidos.FieldByName('ID_DISTRIBUIDOR').AsInteger := FMemDetail.FieldByName('ID_DISTRIBUIDOR').AsInteger;
      FMemDetailProdutosExcluidos.FieldByName('ID_PRODUTO').AsInteger := FMemDetail.FieldByName('ID_PRODUTO').AsInteger;
      FMemDetailProdutosExcluidos.Post;
    end;

    FMemDetail.Delete;
  end;
end;

procedure TViewCadastroDistribuidorDetail.CarregarDadosObjetoParaInterface;
var
  LMemTable: TFDMemTable;
begin
  LMemTable := TFDMemTable(FDataSource.DataSet);
  edtNome.Text := LMemTable.FieldByName('NOME').AsString;
  edtCnpj.Text := TCNPJValidator.FormatarCNPJ(LMemTable.FieldByName('CNPJ').AsString);

  CarregarTabelaDistribuidorProdutos(FDataSource.DataSet.FieldByName('ID').AsInteger);
end;

procedure TViewCadastroDistribuidorDetail.DoNovo;
var
  LMemTable: TFDMemTable;
begin
  LMemTable := TFDMemTable(FDataSource.DataSet);
  LMemTable.Append;

  FMemDetail.Close;
  FMemDetail.Open;

  FMemDetailProdutosExcluidos.Close;
  FMemDetailProdutosExcluidos.Open;

  LimparCamposInterface;
  if edtNome.CanFocus then
    edtNome.SetFocus;
end;

procedure TViewCadastroDistribuidorDetail.DoEditar;
var
  LMemTable: TFDMemTable;
begin
  LMemTable := TFDMemTable(FDataSource.DataSet);
  LMemTable.Edit;

  FMemDetailProdutosExcluidos.Close;
  FMemDetailProdutosExcluidos.Open;

  CarregarDadosObjetoParaInterface;
  CarregarTabelaDistribuidorProdutos(LMemTable.FieldByName('ID').AsInteger);
  if edtNome.CanFocus then
    edtNome.SetFocus;
end;

procedure TViewCadastroDistribuidorDetail.DoCancelar;
var
  LMemTable: TFDMemTable;
begin
  LMemTable := TFDMemTable(FDataSource.DataSet);
  LMemTable.Cancel;

  FMemDetail.CancelUpdates;
  FMemDetail.Close;

  FMemDetailProdutosExcluidos.CancelUpdates;
  FMemDetailProdutosExcluidos.Close;

  LimparCamposInterface;
end;

procedure TViewCadastroDistribuidorDetail.DoDeletar;
var
  LMemTable: TFDMemTable;
  LIdDistribuidor: Integer;
begin
  LMemTable := TFDMemTable(FDataSource.DataSet);
  LIdDistribuidor := LMemTable.FieldByName('ID').AsInteger;

  if TIoCContainer.DistribuidorService.PossuiProdutos(LIdDistribuidor) then
  begin
    TMessageValidation.Aviso('Não é possível excluir o distribuidor pois existem produtos cadastrados para este distribuidor.');
    Exit;
  end;

  TIoCContainer.DistribuidorService.Excluir(LIdDistribuidor);
  LMemTable.Delete;
end;

procedure TViewCadastroDistribuidorDetail.DoSalvar;
var
  LDistribuidor: TDistribuidor;
  LMemTable: TFDMemTable;
begin
  LMemTable := TFDMemTable(FDataSource.DataSet);

  if FMemDetail.State in [dsInsert, dsEdit] then
    FMemDetail.Post;

  LDistribuidor := TDistribuidor.Create;
  try
    LDistribuidor.Id := LMemTable.FieldByName('ID').AsInteger;
    LDistribuidor.Nome := edtNome.Text;
    LDistribuidor.Cnpj := edtCnpj.Text;

    if LDistribuidor.Id = 0 then
    begin
      TIoCContainer.DistribuidorService.Salvar(LDistribuidor);
      LMemTable.FieldByName('ID').AsInteger := LDistribuidor.Id;
    end
    else
      TIoCContainer.DistribuidorService.Atualizar(LDistribuidor);

    FMemDetail.First;
    while not FMemDetail.Eof do
    begin
      if FMemDetail.FieldByName('ID_PRODUTO').AsInteger > 0 then
      begin
        if FMemDetail.FieldByName('ID').AsInteger > 0 then
        begin
          TIoCContainer.DistribuidorService.AtualizarDistribuidorProdutos(
            FMemDetail.FieldByName('ID').AsInteger,
            LDistribuidor.Id,
            FMemDetail.FieldByName('ID_PRODUTO').AsInteger,
            FMemDetail.FieldByName('VALOR_PRODUTO').AsCurrency
          );
        end
        else
        begin
          TIoCContainer.DistribuidorService.SalvarDistribuidorProdutos(
            LDistribuidor.Id,
            FMemDetail.FieldByName('ID_PRODUTO').AsInteger,
            FMemDetail.FieldByName('VALOR_PRODUTO').AsCurrency
          );
        end;
      end;
      FMemDetail.Next;
    end;

    FMemDetailProdutosExcluidos.First;
    while not FMemDetailProdutosExcluidos.Eof do
    begin
      if (FMemDetailProdutosExcluidos.FieldByName('ID_DISTRIBUIDOR').AsInteger > 0) and
         (FMemDetailProdutosExcluidos.FieldByName('ID_PRODUTO').AsInteger > 0) then
      begin
        TIoCContainer.DistribuidorService.ExcluirDistribuidorProduto(
          FMemDetailProdutosExcluidos.FieldByName('ID_DISTRIBUIDOR').AsInteger,
          FMemDetailProdutosExcluidos.FieldByName('ID_PRODUTO').AsInteger
        );
      end;
      FMemDetailProdutosExcluidos.Next;
    end;
    FMemDetailProdutosExcluidos.Close;
    FMemDetailProdutosExcluidos.Open;

    LMemTable.FieldByName('NOME').AsString := LDistribuidor.Nome;
    LMemTable.FieldByName('CNPJ').AsString := LDistribuidor.Cnpj;
    LMemTable.Post;

    LimparCamposInterface;
    ExecutarPesquisa('');
  finally
    LDistribuidor.Free;
  end;
end;

function TViewCadastroDistribuidorDetail.IsDatasetEditando: Boolean;
var
  LMemTable: TFDMemTable;
begin
  LMemTable := TFDMemTable(FDataSource.DataSet);
  Result := LMemTable.State in [dsInsert, dsEdit];
end;

end.

