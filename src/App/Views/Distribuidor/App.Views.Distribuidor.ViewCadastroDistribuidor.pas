unit App.Views.Distribuidor.ViewCadastroDistribuidor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, App.Views.Base.ViewBaseCadastro,
  Vcl.StdCtrls, Vcl.ExtCtrls, FireDAC.Comp.Client, System.Generics.Collections,
  Data.DB, Infra.IoC.Container, Core.Entities.Distribuidor, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet, Vcl.Grids,
  Vcl.DBGrids, Vcl.ComCtrls;

type
  TViewCadastroDistribuidor = class(TViewBaseCadastro)
    lblNome: TLabel;
    edtNome: TEdit;
    lblCnpj: TLabel;
    edtCnpj: TEdit;
  private
    procedure LimparCamposInterface;
    procedure CarregarDadosObjetoParaInterface;
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

procedure TViewCadastroDistribuidor.InicializarComponentes;
begin
  lblTitulo.Caption := 'Cadastro de Distribuidores de Insumos';

  FDataSource.DataSet := TFDMemTable.Create(Self);
  TFDMemTable(FDataSource.DataSet).FieldDefs.Add('ID', ftInteger);
  TFDMemTable(FDataSource.DataSet).FieldDefs.Add('NOME', ftString, 100);
  TFDMemTable(FDataSource.DataSet).FieldDefs.Add('CNPJ', ftString, 18);
  TFDMemTable(FDataSource.DataSet).CreateDataSet;

  ExecutarPesquisa('');
end;

procedure TViewCadastroDistribuidor.ExecutarPesquisa(const ATexto: string);
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
    LLista.Free;
  end;
end;

procedure TViewCadastroDistribuidor.LimparCamposInterface;
begin
  edtNome.Clear;
  edtCnpj.Clear;
end;

procedure TViewCadastroDistribuidor.CarregarDadosObjetoParaInterface;
var
  LMemTable: TFDMemTable;
begin
  LMemTable := TFDMemTable(FDataSource.DataSet);
  edtNome.Text := LMemTable.FieldByName('NOME').AsString;
  edtCnpj.Text := LMemTable.FieldByName('CNPJ').AsString;
end;

procedure TViewCadastroDistribuidor.DoNovo;
var
  LMemTable: TFDMemTable;
begin
  LMemTable := TFDMemTable(FDataSource.DataSet);
  LMemTable.Append;
  LimparCamposInterface;
  if edtNome.CanFocus then
    edtNome.SetFocus;
end;

procedure TViewCadastroDistribuidor.DoEditar;
var
  LMemTable: TFDMemTable;
begin
  LMemTable := TFDMemTable(FDataSource.DataSet);
  LMemTable.Edit;
  CarregarDadosObjetoParaInterface;
  if edtNome.CanFocus then
    edtNome.SetFocus;
end;

procedure TViewCadastroDistribuidor.DoCancelar;
var
  LMemTable: TFDMemTable;
begin
  LMemTable := TFDMemTable(FDataSource.DataSet);
  LMemTable.Cancel;
  LimparCamposInterface;
end;

procedure TViewCadastroDistribuidor.DoDeletar;
var
  LMemTable: TFDMemTable;
begin
  LMemTable := TFDMemTable(FDataSource.DataSet);
  TIoCContainer.DistribuidorService.Excluir(LMemTable.FieldByName('ID').AsInteger);
  LMemTable.Delete;
end;

procedure TViewCadastroDistribuidor.DoSalvar;
var
  LDistribuidor: TDistribuidor;
  LMemTable: TFDMemTable;
begin
  LMemTable := TFDMemTable(FDataSource.DataSet);

  LDistribuidor := TDistribuidor.Create;
  try
    LDistribuidor.Id := LMemTable.FieldByName('ID').AsInteger;
    LDistribuidor.Nome := edtNome.Text;
    LDistribuidor.Cnpj := edtCnpj.Text;

    if LDistribuidor.Id = 0 then
      TIoCContainer.DistribuidorService.Salvar(LDistribuidor)
    else
      TIoCContainer.DistribuidorService.Atualizar(LDistribuidor);

    LMemTable.FieldByName('NOME').AsString := LDistribuidor.Nome;
    LMemTable.FieldByName('CNPJ').AsString := LDistribuidor.Cnpj;
    LMemTable.Post;

    LimparCamposInterface;
    ExecutarPesquisa('');
  finally
    LDistribuidor.Free;
  end;
end;

function TViewCadastroDistribuidor.IsDatasetEditando: Boolean;
var
  LMemTable: TFDMemTable;
begin
  LMemTable := TFDMemTable(FDataSource.DataSet);
  Result := LMemTable.State in [dsInsert, dsEdit];
end;

end.
