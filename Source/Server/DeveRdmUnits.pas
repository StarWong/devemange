///////////////////////////////////////////////////////////////////////////////
//
// Զ������ģ��
//
// ����ʱ��:2007-10-28 ����:������
//
// ����һ�������ṩ�صġ�
//
// �޸�����:
//     1) ������Copyfile() ����ʱ���Զ����ƵĴ��� ver=1.0.1 2007-11-8
//     2) ������TB_FILE_ITEM ����ZSTYPE Field ver=1.0.2 2007-12-3
//
//
///////////////////////////////////////////////////////////////////////////////
unit DeveRdmUnits;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  Windows, Messages, SysUtils, Classes, ComServ, ComObj, VCLCom, DataBkr,
  DBClient, BFSS_TLB, StdVcl, DB, ADODB,

  BFSSClassUnits, Provider, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdMessageClient, IdSMTP, IdMessage;

type

  //�����ṩ�ض���
  TDspPoolRec = Record
    fDsp   : TDataSetProvider;
    fDspName : String;
    fCount : Longint; //Ŀǰ������
  end;

  TBFSSRDM = class(TRemoteDataModule, IBFSSRDM)
    adsSQL: TADODataSet;
    adsQuery: TADODataSet;
    dspQuery: TDataSetProvider;
    dspQueryEx: TDataSetProvider;
    adsQueryEx: TADODataSet;
    dspQueryEx2: TDataSetProvider;
    adsQueryEx2: TADODataSet;
    adsQueryEx3: TADODataSet;
    dspQueryEx3: TDataSetProvider;
    adsQueryEx4: TADODataSet;
    dspQueryEx4: TDataSetProvider;
    RdmADOConn: TADOConnection;
    dspCommand: TDataSetProvider;
    ADOQuery: TADOQuery;
    SMTP: TIdSMTP;
    IdMessage1: TIdMessage;
    procedure RemoteDataModuleCreate(Sender: TObject);
    procedure RemoteDataModuleDestroy(Sender: TObject);
    function dspCommandDataRequest(Sender: TObject;
      Input: OleVariant): OleVariant;
  private
    { Private declarations }
    fLoggedIn : Boolean;
    fUserID   : Integer; //�û�ID��
    fDspPools : Array[0..4] of TDspPoolRec;
  protected
    class procedure UpdateRegistry(Register: Boolean; const ClassID, ProgID: string); override;
    function Login(const AName: WideString; const APass: WideString): Integer; safecall;
    function GetDspName: WideString; safecall;  //ȡ�����ݵ��ṩ����
    procedure BeginTrans; safecall;
    procedure CommitTrans; safecall;
    procedure RollbackTrans; safecall;
    function CopyFile(AFile_ID: Integer; AVer: Integer; ATree_ID: Integer): Integer; safecall;
    function DeleteFile(AFile_ID: Integer): Integer; safecall;
    function UpFileChunk(AFile_ID: Integer; AVer: Integer; AGroupID: Integer; AStream: OleVariant): Integer; safecall;
    procedure MailTo(AStyle: Integer; const AMails: WideString; AContextID: Integer); safecall;
  public
    { Public declarations }
  end;

implementation

uses
  inifiles,
  Variants;

type
   TByteArray = array of byte;

  procedure OleVariantToStream(var Input: OleVariant; Stream: TStream);
  var
    pBuf: Pointer;
  begin
     pBuf := VarArrayLock(Input);
     Stream.Write(TByteArray(pBuf^), Length(TByteArray(Input)));
    VarArrayUnlock(Input);
  end;

  function StreamToOleVariant(Stream: TStream; Count: Integer): OleVariant;
  var
    pBuf: Pointer;
  begin
    Result := VarArrayCreate([0, Count-1], varByte);
    pBuf := VarArrayLock(Result);
    Stream.Read(TByteArray(pBuf^), Length(TByteArray(Result)));
    VarArrayUnlock(Result);
  end;

{$R *.DFM}

class procedure TBFSSRDM.UpdateRegistry(Register: Boolean; const ClassID, ProgID: string);
begin
  if Register then
  begin
    inherited UpdateRegistry(Register, ClassID, ProgID);
    EnableSocketTransport(ClassID);
    //EnableWebTransport(ClassID);
  end else
  begin
    DisableSocketTransport(ClassID);
    //DisableWebTransport(ClassID);
    inherited UpdateRegistry(Register, ClassID, ProgID);
  end;
end;

procedure TBFSSRDM.RemoteDataModuleCreate(Sender: TObject);
var
  myDataBase : String;
const
  glconnstr = 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=%s;'
   +'Persist Security Info=False';

  glconnstrmssql2000 = 'Provider=SQLOLEDB.1;Persist Security Info=False;'+
   'User ID=sa;Password=%s;Initial Catalog=%s;Data Source=%s';
                                   //����         //������
