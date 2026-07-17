unit App.Views.Produtor.ViewCadastroProdutor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, App.Views.Base.ViewBaseCadastro,
  Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls, Vcl.ComCtrls, FireDAC.Comp.Client,
  System.Generics.Collections, Data.DB, Infra.IoC.Container, Core.Entities.Produtor,
  Core.Entities.Distribuidor,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, Vcl.Buttons,

type
  TChaveLimiteExcluido = record
    IdProdutor: Integer;
    IdDistribuidor: Integer;
  end;

  TViewCadastroProdutor = class(TViewBaseCadastro)
    lblNome: TLabel;
    edtNome: TEdit;
    lblCpfCnpj: TLabel;
    edtCpfCnpj: TEdit;
    pnlLimite: TPanel;
    gridLimite: TDBGrid;
    pnlBotoesLimite: TPanel;
    btnAdicionarLimite: TSpeedButton;
    btnRemoverLimite: TSpeedButton;
    procedure btnAdicionarLimiteClick(Sender: TObject);
    procedure btnRemoverLimiteClick(Sender: TObject);
    procedure gridLimiteDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure gridLimiteColEnter(Sender: TObject);
    procedure gridLimiteColExit(Sender: TObject);
  private
    FMemTable: TFDMemTable;
    FMemLimites: TFDMemTable;
    FMemComboDistribuidores: TFDMemTable;
    FDataSourceLimites: TDataSource;
    FDataSourceCombo: TDataSource;
    FLimitesExcluidos: TList<TChaveLimiteExcluido>;
    procedure LimparCamposInterface;
    procedure CarregarDadosObjetoParaInterface;
    procedure ConfigurarDatasets;
    procedure CarregarLimitesProdutor(AIdProdutor: Integer);
    procedure CarregarTabelaDistribuidores;

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

implementation

{$R *.dfm}

procedure TViewCadastroProdutor.InicializarComponentes;
begin
  lblTitulo.Caption := 'Cadastro de Produtores Rurais';

  FLimitesExcluidos := TList<TChaveLimiteExcluido>.Create;

  FMemTable := TFDMemTable.Create(Self);
  FMemTable.FieldDefs.Add('ID', ftInteger);
  FMemTable.FieldDefs.Add('NOME', ftString, 100);
  FMemTable.FieldDefs.Add('CPF_CNPJ', ftString, 18);
  FMemTable.CreateDataSet;

  FDataSource.DataSet := FMemTable;

  ConfigurarDatasets;
  CarregarTabelaDistribuidores;

  ExecutarPesquisa('');
end;

procedure TViewCadastroProdutor.ConfigurarDatasets;
var
  LFieldIdDist: TIntegerField;
  LFieldValor: TFloatField;
  LLookupField: TStringField;
begin
  FMemComboDistribuidores := TFDMemTable.Create(Self);
  FMemComboDistribuidores.FieldDefs.Add('ID', ftInteger);
  FMemComboDistribuidores.FieldDefs.Add('NOME', ftString, 100);
  FMemComboDistribuidores.CreateDataSet;

  FDataSourceCombo := TDataSource.Create(Self);
  FDataSourceCombo.DataSet := FMemComboDistribuidores;

  FMemLimites := TFDMemTable.Create(Self);

  LFieldIdDist := TIntegerField.Create(FMemLimites);
  LFieldIdDist.FieldName := 'ID_DISTRIBUIDOR';
  LFieldIdDist.DataSet := FMemLimites;
  LFieldIdDist.ReadOnly := False;

  LFieldValor := TFloatField.Create(FMemLimites);
  LFieldValor.FieldName := 'VALOR_LIMITE';
  LFieldValor.DataSet := FMemLimites;
  LFieldValor.ReadOnly := False;

  LLookupField := TStringField.Create(FMemLimites);
  LLookupField.FieldName := 'NOME_DISTRIBUIDOR';
  LLookupField.DataSet := FMemLimites;
  LLookupField.FieldKind := fkLookup;
  LLookupField.KeyFields := 'ID_DISTRIBUIDOR';
  LLookupField.LookupDataSet := FMemComboDistribuidores;
  LLookupField.LookupKeyFields := 'ID';
  LLookupField.LookupResultField := 'NOME';
  LLookupField.Size := 100;
  LLookupField.ReadOnly := False;

  FMemLimites.CreateDataSet;

  FDataSourceLimites := TDataSource.Create(Self);
  FDataSourceLimites.DataSet := FMemLimites;
  gridLimite.DataSource := FDataSourceLimites;
  gridLimite.OnColEnter := gridLimiteColEnter;
  gridLimite.OnColExit := gridLimiteColExit;
  gridLimite.OnDrawColumnCell :=  gridLimiteDrawColumnCell
