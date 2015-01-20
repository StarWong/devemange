//////////////////////////////////////////////////////////////
//
// 产品原型，支持 axure的浏览功能
// 作者：龙仕云 2014-5-9
//
//
/////////////////////////////////////////////////////////////

unit PrototypeClinetfrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseChildfrm, ComCtrls, ExtCtrls, Grids, DBGrids, StdCtrls,
  Buttons, ActnList, OleCtrls, SHDocVw, DB, DBClient, Mask, DBCtrls, Menus,
  ImgList;

type

  TPageTypeRec = record
    fIndex : Integer;
    fIndexCount : Integer;
    fWhereStr : string; //分页的where条件
  end;

  PAttachFileRec  = ^TAttachFileRec;
  TAttachFileRec = record
    fName : string;
    ffileid : Integer;
    fFileExt : string;
  end;

  TPrototypeClientDlg = class(TBaseChildDlg)
    pgcPrty: TPageControl;
    tsList: TTabSheet;
    tsView: TTabSheet;
    pnlTools: TPanel;
    pnlonvisible: TPanel;
    actlst1: TActionList;
    btnAddPro: TBitBtn;
    dbgrdList: TDBGrid;
    act_AddPro: TAction;
    wbview: TWebBrowser;
    dsList: TDataSource;
    cdsPrtyList: TClientDataSet;
    pnlPrtyBottom: TPanel;
    lblpagecount: TLabel;
    tsEdit: TTabSheet;
    lbl1: TLabel;
    dbedtPRTY_NAME: TDBEdit;
    lbl2: TLabel;
    dbedtPRTY_NAME1: TDBEdit;
    btnSavePro: TBitBtn;
    btnClance: TBitBtn;
    act_SavePro: TAction;
    act_Clance: TAction;
    act_PrtyView: TAction;
    btnPrtyView: TBitBtn;
    act_FirstPage: TAction;
    act_NextPage: TAction;
    act_ProPage: TAction;
    act_LastPage: TAction;
    btnFirstPage: TBitBtn;
    btnProPage: TBitBtn;
    btnNextPage: TBitBtn;
    btnLastPage: TBitBtn;
    act_RefreshData: TAction;
    btnRefreshData: TBitBtn;
    lvAttach: TListView;
    spl1: TSplitter;
    pmAttach: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    actAttach_Addfile: TAction;
    actAttach_downfile: TAction;
    ilAttach: TImageList;
    dlgOpen1: TOpenDialog;
    dlgSave1: TSaveDialog;
    procedure act_AddProExecute(Sender: TObject);
    procedure dbgrdListDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure act_AddProUpdate(Sender: TObject);
    procedure cdsPrtyListNewRecord(DataSet: TDataSet);
    procedure pgcPrtyChanging(Sender: TObject; var AllowChange: Boolean);
    procedure act_SaveProUpdate(Sender: TObject);
    procedure act_SaveProExecute(Sender: TObject);
    procedure cdsPrtyListBeforePost(DataSet: TDataSet);
    procedure act_ClanceUpdate(Sender: TObject);
    procedure act_ClanceExecute(Sender: TObject);
    procedure dbgrdListDblClick(Sender: TObject);
    procedure act_PrtyViewUpdate(Sender: TObject);
    procedure act_PrtyViewExecute(Sender: TObject);
    procedure act_FirstPageExecute(Sender: TObject);
    procedure act_FirstPageUpdate(Sender: TObject);
    procedure act_ProPageExecute(Sender: TObject);
    procedure act_ProPageUpdate(Sender: TObject);
    procedure act_NextPageUpdate(Sender: TObject);
    procedure act_NextPageExecute(Sender: TObject);
    procedure act_LastPageUpdate(Sender: TObject);
    procedure act_LastPageExecute(Sender: TObject);
    procedure act_RefreshDataExecute(Sender: TObject);
    procedure cdsPrtyListAfterScroll(DataSet: TDataSet);
    procedure actAttach_AddfileExecute(Sender: TObject);
    procedure actAttach_downfileExecute(Sender: TObject);
    procedure actAttach_downfileUpdate(Sender: TObject);
    procedure lvAttachDblClick(Sender: TObject);
  private
    { Private declarations }
    fPageType : TPageTypeRec;
    fFileIconIndexList : TStringList; //附件的图示
  public
    { Public declarations }

    procedure initBase; override;
    procedure freeBase; override;
    procedure Showfrm ; override;  //显示后发生的事件
    procedure Closefrm; override;  //关闭显示发生的事件
    class function GetModuleID : integer;override;

    procedure ClearAttachFile();
        //取文件的图标
    function GetFileIconIndex(FileName:string;AImageList:TImageList):integer;
    procedure LoadAttach(ABugID:Integer);     //加载附件


    function  GetPrtyPageCount(AWhereStr:String):integer; //取出页总数
    procedure LoaPrtyList(APageIndex:integer;AWhereStr:String);

  end;

