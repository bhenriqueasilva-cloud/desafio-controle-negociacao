unit Infra.Data.Firebird.DistribuidorProdutoRepositoryFB;

interface

uses
  System.Generics.Collections,
  Data.DB,
  Infra.Data.Interfaces.IDistribuidorProdutoRepository,
  Infra.Data.Interfaces.IConnectionFactory,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async,
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TDistribuidorProdutoRepositoryFB = class(TInterfacedObject, IDistribuidorProdutoRepository)
  private
    FConnectionFactory: IConnectionFactory;
  public
    constructor Create(AConnectionFactory: IConnectionFactory);

    function Inserir(AIdDistribuidor, AIdProduto: Integer; AValorProduto: Currency): Boolean;
    function Atualizar(AId, AIdDistribuidor, AIdProduto: Integer; AValorProduto: Currency): Boolean;
    function Excluir(AIdDistribuidor, AIdProduto: Integer): Boolean;
    function ObterPorId(AId: Integer; out AValorProduto: Currency): Integer;
    function ObterPorDistribuidorProdutor(AIdDistribuidor, AIdProduto: Integer; out AValorProduto: Currency): Integer;
    function ObterTodosPorDistribuidor(AIdDistribuidor: Integer): TList<TRecordDistribuidorProduto>;
  end;

implementation

uses
  System.SysUtils;

constructor TDistribuidorProdutoRepositoryFB.Create(AConnectionFactory: IConnectionFactory);
begin
  inherited Create;
  FConnectionFactory := AConnectionFactory;
end;

function TDistribuidorProdutoRepositoryFB.Inserir(AIdDistribuidor, AIdProduto: Integer; AValorProduto: Currency): Boolean;
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
      LQuery.SQL.Text := 'INSERT INTO DISTRIBUIDOR_PRODUTO (ID_DISTRIBUIDOR, ID_PRODUTO, VALOR_PRODUTO) ' +
                         'VALUES (:ID_DISTRIBUIDOR, :ID_PRODUTO, :VALOR_PRODUTO)';
      LQuery.ParamByName('ID_DISTRIBUIDOR').AsInteger := AIdDistribuidor;
      LQuery.ParamByName('ID_PRODUTO').AsInteger := AIdProduto;
      LQuery.ParamByName('VALOR_PRODUTO').AsCurrency := AValorProduto;
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

function TDistribuidorProdutoRepositoryFB.Atualizar(AId, AIdDistribuidor, AIdProduto: Integer; AValorProduto: Currency): Boolean;
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
      LQuery.SQL.Text := 'UPDATE DISTRIBUIDOR_PRODUTO SET ID_DISTRIBUIDOR = :ID_DISTRIBUIDOR, ' +
                         'ID_PRODUTO = :ID_PRODUTO, VALOR_PRODUTO = :VALOR_PRODUTO WHERE ID = :ID';
      LQuery.ParamByName('ID_DISTRIBUIDOR').AsInteger := AIdDistribuidor;
      LQuery.ParamByName('ID_PRODUTO').AsInteger := AIdProduto;
      LQuery.ParamByName('VALOR_PRODUTO').AsCurrency := AValorProduto;
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

function TDistribuidorProdutoRepositoryFB.Excluir(AIdDistribuidor, AIdProduto: Integer): Boolean;
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
      LQuery.SQL.Text := 'DELETE FROM DISTRIBUIDOR_PRODUTO WHERE ID_DISTRIBUIDOR = :ID_DISTRIBUIDOR AND ID_PRODUTO = :ID_PRODUTO';
      LQuery.ParamByName('ID_DISTRIBUIDOR').AsInteger := AIdDistribuidor;
      LQuery.ParamByName('ID_PRODUTO').AsInteger := AIdProduto;
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

function TDistribuidorProdutoRepositoryFB.ObterPorId(AId: Integer; out AValorProduto: Currency): Integer;
var
  LQuery: TFDQuery;
  LConnection: TFDConnection;
begin
  Result := 0;
  AValorProduto := 0;
  LConnection := TFDConnection(FConnectionFactory.GetConnection);

  LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := LConnection;
    LConnection.StartTransaction;

    try
      LQuery.SQL.Text := 'SELECT ID_PRODUTO, VALOR_PRODUTO FROM DISTRIBUIDOR_PRODUTO WHERE ID = :ID';
      LQuery.ParamByName('ID').AsInteger := AId;
      LQuery.Open;

      if not LQuery.Eof then
      begin
        Result := LQuery.FieldByName('ID_PRODUTO').AsInteger;
        AValorProduto := LQuery.FieldByName('VALOR_PRODUTO').AsCurrency;
      end;

      LConnection.Commit;
    except
      LConnection.Rollback;
      raise;
    end;
  finally
    LQuery.Free;
  end;
end;

function TDistribuidorProdutoRepositoryFB.ObterPorDistribuidorProdutor(AIdDistribuidor, AIdProduto: Integer; out AValorProduto: Currency): Integer;
var
  LQuery: TFDQuery;
  LConnection: TFDConnection;
begin
  Result := 0;
  AValorProduto := 0;
  LConnection := TFDConnection(FConnectionFactory.GetConnection);

  LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := LConnection;
    LConnection.StartTransaction;

    try
      LQuery.SQL.Text := 'SELECT ID, VALOR_PRODUTO FROM DISTRIBUIDOR_PRODUTO ' +
                         'WHERE ID_DISTRIBUIDOR = :ID_DISTRIBUIDOR AND ID_PRODUTO = :ID_PRODUTO';
      LQuery.ParamByName('ID_DISTRIBUIDOR').AsInteger := AIdDistribuidor;
      LQuery.ParamByName('ID_PRODUTO').AsInteger := AIdProduto;
      LQuery.Open;

      if not LQuery.Eof then
      begin
        Result := LQuery.FieldByName('ID').AsInteger;
        AValorProduto := LQuery.FieldByName('VALOR_PRODUTO').AsCurrency;
      end;

      LConnection.Commit;
    except
      LConnection.Rollback;
      raise;
    end;
  finally
    LQuery.Free;
  end;
end;

function TDistribuidorProdutoRepositoryFB.ObterTodosPorDistribuidor(AIdDistribuidor: Integer): TList<TRecordDistribuidorProduto>;
var
  LQuery: TFDQuery;
  LConnection: TFDConnection;
  LRecord: TRecordDistribuidorProduto;
begin
  Result := TList<TRecordDistribuidorProduto>.Create;
  LConnection := TFDConnection(FConnectionFactory.GetConnection);

  LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := LConnection;
    LConnection.StartTransaction;

    try
      LQuery.SQL.Text := 'SELECT ID, ID_DISTRIBUIDOR, ID_PRODUTO, VALOR_PRODUTO FROM DISTRIBUIDOR_PRODUTO WHERE ID_DISTRIBUIDOR = :ID_DISTRIBUIDOR';
      LQuery.ParamByName('ID_DISTRIBUIDOR').AsInteger := AIdDistribuidor;
      LQuery.Open;

      while not LQuery.Eof do
      begin
        LRecord.Id := LQuery.FieldByName('ID').AsInteger;
        LRecord.IdDistribuidor := LQuery.FieldByName('ID_DISTRIBUIDOR').AsInteger;
        LRecord.IdProduto := LQuery.FieldByName('ID_PRODUTO').AsInteger;
        LRecord.ValorProduto := LQuery.FieldByName('VALOR_PRODUTO').AsCurrency;
        Result.Add(LRecord);
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

end.

