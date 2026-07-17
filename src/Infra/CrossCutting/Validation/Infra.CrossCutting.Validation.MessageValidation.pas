unit Infra.CrossCutting.Validation.MessageValidation;

interface

uses
  System.UITypes,
  Vcl.Dialogs,
  Vcl.Forms,
  Vcl.StdCtrls,
  Vcl.Controls;

type
  TMessageValidation = class
  public

    class function Confirmar(const AMensagem: string; const ATitulo: string = 'Confirmaçãoo'): Boolean; static;

    class procedure Aviso(const AMensagem: string; const ATitulo: string = 'Aviso'); static;

    class procedure Erro(const AMensagem: string; const ATitulo: string = 'Erro'); static;
  end;

implementation

class function TMessageValidation.Confirmar(const AMensagem: string; const ATitulo: string): Boolean;
var
  LFormDialog: TForm;
  I: Integer;
begin

  LFormDialog := CreateMessageDialog(AMensagem, mtConfirmation, [mbYes, mbNo]);
  try
    LFormDialog.Position := poScreenCenter;
    LFormDialog.Caption  := ATitulo;

    for I := 0 to LFormDialog.ComponentCount - 1 do
    begin
      if LFormDialog.Components[I] is TButton then
      begin
        if TButton(LFormDialog.Components[I]).Name = 'Yes' then
          TButton(LFormDialog.Components[I]).Caption := '&Sim'
        else if TButton(LFormDialog.Components[I]).Name = 'No' then
          TButton(LFormDialog.Components[I]).Caption := '&Não';
      end;
    end;

    Result := (LFormDialog.ShowModal = mrYes);
  finally
    LFormDialog.Free;
  end;
end;

class procedure TMessageValidation.Aviso(const AMensagem: string; const ATitulo: string);
var
  LFormDialog: TForm;
begin
  LFormDialog := CreateMessageDialog(AMensagem, mtWarning, [mbOK]);
  try
    LFormDialog.Position := poScreenCenter;
    LFormDialog.Caption  := ATitulo;
    LFormDialog.ShowModal;
  finally
    LFormDialog.Free;
  end;
end;

class procedure TMessageValidation.Erro(const AMensagem: string; const ATitulo: string);
var
  LFormDialog: TForm;
begin
  LFormDialog := CreateMessageDialog(AMensagem, mtError, [mbOK]);
  try
    LFormDialog.Position := poScreenCenter;
    LFormDialog.Caption  := ATitulo;
    LFormDialog.ShowModal;
  finally
    LFormDialog.Free;
  end;
end;

end.

