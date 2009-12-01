///////////////////////////////////////////////////////////////////////////////
//
// �ӿڵĶ���ʵ������
// ��������:2007-11-1 ����:������
// �汾: 1.0.1 
//
//
//  1.�޸���д��־Ŀ¼û�д���ʱ,����. 2008-3-20
//  2.�������Ӳ�����ʾ���� 2008-3-20
//  3.���� GetSysDateTime�ķ���(); 2008-3-24 by mrlong
//  4.�޸� ReadVariant()����һֱû��дʵ�� 2008-5-13
//  5.�޸� fSocketServer.SupportCallbacks := False ��֧�ֻص� by mrlong 2008-5-31 ver=1.0.2
//  6.ɾ����Dcom�����ӣ���Ҫ��..... ver=1.0.5
//  7.����zlib�İ汾 ver=1.0.7
//  8.���ӵ�������FastMM,FatCode ,�粻Ҫ���Խ���������FastXXȥ�������� ����:������ 2009-11-23 ver=1.0.8
//
//
///////////////////////////////////////////////////////////////////////////////
unit DbApiImpl;

interface
uses
  Classes,DBClient,SysUtils,DB,
  MConnect,SConnect,
  DBSocketConnection,
  ExtCtrls,
  DbApiIntf;



const
  gcTimeOut = 1000*10*10*5;//5����
  gc_Class_GUID : array[0..4] of string =
  ('{B4AA6BE1-5DEF-431A-AFA0-F1262EDB4C5A}',
   '{7B1AA46A-8C7D-4C89-BC7C-04129CC66D2A}',
   '{24D5C599-7790-44F1-ACBF-EAD2E8192205}',
   '{588580BC-AB3A-4B4A-BD53-9AF64C7ADA3B}',
   '{F1B0B88B-327F-4C78-9C11-B7A98B1086C1}');

type

  TBfssDBOpr = class(TInterfacedObject, IDbOperator)
  private
    fLogFile:textfile;

    fHost : String;     //SocketServer Host
    fPort : Integer;
    fTimer : TTimer;
    function GetRemoteServer: TCustomRemoteServer;
    procedure SendData(const Data: IDataBlock);
    procedure ReceiveData(const Data: IDataBlock);
    procedure WriteLog(AStr:String);
    procedure OnTimer(Sender: TObject);
    procedure ReSetTimer(ATime:Integer=gcTimeOut); //���¿�ʼ��ʱ;
    function ConnectBySocket():Boolean;

  private
    fSocketServer : TBffsSocketConnection;
    fcdsQuery     : TClientDataSet;
    fConnectStype : TConnectStype;

    property RemoteServer : TCustomRemoteServer read GetRemoteServer;


  public
    constructor Create();
    destructor Destroy; override;

    //1.�������ݿ�
    function Connect(AConnStype:word;const AHost: PChar;const APort: Word = 0): Boolean; stdcall;
    function DisConnect(): Boolean; stdcall;
    function ReConnect(): Boolean; stdcall;
    //2.���׿���
    procedure BeginTrans; stdcall;
    procedure CommitTrans; stdcall;
    procedure RollbackTrans; stdcall;

    //3.ִ��SQL ���
    function ExeSQL(const SqlStr: PChar): Boolean; stdcall;
    function ReadInt(const SqlStr: PChar): Integer; stdcall;
    function ReadRecord(const SqlStr: PChar): OleVariant; stdcall;
    function ReadDataSet(const SqlStr: PChar): OleVariant; stdcall;
    function ReadVariant(const SqlStr: PChar): OleVariant; stdcall;
    function ReadRecordCount(const SqlStr: PChar): Integer; stdcall;
    function ReadBlob(const SqlStr: PChar; var Buf; Len: Integer): Integer; stdcall;
    function RefreshData(const AData: TClientDataSet; const SqlStr: PChar): Boolean; stdcall;
    procedure DoExecute(ASqlStr:WideString;AParams: OleVariant); stdcall;

    //4.AppServer �ӿ�
    function Login(const AName: WideString; const APass: WideString):integer;stdcall;
    function CopyFile(AFile_ID: Integer; AVer: Integer; ATree_ID: Integer): Integer; safecall;
    function DeleteFile(AFile_ID: Integer): Integer; safecall;
    function UpFileChunk(AFile_ID: Integer; AVer: Integer; AGroupID: Integer; AStream: OleVariant): Integer; safecall;
    procedure MailTo(AStyle: Integer; const AMails: WideString; AContextID: Integer); safecall;
    procedure MailToEx(const AMails: WideString; ATitle : WideString; AContent: WideString); safecall;
    function GetSysDateTime: OleVariant; stdcall;

    //5.����
    function Connected(): Boolean; stdcall;
    function Version : integer;stdcall;
    function AppServer : Variant; stdcall;

    //6

  end;

