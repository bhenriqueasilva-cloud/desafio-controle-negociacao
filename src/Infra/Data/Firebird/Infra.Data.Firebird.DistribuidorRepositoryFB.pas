unit Infra.Data.Firebird.DistribuidorRepositoryFB;

interface

uses
  System.Generics.Collections,
  Data.DB,
  Infra.Data.Interfaces.IDistribuidorRepository,
  Infra.Data.Interfaces.IConnectionFactory,
  Core.Entities.Distribuidor,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async,
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TDistribuidorRepositoryFB = class(TInterfacedObject, IDistribuidorRepository)
  private
    FConnectionFactory: IConnectionFactory;
    function QueryToEntity(AQuery: TFDQuery): TDistribuidor;
  public
    constructor Create(AConnectionFactory: IConnectionFactory);

    function Inserir(ADistribuidor: TDistribuidor): Boolean;
    function Atualizar(ADistribuidor: TDistribuidor): Boolean;
    function Excluir(AId: Integer): Boolean;
    function ObterPorId(AId: Integer): TDistribuidor;
    function ObterTodos: TList<TDistribuidor>;
    function ObterTodosPorProdutor(AIdProdutor: Integer): TList<TDistribuidor>;
    function ObterPorNome(const ANome: string): TList<TDistribuidor>;
    function ObterPorCnpj(const ACnpj: string): TDistribuidor;
  end;

implementation

uses
  System.SysUtils;

constructor TDistribuidorRepositoryFB.Create(AConnectionFactory: IConnectionFactory);
begin
  inherited Create;
  FConnectionFactory := AConnectionFactory;
end;

function TDistribuidorRepositoryFB.QueryToEntity(AQuery: TFDQuery): TDistribuidor;
begin
  Result := TDistribuidor.Create;
  Result.Id := AQuery.FieldByName('ID').AsInteger;
  Result.Nome := AQuery.FieldByName('NOME').AsString;
  Result.Cnpj := AQuery.FieldByName('CNPJ').AsString;
end;

function TDistribuidorRepositoryFB.Inserir(ADistribuidor: TDistribuidor): Boolean;
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
      LQuery.SQL.Text := 'INSERT INTO DISTRIBUIDOR (NOME, CNPJ) VALUES (:NOME, :CNPJ) RETURNING ID ';
      LQuery.ParamByName('NOME').AsString := ADistribuidor.Nome;
      LQuery.ParamByName('CNPJ').AsString := ADistribuidor.Cnpj;

      LQuery.Open;

      ADistribuidor.Id := LQuery.FieldByName('ID').AsInteger;

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

function TDistribuidorRepositoryFB.Atualizar(ADistribuidor: TDistribuidor): Boolean;
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
      LQuery.SQL.Text := 'UPDATE DISTRIBUIDOR SET NOME = :NOME, CNPJ = :CNPJ WHERE ID = :ID';
      LQuery.ParamByName('NOME').AsString := ADistribuidor.Nome;
      LQuery.ParamByName('CNPJ').AsString := ADistribuidor.Cnpj;
      LQuery.ParamByName('ID').AsInteger := ADistribuidor.Id;
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

function TDistribuidorRepositoryFB.Excluir(AId: Integer): Boolean;
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
      LQuery.SQL.Text := 'DELETE FROM DISTRIBUIDOR WHERE ID = :ID';
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

function TDistribuidorRepositoryFB.ObterPorId(AId: Integer): TDistribuidor;
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
      LQuery.SQL.Text := 'SELECT ID, NOME, CNPJ FROM DISTRIBUIDOR WHERE ID = :ID';
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

function TDistribuidorRepositoryFB.ObterTodos: TList<TDistribuidor>;
var
  LQuery: TFDQuery;
  LConnection: TFDConnection;
begin
  Result := TList<TDistribuidor>.Create;
  LConnection := TFDConnection(FConnectionFactory.GetConnection);

  LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := LConnection;
    LConnection.StartTransaction;

    try
      LQuery.SQL.Text := 'SELECT ID, NOME, CNPJ FROM DISTRIBUIDOR ORDER BY ID';
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

function TDistribuidorRepositoryFB.ObterTodosPorProdutor(AIdProdutor: Integer): TList<TDistribuidor>;
var
  LQuery: TFDQuery;
  LConnection: TFDConnection;
begin
  Result := TList<TDistribuidor>.Create;
  LConnection := TFDConnection(FConnectionFactory.GetConnection);

  LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := LConnection;
    LConnection.StartTransaction;

    try
      LQuery.SQL.Text :=
        'SELECT d.ID, d.NOME, d.CNPJ ' +
        'FROM PRODUTOR_LIMITE_CREDITO plc ' +
        'INNER JOIN DISTRIBUIDOR d ON (d.ID = plc.ID_DISTRIBUIDOR) ' +
        'WHERE plc.ID_PRODUTOR = :ID_PRODUTOR ' +
        'ORDER BY d.ID';

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

function TDistribuidorRepositoryFB.ObterPorNome(const ANome: string): TList<TDistribuidor>;
var
  LQuery: TFDQuery;
  LConnection: TFDConnection;
begin
  Result := TList<TDistribuidor>.Create;
  LConnection := TFDConnection(FConnectionFactory.GetConnection);

  LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := LConnection;
    LConnection.StartTransaction;

    try
      LQuery.SQL.Text := 'SELECT ID, NOME, CNPJ FROM DISTRIBUIDOR WHERE NOME LIKE :NOME ORDER BY NOME';
      LQuery.ParamByName('NOME').AsString := '%' + UpperCase(ANome) + '%';
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

function TDistribuidorRepositoryFB.ObterPorCnpj(const ACnpj: string): TDistribuidor;
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
      LQuery.SQL.Text := 'SELECT ID, NOME, CNPJ FROM DISTRIBUIDOR WHERE CNPJ = :CNPJ';
      LQuery.ParamByName('CNPJ').AsString := ACnpj;
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

end.

