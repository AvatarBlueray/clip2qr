unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,ClipBrd,QuricolCode, TlHelp32;

type
  TForm1 = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    function processExists(exeFileName: string): Boolean;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    hotkey1,hotkey2: Integer;
    ma:array [1..40] of integer;
    bmp:TBitmap;
    procedure WMHotKey(var Msg : TWMHotKey); message WM_HOTKEY;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}


function tform1.processExists(exeFileName: string): Boolean;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
  first:BOOL;
begin
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  Result := False;
  first:=False;
  while Integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) =
      UpperCase(ExeFileName)) or (UpperCase(FProcessEntry32.szExeFile) =
      UpperCase(ExeFileName))) then
    begin
      if first then
      Result := True;
      first:=True;
    end;
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end; 
procedure TForm1.FormCreate(Sender: TObject);
const MOD_CONTROL = 1
;
VK_q = 81;
vk_esc = 27;


begin
  if processExists (ExtractFileName(Application.ExeName)) then
  begin
         Application.Terminate;
         Exit;
  end;


Form1.DoubleBuffered:=True;
ma[1]:=25;
ma[2]:=47;
ma[3]:=77;
ma[4]:=114;
ma[5]:=154;
ma[6]:=195;
ma[7]:=224;
ma[8]:=279;
ma[9]:=335;
ma[10]:=395;
ma[11]:=468;
ma[12]:=535;
ma[13]:=619;
ma[14]:=667;
ma[15]:=758;
ma[16]:=854;
ma[17]:=938;
ma[18]:=1046;
ma[19]:=1153;
ma[20]:=1249;
ma[21]:=1352;
ma[22]:=1460;
ma[23]:=1588;
ma[24]:=1704;
ma[25]:=1853;
ma[26]:=1990;
ma[27]:=2132;
ma[28]:=2223;
ma[29]:=2369;
ma[30]:=2520;
ma[31]:=2677;
ma[32]:=2840;
ma[33]:=3009;
ma[34]:=3183;
ma[35]:=3351;
ma[36]:=3537;
ma[37]:=3729;
ma[38]:=3927;
ma[39]:=4087;
ma[40]:=4296;
bmp:=TBitmap.Create;
bmp.Width:=5;
bmp.Height:=5;
hotkey2 := GlobalAddAtom('Hotkey2');
   hotkey1 := GlobalAddAtom('Hotkey1');
RegisterHotKey(handle, hotkey1, MOD_CONTROL,VK_q);

end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
UnRegisterHotKey(handle, hotkey1);
end;

procedure TForm1.WMHotKey (var Msg : TWMHotKey);
var
  SomeStringData_Variable :string;
  len,scale:Integer;
  Size:integer;
  i:Integer;

begin
if msg.HotKey = hotkey1 then
begin
  if Clipboard.HasFormat(CF_TEXT) then
  begin
    SomeStringData_Variable:= Clipboard.AsText;
    len:=length(   SomeStringData_Variable);
    scale:=0;

    for i:= 1 to 40 do
    begin
      if ma[i]>len then
      begin
        scale:= 17+4*(i+4);
        Break;
      end;

    end;
    if scale = 0 then
    begin
      ShowMessage( 'To long text');
    end
    else
    begin
      if Screen.Width < Screen.Height then
       size:= (Screen.Width*3) Div  5
      else
        size:= (Screen.Height * 4 ) div 5;

        size:= Size div scale;

        if Size > 0 then
        begin

              if bmp.width <> 0 then
              bmp.Free;

               
              bmp := TQRCode.GetBitmapImage(SomeStringData_Variable,4,size);

              Form1.Width:=bmp.Width;
              form1.Height:=bmp.Height;
              Form1.Left:=(Screen.Width - bmp.Width) div 2;
              Form1.Top:= (Screen.Height- bmp.Height) div 2;
          Form1.Show;
          Form1.Canvas.Draw(0,0,bmp);

             
             RegisterHotKey(handle, hotkey2, 0,27);
      //  bmp.Free;

        end
        else
        ShowMessage('To large');

    end;

  
  end;
end;

if msg.HotKey = hotkey2 then
begin
  UnRegisterHotKey(handle, hotkey2);
  Form1.hide;
end;
end;
procedure TForm1.FormPaint(Sender: TObject);
begin
form1.Canvas.Draw(0,0,bmp);
end;

procedure TForm1.FormShow(Sender: TObject);
begin
 SetWindowPos(Application.Handle,
         HWND_TOPMOST,
         0, 0, 0, 0,
         SWP_NOACTIVATE+SWP_NOMOVE+SWP_NOSIZE);
end;

end.
