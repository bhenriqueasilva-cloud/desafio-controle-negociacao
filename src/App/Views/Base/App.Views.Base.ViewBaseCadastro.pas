unit App.Views.Base.ViewBaseCadastro;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls,
  Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Data.DB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  TViewBaseCadastro = class(TForm)
    pgcPrincipal: TPageControl;
    tsConsulta: TTabSheet;
    tsDados: TTabSheet;
    pnlFiltro: TPanel;
    edtPesquisa: TEdit;
    btnPesquisar: TButton;
    gridConsulta: TDBGrid;
    pnlBotoes: TPanel;
    btnNovo: TButton;
    btnEditar: TButton;
    btnDeletar: TButton;
    btnSalvar: TButton;
    btnCancelar: TButton;
    pnlTitulo: TPanel;
    lblTitulo: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnNovoClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnDeletarClick(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
    procedure gridConsultaDblClick(Sender: TObject);
  private
    function HasData: Boolean;
    procedure pgcPrincipalChange(Sender: TObject);
  protected
    FDataSource: TDataSource;
    procedure AtualizarEstadoBotoes;

    procedure InicializarComponentes; virtual; abstract;
    procedure ExecutarPesquisa(const ATexto: string); virtual; abstract;
    procedure DoNovo; virtual; abstract;
    procedure DoEditar; virtual; abstract;
    procedure DoDeletar; virtual; abstract;
    procedure DoSalvar; virtual; abstract;
    procedure DoCancelar; virtual; abstract;
    function IsDatasetEditando: Boolean; virtual; abstract;
  public
  end;

implementation

{$R *.dfm}

uses
 Infra.CrossCutting.Validation.MessageValidation;

procedure TViewBaseCadastro.FormCreate(Sender: TObject);
begin
  FormStyle := fsMDIChild;
  Visible := True;

  FDataSource := TDataSource.Create(Self);
  gridConsulta.DataSource := FDataSource;

  pgcPrincipal.OnChange := pgcPrincipalChange;

  InicializarComponentes;
  pgcPrincipal.ActivePage := tsConsulta;
  AtualizarEstadoBotoes;
end;

procedure TViewBaseCadastro.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

function TViewBaseCadastro.HasData: Boolean;
begin
  Result := (FDataSource.DataSet <> nil) and (not FDataSource.DataSet.IsEmpty);
end;

procedure TViewBaseCadastro.pgcPrincipalChange(Sender: TObject);
begin
  if pgcPrincipal.ActivePage = tsDados then
  begin
    if (not IsDatasetEditando) and HasData then
    begin
      DoEditar;
      AtualizarEstadoBotoes;
    end;
  end
  else if pgcPrincipal.ActivePage = tsConsulta then
  begin
    if IsDatasetEditando then
    begin
      DoCancelar;
      AtualizarEstadoBotoes;
    end;
  end;
end;

procedure TViewBaseCadastro.AtualizarEstadoBotoes;
var
  LEditando: Boolean;
  LTemDados: Boolean;
begin
  LEditando := IsDatasetEditando;
  LTemDados := HasData;

  btnNovo.Enabled := not LEditando;
  btnEditar.Enabled := (not LEditando) and LTemDados;
  btnDeletar.Enabled := (not LEditando) and LTemDados;
  btnSalvar.Enabled := LEditando;
  btnCancelar.Enabled := LEditando;
end;

procedure TViewBaseCadastro.btnNovoClick(Sender: TObject);
begin
  DoNovo;
  pgcPrincipal.ActivePage := tsDados;
  AtualizarEstadoBotoes;
end;

procedure TViewBaseCadastro.btnEditarClick(Sender: TObject);
begin
  if HasData then
  begin
    DoEditar;
    pgcPrincipal.ActivePage := tsDados;
    AtualizarEstadoBotoes;
  end;
end;

procedure TViewBaseCadastro.gridConsultaDblClick(Sender: TObject);
begin
  if HasData then
  begin
    DoEditar;
    pgcPrincipal.ActivePage := tsDados;
    AtualizarEstadoBotoes;
  end;
end;

procedure TViewBaseCadastro.btnDeletarClick(Sender: TObject);
begin
  if HasData and TMessageValidation.Confirmar('Confirma a exclusão do registro selecionado?') then
  begin
    DoDeletar;
    AtualizarEstadoBotoes;
  end;
end;

procedure TViewBaseCadastro.btnSalvarClick(Sender: TObject);
begin
  DoSalvar;
  pgcPrincipal.ActivePage := tsConsulta;
  AtualizarEstadoBotoes;
end;

procedure TViewBaseCadastro.btnCancelarClick(Sender: TObject);
begin
  DoCancelar;
  pgcPrincipal.ActivePage := tsConsulta;
  AtualizarEstadoBotoes;
end;

procedure TViewBaseCadastro.btnPesquisarClick(Sender: TObject);
begin
  ExecutarPesquisa(edtPesquisa.Text);
  AtualizarEstadoBotoes;
end;

end.

