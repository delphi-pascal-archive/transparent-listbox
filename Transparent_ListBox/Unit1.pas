unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls,
  UTransparentListBox, Buttons;

type
  TForm1 = class(TForm)
    Image1: TImage;
    SpeedButton1: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    procedure LBTclic(Sender : TObject);
  end;

var
  Form1 : TForm1;
  LBT   : TTransparentListBox;

implementation

{$R *.dfm}

{-------------------------------------------------------------------------------
 initialisation de la ListBox transparente
 une astuce pour définir la propriété Parent qui demande un TWinControl
 Image n'est pas un TWinControl, j'utilise donc le bouton "OK" qui est posé
 aussi sur l'image concernée
-------------------------------------------------------------------------------}
procedure TForm1.FormCreate(Sender: TObject);
begin
  LBT           := TTransparentListBox.Create(Self);
  With LBT do
  begin
    Parent      := Form1;//SpeedButton1.Parent;
    BorderStyle := bsNone;
    Brush.Style := bsClear;
    Left        := 5;
    Top         := 50;
    Width       := 290;
    Height      := 200;
    Font.Name   := 'Garamond';
    Font.Color  := clBlack;
    Font.Style  := [fsItalic];
    Font.Size   := 11;

    OnClick     := LBTclic;

    Clear;
    Items.Add('Utilisation d''un TListBox Transparent');
    Items.Add('ce composant a été écrit par Walter Irion');
    Items.Add('je mets un petit exemple ici pour Delphifr');
    Items.Add('');
    Items.Add('Si vous cliquez sur une ligne, vous aurez');
    Items.Add('la preuve que c''est une listBox');
    Items.Add('');
    Items.Add('Si vous souhaitez installer le composant,');
    Items.Add('remettre la procedure register');
  end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  LBT.Free;
end;

procedure TForm1.LBTclic(Sender : TObject);
begin
  if LBT.ItemIndex > -1 then
    showmessage('Clic sur la ligne n° '+inttoStr(LBT.ItemIndex)+#13#10
               +'de la ListBoxTransparente créée dynamiquement');
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  close
end;

end.
