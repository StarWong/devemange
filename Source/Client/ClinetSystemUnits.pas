///////////////////////////////////////////////////////////////////////////////
//
// author: mrlong date:2007-12-12
//
//  �޸�����:
//     1)����Ȩ��Ϊ����Ȩ��. �û�����Ϊ����Ա����ȫ��Ȩ������.
//
//
//
////////////////////////////////////////////////////////////////////////////////
unit ClinetSystemUnits;

interface
uses
  Classes,SysUtils,Windows,
  ClientTypeUnits,Gauges,
  DBApiIntf,DBClient;

type

  TEditerType = (etAdmin,etUser);  //�û�����

  TClinetSystem = Class(TObject)
  private
    fTickCount : word;
  public
    fAppDir : String;
    fTempDir : String;            //��ʱĿ¼
    fDbOpr  : IDbOperator;        //���ݽӿڴ���
    fEditer_id : integer;         //�û���id��
    fEditer : String;             //�û���
    fEditerType : TEditerType;    //�û�����
    fHost   : String;             //��������
    fcdsUsePriv : TClientDataSet; //�û�Ȩ�ޱ�
    fGauge  : TGauge;
    fDeleteFiles : TStringList;   //����ļ�ʱҪɾ��������
    fCancelUpFile : Boolean;      //��ֹ�ϴ��������ļ�

    constructor Create;
    destructor Destroy; override;

    procedure BeginTickCount;  //��ʼ��ʱ
    procedure EndTickCount;    //������ʱ

    procedure GetUserPriv(); //ȡ���û���Ȩ��
    //����Ȩ��
    function HasModuleAction(AStype:integer;ASubStype:integer;
      AID:integer;AAction:TActionType):Boolean;

    //�ļ����ϴ�������
    function UpFile(AFile_ID,AVer:integer;AfileName:String):Boolean;overload; //�ϴ��ļ�
    function UpFile(ATreeStyle:TFileStype;ATree_ID:integer;AFileName:String;var AFileID:integer;AVer:integer=1):Boolean;overload;
    function DonwFileToFileName(Afile_id,Aver:integer;AfileName:String):Boolean;overload; //���浽�ļ�
    function DonwFileToFileName(Afile_id:integer;var AfileName:String):Boolean;overload; //���浽�ļ�
    procedure OleVariantToStream(var Input: OleVariant; Stream: TStream);
    function StreamToOleVariant(Stream: TStream; Count: Integer): OleVariant;

    //����
    function GetFileSize(const FileName: String): LongInt;
    procedure SplitStr(AStr:String;ASl:TStringList;AChar:Char=';');  //�۷��ַ�
  end;

var
  ClientSystem : TClinetSystem;

implementation
uses
  DB,Forms,
  Variants,
  ZLibEx;

  function CreateBfssDBOpr():IDbOperator; stdcall;
    external 'DBApi.dll';

type
   TByteArray = array of byte;

{ TClinetSystem }

procedure TClinetSystem.BeginTickCount;
begin
  fTickCount := gettickcount;
end;

constructor TClinetSystem.Create;
  function DoGetTemp:string;
  var  
    dwsize  : dword;
    pcstr   : pchar;
  begin
    Result   :=   './';
    dwsize   :=   MAX_PATH   +   1;
    getmem(pcstr,dwsize);
    try
      if gettemppath(dwsize,pcstr)   <>   0   then
          Result   :=   strpas(pcstr);
    finally
      freemem(pcstr);
    end;
  end;

