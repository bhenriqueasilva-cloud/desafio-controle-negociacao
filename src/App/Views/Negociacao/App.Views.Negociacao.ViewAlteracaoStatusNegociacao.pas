unit App.Views.Negociacao.ViewAlteracaoStatusNegociacao;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Core.Entities.Negociacao,
  Core.Enums.TipoStatus,
  Infra.IoC.Container;

type
  TViewAlteracaoStatusNegociacao = class(TForm)
    pnlTitulo: TPanel;
    lblTitulo: TLabel;
    grpDados: TGroupBox;
    lblCodigo: TLabel;
    edtCodigo: TEdit;
    btnBuscar: TButton;
    grpStatus: TGroupBox;
    lblStatusAtual: TLabel;
    edtStatusAtual: TEdit;
    btnAprovar: TButton;
    btnConcluir: TButton;
    btnCancelar: TButton;
    btnFechar: TButton;
    procedure btnBuscarClick(Sender: TObject);
    procedure btnAprovarClick(Sender: TObject);
    procedure btnConcluirClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
  private

    FNegociacao: TNegociacao;
    function StatusToString(AStatus: TTipoStatus): string;
  public
    procedure CarregarNegociacaoPorId(AId: Integer);
  end;

var
  ViewAlteracaoStatusNegociacao: TViewAlteracaoStatusNegociacao;

implementation

{$R *.dfm}

uses
  Infra.CrossCutting.Validation.MessageValidation;

procedure TViewAlteracaoStatusNegociacao.CarregarNegociacaoPorId(AId: Integer);
begin
  edtCodigo.Text := IntToStr(AId);
  btnBuscar.Click;
end;

procedure TViewAlteracaoStatusNegociacao.btnBuscarClick(Sender: TObject);
var
  LCodigo: Integer;
begin
  if Trim(edtCodigo.Text) = '' then
  begin
    TMessageValidation.Aviso('Informe o código da negociação');
    Exit;
  end;
  try
    LCodigo := StrToInt(edtCodigo.Text);

    if Assigned(FNegociacao) then
      FreeAndNil(FNegociacao);

    FNegociacao := TIoCContainer.NegociacaoService.ObterPorId(LCodigo);
    if FNegociacao = nil then
    begin
      TMessageValidation.Aviso('Negociação não encontrada');
      edtStatusAtual.Text := '';
      Exit;
    end;
    edtStatusAtual.Text := StatusToString(FNegociacao.Status);
  except
    on E: Exception do
      TMessageValidation.Erro('Erro ao buscar negociação: ' + E.Message);
  end;
end;

procedure TViewAlteracaoStatusNegociacao.btnAprovarClick(Sender: TObject);
begin
  if FNegociacao = nil then
  begin
    TMessageValidation.Aviso('Busque uma negociação primeiro');
    Exit;
  end;

  try
    if TIoCContainer.NegociacaoService.AprovarNegociacao(FNegociacao.Id) then
    begin
      TMessageValidation.Aviso('Negociação aprovada com sucesso!');
      edtStatusAtual.Text := 'Aprovada';
    end;
  except
    on E: Exception do
      TMessageValidation.Erro('Erro ao aprovar negociação: ' + E.Message);
  end;
end;

procedure TViewAlteracaoStatusNegociacao.btnConcluirClick(Sender: TObject);
begin
  if FNegociacao = nil then
  begin
    TMessageValidation.Aviso('Busque uma negociação primeiro');
    Exit;
  end;

  try
    if TIoCContainer.NegociacaoService.ConcluirNegociacao(FNegociacao.Id) then
    begin
      TMessageValidation.Aviso('Negociação concluída com sucesso!');
      edtStatusAtual.Text := 'Concluída';
    end;
  except
    on E: Exception do
      TMessageValidation.Erro('Erro ao concluir negociação: ' + E.Message);
  end;
end;

procedure TViewAlteracaoStatusNegociacao.btnCancelarClick(Sender: TObject);
begin
  if FNegociacao = nil then
  begin
    TMessageValidation.Aviso('Busque uma negociação primeiro');
    Exit;
  end;

  try
    if TIoCContainer.NegociacaoService.CancelarNegociacao(FNegociacao.Id) then
    begin
      TMessageValidation.Aviso('Negociação cancelada com sucesso!');
      edtStatusAtual.Text := 'Cancelada';
    end;
  except
    on E: Exception do
      TMessageValidation.Erro('Erro ao cancelar negociação: ' + E.Message);
  end;
end;

procedure TViewAlteracaoStatusNegociacao.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TViewAlteracaoStatusNegociacao.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := Cafree;
end;

procedure TViewAlteracaoStatusNegociacao.FormDestroy(Sender: TObject);
begin
  if Assigned(FNegociacao) then
    FreeAndNil(FNegociacao);
end;

function TViewAlteracaoStatusNegociacao.StatusToString(AStatus: TTipoStatus): string;
begin
  case AStatus of
    tsPendente: Result := 'Pendente';
    tsAprovada: Result := 'Aprovada';
    tsConcluida: Result := 'Concluída';
    tsCancelada: Result := 'Cancelada';
  else
    Result := 'Desconhecido';
  end;
end;

end.