implementation
uses
  ShellAPI,
  ClinetSystemUnits,
  ClientTypeUnits, DmUints;

type
  gc_Page_Prty = (papr_list,papr_edit,papr_view);


{$R *.dfm}

procedure TPrototypeClientDlg.act_AddProExecute(Sender: TObject);
begin
  cdsPrtyList.Append;
  pgcPrty.TabIndex := ord(papr_edit);
end;

procedure TPrototypeClientDlg.Closefrm;
begin
  
end;

procedure TPrototypeClientDlg.freeBase;
begin
  inherited;
  ClearAttachFile();
  fFileIconIndexList.Free;
end;

class function TPrototypeClientDlg.GetModuleID: integer;
begin
  Result := Ord(mtAnt);
end;

procedure TPrototypeClientDlg.initBase;
var
  i : Integer;
  mycds : TClientDataSet;
  myfield : TFieldDef;
  mywhere : string;
const
  glSQL1 = 'select * from TB_PROTOTYPE where 1=0 ';
begin
  inherited;
  fLoading := False;
  fFileIconIndexList := TStringList.Create;

  mycds := TClientDataSet.Create(nil);
  try
    mycds.data := ClientSystem.fDbOpr.ReadDataSet(PChar(glSQL1));

    if cdsPrtyList.Active then
      cdsPrtyList.Close;
    cdsPrtyList.FieldDefs.Clear;
    cdsPrtyList.FieldDefs.Assign(mycds.FieldDefs);

    with cdsPrtyList.FieldDefs do
    begin
      myField := AddFieldDef;
      myField.Name := 'ZISNEW';   //是否是新增
      myField.DataType := ftBoolean;

      myField := AddFieldDef;
      myField.Name := 'ZAUTOID';   //序号
      myField.DataType := ftInteger;

      myField := AddFieldDef;
      myField.Name := 'ZID';   //对应 PRTY_ID;
      myField.DataType := ftInteger;


      for i:=0 to Count -1 do
      begin
        cdsPrtyList.FieldDefs[i].CreateField(cdsPrtyList).Alignment := taLeftJustify;
      end;

    end;

    //由谁创建
    myfield := cdsPrtyList.FieldDefs.AddFieldDef;
    myfield.Name :='ZUSERNAME';
    myfield.DataType := ftString;
    myfield.Size := 50;
    with myfield.CreateField(cdsPrtyList) do
    begin
      FieldKind := fkLookup;
      KeyFields := 'ZUSER_ID';
      LookupDataSet := DM.cdsUserAll;
      LookupKeyFields := 'ZID';
      LookupResultField := 'ZNAME';
    end;


    cdsPrtyList.CreateDataSet;

    //加载第一页内容
    fPageType.fIndex := 1;
    mywhere := '1=1';

    fPageType.fIndexCount := GetPrtyPageCount(mywhere);
    fPageType.fWhereStr := mywhere;
    LoaPrtyList(fPageType.fIndex,fPageType.fWhereStr);
    lblPageCount.Caption := format('%d/%d',[1,
      fPageType.fIndexCount]);
    

  finally
    mycds.Free;
  end;
end;


procedure TPrototypeClientDlg.Showfrm;
begin
  inherited;

end;

procedure TPrototypeClientDlg.dbgrdListDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
 if (cdsPrtyList.RecNo mod 2  = 0) and not ( gdSelected in State)  then
    dbgrdList.Canvas.Brush.Color := clSilver;

  case Column.Index of
    2 :
      if cdsPrtyList.FieldByName('ZUSER_ID').AsInteger =
         ClientSystem.fEditer_id then
      begin
        dbgrdList.Canvas.Brush.Color := clAqua;
      end;

  end;
  dbgrdList.DefaultDrawColumnCell(Rect,DataCol,Column,State);
