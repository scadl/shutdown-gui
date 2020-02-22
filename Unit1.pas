unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, Buttons, ExtCtrls, shellapi;

type
  TForm1 = class(TForm)
    rgAction: TRadioGroup;
    gpInterval: TGroupBox;
    rgTimerType: TRadioGroup;
    bBtnRun: TBitBtn;
    SpinEdit1: TSpinEdit;
    Label0: TLabel;
    SpinEdit2: TSpinEdit;
    Label1: TLabel;
    SpinEdit3: TSpinEdit;
    Label2: TLabel;
    gpAdditional: TGroupBox;
    cbVisualTimer: TCheckBox;
    cbForceShutdown: TCheckBox;
    btnSetReason: TButton;
    bBtnCancel: TBitBtn;
    DebugLabel: TLabel;
    timeVisInterval: TTimer;
    timeShutdown: TTimer;
    procedure bBtnRunClick(Sender: TObject);
    procedure timeVisIntervalTimer(Sender: TObject);
    procedure btnSetReasonClick(Sender: TObject);
    procedure rgActionClick(Sender: TObject);
    procedure rgTimerTypeClick(Sender: TObject);
    procedure bBtnCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  secbuf: integer;
  reas: string;

implementation

{$R *.dfm}

procedure TForm1.bBtnRunClick(Sender: TObject);
var
  mc, ac: string[4];
  command: string;
  hs, ms, ss, timesec: integer;
begin

  case rgAction.ItemIndex of
    0:
      mc := '-s ';
    1:
      mc := '-p ';
    2:
      mc := '-l ';
    3:
      mc := '-r ';
    4:
      mc := '-g ';
    5:
      mc := '-h ';
  end;

  if SpinEdit1.Value <> 0 then
    hs := SpinEdit1.Value * 3600
  else
    hs := 0;
  if SpinEdit2.Value <> 0 then
    ms := SpinEdit2.Value * 60
  else
    ms := 0;
  if SpinEdit3.Value <> 0 then
    ss := SpinEdit3.Value
  else
    ss := 0;

  case rgAction.ItemIndex of
    0:
      begin
        timesec := hs + ms + ss;
        secbuf := timesec;
      end;
    1:
      begin
        timesec := 1;
        timeShutdown.Interval := (hs + ms + ss) * 1000;
        secbuf := timeShutdown.Interval div 1000;
        timeShutdown.Enabled := true;
      end;
  end;

  if cbForceShutdown.Checked then
    ac := '-f '
  else
    ac := '';

  if cbVisualTimer.Checked then
    timeVisInterval.Enabled := true;

  if reas <> '' then
    reas := ' -c "' + reas + '"';

  command := ' ' + mc + ac;

  if(rgAction.ItemIndex < 5) then
    command := command + '-t ' + inttostr(timesec) + reas;

  if(rgAction.ItemIndex = 5) then
    WinExec('powercfg -h on', SW_SHOWNORMAL);

  if(rgAction.ItemIndex = 6)
  then
  begin
    WinExec('powercfg -h off', SW_SHOWNORMAL);
    WinExec('RUNDLL32.EXE powrprof.dll,SetSuspendState 0,1,0', SW_HIDE);
  end
  else
    ShellExecute(Application.Handle, pchar('open'), pchar('shutdown'), pchar(command), '', SW_SHOWNORMAL);

  bBtnCancel.Enabled := true;
  bBtnRun.Enabled := false;

  gpInterval.Enabled := false;
  rgAction.Enabled := false;
  SpinEdit1.Enabled := false;
  SpinEdit2.Enabled := false;
  SpinEdit3.Enabled := false;
  Label0.Enabled := false;
  Label1.Enabled := false;
  Label2.Enabled := false;
  gpAdditional.Enabled := false;
  cbVisualTimer.Enabled := false;
  cbForceShutdown.Enabled := false;
  rgAction.Enabled := false;
  // DebugLabel.Caption:=command;
end;

procedure TForm1.bBtnCancelClick(Sender: TObject);
begin
  WinExec('shutdown -a', SW_hide);
  timeShutdown.Enabled := false;
  timeVisInterval.Enabled := false;
  bBtnRun.Caption := 'Выполнить';

  rgAction.Enabled := true;
  rgAction.ItemIndex := -1;
  rgAction.ItemIndex := -1;

  bBtnCancel.Enabled := false;
  bBtnRun.Enabled := true;
end;

procedure TForm1.btnSetReasonClick(Sender: TObject);
begin
  reas := InputBox('Прина отключения',
    'Напишите здесь напоминание для себя, почему вы запланировали отключение:',
    '');
  if reas <> '' then
  begin
    rgAction.Caption := 'Причина указана';
    rgAction.Font.Style := [fsItalic];
  end;
end;

procedure TForm1.rgActionClick(Sender: TObject);
var
  continue: boolean;
begin
  continue := true;
  if (rgAction.ItemIndex = 1) or (rgAction.ItemIndex = 4) or (rgAction.ItemIndex = 5) then
  begin
    continue := false;
    if (Win32Platform = VER_PLATFORM_WIN32_NT) then
    begin
      if (rgAction.ItemIndex = 1) then
      begin
        bBtnRun.Enabled := true;
        cbForceShutdown.Checked := true;
      end;
      if (rgAction.ItemIndex = 4) then
      begin
        continue := true;
      end;
      if (rgAction.ItemIndex = 5) then
      begin
        bBtnRun.Enabled := true;
      end;
    end
    else
    begin
      MessageDlg('В вашей ОС не поддерживается данная функция!', mtError,
        [mbOK], 0);
      rgAction.ItemIndex := -1;
    end;
  end;

  if (rgAction.ItemIndex = 2) or (rgAction.ItemIndex=6) then
  begin
    bBtnRun.Enabled := true;
    continue := false;
  end;

  if continue then
  begin
    rgTimerType.Enabled := true;
    bBtnRun.Enabled := false;
    rgAction.Enabled := false;
  end;
end;

procedure TForm1.rgTimerTypeClick(Sender: TObject);
begin
  gpInterval.Enabled := true;
  SpinEdit1.Enabled := true;
  SpinEdit2.Enabled := true;
  SpinEdit3.Enabled := true;
  Label0.Enabled := true;
  Label1.Enabled := true;
  Label2.Enabled := true;
  gpAdditional.Enabled := true;
  cbVisualTimer.Enabled := true;
  cbForceShutdown.Enabled := true;
  btnSetReason.Enabled := true;
  bBtnRun.Enabled := true;
end;

procedure TForm1.timeVisIntervalTimer(Sender: TObject);
begin
  secbuf := secbuf - 1;
  bBtnRun.Caption := 'До выключения осталось: ' + inttostr(secbuf) +
    ' секунд...';
end;

end.