var
  CurrentDBOpr : TBfssDBOpr;

  function CreateBfssDBOpr(): IDbOperator; stdcall;


implementation
uses
  Variants;

  function CreateBfssDBOpr(): IDbOperator;
  begin
    if not Assigned(CurrentDBOpr) then
      CurrentDBOpr := TBfssDBOpr.Create;
    Result := CurrentDBOpr;
  end;

//д��־

{ TBfssDBOpr }

function TBfssDBOpr.AppServer: Variant;
begin
  if not RemoteServer.Connected then ReConnect;
  if RemoteServer.Connected then
    Result := RemoteServer.AppServer;
end;

procedure TBfssDBOpr.BeginTrans;
begin
  //Ϊ���������жϻ��������,���ԷŴ�
  ReSetTimer;
  if RemoteServer.Connected then
    RemoteServer.AppServer.BeginTrans;
end;

procedure TBfssDBOpr.CommitTrans;
begin
  ReSetTimer;
  if RemoteServer.Connected then
    RemoteServer.AppServer.CommitTrans;
end;

function TBfssDBOpr.Connect(AConnStype:word;const AHost: PChar; const APort: Word): Boolean;
begin
  Result := False;
  fConnectStype := TConnectStype(AConnStype);
  if RemoteServer.Connected then
    RemoteServer.Connected := False;

  fHost := AHost;
  fPort := APort;
  if Self.fConnectStype = csSocket then
  begin
    with RemoteServer as TBffsSocketConnection do
    begin
      Host  := AHost;
      Port  := APort;
      Result := ConnectBySocket();
      if Result then
        WriteLog('Sokcet ���ӳɹ���')
      else
        WriteLog('Sokcet ����ʧ�ܡ�');
    end;
  end;

  fcdsQuery.RemoteServer := RemoteServer;
  if Result then
    fTimer.Enabled := True;
end;

function TBfssDBOpr.ConnectBySocket: Boolean;
var
  mysl : TStringList;
  mystr : string;
  i : Integer;
begin
  mysl  := TStringList.Create;
  try
    mystr := gc_Class_GUID[Random(5)];
    try
      fSocketServer.ServerGUID  := mystr;
      fSocketServer.Connected  := True;
    except
      WriteLog('Sokcet -first ����ʧ�ܡ�');
    end;
    mysl.Add(mystr);

    for i:=0 to 4 do
    begin
      mystr := gc_Class_GUID[i];
      if mysl.IndexOf(mystr) >=0 then Continue;
      try
        fSocketServer.ServerGUID  := mystr;
        fSocketServer.Connected   := True;
        if fSocketServer.Connected then Break;
      except
        mysl.Add(mystr);
        WriteLog(Format('Sokcet -%d -%s ����ʧ�ܡ�',[i,mystr]));
      end;
    end;

    Result := fSocketServer.Connected;

  finally
    mysl.free;
  end;
end;

function TBfssDBOpr.Connected: Boolean;
begin
  Result := RemoteServer.Connected;
end;

function TBfssDBOpr.CopyFile(AFile_ID, AVer, ATree_ID: Integer): Integer;
begin
  Result := -1;
  if not RemoteServer.Connected then ReConnect;
  if RemoteServer.Connected then
    Result := RemoteServer.AppServer.CopyFile(AFile_ID,AVer,ATree_ID);
end;

constructor TBfssDBOpr.Create();
var
  mylogfile : string;
begin
  fTimer := TTimer.Create(nil);
  fTimer.Interval := gcTimeOut;
  fTimer.Enabled  := False;
  fTimer.OnTimer  := OnTimer;

  fSocketServer := TBffsSocketConnection.Create(nil);
  fSocketServer.SupportCallbacks := False; //��֧�ֻص� by mrlong 2008-5-31
  fSocketServer.SendDataEvent := SendData;
  fSocketServer.ReceiveDataEvent := ReceiveData;

  fcdsQuery := TClientDataSet.Create(nil);
  fConnectStype := csSocket;

  //��־
  mylogfile := ExtractFileDir(System.ParamStr(0)) +
    format('\Log\DBApi_%s.log',[formatdatetime('yyyy-mm-dd',now())]);
  if not DirectoryExists(ExtractFileDir(mylogfile)) then
    CreateDir(ExtractFileDir(mylogfile));
  AssignFile(fLogFile,mylogfile);
  if not FileExists(mylogfile) then
    Rewrite(fLogfile)
  else
    Reset(flogfile);
