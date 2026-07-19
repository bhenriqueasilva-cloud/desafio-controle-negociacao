unit Infra.Data.Firebird.ProdutorLimiteCreditoRepositoryFB;

interface

uses
  System.Generics.Collections,
  Data.DB,
  Infra.Data.Interfaces.IProdutorLimiteCreditoRepository,
  Infra.Data.Interfaces.IConnectionFactory,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async,
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TProdutorLimiteCreditoRepositoryFB = class(TInterfacedObject, IProdutorLimiteCreditoRepository)
  private
    FConnectionFactory: IConnectionFactory;
  public
    constructor Create(AConnectionFactory: IConnectionFactory);

    function Inserir(AIdProdutor, AIdDistribuidor: Integer; AValor: Currency): Boolean;
    function Atualizar(AIdProdutor, AIdDistribuidor: Integer; AValor: Currency): Boolean;
    function Excluir(AIdProdutor, AIdDistribuidor: Integer): Boolean;
    function ObterPorId(AId: Integer): Currency;
    function ObterLimite(AIdProdutor, AIdDistribuidor: Integer; out AValorLimite: Currency): Integer;
    function ObterTodosPorProdutor(AIdProdutor: Integer): TList<TPair<Integer, Currency>>;
    function PossuiDistribuidores(AIdProdutor: Integer): Boolean;
  end;

implementation

uses
  System.SysUtils;

constructor TProdutorLimiteCreditoRepositoryFB.Create(AConnectionFactory: IConnectionFactory);
begin
  inherited Create;
  FConnectionFactory := AConnectionFactory;
end;

function TProdutorLimiteCreditoRepositoryFB.Inserir(AIdProdutor, AIdDistribuidor: Integer; AValor: Currency): Boolean;
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
      LQuery.SQL.Text := 'INSERT INTO PRODUTOR_LIMITE_CREDITO (ID_PRODUTOR, ID_DISTRIBUIDOR, VALOR_LIMITE) VALUES (:ID_PRODUTOR, :ID_DISTRIBUIDOR, :VALOR_LIMITE)';
      LQuery.ParamByName('ID_PRODUTOR').AsInteger := AIdProdutor;
      LQuery.ParamByName('ID_DISTRIBUIDOR').AsInteger := AIdDistribuidor;
      LQuery.ParamByName('VALOR_LIMITE').AsCurrency := AValor;
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

function TProdutorLimiteCreditoRepositoryFB.Atualizar(AIdProdutor, AIdDistribuidor: Integer; AValor: Currency): Boolean;
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
      LQuery.SQL.Text := 'UPDATE PRODUTOR_LIMITE_CREDITO SET VALOR_LIMITE = :VALOR_LIMITE WHERE ID_PRODUTOR = :ID_PRODUTOR AND ID_DISTRIBUIDOR = :ID_DISTRIBUIDOR';
      LQuery.ParamByName('VALOR_LIMITE').AsCurrency := AValor;
      LQuery.ParamByName('ID_PRODUTOR').AsInteger := AIdProdutor;
      LQuery.ParamByName('ID_DISTRIBUIDOR').AsInteger := AIdDistribuidor;
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

function TProdutorLimiteCreditoRepositoryFB.Excluir(AIdProdutor, AIdDistribuidor: Integer): Boolean;
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
      LQuery.SQL.Text := 'DELETE FROM PRODUTOR_LIMITE_CREDITO WHERE ID_PRODUTOR = :ID_PRODUTOR AND ID_DISTRIBUIDOR = :ID_DISTRIBUIDOR';
      LQuery.ParamByName('ID_PRODUTOR').AsInteger := AIdProdutor;
      LQuery.ParamByName('ID_DISTRIBUIDOR').AsInteger := AIdDistribuidor;
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

function TProdutorLimiteCreditoRepositoryFB.ObterPorId(AId: Integer): Currency;
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
      LQuery.SQL.Text := 'SELECT VALOR_LIMITE FROM PRODUTOR_LIMITE_CREDITO WHERE ID = :ID';
      LQuery.ParamByName('ID').AsInteger := AId;
      LQuery.Open;

      if not LQuery.Eof then
        Result := LQuery.FieldByName('VALOR_LIMITE').AsCurrency;

      LConnection.Commit;
    except
      LConnection.Rollback;
      raise;
    end;
  finally
    LQuery.Free;
  end;
end;

function TProdutorLimiteCreditoRepositoryFB.ObterLimite(AIdProdutor, AIdDistribuidor: Integer;
  out AValorLimite: Currency): Integer;
var
  LQuery: TFDQuery;
  LConnection: TFDConnection;
begin
  Result := 0;
  AValorLimite := 0;

  LConnection := TFDConnection(FConnectionFactory.GetConnection);
  LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := LConnection;
    LConnection.StartTransaction;
    try
      LQuery.SQL.Text := 'SELECT ID, VALOR_LIMITE FROM PRODUTOR_LIMITE_CREDITO ' +
                         'WHERE ID_PRODUTOR = :ID_PRODUTOR AND ID_DISTRIBUIDOR = :ID_DISTRIBUIDOR';

      LQuery.ParamByName('ID_PRODUTOR').AsInteger := AIdProdutor;
      LQuery.ParamByName('ID_DISTRIBUIDOR').AsInteger := AIdDistribuidor;
      LQuery.Open;

      if not LQuery.Eof then
      begin
        Result := LQuery.FieldByName('ID').AsInteger;
        AValorLimite := LQuery.FieldByName('VALOR_LIMITE').AsCurrency;
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

function TProdutorLimiteCreditoRepositoryFB.ObterTodosPorProdutor(AIdProdutor: Integer): TList<TPair<Integer, Currency>>;
var
  LQuery: TFDQuery;
  LConnection: TFDConnection;
  LPair: TPair<Integer, Currency>;
begin
  Result := TList<TPair<Integer, Currency>>.Create;
  LConnection := TFDConnection(FConnectionFactory.GetConnection);

  LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := LConnection;
    LConnection.StartTransaction;

    try
      LQuery.SQL.Text := 'SELECT ID_DISTRIBUIDOR, VALOR_LIMITE FROM PRODUTOR_LIMITE_CREDITO WHERE ID_PRODUTOR = :ID_PRODUTOR';
      LQuery.ParamByName('ID_PRODUTOR').AsInteger := AIdProdutor;
      LQuery.Open;

      while not LQuery.Eof do
      begin
        LPair.Key := LQuery.FieldByName('ID_DISTRIBUIDOR').AsInteger;
        LPair.Value := LQuery.FieldByName('VALOR_LIMITE').AsCurrency;
        Result.Add(LPair);
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

function TProdutorLimiteCreditoRepositoryFB.PossuiDistribuidores(AIdProdutor: Integer): Boolean;
var
  LQuery: TFDQuery;
  LConnection: TFDConnection;
begin
  Result := False;
  LConnection := TFDConnection(FConnectionFactory.GetConnection);

  LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := LConnection;
    LConnection.StartTransaction;

    try
      LQuery.SQL.Text := 'SELECT COUNT(*) AS TOTAL FROM PRODUTOR_LIMITE_CREDITO WHERE ID_PRODUTOR = :ID_PRODUTOR';
      LQuery.ParamByName('ID_PRODUTOR').AsInteger := AIdProdutor;
      LQuery.Open;

      if not LQuery.Eof then
        Result := LQuery.FieldByName('TOTAL').AsInteger > 0;

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

