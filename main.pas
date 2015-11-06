unit main;

interface

uses

Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
Dialogs, StdCtrls,ShellAPI,inifiles,registry,Des ,FileCtrl, jpeg, ExtCtrls;

type
TBruce = class(TForm)
    dlgOpen1: TOpenDialog;
    Image1: TImage;
    Button2: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    Button1: TButton;
    Label2: TLabel;
    Edit2: TEdit;
    Button3: TButton;
    Label3: TLabel;
    Edit3: TEdit;
    Button5: TButton;


    procedure FormCreate(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure JiaMI(var FilePath,MiMa:string);
    procedure JieMi(var DianFile:string);
    procedure ZhuCeCaiDan;
    procedure DelZhuCe;
    procedure Button1Click(Sender: TObject);
    procedure Edit2Exit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);

private
    { Private declarations }
public
    { Public declarations }
    end;

var
Bruce: TBruce;
FilePahtName :string;
 sRoot:WideString;
     sCaption:string;
implementation
uses Unit2;

{$R *.dfm}

procedure TBruce.JiaMI(var FilePath,MiMa:string);
var
DianFile,IniPath:string;
inifile: TInifile;

begin

DianFile:=FilePath+'..\';
iniPath:='dat.ini';
inifile:=TIniFile.Create(IniPath);

inifile.WriteString('111','key',DES.EncryStrHex(MiMa,'FEIGEW'));
inifile.Free;

renamefile(FilePath,DianFile);


end;

procedure TBruce.FormCreate(Sender: TObject);
var
i: Integer;

begin


ZhuCeCaiDan;
for i := 1 to ParamCount do
begin
    if LowerCase(ParamStr(i)) <> '' then begin
           FilePahtName:= ParamStr(i);
    end;
end;


end;

procedure TBruce.JieMi(var DianFile:string);
var
FileName,FileJD:string;
i:Integer;
begin
FileName:=DianFile+'.\';

I:=Length(FileName);

FileJD:=Copy(FileName,1,i-3);
renamefile(FileName,FileJD);


end;

procedure TBruce.ZhuCeCaiDan;
var

a:TRegistry;
begin 
a:=TRegistry.create;
a.rootkey:=HKEY_CLASSES_ROOT;

if a.openkey('Folder\Shell\cutbig',true) then
begin
//用writestring将设置值写入打开的主键
a.writestring('','加密/解密文件夹');
a.closekey;
end;
if a.openkey('Folder\Shell\cutbig\command',true) then
begin
//command子键的内容是点击右键后选择相应项后要运行的程序；
//%1是在单击右键时选中的文件名

a.writestring('','"'+Application.exeName+'" "%1"');
a.closekey;
end;
a.free;

end;

procedure TBruce.DelZhuCe;
var

a:TRegistry;
begin
a:=TRegistry.create;
a.rootkey:=HKEY_CLASSES_ROOT;
//用deletekey删除一个主键，其所包含的子键也被删除，如果已无此主键，运行删除操作不会带来别的危害
a.deletekey('Folder\Shell\cutbig');
a.free;

Application.MessageBox('成功删除系统右键菜单！', '成功', MB_OK +
MB_ICONINFORMATION);

end;

procedure TBruce.Button5Click(Sender: TObject);
begin
application.Terminate;
end;

procedure TBruce.Button1Click(Sender: TObject);
var
password:string;
begin
if FilePahtName='' then begin
Application.MessageBox('没有可加密的文件夹，请从文件夹上右键启动加密程序！',
    '系统', MB_OK + MB_ICONWARNING);
//Application.Terminate;
end;
    
if (Edit1.Text='') or (Edit2.text='') then begin
Application.MessageBox('密码不能为空，请输入你的密码！', '系统', MB_OK +
    MB_ICONWARNING);
Exit;
end;

if Edit2.Text=Edit1.Text then begin
password:=Edit2.Text;
    JiaMI(FilePahtName,password);
Application.MessageBox('文件夹添加密码成功，请牢记您的密码！', '系统', MB_OK
    + MB_ICONINFORMATION);

//Application.Terminate;
end else begin
Application.MessageBox('两次输入的密码不一致，请重新输入！', '系统', MB_OK + 
MB_ICONWARNING);
Edit2.SetFocus;
end;
end;

procedure TBruce.Edit2Exit(Sender: TObject);
begin
if Edit2.Text<>Edit1.Text then begin
Application.MessageBox('两次输入的密码不一致，请重新输入！', '系统', MB_OK + 
    MB_ICONWARNING);
Edit2.SetFocus;
end;
end;

procedure TBruce.FormShow(Sender: TObject);
begin
Edit1.SetFocus;
end;

procedure TBruce.Button2Click(Sender: TObject);

begin
   { FilePahtName:='';
  if not dlgOpen1.Execute then exit;
  FilePahtName:=dlgOpen1.FileName;

  ShowMessage(FilePahtName);}
 
   sCaption := '文件夹';       //弹出框标题名(非弹出框窗体名)
    sRoot := '';                    //初始文件夹(如'C:\','D:\DownLoad'等, 不存在则从桌面)
  

   begin
   if SelectDirectory(sCaption, sRoot, FilePahtName) then
//已返回所选文件夹路径给FilePahtName,自行处理
    end;
    ShowMessage(FilePahtName);
end;

procedure TBruce.Button3Click(Sender: TObject);
var
len:Integer;
   inifile: TInifile;
   IniPath,password,sstemp:string;
begin
Bruce.JieMi(FilePahtName);
len:=Length(FilePahtName);

sstemp:=Copy(FilePahtName,1,len-1);
iniPath:='dat.ini';

inifile:=TIniFile.Create(IniPath);
password:=inifile.ReadString('111','key','');
password:=des.DecryStrhex(password,'FEIGEW');
inifile.Free;

Bruce.JiaMI(sstemp,password);

if Edit3.Text=password then begin
Bruce.JieMi(FilePahtName);
DeleteFile(IniPath) ;
Application.MessageBox('文件夹解密成功！', '系统', MB_OK + MB_ICONINFORMATION);
Application.Terminate;
end else begin
Application.MessageBox('您输入的密码错误，请重新输入密码！', '系统', MB_OK +
    MB_ICONWARNING);
Edit3.SetFocus;
end;
end;


end.





