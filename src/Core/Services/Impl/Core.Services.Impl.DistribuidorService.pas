unit Core.Services.Impl.DistribuidorService;

interface

uses
  System.Generics.Collections,
  Core.Services.Interfaces.IDistribuidorService,
  Core.Entities.Distribuidor,
  Infra.Data.Interfaces.IDistribuidorRepository,
  Infra.Data.Interfaces.IDistribuidorProdutoRepository,
  Infra.CrossCutting.Validation.CNPJValidator;

type
  TDistribuidorService = class(TInterfacedObject, IDistribuidorService)
  private
    FDistribuidorRepository: IDistribuidorRepository;
    FDistribuidorProdutoRepository: IDistribuidorProdutoRepository;
    procedure ValidarDocumento(var ACnpj: string);
  public
    constructor Create(ADistribuidorRepository: IDistribuidorRepository;
      ADistribuidorProdutoRepository: IDistribuidorProdutoRepository);
    destructor Destroy; override;
    function Salvar(ADistribuidor: TDistribuidor): Boolean;
    function Atualizar(ADistribuidor: TDistribuidor): Boolean;
    function Excluir(AId: Integer): Boolean;
    function ObterPorId(AId: Integer): TDistribuidor;
    function ObterTodos: TList<TDistribuidor>;
    function ObterPorNome(const ANome: string): TList<TDistribuidor>;
    function ObterPorCnpj(const ACnpj: string): TDistribuidor;
    function ObterTodosPorProdutor(AIdProdutor: Integer): TList<TDistribuidor>;
    function ObterDistribuidorProdutos(AIdDistribuidor, AIdProduto: Integer; out AValorProduto: Currency) : Integer;
    function AtualizarDistribuidorProdutos(AId, AIdDistribuidor, AIdProduto: Integer; AValorProduto: Currency) : Boolean;
    function SalvarDistribuidorProdutos(AIdDistribuidor, AIdProduto: Integer ; AValorProduto: Currency) : Boolean;
    function ExcluirDistribuidorProduto(AIdDistribuidor, AIdProduto: Integer): Boolean;
  end;

implementation

uses
  System.SysUtils;

constructor TDistribuidorService.Create(ADistribuidorRepository: IDistribuidorRepository;
  ADistribuidorProdutoRepository: IDistribuidorProdutoRepository);
begin
  inherited Create;
  FDistribuidorRepository := ADistribuidorRepository;
  FDistribuidorProdutoRepository := ADistribuidorProdutoRepository;
end;

destructor TDistribuidorService.Destroy;
begin
  inherited;
end;

procedure TDistribuidorService.ValidarDocumento(var ACnpj: string);
var
  LTextoLimpo: string;
  I: Integer;
begin
  LTextoLimpo := '';
  for I := 1 to Length(ACnpj) do
  begin
    if CharInSet(ACnpj[I], ['0'..'9']) then
      LTextoLimpo := LTextoLimpo + ACnpj[I];
  end;

  if not TCNPJValidator.Validar(LTextoLimpo) then
    raise Exception.Create('CNPJ inválido.');

  ACnpj := LTextoLimpo;
end;

function TDistribuidorService.Salvar(ADistribuidor: TDistribuidor): Boolean;
var
  LCnpjLimpo: string;
begin
  ADistribuidor.Validar;
  LCnpjLimpo := ADistribuidor.Cnpj;
  ValidarDocumento(LCnpjLimpo);
  ADistribuidor.Cnpj := LCnpjLimpo;
  Result := FDistribuidorRepository.Inserir(ADistribuidor);
end;

function TDistribuidorService.Atualizar(ADistribuidor: TDistribuidor): Boolean;
var
  LCnpjLimpo: string;
begin
  ADistribuidor.Validar;
  LCnpjLimpo := ADistribuidor.Cnpj;
  ValidarDocumento(LCnpjLimpo);
  ADistribuidor.Cnpj := LCnpjLimpo;
  Result := FDistribuidorRepository.Atualizar(ADistribuidor);
end;

function TDistribuidorService.Excluir(AId: Integer): Boolean;
begin
  Result := FDistribuidorRepository.Excluir(AId);
end;

function TDistribuidorService.ObterPorId(AId: Integer): TDistribuidor;
begin
  Result := FDistribuidorRepository.ObterPorId(AId);
end;

function TDistribuidorService.ObterTodos: TList<TDistribuidor>;
begin
  Result := FDistribuidorRepository.ObterTodos;
end;

function TDistribuidorService.ObterTodosPorProdutor(AIdProdutor: Integer): TList<TDistribuidor>;
begin
  Result := FDistribuidorRepository.ObterTodosPorProdutor(AIdProdutor);
end;

function TDistribuidorService.ObterPorNome(const ANome: string): TList<TDistribuidor>;
begin
  Result := FDistribuidorRepository.ObterPorNome(ANome);
end;

function TDistribuidorService.ObterPorCnpj(const ACnpj: string): TDistribuidor;
begin
  Result := FDistribuidorRepository.ObterPorCnpj(ACnpj);
end;

function TDistribuidorService.ObterDistribuidorProdutos(AIdDistribuidor, AIdProduto: Integer; out AValorProduto: Currency): Integer;
begin
  Result := FDistribuidorProdutoRepository.ObterPorDistribuidorProdutor(AIdDistribuidor, AIdProduto, AValorProduto);
end;

function TDistribuidorService.AtualizarDistribuidorProdutos(AId, AIdDistribuidor, AIdProduto: Integer; AValorProduto: Currency): Boolean;
begin
  Result := FDistribuidorProdutoRepository.Atualizar(AId, AIdDistribuidor, AIdProduto, AValorProduto);
end;

function TDistribuidorService.SalvarDistribuidorProdutos(AIdDistribuidor, AIdProduto: Integer; AValorProduto: Currency): Boolean;
begin
  Result := FDistribuidorProdutoRepository.Inserir(AIdDistribuidor, AIdProduto, AValorProduto);
end;

function TDistribuidorService.ExcluirDistribuidorProduto(AIdDistribuidor, AIdProduto: Integer): Boolean;
begin
  Result := FDistribuidorProdutoRepository.Excluir(AIdDistribuidor, AIdProduto);
end;

end.