begin
  fLoggedIn := False;
  fUserID   := 0;

  fDspPools[0].fCount := 0;
  fDspPools[0].fDsp := dspQuery;
  fDspPools[0].fDspName := 'dspQuery';

  fDspPools[1].fCount := 0;
  fDspPools[1].fDsp := dspQueryEx;
  fDspPools[1].fDspName := 'dspQueryEx';

  fDspPools[2].fCount := 0;
  fDspPools[2].fDsp := dspQueryEx2;
  fDspPools[2].fDspName := 'dspQueryEx2';

  fDspPools[3].fCount := 0;
  fDspPools[3].fDsp := dspQueryEx3;
  fDspPools[3].fDspName := 'dspQueryEx3';

  fDspPools[4].fCount := 0;
  fDspPools[4].fDsp := dspQueryEx4;
  fDspPools[4].fDspName := 'dspQueryEx4';

  // �������ݿ�
  //
  //Aeecss
  //
  if CurrBFSSSystem.fDataBase.fType = dbt_Access then
  begin
    myDataBase := Format('%s\%s',[CurrBFSSSystem.fAppDir,
             CurrBFSSSystem.fDataBase.fDBName]);
    if not FileExists(myDataBase) then Exit;
    if  RdmADOConn.Connected then
      RdmADOConn.Connected := False;
    RdmADOConn.ConnectionString := format(glconnstr,[myDataBase]);

  end
  // MSSQL2000
  else begin
    if RdmADOConn.Connected then
      RdmADOConn.Connected := False;
    RdmADOConn.ConnectionString := format(glconnstrmssql2000,[
      CurrBFSSSystem.fDataBase.fasPass,
      CurrBFSSSystem.fDataBase.fDBName,
      CurrBFSSSystem.fDataBase.fDBServer]);
    RdmADOConn.Open;
  end;

end;

procedure TBFSSRDM.RemoteDataModuleDestroy(Sender: TObject);
begin
  if fLoggedIn then
  begin
    CurrBFSSSystem.fUsers.Delete(fUserID);
  end;
  if SMTP.Connected then SMTP.Disconnect;
end;

function TBFSSRDM.Login(const AName, APass: WideString):Integer;
var
  myItem : PUserRec;
const
  glSQL  = 'select * from TB_USER_ITEM where ZNAME=''%s'' and ZPASS=''%s''';
  glSQL2 = 'select * from TB_USER_PRIVILEGE where ZUSER_ID=%d';
begin
  Result := -1;
  if adsSQL.Active then adsSQL.Close;

  adsSQL.CommandText := format(glSQL,[AName,APass]);
  adsSQL.Open;
  if adsSQL.RecordCount > 0 then
  begin
    if adsSQL.FieldByName('ZSTOP').AsBoolean then
    begin
      Result := -2; //�˺Ž���
      Exit;
    end;

    fLoggedIn := True;
    fUserID := adsSQL.FieldByName('ZID').AsInteger;
    new(myItem);
    myItem^.fID := fUserID;
    myItem^.fName := AName;
    myItem^.fLoginDateTime := Now();
    myItem^.fPrivi := THashedStringList.Create;
    CurrBFSSSystem.fUsers.Add(myItem);

    //����Ȩ��
    {
    adsSQL.Close;
    adsSQL.CommandText := format(glSQL2,[fUserID]);
    adsSQL.Open;
    adsSQL.First;
    while not adsSQL.Eof do
    begin
      myItem^.fPrivi.Add(format('%d=%d',[
        adsSQL.FieldByName('ZFILE_ID').AsInteger,
        adsSQL.FieldByName('ZRIGHTMASK').AsInteger]));
      adsSQL.Next;
    end;
    }
    Result := fUserID;
  end;
end;

function TBFSSRDM.GetDspName: WideString;
var
  i,c : integer;
  myStr : String;
begin
  myStr := fDspPools[0].fDspName;
  c := 0;
  for i:=0 to 3 do
  begin
    if fDspPools[i].fCount > fDspPools[i+1].fCount then
    begin
      myStr := fDspPools[i+1].fDspName;
      c := i+1;
    end;
  end;
  Result := myStr;
  inc(fDspPools[c].fCount);
end;

procedure TBFSSRDM.BeginTrans;
begin
  RdmADOConn.BeginTrans;
end;

procedure TBFSSRDM.CommitTrans;
begin
  RdmADOConn.CommitTrans;
end;

procedure TBFSSRDM.RollbackTrans;
begin
  RdmADOConn.RollbackTrans;
end;

function TBFSSRDM.dspCommandDataRequest(Sender: TObject;
  Input: OleVariant): OleVariant;
var
  myVarType: TVarType;
  S : String;
