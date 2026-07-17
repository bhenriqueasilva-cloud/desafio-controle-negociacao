unit App.Views.Base.ViewBaseCadastroDetail;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, App.Views.Base.ViewBaseCadastro,
  Data.DB, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.ComCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.Client;

type
  TViewBaseCadastroDetail = class(TViewBaseCadastro)
    gbDetail: TGroupBox;
    gridDetail: TDBGrid;
    pnlButtonDetail: TPanel;
    btnIncluirDetail: TSpeedButton;
    brnExcluirDetail: TSpeedButton;
    procedure FormCreate(Sender: TObject);
  private
  protected
    FDataSourceDetail: TDataSource;
    FMemDetail: TFDMemTable;
  public
  end;

var
  ViewBaseCadastroDetail: TViewBaseCadastroDetail;

implementation

{$R *.dfm}

procedure TViewBaseCadastroDetail.FormCreate(Sender: TObject);
begin

  FMemDetail := TFDMemTable.Create(Self);
  FDataSourceDetail := TDataSource.Create(Self);
  FDataSourceDetail.DataSet := FMemDetail;
  gridDetail.DataSource := FDataSourceDetail;
  inherited;
end;

end.
