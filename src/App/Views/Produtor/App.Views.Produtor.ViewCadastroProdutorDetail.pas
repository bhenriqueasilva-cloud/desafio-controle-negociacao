unit App.Views.Produtor.ViewCadastroProdutorDetail;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, App.Views.Base.ViewBaseCadastroDetail,
  Vcl.StdCtrls, Vcl.ExtCtrls, FireDAC.Comp.Client, System.Generics.Collections,
  Data.DB, Infra.IoC.Container, Core.Entities.Produtor, Core.Entities.Distribuidor, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet, Vcl.Grids,
  Vcl.DBGrids, Vcl.ComCtrls, Vcl.Buttons,
  Infra.CrossCutting.Validation.MessageValidation,
  Infra.CrossCutting.Validation.CPFValidator,
  Infra.CrossCutting.Validation.CNPJValidator;

type
  TViewCadastroProdutorDetail = class(TViewBaseCadastroDetail)
    lblNome: TLabel;
    lblCpfCnpj: TLabel;
    edtNome: TEdit;
    edtCpfCnpj: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure btnIncluirDetailClick(Sender: TObject);
    procedure brnExcluirDetailClick(Sender: TObject);
  private
    FDataSourceDistribuidor: TDataSource;
    FMemDetailDistribuidor: TFDMemTable;
    FMemDetailDistribuidorExcluidos: TFDMemTable;
    procedure FMemDetailBeforePost(DataSet: TDataSet);
    procedure LimparCamposInterface;
    procedure CarregarDadosObjetoParaInterface;
    procedure CarregarTabelaDistribuidores;
    procedure CarregarTabelaProdutorLimites(AIdProdutor: Integer);
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
  ViewCadastroProdutorDetail: TViewCadastroProdutorDetail;

implementation

{$R *.dfm}

procedure TViewCadastroProdutorDetail.InicializarComponentes;
var
  LLookupField: TStringField;
  LFieldId: TIntegerField;
  LFieldIdProdutor: TIntegerField;
  LFieldIdDist: TIntegerField;
  LFieldValorLimite: TFloatField;
begin
  lblTitulo.Caption := 'Cadastro de Limite de Crédito de Produtores';

  FDataSource.DataSet := TFDMemTable.Create(Self);
  TFDMemTable(FDataSource.DataSet).FieldDefs.Add('ID', ftInteger);
  TFDMemTable(FDataSource.DataSet).FieldDefs.Add('NOME', ftString, 100);
  TFDMemTable(FDataSource.DataSet).FieldDefs.Add('CPF_CNPJ', ftString, 18);
  TFDMemTable(FDataSource.DataSet).CreateDataSet;

  FMemDetailDistribuidorExcluidos := TFDMemTable.Create(Self);
  FMemDetailDistribuidorExcluidos.FieldDefs.Add('ID_PRODUTOR', ftInteger);
  FMemDetailDistribuidorExcluidos.FieldDefs.Add('ID_DISTRIBUIDOR', ftInteger);
  FMemDetailDistribuidorExcluidos.CreateDataSet;

  LFieldId := TIntegerField.Create(Self);
  LFieldId.FieldName := 'ID';
  LFieldId.DataSet := FMemDetail;
  LFieldId.ProviderFlags := [pfInWhere, pfInKey];

  LFieldIdProdutor := TIntegerField.Create(Self);
  LFieldIdProdutor.FieldName := 'ID_PRODUTOR';
  LFieldIdProdutor.DataSet := FMemDetail;

  LFieldIdDist := TIntegerField.Create(Self);
  LFieldIdDist.FieldName := 'ID_DISTRIBUIDOR';
  LFieldIdDist.DataSet := FMemDetail;

  LFieldValorLimite := TFloatField.Create(Self);
  LFieldValorLimite.FieldName := 'VALOR_LIMITE';
  LFieldValorLimite.DataSet := FMemDetail;
  LFieldValorLimite.DisplayLabel := 'Limite de Crédito';
  LFieldValorLimite.DisplayFormat := 'R$ ,0.00';

  FMemDetailDistribuidor.FieldDefs.Add('ID', ftInteger);
  FMemDetailDistribuidor.FieldDefs.Add('NOME', ftString, 100);
  FMemDetailDistribuidor.FieldDefs.Add('CNPJ', ftString, 18);
  FMemDetailDistribuidor.CreateDataSet;
  FDataSourceDistribuidor.DataSet := FMemDetailDistribuidor;

  LLookupField := TStringField.Create(Self);
  LLookupField.FieldName := 'NOME_DISTRIBUIDOR';
  LLookupField.DisplayLabel := 'Distribuidor';
  LLookupField.DataSet := FMemDetail;
  LLookupField.FieldKind := fkLookup;
  LLookupField.KeyFields := 'ID_DISTRIBUIDOR';
  LLookupField.LookupDataSet := FMemDetailDistribuidor;
  LLookupField.LookupKeyFields := 'ID';
  LLookupField.LookupResultField := 'NOME';
  LLookupField.Size := 100;

  FMemDetail.BeforePost := FMemDetailBeforePost;
  FMemDetail.CreateDataSet;

  ExecutarPesquisa('');
  CarregarTabelaDistribuidores;
