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
    //ȡ�������ʼ��ĵ�ַ
    function GetMailAdder(AUserNames:string):string;
    //���͵�����
    procedure SendMail(AEmailto:String;AMailType:Integer;AZID:Integer);

    //��ʾ���ȴ���
    procedure ShowProgress(const Title: string;ACount:integer);
    procedure HideProgress;
    procedure UpdateProgress(Value: Integer);
    procedure UpdateProgressTitle(const Title: string);

    function NewGuid: string;
  end;

var
  BaseChildDlg: TBaseChildDlg;

implementation
uses
  ClinetSystemUnits, Mainfrm,CnProgressFrm, DmUints;

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

function TBaseChildDlg.GetMailAdder(AUserNames: string): string;
var
  i : integer;
  mysv,mysl : TStringList;
  mystr,mymail : string;
begin
  mysv := TStringList.Create;
  mysl := TStringList.Create;
  try
    mysv.Delimiter := ';';
    mysv.DelimitedText := AUserNames;
    mymail := '';
    for i:=0 to  mysv.Count -1 do
    begin
      //���ǵ�ǰ�ı༭�ڶ�����Ҫ������
      if (Trim(mysv.Strings[i])='') or
         (mysv.Strings[i]=Format('%s(%d)',[ClientSystem.fEditer,ClientSystem.fEditer_id])) then
        Continue;

      if mysl.IndexOf(mysv[i]) < 0 then
      begin
        mysl.Add(mysv[i]);
        DM.cdsUser.First;
        while not DM.cdsUser.Eof do
        begin
          myStr := format('%s(%d)',[DM.cdsUser.FieldByName('ZNAME').AsString,
            DM.cdsUser.FieldByName('ZID').AsInteger]);
          if CompareText(myStr,mysv[i]) = 0 then
          begin
            if mymail = '' then
              mymail := DM.cdsUser.FieldByName('ZEMAIL').AsString
            else
              mymail := mymail + ';' + DM.cdsUser.FieldByName('ZEMAIL').AsString;
            break;
          end;
          DM.cdsUser.Next;
        end;
      end;
    end;
    Result := mymail;
  finally
    mysv.free;
    mysl.Free;
  end;
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

function TBaseChildDlg.NewGuid: string;
var
  aGuid: TGUID;
begin
  CreateGUID(aGuid);
  result:=GUIDToString(aGuid);
  result:=Copy(result, 2, 36);
end;

procedure TBaseChildDlg.SendMail(AEmailto: String;
  AMailType:Integer;AZID:Integer);
var
  mystr : string;
begin
  mystr := GetMailAdder(AEmailto);
  if mystr <> '' then
    ClientSystem.fDbOpr.MailTo(AMailType,myStr,AZID);
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
