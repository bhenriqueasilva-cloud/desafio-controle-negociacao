unit App.Views.Negociacao.ViewConsultaNegociacoes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  System.Generics.Collections, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Grids, Vcl.Buttons,
  Vcl.Printers, Core.Entities.Negociacao, Core.Entities.Produtor,
  Core.Entities.Distribuidor, Core.Enums.TipoStatus, Infra.IoC.Container,
  Infra.CrossCutting.Validation.MessageValidation, frCoreClasses, frxClass,
  frxDBSet, frxDesgn;

type
  TViewConsultaNegociacoes = class(TForm)
    pnlTitulo: TPanel;
    lblTitulo: TLabel;
    grpFiltros: TGroupBox;
    lblProdutor: TLabel;
    cbxProdutor: TComboBox;
    lblDistribuidor: TLabel;
    cbxDistribuidor: TComboBox;
    btnFiltrar: TButton;
    btnLimpar: TButton;
    grpResultados: TGroupBox;
    grdNegociacoes: TStringGrid;
    btnAlterarStatus: TButton;
    btnImprimir: TButton;
    btnFechar: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnFiltrarClick(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
    procedure btnAlterarStatusClick(Sender: TObject);
    procedure btnImprimirClick(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FProdutores: TList<TProdutor>;
    FDistribuidores: TList<TDistribuidor>;
    procedure CarregarDados;
    procedure ConfigurarGrid;
    procedure LimparGrid;
    function DataParaTexto(const AData: TDateTime): string;
    function NomeProdutorPorId(AIdProdutor: Integer): string;
    function NomeDistribuidorPorId(AIdDistribuidor: Integer): string;
    function StatusToString(AStatus: TTipoStatus): string;
  public
  end;

var
  ViewConsultaNegociacoes: TViewConsultaNegociacoes;

implementation

uses
  App.Views.Negociacao.ViewAlteracaoStatusNegociacao, FireDAC.Comp.Client, Data.DB;

{$R *.dfm}

procedure TViewConsultaNegociacoes.FormClose(Sender: TObject;
  var Action: TCloseAction);
  var
  LProdutor: TProdutor;
  LDistribuidor: TDistribuidor;
begin
 if Assigned(FProdutores) then
  begin
    for LProdutor in FProdutores do
      if Assigned(LProdutor) then LProdutor.Free;
    FreeAndNil(FProdutores);
  end;

  if Assigned(FDistribuidores) then
  begin
    for LDistribuidor in FDistribuidores do
      if Assigned(LDistribuidor) then LDistribuidor.Free;
    FreeAndNil(FDistribuidores);
  end;

  Action := CaFree;
end;

procedure TViewConsultaNegociacoes.FormCreate(Sender: TObject);
begin
  Caption := 'Consulta de Negociações';
  lblTitulo.Caption := 'Consulta de Negociações';

  FProdutores := TList<TProdutor>.Create;
  FDistribuidores := TList<TDistribuidor>.Create;

  ConfigurarGrid;
  CarregarDados;
end;

procedure TViewConsultaNegociacoes.ConfigurarGrid;
begin
  grdNegociacoes.ColCount := 9;
  grdNegociacoes.FixedRows := 1;
  grdNegociacoes.Cells[0, 0] := 'Código';
  grdNegociacoes.Cells[1, 0] := 'Produtor';
  grdNegociacoes.Cells[2, 0] := 'Distribuidor';
  grdNegociacoes.Cells[3, 0] := 'Data Cadastro';
  grdNegociacoes.Cells[4, 0] := 'Data Aprovação';
  grdNegociacoes.Cells[5, 0] := 'Data Conclusão';
  grdNegociacoes.Cells[6, 0] := 'Data Cancelamento';
  grdNegociacoes.Cells[7, 0] := 'Status';
  grdNegociacoes.Cells[8, 0] := 'Valor Total';

  grdNegociacoes.ColWidths[0] := 60;
  grdNegociacoes.ColWidths[1] := 160;
  grdNegociacoes.ColWidths[2] := 160;
  grdNegociacoes.ColWidths[3] := 95;
  grdNegociacoes.ColWidths[4] := 95;
  grdNegociacoes.ColWidths[5] := 95;
  grdNegociacoes.ColWidths[6] := 110;
  grdNegociacoes.ColWidths[7] := 85;
  grdNegociacoes.ColWidths[8] := 90;

  LimparGrid;
end;

procedure TViewConsultaNegociacoes.LimparGrid;
var
  I: Integer;
begin
  grdNegociacoes.RowCount := 2;
  for I := 0 to grdNegociacoes.ColCount - 1 do
    grdNegociacoes.Cells[I, 1] := '';
end;

function TViewConsultaNegociacoes.DataParaTexto(const AData: TDateTime): string;
begin
  if AData > 0 then
    Result := FormatDateTime('dd/mm/yyyy', AData)
  else
    Result := '';
end;

function TViewConsultaNegociacoes.NomeProdutorPorId(AIdProdutor: Integer): string;
var
  LProdutor: TProdutor;
begin
  Result := 'N/A';
  for LProdutor in FProdutores do
    if LProdutor.Id = AIdProdutor then
      Exit(LProdutor.Nome);
end;

function TViewConsultaNegociacoes.NomeDistribuidorPorId(AIdDistribuidor: Integer): string;
var
  LDistribuidor: TDistribuidor;
begin
  Result := 'N/A';
  for LDistribuidor in FDistribuidores do
    if LDistribuidor.Id = AIdDistribuidor then
      Exit(LDistribuidor.Nome);
end;

procedure TViewConsultaNegociacoes.CarregarDados;
var
  LProdutor: TProdutor;
  LDistribuidor: TDistribuidor;
begin
  try
    if Assigned(FProdutores) then
    begin
      for LProdutor in FProdutores do
        if Assigned(LProdutor) then LProdutor.Free;
      FProdutores.Free;
      FProdutores := nil;
    end;

    if Assigned(FDistribuidores) then
    begin
      for LDistribuidor in FDistribuidores do
        if Assigned(LDistribuidor) then LDistribuidor.Free;
      FDistribuidores.Free;
      FDistribuidores := nil;
    end;

    FProdutores := TIoCContainer.ProdutorService.ObterTodos;
    FDistribuidores := TIoCContainer.DistribuidorService.ObterTodos;

    cbxProdutor.Items.Clear;
    cbxProdutor.Items.Add('Todos');
    if Assigned(FProdutores) then
    begin
      for LProdutor in FProdutores do
        cbxProdutor.Items.AddObject(LProdutor.Nome, TObject(LProdutor.Id));
    end;
    cbxProdutor.ItemIndex := 0;

    cbxDistribuidor.Items.Clear;
    cbxDistribuidor.Items.Add('Todos');
    if Assigned(FDistribuidores) then
    begin
      for LDistribuidor in FDistribuidores do
        cbxDistribuidor.Items.AddObject(LDistribuidor.Nome, TObject(LDistribuidor.Id));
    end;
    cbxDistribuidor.ItemIndex := 0;

  except
    on E: Exception do
      TMessageValidation.Erro('Erro ao carregar dados: ' + E.Message);
  end;
end;


procedure TViewConsultaNegociacoes.btnFiltrarClick(Sender: TObject);
var
  LNegociacoes: TList<TNegociacao>;
  LNegociacao: TNegociacao;
  LIdProdutor: Integer;
  LIdDistribuidor: Integer;
  I: Integer;
begin
  try
    LIdProdutor := 0;
    LIdDistribuidor := 0;

    if cbxProdutor.ItemIndex > 0 then
      LIdProdutor := Integer(cbxProdutor.Items.Objects[cbxProdutor.ItemIndex]);

    if cbxDistribuidor.ItemIndex > 0 then
      LIdDistribuidor := Integer(cbxDistribuidor.Items.Objects[cbxDistribuidor.ItemIndex]);

    if (LIdProdutor > 0) and (LIdDistribuidor > 0) then
    begin
      TMessageValidation.Aviso('Selecione apenas um filtro por vez');
      Exit;
    end;

    if LIdProdutor > 0 then
      LNegociacoes := TIoCContainer.NegociacaoService.ObterPorProdutor(LIdProdutor)
    else if LIdDistribuidor > 0 then
      LNegociacoes := TIoCContainer.NegociacaoService.ObterPorDistribuidor(LIdDistribuidor)
    else
      LNegociacoes := TIoCContainer.NegociacaoService.ObterTodos;

    try
      LimparGrid;

      for LNegociacao in LNegociacoes do
      begin
        I := grdNegociacoes.RowCount;
        grdNegociacoes.RowCount := I + 1;

        grdNegociacoes.Cells[0, I] := IntToStr(LNegociacao.Id);
        grdNegociacoes.Cells[1, I] := NomeProdutorPorId(LNegociacao.IdProdutor);
        grdNegociacoes.Cells[2, I] := NomeDistribuidorPorId(LNegociacao.IdDistribuidor);
        grdNegociacoes.Cells[3, I] := DataParaTexto(LNegociacao.DataCadastro);
        grdNegociacoes.Cells[4, I] := DataParaTexto(LNegociacao.DataAprovacao);
        grdNegociacoes.Cells[5, I] := DataParaTexto(LNegociacao.DataConclusao);
        grdNegociacoes.Cells[6, I] := DataParaTexto(LNegociacao.DataCancelamento);
        grdNegociacoes.Cells[7, I] := StatusToString(LNegociacao.Status);
        grdNegociacoes.Cells[8, I] := FormatFloat('R$ ,0.00', LNegociacao.ValorTotal);
      end;
    finally
      if Assigned(LNegociacoes) then
      begin
        for LNegociacao in LNegociacoes do
          if Assigned(LNegociacao) then
            LNegociacao.Free;

        LNegociacoes.Free;
      end;
    end;
  except
    on E: Exception do
      TMessageValidation.Erro('Erro ao filtrar negociações: ' + E.Message);
  end;
end;

procedure TViewConsultaNegociacoes.btnLimparClick(Sender: TObject);
begin
  cbxProdutor.ItemIndex := 0;
  cbxDistribuidor.ItemIndex := 0;
  LimparGrid;
end;

procedure TViewConsultaNegociacoes.btnImprimirClick(Sender: TObject);
var
  LMemTable: TFDMemTable;
  I: Integer;
  LTemDados: Boolean;
  LReport: TfrxReport;
  LDBDataset: TfrxDBDataset;
  LPage: TfrxReportPage;
  LHeaderBand: TfrxHeader;
  LDataBand: TfrxMasterData;
  LMemoTitulo, LMemoHeader, LMemoCampo: TfrxMemoView;
  LPosicaoX: Double;
begin
  LTemDados := False;
  for I := 1 to grdNegociacoes.RowCount - 1 do
  begin
    if Trim(grdNegociacoes.Cells[0, I]) <> '' then
    begin
      LTemDados := True;
      Break;
    end;
  end;

  if not LTemDados then
  begin
    TMessageValidation.Aviso('Não há negociações filtradas para imprimir.');
    Exit;
  end;

  LReport := TfrxReport.Create(Self);
  LDBDataset := TfrxDBDataset.Create(Self);
  LMemTable := TFDMemTable.Create(Self);
  try
    LMemTable.FieldDefs.Add('ID', ftInteger);
    LMemTable.FieldDefs.Add('PRODUTOR', ftString, 100);
    LMemTable.FieldDefs.Add('DISTRIBUIDOR', ftString, 100);
    LMemTable.FieldDefs.Add('DATA_CADASTRO', ftString, 20);
    LMemTable.FieldDefs.Add('DATA_APROVACAO', ftString, 20);
    LMemTable.FieldDefs.Add('DATA_CONCLUSAO', ftString, 20);
    LMemTable.FieldDefs.Add('DATA_CANCELAMENTO', ftString, 20);
    LMemTable.FieldDefs.Add('STATUS', ftString, 30);
    LMemTable.FieldDefs.Add('VALOR_TOTAL', ftString, 30);
    LMemTable.CreateDataSet;

    LMemTable.DisableControls;
    try
      for I := 1 to grdNegociacoes.RowCount - 1 do
      begin
        if Trim(grdNegociacoes.Cells[0, I]) = '' then
          Continue;

        LMemTable.Append;
        LMemTable.FieldByName('ID').AsString                := grdNegociacoes.Cells[0, I];
        LMemTable.FieldByName('PRODUTOR').AsString          := grdNegociacoes.Cells[1, I];
        LMemTable.FieldByName('DISTRIBUIDOR').AsString      := grdNegociacoes.Cells[2, I];
        LMemTable.FieldByName('DATA_CADASTRO').AsString     := grdNegociacoes.Cells[3, I];
        LMemTable.FieldByName('DATA_APROVACAO').AsString    := grdNegociacoes.Cells[4, I];
        LMemTable.FieldByName('DATA_CONCLUSAO').AsString    := grdNegociacoes.Cells[5, I];
        LMemTable.FieldByName('DATA_CANCELAMENTO').AsString := grdNegociacoes.Cells[6, I];
        LMemTable.FieldByName('STATUS').AsString            := grdNegociacoes.Cells[7, I];
        LMemTable.FieldByName('VALOR_TOTAL').AsString        := grdNegociacoes.Cells[8, I];
        LMemTable.Post;
      end;
    finally
      LMemTable.EnableControls;
    end;

    LMemTable.First;

    LDBDataset.DataSet := LMemTable;
    LDBDataset.UserName := 'Negociacoes';

    LReport.Clear;
    LReport.DataSets.Add(LDBDataset);
    LReport.EnabledDataSets.Add(LDBDataset);

    LPage := TfrxReportPage.Create(LReport);
    LPage.CreateUniqueName;
    LPage.SetDefaults;
    LPage.Orientation := poLandscape;

    LHeaderBand := TfrxHeader.Create(LPage);
    LHeaderBand.CreateUniqueName;
    LHeaderBand.Top := 0;
    LHeaderBand.Height := 50;

    LMemoTitulo := TfrxMemoView.Create(LHeaderBand);
    LMemoTitulo.CreateUniqueName;
    LMemoTitulo.Text := 'Relatório de Negociações';
    LMemoTitulo.SetBounds(0, 0, 1000, 25);
    LMemoTitulo.Font.Size := 16;
    LMemoTitulo.Font.Style := [fsBold];

    LPosicaoX := 0;

    LMemoHeader := TfrxMemoView.Create(LHeaderBand);
    LMemoHeader.CreateUniqueName;
    LMemoHeader.Text := 'ID';
    LMemoHeader.SetBounds(LPosicaoX, 30, 50, 20);
    LMemoHeader.Font.Style := [fsBold];
    LMemoHeader.Frame.Typ := [ftLeft, ftRight, ftTop, ftBottom];
    LMemoHeader.Color := clLtGray;
    LPosicaoX := LPosicaoX + 50;

    LMemoHeader := TfrxMemoView.Create(LHeaderBand);
    LMemoHeader.CreateUniqueName;
    LMemoHeader.Text := 'Produtor';
    LMemoHeader.SetBounds(LPosicaoX, 30, 200, 20);
    LMemoHeader.Font.Style := [fsBold];
    LMemoHeader.Frame.Typ := [ftLeft, ftRight, ftTop, ftBottom];
    LMemoHeader.Color := clLtGray;
    LPosicaoX := LPosicaoX + 200;

    LMemoHeader := TfrxMemoView.Create(LHeaderBand);
    LMemoHeader.CreateUniqueName;
    LMemoHeader.Text := 'Distribuidor';
    LMemoHeader.SetBounds(LPosicaoX, 30, 200, 20);
    LMemoHeader.Font.Style := [fsBold];
    LMemoHeader.Frame.Typ := [ftLeft, ftRight, ftTop, ftBottom];
    LMemoHeader.Color := clLtGray;
    LPosicaoX := LPosicaoX + 200;

    LMemoHeader := TfrxMemoView.Create(LHeaderBand);
    LMemoHeader.CreateUniqueName;
    LMemoHeader.Text := 'Data Cad.';
    LMemoHeader.SetBounds(LPosicaoX, 30, 85, 20);
    LMemoHeader.Font.Style := [fsBold];
    LMemoHeader.Frame.Typ := [ftLeft, ftRight, ftTop, ftBottom];
    LMemoHeader.Color := clLtGray;
    LPosicaoX := LPosicaoX + 85;

    LMemoHeader := TfrxMemoView.Create(LHeaderBand);
    LMemoHeader.CreateUniqueName;
    LMemoHeader.Text := 'Data Aprov.';
    LMemoHeader.SetBounds(LPosicaoX, 30, 85, 20);
    LMemoHeader.Font.Style := [fsBold];
    LMemoHeader.Frame.Typ := [ftLeft, ftRight, ftTop, ftBottom];
    LMemoHeader.Color := clLtGray;
    LPosicaoX := LPosicaoX + 85;

    LMemoHeader := TfrxMemoView.Create(LHeaderBand);
    LMemoHeader.CreateUniqueName;
    LMemoHeader.Text := 'Data Concl.';
    LMemoHeader.SetBounds(LPosicaoX, 30, 85, 20);
    LMemoHeader.Font.Style := [fsBold];
    LMemoHeader.Frame.Typ := [ftLeft, ftRight, ftTop, ftBottom];
    LMemoHeader.Color := clLtGray;
    LPosicaoX := LPosicaoX + 85;

    LMemoHeader := TfrxMemoView.Create(LHeaderBand);
    LMemoHeader.CreateUniqueName;
    LMemoHeader.Text := 'Data Canc.';
    LMemoHeader.SetBounds(LPosicaoX, 30, 85, 20);
    LMemoHeader.Font.Style := [fsBold];
    LMemoHeader.Frame.Typ := [ftLeft, ftRight, ftTop, ftBottom];
    LMemoHeader.Color := clLtGray;
    LPosicaoX := LPosicaoX + 85;

    LMemoHeader := TfrxMemoView.Create(LHeaderBand);
    LMemoHeader.CreateUniqueName;
    LMemoHeader.Text := 'Status';
    LMemoHeader.SetBounds(LPosicaoX, 30, 85, 20);
    LMemoHeader.Font.Style := [fsBold];
    LMemoHeader.Frame.Typ := [ftLeft, ftRight, ftTop, ftBottom];
    LMemoHeader.Color := clLtGray;
    LPosicaoX := LPosicaoX + 85;

    LMemoHeader := TfrxMemoView.Create(LHeaderBand);
    LMemoHeader.CreateUniqueName;
    LMemoHeader.Text := 'Valor Total';
    LMemoHeader.SetBounds(LPosicaoX, 30, 110, 20);
    LMemoHeader.Font.Style := [fsBold];
    LMemoHeader.Frame.Typ := [ftLeft, ftRight, ftTop, ftBottom];
    LMemoHeader.Color := clLtGray;

    LDataBand := TfrxMasterData.Create(LPage);
    LDataBand.CreateUniqueName;
    LDataBand.DataSet := LDBDataset;
    LDataBand.Top := 60;
    LDataBand.Height := 20;

    LPosicaoX := 0;

    LMemoCampo := TfrxMemoView.Create(LDataBand);
    LMemoCampo.CreateUniqueName;
    LMemoCampo.DataSet := LDBDataset;
    LMemoCampo.DataField := 'ID';
    LMemoCampo.SetBounds(LPosicaoX, 0, 50, 20);
    LMemoCampo.Frame.Typ := [ftLeft, ftRight, ftTop, ftBottom];
    LPosicaoX := LPosicaoX + 50;

    LMemoCampo := TfrxMemoView.Create(LDataBand);
    LMemoCampo.CreateUniqueName;
    LMemoCampo.DataSet := LDBDataset;
    LMemoCampo.DataField := 'PRODUTOR';
    LMemoCampo.SetBounds(LPosicaoX, 0, 200, 20);
    LMemoCampo.Frame.Typ := [ftLeft, ftRight, ftTop, ftBottom];
    LPosicaoX := LPosicaoX + 200;

    LMemoCampo := TfrxMemoView.Create(LDataBand);
    LMemoCampo.CreateUniqueName;
    LMemoCampo.DataSet := LDBDataset;
    LMemoCampo.DataField := 'DISTRIBUIDOR';
    LMemoCampo.SetBounds(LPosicaoX, 0, 200, 20);
    LMemoCampo.Frame.Typ := [ftLeft, ftRight, ftTop, ftBottom];
    LPosicaoX := LPosicaoX + 200;

    LMemoCampo := TfrxMemoView.Create(LDataBand);
    LMemoCampo.CreateUniqueName;
    LMemoCampo.DataSet := LDBDataset;
    LMemoCampo.DataField := 'DATA_CADASTRO';
    LMemoCampo.SetBounds(LPosicaoX, 0, 85, 20);
    LMemoCampo.Frame.Typ := [ftLeft, ftRight, ftTop, ftBottom];
    LPosicaoX := LPosicaoX + 85;

    LMemoCampo := TfrxMemoView.Create(LDataBand);
    LMemoCampo.CreateUniqueName;
    LMemoCampo.DataSet := LDBDataset;
    LMemoCampo.DataField := 'DATA_APROVACAO';
    LMemoCampo.SetBounds(LPosicaoX, 0, 85, 20);
    LMemoCampo.Frame.Typ := [ftLeft, ftRight, ftTop, ftBottom];
    LPosicaoX := LPosicaoX + 85;

    LMemoCampo := TfrxMemoView.Create(LDataBand);
    LMemoCampo.CreateUniqueName;
    LMemoCampo.DataSet := LDBDataset;
    LMemoCampo.DataField := 'DATA_CONCLUSAO';
    LMemoCampo.SetBounds(LPosicaoX, 0, 85, 20);
    LMemoCampo.Frame.Typ := [ftLeft, ftRight, ftTop, ftBottom];
    LPosicaoX := LPosicaoX + 85;

    LMemoCampo := TfrxMemoView.Create(LDataBand);
    LMemoCampo.CreateUniqueName;
    LMemoCampo.DataSet := LDBDataset;
    LMemoCampo.DataField := 'DATA_CANCELAMENTO';
    LMemoCampo.SetBounds(LPosicaoX, 0, 85, 20);
    LMemoCampo.Frame.Typ := [ftLeft, ftRight, ftTop, ftBottom];
    LPosicaoX := LPosicaoX + 85;

    LMemoCampo := TfrxMemoView.Create(LDataBand);
    LMemoCampo.CreateUniqueName;
    LMemoCampo.DataSet := LDBDataset;
    LMemoCampo.DataField := 'STATUS';
    LMemoCampo.SetBounds(LPosicaoX, 0, 85, 20);
    LMemoCampo.Frame.Typ := [ftLeft, ftRight, ftTop, ftBottom];
    LPosicaoX := LPosicaoX + 85;

    LMemoCampo := TfrxMemoView.Create(LDataBand);
    LMemoCampo.CreateUniqueName;
    LMemoCampo.DataSet := LDBDataset;
    LMemoCampo.DataField := 'VALOR_TOTAL';
    LMemoCampo.SetBounds(LPosicaoX, 0, 110, 20);
    LMemoCampo.Frame.Typ := [ftLeft, ftRight, ftTop, ftBottom];

    LReport.ShowReport(True);

  finally
    LMemTable.Free;
    LDBDataset.Free;
    LReport.Free;
  end;
end;

procedure TViewConsultaNegociacoes.btnAlterarStatusClick(Sender: TObject);
var
  LIdNegociacao: Integer;
  LStrId: string;
  I: Integer;
  LFormStatus: TViewAlteracaoStatusNegociacao;
begin
  if grdNegociacoes.Row < 1 then
  begin
    TMessageValidation.Aviso('Selecione uma negociação na grade.');
    Exit;
  end;

  LStrId := grdNegociacoes.Cells[0, grdNegociacoes.Row];
  if Trim(LStrId) = '' then
  begin
    TMessageValidation.Aviso('Linha vazia selecionada.');
    Exit;
  end;

  LIdNegociacao := StrToIntDef(LStrId, 0);
  if LIdNegociacao = 0 then
    Exit;

  LFormStatus := nil;
  for I := 0 to Application.MainForm.MDIChildCount - 1 do
  begin
    if Application.MainForm.MDIChildren[I] is TViewAlteracaoStatusNegociacao then
    begin
      LFormStatus := TViewAlteracaoStatusNegociacao(Application.MainForm.MDIChildren[I]);
      Break;
    end;
  end;

  if not Assigned(LFormStatus) then
    LFormStatus := TViewAlteracaoStatusNegociacao.Create(Application.MainForm);

  LFormStatus.BringToFront;
  if LFormStatus.Visible and LFormStatus.Enabled then
    LFormStatus.SetFocus;

  LFormStatus.CarregarNegociacaoPorId(LIdNegociacao);
end;

procedure TViewConsultaNegociacoes.btnFecharClick(Sender: TObject);
begin
  Close;
end;

function TViewConsultaNegociacoes.StatusToString(AStatus: TTipoStatus): string;
begin
  case AStatus of
    tsPendente: Result := 'Pendente';
    tsAprovada: Result := 'Aprovada';
    tsConcluida: Result := 'Concluída';
    tsCancelada: Result := 'Cancelada';
  else
    Result := 'Desconhecido';
  end;
end;

end.

