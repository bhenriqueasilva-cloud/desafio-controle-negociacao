unit Infra.IoC.Container;

interface

uses
  Infra.Data.Interfaces.IConnectionFactory,
  Infra.Data.Interfaces.IProdutorRepository,
  Infra.Data.Interfaces.IDistribuidorRepository,
  Infra.Data.Interfaces.IDistribuidorProdutoRepository,
  Infra.Data.Interfaces.IProdutoRepository,
  Infra.Data.Interfaces.INegociacaoRepository,
  Infra.Data.Interfaces.INegociacaoItemRepository,
  Infra.Data.Interfaces.IProdutorLimiteCreditoRepository,
  Infra.CrossCutting.Configuration.DatabaseConfig,
  Core.Services.Interfaces.IProdutorService,
  Core.Services.Interfaces.IDistribuidorService,
  Core.Services.Interfaces.IProdutoService,
  Core.Services.Interfaces.INegociacaoService,
  Core.Services.Interfaces.IValidacaoCreditoService;

type
  TIoCContainer = class
  private
    class var FInstance: TIoCContainer;
    class var FDatabaseConfig: TDatabaseConfig;
    class var FConnectionFactory: IConnectionFactory;
    class var FProdutorRepository: IProdutorRepository;
    class var FDistribuidorRepository: IDistribuidorRepository;
    class var FDistribuidorProdutoRepository: IDistribuidorProdutoRepository;
    class var FProdutoRepository: IProdutoRepository;
    class var FNegociacaoRepository: INegociacaoRepository;
    class var FNegociacaoItemRepository: INegociacaoItemRepository;
    class var FProdutorLimiteCreditoRepository: IProdutorLimiteCreditoRepository;
    class var FProdutorService: IProdutorService;
    class var FDistribuidorService: IDistribuidorService;
    class var FProdutoService: IProdutoService;
    class var FNegociacaoService: INegociacaoService;
    class var FValidacaoCreditoService: IValidacaoCreditoService;
    class procedure InitializeConnection;
  public
    class function GetInstance: TIoCContainer;
    class procedure RegisterServices;
    class procedure Initialize;
    class procedure Uninitialize;
    class property ConnectionFactory: IConnectionFactory read FConnectionFactory;
    class property ProdutorRepository: IProdutorRepository read FProdutorRepository;
    class property DistribuidorRepository: IDistribuidorRepository read FDistribuidorRepository;
    class property DistribuidorProdutoRepository: IDistribuidorProdutoRepository read FDistribuidorProdutoRepository;
    class property ProdutoRepository: IProdutoRepository read FProdutoRepository;
    class property NegociacaoRepository: INegociacaoRepository read FNegociacaoRepository;
    class property NegociacaoItemRepository: INegociacaoItemRepository read FNegociacaoItemRepository;
    class property ProdutorLimiteCreditoRepository: IProdutorLimiteCreditoRepository read FProdutorLimiteCreditoRepository;
    class property ProdutorService: IProdutorService read FProdutorService;
    class property DistribuidorService: IDistribuidorService read FDistribuidorService;
    class property ProdutoService: IProdutoService read FProdutoService;
    class property NegociacaoService: INegociacaoService read FNegociacaoService;
    class property ValidacaoCreditoService: IValidacaoCreditoService read FValidacaoCreditoService;
  end;

implementation

uses
  System.SysUtils,
  Infra.Data.Firebird.FirebirdConnectionFactory,
  Infra.Data.Firebird.ProdutorRepositoryFB,
  Infra.Data.Firebird.DistribuidorRepositoryFB,
  Infra.Data.Firebird.DistribuidorProdutoRepositoryFB,
  Infra.Data.Firebird.ProdutoRepositoryFB,
  Infra.Data.Firebird.NegociacaoRepositoryFB,
  Infra.Data.Firebird.NegociacaoItemRepositoryFB,
  Infra.Data.Firebird.ProdutorLimiteCreditoRepositoryFB,
  Core.Services.Impl.ProdutorService,
  Core.Services.Impl.DistribuidorService,
  Core.Services.Impl.ProdutoService,
  Core.Services.Impl.NegociacaoService,
  Core.Services.Impl.ValidacaoCreditoService;

class function TIoCContainer.GetInstance: TIoCContainer;
begin
  if FInstance = nil then
    FInstance := TIoCContainer.Create;
  Result := FInstance;
end;

class procedure TIoCContainer.InitializeConnection;
begin
  FDatabaseConfig := TDatabaseConfig.Create;
  FConnectionFactory := TFirebirdConnectionFactory.Create(FDatabaseConfig);
end;

class procedure TIoCContainer.RegisterServices;
begin
  InitializeConnection;
  FProdutorRepository := TProdutorRepositoryFB.Create(FConnectionFactory);
  FDistribuidorRepository := TDistribuidorRepositoryFB.Create(FConnectionFactory);
  FDistribuidorProdutoRepository := TDistribuidorProdutoRepositoryFB.Create(FConnectionFactory);
  FProdutoRepository := TProdutoRepositoryFB.Create(FConnectionFactory);
  FNegociacaoRepository := TNegociacaoRepositoryFB.Create(FConnectionFactory);
  FNegociacaoItemRepository := TNegociacaoItemRepositoryFB.Create(FConnectionFactory);
  FProdutorLimiteCreditoRepository := TProdutorLimiteCreditoRepositoryFB.Create(FConnectionFactory);
  FValidacaoCreditoService := TValidacaoCreditoService.Create(FNegociacaoRepository, FProdutorLimiteCreditoRepository);
  FProdutorService := TProdutorService.Create(FProdutorRepository, FProdutorLimiteCreditoRepository, FNegociacaoRepository);
  FDistribuidorService := TDistribuidorService.Create(FDistribuidorRepository, FDistribuidorProdutoRepository);
  FProdutoService := TProdutoService.Create(FProdutoRepository);
  FNegociacaoService := TNegociacaoService.Create(FNegociacaoRepository, FNegociacaoItemRepository, FValidacaoCreditoService);
end;

class procedure TIoCContainer.Initialize;
begin
  RegisterServices;
end;

class procedure TIoCContainer.Uninitialize;
begin
  FValidacaoCreditoService := nil;
  FProdutorService := nil;
  FDistribuidorService := nil;
  FProdutoService := nil;
  FNegociacaoService := nil;

  FProdutorRepository := nil;
  FDistribuidorRepository := nil;
  FDistribuidorProdutoRepository := nil;
  FProdutoRepository := nil;
  FNegociacaoRepository := nil;
  FNegociacaoItemRepository := nil;
  FProdutorLimiteCreditoRepository := nil;

  FConnectionFactory := nil;

  if FInstance <> nil then
    FreeAndNil(FInstance);
end;

initialization

finalization
  TIoCContainer.Uninitialize;

  if Assigned(TIoCContainer.FDatabaseConfig) then
    FreeAndNil(TIoCContainer.FDatabaseConfig);

end.

