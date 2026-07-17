unit Core.Entities.CadastroBase;

interface

uses
  Core.Exceptions.ValidacaoException;

type
  TCadastroBase = class abstract
  private
    FId: Integer;
    FNome: string;
    procedure SetNome(const AValue: string);
  protected
    function GetNomeEntidade: string; virtual; abstract;
  public
    procedure Validar; virtual;

    property Id: Integer read FId write FId;
    property Nome: string read FNome write SetNome;
  end;

implementation

uses
  System.SysUtils;

procedure TCadastroBase.SetNome(const AValue: string);
begin
  if Trim(AValue) = '' then
    raise EValidacaoException.CreateFmt('Nome do %s não pode ser vazio', [GetNomeEntidade]);
  FNome := Trim(AValue);
end;

procedure TCadastroBase.Validar;
begin
  if Trim(FNome) = '' then
    raise EValidacaoException.CreateFmt('Nome do %s não pode ser vazio', [GetNomeEntidade]);
end;

end.