end;

function TBfssDBOpr.DeleteFile(AFile_ID: Integer): Integer;
begin
  Result := -1;
  if not RemoteServer.Connected then ReConnect;
  if RemoteServer.Connected then
    Result := RemoteServer.AppServer.DeleteFile(AFile_ID);
end;

destructor TBfssDBOpr.Destroy;
begin
  if fcdsQuery.Active then
    fcdsQuery.Close;
  fcdsQuery.Free;
  if RemoteServer.Connected then
    RemoteServer.Connected := False;

  fSocketServer.Free;
  Closefile(fLogFile);  //�ر���־
  fTimer.Free;
  inherited;
end;

function TBfssDBOpr.DisConnect: Boolean;
begin
  RemoteServer.Connected := False;
  Result := not RemoteServer.Connected;
  fTimer.Enabled := False;
end;

procedure TBfssDBOpr.DoExecute(ASqlStr:WideString;AParams: OleVariant);
var
  OwnerData: OleVariant;
begin
  if not RemoteServer.Connected then ReConnect;
  if not RemoteServer.Connected then Exit;
  with  RemoteServer do
  begin
    //ReSetTimer;
    AppServer.AS_Execute(AppServer.GetDSPName,
      ASqlStr,AParams, OwnerData);
  end;
end;

function TBfssDBOpr.ExeSQL(const SqlStr: PChar): Boolean;
begin
  Result := False;
  if not RemoteServer.Connected then ReConnect;
  if not RemoteServer.Connected then  Exit;
  //ReSetTimer;
  try
    fcdsQuery.Close;
    fcdsQuery.ProviderName := RemoteServer.AppServer.GetDSPName;
    fcdsQuery.CommandText := SqlStr;
    fcdsQuery.Execute;
    fcdsQuery.Close;
  except
    Exit;
  end;
  Result := True;
end;


function TBfssDBOpr.GetRemoteServer: TCustomRemoteServer;
begin
  Result := nil;
  if fConnectStype = csSocket then
    Result := fSocketServer;
end;

function TBfssDBOpr.GetSysDateTime: OleVariant;
begin
  if not RemoteServer.Connected then ReConnect;
  if RemoteServer.Connected then
    Result := RemoteServer.AppServer.GetSysDateTime;
end;

function TBfssDBOpr.Login(const AName, APass: WideString):integer;
begin
  Result := -1;
  if not RemoteServer.Connected then ReConnect;
  if not RemoteServer.Connected then Exit;
  Result := RemoteServer.AppServer.Login(AName,APass);
end;

procedure TBfssDBOpr.MailTo(AStyle: Integer; const AMails: WideString;
  AContextID: Integer);
begin
  if not RemoteServer.Connected then ReConnect;
  if not RemoteServer.Connected then Exit;
  RemoteServer.AppServer.MailTo(AStyle,AMails,AContextID);
end;

procedure TBfssDBOpr.MailToEx(const AMails: WideString; ATitle,
  AContent: WideString);
begin
  if not RemoteServer.Connected then ReConnect;
  if not RemoteServer.Connected then Exit;
  RemoteServer.AppServer.MailToEx(AMails,ATitle,AContent);
end;

procedure TBfssDBOpr.OnTimer(Sender: TObject);
begin
  //
  if Self.fConnectStype = csSocket then
  begin
    if fSocketServer.Connected then
      fSocketServer.Connected := False;
  end;
  fTimer.Enabled := False;
  WriteLog('û��ʹ�ó����涨��ʱ�䣬�Ͽ�����'+DateTimeToStr(Now));
end;

function TBfssDBOpr.ReadBlob(const SqlStr: PChar; var Buf;
  Len: Integer): Integer;
begin
  Result := -1;
end;

function TBfssDBOpr.ReadDataSet(const SqlStr: PChar): OleVariant;
begin
  if not RemoteServer.Connected then ReConnect;
  if not RemoteServer.Connected then Exit;
  ReSetTimer;
  fcdsQuery.Close;
  fcdsQuery.ProviderName := RemoteServer.AppServer.GetDSPName;
  WriteLog(fcdsQuery.ProviderName);
  fcdsQuery.CommandText := SqlStr;
  fcdsQuery.Open;
  Result := fcdsQuery.Data;
  fcdsQuery.Close;
