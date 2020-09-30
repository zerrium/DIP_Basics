unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ExtDlgs, ComCtrls, windows, math, Strutils;

type

  { TForm1 }

  TForm1 = class(TForm)
    brightnessLabel: TLabel;
    resetBrightnessButton: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    loadButton: TButton;
    OpenPictureDialog1: TOpenPictureDialog;
    saveButton: TButton;
    Image1: TImage;
    SavePictureDialog1: TSavePictureDialog;
    TrackBarBrightness: TTrackBar;
    procedure loadButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure resetBrightnessButtonClick(Sender: TObject);
    procedure saveButtonClick(Sender: TObject);
    procedure TrackBarBrightnessChange(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  bitmapR, bitmapG, bitmapB : array [0..2000, 0..2000] of integer;
  defaultBrightnessR, defaultBrightnessG, defaultBrightnessB : array [0..2000, 0..2000] of integer;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin

end;

procedure TForm1.resetBrightnessButtonClick(Sender: TObject);
var
  x,y : integer;
begin
  for y:=0 to image1.Height-1 do
    begin
      for x:=0 to image1.Width-1 do
      begin
        image1.Canvas.Pixels[x,y] := RGB(defaultBrightnessR[x,y], defaultBrightnessG[x,y], defaultBrightnessB[x,y]);
      end;
    end;
  TrackBarBrightness.Position := 0;
end;

procedure TForm1.saveButtonClick(Sender: TObject);
begin
  if SavePictureDialog1.Execute then
  begin
    image1.Picture.SaveToFile(SavePictureDialog1.FileName);
  end;
end;

procedure TForm1.TrackBarBrightnessChange(Sender: TObject);
var
   x, y: integer;
begin
  TrackBarBrightness.Enabled := False;
  for y:=0 to image1.Height-1 do
  begin
    for x:=0 to image1.Width-1 do
    begin
      bitmapR[x,y] := Trunc(bitmapR[x,y] + (defaultBrightnessR[x,y] * TrackBarBrightness.Position/100));
      bitmapG[x,y] := Trunc(bitmapG[x,y] + (defaultBrightnessG[x,y] * TrackBarBrightness.Position/100));
      bitmapB[x,y] := Trunc(bitmapB[x,y] + (defaultBrightnessB[x,y] * TrackBarBrightness.Position/100));

      //Pake ternary operator supaya nilainya ga negatif dan ga lebih dari 255 (Willy)
      bitmapR[x,y] := IfThen(bitmapR[x,y] < 0, 0, IfThen(bitmapR[x,y] > 255, 255, bitmapR[x,y]));
      bitmapG[x,y] := IfThen(bitmapG[x,y] < 0, 0, IfThen(bitmapG[x,y] > 255, 255, bitmapG[x,y]));
      bitmapB[x,y] := IfThen(bitmapB[x,y] < 0, 0, IfThen(bitmapB[x,y] > 255, 255, bitmapB[x,y]));

      image1.Canvas.Pixels[x,y] := RGB(bitmapR[x,y], bitmapG[x,y], bitmapB[x,y]);
    end;
  end;
  TrackBarBrightness.Enabled := True;
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
          defaultBrightnessR[x,y] := bitmapR[x,y];
          defaultBrightnessG[x,y] := bitmapG[x,y];
          defaultBrightnessB[x,y] := bitmapB[x,y];
        end;
      end;
    end;
end;

end.

