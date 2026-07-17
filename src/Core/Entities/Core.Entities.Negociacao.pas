unit Core.Entities.Negociacao;

interface

uses
  System.Generics.Collections,
  System.SysUtils,
  Core.Enums.TipoStatus,
  Core.Entities.NegociacaoItem,
  Core.Exceptions.ValidacaoException;

type
  TNegociacao = class
  private
    FId: Integer;
    FIdProdutor: Integer;
    FIdDistribuidor: Integer;
    FDataCadastro: TDateTime;
    FDataAprovacao: TDateTime;
    FDataConclusao: TDateTime;
    FDataCancelamento: TDateTime;
    FValorTotal: Currency;
    FStatus: TTipoStatus;
    FItens: TList<TNegociacaoItem>;
    procedure SetStatus(const AValue: TTipoStatus);
    procedure SetValorTotal(const AValue: Currency);
  public
    constructor Create;
    destructor Destroy; override;

    procedure Validar;
    procedure AdicionarItem(AItem: TNegociacaoItem);
    procedure RemoverItem(AItem: TNegociacaoItem);
    procedure CalcularValorTotal;
    procedure Aprovar;
    procedure Concluir;
    procedure Cancelar;
    function PodeAprovar: Boolean;
    function PodeConcluir: Boolean;
    function PodeCancelar: Boolean;

    property Id: Integer read FId write FId;
    property IdProdutor: Integer read FIdProdutor write FIdProdutor;
    property IdDistribuidor: Integer read FIdDistribuidor write FIdDistribuidor;
    property DataCadastro: TDateTime read FDataCadastro write FDataCadastro;
    property DataAprovacao: TDateTime read FDataAprovacao write FDataAprovacao;
    property DataConclusao: TDateTime read FDataConclusao write FDataConclusao;
    property DataCancelamento: TDateTime read FDataCancelamento write FDataCancelamento;
    property ValorTotal: Currency read FValorTotal write SetValorTotal;
    property Status: TTipoStatus read FStatus write SetStatus;
    property Itens: TList<TNegociacaoItem> read FItens;
  end;

implementation

constructor TNegociacao.Create;
begin
  inherited;
  FItens := TList<TNegociacaoItem>.Create;
  FStatus := tsPendente;
  FDataCadastro := Now;
end;

destructor TNegociacao.Destroy;
var
  LItem: TNegociacaoItem;
begin
  if Assigned(FItens) then
  begin
    for LItem in FItens do
      if Assigned(LItem) then
        LItem.Free;

    FItens.Free;
  end;
  inherited;
end;

procedure TNegociacao.SetStatus(const AValue: TTipoStatus);
begin
  FStatus := AValue;
end;

procedure TNegociacao.SetValorTotal(const AValue: Currency);
begin
  if AValue < 0 then
    raise EValidacaoException.Create('Valor total não pode ser negativo');
  FValorTotal := AValue;
end;

procedure TNegociacao.Validar;
begin
  if FIdProdutor <= 0 then
    raise EValidacaoException.Create('Produtor não informado');
  if FIdDistribuidor <= 0 then
    raise EValidacaoException.Create('Distribuidor não informado');
  if FItens.Count = 0 then
    raise EValidacaoException.Create('Negociação deve conter pelo menos um item');
  if FValorTotal <= 0 then
    raise EValidacaoException.Create('Valor total deve ser maior que zero');
end;

procedure TNegociacao.AdicionarItem(AItem: TNegociacaoItem);
begin
  if AItem = nil then
    raise EValidacaoException.Create('Item não pode ser nulo');
  FItens.Add(AItem);
  CalcularValorTotal;
end;

procedure TNegociacao.RemoverItem(AItem: TNegociacaoItem);
begin
  if not FItens.Contains(AItem) then
    raise EValidacaoException.Create('Item não encontrado na negociação');

  FItens.Remove(AItem);

  CalcularValorTotal;
end;

procedure TNegociacao.CalcularValorTotal;
var
  LItem: TNegociacaoItem;
begin
  FValorTotal := 0;
  for LItem in FItens do
    FValorTotal := FValorTotal + LItem.ValorTotal;
end;

procedure TNegociacao.Aprovar;
begin
  if not PodeAprovar then
    raise EValidacaoException.Create('Negociação não pode ser aprovada');
  FStatus := tsAprovada;
  FDataAprovacao := Now;
end;

procedure TNegociacao.Concluir;
begin
  if not PodeConcluir then
    raise EValidacaoException.Create('Negociação não pode ser concluída');
  FStatus := tsConcluida;
  FDataConclusao := Now;
end;

procedure TNegociacao.Cancelar;
begin
  if not PodeCancelar then
    raise EValidacaoException.Create('Negociação não pode ser cancelada');
  FStatus := tsCancelada;
  FDataCancelamento := Now;
end;

function TNegociacao.PodeAprovar: Boolean;
begin
  Result := (FStatus = tsPendente);
end;

function TNegociacao.PodeConcluir: Boolean;
begin
  Result := (FStatus = tsAprovada);
end;

function TNegociacao.PodeCancelar: Boolean;
begin
  Result := (FStatus = tsPendente) or (FStatus = tsAprovada);
end;

end.
