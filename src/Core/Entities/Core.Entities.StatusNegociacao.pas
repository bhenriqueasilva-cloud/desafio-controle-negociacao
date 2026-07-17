unit Core.Entities.StatusNegociacao;

interface

type
  TStatusNegociacao = class
  private
    FId: Integer;
    FDescricao: string;
  public
    property Id: Integer read FId write FId;
    property Descricao: string read FDescricao write FDescricao;
  end;

implementation

end.
