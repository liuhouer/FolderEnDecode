unit Unit2;

interface

uses
Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
Dialogs, StdCtrls,des;

type
TForm2 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    Button2: TButton;
    Edit1: TEdit;
    GroupBox1: TGroupBox;


    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
private
    { Private declarations }
public
    { Public declarations }
end;

var
Form2: TForm2;

implementation
uses main,IniFiles;
{$R *.dfm}

procedure TForm2.Button2Click(Sender: TObject);
begin
Application.Terminate;
end;

procedure TForm2.Button1Click(Sender: TObject);
var
len:Integer;
   inifile: TInifile;
   IniPath,password,sstemp:string;
begin
Bruce.JieMi(FilePahtName);
len:=Length(FilePahtName);

sstemp:=Copy(FilePahtName,1,len-1);
iniPath:=sstemp +'\dat.ini';

inifile:=TIniFile.Create(IniPath);
password:=inifile.ReadString('111','key','');
password:=des.DecryStrhex(password,'FEIGEW');
inifile.Free;

Bruce.JiaMI(sstemp,password);

if Edit1.Text=password then begin
Bruce.JieMi(FilePahtName);
DeleteFile(IniPath) ;
Application.MessageBox('文件夹解密成功！', '系统', MB_OK + MB_ICONINFORMATION);
Application.Terminate;
end else begin
Application.MessageBox('您输入的密码错误，请重新输入密码！', '系统', MB_OK + 
    MB_ICONWARNING);
Edit1.SetFocus;
end;
end;

procedure TForm2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Application.Terminate;
end;

end.

 