end;

procedure TViewCadastroProdutor.CarregarTabelaDistribuidores;
var
  LLista: TList<TDistribuidor>;
  LItem: TDistribuidor;
begin
  FMemComboDistribuidores.Close;
  FMemComboDistribuidores.Open;

  LLista := TIoCContainer.DistribuidorService.ObterTodos;
  try
    for LItem in LLista do
    begin
      FMemComboDistribuidores.Append;
      FMemComboDistribuidores.FieldByName('ID').AsInteger := LItem.Id;
      FMemComboDistribuidores.FieldByName('NOME').AsString := LItem.Nome;
      FMemComboDistribuidores.Post;
    end;
  finally
    LLista.Free;
  end;
end;

procedure TViewCadastroProdutor.btnAdicionarLimiteClick(Sender: TObject);
begin
  if not IsDatasetEditando then
    Exit;

  if FMemLimites.State in [dsInsert, dsEdit] then
    FMemLimites.Post;

  FMemLimites.IndexFieldNames := '';
  FMemLimites.Last;

  FMemLimites.Append;
  FMemLimites.FieldByName('ID_DISTRIBUIDOR').Clear;

  if gridLimite.CanFocus then
  begin
    gridLimite.SetFocus;
    gridLimite.SelectedIndex := 0;

    gridLimite.EditorMode := True;
  end;
end;

procedure TViewCadastroProdutor.btnRemoverLimiteClick(Sender: TObject);
var
  LIdProdutor: Integer;
  LExcluido: TChaveLimiteExcluido;
begin
  if not IsDatasetEditando then
    Exit;
  if FMemLimites.IsEmpty then
    Exit;

  if TMessageValidation.Confirmar('Deseja remover o limite de crédito deste distribuidor da lista?') then
  begin
    LIdProdutor := FMemTable.FieldByName('ID').AsInteger;

    if (LIdProdutor > 0) and (FMemLimites.FieldByName('ID_DISTRIBUIDOR').AsInteger > 0) then
    begin
      LExcluido.IdProdutor := LIdProdutor;
      LExcluido.IdDistribuidor := FMemLimites.FieldByName('ID_DISTRIBUIDOR').AsInteger;
      FLimitesExcluidos.Add(LExcluido);
    end;

    FMemLimites.Delete;
  end;
end;

procedure TViewCadastroProdutor.ExecutarPesquisa(const ATexto: string);
var
  LLista: TList<TProdutor>;
  LProdutor: TProdutor;
begin
  FMemTable.Close;
  FMemTable.Open;

  if ATexto = '' then
    LLista := TIoCContainer.ProdutorService.ObterTodos
  else
    LLista := TIoCContainer.ProdutorService.ObterPorNome(ATexto);

  try
    FMemTable.DisableControls;
    for LProdutor in LLista do
    begin
      FMemTable.Append;
      FMemTable.FieldByName('ID').AsInteger := LProdutor.Id;
      FMemTable.FieldByName('NOME').AsString := LProdutor.Nome;
      FMemTable.FieldByName('CPF_CNPJ').AsString := LProdutor.CpfCnpj;
      FMemTable.Post;
    end;
  finally
    FMemTable.EnableControls;
    LLista.Free;
  end;
