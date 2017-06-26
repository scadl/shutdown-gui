unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, Buttons, ExtCtrls, shellapi, uwinversion;

type
  TForm1 = class(TForm)
    RadioGroup1: TRadioGroup;
    GroupBox1: TGroupBox;
    RadioGroup2: TRadioGroup;
    BitBtn1: TBitBtn;
    SpinEdit1: TSpinEdit;
    Label0: TLabel;
    SpinEdit2: TSpinEdit;
    Label1: TLabel;
    SpinEdit3: TSpinEdit;
    Label2: TLabel;
    ShutdownTimer: TTimer;
    GroupBox2: TGroupBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Button1: TButton;
    BitBtn2: TBitBtn;
    DebugLabel: TLabel;
    Timer1: TTimer;
    procedure BitBtn1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure RadioGroup2Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  secbuf:integer;
  reas:string;

implementation

{$R *.dfm}

procedure TForm1.BitBtn1Click(Sender: TObject);
var mc,ac:string[4]; command:string; hs,ms,ss,timesec:integer;
begin

case RadioGroup1.ItemIndex of
0:mc:='-s ';
1:mc:='-p ';
2:mc:='-l ';
3:mc:='-r ';
4:mc:='-g ';
5:mc:='-h ';
end;

if SpinEdit1.Value<>0 then hs:=SpinEdit1.Value*3600 else hs:=0;
if SpinEdit2.Value<>0 then ms:=SpinEdit2.Value*60 else ms:=0;
if SpinEdit3.Value<>0 then ss:=SpinEdit3.Value else ss:=0;

case RadioGroup2.ItemIndex of
0: begin
    timesec:=hs+ms+ss;
    secbuf:=timesec;
  end;
1: begin
    timesec:=1;
    ShutdownTimer.Interval:=(hs+ms+ss)*1000;
    secbuf:=ShutdownTimer.Interval div 1000;
    ShutdownTimer.Enabled:=true;
  end;
end;

if CheckBox2.Checked then ac:='-f ' else ac:='';
if CheckBox1.Checked then Timer1.Enabled:=true;

if reas<>'' then reas:=' -c "'+reas+'"';

command:=' '+mc+ac+'-t '+inttostr(timesec)+reas;
ShellExecute(Application.Handle,pchar('open'),pchar('shutdown'), pchar(command),'',SW_SHOWNORMAL);

BitBtn2.Enabled:=true;
BitBtn1.Enabled:=false;

GroupBox1.Enabled:=false;
RadioGroup2.Enabled:=false;
SpinEdit1.Enabled:=false;
SpinEdit2.Enabled:=false;
SpinEdit3.Enabled:=false;
label0.Enabled:=false;
label1.Enabled:=false;
label2.Enabled:=false;
GroupBox2.Enabled:=false;
CheckBox1.Enabled:=false;
CheckBox2.Enabled:=false;
Button1.Enabled:=false;
//DebugLabel.Caption:=command;
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
begin
WinExec('shutdown -a',SW_hide);
ShutdownTimer.Enabled:=false;
Timer1.Enabled:=false;
BitBtn1.Caption:='Выполнить отключение';

RadioGroup1.Enabled:=true;
RadioGroup1.ItemIndex:=-1;
RadioGroup2.ItemIndex:=-1;

BitBtn2.Enabled:=false;
BitBtn1.Enabled:=true;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
reas:=InputBox('Прина отключения','Напишите здесь напоминание для себя, почему вы запланировали отключение:','');
if reas<>'' then
  begin
    Button1.Caption:='Причина указана';
    Button1.Font.Style:=[fsItalic];
  end;
end;

procedure TForm1.RadioGroup1Click(Sender: TObject);
var continue:boolean;
begin
continue:=true;
if (RadioGroup1.ItemIndex=1) or (RadioGroup1.ItemIndex=4) or (RadioGroup1.ItemIndex=5) then
  begin
    continue:=false;
    if (TOSInfo.IsWin7) or (TOSInfo.IsWinVista) then
      begin
        if (RadioGroup1.ItemIndex=1) then begin BitBtn1.Enabled:=true; CheckBox2.Checked:=true; end;
        if (RadioGroup1.ItemIndex=4) then begin continue:=true; end;
        if (RadioGroup1.ItemIndex=5) then begin BitBtn1.Enabled:=true; end;
      end
    else
      begin
        MessageDlg('В вашей ОС не поддерживается данная функция!',mtError,[mbOK],0);
        RadioGroup1.ItemIndex:=-1;
      end;
  end;

if (RadioGroup1.ItemIndex=2) then
  begin
    BitBtn1.Enabled:=true;
    continue:=false;
  end;

if continue then begin RadioGroup2.Enabled:=true; BitBtn1.Enabled:=false; RadioGroup1.Enabled:=false; end;
end;

procedure TForm1.RadioGroup2Click(Sender: TObject);
begin
GroupBox1.Enabled:=true;
SpinEdit1.Enabled:=true;
SpinEdit2.Enabled:=true;
SpinEdit3.Enabled:=true;
label0.Enabled:=true;
label1.Enabled:=true;
label2.Enabled:=true;
GroupBox2.Enabled:=true;
CheckBox1.Enabled:=true;
CheckBox2.Enabled:=true;
Button1.Enabled:=true;
BitBtn1.Enabled:=true;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
secbuf:=secbuf-1;
BitBtn1.Caption:='До выключения осталось: '+ inttostr(secbuf) +' секунд...';
end;

end.