end;




function TBfssDBOpr.ReadInt(const SqlStr: PChar): Integer;
begin
  Result := -1;
  if not RemoteServer.Connected then ReConnect;
  if not RemoteServer.Connected then Exit;
  //ReSetTimer;
  fcdsQuery.Close;
  fcdsQuery.ProviderName := RemoteServer.AppServer.GetDSPName;
  fcdsQuery.CommandText := SqlStr;
  fcdsQuery.Open;
  if fcdsQuery.Fields.Count > 0 then
    Result := fcdsQuery.Fields[0].Value;
  fcdsQuery.Close;
end;

function TBfssDBOpr.ReadRecord(const SqlStr: PChar): OleVariant;
begin

end;

function TBfssDBOpr.ReadRecordCount(const SqlStr: PChar): Integer;
begin
  Result := 0;
  if not RemoteServer.Connected then ReConnect;
  if not RemoteServer.Connected then Exit;
  //ReSetTimer;
  fcdsQuery.Close;
  fcdsQuery.ProviderName := RemoteServer.AppServer.GetDSPName;
  fcdsQuery.CommandText := SqlStr;
  fcdsQuery.Open;
  Result := fcdsQuery.RecordCount;
  fcdsQuery.Close;
end;

function TBfssDBOpr.ReadVariant(const SqlStr: PChar): OleVariant;
begin
  if not RemoteServer.Connected then ReConnect;
  if not RemoteServer.Connected then Exit;
  //ReSetTimer;
  fcdsQuery.Close;
  fcdsQuery.ProviderName := RemoteServer.AppServer.GetDSPName;
  fcdsQuery.CommandText := SqlStr;
  fcdsQuery.Open;
  if fcdsQuery.Fields.Count > 0 then
    Result := fcdsQuery.Fields[0].Value;
  fcdsQuery.Close;
end;

procedure TBfssDBOpr.ReceiveData(const Data: IDataBlock);
begin
  WriteLog('����='+inttostr(Data.Size));
end;

function TBfssDBOpr.ReConnect: Boolean;
begin
  RemoteServer.Connected := False;
  if (fConnectStype = csSocket) and
     (RemoteServer is TBffsSocketConnection) then
  begin
    (RemoteServer as TBffsSocketConnection).Host := fHost;
    (RemoteServer as TBffsSocketConnection).Port := fPort;
  end;

  if RemoteServer is TDCOMConnection then
  begin
    try
      RemoteServer.Connected := True;
      Result := RemoteServer.Connected;
    except
      Result := False;
      WriteLog('Sokcet -1 ����ʧ�ܡ�');
      Exit;
    end;
  end
  else
    Result := ConnectBySocket;

  if Result then
  begin
    fTimer.Enabled := True;
    WriteLog('û��ʹ�ó����涨��ʱ�������������'+DateTimeToStr(Now));
  end;
end;

function TBfssDBOpr.RefreshData(const AData: TClientDataSet;
  const SqlStr: PChar): Boolean;
begin
   Result := False;
end;

procedure TBfssDBOpr.ReSetTimer(ATime:Integer);
begin
  if not fTimer.Enabled then Exit;
  fTimer.Enabled  := False;
  fTimer.Interval := ATime;
  fTimer.Enabled  := True;
end;

procedure TBfssDBOpr.RollbackTrans;
begin
  ReSetTimer();
  if RemoteServer.Connected then
    RemoteServer.AppServer.RollbackTrans;
end;

procedure TBfssDBOpr.SendData(const Data: IDataBlock);
begin
  WriteLog('����='+inttostr(Data.Size));
end;

function TBfssDBOpr.UpFileChunk(AFile_ID, AVer, AGroupID: Integer;
  AStream: OleVariant): Integer;
begin
  Result := -1;
  if not RemoteServer.Connected then ReConnect;
  if RemoteServer.Connected then
    Result := RemoteServer.AppServer.UpFileChunk(AFile_ID,AVer,AGroupID,AStream);
end;

function TBfssDBOpr.Version: integer;
begin
  Result := cnCurDbOprVersion;
end;

procedure TBfssDBOpr.WriteLog(AStr: String);
var
  mystr : string;
begin
  mystr := format('%s %s',[
    formatdatetime('yyyy-dd-mm hh:mm:ss',now()),AStr]);
  Append(fLogFile);
  writeln(fLogFile,mystr);
  Flush(fLogFile);
end;

initialization
  CurrentDBOpr := nil;
finalization

end.
