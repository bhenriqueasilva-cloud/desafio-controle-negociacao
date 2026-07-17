unit App.Views.Principal.ViewPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Imaging.jpeg;

type
  TViewPrincipal = class(TForm)
    mMenu: TMainMenu;
    Cadastros: TMenuItem;
    Produtor: TMenuItem;
    Distribuidor: TMenuItem;
    Produto: TMenuItem;
    Negociacoes: TMenuItem;
    NovaNegociacao: TMenuItem;
    ConsultarNegociacoes: TMenuItem;
    AlterarStatus: TMenuItem;
    Sair: TMenuItem;
    pnlTitulo: TPanel;
    lblTitulo: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure SairClick(Sender: TObject);
    procedure ProdutorClick(Sender: TObject);
    procedure DistribuidorClick(Sender: TObject);
    procedure ProdutoClick(Sender: TObject);
    procedure NovaNegociacaoClick(Sender: TObject);
    procedure ConsultarNegociacoesClick(Sender: TObject);
    procedure AlterarStatusClick(Sender: TObject);
  private
    procedure AbrirFormMDI(AFormClass: TFormClass);

  public

  end;

var
  ViewPrincipal: TViewPrincipal;

implementation

{$R *.dfm}

uses 
  App.Views.Produtor.ViewCadastroProdutorDetail,
  App.Views.Distribuidor.ViewCadastroDistribuidorDetail,
  App.Views.Produto.ViewCadastroProduto,
  App.Views.Negociacao.ViewManutencaoNegociacao,
  App.Views.Negociacao.ViewConsultaNegociacoes,
  App.Views.Negociacao.ViewAlteracaoStatusNegociacao;

procedure TViewPrincipal.FormCreate(Sender: TObject);
begin
  Caption := 'Controle de Negociações - Aliare';
  lblTitulo.Caption := 'Sistema de Controle de Negociações';
end;

procedure TViewPrincipal.AbrirFormMDI(AFormClass: TFormClass);
var
  I: Integer;
  LForm: TForm;
begin
  for I := 0 to MDIChildCount - 1 do
  begin
    if MDIChildren[I] is AFormClass then
    begin
      LForm := MDIChildren[I];
      LForm.BringToFront;
      if LForm.Visible and LForm.Enabled then
        LForm.SetFocus;
      Exit;
    end;
  end;

  AFormClass.Create(Self).Show;
end;

procedure TViewPrincipal.ConsultarNegociacoesClick(Sender: TObject);
begin
  AbrirFormMDI(TViewConsultaNegociacoes);
end;

procedure TViewPrincipal.AlterarStatusClick(Sender: TObject);
begin
  AbrirFormMDI(TViewAlteracaoStatusNegociacao);
end;

procedure TViewPrincipal.NovaNegociacaoClick(Sender: TObject);
begin
  AbrirFormMDI(TViewManutencaoNegociacao);
end;

procedure TViewPrincipal.ProdutorClick(Sender: TObject);
begin
  AbrirFormMDI(TViewCadastroProdutorDetail);
end;

procedure TViewPrincipal.DistribuidorClick(Sender: TObject);
begin
  AbrirFormMDI(TViewCadastroDistribuidorDetail);
end;

procedure TViewPrincipal.ProdutoClick(Sender: TObject);
begin
  AbrirFormMDI(TViewCadastroProduto);
end;

procedure TViewPrincipal.SairClick(Sender: TObject);
begin
  Application.Terminate;
end;
end.