begin
  //
  // ���յ��û�����Ӧ
  //
  Result := NULL;
  myVarType := VarType(Input);
  case myVarType of
    varString,varOleStr:
      begin
        S := Input;
        if CompareText(S,'version') =0 then
          Result := format('%d.%d',[BFSSMajorVersion,
            BFSSMinorVersion]);
      end;
    else begin

    end;
  end;
end;

function TBFSSRDM.CopyFile(AFile_ID, AVer, ATree_ID: Integer): Integer;
var
  myNewQuery : TADOQuery;
  myADOQuery : TADOQuery;
  myFileID : integer;
  myms : TMemoryStream;
const
  glSQL   = 'select * from  TB_FILE_ITEM where ZID=%d and ZVER=%d';
  glSQL1  = 'select isnull(Max(ZID),0)+1 as mymax from TB_FILE_ITEM';
  glSQL2  = 'insert into TB_FILE_ITEM (ZTREE_ID,ZSTYPE,ZID,ZVER,ZNAME,ZEDITER_ID, ' +
            'ZEDITDATETIME,ZSTATUS,ZEXT,ZSTRUCTVER,ZTYPE,ZNEWVER,ZSIZE) '+
            ' values(%d,%d,%d,%d,''%s'',%d,''%s'',%d,''%s'',%d,%d,1,%d) ';
  glSQL3  = 'select * from TB_FILE_CONTEXT where ZFILE_ID=%d and ZVER=%d';
  glSQL4  = 'insert into TB_FILE_CONTEXT (ZFILE_ID,ZGROUPID,ZVER,ZSTREAM) ' +
            ' values(%d,%d,%d,:mystream)';
begin
  //
  // �ļ��Ŀ���
  //
  Result := -1;
  RdmADOConn.BeginTrans;
  try
    myADOQuery := TADOQuery.Create(nil);
    myNewQuery := TADOQuery.Create(nil);
    try
      myADOQuery.Connection := RdmADOConn;
      myNewQuery.Connection := RdmADOConn;

      myADOQuery.SQL.Text := format(glSQL,[AFile_ID,AVer]);
      myADOQuery.Open;

      myNewQuery.Close;
      myNewQuery.SQL.Text := glSQL1;
      myNewQuery.Open;
      myFileID := myNewQuery.FieldByName('mymax').AsInteger;

      myNewQuery.Close;
      myNewQuery.SQL.Text := format(glSQL2,[
        ATree_ID,
        0,  //0��ʾ���ļ�����ģ���ڵ��ĵ�
        myFileID,
        1,
        '����' + myADOQuery.FieldByName('ZNAME').AsString,
        fUserID,
        datetimetostr(now()),
        0,
        myADOQuery.FieldByName('ZEXT').AsString,
        myADOQuery.FieldByName('ZSTRUCTVER').AsInteger,
        myADOQuery.FieldByName('ZTYPE').AsInteger,
        myADOQuery.FieldByName('ZSIZE').AsInteger]);
      myNewQuery.ExecSQL;

      //�����ļ�������
      myADOQuery.Close;
      myADOQuery.SQL.Text := format(glSQL3,[AFile_ID,AVer]);
      myADOQuery.Open;
      myADOQuery.First;
      while not myADOQuery.Eof do
      begin
        myNewQuery.Close;
        myNewQuery.Parameters.Clear;
        myNewQuery.SQL.Text := format(glSQL4,[myFileID,
          myADOQuery.FieldByName('ZGROUPID').AsInteger,
          1]);
        myms := TMemoryStream.Create;
        TBlobField(myADOQuery.FieldByName('ZSTREAM')).SaveToStream(myms);
        myms.Position := 0;
        mynewQuery.Parameters.ParamByName('mystream').LoadFromStream(myms,ftBlob);
        myNewQuery.ExecSQL;
        myADOQuery.Next;
        freeandnil(myms);
      end;

    finally
      myADOQuery.Free;
      myNewQuery.Free;
    end;
    Result := myFileID;
    RdmADoConn.CommitTrans;
  except
    on E: Exception do
    begin
      CurrBFSSSystem.WriteLog('�ļ���������'+ E.Message);
      RdmADOConn.RollbackTrans;
    end;
  end;
end;


function TBFSSRDM.DeleteFile(AFile_ID: Integer): Integer;
const
  glSQL  = 'delete TB_FILE_CONTEXT where ZFILE_ID=%d';
  glSQL2 = 'delete TB_FILE_ITEM where ZID=%d';
begin
  //ɾ���ļ�
  RdmADOConn.BeginTrans;
  try
    ADOQuery.Close;
    ADOQuery.SQL.Text := format(glSQL,[AFile_ID]);
    ADOQuery.ExecSQL;

    ADOQuery.Close;
    ADOQuery.SQL.Text := format(glSQL2,[AFile_ID]);
    ADOQuery.ExecSQL;

    RdmADOConn.CommitTrans;
    Result := AFile_ID;
  except
    on E: Exception do
    begin
      CurrBFSSSystem.WriteLog('ɾ���ļ�����'+ E.Message);
      RdmADOConn.RollbackTrans;
      Result := -1;
    end;
  end;