end;

procedure TViewCadastroProdutor.gridLimiteColEnter(Sender: TObject);
var
  LIdProdutor: Integer;
  LIdDistribuidor: Integer;
begin
  if gridLimite.SelectedField.FieldName.ToUpper = 'NOME_DISTRIBUIDOR' then
  begin
    LIdProdutor := FMemTable.FieldByName('ID').AsInteger;
    LIdDistribuidor := FMemLimites.FieldByName('ID_DISTRIBUIDOR').AsInteger;

    if (LIdProdutor > 0) and (LIdDistribuidor > 0) then
      gridLimite.SelectedField.ReadOnly := True
    else
      gridLimite.SelectedField.ReadOnly := False;
  end;
end;

procedure TViewCadastroProdutor.gridLimiteColExit(Sender: TObject);
var
  LFDMemTemp: TFDMemTable;
  LJaExiste: Boolean;
  LIdSelecionado: Integer;
  LRecNoAtual: Integer;
begin
  if gridLimite.SelectedField.FieldName.ToUpper = 'NOME_DISTRIBUIDOR' then
  begin
    LIdSelecionado := FMemLimites.FieldByName('ID_DISTRIBUIDOR').AsInteger;
    if LIdSelecionado <= 0 then Exit;

    LJaExiste := False;
    LRecNoAtual := FMemLimites.RecNo;

    LFDMemTemp := TFDMemTable.Create(nil);
    try
      LFDMemTemp.CloneCursor(FMemLimites, True, False);

      LFDMemTemp.First;
      while not LFDMemTemp.Eof do
      begin
        if (LFDMemTemp.FieldByName('ID_DISTRIBUIDOR').AsInteger = LIdSelecionado) and
           (LFDMemTemp.RecNo <> LRecNoAtual) then
        begin
          LJaExiste := True;
          Break;
        end;
        LFDMemTemp.Next;
      end;
    finally
      LFDMemTemp.Free;
    end;

    if LJaExiste then
    begin
      TMessageValidation.Aviso('Este distribuidor já possui um limite configurado para este produtor.');

      FMemLimites.Edit;
      FMemLimites.FieldByName('ID_DISTRIBUIDOR').Clear;
      gridLimite.SetFocus;
      Abort;
    end;
  end;
end;

procedure TViewCadastroProdutor.gridLimiteDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);

begin
  gridLimite.DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;

procedure TViewCadastroProdutor.CarregarLimitesProdutor(AIdProdutor: Integer);
var
  LListaDistribuidores: TList<TDistribuidor>;
  LDistribuidor: TDistribuidor;
  LValorLimite: Currency;
begin
  FMemLimites.Close;
  FMemLimites.Open;
  if AIdProdutor = 0 then
    Exit;

  LListaDistribuidores := TIoCContainer.DistribuidorService.ObterTodos;
  try
    FMemLimites.DisableControls;
    for LDistribuidor in LListaDistribuidores do
    begin
      LValorLimite := TIoCContainer.ProdutorService.ObterProdutorLimiteCredito(AIdProdutor, LDistribuidor.Id);

      if LValorLimite > 0 then
      begin
        FMemLimites.Append;
        FMemLimites.FieldByName('ID_DISTRIBUIDOR').AsInteger := LDistribuidor.Id;
        FMemLimites.FieldByName('VALOR_LIMITE').AsFloat := LValorLimite;
        FMemLimites.Post;
      end;
    end;
  finally
    FMemLimites.EnableControls;
    LListaDistribuidores.Free;
  end;
end;

procedure TViewCadastroProdutor.LimparCamposInterface;
begin
  edtNome.Clear;
  edtCpfCnpj.Clear;
  FMemLimites.Close;
  FMemLimites.Open;
  FLimitesExcluidos.Clear;
end;

