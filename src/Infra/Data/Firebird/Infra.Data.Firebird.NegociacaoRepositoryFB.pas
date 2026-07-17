unit Infra.Data.Firebird.NegociacaoRepositoryFB;

interface

uses
  System.Generics.Collections,
  Data.DB,
  Infra.Data.Interfaces.INegociacaoRepository,
  Infra.Data.Interfaces.IConnectionFactory,
  Core.Entities.Negociacao,
  Core.Enums.TipoStatus,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async,
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TNegociacaoRepositoryFB = class(TInterfacedObject, INegociacaoRepository)
  private
    FConnectionFactory: IConnectionFactory;
    function QueryToEntity(AQuery: TFDQuery): TNegociacao;
    function StatusToInteger(AStatus: TTipoStatus): Integer;
    function IntegerToStatus(AValue: Integer): TTipoStatus;
  public
    constructor Create(AConnectionFactory: IConnectionFactory);

    function Inserir(ANegociacao: TNegociacao): Boolean;
    function Atualizar(ANegociacao: TNegociacao): Boolean;
    function Excluir(AId: Integer): Boolean;
    function ObterPorId(AId: Integer): TNegociacao;
    function ObterTodos: TList<TNegociacao>;
    function ObterPorProdutor(AIdProdutor: Integer): TList<TNegociacao>;
    function ObterPorDistribuidor(AIdDistribuidor: Integer): TList<TNegociacao>;
    function ObterPorStatus(AStatus: Integer): TList<TNegociacao>;
    function ObterValorTotalAprovado(AIdProdutor, AIdDistribuidor: Integer): Currency;
  end;

implementation

uses
  System.SysUtils;

constructor TNegociacaoRepositoryFB.Create(AConnectionFactory: IConnectionFactory);
begin
  inherited Create;
  FConnectionFactory := AConnectionFactory;
end;

function TNegociacaoRepositoryFB.StatusToInteger(AStatus: TTipoStatus): Integer;
begin
  case AStatus of
    tsPendente: Result := 1;
    tsAprovada: Result := 2;
    tsConcluida: Result := 3;
    tsCancelada: Result := 4;
  else
    Result := 1;
  end;
end;

function TNegociacaoRepositoryFB.IntegerToStatus(AValue: Integer): TTipoStatus;
begin
  case AValue of
    1: Result := tsPendente;
    2: Result := tsAprovada;
    3: Result := tsConcluida;
    4: Result := tsCancelada;
  else
    Result := tsPendente;
  end;
end;

function TNegociacaoRepositoryFB.QueryToEntity(AQuery: TFDQuery): TNegociacao;
begin
  Result := TNegociacao.Create;
  Result.Id := AQuery.FieldByName('ID').AsInteger;
  Result.IdProdutor := AQuery.FieldByName('ID_PRODUTOR').AsInteger;
  Result.IdDistribuidor := AQuery.FieldByName('ID_DISTRIBUIDOR').AsInteger;
  Result.DataCadastro := AQuery.FieldByName('DATA_CADASTRO').AsDateTime;

  if not AQuery.FieldByName('DATA_APROVACAO').IsNull then
    Result.DataAprovacao := AQuery.FieldByName('DATA_APROVACAO').AsDateTime;

  if not AQuery.FieldByName('DATA_CONCLUSAO').IsNull then
    Result.DataConclusao := AQuery.FieldByName('DATA_CONCLUSAO').AsDateTime;

  if not AQuery.FieldByName('DATA_CANCELAMENTO').IsNull then
    Result.DataCancelamento := AQuery.FieldByName('DATA_CANCELAMENTO').AsDateTime;

  Result.ValorTotal := AQuery.FieldByName('VALOR_TOTAL').AsCurrency;
  Result.Status := IntegerToStatus(AQuery.FieldByName('STATUS').AsInteger);
end;

function TNegociacaoRepositoryFB.Inserir(ANegociacao: TNegociacao): Boolean;
var
  LQuery: TFDQuery;
  LConnection: TFDConnection;
