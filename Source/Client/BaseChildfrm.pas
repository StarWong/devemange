unit BaseChildfrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  ClientTypeUnits;

type
  TBaseChildClass = class of TBaseChildDlg;
  
  TBaseChildDlg = class(TForm)
  private

  public
    fLoading : Boolean;

    procedure initBase; virtual;
    procedure freeBase; virtual;
    procedure Showfrm ; virtual;  //��ʾ�������¼�
    procedure Closefrm; virtual;  //�ر���ʾ�������¼�

    class function GetModuleID : integer;virtual; //ȡ��ģ��ID
    //����Ȩ��
    //
    // ASubModule Ϊ��ģ���id��
    // AID Ϊ��ģ������Ĺ��� ,��ֲ���ID, ���� Bug�µķֲ�ID
    //   ����AID�ǲ��������ID
    //
    function HasModuleAction(ASubStype:integer;AID:integer;AAction:TActionType):Boolean;
    function HasModuleActionByShow(ASubStype:integer;AID:integer;AAction:TActionType):Boolean;

    //��ʾ״̬����
    procedure ShowStatusBarText(Aindex:integer;AStr:String);

    //��ʾ���ȴ���
    procedure ShowProgress(const Title: string;ACount:integer);
    procedure HideProgress;
    procedure UpdateProgress(Value: Integer);
    procedure UpdateProgressTitle(const Title: string);
  end;

var
  BaseChildDlg: TBaseChildDlg;

implementation
uses
  ClinetSystemUnits, Mainfrm,CnProgressFrm;

{$R *.dfm}

{ TBaseChildDlg }

procedure TBaseChildDlg.Closefrm;
begin
  //��������
end;

procedure TBaseChildDlg.freeBase;
begin
  //��������
end;

class function TBaseChildDlg.GetModuleID: integer;
begin
  Result := -1;
end;

function TBaseChildDlg.HasModuleAction(ASubStype:integer;AID: integer;
  AAction: TActionType): Boolean;
var
  myStyle : integer;
begin
  myStyle := GetModuleID; //ȡ���ܵ�ģ��
  Result := ClientSystem.HasModuleAction(myStyle,{myStyle+}ASubStype,
    AID,AAction);
end;

function TBaseChildDlg.HasModuleActionByShow(ASubStype, AID: integer;
  AAction: TActionType): Boolean;
begin
  Result := HasModuleAction(ASubStype,AID,AAction);
  if not Result and (AID<>1) then   //AID<>1 ����㲻��ʾ
    MessageBox(Handle,PChar(format('��û��%s������Ȩ��',[ActionTypeName[AAction]])),
      '��ʾ',MB_ICONWARNING+MB_OK);
end;

procedure TBaseChildDlg.HideProgress;
begin
  CnProgressFrm.HideProgress;  
end;

procedure TBaseChildDlg.initBase;
begin
  fLoading := False;
  //��������
end;

procedure TBaseChildDlg.Showfrm;
begin
  //��������
end;

procedure TBaseChildDlg.ShowProgress(const Title: string; ACount: integer);
begin
  CnProgressFrm.ShowProgress(Title,ACount);
end;

procedure TBaseChildDlg.ShowStatusBarText(Aindex: integer; AStr: String);
begin
  if Application.MainForm is TMainDlg then
  begin
    (Application.MainForm as TMainDlg).StatusBarMain.Panels[Aindex].Text := AStr;
  end;
end;

procedure TBaseChildDlg.UpdateProgress(Value: Integer);
begin
  CnProgressFrm.UpdateProgress(Value);
end;

procedure TBaseChildDlg.UpdateProgressTitle(const Title: string);
begin
  CnProgressFrm.UpdateProgressTitle(Title);
end;

end.