end;

function TBFSSRDM.UpFileChunk(AFile_ID, AVer, AGroupID: Integer;
  AStream: OleVariant): Integer;
var
  myms : TMemoryStream;
const
  glSQL  = 'insert into TB_FILE_CONTEXT (ZFILE_ID,ZGROUPID,ZVER,ZSTREAM) ' +
          'values(%d,%d,%d,:myStream)';
begin
  Result := -1;
  //�ϴ����ݿ�
  myms := TMemoryStream.Create;

  try
    //RdmADOConn.BeginTrans;
    try
      OleVariantToStream(AStream,myms);
      myms.Position :=0;
      //д���
      ADOQuery.Close;
      ADOQuery.Parameters.Clear;
      ADOQuery.SQL.Text := format(glSQL,[AFile_ID,AGroupID,AVer]);
      ADOQuery.Parameters.ParamByName('myStream').LoadFromStream(myms,ftBlob);
      ADOQuery.ExecSQL;
      ADOQuery.Close;
      Result := AFile_ID;

      //RdmADOConn.CommitTrans;
    except
      on E: Exception do
        CurrBFSSSystem.WriteLog('�ϴ��ļ������'+ E.Message);
      //RdmADOConn.RollbackTrans;
    end;
  finally
    myms.Free;
  end;
end;

//
// AStyle : ���� Ŀǰֻ��bug=0
// AMails : ���䣬����� ; �ŷֿ�
// AContextID : Ϊ���ݵ�ID,����Style������,����bug����Bug_IDֵ
//
procedure TBFSSRDM.MailTo(AStyle: Integer; const AMails: WideString;
  AContextID: Integer);
var
  myTitle : String;
  myContext : String;  //����
  myID : integer;
  myIdMsg: TIdMessage;
const
  glSQL  = 'select ZTITLE from TB_BUG_ITEM where ZID=%d ';
  glSQL2 = 'select isnull(max(ZID),0) as v from TB_BUG_HISTORY where ZBUG_ID=%d';
  glSQL3 = 'select ZCONTEXT from TB_BUG_HISTORY where ZID=%d';
begin
  if not CurrBFSSSystem.fSMTPParams.fAction then Exit;
  if not SMTP.Connected then
  begin
    SMTP.AuthenticationType := atLogin;
    SMTP.Host     := CurrBFSSSystem.fSMTPParams.fHost;
    SMTP.Port     := CurrBFSSSystem.fSMTPParams.fPort;
    SMTP.Username := CurrBFSSSystem.fSMTPParams.fUserName;
    SMTP.Password := CurrBFSSSystem.fSMTPParams.fPassword;
    try
      SMTP.Connect;
      if not SMTP.Connected then
      begin
        CurrBFSSSystem.WriteLog('�����ʼ�����������');
        Exit;
      end;
    except
      on E: Exception do
      begin
        CurrBFSSSystem.WriteLog('�����ʼ�����������'+ E.Message);
        Exit;
      end;
    end;
  end;

  if SMTP.Connected then
  begin
    //�����ʼ�
    case AStyle of
      0: {bug}
        begin
          if adsSQL.Active then
            adsSQL.Close;
          adsSQL.CommandText := format(glSQL,[AContextID]);
          adsSQL.Open;
          if adsSQL.RecordCount = 0 then Exit;

          myTitle := adsSQL.FieldByName('ZTITLE').AsString;
          adsSQL.Close;
          adsSQL.CommandText :=  format(glSQL2,[AContextID]);
          adsSQL.Open;
          if adsSQL.RecordCount > 0 then
          begin
            myID := adsSQL.FieldByName('v').AsInteger;
            adsSQL.Close;
            adsSQL.CommandText := format(glSQL3,[myID]);
            adsSQl.Open;
            if adsSQL.RecordCount > 0 then
              myContext := adsSQL.FieldByName('ZCONTEXT').AsString;
          end;

        end;
    end;

    //��������:
    try
      IdMessage1.Clear;
      IdMessage1.CharSet := 'gb2312';
      IdMessage1.ClearBody;
      IdMessage1.Body.Add(myContext);
      IdMessage1.From.address := CurrBFSSSystem.fSMTPParams.fUserName;
      IdMessage1.Subject := myTitle;
      IdMessage1.Recipients.EMailAddresses := AMails;
      IdMessage1.MessageParts.Clear;
      SMTP.Send(IdMessage1);
    finally

    end;
  end;

end;

initialization
  TComponentFactory.Create(ComServer, TBFSSRDM,
    Class_BFSSRDM, ciMultiInstance, tmApartment);


end.
