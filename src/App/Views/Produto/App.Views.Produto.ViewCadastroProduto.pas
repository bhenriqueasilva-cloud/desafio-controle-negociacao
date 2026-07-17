unit App.Views.Produto.ViewCadastroProduto;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, Vcl.Controls, Vcl.StdCtrls,
  Vcl.Forms, Data.DB, FireDAC.Comp.Client, System.Generics.Collections,
  App.Views.Base.ViewBaseCadastro, Core.Entities.Produto, Infra.IoC.Container,
  Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.ComCtrls;

type
  TViewCadastroProduto = class(TViewBaseCadastro)
    lblNome: TLabel;
    lblPrecoVenda: TLabel;
    edtNome: TEdit;
    edtPrecoVenda: TEdit;
    procedure edtPrecoVendaEnter(Sender: TObject);
    procedure edtPrecoVendaExit(Sender: TObject);
  private
    function GetMemTable: TFDMemTable;
    procedure LimparCamposInterface;
    procedure CarregarDadosObjetoParaInterface;
    procedure FormatarMoeda(AEdit: TEdit; AValor: Currency);
    function StringParaMoeda(const ATexto: string): Currency;
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
  ViewCadastroProduto: TViewCadastroProduto;

implementation

{$R *.dfm}

function TViewCadastroProduto.GetMemTable: TFDMemTable;
begin
  Result := TFDMemTable(FDataSource.DataSet);
end;

procedure TViewCadastroProduto.InicializarComponentes;
begin
  lblTitulo.Caption := 'Cadastro de Produtos';

  FDataSource.DataSet := TFDMemTable.Create(Self);
  GetMemTable.FieldDefs.Add('ID', ftInteger);
  GetMemTable.FieldDefs.Add('NOME', ftString, 100);
  GetMemTable.FieldDefs.Add('PRECO_VENDA', ftCurrency);
  GetMemTable.CreateDataSet;

  edtPrecoVenda.OnEnter := edtPrecoVendaEnter;
  edtPrecoVenda.OnExit := edtPrecoVendaExit;

  ExecutarPesquisa('');
end;

procedure TViewCadastroProduto.ExecutarPesquisa(const ATexto: string);
var
  LLista: TList<TProduto>;
  LProduto: TProduto;
begin
  GetMemTable.Close;
  GetMemTable.Open;

  if ATexto = '' then
    LLista := TIoCContainer.ProdutoService.ObterTodos
  else
    LLista := TIoCContainer.ProdutoService.ObterPorNome(ATexto);

  try
    GetMemTable.DisableControls;
    for LProduto in LLista do
    begin
      GetMemTable.Append;
      GetMemTable.FieldByName('ID').AsInteger := LProduto.Id;
      GetMemTable.FieldByName('NOME').AsString := LProduto.Nome;
      GetMemTable.FieldByName('PRECO_VENDA').AsCurrency := LProduto.PrecoVenda;
      GetMemTable.Post;
    end;
  finally
    GetMemTable.EnableControls;

    if Assigned(LLista) then
    begin
      for LProduto in LLista do
        LProduto.Free;
      LLista.Free;
    end;
  end;
end;

procedure TViewCadastroProduto.LimparCamposInterface;
begin
  edtNome.Clear;
  edtPrecoVenda.Clear;
end;

procedure TViewCadastroProduto.CarregarDadosObjetoParaInterface;
begin
  edtNome.Text := GetMemTable.FieldByName('NOME').AsString;
  FormatarMoeda(edtPrecoVenda, GetMemTable.FieldByName('PRECO_VENDA').AsCurrency);
end;

procedure TViewCadastroProduto.DoNovo;
begin
  GetMemTable.Append;
  LimparCamposInterface;
  if edtNome.CanFocus then
    edtNome.SetFocus;
end;

procedure TViewCadastroProduto.DoEditar;
begin
  GetMemTable.Edit;
  CarregarDadosObjetoParaInterface;
  if edtNome.CanFocus then
    edtNome.SetFocus;
end;

procedure TViewCadastroProduto.DoCancelar;
begin
  GetMemTable.Cancel;
  LimparCamposInterface;
end;

procedure TViewCadastroProduto.DoDeletar;
begin
  TIoCContainer.ProdutoService.Excluir(GetMemTable.FieldByName('ID').AsInteger);
  GetMemTable.Delete;
end;

procedure TViewCadastroProduto.DoSalvar;
var
  LProduto: TProduto;
begin
  LProduto := TProduto.Create;
  try
    LProduto.Id := GetMemTable.FieldByName('ID').AsInteger;
    LProduto.Nome := edtNome.Text;
    LProduto.PrecoVenda := StringParaMoeda(edtPrecoVenda.Text);

    if LProduto.Id = 0 then
      TIoCContainer.ProdutoService.Salvar(LProduto)
    else
      TIoCContainer.ProdutoService.Atualizar(LProduto);

    GetMemTable.FieldByName('NOME').AsString := LProduto.Nome;
    GetMemTable.FieldByName('PRECO_VENDA').AsCurrency := LProduto.PrecoVenda;
    GetMemTable.Post;

    LimparCamposInterface;
    ExecutarPesquisa('');
  finally
    LProduto.Free;
  end;
end;

function TViewCadastroProduto.IsDatasetEditando: Boolean;
begin
  Result := GetMemTable.State in [dsInsert, dsEdit];
end;

procedure TViewCadastroProduto.edtPrecoVendaEnter(Sender: TObject);
var
  LValor: Currency;
begin
  if edtPrecoVenda.Text <> '' then
  begin
    LValor := StringParaMoeda(edtPrecoVenda.Text);
    if LValor > 0 then
      edtPrecoVenda.Text := FormatFloat('0.00', LValor)
    else
      edtPrecoVenda.Clear;
  end;
end;

procedure TViewCadastroProduto.edtPrecoVendaExit(Sender: TObject);
begin
  if edtPrecoVenda.Text <> '' then
    FormatarMoeda(edtPrecoVenda, StringParaMoeda(edtPrecoVenda.Text));
end;

procedure TViewCadastroProduto.FormatarMoeda(AEdit: TEdit; AValor: Currency);
begin
  AEdit.Text := FormatFloat('R$ ,0.00', AValor);
end;

function TViewCadastroProduto.StringParaMoeda(const ATexto: string): Currency;
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
  begin
    LTextoLimpo := StringReplace(LTextoLimpo, '.', '', [rfReplaceAll]);
  end
  else
  begin
    LTextoLimpo := StringReplace(LTextoLimpo, ',', '', [rfReplaceAll]);
    LTextoLimpo := StringReplace(LTextoLimpo, '.', ',', [rfReplaceAll]);
  end;

  if (LTextoLimpo = '') or (LTextoLimpo = ',') then
    Exit(0);

  try
    Result := StrToCurr(LTextoLimpo);
  except
    Result := 0;
  end;
end;

end.