begin
  LConnection := TFDConnection(FConnectionFactory.GetConnection);

  LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := LConnection;
    LConnection.StartTransaction;

    try
      LQuery.SQL.Text := 'INSERT INTO NEGOCIACAO (ID_PRODUTOR, ID_DISTRIBUIDOR, DATA_CADASTRO, ' +
                       'DATA_APROVACAO, DATA_CONCLUSAO, DATA_CANCELAMENTO, VALOR_TOTAL, STATUS) ' +
                       'VALUES (:ID_PRODUTOR, :ID_DISTRIBUIDOR, :DATA_CADASTRO, ' +
                       ':DATA_APROVACAO, :DATA_CONCLUSAO, :DATA_CANCELAMENTO, :VALOR_TOTAL, :STATUS) ' +
                       'RETURNING ID ';

      LQuery.ParamByName('ID_PRODUTOR').AsInteger := ANegociacao.IdProdutor;
      LQuery.ParamByName('ID_DISTRIBUIDOR').AsInteger := ANegociacao.IdDistribuidor;
      LQuery.ParamByName('DATA_CADASTRO').AsDateTime := ANegociacao.DataCadastro;

      if ANegociacao.DataAprovacao > 0 then
        LQuery.ParamByName('DATA_APROVACAO').AsDateTime := ANegociacao.DataAprovacao
      else
        LQuery.ParamByName('DATA_APROVACAO').Clear;

      if ANegociacao.DataConclusao > 0 then
        LQuery.ParamByName('DATA_CONCLUSAO').AsDateTime := ANegociacao.DataConclusao
      else
        LQuery.ParamByName('DATA_CONCLUSAO').Clear;

      if ANegociacao.DataCancelamento > 0 then
        LQuery.ParamByName('DATA_CANCELAMENTO').AsDateTime := ANegociacao.DataCancelamento
      else
        LQuery.ParamByName('DATA_CANCELAMENTO').Clear;

      LQuery.ParamByName('VALOR_TOTAL').AsCurrency := ANegociacao.ValorTotal;
      LQuery.ParamByName('STATUS').AsInteger := StatusToInteger(ANegociacao.Status);

      LQuery.Open;

      ANegociacao.Id := LQuery.FieldByName('ID').AsInteger;

      LConnection.Commit;
      Result := True;
    except
      LConnection.Rollback;
      raise;
    end;
  finally
    LQuery.Free;
  end;
end;
function TNegociacaoRepositoryFB.Atualizar(ANegociacao: TNegociacao): Boolean;
var
  LQuery: TFDQuery;
  LConnection: TFDConnection;
begin
  LConnection := TFDConnection(FConnectionFactory.GetConnection);

  LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := LConnection;
    LConnection.StartTransaction;

    try
      LQuery.SQL.Text := 'UPDATE NEGOCIACAO SET ID_PRODUTOR = :ID_PRODUTOR, ID_DISTRIBUIDOR = :ID_DISTRIBUIDOR, ' +
                       'DATA_APROVACAO = :DATA_APROVACAO, DATA_CONCLUSAO = :DATA_CONCLUSAO, ' +
                       'DATA_CANCELAMENTO = :DATA_CANCELAMENTO, VALOR_TOTAL = :VALOR_TOTAL, STATUS = :STATUS ' +
                       'WHERE ID = :ID';
      LQuery.ParamByName('ID_PRODUTOR').AsInteger := ANegociacao.IdProdutor;
      LQuery.ParamByName('ID_DISTRIBUIDOR').AsInteger := ANegociacao.IdDistribuidor;

      if ANegociacao.DataAprovacao > 0 then
        LQuery.ParamByName('DATA_APROVACAO').AsDateTime := ANegociacao.DataAprovacao
      else
        LQuery.ParamByName('DATA_APROVACAO').Clear;

      if ANegociacao.DataConclusao > 0 then
        LQuery.ParamByName('DATA_CONCLUSAO').AsDateTime := ANegociacao.DataConclusao
      else
        LQuery.ParamByName('DATA_CONCLUSAO').Clear;

      if ANegociacao.DataCancelamento > 0 then
        LQuery.ParamByName('DATA_CANCELAMENTO').AsDateTime := ANegociacao.DataCancelamento
      else
        LQuery.ParamByName('DATA_CANCELAMENTO').Clear;

      LQuery.ParamByName('VALOR_TOTAL').AsCurrency := ANegociacao.ValorTotal;
      LQuery.ParamByName('STATUS').AsInteger := StatusToInteger(ANegociacao.Status);
      LQuery.ParamByName('ID').AsInteger := ANegociacao.Id;
      LQuery.ExecSQL;

      LConnection.Commit;
      Result := True;
    except
      LConnection.Rollback;
      raise;
    end;
  finally
    LQuery.Free;
  end;