begin
  fDbOpr := CreateBfssDBOpr();
  fAppDir := ExtractFileDir(System.ParamStr(0));
  ftempdir := DoGetTemp;
  fcdsUsePriv := TClientDataSet.Create(nil);
  fEditer_id := -1;
  fGauge  := TGauge.Create(nil);
  fDeleteFiles := TStringList.Create;
  fTickCount := 0;
  fCancelUpFile := False;
  if not DirectoryExists(fAppDir + '\' + gcLogDir) then
    CreateDir(fAppDir + '\' + gcLogDir);
end;

destructor TClinetSystem.Destroy;
begin
  fDeleteFiles.Free;
  fcdsUsePriv.Free;
  fDbOpr := nil;
  fGauge.Free;
  inherited;
end;

function TClinetSystem.DonwFileToFileName(Afile_id, Aver: integer;
  AfileName: String): Boolean;
var
  myfileStream: TMemoryStream;
  myStream,OutStream : TMemoryStream;
  myfilename : String;
  ZStream : TZDecompressionStream;
  mycds : TClientDataSet;
  myb : Boolean;
const
  glSQL = 'Select ZSTREAM from TB_FILE_CONTEXT ' +
          ' where ZFILE_ID=%d and ZVer=%d Order by ZGROUPID';
begin
  Self.BeginTickCount;
  myfilename := AfileName;
  mycds := TClientDataSet.Create(nil);
  myb := fCancelUpFile;
  fCancelUpFile := False;
  try
    mycds.Data := ClientSystem.fDBOpr.ReadDataSet(pChar(format(glSQL,[Afile_id,Aver])));
    myfileStream := TMemoryStream.Create;
    OutStream    := TMemoryStream.Create;
    fGauge.Progress := 0;
    fGauge.MaxValue := mycds.RecordCount;
    try
      while not mycds.Eof do
      begin
        if fCancelUpFile then
        begin
          fGauge.Progress := 0;
          Result := False;
          Exit;
        end;
        Application.ProcessMessages;
        myStream :=  TMemoryStream.Create;
        //TBlobField(cdsQuery.FieldByName('ZSTREAM')).SaveToStream(myStream);
        //myStream := StrToStream(Base64ToStr(cdsQuery.FieldByName('ZSTREAM').AsString));
        (mycds.FieldByName('ZSTREAM') as TBlobField).SaveToStream(myStream);
        myStream.Position := 0;
        myfileStream.CopyFrom(myStream,myStream.Size);
        freeandnil(myStream);
        mycds.Next;
        fGauge.Progress := fGauge.Progress + 1;
      end;

      //��ѹ
      myfileStream.Position := 0;
      ZStream := TZDecompressionStream.Create(myfileStream);
      try
        OutStream.CopyFrom(ZStream, ZStream.Size);
      finally
        ZStream.Free;
      end;
      OutStream.Position := 0;
      OutStream.SaveToFile(myfilename);
    finally
      myfileStream.Free;
      OutStream.Free;
    end;
    Result := True;
  finally
    mycds.Free;
    Self.EndTickCount;
    fCancelUpFile := myb;
  end;
end;


function TClinetSystem.DonwFileToFileName(Afile_id: integer;
  var AfileName: String): Boolean;
var
  myfilename : String;
  myver : integer;
const
  glSQL  = 'select isnull(max(ZVER),0) from  TB_FILE_ITEM where ZID=%d';
begin
  Result := False;
  if not DirectoryExists(fAppDir + '\' +gcfiledir) then
    if not CreateDir(fAppDir + '\' +gcfiledir) then Exit;
  myfilename := format('%s\%s\%s',[fAppDir,gcfiledir,AfileName]);
  myver := self.fDbOpr.ReadInt(PChar(Format(glSQL,[AFile_id])));
  if DonwFileToFileName(Afile_id,myver,myfilename) then
  begin
    AfileName := myfilename;
    Result := True;
    fDeleteFiles.Add(AfileName); // ����ɾ������ʱ�ļ�
  end;
end;

procedure TClinetSystem.EndTickCount;
var
  myendcount : word;
begin
  //���������ô��ʾ��������,����Ϣ��?
  if Assigned(Application.MainForm) then
  begin
    myendcount := gettickcount;
    SendMessage(Application.MainForm.Handle,
      gcMSG_TickCount,(myendcount-fTickCount),0);
    fTickCount := 0;
  end;
end;

function TClinetSystem.GetFileSize(const FileName: String): LongInt;
var
  SearchRec: TSearchRec;
begin
  if FindFirst(ExpandFileName(FileName), faAnyFile, SearchRec) = 0 then
    Result := SearchRec.Size div 1024
  else
   Result := 0;
end;

procedure TClinetSystem.GetUserPriv;
const
  glSQL = 'select ZSTYLE,ZMODULEID,ZRIGHTMASK from TB_USER_PRIVILEGE ' +
          'where ZUSER_ID=%d';
begin
  if fEditer_id <0 then Exit;
  fcdsUsePriv.data := fDBOpr.ReadDataSet(PChar(format(glSQL,[fEditer_id])));
end;

function TClinetSystem.HasModuleAction(AStype: integer;ASubStype:integer; AID: integer;
  AAction: TActionType): Boolean;
var
  myc : integer;
begin
  //
  // ����Ȩ��,������Ȩ��,����˵�����ģ��
  //  �������Ҫ�����.
  //
  // Ϊ�˰�ȫ����Ϊ����ֻҪ���ڲ�˵����Ȩ��,��������Ϊo�Ĺ����û�.
  //
  //
  if ClientSystem.fEditer_id < 0 then
  begin
    Result := False;
    Exit;
  end;

  //����Ա��ȫ����Ȩ��
  if ClientSystem.fEditerType = etAdmin then
  begin
    Result := True;
    Exit;
  end;

  Result := False;
  fcdsUsePriv.First;
  myc := 0;
  while not fcdsUsePriv.Eof do
  begin
    if (fcdsUsePriv.FieldByName('ZSTYLE').AsInteger = AStype) and
       (fcdsUsePriv.FieldByName('ZSUBSTYLE').AsInteger = ASubStype) and
       (fcdsUsePriv.FieldByName('ZMODULEID').AsInteger = AID) then
    begin
      case AAction of
        atView:   myc := gcActionView;
        atUpdate: myc := gcActionUpdate;
        atInsert: myc := acActionInsert;
        atDelete: myc := acActionDelete;
      end;

      Result := fcdsUsePriv.FieldByName('ZRIGHTMASK').AsInteger and myc = myc;
      break;
    end;
    fcdsUsePriv.Next;
  end;
end;

procedure TClinetSystem.OleVariantToStream(var Input: OleVariant;
  Stream: TStream);
var
  pBuf: Pointer;
begin
  pBuf := VarArrayLock(Input);
  Stream.Write(TByteArray(pBuf^), Length(TByteArray(Input)));
  VarArrayUnlock(Input);
end;



procedure TClinetSystem.SplitStr(AStr: String; ASl: TStringList;
  AChar: Char);
var
  mystr : string;
  i,len : integer;
begin
  len := length(AStr);
  mystr := '';
  for i:=1 to len do
  begin
    if AStr[i] = AChar then
    begin
      ASl.Add(mystr);
      mystr := '';
    end
    else
      mystr := mystr + AStr[i];
  end;
  if mystr <> '' then ASl.Add(mystr);
end;

function TClinetSystem.StreamToOleVariant(Stream: TStream;
  Count: Integer): OleVariant;
var
  pBuf: Pointer;
begin
  Result := VarArrayCreate([0, Count-1], varByte);
  pBuf := VarArrayLock(Result);
  Stream.Read(TByteArray(pBuf^), Length(TByteArray(Result)));
  VarArrayUnlock(Result);
end;


function TClinetSystem.UpFile(AFile_ID, AVer: integer;
  AfileName: String): Boolean;
var
  count,c,i : integer;
  myStream,myms : TMemoryStream;
  OutStream : TMemoryStream;
  ZStream: TZCompressionStream;
  myData : OleVariant;
  myb : Boolean;
const
  glSQL = 'insert into TB_FILE_CONTEXT (ZFILE_ID,ZGROUPID,ZVER,ZSTREAM)  ' +
          'values(%d,%d,%d,:myStream)';
  glBackSize = 10240*5; //5k
begin
  myStream := TMemoryStream.Create;
  OutStream := TMemoryStream.Create;

  myb := fCancelUpFile;
  fCancelUpFile := False;
  BeginTickCount;
  try
    myStream.LoadFromFile(AfileName);
    //ѹ��
    ZStream := TZCompressionStream.Create(OutStream,zcFastest);
    try
      ZStream.CopyFrom(myStream, 0);
    finally
      ZStream.Free;
    end;

    OutStream.Position := 0;
    count := OutStream.Size div glBackSize; //һ�α���1024���ֽ�
    fGauge.Progress := 0;
    if OutStream.Size mod glBackSize > 0 then
      fGauge.MaxValue := count +1
    else
      fGauge.MaxValue := count;
    c := 0;
    for i:=0 to count -1 do
    begin
      if fCancelUpFile then
      begin
        fGauge.Progress := 0;
        Result:= False;
        Exit;
      end;
      Application.ProcessMessages;
      myms := TMemoryStream.Create;
      myms.CopyFrom(OutStream,glBackSize);
      myms.Position := 0;
      try
        {
        cdsQuery.Close;
        cdsQuery.Params.Clear;
        //cdsQuery.Params.CreateParam(ftString,'myStream',ptInput);
        //cdsQuery.Params.ParamByName('myStream').AsBlob := StrToBase64(StreamToStr(myms));  //LoadFromStream(myms,ftBlob);
        cdsQuery.Params.CreateParam(ftBlob,'myStream',ptInput);
        cdsQuery.Params.ParamByName('myStream').LoadFromStream(myms,ftBlob);  //LoadFromStream(myms,ftBlob);
        cdsQuery.CommandText := format(glSQL,[AFile_ID,c,AVer]);
        fDBOpr.DoExecute(cdsQuery.CommandText ,PackageParams(cdsQuery.Params));
        }
        myData := StreamToOleVariant(myms,myms.Size);
        if ClientSystem.fDBOpr.UpFileChunk(AFile_ID,AVer,c,myData) <0 then
        begin
          Result := False;
          Exit;
        end;

      except
        Result := False;
        Exit;
      end;

      inc(c);
      freeandnil(myms);
      fGauge.Progress := c;
    end;

    if (OutStream.Size mod glBackSize) >0 then
    begin
      if fCancelUpFile then
      begin
        fGauge.Progress := 0;
        Result:= False;
        Exit;
      end;

      myms := TMemoryStream.Create;
      myms.CopyFrom(OutStream,OutStream.Size mod glBackSize);
      myms.Position :=0;
      try
      {
        cdsQuery.Close;
        cdsQuery.Params.Clear;
        cdsQuery.Params.CreateParam(ftString,'myStream',ptInput);
        cdsQuery.params.findparam('myStream').AsString := StrToBase64(StreamToStr(myms));//oadFromStream(myms,ftblob);
        cdsQuery.CommandText := format(glSQL,[AFile_ID,c,AVer]);

        fDBOpr.DoExecute(cdsQuery.CommandText,PackageParams(cdsQuery.Params));
      }
        myData := StreamToOleVariant(myms,myms.Size);
        if ClientSystem.fDBOpr.UpFileChunk(AFile_ID,AVer,c,myData) <0 then
        begin
          Result := False;
          Exit;
        end;

        fGauge.Progress := fGauge.Progress + 1;
      except
        Result := False;
        Exit;
      end;
      freeandnil(myms);
    end;
    Result := True;

  finally
    myStream.Free;
    OutStream.Free;
    EndTickCount;
    fCancelUpFile := myb;
  end;
end;


function TClinetSystem.UpFile(ATreeStyle:TFileStype;ATree_ID:integer;AFileName: String;
  var AFileID: integer;AVer:integer): Boolean;
var
  myfilename : string;
  myfileid : integer;
const
  glSQL =  'insert into TB_FILE_ITEM (ZTREE_ID,ZSTYPE,ZID,ZVER,ZNAME,ZEDITER_ID,ZFILEPATH, '+
           'ZSTATUS,ZEXT,ZEDITDATETIME,ZSTRUCTVER,ZTYPE,ZNEWVER,ZNOTE,ZSIZE) ' +
           'values (%d,%d,%d,%d,''%s'',%d,''%s'',%d,''%s'',''%s'',%d,%d,1,''%s'',%d)';
  glSQL2 = 'select isnull(max(ZID),0)+1 as mymax from TB_FILE_ITEM ';
begin
  //
  //�����ļ�
  //
  // ��ط��������ع�����. Ŀǰ��ʱû�С�
  //
  // AFileid ��ʱ���� =1 ��ʾҪȡ�����ֵ
  //
  myfilename := AFileName;

  if AFileID < 0 then
    myfileid := fDBOpr.ReadInt(PChar(glSQL2))
  else
    myfileid := AFileid;

  AFileID  := myfileid;

  Result := False;
  Self.BeginTickCount;
  fDBOpr.BeginTrans;
  try
    fDBOpr.ExeSQL(PChar(format(glSQL,[
      ATree_ID, 
      Ord(ATreeStyle), //����
      myfileid,
      AVer,  //�ļ��汾��
      ExtractFileName(myfilename),
      fEditer_id,
      myfilename,
      0,
      ExtractFileExt(myfilename),
      datetimetostr(now()), //?��ط�mssql�ǲ���һ����
      0,
      1,
      '',
      GetFileSize(myfilename)])));

    if not UpFile(myfileid,AVer,myfilename) then
    begin
      ClientSystem.fDBOpr.RollbackTrans;
      Exit;
    end;
    ClientSystem.fDBOpr.CommitTrans;
    Result := True;
  except
    ClientSystem.fDBOpr.RollbackTrans;
    Result := False;
    Self.EndTickCount;
  end;
end;


initialization
  ClientSystem := TClinetSystem.Create;
finalization
  ClientSystem.Free;


end.