end;

procedure TViewCadastroProdutorDetail.ExecutarPesquisa(const ATexto: string);
var
  LLista: TList<TProdutor>;
  LProdutor: TProdutor;
  LMemTable: TFDMemTable;
begin
  LMemTable := TFDMemTable(FDataSource.DataSet);
  LMemTable.Close;
  LMemTable.Open;

  if ATexto = '' then
    LLista := TIoCContainer.ProdutorService.ObterTodos
  else
    LLista := TIoCContainer.ProdutorService.ObterPorNome(ATexto);

  try
    LMemTable.DisableControls;
    for LProdutor in LLista do
    begin
      LMemTable.Append;
      LMemTable.FieldByName('ID').AsInteger := LProdutor.Id;
      LMemTable.FieldByName('NOME').AsString := LProdutor.Nome;
      LMemTable.FieldByName('CPF_CNPJ').AsString := LProdutor.CpfCnpj;
      LMemTable.Post;
    end;
  finally
    LMemTable.EnableControls;
    if Assigned(LLista) then
    begin
      for LProdutor in LLista do
        LProdutor.Free;
      LLista.Free;
    end;
  end;
end;

procedure TViewCadastroProdutorDetail.CarregarTabelaProdutorLimites(AIdProdutor: Integer);
var
  LListaDistribuidor: TList<TDistribuidor>;
  LDistribuidor: TDistribuidor;
  LId: Integer;
  LValorLimite: Currency;
begin
  FMemDetail.Close;
  FMemDetail.Open;

  if AIdProdutor = 0 then
    Exit;

  LListaDistribuidor := TIoCContainer.DistribuidorService.ObterTodos;
  try
    FMemDetail.DisableControls;
    for LDistribuidor in LListaDistribuidor do
    begin
      LId := TIoCContainer.ProdutorService.ObterProdutorLimiteCredito(AIdProdutor, LDistribuidor.Id, LValorLimite);
      if LId > 0 then
      begin
        FMemDetail.Append;
        FMemDetail.FieldByName('ID').AsInteger := LId;
        FMemDetail.FieldByName('ID_PRODUTOR').AsInteger := AIdProdutor;
        FMemDetail.FieldByName('ID_DISTRIBUIDOR').AsInteger := LDistribuidor.Id;
        FMemDetail.FieldByName('VALOR_LIMITE').AsCurrency := LValorLimite;
        FMemDetail.Post;
      end;
    end;
  finally
    FMemDetail.EnableControls;
    if Assigned(LListaDistribuidor) then
    begin
      for LDistribuidor in LListaDistribuidor do
        LDistribuidor.Free;
      LListaDistribuidor.Free;
    end;
  end;
end;

procedure TViewCadastroProdutorDetail.CarregarTabelaDistribuidores;
var
  LLista: TList<TDistribuidor>;
  LItem: TDistribuidor;
begin
  FMemDetailDistribuidor.Close;
  FMemDetailDistribuidor.Open;

  LLista := TIoCContainer.DistribuidorService.ObterTodos;
  try
    FMemDetailDistribuidor.DisableControls;
    for LItem in LLista do
    begin
      FMemDetailDistribuidor.Append;
      FMemDetailDistribuidor.FieldByName('ID').AsInteger := LItem.Id;
      FMemDetailDistribuidor.FieldByName('NOME').AsString := LItem.Nome;
      FMemDetailDistribuidor.FieldByName('CNPJ').AsString := LItem.Cnpj;
      FMemDetailDistribuidor.Post;
    end;
  finally
    FMemDetailDistribuidor.EnableControls;
    if Assigned(LLista) then
    begin
      for LItem in LLista do
        LItem.Free;
      LLista.Free;
    end;
  end;
end;

procedure TViewCadastroProdutorDetail.FormCreate(Sender: TObject);
begin
  FMemDetailDistribuidor := TFDMemTable.Create(Self);
  FDataSourceDistribuidor := TDataSource.Create(Self);
  inherited;
end;

procedure TViewCadastroProdutorDetail.FMemDetailBeforePost(DataSet: TDataSet);
var
  LClone: TFDMemTable;
