unit Infra.Data.Firebird.ProdutorRepositoryFB;

interface

uses
  System.Generics.Collections,
  Data.DB,
  Infra.Data.Interfaces.IProdutorRepository,
  Infra.Data.Interfaces.IConnectionFactory,
  Core.Entities.Produtor,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async,
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TProdutorRepositoryFB = class(TInterfacedObject, IProdutorRepository)
  private
    FConnectionFactory: IConnectionFactory;
    function QueryToEntity(AQuery: TFDQuery): TProdutor;
  public
    constructor Create(AConnectionFactory: IConnectionFactory);

    function Inserir(AProdutor: TProdutor): Boolean;
    function Atualizar(AProdutor: TProdutor): Boolean;
    function Excluir(AId: Integer): Boolean;
    function ObterPorId(AId: Integer): TProdutor;
    function ObterTodos: TList<TProdutor>;
    function ObterPorNome(const ANome: string): TList<TProdutor>;
    function ObterPorCpfCnpj(const ACpfCnpj: string): TProdutor;
  end;

implementation

uses
  System.SysUtils;

constructor TProdutorRepositoryFB.Create(AConnectionFactory: IConnectionFactory);
begin
  inherited Create;
  FConnectionFactory := AConnectionFactory;
end;

function TProdutorRepositoryFB.QueryToEntity(AQuery: TFDQuery): TProdutor;
begin
  Result := TProdutor.Create;
  Result.Id := AQuery.FieldByName('ID').AsInteger;
  Result.Nome := AQuery.FieldByName('NOME').AsString;
  Result.CpfCnpj := AQuery.FieldByName('CPF_CNPJ').AsString;
end;

function TProdutorRepositoryFB.Inserir(AProdutor: TProdutor): Boolean;
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
      LQuery.SQL.Text := 'INSERT INTO PRODUTOR (NOME, CPF_CNPJ) VALUES (:NOME, :CPF_CNPJ) RETURNING ID ';
      LQuery.ParamByName('NOME').AsString := AProdutor.Nome;
      LQuery.ParamByName('CPF_CNPJ').AsString := AProdutor.CpfCnpj;

      LQuery.Open;

      AProdutor.Id := LQuery.FieldByName('ID').AsInteger;

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

function TProdutorRepositoryFB.Atualizar(AProdutor: TProdutor): Boolean;
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
      LQuery.SQL.Text := 'UPDATE PRODUTOR SET NOME = :NOME, CPF_CNPJ = :CPF_CNPJ WHERE ID = :ID';
      LQuery.ParamByName('NOME').AsString := AProdutor.Nome;
      LQuery.ParamByName('CPF_CNPJ').AsString := AProdutor.CpfCnpj;
      LQuery.ParamByName('ID').AsInteger := AProdutor.Id;
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

function TProdutorRepositoryFB.Excluir(AId: Integer): Boolean;
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
      LQuery.SQL.Text := 'DELETE FROM PRODUTOR WHERE ID = :ID';
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

function TProdutorRepositoryFB.ObterPorId(AId: Integer): TProdutor;
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
      LQuery.SQL.Text := 'SELECT ID, NOME, CPF_CNPJ FROM PRODUTOR WHERE ID = :ID';
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

function TProdutorRepositoryFB.ObterTodos: TList<TProdutor>;
var
  LQuery: TFDQuery;
  LConnection: TFDConnection;
begin
  Result := TList<TProdutor>.Create;
  LConnection := TFDConnection(FConnectionFactory.GetConnection);

  LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := LConnection;
    LConnection.StartTransaction;
    try
      LQuery.SQL.Text := 'SELECT ID, NOME, CPF_CNPJ FROM PRODUTOR ORDER BY ID';
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

function TProdutorRepositoryFB.ObterPorNome(const ANome: string): TList<TProdutor>;
var
  LQuery: TFDQuery;
  LConnection: TFDConnection;
begin
  Result := TList<TProdutor>.Create;
  LConnection := TFDConnection(FConnectionFactory.GetConnection);

  LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := LConnection;
    LConnection.StartTransaction;
    try
      LQuery.SQL.Text := 'SELECT ID, NOME, CPF_CNPJ FROM PRODUTOR WHERE NOME LIKE :NOME ORDER BY NOME';
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

function TProdutorRepositoryFB.ObterPorCpfCnpj(const ACpfCnpj: string): TProdutor;
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
      LQuery.SQL.Text := 'SELECT ID, NOME, CPF_CNPJ FROM PRODUTOR WHERE CPF_CNPJ = :CPF_CNPJ';
      LQuery.ParamByName('CPF_CNPJ').AsString := ACpfCnpj;
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

