unit Infra.Data.Firebird.ItemNegociacaoRepositoryFB;

interface

uses
  System.Generics.Collections,
  Data.DB,
  Infra.Data.Interfaces.IItemNegociacaoRepository,
  Infra.Data.Interfaces.IConnectionFactory,
  Core.Entities.ItemNegociacao,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async,
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TItemNegociacaoRepositoryFB = class(TInterfacedObject, IItemNegociacaoRepository)
  private
    FConnectionFactory: IConnectionFactory;
    function QueryToEntity(AQuery: TFDQuery): TItemNegociacao;
  public
    constructor Create(AConnectionFactory: IConnectionFactory);

    function Inserir(AItem: TItemNegociacao): Boolean;
    function Atualizar(AItem: TItemNegociacao): Boolean;
    function Excluir(AId: Integer): Boolean;
    function ObterPorId(AId: Integer): TItemNegociacao;
    function ObterPorNegociacao(AIdNegociacao: Integer): TList<TItemNegociacao>;
    function ExcluirPorNegociacao(AIdNegociacao: Integer): Boolean;
  end;

implementation

uses
  System.SysUtils;

constructor TItemNegociacaoRepositoryFB.Create(AConnectionFactory: IConnectionFactory);
begin
  inherited Create;
  FConnectionFactory := AConnectionFactory;
end;

function TItemNegociacaoRepositoryFB.QueryToEntity(AQuery: TFDQuery): TItemNegociacao;
begin
  Result := TItemNegociacao.Create;
  Result.Id := AQuery.FieldByName('ID').AsInteger;
  Result.IdNegociacao := AQuery.FieldByName('ID_NEGOCIACAO').AsInteger;
  Result.IdProduto := AQuery.FieldByName('ID_PRODUTO').AsInteger;
  Result.Quantidade := AQuery.FieldByName('QUANTIDADE').AsFloat;
  Result.PrecoUnitario := AQuery.FieldByName('PRECO_UNITARIO').AsCurrency;
  Result.ValorTotal := AQuery.FieldByName('VALOR_TOTAL').AsCurrency;
end;

function TItemNegociacaoRepositoryFB.Inserir(AItem: TItemNegociacao): Boolean;
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
      LQuery.SQL.Text := 'INSERT INTO ITEM_NEGOCIACAO (ID_NEGOCIACAO, ID_PRODUTO, QUANTIDADE, PRECO_UNITARIO, VALOR_TOTAL) ' +
                         'VALUES (:ID_NEGOCIACAO, :ID_PRODUTO, :QUANTIDADE, :PRECO_UNITARIO, :VALOR_TOTAL)';
      LQuery.ParamByName('ID_NEGOCIACAO').AsInteger := AItem.IdNegociacao;
      LQuery.ParamByName('ID_PRODUTO').AsInteger := AItem.IdProduto;
      LQuery.ParamByName('QUANTIDADE').AsFloat := AItem.Quantidade;
      LQuery.ParamByName('PRECO_UNITARIO').AsCurrency := AItem.PrecoUnitario;
      LQuery.ParamByName('VALOR_TOTAL').AsCurrency := AItem.ValorTotal;
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

function TItemNegociacaoRepositoryFB.Atualizar(AItem: TItemNegociacao): Boolean;
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
      LQuery.SQL.Text := 'UPDATE ITEM_NEGOCIACAO SET ID_PRODUTO = :ID_PRODUTO, QUANTIDADE = :QUANTIDADE, ' +
                         'PRECO_UNITARIO = :PRECO_UNITARIO, VALOR_TOTAL = :VALOR_TOTAL WHERE ID = :ID';
      LQuery.ParamByName('ID_PRODUTO').AsInteger := AItem.IdProduto;
      LQuery.ParamByName('QUANTIDADE').AsFloat := AItem.Quantidade;
      LQuery.ParamByName('PRECO_UNITARIO').AsCurrency := AItem.PrecoUnitario;
      LQuery.ParamByName('VALOR_TOTAL').AsCurrency := AItem.ValorTotal;
      LQuery.ParamByName('ID').AsInteger := AItem.Id;
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

function TItemNegociacaoRepositoryFB.Excluir(AId: Integer): Boolean;
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
      LQuery.SQL.Text := 'DELETE FROM ITEM_NEGOCIACAO WHERE ID = :ID';
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

function TItemNegociacaoRepositoryFB.ObterPorId(AId: Integer): TItemNegociacao;
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
      LQuery.SQL.Text := 'SELECT * FROM ITEM_NEGOCIACAO WHERE ID = :ID';
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

function TItemNegociacaoRepositoryFB.ObterPorNegociacao(AIdNegociacao: Integer): TList<TItemNegociacao>;
var
  LQuery: TFDQuery;
  LConnection: TFDConnection;
begin
  Result := TList<TItemNegociacao>.Create;
  LConnection := TFDConnection(FConnectionFactory.GetConnection);

  LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := LConnection;
    LConnection.StartTransaction;

    try
      LQuery.SQL.Text := 'SELECT * FROM ITEM_NEGOCIACAO WHERE ID_NEGOCIACAO = :ID_NEGOCIACAO ORDER BY ID';
      LQuery.ParamByName('ID_NEGOCIACAO').AsInteger := AIdNegociacao;
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

function TItemNegociacaoRepositoryFB.ExcluirPorNegociacao(AIdNegociacao: Integer): Boolean;
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
      LQuery.SQL.Text := 'DELETE FROM ITEM_NEGOCIACAO WHERE ID_NEGOCIACAO = :ID_NEGOCIACAO';
      LQuery.ParamByName('ID_NEGOCIACAO').AsInteger := AIdNegociacao;
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

end.