procedure TViewCadastroProdutor.CarregarDadosObjetoParaInterface;
begin
  edtNome.Text := FMemTable.FieldByName('NOME').AsString;
  edtCpfCnpj.Text := FMemTable.FieldByName('CPF_CNPJ').AsString;
  CarregarLimitesProdutor(FMemTable.FieldByName('ID').AsInteger);
end;

procedure TViewCadastroProdutor.DoNovo;
begin
  FMemTable.Append;
  LimparCamposInterface;
  if edtNome.CanFocus then
    edtNome.SetFocus;
end;

procedure TViewCadastroProdutor.DoEditar;
begin
  FMemTable.Edit;
  CarregarDadosObjetoParaInterface;
  if edtNome.CanFocus then
    edtNome.SetFocus;
end;

procedure TViewCadastroProdutor.DoCancelar;
begin
  FMemTable.Cancel;
  FMemLimites.Cancel;
  LimparCamposInterface;
end;

procedure TViewCadastroProdutor.DoDeletar;
begin
  TIoCContainer.ProdutorService.Excluir(FMemTable.FieldByName('ID').AsInteger);
  FMemTable.Delete;
end;

procedure TViewCadastroProdutor.DoSalvar;
var
  LProdutor: TProdutor;
  LChaveExcluido: TChaveLimiteExcluido;
  LIdDistribuidor: Integer;
  LValorLimite: Currency;
  LListaControle: TList<Integer>;
begin
  if FMemLimites.State in [dsInsert, dsEdit] then
    FMemLimites.Post;

  LProdutor := TProdutor.Create;
  try
    LProdutor.Id := FMemTable.FieldByName('ID').AsInteger;
    LProdutor.Nome := edtNome.Text;
    LProdutor.CpfCnpj := edtCpfCnpj.Text;

    if LProdutor.Id = 0 then
      TIoCContainer.ProdutorService.Salvar(LProdutor)
    else
      TIoCContainer.ProdutorService.Atualizar(LProdutor);

    for LChaveExcluido in FLimitesExcluidos do
    begin
      TIoCContainer.ProdutorService.ExcluirProdutorLimiteCredito(LChaveExcluido.IdProdutor, LChaveExcluido.IdDistribuidor);
    end;

    FMemLimites.First;
    while not FMemLimites.Eof do
    begin
      LIdDistribuidor := FMemLimites.FieldByName('ID_DISTRIBUIDOR').AsInteger;
      LValorLimite := FMemLimites.FieldByName('VALOR_LIMITE').AsCurrency;

      if LIdDistribuidor > 0 then
      begin
        if LProdutor.LimitesCredito.ContainsKey(LIdDistribuidor) then
        begin
          TMessageValidation.Aviso('Existem distribuidores duplicados na lista de limites. Verifique antes de salvar.');
          Abort;
        end;

        LProdutor.AdicionarProdutorLimiteCredito(LIdDistribuidor, LValorLimite);

        if TIoCContainer.ProdutorService.ObterProdutorLimiteCredito(LProdutor.Id, LIdDistribuidor) > 0 then
          TIoCContainer.ProdutorService.AtualizarProdutorLimiteCredito(LProdutor.Id, LIdDistribuidor, LValorLimite)
        else
          TIoCContainer.ProdutorService.AdicionarProdutorLimiteCredito(LProdutor.Id, LIdDistribuidor, LValorLimite);
      end;
      FMemLimites.Next;
    end;

    FMemTable.FieldByName('NOME').AsString := LProdutor.Nome;
    FMemTable.FieldByName('CPF_CNPJ').AsString := LProdutor.CpfCnpj;
    FMemTable.Post;

    LimparCamposInterface;
    ExecutarPesquisa('');
  finally
    LProdutor.Free;
  end;
end;

function TViewCadastroProdutor.IsDatasetEditando: Boolean;
begin
  Result := FMemTable.State in [dsInsert, dsEdit];
end;

end.



