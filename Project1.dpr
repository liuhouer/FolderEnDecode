program Project1;

uses
  Forms,
  SysUtils,
  main in 'main.pas' {Bruce},
  Unit2 in 'Unit2.pas' {Form2};

var FilePahtName:string;
{$R *.res}
procedure QiDong();
var i:Integer;
begin
for i := 1 to ParamCount do
begin
    if LowerCase(ParamStr(i)) <> '' then begin
           FilePahtName:= ParamStr(i);
    end;
end;
end;
var len:Integer;
fileTemp:string;
begin
//Application.Initialize;
Application.CreateForm(TBruce, Bruce);
  QiDong;
len:=Length(FilePahtName);
fileTemp:=Copy(FilePahtName,len,len);
if fileTemp='.' then   begin
Application.ShowMainForm:=False;

Application.CreateForm(TForm2, Form2);
Form2.Show;
end;

Application.Run;

end.