end;

function TNegociacaoRepositoryFB.Excluir(AId: Integer): Boolean;
var
  LQuery: TFDQuery;
  LConnection: TFDConnection;
begin
  LConnection := TFDConnection(FConnectionFactory.GetConnection);

  LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := LConnection;
    LConnection.StartTransaction;

    try
      LQuery.SQL.Text := 'DELETE FROM NEGOCIACAO WHERE ID = :ID';
      LQuery.ParamByName('ID').AsInteger := AId;
      LQuery.ExecSQL;

      LConnection.Commit;
      Result := True;
    except
      LConnection.Rollback;
      raise;
    end;
  finally
    LQuery.Free;
  end;
end;

function TNegociacaoRepositoryFB.ObterPorId(AId: Integer): TNegociacao;
var
  LQuery: TFDQuery;
  LConnection: TFDConnection;
begin
  Result := nil;
  LConnection := TFDConnection(FConnectionFactory.GetConnection);

  LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := LConnection;
    LConnection.StartTransaction;

    try
      LQuery.SQL.Text := 'SELECT ID, ID_PRODUTOR, ID_DISTRIBUIDOR, DATA_CADASTRO, ' +
        ' DATA_APROVACAO, DATA_CONCLUSAO, DATA_CANCELAMENTO, VALOR_TOTAL, STATUS FROM ' +
        ' NEGOCIACAO WHERE ID = :ID';
      LQuery.ParamByName('ID').AsInteger := AId;
      LQuery.Open;

      if not LQuery.Eof then
        Result := QueryToEntity(LQuery);

      LConnection.Commit;
    except
      LConnection.Rollback;
      raise;
    end;
  finally
    LQuery.Free;
  end;
end;

function TNegociacaoRepositoryFB.ObterTodos: TList<TNegociacao>;
var
  LQuery: TFDQuery;
  LConnection: TFDConnection;
begin
  Result := TList<TNegociacao>.Create;
  LConnection := TFDConnection(FConnectionFactory.GetConnection);

  LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := LConnection;
    LConnection.StartTransaction;

    try
      LQuery.SQL.Text := 'SELECT ID, ID_PRODUTOR, ID_DISTRIBUIDOR, DATA_CADASTRO, ' +
        ' DATA_APROVACAO, DATA_CONCLUSAO, DATA_CANCELAMENTO, VALOR_TOTAL, STATUS ' +
        ' FROM NEGOCIACAO ORDER BY DATA_CADASTRO DESC';
      LQuery.Open;

      while not LQuery.Eof do
      begin
        Result.Add(QueryToEntity(LQuery));
        LQuery.Next;
      end;

      LConnection.Commit;
    except
      LConnection.Rollback;
      Result.Free;
      raise;
    end;
  finally
    LQuery.Free;
  end;
end;

function TNegociacaoRepositoryFB.ObterPorProdutor(AIdProdutor: Integer): TList<TNegociacao>;
var
  LQuery: TFDQuery;
  LConnection: TFDConnection;
begin
  Result := TList<TNegociacao>.Create;
  LConnection := TFDConnection(FConnectionFactory.GetConnection);

  LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := LConnection;
    LConnection.StartTransaction;

    try
      LQuery.SQL.Text := 'SELECT ID, ID_PRODUTOR, ID_DISTRIBUIDOR, DATA_CADASTRO, ' +
      ' DATA_APROVACAO, DATA_CONCLUSAO, DATA_CANCELAMENTO, VALOR_TOTAL, STATUS ' +
      ' FROM NEGOCIACAO WHERE ID_PRODUTOR = :ID_PRODUTOR ORDER BY DATA_CADASTRO DESC';
      LQuery.ParamByName('ID_PRODUTOR').AsInteger := AIdProdutor;
      LQuery.Open;

      while not LQuery.Eof do
      begin
        Result.Add(QueryToEntity(LQuery));
        LQuery.Next;
      end;

      LConnection.Commit;
    except
      LConnection.Rollback;
      Result.Free;
      raise;
    end;
  finally
    LQuery.Free;
  end;
