unit Infra.Data.Firebird.NegociacaoItemRepositoryFB;

interface

uses
  System.Generics.Collections,
  Data.DB,
  Infra.Data.Interfaces.INegociacaoItemRepository,
  Infra.Data.Interfaces.IConnectionFactory,
  Core.Entities.NegociacaoItem,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async,
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TNegociacaoItemRepositoryFB = class(TInterfacedObject, INegociacaoItemRepository)
  private
    FConnectionFactory: IConnectionFactory;
    function QueryToEntity(AQuery: TFDQuery): TNegociacaoItem;
  public
    constructor Create(AConnectionFactory: IConnectionFactory);

    function Inserir(AItem: TNegociacaoItem): Boolean;
    function Atualizar(AItem: TNegociacaoItem): Boolean;
    function Excluir(AId: Integer): Boolean;
    function ObterPorId(AId: Integer): TNegociacaoItem;
    function ObterPorNegociacao(AIdNegociacao: Integer): TList<TNegociacaoItem>;
    function ExcluirPorNegociacao(AIdNegociacao: Integer): Boolean;
  end;

implementation

uses
  System.SysUtils;

constructor TNegociacaoItemRepositoryFB.Create(AConnectionFactory: IConnectionFactory);
begin
  inherited Create;
  FConnectionFactory := AConnectionFactory;
end;

function TNegociacaoItemRepositoryFB.QueryToEntity(AQuery: TFDQuery): TNegociacaoItem;
begin
  Result := TNegociacaoItem.Create;
  Result.Id := AQuery.FieldByName('ID').AsInteger;
  Result.IdNegociacao := AQuery.FieldByName('ID_NEGOCIACAO').AsInteger;
  Result.IdProduto := AQuery.FieldByName('ID_PRODUTO').AsInteger;
  Result.Quantidade := AQuery.FieldByName('QUANTIDADE').AsFloat;
  Result.PrecoUnitario := AQuery.FieldByName('PRECO_UNITARIO').AsCurrency;
  Result.ValorTotal := AQuery.FieldByName('VALOR_TOTAL').AsCurrency;
end;

function TNegociacaoItemRepositoryFB.Inserir(AItem: TNegociacaoItem): Boolean;
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
      LQuery.SQL.Text := 'INSERT INTO NEGOCIACAO_ITEM (ID_NEGOCIACAO, ID_PRODUTO, QUANTIDADE, PRECO_UNITARIO, VALOR_TOTAL) ' +
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

function TNegociacaoItemRepositoryFB.Atualizar(AItem: TNegociacaoItem): Boolean;
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
      LQuery.SQL.Text := 'UPDATE NEGOCIACAO_ITEM SET ID_PRODUTO = :ID_PRODUTO, QUANTIDADE = :QUANTIDADE, ' +
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

function TNegociacaoItemRepositoryFB.Excluir(AId: Integer): Boolean;
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
      LQuery.SQL.Text := 'DELETE FROM NEGOCIACAO_ITEM WHERE ID = :ID';
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

function TNegociacaoItemRepositoryFB.ObterPorId(AId: Integer): TNegociacaoItem;
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
      LQuery.SQL.Text := 'SELECT * FROM NEGOCIACAO_ITEM WHERE ID = :ID';
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

function TNegociacaoItemRepositoryFB.ObterPorNegociacao(AIdNegociacao: Integer): TList<TNegociacaoItem>;
var
  LQuery: TFDQuery;
  LConnection: TFDConnection;
begin
  Result := TList<TNegociacaoItem>.Create;
  LConnection := TFDConnection(FConnectionFactory.GetConnection);

  LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := LConnection;
    LConnection.StartTransaction;

    try
      LQuery.SQL.Text := 'SELECT * FROM NEGOCIACAO_ITEM WHERE ID_NEGOCIACAO = :ID_NEGOCIACAO ORDER BY ID';
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

function TNegociacaoItemRepositoryFB.ExcluirPorNegociacao(AIdNegociacao: Integer): Boolean;
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
      LQuery.SQL.Text := 'DELETE FROM NEGOCIACAO_ITEM WHERE ID_NEGOCIACAO = :ID_NEGOCIACAO';
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