begin
  if DataSet.FieldByName('ID_DISTRIBUIDOR').IsNull or 
     (DataSet.FieldByName('ID_DISTRIBUIDOR').AsInteger = 0) then
    Exit;

  LClone := TFDMemTable.Create(nil);
  try
    LClone.CloneCursor(TFDMemTable(DataSet), True, True);
    LClone.First;
    while not LClone.Eof do
    begin
      if (LClone.RecNo <> DataSet.RecNo) and 
         (LClone.FieldByName('ID_DISTRIBUIDOR').AsInteger = DataSet.FieldByName('ID_DISTRIBUIDOR').AsInteger) then
      begin
        TMessageValidation.Aviso('O mesmo distribuidor não pode ser adicionado mais de uma vez na lista de limites de crédito.');
        Abort;
      end;
      LClone.Next;
    end;
  finally
    LClone.Free;
  end;
end;

procedure TViewCadastroProdutorDetail.LimparCamposInterface;
begin
  edtNome.Clear;
  edtCpfCnpj.Clear;
end;

procedure TViewCadastroProdutorDetail.CarregarDadosObjetoParaInterface;
var
  LMemTable: TFDMemTable;
  LDocBanco: string;
begin
  LMemTable := TFDMemTable(FDataSource.DataSet);
  if FDataSource.DataSet.IsEmpty then
    Exit;

  edtNome.Text := FDataSource.DataSet.FieldByName('NOME').AsString;

  LDocBanco := LMemTable.FieldByName('CPF_CNPJ').AsString;
   if Length(LDocBanco) = 11 then
    edtCpfCnpj.Text := TCPFValidator.FormatarCPF(LDocBanco)
  else if Length(LDocBanco) = 14 then
    edtCpfCnpj.Text := TCNPJValidator.FormatarCNPJ(LDocBanco)
  else
    edtCpfCnpj.Text := LDocBanco;

  CarregarTabelaProdutorLimites(FDataSource.DataSet.FieldByName('ID').AsInteger);
end;

procedure TViewCadastroProdutorDetail.btnIncluirDetailClick(Sender: TObject);
begin
  if not (FDataSource.DataSet.State in [dsInsert, dsEdit]) then
    Exit;

  if FMemDetail.State in [dsInsert, dsEdit] then
    FMemDetail.Post;

  FMemDetail.IndexFieldNames := '';
  FMemDetail.Last;

  if (not FMemDetail.IsEmpty) and (FMemDetail.FieldByName('ID_DISTRIBUIDOR').IsNull
    or (FMemDetail.FieldByName('ID_DISTRIBUIDOR').AsInteger <= 0)) then
  begin
    TMessageValidation.Aviso('Por favor, preencha o distribuidor na linha atual antes de incluir uma nova.');
    if gridDetail.CanFocus then gridDetail.SetFocus;
    Exit;
  end;

  FMemDetail.Append;
  FMemDetail.FieldByName('ID').AsInteger := 0;
  FMemDetail.FieldByName('ID_PRODUTOR').AsInteger := FDataSource.DataSet.FieldByName('ID').AsInteger;
  FMemDetail.FieldByName('ID_DISTRIBUIDOR').Clear;
  FMemDetail.FieldByName('VALOR_LIMITE').AsCurrency := 0;

  if gridDetail.CanFocus then
  begin
    gridDetail.SetFocus;
    gridDetail.SelectedIndex := 0;
    gridDetail.EditorMode := True;
  end;
end;

procedure TViewCadastroProdutorDetail.brnExcluirDetailClick(Sender: TObject);
begin
  if not (FDataSource.DataSet.State in [dsInsert, dsEdit]) then
    Exit;

  if FMemDetail.IsEmpty then
    Exit;

  if TMessageValidation.Confirmar('Deseja remover o limite de crédito deste distribuidor?') then
  begin
    if FMemDetail.FieldByName('ID').AsInteger > 0 then
    begin
      FMemDetailDistribuidorExcluidos.Append;
      FMemDetailDistribuidorExcluidos.FieldByName('ID_PRODUTOR').AsInteger := FMemDetail.FieldByName('ID_PRODUTOR').AsInteger;
      FMemDetailDistribuidorExcluidos.FieldByName('ID_DISTRIBUIDOR').AsInteger := FMemDetail.FieldByName('ID_DISTRIBUIDOR').AsInteger;
      FMemDetailDistribuidorExcluidos.Post;
    end;
    FMemDetail.Delete;
  end;
end;

procedure TViewCadastroProdutorDetail.DoNovo;
var
  LMemTable: TFDMemTable;
begin
  LMemTable := TFDMemTable(FDataSource.DataSet);
  LMemTable.Append;

  FMemDetail.Close;
  FMemDetail.Open;

  FMemDetailDistribuidorExcluidos.Close;
  FMemDetailDistribuidorExcluidos.Open;

  LimparCamposInterface;
  if edtNome.CanFocus then
    edtNome.SetFocus;
end;

procedure TViewCadastroProdutorDetail.DoEditar;
var
  LMemTable: TFDMemTable;