end;
function TPrototypeClientDlg.GetPrtyPageCount(AWhereStr: String): integer;
var
  mySQL  : string;
  myRowCount : integer;
  mywhere : string;
const
  glSQL = 'exec pt_SplitPage ''TB_PROTOTYPE'',''' +
         'PRTY_DATETIME'', ''%s'',20,%d,%d,1,''%s''';
  //                                             页码,以总数=1, 条件where
begin
  mywhere := AWhereStr;

  mySQL := format(glSQL,[
    'PRTY_DATETIME',
    1,
    1, //不是取总数
    mywhere]);


  myRowCount := ClientSystem.fDbOpr.ReadInt(PChar(mySQL));
  Result := myRowCount div 20;
  if (myRowCount mod 20) > 0 then
    Result := Result + 1;

end;


procedure TPrototypeClientDlg.LoaPrtyList(APageIndex: integer;
  AWhereStr: String);
var
  i,myc : Integer;
  myb : Boolean;
  mywhere : string;
  mySql : string;
  cdstemp : TClientDataSet;
const
  //glSQL = 'select * from TB_ANT order by ZDATE desc';  //ZID desc
  glSQL = 'exec pt_SplitPage ''TB_PROTOTYPE '',' +
          '''PRTY_GUID,PRTY_NAME,ZUSER_ID,PRTY_DATETIME,PRTY_ID,' +
          'PRTY_DIRNAME'',' +
          '''%s'',20,%d,%d,1,''%s''';

begin
  //
  if fLoading then Exit;
  mywhere := AWhereStr;
  mySQL := format(glSQL,[
      'PRTY_DATETIME',
      APageIndex,
      0, //不是取总数
      mywhere]);

  myb := fLoading;
  fLoading := True;
  
  cdsPrtyList.DisableControls;
  ClientSystem.BeginTickCount;
  ShowProgress('读取数据...',0);
  cdstemp := TClientDataSet.Create(nil);

  try
    while not cdsPrtyList.Eof do
      cdsPrtyList.Delete;
      
    cdstemp.Data := ClientSystem.fDbOpr.ReadDataSet(PChar(mySQL));
    cdstemp.First;
    myc := 1;
    while not cdstemp.Eof do
    begin
      cdsPrtyList.Append;
      cdsPrtyList.FieldByName('ZISNEW').AsBoolean := False;
      cdsPrtyList.FieldByName('ZAUTOID').AsString := inttostr(myc+(APageIndex-1)*20);Inc(myc);
      cdsPrtyList.FieldByName('ZID').AsInteger := cdstemp.fieldByName('PRTY_ID').AsInteger;

      for i:=0 to cdstemp.Fields.Count -1 do
      begin
        if cdstemp.Fields[i].FieldName <>'PRTY_ID' then
         cdsPrtyList.FieldByName(cdstemp.Fields[i].FieldName).AsVariant :=
            cdstemp.FieldByName(cdstemp.Fields[i].FieldName).AsVariant;
      end;
      cdstemp.Next;
      cdsPrtyList.Post;
    end;

    cdsPrtyList.First;
  finally
    cdstemp.Free;
    cdsPrtyList.EnableControls;
    fLoading := myb;
    HideProgress;
    ClientSystem.EndTickCount;
  end;
end;


procedure TPrototypeClientDlg.act_AddProUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := cdsPrtyList.State = dsBrowse;
end;

procedure TPrototypeClientDlg.cdsPrtyListNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('ZISNEW').AsBoolean := True;
  DataSet.FieldByName('PRTY_GUID').AsString := NewGuid;
  DataSet.FieldByName('ZUSER_ID').AsInteger := ClientSystem.fEditer_id;
  DataSet.FieldByName('PRTY_DATETIME').AsDateTime := ClientSystem.fDbOpr.GetSysDateTime;
  DataSet.FieldByName('ZID').AsInteger := -1;
end;

procedure TPrototypeClientDlg.pgcPrtyChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  if pgcPrty.ActivePageIndex = Ord(papr_edit) then
  begin
    if cdsPrtyList.State in [dsInsert,dsEdit]  then
    begin
      MessageBox(Handle,'内容已修改','提示',MB_ICONERROR+MB_OK);
      AllowChange := False;
      Exit;
    end;
  end;
end;


procedure TPrototypeClientDlg.act_SaveProUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := cdsPrtyList.State in [dsInsert,dsEdit];
end;

procedure TPrototypeClientDlg.act_SaveProExecute(Sender: TObject);
begin
  //保存
  cdsPrtyList.Post;
end;

procedure TPrototypeClientDlg.cdsPrtyListBeforePost(DataSet: TDataSet);
var
  mySQL : string;
const
  gc_SQL = 'insert TB_PROTOTYPE (PRTY_GUID,PRTY_NAME,ZUSER_ID,PRTY_DATETIME,PRTY_DIRNAME) ' +
           ' values(''%s'',''%s'',%d,''%s'',''%s'')';
  gc_SQL2 = 'update TB_PROTOTYPE set PRTY_NAME=''%s'',PRTY_DIRNAME=''%s'' where PRTY_GUID=''%s'' ';
begin
  if fLoading then Exit;
  
  //新建
  if DataSet.FieldByName('ZISNEW').AsBoolean then
  begin
    mySQL := Format(gc_SQL,[
      DataSet.FieldByName('PRTY_GUID').AsString,
      DataSet.FieldByName('PRTY_NAME').AsString,
      DataSet.FieldByName('ZUSER_ID').AsInteger,
      DataSet.FieldByName('PRTY_DATETIME').AsString,
      DataSet.FieldByName('PRTY_DIRNAME').AsString
    ]);

    ClientSystem.fDbOpr.BeginTrans;
    try
      ClientSystem.fDbOpr.ExeSQL(PChar(mySQL));
      DataSet.FieldByName('ZISNEW').AsBoolean := False;
      ClientSystem.fDbOpr.CommitTrans;
    except
      ClientSystem.fDbOpr.RollbackTrans;
    end;

  end
  //修改
  else begin
    mySQL := Format(gc_SQL2,[
      DataSet.FieldByName('PRTY_NAME').AsString,
      DataSet.FieldByName('PRTY_DIRNAME').AsString,
      DataSet.FieldByName('PRTY_GUID').AsString
    ]);

    ClientSystem.fDbOpr.BeginTrans;
    try
      ClientSystem.fDbOpr.ExeSQL(PChar(mySQL));
      DataSet.FieldByName('ZISNEW').AsBoolean := False;
      ClientSystem.fDbOpr.CommitTrans;
    except
      ClientSystem.fDbOpr.RollbackTrans;
    end;

  end;
end;

procedure TPrototypeClientDlg.act_ClanceUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := cdsPrtyList.State in [dsInsert,dsEdit];
end;

procedure TPrototypeClientDlg.act_ClanceExecute(Sender: TObject);
begin
  cdsPrtyList.Cancel;
  pgcPrty.TabIndex := Ord(papr_list);
end;

procedure TPrototypeClientDlg.dbgrdListDblClick(Sender: TObject);
begin
  //打开
  act_PrtyView.Execute;
end;

procedure TPrototypeClientDlg.act_PrtyViewUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := cdsPrtyList.RecordCount > 0;
end;

procedure TPrototypeClientDlg.act_PrtyViewExecute(Sender: TObject);
var
  myDirName : string;
  myURL : string;
  flag : OleVariant;
begin
  myDirName := cdsPrtyList.FieldByName('PRTY_DIRNAME').AsString;
  if myDirName = '' then
  begin
    MessageBox(Handle,'SVN子目录不能为空','提示',MB_ICONERROR+MB_OK);
    Exit;
  end;

  if wbview.Busy then
  begin
    MessageBox(Handle,'浏览器加载太多，在忙着很等待。。。','提示',MB_ICONERROR+MB_OK);
    Exit;
  end;

  if DM.cdsSysParams.Locate('ZNAME','axure_web',[loPartialKey]) then
  begin
    myURL := DM.cdsSysParams.FieldByName('ZVALUE').AsString;
    myURL := myURL + myDirName;
    //当flags为navNoReadFromCache	或 4 时不从缓存中找
    //当flags为navNoWriteToCache	或 8 时不将当前页放入缓存
    wbview.offline:=true;
    flag := 4;
    wbview.Navigate(myURL,flag); //=4
    wbview.offline:=false;

    (*while true do
    begin
      if  wbview. then
      begin
        wbview.Refresh;
        Break;
      end;
    end;*)

    //打开
    pgcPrty.TabIndex := Ord(papr_view);
  end
  else begin
    MessageBox(Handle,'系统参数没有设参数(axure_web)','提示',MB_ICONERROR+MB_OK);
    Exit;
  end;
end;

procedure TPrototypeClientDlg.act_FirstPageExecute(Sender: TObject);
begin
  fPageType.fIndex := 1;
  LoaPrtyList(fPageType.fIndex,fPageType.fWhereStr);
  lblPageCount.Caption := format('%d/%d',[1,
  fPageType.fIndexCount]);
end;

procedure TPrototypeClientDlg.act_FirstPageUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := (fPageType.fIndex <> 1) and
  (fPageType.fIndexCount > 1);
end;

procedure TPrototypeClientDlg.act_ProPageExecute(Sender: TObject);
begin
  fPageType.fIndex := fPageType.fIndex -1;
  LoaPrtyList(fPageType.fIndex,fPageType.fWhereStr);
  lblPageCount.Caption := format('%d/%d',[
      fPageType.fIndex,
      fPageType.fIndexCount]);

  
end;

procedure TPrototypeClientDlg.act_ProPageUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := (fPageType.fIndex > 1) ;
end;

procedure TPrototypeClientDlg.act_NextPageUpdate(Sender: TObject);
begin
 (Sender as TAction).Enabled := (fPageType.fIndex<fPageType.fIndexCount);
end;

procedure TPrototypeClientDlg.act_NextPageExecute(Sender: TObject);
begin
  fPageType.fIndex := fPageType.fIndex +1;
  LoaPrtyList(fPageType.fIndex,fPageType.fWhereStr);
  lblPageCount.Caption := format('%d/%d',[
      fPageType.fIndex,
      fPageType.fIndexCount]);
end;

procedure TPrototypeClientDlg.act_LastPageUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := (fPageType.fIndex<fPageType.fIndexCount);
end;

procedure TPrototypeClientDlg.act_LastPageExecute(Sender: TObject);
begin
  fPageType.fIndex := fPageType.fIndexCount;
  LoaPrtyList(fPageType.fIndex,fPageType.fWhereStr);
  lblPageCount.Caption := format('%d/%d',[
      fPageType.fIndex,
      fPageType.fIndexCount]);

end;

procedure TPrototypeClientDlg.act_RefreshDataExecute(Sender: TObject);
begin
  LoaPrtyList(fPageType.fIndex,fPageType.fWhereStr);
  lblPageCount.Caption := format('%d/%d',[
      fPageType.fIndex,
      fPageType.fIndexCount]);


end;

procedure TPrototypeClientDlg.LoadAttach(ABugID: Integer);
var
  mycds : TClientDataSet;
  mySQL : string;
  myItem : TListItem;
  myData : PAttachFileRec;
  myb : Boolean;
  myExt : string;
const
  glSQL = 'select * from  TB_FILE_ITEM where ZCONTENTID=%d and ZSTYPE=8 Order by ZEDITDATETIME';
begin
  mycds := TClientDataSet.Create(nil);
  myb := fLoading;
  fLoading := True;
  lvAttach.Items.BeginUpdate;
  try

    ClearAttachFile;
    mySQL := format(glSQL,[ABugID]);
    mycds.Data := ClientSystem.fDbOpr.ReadDataSet(PChar(mySQL));
    if mycds.RecordCount > 0 then
    begin
      mycds.First;
      while not mycds.Eof do
      begin
        myItem := lvAttach.Items.Add;
        myItem.Caption := mycds.FieldByName('ZNAME').AsString;
        myExt := mycds.FieldByname('ZEXT').AsString;
        if fFileIconIndexList.IndexOfName(myExt) >=0 then
          myItem.ImageIndex := StrToIntDef(fFileIconIndexList.Values[myExt],0)
        else begin
          myItem.ImageIndex := GetFileIconIndex('c:\' + myItem.Caption,ilAttach);
          fFileIconIndexList.Add(Format('%s=%d',[myExt,myItem.ImageIndex]));
        end;

        New(myData);
        myData^.fName   := myItem.Caption;
        mydata^.ffileid := mycds.FieldByName('ZID').AsInteger;
        myData^.fFileExt := mycds.FieldByname('ZEXT').AsString;
        myItem.Data    := mydata;

        mycds.Next;
      end;
    end;

  finally
    mycds.Free;
    lvAttach.Items.EndUpdate;
    fLoading := myb;
  end;

end;

procedure TPrototypeClientDlg.ClearAttachFile;
var
  i : Integer;
  myItem : PAttachFileRec;
begin
  for i:=0 to lvAttach.Items.Count -1 do
  begin
    myItem := lvAttach.Items[i].Data;
    Dispose(myItem);
  end;
  lvAttach.Clear;
end;

function TPrototypeClientDlg.GetFileIconIndex(FileName: string;
  AImageList: TImageList): integer;
var
  sinfo:SHFILEINFO;
  myIcon:TIcon;
  nIndex : integer;
begin
  Result  := -1;
  FillChar(sinfo, SizeOf(sinfo),0);
  SHGetFileInfo(PChar(FileName),FILE_ATTRIBUTE_NORMAL,sinfo,SizeOf(sInfo),
  SHGFI_USEFILEATTRIBUTES or SHGFI_ICON or SHGFI_LARGEICON{SHGFI_SMALLICON});
  if sinfo.hIcon>0 then
  begin
    myIcon:=TIcon.Create;
    myIcon.Handle:=sinfo.hIcon;
    nIndex:= AImageList.AddIcon(myIcon);
    myIcon.Free;
    Result := nIndex;
  end;
end;


procedure TPrototypeClientDlg.cdsPrtyListAfterScroll(DataSet: TDataSet);
var
  myID : Integer;
begin
  //
  if fLoading then Exit;

  myID := cdsPrtyList.fieldByName('ZID').AsInteger;
  LoadAttach(myID);
end;

procedure TPrototypeClientDlg.actAttach_AddfileExecute(Sender: TObject);
var
  myAid,myid : Integer;
  myfilename : string;
begin
  if fLoading then Exit;

  myAid  :=  cdsPrtyList.fieldByName('ZID').AsInteger;
  if myAid < 0 then
  begin
    Application.MessageBox('刚创建的原型请刷新一下才增加附件','增加附件',MB_ICONWARNING+MB_OK);
    Exit;
  end;

  if not dlgOpen1.Execute then Exit;

  myfilename := dlgOpen1.FileName;


  //上传中
  ShowProgress('上传文件中...',0);
  try
    myid := ClientSystem.fDbOpr.UpFile(8,myAid,myfilename);
  finally
    HideProgress;
  end;

  if myid = 0 then
  begin
    LoadAttach(myAid);
  end
  else
    Application.MessageBox(PChar('上传失败,错误号:' +inttostr(myid) ),'提示',
      MB_ICONERROR);
end;

procedure TPrototypeClientDlg.actAttach_downfileExecute(Sender: TObject);
var
  myfilename : string;
  myData : PAttachFileRec;
  myi : Integer;
begin
  //
  myData := lvAttach.Selected.Data;
  dlgSave1.Filter := Format('*%s|*%s',[myData^.fFileExt,myData^.fFileExt]);
  dlgSave1.FileName := myData^.fName;
  dlgSave1.DefaultExt := myData^.fFileExt;
  
  if not dlgSave1.Execute then
    Exit;
  myfilename := dlgSave1.FileName;
  myi := ClientSystem.fDbOpr.DownFile(myData^.ffileid,myfilename);
  if myi = 0 then
  begin
    Application.MessageBox('下载成功','提示',MB_ICONQUESTION);
  end
  else
    Application.MessageBox(PChar('下载失败,错误号:' + inttostr(myi)),'提示',MB_ICONERROR);


end;


procedure TPrototypeClientDlg.actAttach_downfileUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := Assigned(lvAttach.Selected)
  and Assigned(lvAttach.Selected.Data);
end;

procedure TPrototypeClientDlg.lvAttachDblClick(Sender: TObject);
begin
  inherited;
  //
  if Assigned(lvAttach.Selected) and Assigned(lvAttach.Selected.Data) then
    actAttach_downfileExecute(nil);   
end;

end.
