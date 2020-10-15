unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ExtDlgs, ComCtrls, Spin, windows, math, Strutils;

type

  { TForm1 }

  TForm1 = class(TForm)
    brightnessLabel: TLabel;
    brightnessLabel1: TLabel;
    ButtonBinary: TButton;
    ButtonGray: TButton;
    ButtonEdge: TButton;
    ButtonContrast: TButton;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    sharpenButton: TButton;
    resetButton: TButton;
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
    SpinBinary: TSpinEdit;
    TrackBarContrast: TTrackBar;
    TrackBarBrightness: TTrackBar;
    procedure ButtonBinaryClick(Sender: TObject);
    procedure ButtonContrastClick(Sender: TObject);
    procedure ButtonEdgeClick(Sender: TObject);
    procedure ButtonGrayClick(Sender: TObject);
    procedure ButtonInversClick(Sender: TObject);
    procedure ButtonSmoothClick(Sender: TObject);
    procedure loadButtonClick(Sender: TObject);
    procedure resetBrightnessButtonClick(Sender: TObject);
    procedure resetButtonClick(Sender: TObject);
    procedure saveButtonClick(Sender: TObject);
    procedure sharpenButtonClick(Sender: TObject);
    procedure TrackBarBrightnessChange(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  bitmapR, bitmapG, bitmapB : array [0..1000, 0..1000] of Byte; //variabel untuk gambar yang default belom dimanipulasi
  manipR, manipG, manipB : array [0..1000, 0..1000] of Byte; //variabel untuk gambar yang termanipulasi
  defaultBrightnessR, defaultBrightnessG, defaultBrightnessB : array [0..1000, 0..1000] of Byte; //variabel untuk default brightness

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
        manipR[x,y] := defaultBrightnessR[x,y];
        manipG[x,y] := defaultBrightnessG[x,y];
        manipB[x,y] := defaultBrightnessB[x,y];
      end;
    end;
  TrackBarBrightness.Position := 0;
end;

procedure TForm1.resetButtonClick(Sender: TObject);
var
  x,y : integer;
begin
  for y:=0 to image1.Height-1 do
    begin
      for x:=0 to image1.Width-1 do
      begin
        image1.Canvas.Pixels[x,y] := RGB(bitmapR[x,y], bitmapG[x,y], bitmapB[x,y]);
        defaultBrightnessR[x,y] := bitmapR[x,y];
        manipR[x,y] := bitmapR[x,y];
        defaultBrightnessG[x,y] := bitmapG[x,y];
        manipG[x,y] := bitmapG[x,y];
        defaultBrightnessB[x,y] := bitmapB[x,y];
        manipB[x,y] := bitmapB[x,y];
      end;
    end;
  TrackBarBrightness.Position := 0;
  TrackBarContrast.Position := 0;
end;

procedure TForm1.saveButtonClick(Sender: TObject); //save gambar yang udah dimanipulasi
begin
  if SavePictureDialog1.Execute then
  begin
    image1.Picture.SaveToFile(SavePictureDialog1.FileName);
  end;
end;

procedure TForm1.sharpenButtonClick(Sender: TObject);
var
  x, y, dbr, dbg, dbb  : integer;
  sharpR, sharpG, sharpB : double;
begin
  for y:= 0 to image1.height-1 do
  begin
   for x:= 0 to image1.width-1 do
   begin
    sharpR := (manipR[x-1][y-1] * (-0.1)) + (manipR[x][y-1] * (-0.1)) + (manipR[x+1][y-1] * (-0.1))
              + (manipR[x-1][y] * (-0.1)) + (manipR[x][y] * 1.8) + (manipR[x+1][y] * (-0.1))
              + (manipR[x-1][y+1] * (-0.1)) + (manipR[x][y+1] * (-0.1)) + (manipR[x+1][y+1] * (-0.1));
    sharpG := (manipG[x-1][y-1] * (-0.1)) + (manipG[x][y-1] * (-0.1)) + (manipG[x+1][y-1] * (-0.1))
              + (manipG[x-1][y] * (-0.1)) + (manipG[x][y] * 1.8) + (manipG[x+1][y] * (-0.1))
              + (manipG[x-1][y+1] * (-0.1)) + (manipG[x][y+1] * (-0.1)) + (manipG[x+1][y+1] * (-0.1));
    sharpB := (manipB[x-1][y-1] * (-0.1)) + (manipB[x][y-1] * (-0.1)) + (manipB[x+1][y-1] * (-0.1))
              + (manipB[x-1][y] * (-0.1)) + (manipB[x][y] * 1.8) + (manipB[x+1][y] * (-0.1))
              + (manipB[x-1][y+1] * (-0.1)) + (manipB[x][y+1] * (-0.1)) + (manipB[x+1][y+1] * (-0.1));

    //Pake ternary operator supaya nilainya ga negatif dan ga lebih dari 255 (Willy)
    manipR[x,y] := IfThen(sharpR < 0, 0, IfThen(sharpR > 255, 255, Trunc(sharpR)));
    manipG[x,y] := IfThen(sharpG < 0, 0, IfThen(sharpG > 255, 255, Trunc(sharpG)));
    manipB[x,y] := IfThen(sharpB < 0, 0, IfThen(sharpB > 255, 255, Trunc(sharpB)));

    image1.Canvas.Pixels[x,y] := RGB(manipR[x,y], manipG[x,y], manipB[x,y]);
    dbr := Trunc(manipR[x,y]/((100 + TrackBarBrightness.Position)/100));
    dbg := Trunc(manipG[x,y]/((100 + TrackBarBrightness.Position)/100));
    dbb := Trunc(manipB[x,y]/((100 + TrackBarBrightness.Position)/100));
    defaultBrightnessR[x,y] := IfThen(dbr < 0, 0, IfThen(dbr > 255, 255, Trunc(dbr)));
    defaultBrightnessG[x,y] := IfThen(dbg < 0, 0, IfThen(dbg > 255, 255, Trunc(dbg)));
    defaultBrightnessB[x,y] := IfThen(dbb < 0, 0, IfThen(dbb > 255, 255, Trunc(dbb)));
   end;
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
          manipR[x,y] := bitmapR[x,y];
          manipG[x,y] := bitmapG[x,y];
          manipB[x,y] := bitmapB[x,y];
        end;
      end;
    end;
end;

procedure TForm1.ButtonSmoothClick(Sender: TObject);
var
  x, y, dbr, dbg, dbb  : integer;
  gausR, gausG, gausB : double;
begin
  for y:= 0 to image1.height-1 do
  begin
   for x:= 0 to image1.width-1 do
   begin
    gausR := (manipR[x-1][y-1] * 0.075) + (manipR[x][y-1] * 0.124) + (manipR[x+1][y-1] * 0.075)
              + (manipR[x-1][y] * 0.124) + (manipR[x][y] * 0.204) + (manipR[x+1][y] * 0.124)
              + (manipR[x-1][y+1] * 0.075) + (manipR[x][y+1] * 0.124) + (manipR[x+1][y+1] * 0.075);
    gausG := (manipG[x-1][y-1] * 0.075) + (manipG[x][y-1] * 0.124) + (manipG[x+1][y-1] * 0.075)
              + (manipG[x-1][y] * 0.124) + (manipG[x][y] * 0.204) + (manipG[x+1][y] * 0.124)
              + (manipG[x-1][y+1] * 0.075) + (manipG[x][y+1] * 0.124) + (manipG[x+1][y+1] * 0.075);
    gausB := (manipB[x-1][y-1] * 0.075) + (manipB[x][y-1] * 0.124) + (manipB[x+1][y-1] * 0.075)
              + (manipB[x-1][y] * 0.124) + (manipB[x][y] * 0.204) + (manipB[x+1][y] * 0.124)
              + (manipB[x-1][y+1] * 0.075) + (manipB[x][y+1] * 0.124) + (manipB[x+1][y+1] * 0.075);

    image1.Canvas.Pixels[x,y] := RGB(Trunc(gausR), Trunc(gausG), Trunc(gausB));
    dbr := Trunc(gausR/((100 + TrackBarBrightness.Position)/100));
    dbg := Trunc(gausG/((100 + TrackBarBrightness.Position)/100));
    dbb := Trunc(gausB/((100 + TrackBarBrightness.Position)/100));
    defaultBrightnessR[x,y] := IfThen(dbr < 0, 0, IfThen(dbr > 255, 255, Trunc(dbr)));
    defaultBrightnessG[x,y] := IfThen(dbg < 0, 0, IfThen(dbg > 255, 255, Trunc(dbg)));
    defaultBrightnessB[x,y] := IfThen(dbb < 0, 0, IfThen(dbb > 255, 255, Trunc(dbb)));
    manipR[x,y] := Trunc(gausR);
    manipG[x,y] := Trunc(gausG);
    manipB[x,y] := Trunc(gausB);
   end;
  end;

end;

procedure TForm1.ButtonInversClick(Sender: TObject);
var
  x, y, dbr, dbg, dbb: integer;
begin
  for y:= 0 to image1.height-1 do
  begin
   for x:= 0 to image1.width-1 do
   begin
    manipR[x,y] := 255 - manipR[x,y];
    manipG[x,y] := 255 - manipG[x,y];
    manipB[x,y] := 255 - manipB[x,y];

    image1.Canvas.Pixels[x,y] := RGB(manipR[x,y], manipG[x,y], manipB[x,y]);
    dbr := Trunc(manipR[x,y]/((100 + TrackBarBrightness.Position)/100));
    dbg := Trunc(manipG[x,y]/((100 + TrackBarBrightness.Position)/100));
    dbb := Trunc(manipB[x,y]/((100 + TrackBarBrightness.Position)/100));
    defaultBrightnessR[x,y] := IfThen(dbr < 0, 0, IfThen(dbr > 255, 255, Trunc(dbr)));
    defaultBrightnessG[x,y] := IfThen(dbg < 0, 0, IfThen(dbg > 255, 255, Trunc(dbg)));
    defaultBrightnessB[x,y] := IfThen(dbb < 0, 0, IfThen(dbb > 255, 255, Trunc(dbb)));
   end;
  end;

end;

procedure TForm1.ButtonContrastClick(Sender: TObject);
var
  x, y, contrast, dbr, dbg, dbb : integer;
  factor, newRed, newGreen, newBlue : real;
begin
  contrast := TrackBarContrast.Position;
  factor := (259 * (contrast + 255)) / (255 * (259 - contrast));

  // copy of integer
  for y := 0 to image1.Height-1 do
  begin
       for x := 0 to image1.Width-1 do
       begin
            newRed   := manipR[x,y];
            newGreen := manipG[x,y];
            newBlue  := manipB[x,y];

            newRed   := (factor * (newRed - 128) + 128);
            newGreen := (factor * (newGreen - 128) + 128);
            newBlue  := (factor * (newBlue - 128) + 128);

            if newRed > 255 then newRed := 255 else if newRed < 0 then newRed := 0;
            if newGreen > 255 then newGreen := 255 else if newGreen < 0 then newGreen := 0;
            if newBlue > 255 then newBlue := 255 else if newBlue < 0 then newBlue := 0;

            Image1.Canvas.Pixels[x,y] := RGB(Trunc(newRed), Trunc(newGreen), Trunc(newBlue));

            dbr := Trunc(newRed/((100 + TrackBarBrightness.Position)/100));
            dbg := Trunc(newGreen/((100 + TrackBarBrightness.Position)/100));
            dbb := Trunc(newBlue/((100 + TrackBarBrightness.Position)/100));
            defaultBrightnessR[x,y] := IfThen(dbr < 0, 0, IfThen(dbr > 255, 255, Trunc(dbr)));
            defaultBrightnessG[x,y] := IfThen(dbg < 0, 0, IfThen(dbg > 255, 255, Trunc(dbg)));
            defaultBrightnessB[x,y] := IfThen(dbb < 0, 0, IfThen(dbb > 255, 255, Trunc(dbb)));

            manipR[x,y] := Trunc(newRed);
            manipG[x,y] := Trunc(newGreen);
            manipB[x,y] := Trunc(newBlue);
       end;
  end;
end;

procedure TForm1.ButtonBinaryClick(Sender: TObject);
var
  x, y, biner : integer;
begin
  for y:= 0 to image1.height-1 do
  begin
   for x:= 0 to image1.width-1 do
   begin
    biner := (manipR[x,y] + manipG[x,y] + manipB[x,y]) div 3;
    biner := IfThen(biner < SpinBinary.Value, 0, 255);

    image1.Canvas.Pixels[x,y] := RGB(biner, biner, biner);
    manipR[x,y] := biner;
    manipG[x,y] := biner;
    manipB[x,y] := biner;
   end;
  end;
end;

procedure TForm1.ButtonEdgeClick(Sender: TObject);
var
  grey : array[0..1000,0..1000] of integer;
  sobelx, sobely : array [0..3,0..3] of integer;
  sblx, sbly, sbl, i, j : integer;
begin
  // SOBEL X
  sobelx[0,0] := -1;
  sobelx[0,1] := 0;
  sobelx[0,2] := 1;

  sobelx[1,0] := -2;
  sobelx[1,1] := 0;
  sobelx[1,2] := 2;

  sobelx[2,0] := -1;
  sobelx[2,1] := 0;
  sobelx[2,2] := 1;

  // SOBEL Y
  sobely[0,0] := -1;
  sobely[0,1] := -2;
  sobely[0,2] := -1;

  sobely[1,0] := 0;
  sobely[1,1] := 0;
  sobely[1,2] := 0;

  sobely[2,0] := 1;
  sobely[2,1] := 2;
  sobely[2,2] := 1;

  // Grayscalling
  for j := 0 to Image1.Height-1 do
  begin
       for i := 0 to Image1.Width-1 do
       begin
            grey[i,j] := (bitmapR[i,j] + bitmapG[i,j] + bitmapB[i,j]) div 3;
       end;
  end;

  for j := 0 to Image1.Height-1 do
  begin
       for i := 0 to Image1.Width-1 do
       begin
            // SOBEL X
            sblx := (grey[i-1,j-1] * sobelx[0,0]) + (grey[i,j-1] * sobelx[0,1]) + (grey[i+1,j-1] * sobelx[0,2])
                   + (grey[i-1,j] * sobelx[1,0]) + (grey[i,j] * sobelx[1,1]) + (grey[i+1,j] * sobelx[1,2])
                   + (grey[i-1,j+1] * sobelx[2,0]) + (grey[i,j+1] * sobelx[2,1]) + (grey[i+1,j+1] * sobelx[2,2]);

            // SOBEL Y
            sbly := (grey[i-1,j-1] * sobely[0,0]) + (grey[i,j-1] * sobely[0,1]) + (grey[i+1,j-1] * sobely[0,2])
                   + (grey[i-1,j] * sobely[1,0]) + (grey[i,j] * sobely[1,1]) + (grey[i+1,j] * sobely[1,2])
                   + (grey[i-1,j+1] * sobely[2,0]) + (grey[i,j+1] * sobely[2,1]) + (grey[i+1,j+1] * sobely[2,2]);

            // Callibrating
            if sblx > 255 then sblx := 255 else
            if sblx < 0 then sblx := 0 else sblx := round(sblx);

            if sbly > 255 then sbly := 255 else
            if sbly < 0 then sbly := 0 else sbly := round(sbly);

            sbl := round(sqrt((sblx * sblx) + (sbly * sbly)));

            Image1.Canvas.Pixels[i,j] := RGB(sbl, sbl, sbl);
       end;
  end;
end;

procedure TForm1.ButtonGrayClick(Sender: TObject);
var
  x, y, gray, db : integer;
begin
  for y:= 0 to image1.height-1 do
  begin
   for x:= 0 to image1.width-1 do
   begin
    gray := (manipR[x,y] + manipG[x,y] + manipB[x,y]) div 3;

    image1.Canvas.Pixels[x,y] := RGB(gray, gray, gray);
    manipR[x,y] := gray;
    manipG[x,y] := gray;
    manipB[x,y] := gray;

    db := Trunc(gray/((100 + TrackBarBrightness.Position)/100));
    defaultBrightnessR[x,y] := IfThen(db < 0, 0, IfThen(db > 255, 255, Trunc(db)));
    defaultBrightnessG[x,y] := IfThen(db < 0, 0, IfThen(db > 255, 255, Trunc(db)));
    defaultBrightnessB[x,y] := IfThen(db < 0, 0, IfThen(db > 255, 255, Trunc(db)));
   end;
  end;
end;

end.

