unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ExtDlgs, windows;

type

  { TForm1 }

  TForm1 = class(TForm)
    loadButton: TButton;
    OpenPictureDialog1: TOpenPictureDialog;
    saveButton: TButton;
    Image1: TImage;
    SavePictureDialog1: TSavePictureDialog;
    procedure loadButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  bitmapR, bitmapG, bitmapB : array [0..2000, 0..2000] of byte;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin

end;

procedure TForm1.loadButtonClick(Sender: TObject);
var
    x, y : integer;
begin
  if OpenPictureDialog1.Execute then
    begin
      Image1.Picture.LoadFromFile(OpenPictureDialog1.FileName);
      for y:=0 to image1.Height-1 do
      begin
        for x:=0 to image1.Width-1 do
        begin
          bitmapR[x,y] := GetRValue(image1.Canvas.Pixels[x,y]);
          bitmapG[x,y] := GetGValue(image1.Canvas.Pixels[x,y]);
          bitmapB[x,y] := GetBValue(image1.Canvas.Pixels[x,y]);
        end;
      end;
    end;
end;

end.

