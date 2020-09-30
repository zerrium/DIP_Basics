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
    ButtonInvers: TButton;
    ButtonSmooth: TButton;
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
    procedure ButtonInversClick(Sender: TObject);
    procedure ButtonSmoothClick(Sender: TObject);
    procedure loadButtonClick(Sender: TObject);
    procedure resetBrightnessButtonClick(Sender: TObject);
    procedure saveButtonClick(Sender: TObject);
    procedure TrackBarBrightnessChange(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  bitmapR, bitmapG, bitmapB : array [0..1000, 0..1000] of Byte; //variabel untuk gambar yang default belom dimanipulasi
  manipR, manipG, manipB : array [0..1000, 0..1000] of Byte; //variabel untuk gambar yang termanipulasi
  defaultBrightnessR, defaultBrightnessG, defaultBrightnessB : array [0..2000, 0..2000] of Byte; //variabel untuk default brightness

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.resetBrightnessButtonClick(Sender: TObject); //kembaliin gambar ke brightness semula
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

procedure TForm1.saveButtonClick(Sender: TObject); //save gambar yang udah dimanipulasi
begin
  if SavePictureDialog1.Execute then
  begin
    image1.Picture.SaveToFile(SavePictureDialog1.FileName);
  end;
end;

procedure TForm1.TrackBarBrightnessChange(Sender: TObject); //adjust brightness gambar
var
   x, y, brightnessR, brightnessG, brightnessB: integer;
begin
  TrackBarBrightness.Enabled := False;
  for y:=0 to image1.Height-1 do
  begin
    for x:=0 to image1.Width-1 do
    begin
      brightnessR := Trunc(defaultBrightnessR[x,y] + (defaultBrightnessR[x,y] * TrackBarBrightness.Position/100));
      brightnessG := Trunc(defaultBrightnessG[x,y] + (defaultBrightnessG[x,y] * TrackBarBrightness.Position/100));
      brightnessB := Trunc(defaultBrightnessB[x,y] + (defaultBrightnessB[x,y] * TrackBarBrightness.Position/100));

      //Pake ternary operator supaya nilainya ga negatif dan ga lebih dari 255 (Willy)
      manipR[x,y] := IfThen(brightnessR < 0, 0, IfThen(brightnessR > 255, 255, brightnessR));
      manipG[x,y] := IfThen(brightnessG < 0, 0, IfThen(brightnessG > 255, 255, brightnessG));
      manipB[x,y] := IfThen(brightnessB < 0, 0, IfThen(brightnessB > 255, 255, brightnessB));

      image1.Canvas.Pixels[x,y] := RGB(manipR[x,y], manipG[x,y], manipB[x,y]);
    end;
  end;
  TrackBarBrightness.Enabled := True;
end;

procedure TForm1.loadButtonClick(Sender: TObject); //load gambar
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

procedure TForm1.ButtonSmoothClick(Sender: TObject);
var
  x, y  : integer;
  gausR, gausG, gausB : double;
begin
  for y:= 0 to image1.height-1 do
  begin
   for x:= 0 to image1.width-1 do
   begin
    gausR := (bitmapR[x-1][y-1] * 0.075) + (bitmapR[x][y-1] * 0.124) + (bitmapR[x+1][y-1] * 0.075)
              + (bitmapR[x-1][y] * 0.075) + (bitmapR[x][y] * 0.124) + (bitmapR[x+1][y] * 0.075)
              + (bitmapR[x-1][y+1] * 0.075) + (bitmapR[x][y+1] * 0.124) + (bitmapR[x+1][y+1] * 0.075);
    gausG := (bitmapG[x-1][y-1] * 0.075) + (bitmapG[x][y-1] * 0.124) + (bitmapG[x+1][y-1] * 0.075)
              + (bitmapG[x-1][y] * 0.075) + (bitmapG[x][y] * 0.124) + (bitmapG[x+1][y] * 0.075)
              + (bitmapG[x-1][y+1] * 0.075) + (bitmapG[x][y+1] * 0.124) + (bitmapG[x+1][y+1] * 0.075);
    gausB := (bitmapB[x-1][y-1] * 0.075) + (bitmapB[x][y-1] * 0.124) + (bitmapB[x+1][y-1] * 0.075)
              + (bitmapB[x-1][y] * 0.075) + (bitmapB[x][y] * 0.124) + (bitmapB[x+1][y] * 0.075)
              + (bitmapB[x-1][y+1] * 0.075) + (bitmapB[x][y+1] * 0.124) + (bitmapB[x+1][y+1] * 0.075);

    image1.Canvas.Pixels[x,y] := RGB(Trunc(gausR), Trunc(gausG), Trunc(gausB));
   end;
  end;

end;

procedure TForm1.ButtonInversClick(Sender: TObject);
begin

end;

end.