begin
  LMemTable := TFDMemTable(FDataSource.DataSet);
  LMemTable.Edit;

  FMemDetailDistribuidorExcluidos.Close;
  FMemDetailDistribuidorExcluidos.Open;

  CarregarDadosObjetoParaInterface;
  CarregarTabelaProdutorLimites(LMemTable.FieldByName('ID').AsInteger);

  if edtNome.CanFocus then
    edtNome.SetFocus;
end;

procedure TViewCadastroProdutorDetail.DoDeletar;
var
  LMemTable: TFDMemTable;
begin
  if TMessageValidation.Confirmar('Deseja realmente excluir este produtor e seus limites?') then
  begin
    LMemTable := TFDMemTable(FDataSource.DataSet);
    TIoCContainer.ProdutorService.Excluir(LMemTable.FieldByName('ID').AsInteger);
    LMemTable.Delete;
  end;
end;

procedure TViewCadastroProdutorDetail.DoSalvar;
var
  LProdutor: TProdutor;
  LMemTable: TFDMemTable;
begin
  LMemTable := TFDMemTable(FDataSource.DataSet);

  if FMemDetail.State in [dsInsert, dsEdit] then
    FMemDetail.Post;
  LProdutor := TProdutor.Create;
  try
    LProdutor.Id := LMemTable.FieldByName('ID').AsInteger;
    LProdutor.Nome := edtNome.Text;
    LProdutor.CpfCnpj := edtCpfCnpj.Text;

    if LProdutor.Id = 0 then
    begin
      TIoCContainer.ProdutorService.Salvar(LProdutor);
      LMemTable.FieldByName('ID').AsInteger := LProdutor.Id;
    end
    else
      TIoCContainer.ProdutorService.Atualizar(LProdutor);

    FMemDetail.First;
    while not FMemDetail.Eof do
    begin
      if FMemDetail.FieldByName('ID_DISTRIBUIDOR').AsInteger > 0 then
      begin
        if FMemDetail.FieldByName('ID').AsInteger > 0 then
        begin
          TIoCContainer.ProdutorService.AtualizarProdutorLimiteCredito(
            LProdutor.Id,
            FMemDetail.FieldByName('ID_DISTRIBUIDOR').AsInteger,
            FMemDetail.FieldByName('VALOR_LIMITE').AsCurrency
          );
        end
        else
        begin
          TIoCContainer.ProdutorService.SalvarProdutorLimiteCredito(
            LProdutor.Id,
            FMemDetail.FieldByName('ID_DISTRIBUIDOR').AsInteger,
            FMemDetail.FieldByName('VALOR_LIMITE').AsCurrency
          );
        end;
      end;
      FMemDetail.Next;
    end;

    FMemDetailDistribuidorExcluidos.First;
    while not FMemDetailDistribuidorExcluidos.Eof do
    begin
      if (FMemDetailDistribuidorExcluidos.FieldByName('ID_PRODUTOR').AsInteger > 0) and
         (FMemDetailDistribuidorExcluidos.FieldByName('ID_DISTRIBUIDOR').AsInteger > 0) then
      begin
        TIoCContainer.ProdutorService.ExcluirProdutorLimiteCredito(
          FMemDetailDistribuidorExcluidos.FieldByName('ID_PRODUTOR').AsInteger,
          FMemDetailDistribuidorExcluidos.FieldByName('ID_DISTRIBUIDOR').AsInteger
        );
      end;
      FMemDetailDistribuidorExcluidos.Next;
    end;

    FMemDetailDistribuidorExcluidos.Close;
    FMemDetailDistribuidorExcluidos.Open;

    LMemTable.FieldByName('NOME').AsString := LProdutor.Nome;
    LMemTable.FieldByName('CPF_CNPJ').AsString := LProdutor.CpfCnpj;
    LMemTable.Post;

    LimparCamposInterface;
    ExecutarPesquisa('');
  finally
    LProdutor.Free;
  end;
end;

procedure TViewCadastroProdutorDetail.DoCancelar;
var
  LMemTable: TFDMemTable;
begin
  LMemTable := TFDMemTable(FDataSource.DataSet);
  LMemTable.Cancel;

  FMemDetail.CancelUpdates;
  FMemDetail.Close;

  FMemDetailDistribuidorExcluidos.CancelUpdates;
  FMemDetailDistribuidorExcluidos.Close;

  LimparCamposInterface;
end;

function TViewCadastroProdutorDetail.IsDatasetEditando: Boolean;
var
  LMemTable: TFDMemTable;
begin
  LMemTable := TFDMemTable(FDataSource.DataSet);
  Result := (LMemTable.State in [dsInsert, dsEdit]) or (FMemDetail.State in [dsInsert, dsEdit]);
end;

end.




