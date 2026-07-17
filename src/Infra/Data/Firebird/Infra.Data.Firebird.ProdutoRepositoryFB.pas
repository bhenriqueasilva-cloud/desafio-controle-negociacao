unit Infra.Data.Firebird.ProdutoRepositoryFB;

interface

uses
  System.Generics.Collections,
  Data.DB,
  Infra.Data.Interfaces.IProdutoRepository,
  Infra.Data.Interfaces.IConnectionFactory,
  Core.Entities.Produto,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async,
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TProdutoRepositoryFB = class(TInterfacedObject, IProdutoRepository)
  private
    FConnectionFactory: IConnectionFactory;
    function QueryToEntity(AQuery: TFDQuery): TProduto;
  public
    constructor Create(AConnectionFactory: IConnectionFactory);

    function Inserir(AProduto: TProduto): Boolean;
    function Atualizar(AProduto: TProduto): Boolean;
    function Excluir(AId: Integer): Boolean;
    function ObterPorId(AId: Integer): TProduto;
    function ObterTodos: TList<TProduto>;
    function ObterTodosPorDistribuidor(AIdDistribuidor: Integer): TList<TProduto>;
    function ObterPorNome(const ANome: string): TList<TProduto>;
  end;

implementation

uses
  System.SysUtils;

constructor TProdutoRepositoryFB.Create(AConnectionFactory: IConnectionFactory);
begin
  inherited Create;
  FConnectionFactory := AConnectionFactory;
end;

function TProdutoRepositoryFB.QueryToEntity(AQuery: TFDQuery): TProduto;
begin
  Result := TProduto.Create;
  Result.Id := AQuery.FieldByName('ID').AsInteger;
  Result.Nome := AQuery.FieldByName('NOME').AsString;
  Result.PrecoVenda := AQuery.FieldByName('PRECO_VENDA').AsCurrency;
end;

function TProdutoRepositoryFB.Inserir(AProduto: TProduto): Boolean;
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
      LQuery.SQL.Text := 'INSERT INTO PRODUTO (NOME, PRECO_VENDA) VALUES (:NOME, :PRECO_VENDA)';
      LQuery.ParamByName('NOME').AsString := AProduto.Nome;
      LQuery.ParamByName('PRECO_VENDA').AsCurrency := AProduto.PrecoVenda;
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

function TProdutoRepositoryFB.Atualizar(AProduto: TProduto): Boolean;
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
      LQuery.SQL.Text := 'UPDATE PRODUTO SET NOME = :NOME, PRECO_VENDA = :PRECO_VENDA WHERE ID = :ID';
      LQuery.ParamByName('NOME').AsString := AProduto.Nome;
      LQuery.ParamByName('PRECO_VENDA').AsCurrency := AProduto.PrecoVenda;
      LQuery.ParamByName('ID').AsInteger := AProduto.Id;
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

function TProdutoRepositoryFB.Excluir(AId: Integer): Boolean;
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
      LQuery.SQL.Text := 'DELETE FROM PRODUTO WHERE ID = :ID';
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

function TProdutoRepositoryFB.ObterPorId(AId: Integer): TProduto;
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
      LQuery.SQL.Text := 'SELECT ID, NOME, PRECO_VENDA FROM PRODUTO WHERE ID = :ID';
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

function TProdutoRepositoryFB.ObterTodos: TList<TProduto>;
var
  LQuery: TFDQuery;
  LConnection: TFDConnection;
begin
  Result := TList<TProduto>.Create;
  LConnection := TFDConnection(FConnectionFactory.GetConnection);

  LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := LConnection;
    LConnection.StartTransaction;

    try
      LQuery.SQL.Text := 'SELECT ID, NOME, PRECO_VENDA FROM PRODUTO ORDER BY ID';
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

function TProdutoRepositoryFB.ObterTodosPorDistribuidor(
  AIdDistribuidor: Integer): TList<TProduto>;
var
  LQuery: TFDQuery;
  LConnection: TFDConnection;
  LProduto: TProduto;
begin
  Result := TList<TProduto>.Create;
  LConnection := TFDConnection(FConnectionFactory.GetConnection);

  LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := LConnection;
    LConnection.StartTransaction;

    try
      LQuery.SQL.Text :=
        'SELECT p.ID, p.NOME, dp.VALOR_PRODUTO AS PRECO_VENDA ' +
        'FROM DISTRIBUIDOR_PRODUTO dp ' +
        'INNER JOIN PRODUTO p ON (p.ID = dp.ID_PRODUTO) ' +
        'WHERE dp.ID_DISTRIBUIDOR = :ID_DISTRIBUIDOR ' +
        'ORDER BY p.NOME';

      LQuery.ParamByName('ID_DISTRIBUIDOR').AsInteger := AIdDistribuidor;
      LQuery.Open;

      while not LQuery.Eof do
      begin
        LProduto := QueryToEntity(LQuery);

        LProduto.PrecoVenda := LQuery.FieldByName('PRECO_VENDA').AsCurrency;

        Result.Add(LProduto);

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

function TProdutoRepositoryFB.ObterPorNome(const ANome: string): TList<TProduto>;
var
  LQuery: TFDQuery;
  LConnection: TFDConnection;
begin
  Result := TList<TProduto>.Create;
  LConnection := TFDConnection(FConnectionFactory.GetConnection);

  LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := LConnection;
    LConnection.StartTransaction;

    try
      LQuery.SQL.Text := 'SELECT ID, NOME, PRECO_VENDA FROM PRODUTO WHERE NOME LIKE :NOME ORDER BY NOME';
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

end.