end;

function TNegociacaoRepositoryFB.ObterPorDistribuidor(AIdDistribuidor: Integer): TList<TNegociacao>;
var
  LQuery: TFDQuery;
  LConnection: TFDConnection;
begin
  Result := TList<TNegociacao>.Create;
  LConnection := TFDConnection(FConnectionFactory.GetConnection);

  LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := LConnection;
    LConnection.StartTransaction;

    try
      LQuery.SQL.Text := 'SELECT ID, ID_PRODUTOR, ID_DISTRIBUIDOR, DATA_CADASTRO, ' +
      ' DATA_APROVACAO, DATA_CONCLUSAO, DATA_CANCELAMENTO, VALOR_TOTAL, STATUS '  +
      ' FROM NEGOCIACAO WHERE ID_DISTRIBUIDOR = :ID_DISTRIBUIDOR ORDER BY DATA_CADASTRO DESC';
      LQuery.ParamByName('ID_DISTRIBUIDOR').AsInteger := AIdDistribuidor;
      LQuery.Open;

      while not LQuery.Eof do
      begin
        Result.Add(QueryToEntity(LQuery));
        LQuery.Next;
      end;

      LConnection.Commit;
    except
      LConnection.Rollback;
      Result.Free;
      raise;
    end;
  finally
    LQuery.Free;
  end;
end;

function TNegociacaoRepositoryFB.ObterPorStatus(AStatus: Integer): TList<TNegociacao>;
var
  LQuery: TFDQuery;
  LConnection: TFDConnection;
begin
  Result := TList<TNegociacao>.Create;
  LConnection := TFDConnection(FConnectionFactory.GetConnection);

  LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := LConnection;
    LConnection.StartTransaction;

    try
      LQuery.SQL.Text := 'SELECT ID, ID_PRODUTOR, ID_DISTRIBUIDOR, DATA_CADASTRO, ' +
      ' DATA_APROVACAO, DATA_CONCLUSAO, DATA_CANCELAMENTO, VALOR_TOTAL, STATUS ' +
      ' FROM NEGOCIACAO WHERE STATUS = :STATUS ORDER BY DATA_CADASTRO DESC';
      LQuery.ParamByName('STATUS').AsInteger := AStatus;
      LQuery.Open;

      while not LQuery.Eof do
      begin
        Result.Add(QueryToEntity(LQuery));
        LQuery.Next;
      end;

      LConnection.Commit;
    except
      LConnection.Rollback;
      Result.Free;
      raise;
    end;
  finally
    LQuery.Free;
  end;
end;

function TNegociacaoRepositoryFB.ObterValorTotalAprovado(AIdProdutor, AIdDistribuidor: Integer): Currency;
var
  LQuery: TFDQuery;
  LConnection: TFDConnection;
begin
  Result := 0;
  LConnection := TFDConnection(FConnectionFactory.GetConnection);

  LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := LConnection;
    LConnection.StartTransaction;

    try
      LQuery.SQL.Text := 'SELECT COALESCE(SUM(VALOR_TOTAL), 0) AS TOTAL FROM NEGOCIACAO ' +
                       'WHERE ID_PRODUTOR = :ID_PRODUTOR AND ID_DISTRIBUIDOR = :ID_DISTRIBUIDOR AND STATUS = 2';
      LQuery.ParamByName('ID_PRODUTOR').AsInteger := AIdProdutor;
      LQuery.ParamByName('ID_DISTRIBUIDOR').AsInteger := AIdDistribuidor;
      LQuery.Open;

      if not LQuery.Eof then
        Result := LQuery.FieldByName('TOTAL').AsCurrency;

      LConnection.Commit;
    except
      LConnection.Rollback;
      raise;
    end;
  finally
    LQuery.Free;
  end;
end;

end.

