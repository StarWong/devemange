unit BugManageClientfrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseChildfrm, ExtCtrls, ComCtrls, DB, DBClient,

  ClientTypeUnits, ActnList, Menus, Grids, DBGrids, StdCtrls, Buttons,
  DBCtrls, Mask, dbcgrids,BugHighQueryfrm;

type

  TBugColumns = (bcCode,bcTitle,bcWhoBuild,bcAssingeto,bcwhoReso,bcType,bcBuildDate
    ,bcResoDate);

  TPageType = (ptDir,ptMe,ptQuery); //����Ŀ��ҳ,�����Ҵ�����ҳ��ָ���ҷ�ҳ

  TPageTypeRec = record
    fName : string;
    fType : TPageType;
    fIndex : Integer;
    fIndexCount : Integer;
    fWhereStr : string; //��ҳ��where����
  end;

  TBugManageDlg = class(TBaseChildDlg)
    plCenter: TPanel;
    plnovisible: TPanel;
    cdsBugTree: TClientDataSet;
    ActionList1: TActionList;
    actBug_AddDir: TAction;
    pmBugTree: TPopupMenu;
    N1: TMenuItem;
    actBug_Del: TAction;
    N2: TMenuItem;
    actBug_Update: TAction;
    N3: TMenuItem;
    cdsBugItem: TClientDataSet;
    dsBugItem: TDataSource;
    actBug_NewPage: TAction;
    actBug_PrivPage: TAction;
    actBug_FirstPage: TAction;
    actBug_LastPage: TAction;
    pmBugItem: TPopupMenu;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    cdsBugType: TClientDataSet;
    cdsBugPlan: TClientDataSet;
    actBug_AddBug: TAction;
    cdsBugLevel: TClientDataSet;
    dsBugLevel: TDataSource;
    cdsProject: TClientDataSet;
    dsProject: TDataSource;
    pcBug: TPageControl;
    tsBugItem: TTabSheet;
    tsBugContext: TTabSheet;
    Splitter1: TSplitter;
    tvProject: TTreeView;
    plBugList: TPanel;
    dgBugItem: TDBGrid;
    plBugTop: TPanel;
    BitBtn3: TBitBtn;
    dsBugType: TDataSource;
    cdsBugHistory: TClientDataSet;
    dsBugBugHistory: TDataSource;
    actBugItem_Save: TAction;
    actBugItem_Cancel: TAction;
    actBugHistory_Add: TAction;
    plBugItemBottom: TPanel;
    BitBtn11: TBitBtn;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn6: TBitBtn;
    lbPageCount: TLabel;
    N8: TMenuItem;
    N9: TMenuItem;
    actBugHistory_Save: TAction;
    actBugHistory_Resolu: TAction;
    actBugHistory_ReSet: TAction;
    actBugHistory_Cancel: TAction;
    Splitter2: TSplitter;
    plBugHistory: TPanel;
    plBugHistoryTop: TPanel;
    Label13: TLabel;
    Bevel1: TBevel;
    BitBtn7: TBitBtn;
    BitBtn10: TBitBtn;
    BitBtn8: TBitBtn;
    BitBtn9: TBitBtn;
    BitBtn12: TBitBtn;
    Panel1: TPanel;
    dbcBugHistory: TDBCtrlGrid;
    DBText1: TDBText;
    DBText2: TDBText;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    DBText3: TDBText;
    Label12: TLabel;
    DBText4: TDBText;
    DBText5: TDBText;
    DBMemo1: TDBMemo;
    dsBugPlan: TDataSource;
    lbProjectName: TLabel;
    actBugHistory_PrivBug: TAction;
    actBugHistory_NextBug: TAction;
    cdsBugStatus: TClientDataSet;
    dsBugStatus: TDataSource;
    actBug_MeBuild: TAction;
    BitBtn15: TBitBtn;
    BitBtn16: TBitBtn;
    BitBtn17: TBitBtn;
    actBug_AssingToMe: TAction;
    actBug_ResoMe: TAction;
    actBugHistory_OpenFile: TAction;
    actBug_RefreshData: TAction;
    N10: TMenuItem;
    cbSort: TComboBox;
    DBNavigator1: TDBNavigator;
    N11: TMenuItem;
    N12: TMenuItem;
    btnBug_RefreshData: TBitBtn;
    pnlContextTop: TPanel;
    lbBugCaption: TLabel;
    DBText6: TDBText;
    actBug_HighQuery: TAction;
    N13: TMenuItem;
    cdstemp: TClientDataSet;
    btnBug_HighQuery: TBitBtn;
    actBug_Moveto: TAction;
    N14: TMenuItem;
    actBugHistory_Savetofile: TAction;
    dlgSave1: TSaveDialog;
    dbtxtZFILESAVE: TDBText;
    cbbTag: TComboBox;
    scrlbx1: TScrollBox;
    lbl1: TLabel;
    lbl2: TLabel;
    lbl3: TLabel;
    lbl4: TLabel;
    lbl5: TLabel;
    lbl6: TLabel;
    lbl7: TLabel;
    lbl8: TLabel;
    lbl9: TLabel;
    lbl10: TLabel;
    lbl11: TLabel;
    lbl12: TLabel;
    lbl13: TLabel;
    lbl14: TLabel;
    dblkcbbZOS: TDBLookupComboBox;
    dbedtZTREEPATH: TDBEdit;
    dblkcbbZOPENVER: TDBLookupComboBox;
    dbedtZTITLE: TDBEdit;
    dblkcbbZLEVEL: TDBLookupComboBox;
    dblkcbbZTYPE: TDBLookupComboBox;
    btnBugItem_Save: TBitBtn;
    btnBugItem_Cancel: TBitBtn;
    dblkcbbZASSIGNEDTO: TDBLookupComboBox;
    dbedtZMAILTO: TDBEdit;
    dbedtZASSIGNEDDATE: TDBEdit;
    dbedtZRESOLVEDNAME: TDBEdit;
    dbedtZRESOLUTIONNAME: TDBEdit;
    dblkcbbZRESOLVEDVER: TDBLookupComboBox;
    btnBugHistory_PrivBug: TBitBtn;
    btnBugHistory_NextBug: TBitBtn;
    dbedtZRESOLVEDDATE: TDBEdit;
    dblkcbbSelectUsermail: TDBLookupComboBox;
    dbtxt1: TDBText;
    dbtxtZTAGNAME: TDBText;
    cdsTerm: TClientDataSet;
    dsTerm: TDataSource;
    lbl15: TLabel;
    actBug_ExportExcel: TAction;
    Excel1: TMenuItem;
    btnBud_AddByDemand: TBitBtn;
    actBud_AddByDemand: TAction;
    actBug_GotoDemand: TAction;
    btnBug_GotoDemand: TBitBtn;
    act_AllData: TAction;
    btnAllData: TBitBtn;
    dbedtZDEMAND_ID: TDBEdit;
    dbmmoZTITLE: TDBMemo;
    actBug_Verify: TAction;
    dbedtZNEDDDATE: TDBEdit;
    BtnSelectedDataTime: TBitBtn;
    grp1: TGroupBox;
    BtnBug_Verify: TBitBtn;
    lbl16: TLabel;
    dbedtZVERIF_NAME: TDBEdit;
    lbl17: TLabel;
    dbedtZVERIFYDATE: TDBEdit;
    procedure actBug_AddDirExecute(Sender: TObject);
    procedure tvProjectExpanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
    procedure actBug_DelUpdate(Sender: TObject);
    procedure actBug_DelExecute(Sender: TObject);
    procedure actBug_UpdateUpdate(Sender: TObject);
    procedure actBug_UpdateExecute(Sender: TObject);
    procedure tvProjectChange(Sender: TObject; Node: TTreeNode);
    procedure actBug_NewPageExecute(Sender: TObject);
    procedure actBug_NewPageUpdate(Sender: TObject);
    procedure actBug_PrivPageUpdate(Sender: TObject);
    procedure actBug_PrivPageExecute(Sender: TObject);
    procedure actBug_FirstPageUpdate(Sender: TObject);
    procedure actBug_FirstPageExecute(Sender: TObject);
    procedure actBug_LastPageUpdate(Sender: TObject);
    procedure actBug_LastPageExecute(Sender: TObject);
    procedure pcBugChanging(Sender: TObject; var AllowChange: Boolean);
    procedure actBug_AddBugUpdate(Sender: TObject);
    procedure cdsBugItemNewRecord(DataSet: TDataSet);
    procedure actBug_AddBugExecute(Sender: TObject);
    procedure actBugItem_SaveUpdate(Sender: TObject);
    procedure actBugItem_CancelUpdate(Sender: TObject);
    procedure actBugItem_CancelExecute(Sender: TObject);
    procedure cdsBugItemBeforePost(DataSet: TDataSet);
    procedure actBugItem_SaveExecute(Sender: TObject);
    procedure actBugHistory_AddExecute(Sender: TObject);
    procedure actBugHistory_AddUpdate(Sender: TObject);
    procedure tvProjectChanging(Sender: TObject; Node: TTreeNode;
      var AllowChange: Boolean);
    procedure actBugHistory_ResoluUpdate(Sender: TObject);
    procedure actBugHistory_ReSetUpdate(Sender: TObject);
    procedure actBugHistory_ResoluExecute(Sender: TObject);
    procedure actBugHistory_SaveUpdate(Sender: TObject);
    procedure actBugHistory_SaveExecute(Sender: TObject);
    procedure actBugHistory_CancelUpdate(Sender: TObject);
    procedure actBugHistory_CancelExecute(Sender: TObject);
    procedure actBugHistory_ReSetExecute(Sender: TObject);
    procedure cdsBugHistoryNewRecord(DataSet: TDataSet);
    procedure cdsBugHistoryBeforePost(DataSet: TDataSet);
    procedure actBugHistory_PrivBugUpdate(Sender: TObject);
    procedure actBugHistory_NextBugUpdate(Sender: TObject);
    procedure actBugHistory_PrivBugExecute(Sender: TObject);
    procedure actBugHistory_NextBugExecute(Sender: TObject);
    procedure dgBugItemDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure actBug_MeBuildExecute(Sender: TObject);
    procedure actBug_AssingToMeExecute(Sender: TObject);
    procedure actBug_ResoMeExecute(Sender: TObject);
    procedure DBText3DblClick(Sender: TObject);
    procedure actBugHistory_OpenFileExecute(Sender: TObject);
    procedure actBugHistory_OpenFileUpdate(Sender: TObject);
    procedure actBug_RefreshDataUpdate(Sender: TObject);
    procedure actBug_RefreshDataExecute(Sender: TObject);
    procedure dblkcbbSelectUsermailCloseUp(Sender: TObject);
    procedure actBug_HighQueryExecute(Sender: TObject);
    procedure actBug_MovetoExecute(Sender: TObject);
    procedure actBug_MovetoUpdate(Sender: TObject);
    procedure pcBugChange(Sender: TObject);
    procedure lblSavetofileClick(Sender: TObject);
    procedure actBugHistory_SavetofileExecute(Sender: TObject);
    procedure dbtxtZFILESAVEClick(Sender: TObject);
    procedure cbbTagChange(Sender: TObject);
    procedure actBug_ExportExcelExecute(Sender: TObject);
    procedure actBud_AddByDemandExecute(Sender: TObject);
    procedure actBug_GotoDemandUpdate(Sender: TObject);
    procedure act_AllDataExecute(Sender: TObject);
    procedure actBug_GotoDemandExecute(Sender: TObject);
    procedure actBug_VerifyExecute(Sender: TObject);
    procedure actBug_VerifyUpdate(Sender: TObject);
    procedure BtnSelectedDataTimeClick(Sender: TObject);
  private
    fPageType : TPageTypeRec; //��ҳ����
    fHighQuery : TBugHighQueryDlg;
    fZRESOLVEDBY : Integer; //��������Ϊ������

    procedure ClearNode(AParent:TTreeNode);
    function  GetBugItemPageCount(APageIndex:integer;AWhereStr:String):integer; //ȡ��ҳ����
    procedure LoadBugItem(APageIndex:integer;AWhereStr:String);
    procedure LoadBugHistory(ABugID:integer); //����bug�Ļظ�
    function  UpBugFile(APro_ID:integer;AFileName:String;var AFileID:integer):Boolean; //�ϴ��ļ��������ļ���ID��
    procedure Mailto(AEmailto:String); //���͵�����
    procedure WMShowBugItem(var msg:TMessage); message gcMSG_GetBugItem; //ֱ����ʾbug,���ڲ���������
    procedure LoadTag(AItems:TStrings);
    procedure SetTag(ATagName:string); //���ñ�ǩ
  public
    { Public declarations }
    procedure initBase; override;
    procedure freeBase; override;
    procedure LoadBugTree(APID:integer;APNode:TTreeNode);
    class function GetModuleID : integer;override;
  end;

var
  BugManageDlg: TBugManageDlg;

implementation
uses
  ShellAPI,
  AddBugTreeNodefrm,          {����BUG��Ŀ}
  ClinetSystemUnits,
  Activationfrm,              {�����}
  TickDateTimefrm,            {ѡ�񴰿�}
  SelectBugStatusfrm,
  BugAeplyfrm,
  ComObj,
  DmUints;

{$R *.dfm}

{ TBugManageDlg }

procedure TBugManageDlg.ClearNode(AParent: TTreeNode);
  procedure DofreeChild(APNode:TTreeNode);
  var
    i : integer;
    myBugData : PBugTreeNode;
  begin
    for i:=0 to APNode.Count -1 do
    begin
      if Assigned(APNode.Item[i]) and
         Assigned(APNode.Item[i].data) then
      begin
        myBugData := APNode.Item[i].data;
        Dispose(myBugData);
      end;
      if APNode.Item[i].HasChildren then
        DofreeChild(APNode.Item[i]);
    end;
  end;
var
  myChild   : TTreeNode;
  myBugData : PBugTreeNode;
  myb : Boolean;
begin
  myb := fLoading;
  fLoading := True;
  try
    if Assigned(AParent) then
    begin
      DofreeChild(AParent);
      AParent.DeleteChildren;
    end
    else begin
      myChild := tvProject.TopItem;
      while Assigned(myChild) do
      begin
        if Assigned(myChild.Data) then
        begin
          myBugData := myChild.Data;
          Dispose(myBugData);
        end;
        myChild := myChild.GetNext;
      end;
      tvProject.Items.Clear;
    end;
  finally
    fLoading := myb;
  end;
end;

class function TBugManageDlg.GetModuleID: integer;
begin
  Result := Ord(mtBug);
end;

procedure TBugManageDlg.initBase;
const
  glSQL  = 'select ZID,ZNAME from TB_BUG_PARAMS where ZTYPE=%d';
begin
  with ClientSystem.fDbOpr do
  begin
    cdsBugStatus.Data := ReadDataSet(PChar(format(glSQL,[1])));
    cdsBugType.Data := ReadDataSet(PChar(format(glSQL,[4])));
    cdsBugPlan.Data := ReadDataSet(PChar(format(glSQL,[2])));
    cdsBugLEVEL.Data := ReadDataSet(PChar(format(glSQL,[5])));
    cdsTerm.Data     := ReadDataSet(PChar(format(glSQL,[6])));
  end;
  LoadTag(cbbTag.Items);
  LoadBugTree(-1,nil);
  fHighQuery := nil;
end;

procedure TBugManageDlg.LoadBugTree(APID: integer; APNode: TTreeNode);
var
  mySQL : string;
  myNode : TTreeNode;
  myData,myPData : PBugTreeNode;
  myb : Boolean;
const
  glSQL  = 'select * from TB_BUG_TREE where ZPID=%d Order by ZSORT';
begin
  myb := fLoading;
  fLoading := True;
  try
    mySQL := format(glSQL,[APID]);
    cdsBugTree.Data := ClientSystem.fDbOpr.ReadDataSet(PChar(mySQL));
    cdsBugTree.First;
    ClearNode(APNode); //�����Ŀ
    while not cdsBugTree.Eof do
    begin
      //
      // û��Ȩ�޲�����
      //
      if not HasModuleAction(Ord(bsBugTree),
        cdsBugTree.FieldByName('ZID').AsInteger,atView) then
      begin
        cdsBugTree.Next;
        Continue;
      end;

      new(myData);
      myData^.fName := cdsBugTree.FieldByName('ZNAME').AsString;
      if Assigned(APNode) and Assigned(APNode.data) then
      begin
        myPData := APNode.data;
        myData^.fParent := myPData;
        myPData^.fhasLoad := True; //�Ѽ��ع���
      end
      else
        myData^.fParent := nil;
      myData^.fID  := cdsBugTree.FieldByName('ZID').AsInteger;
      myData^.fPID := cdsBugTree.FieldByName('ZPID').AsInteger;
      myData^.fPRO_ID := cdsBugTree.FieldByName('ZPRO_ID').AsInteger;
      myData^.fAddDate := cdsBugTree.FieldByName('ZADDDATE').AsDateTime;
      myData^.fSort    := cdsBugTree.FieldByName('ZSORT').AsInteger;
      myData^.fhasChild := cdsBugTree.FieldByName('ZHASCHILD').AsBoolean;
      myData^.fPageIndex := 1;
      myData^.fPageCount := 1;
      myNode := tvProject.Items.AddChild(APNode,myData^.fName);
      myNode.Data := myData;
      if myData^.fhasChild then
      begin
        tvProject.Items.AddChildFirst(myNode,'��ȡ����...');
        myData^.fhasLoad := False;
      end
      else
        myData^.fhasLoad := True;
      if myNode.Level = 0 then
      begin
        myNode.ImageIndex := 0;
        myNode.SelectedIndex := 0;
      end
      else begin
        myNode.ImageIndex := 1;
        myNode.SelectedIndex := 1;
      end;
      cdsBugTree.Next;
    end;

  finally
    fLoading := myb;
  end;

end;

procedure TBugManageDlg.actBug_AddDirExecute(Sender: TObject);
var
  myPID : integer;
  myPData : PBugTreeNode;
  mySQL : String;
const
  glSQL  = 'insert TB_BUG_TREE (ZPID,ZPRO_ID,ZNAME,ZADDDATE,ZSORT,ZHASCHILD) '+
           'values(%d,%d,''%s'',''%s'',%d,0)';
  glSQL2 = 'update TB_BUG_TREE set ZHASCHILD=1 where ZID=%d';
begin
  with TAddBugTreeNodeDlg.Create(nil) do
  try
    if ShowModal = mrOK then
    begin
      myPData := nil;
      ClientSystem.fDbOpr.BeginTrans;
      try
        if rbRoot.Checked then
          myPID := -1
        else if rbSelectNode.Checked then
        begin
          if not Assigned(tvProject.Selected) or
             not Assigned(tvProject.Selected.data) then
          begin
            MessageBox(Handle,'��ѡ��ǰ����Ŀ','��ʾ',MB_ICONERROR+MB_OK);
            ClientSystem.fDbOpr.RollbackTrans;
            Exit;
          end;
          myPData := tvProject.Selected.data;
          myPID := myPData^.fID;
        end
        else begin
          ClientSystem.fDbOpr.RollbackTrans;
          Exit;
        end;

        //Ȩ��
        if not HasModuleActionByShow(Ord(bsBugTree),myPID,atInsert) then
          Exit;
          
        mySQL := format(glSQL,[myPID,
          strtoint(edProID.Text),
          edName.Text,
          datetimetostr(dpAddDate.DateTime),
          strtoint(edSort.Text)]);
        ClientSystem.fDbOpr.ExeSQL(PChar(mySQL));
        if myPID = -1 then
          LoadBugTree(-1,nil)
        else begin
          if Assigned(myPData) and not myPData^.fhasChild then
          begin
            mySQL := format(glSQL2,[myPData^.fID]);
            ClientSystem.fDbOpr.ExeSQL(PChar(mySQL));
            myPData^.fhasChild := True;
          end;
          LoadBugTree(myPID,tvProject.Selected);
        end;
        ClientSystem.fDbOpr.CommitTrans;
      except
        ClientSystem.fDbOpr.RollbackTrans;
      end;
    end;
  finally
    free;
  end;
end;

procedure TBugManageDlg.tvProjectExpanding(Sender: TObject;
  Node: TTreeNode; var AllowExpansion: Boolean);
var
  myNodeData : PBugTreeNode;
  myb : Boolean;
begin
  if Assigned(Node) and Assigned(Node.data) then
  begin
    myb := fLoading;
    fLoading := True;
    try
      myNodeData := Node.data;
      if (not myNodeData^.fhasLoad) and myNodeData^.fhasChild then
        LoadBugTree(myNodeData^.fID ,Node);
    finally
      fLoading := myb;
    end;
  end;
  AllowExpansion := True;
end;

procedure TBugManageDlg.actBug_DelUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := Assigned(tvProject.Selected)
  and Assigned(tvProject.Selected.data);
end;

procedure TBugManageDlg.actBug_DelExecute(Sender: TObject);
var
  myData : PBugTreeNode;
begin
  myData := tvProject.Selected.data;
  if not HasModuleActionByShow(Ord(bsBugTree),myData^.fID,atDelete) then
    Exit;
  if MessageBox(Handle,PChar(format('ɾ�� %s',[myData^.fName])),
    'ѯ��',MB_ICONQUESTION+MB_YESNO)=IDNO then Exit;

  //ִ��ɾ��
  
end;

procedure TBugManageDlg.actBug_UpdateUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := Assigned(tvProject.Selected)
  and Assigned(tvProject.Selected.data);
end;

procedure TBugManageDlg.actBug_UpdateExecute(Sender: TObject);
var
  myData : PBugTreeNode;
  mySQL  : string;
const
  glSQL  = 'update TB_BUG_TREE set ZNAME=''%s'',ZPRO_ID=%d,ZSORT=%d,ZADDDATE=''%s'' '+
           'where ZID=%d';
begin
  myData := tvProject.Selected.data;
  if not HasModuleActionByShow(Ord(bsBugTree),myData^.fID,atUpdate) then
    Exit;
  with TAddBugTreeNodeDlg.Create(nil) do
  try
    GroupBox1.Visible := False;
    edName.Text := myData^.fName;
    edPROID.Text := inttostr(myData^.fPRO_ID);
    edSort.Text  := inttostr(myData^.fSort);
    dpAddDate.DateTime := myData^.fAddDate;

    if ShowModal = mrOK then
    begin
      ClientSystem.fDbOpr.BeginTrans;
      try
        mySQL := format(glSQL,[
          edName.Text,
          strtoint(edPROID.text),
          strtoint(edSort.text),
          datetimetostr(dpAddDate.DateTime),
          myData^.fID]);
        ClientSystem.fDbOpr.ExeSQL(PChar(mySQL));
        mydata^.fName := edName.Text;
        mydata^.fPRO_ID := strtoint(edPROID.Text);
        mydata^.fSort := strtoint(edSort.Text);
        mydata^.fAddDate := dpAddDate.DateTime;
        tvProject.Selected.Text := mydata^.fName;

        ClientSystem.fDbOpr.CommitTrans;
      except
        ClientSystem.fDbOpr.RollbackTrans;
      end;
    end;

  finally
    free;
  end;
end;

procedure TBugManageDlg.tvProjectChange(Sender: TObject; Node: TTreeNode);
var
  myPageIndex:integer;
  mywhere : String;
  myData : PBugTreeNode;
begin
  //
  //���������б�
  // ����ʱ������ע�ⲻҪȫ�����أ���Ϊ�Ժ��
  // �����ǻ�ܶ࣬����ط��ܹؼ���
  //
  if fLoading then Exit;
  if not Assigned(Node.data) then Exit;
  myData := Node.data;

  ShowStatusBarText(2,format('�ֲ���=%d',[myData^.fid]));

  //Ȩ��
  if not HasModuleActionByShow(Ord(bsBugTree),myData.fID,atView) then
  begin
    Exit;
  end;


  fPageType.fType := ptDir;
  fPageType.fWhereStr := 'ZTREE_ID=';
  myPageIndex := myData^.fPageIndex;
  mywhere := fPageType.fWhereStr {'ZTREE_ID='} + inttostr(myData^.fID);
  myData^.fPageCount := GetBugItemPageCount(myPageindex,myWhere);
  lbPageCount.Caption := format('%d/%d',[
    myData^.fPageIndex,
    myData^.fPageCount]);
  LoadBugItem(myPageindex,myWhere);
  lbProjectName.Caption := format('%s  =>��%d��%dҳ',[
    myData^.fName,myData^.fPageIndex,myData^.fPageCount]);

end;

procedure TBugManageDlg.LoadBugItem(APageIndex: integer;
  AWhereStr: String);
var
  mySQL  : string;
  i : integer;
  myfield : TFieldDef;
  myDataSet : TClientDataSet;
  myb : Boolean;
  mywhere : String;
const
  glSQL = 'exec pt_SplitPage ''TB_BUG_ITEM'',' +
          '''ZPRO_ID,ZID,ZTYPE,ZTITLE,ZOPENEDBY,ZOPENEDDATE,ZASSIGNEDTO,ZRESOLVEDBY,' +
          'ZRESOLUTION,ZRESOLVEDDATE,ZOS,ZLEVEL,ZSTATUS,ZMAILTO,ZOPENVER, ' +
          'ZRESOLVEDVER,ZTREEPATH,ZTREE_ID,ZASSIGNEDTO,ZASSIGNEDDATE,ZTAGNAME,ZTERM,ZDEMAND_ID,ZNEDDDATE,ZVERIFYDATE,ZVERIFYED,ZVERIFNAME'',' +
          '''%s'',20,%d,%d,1,''%s''';
  //                                             ҳ��,������=1, ����where
begin

  mywhere := AWhereStr;
  if cbSort.ItemIndex = 0 then  //���������
    mySQL := format(glSQL,[
      'ZID',
      APageIndex,
      0, //����ȡ����
      mywhere])
  else
    mySQL := format(glSQL,[
      'ZLASTEDITEDDATE',
      APageIndex,
      0, //����ȡ����
      mywhere]);

  if fLoading then Exit;

  ClientSystem.BeginTickCount;
  myb := fLoading;
  fLoading := True;
  myDataSet := TClientDataSet.Create(nil);
  ShowProgress('��ȡ����...',0);
  try
    myDataSet.Data := ClientSystem.fDbOpr.ReadDataSet(PChar(mySQL));
    if cdsBugItem.Fields.Count=0 then
      with cdsBugItem do
      begin
        Fields.Clear;
        FieldDefs.Assign(myDataSet.FieldDefs);
        myfield := FieldDefs.AddFieldDef;
        myfield.Name :='ZISNEW';
        myfield.DataType := ftBoolean;
        for i:=0 to FieldDefs.Count -1 do
        begin
          FieldDefs[i].CreateField(cdsBugItem).Alignment := taLeftJustify;
        end;

        //��������
        myfield := FieldDefs.AddFieldDef;
        myfield.Name :='ZBUGTYPE';
        myfield.DataType := ftString;
        myfield.Size := 50;
        with myfield.CreateField(cdsBugItem) do
        begin
          FieldKind := fkLookup;
          KeyFields := 'ZTYPE';
          LookupDataSet := cdsBugType;
          LookupKeyFields := 'ZID';
          LookupResultField := 'ZNAME';
        end;

        //��˭����
        myfield := FieldDefs.AddFieldDef;
        myfield.Name :='ZOPENEDNAME';
        myfield.DataType := ftString;
        myfield.Size := 50;
        with myfield.CreateField(cdsBugItem) do
        begin
          FieldKind := fkLookup;
          KeyFields := 'ZOPENEDBY';
          LookupDataSet := DM.cdsUserAll;
          LookupKeyFields := 'ZID';
          LookupResultField := 'ZNAME';
        end;

        //ָ�ɸ�
        myfield := FieldDefs.AddFieldDef;
        myfield.Name :='ZASSIGNEDNAME';
        myfield.DataType := ftString;
        myfield.Size := 50;
        with myfield.CreateField(cdsBugItem) do
        begin
          FieldKind := fkLookup;
          KeyFields := 'ZASSIGNEDTO';
          LookupDataSet := DM.cdsUserAll;
          LookupKeyFields := 'ZID';
          LookupResultField := 'ZNAME';
        end;

        //�����
        myfield := FieldDefs.AddFieldDef;
        myfield.Name :='ZRESOLVEDNAME';
        myfield.DataType := ftString;
        myfield.Size := 50;
        with myfield.CreateField(cdsBugItem) do
        begin
          FieldKind := fkLookup;
          KeyFields := 'ZRESOLVEDBY';
          LookupDataSet := DM.cdsUserAll;
          LookupKeyFields := 'ZID';
          LookupResultField := 'ZNAME';
        end;

        //�������
        myfield := FieldDefs.AddFieldDef;
        myfield.Name :='ZRESOLUTIONNAME';
        myfield.DataType := ftString;
        myfield.Size := 50;
        with myfield.CreateField(cdsBugItem) do
        begin
          FieldKind := fkLookup;
          KeyFields := 'ZRESOLUTION';
          LookupDataSet := cdsBugPlan;
          LookupKeyFields := 'ZID';
          LookupResultField := 'ZNAME';
        end;

        //Ҫ������
        myfield := FieldDefs.AddFieldDef;
        myfield.Name :='ZTERMNAME';
        myfield.DataType := ftString;
        myfield.Size := 50;
        with myfield.CreateField(cdsBugItem) do
        begin
          FieldKind := fkLookup;
          KeyFields := 'ZTERM';
          LookupDataSet := cdsTerm;
          LookupKeyFields := 'ZID';
          LookupResultField := 'ZNAME';
        end;

        //�����
        myfield := FieldDefs.AddFieldDef;
        myfield.Name :='ZVERIF_NAME';
        myfield.DataType := ftString;
        myfield.Size := 50;
        with myfield.CreateField(cdsBugItem) do
        begin
          FieldKind := fkLookup;
          KeyFields := 'ZVERIFNAME';
          LookupDataSet := DM.cdsUserAll;
          LookupKeyFields := 'ZID';
          LookupResultField := 'ZNAME';
        end;

        CreateDataSet;
      end
    else begin
      cdsBugItem.DisableControls;
      try
        while not cdsBugItem.IsEmpty do cdsBugItem.Delete;
      finally
        cdsBugItem.EnableControls;
      end;
    end;

    cdsBugItem.DisableControls;
    try
      myDataSet.First;
      while not myDataSet.Eof do
      begin
        cdsBugItem.Append;
        cdsBugItem.FieldByName('ZISNEW').AsBoolean := False;
        for i:=0 to myDataSet.FieldDefs.Count -1 do
          cdsBugItem.FieldByName(myDataSet.FieldDefs[i].Name).AsVariant :=
            myDataSet.FieldByName(myDataSet.FieldDefs[i].Name).AsVariant;
        cdsBugItem.Post;
        myDataSet.Next;
      end;
      cdsBugItem.First;
    finally
      cdsBugItem.EnableControls;
    end;

  finally
    myDataSet.Free;
    fLoading :=myb;
    ClientSystem.EndTickCount;
    HideProgress;
  end;
end;

procedure TBugManageDlg.actBug_NewPageExecute(Sender: TObject);
var
  myPageIndex:integer;
  mywhere : String;
  myData : PBugTreeNode;
begin
  if fLoading then Exit;
  //
  // ���������,�������Ҵ����ķ�ҳ,������һҳ���ǰ���Ŀ����ҳ��.
  //
  if fPageType.fType = ptme then
  begin
    fPageType.fIndex := fPageType.fIndex + 1;
    myPageIndex := fPageType.fIndex;
    mywhere := Format(fPageType.fWhereStr,[ClientSystem.fEditer_id]);
    LoadBugItem(myPageindex,myWhere);
    lbPageCount.Caption := format('%d/%d',[
      fPageType.fIndex,
      fPageType.fIndexCount]);
    lbProjectName.Caption := format('%s  =>��%d��%dҳ',[
      fPageType.fName,fPageType.fIndex,fPageType.fIndexCount]);
  end
  else if fPageType.fType = ptQuery then
  begin
    fPageType.fIndex := fPageType.fIndex + 1;
    myPageIndex := fPageType.fIndex;
    mywhere := fPageType.fWhereStr;
    LoadBugItem(myPageindex,myWhere);
    lbPageCount.Caption := format('%d/%d',[
      fPageType.fIndex,
      fPageType.fIndexCount]);
    lbProjectName.Caption := format('%s  =>��%d��%dҳ',[
      fPageType.fName,fPageType.fIndex,fPageType.fIndexCount]);
  end
  else begin
    mydata := tvProject.Selected.data;
    mydata^.fPageIndex := mydata^.fPageIndex + 1;
    myPageIndex := myData^.fPageIndex;
    mywhere := 'ZTREE_ID=' + inttostr(myData^.fID);
    LoadBugItem(myPageindex,myWhere);
    lbPageCount.Caption := format('%d/%d',[
      myData^.fPageIndex,
      myData^.fPageCount]);
    lbProjectName.Caption := format('%s  =>��%d��%dҳ',[
      myData^.fName,myData^.fPageIndex,myData^.fPageCount]);
  end;
end;

procedure TBugManageDlg.actBug_NewPageUpdate(Sender: TObject);
begin
  if fPageType.fType in [ptme,ptQuery] then
  begin
    (sender as TAction).Enabled := not fLoading
    and (fPageType.fIndex<fPageType.fIndexCount);
  end
  else begin
    (sender as TAction).Enabled := not fLoading
    and Assigned(tvProject.Selected)
    and Assigned(tvProject.Selected.data)
    and (PBugTreeNode(tvProject.Selected.data)^.fPageIndex<
      PBugTreeNode(tvProject.Selected.data).fPageCount);
  end;
end;

procedure TBugManageDlg.actBug_PrivPageUpdate(Sender: TObject);
begin
  if fPageType.fType in [ptme,ptQuery] then
  begin
    (sender as TAction).Enabled := not fLoading
    and (fPageType.fIndex>1);
  end
  else begin
    (sender as TAction).Enabled := not fLoading
    and Assigned(tvProject.Selected)
    and Assigned(tvProject.Selected.data)
    and (PBugTreeNode(tvProject.Selected.data)^.fPageIndex>1);
  end;
end;

procedure TBugManageDlg.actBug_PrivPageExecute(Sender: TObject);
var
  myPageIndex:integer;
  mywhere : String;
  myData : PBugTreeNode;
begin
  if fLoading then Exit;
  if fPageType.fType = ptMe then
  begin
    fPageType.fIndex := fPageType.fIndex -1;
    myPageIndex := fPageType.fIndex;
    mywhere := Format(fPageType.fWhereStr,[ClientSystem.fEditer_id]);
    LoadBugItem(myPageindex,myWhere);
    lbPageCount.Caption := format('%d/%d',[
      fPageType.fIndex,
      fPageType.fIndexCount]);
    lbProjectName.Caption := format('%s  =>��%d��%dҳ',[
      fPageType.fName,fPageType.fIndex,fPageType.fIndexCount]);
  end
  else if fPageType.fType = ptQuery then
  begin
    fPageType.fIndex := fPageType.fIndex -1;
    myPageIndex := fPageType.fIndex;
    mywhere := fPageType.fWhereStr;
    LoadBugItem(myPageindex,myWhere);
    lbPageCount.Caption := format('%d/%d',[
      fPageType.fIndex,
      fPageType.fIndexCount]);
    lbProjectName.Caption := format('%s  =>��%d��%dҳ',[
      fPageType.fName,fPageType.fIndex,fPageType.fIndexCount]);
  end
  else begin
    mydata := tvProject.Selected.data;
    mydata^.fPageIndex := mydata^.fPageIndex - 1;
    myPageIndex := myData^.fPageIndex;
    mywhere := 'ZTREE_ID=' + inttostr(myData^.fID);
    LoadBugItem(myPageindex,myWhere);
    lbPageCount.Caption := format('%d/%d',[
      myData^.fPageIndex,
      myData^.fPageCount]);
    lbProjectName.Caption := format('%s  =>��%d��%dҳ',[
      myData^.fName,myData^.fPageIndex,myData^.fPageCount]);
  end;
end;

function TBugManageDlg.GetBugItemPageCount(APageIndex: integer;
  AWhereStr: String): integer;
var
  mySQL  : string;
  myRowCount : integer;
  mywhere : string;
const
  glSQL = 'exec pt_SplitPage ''TB_BUG_ITEM'',' +
          '''ZID,' +
         'ZRESOLUTION,ZRESOLVEDDATE'', ''%s'',20,%d,%d,1,''%s''';
  //                                             ҳ��,������=1, ����where
begin
  mywhere := AWhereStr;

  if cbSort.ItemIndex = 0 then  //���������
    mySQL := format(glSQL,[
      'ZID',
      APageIndex,
      1, //����ȡ����
      mywhere])
  else
    mySQL := format(glSQL,[
      'ZLASTEDITEDDATE',
      APageIndex,
      1, //����ȡ����
      mywhere]);

  myRowCount := ClientSystem.fDbOpr.ReadInt(PChar(mySQL));
  Result := myRowCount div 20;
  if (myRowCount mod 20) > 0 then
    Result := Result + 1;

end;


procedure TBugManageDlg.actBug_FirstPageUpdate(Sender: TObject);
begin
  if fPageType.fType in [ptMe,ptQuery] then
  begin
    (sender as TAction).Enabled := not fLoading
    and (fPageType.fIndex<>1);
  end
  else begin
    (sender as TAction).Enabled := not fLoading
    and Assigned(tvProject.Selected)
    and Assigned(tvProject.Selected.data)
    and (PBugTreeNode(tvProject.Selected.data)^.fPageIndex<>1);
  end;
end;

procedure TBugManageDlg.actBug_FirstPageExecute(Sender: TObject);
var
  myPageIndex:integer;
  mywhere : String;
  myData : PBugTreeNode;
begin
  if fLoading then Exit;
  if fPageType.fType = ptMe then
  begin
    fPageType.fIndex := 1;
    myPageIndex := 1;
    mywhere := Format(fPageType.fWhereStr,[ClientSystem.fEditer_id]);
    LoadBugItem(myPageindex,myWhere);
    lbPageCount.Caption := format('%d/%d',[
      1,
      fPageType.fIndexCount]);
    lbProjectName.Caption := format('%s  =>��%d��%dҳ',[
      fPageType.fName,fPageType.fIndex,fPageType.fIndexCount]);
  end
  else if fPageType.fType = ptQuery then
  begin
    fPageType.fIndex := 1;
    myPageIndex := 1;
    mywhere := fPageType.fWhereStr;
    LoadBugItem(myPageindex,myWhere);
    lbPageCount.Caption := format('%d/%d',[
      1,
      fPageType.fIndexCount]);
    lbProjectName.Caption := format('%s  =>��%d��%dҳ',[
      fPageType.fName,fPageType.fIndex,fPageType.fIndexCount]);
  end
  else begin
    mydata := tvProject.Selected.data;
    mydata^.fPageIndex := 1;
    myPageIndex := myData^.fPageIndex;
    mywhere := 'ZTREE_ID=' + inttostr(myData^.fID);
    LoadBugItem(myPageindex,myWhere);
    lbPageCount.Caption := format('%d/%d',[
      myData^.fPageIndex,
      myData^.fPageCount]);
    lbProjectName.Caption := format('%s  =>��%d��%dҳ',[
      myData^.fName,myData^.fPageIndex,myData^.fPageCount]);
  end;
end;

procedure TBugManageDlg.actBug_LastPageUpdate(Sender: TObject);
begin
  if fPageType.fType in [ptMe,ptQuery] then
  begin
    (sender as TAction).Enabled := not fLoading
    and (fPageType.fIndex<>fPageType.fIndexCount);
  end
  else begin
    (sender as TAction).Enabled := not fLoading
    and Assigned(tvProject.Selected)
    and Assigned(tvProject.Selected.data)
    and (PBugTreeNode(tvProject.Selected.data)^.fPageIndex<>
      PBugTreeNode(tvProject.Selected.data).fPageCount);
  end;
end;

procedure TBugManageDlg.actBug_LastPageExecute(Sender: TObject);
var
  myPageIndex:integer;
  mywhere : String;
  myData : PBugTreeNode;
begin
  if fLoading then Exit;
  if fPageType.fType = ptme then
  begin
    fPageType.fIndex := fPageType.fIndexCount;
    myPageIndex := fPageType.fIndex;
    mywhere := Format(fPageType.fWhereStr,[ClientSystem.fEditer_id]);
    LoadBugItem(myPageindex,myWhere);
    lbPageCount.Caption := format('%d/%d',[
      fPageType.fIndex,
      fPageType.fIndexCount]);
    lbProjectName.Caption := format('%s  =>��%d��%dҳ',[
      fPageType.fName,fPageType.fIndex,fPageType.fIndexCount]);
  end
  else if fPageType.fType = ptQuery then
  begin
    fPageType.fIndex := fPageType.fIndexCount;
    myPageIndex := fPageType.fIndex;
    mywhere := fPageType.fWhereStr;
    LoadBugItem(myPageindex,myWhere);
    lbPageCount.Caption := format('%d/%d',[
      fPageType.fIndex,
      fPageType.fIndexCount]);
    lbProjectName.Caption := format('%s  =>��%d��%dҳ',[
      fPageType.fName,fPageType.fIndex,fPageType.fIndexCount]);
  end
  else begin
    mydata := tvProject.Selected.data;
    mydata^.fPageIndex := mydata^.fPageCount;
    myPageIndex := myData^.fPageIndex;
    mywhere := 'ZTREE_ID=' + inttostr(myData^.fID);
    LoadBugItem(myPageindex,myWhere);
    lbPageCount.Caption := format('%d/%d',[
      myData^.fPageIndex,
      myData^.fPageCount]);
    lbProjectName.Caption := format('%s  =>��%d��%dҳ',[
      myData^.fName,myData^.fPageIndex,myData^.fPageCount]);
  end;
end;

procedure TBugManageDlg.pcBugChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  AllowChange := (not cdsBugItem.IsEmpty) or (pcBug.ActivePageIndex = 1);
  if not AllowChange then Exit;

  if pcBug.ActivePageIndex = 0 then
  begin
    if cdsBugItem.FieldByName('ZISNEW').AsBoolean then
    begin
      //LoadBugHistory(-1); //
    end
    else begin
      lbBugCaption.Caption := Format('#%d %s',[cdsBugItem.FieldByName('ZID').AsInteger,
        cdsBugItem.FieldByName('ZTITLE').AsString]);
      LoadBugHistory(cdsBugItem.FieldByName('ZID').Asinteger);
    end;
  end
  else if pcBug.ActivePageIndex = 1 then
  begin
    if (cdsBugItem.State in [dsInsert,dsEdit]) or
       (cdsBugHistory.State in [dsInsert,dsEdit]) then
    begin
      MessageBox(Handle,'�������޸�','��ʾ',MB_ICONERROR+MB_OK);
      AllowChange := False;
      Exit;
    end;
  end;

end;

procedure TBugManageDlg.actBug_AddBugUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := Assigned(tvProject.Selected)
  and Assigned(tvProject.Selected.Data);
end;

procedure TBugManageDlg.cdsBugItemNewRecord(DataSet: TDataSet);
var
  myPath : string;
  myBugData,myPBugData : PBugTreeNode;
begin
  if fLoading then Exit;

  if not Assigned(tvProject.Selected) or
     not Assigned(tvProject.Selected.Data) then Exit;

  myBugData := tvProject.Selected.Data;
  mypath := myBugData^.fName;
  myPBugData := myBugData^.fParent;
  while Assigned(myPBugData) do
  begin
    if myPBugData^.fPRO_ID = myBugData^.fPRO_ID then
      mypath := myPBugData^.fName + '/' + mypath;
    myPBugData := myPBugData^.fParent;
  end;

  DataSet.FieldByName('ZPRO_ID').AsInteger  := myBugData^.fPRO_ID;
  DataSet.FieldByName('ZTREEPATH').AsString := myPath;
  DataSet.FieldByName('ZTREE_ID').AsInteger := myBugData^.fID;
  DataSet.FieldByName('ZSTATUS').AsInteger   := 0; //0=Ҫ�޸ĵ�
  DataSet.FieldByName('ZOPENEDBY').AsInteger := ClientSystem.fEditer_id;
  DataSet.FieldByName('ZOPENEDDATE').AsDateTime := ClientSystem.SysNow;
  DataSet.FieldByName('ZISNEW').AsBoolean := True;
  DataSet.FieldByName('ZRESOLUTION').AsInteger := -1; //�������
  DataSet.FieldByName('ZMAILTO').AsString := Format('%s(%d)',[ClientSystem.fEditer,ClientSystem.fEditer_id]);
  DataSet.FieldByName('ZDEMAND_ID').AsInteger := -1;
  DataSet.FieldByName('ZNEDDDATE').AsDateTime := ClientSystem.fDbOpr.GetSysDateTime;
end;

procedure TBugManageDlg.actBug_AddBugExecute(Sender: TObject);
var
  myBugData : PBugTreeNode;
begin
  myBugData := tvProject.Selected.data;

  //Ȩ��
  if not HasModuleActionByShow(Ord(bsBugTree),myBugData.fID,atInsert) then
    Exit;

  lbBugCaption.Caption := '���������� by ' + ClientSystem.fEditer;
  pcBug.ActivePageIndex := 1;
  pcBugChange(nil);
  if cdsBugItem.State in [dsEdit,dsInsert] then
    cdsBugItem.Post;
  LoadBugHistory(-1); //��ΪOnpageChangeû�д���
  cdsBugItem.First;
  cdsBugItem.Insert;
end;

procedure TBugManageDlg.actBugItem_SaveUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := Assigned(tvProject.Selected)
  and Assigned(tvProject.Selected.data)
  and (cdsBugItem.State in [dsEdit,dsInsert]);
end;

procedure TBugManageDlg.actBugItem_CancelUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := Assigned(tvProject.Selected)
  and Assigned(tvProject.Selected.data)
  and (cdsBugItem.State in [dsEdit,dsInsert]);
end;

procedure TBugManageDlg.actBugItem_CancelExecute(Sender: TObject);
begin
  cdsBugItem.Cancel;
end;

procedure TBugManageDlg.cdsBugItemBeforePost(DataSet: TDataSet);
var
  mySQL : String;
  myZID : integer;
  myBugData : PBugTreeNode;
  myAssingdate : string; //ָ�ɵ�ʱ�䣬����û��ָ�ɣ�����null
  myform : TActivationDlg;
const
  glSQL   = 'select isNull(max(ZID),0)+1 from TB_BUG_ITEM';
  glSQL2  = 'insert TB_BUG_ITEM (ZID,ZTREE_ID,ZPRO_ID,ZTREEPATH,ZTITLE,' +
             ' ZOS,ZTYPE,ZLEVEL,ZSTATUS,ZMAILTO,ZOPENEDBY, ' +
             ' ZOPENEDDATE,ZOPENVER,ZASSIGNEDTO,ZASSIGNEDDATE,ZRESOLUTION,' +
             ' ZLASTEDITEDBY,ZLASTEDITEDDATE,ZTAGNAME,ZDEMAND_ID,ZNEDDDATE) ' +
             'values(%d,%d,%d,''%s'',''%s'',%d,%d,%d,%d,''%s'',%d,' +
             ' %s,%d,%d,%s,%d,%d,%s,''%s'',%d,''%s'')' ;

  glSQL3  = 'update TB_BUG_ITEM set ' +
            'ZTITLE=''%s'', ' +
            'ZOS=%d, ' +
            'ZTYPE=%d ,' +
            'ZLEVEL=%d, ' +
            'ZMAILTO=''%s'','+
            'ZOPENVER=%d, ' +
            'ZASSIGNEDTO=%d, '+
            'ZASSIGNEDDATE=%s, '+
            'ZLASTEDITEDBY=%d , ' +
            'ZLASTEDITEDDATE=getdate(),' +
            'ZDEMAND_ID=%d, '  +
            'ZTAGNAME=''%s'', ' +
            'ZNEDDDATE=''%s'', ' +
            'ZVERIFYDATE=''%s'', ' +
            'ZVERIFYED=%d ,' +
            'ZVERIFNAME=%d ' +
            'where ZID=%d';
begin
  //
  if fLoading then Exit;

  myBugData := tvProject.Selected.data;
  if not DataSet.FieldByName('ZISNEW').AsBoolean then
  begin
    if DataSet.FieldByName('ZASSIGNEDTO').AsInteger >=0 then
      myAssingdate := 'getdate()'
    else
      myAssingdate := 'NULL';
    mySQL := format(glSQL3,[
      DataSet.FieldByName('ZTITLE').AsString,
      DataSet.FieldByName('ZOS').AsInteger,
      DataSet.FieldByName('ZTYPE').AsInteger,
      DataSet.FieldByName('ZLEVEL').AsInteger,
      DataSet.FieldByName('ZMAILTO').AsString,
      DataSet.FieldByName('ZOPENVER').AsInteger,
      DataSet.FieldByName('ZASSIGNEDTO').AsInteger,
      myAssingdate,
      ClientSystem.fEditer_id,
      DataSet.FieldByName('ZDEMAND_ID').AsInteger,
      DataSet.FieldByName('ZTAGNAME').AsString,
      //Ҫ������
      DateToStr(StrToDateDef(DataSet.FieldByName('ZNEDDDATE').AsString,StrToDate('2008-1-1'))),
      DateToStr(StrToDateDef(DataSet.FieldByName('ZVERIFYDATE').AsString,StrToDate('2008-1-1'))),
      Ord(DataSet.FieldByName('ZVERIFYED').AsBoolean),
      DataSet.FieldByName('ZVERIFNAME').AsInteger,
      DataSet.FieldByName('ZID').AsInteger]);

    ClientSystem.fDbOpr.BeginTrans;
    try
      ClientSystem.fDbOpr.ExeSQL(PChar(mySQL));

      //�Ǽ���ʱ 2009-11-04
      if DataSet.FieldByName('ZSTATUS').AsInteger = Ord(bgsReAction) then
      begin
        myform := TActivationDlg.Create(nil);
        try
          myform.edtID.Text := IntToStr(cdsBugItem.FieldByName('ZID').AsInteger);
          myform.edtName.Text := DataSet.FieldByName('ZTITLE').AsString;
          if myform.ShowModal = mrok then
          begin
            myform.fType := 1;
            if  DataSet.FieldByName('ZRESOLVEDBY').AsInteger = -1 then
              myform.fAcivate_UserID := fZRESOLVEDBY
            else
              myform.fAcivate_UserID := DataSet.FieldByName('ZRESOLVEDBY').AsInteger;
            myform.PostData;
          end;
        finally
          myform.Free;
        end;
      end;

      ClientSystem.fDbOpr.CommitTrans;
    except
      ClientSystem.fDbOpr.RollbackTrans;
    end;
  end
  else begin   //�½�
    myZID := ClientSystem.fDbOpr.ReadInt(PChar(glSQL));
    if DataSet.FieldByName('ZASSIGNEDTO').AsInteger >=0 then
      myAssingdate := 'getdate()'
    else
      myAssingdate := 'NULL';

    mySQL := Format(glSQL2,[myZID,
      myBugData^.fID,
      myBugData^.fPRO_ID,
      DataSet.FieldByName('ZTREEPATH').AsString,
      DataSet.FieldByName('ZTITLE').AsString,
      DataSet.FieldByName('ZOS').AsInteger,
      DataSet.FieldByName('ZTYPE').AsInteger,
      DataSet.FieldByName('ZLEVEL').AsInteger,
      DataSet.FieldByName('ZSTATUS').AsInteger,
      DataSet.FieldByName('ZMAILTO').AsString,
      DataSet.FieldByName('ZOPENEDBY').AsInteger,
      'getdate()',
      DataSet.FieldByName('ZOPENVER').AsInteger,
      DataSet.FieldByName('ZASSIGNEDTO').AsInteger,  //ָ�ɸ�
      myAssingdate, //ָ��ʱ��
      DataSet.FieldByName('ZRESOLUTION').AsInteger,
      DataSet.FieldByName('ZOPENEDBY').AsInteger,
      'getdate()',
      DataSet.FieldByName('ZTAGNAME').AsString,
      DataSet.FieldByName('ZDEMAND_ID').AsInteger,
      DateToStr(StrToDateDef(DataSet.FieldByName('ZNEDDDATE').AsString,StrToDate('2008-1-1')))]);

    ClientSystem.fDbOpr.BeginTrans;
    try
      ClientSystem.fDbOpr.ExeSQL(PChar(mySQL));
      DataSet.FieldByName('ZID').AsInteger := myZID;
      DataSet.FieldByName('ZISNEW').AsBoolean := False;

      ClientSystem.fDbOpr.CommitTrans;
      //�ʼ�֪ͨ
      ShowProgress('�ʼ�֪ͨ...',0);
      try
        Application.ProcessMessages;
        Mailto(DataSet.FieldByName('ZMAILTO').AsString);
      finally
        HideProgress();
      end;
    except
      ClientSystem.fDbOpr.RollbackTrans;
    end;

  end;
end;

procedure TBugManageDlg.actBugItem_SaveExecute(Sender: TObject);
begin
  cdsBugItem.Post;
end;

procedure TBugManageDlg.actBugHistory_AddExecute(Sender: TObject);
var
  myfilename : string;
begin
  cdsBugHistory.DisableControls;
  try
    cdsBugHistory.Append; //����
    cdsBugHistory.FieldByName('ZSTATUS').AsInteger := Ord(bgsAction);
    with TBugAeplyDlg.Create(nil) do
    try
      dblcQustionType.Enabled := False;
      dblcQustionVer.Enabled  := False;
      if ShowModal <> mrOK then
      begin
        cdsBugHistory.EnableControls;
        cdsBugHistory.Cancel;
        cdsBugHistory.DisableControls;
        Exit;
      end;
      myfilename := edPath.Text;
      cdsBugHistory.FieldByName('ZFILEPATH').AsString := myfilename;
    finally
      free;
    end;
  finally
    cdsBugHistory.EnableControls;
  end;
end;

procedure TBugManageDlg.actBugHistory_AddUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled :=
    not cdsBugItem.FieldByName('ZISNEW').AsBoolean
    and not (cdsBugHistory.State in [dsEdit,dsInsert]);
end;

procedure TBugManageDlg.tvProjectChanging(Sender: TObject; Node: TTreeNode;
  var AllowChange: Boolean);
begin
  if not Assigned(Node.data) then
  begin
    AllowChange := False;
    Exit;
  end;
  AllowChange := True;
end;

procedure TBugManageDlg.actBugHistory_ResoluUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled :=
    not cdsBugItem.FieldByName('ZISNEW').AsBoolean and
    (cdsBugItem.FieldByName('ZSTATUS').AsInteger in [Ord(bgsAction),Ord(bgsReAction)])
    and not (cdsBugHistory.State in [dsEdit,dsInsert]);
end;

procedure TBugManageDlg.actBugHistory_ReSetUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled :=
    not cdsBugItem.FieldByName('ZISNEW').AsBoolean and
    (cdsBugItem.FieldByName('ZSTATUS').AsInteger = Ord(bgsDeath))
    and not (cdsBugHistory.State in [dsEdit,dsInsert]);
end;

procedure TBugManageDlg.actBugHistory_ResoluExecute(Sender: TObject);
var
  myRecNo : integer;
begin
  cdsBugHistory.DisableControls;
  try
    myRecNo := cdsBugHistory.RecNo;
    cdsBugHistory.Append; //����
    cdsBugHistory.FieldByName('ZSTATUS').AsInteger := Ord(bgsDeath);
    with TBugAeplyDlg.Create(nil) do
    try
      if ShowModal <> mrOK then
      begin
        cdsBugHistory.EnableControls;
        cdsBugHistory.Cancel;
        cdsBugHistory.DisableControls;
        cdsBugHistory.RecNo := myRecNo;
        Exit;
      end;
      cdsBugHistory.FieldByName('ZFILEPATH').AsString := edPath.Text;
    finally
      free;
    end;
  finally
    cdsBugHistory.EnableControls;
  end;
end;

procedure TBugManageDlg.actBugHistory_SaveUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := (cdsBugHistory.State in [dsEdit,
    dsInsert])
  and not cdsBugItem.FieldByName('ZISNEW').AsBoolean;
end;

procedure TBugManageDlg.actBugHistory_SaveExecute(Sender: TObject);
begin
  cdsBugHistory.Post;
end;

procedure TBugManageDlg.actBugHistory_CancelUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := cdsBugHistory.State in [dsEdit,
    dsInsert];
end;

procedure TBugManageDlg.actBugHistory_CancelExecute(Sender: TObject);
begin
  if MessageBox(Handle,'���ǳ�����Ļظ�?','ѯ��',
    MB_ICONQUESTION+MB_YESNO)=IDNO then
    Exit;
  cdsBugHistory.Cancel;
end;

procedure TBugManageDlg.LoadBugHistory(ABugID: integer);
var
  mySQL : String;
  mycds : TClientDataSet;
  myfield : TFieldDef;
  i : integer;
  c : integer;
  myb : Boolean;
const
  glSQL  = 'select * from  TB_BUG_HISTORY where ZBUG_ID=%d Order by ZID';
begin
  //����ṹ
  mycds := TClientDataSet.Create(nil);
  myb := fLoading;
  fLoading := True;
  try

    mySQL := format(glSQL,[ABugID]);
    mycds.Data := ClientSystem.fDbOpr.ReadDataSet(PChar(mySQL));

    if cdsBugHistory.Fields.Count = 0 then
    begin
      with cdsBugHistory do
      begin
        FieldDefs.Assign(mycds.FieldDefs);
        myfield := FieldDefs.AddFieldDef;
        myfield.Name :='ZNO';
        myfield.DataType := ftInteger;
        myfield := FieldDefs.AddFieldDef;
        myfield.Name :='ZISNEW';
        myfield.DataType := ftBoolean;

        myfield := FieldDefs.AddFieldDef;
        myfield.Name :='ZFILEPATH';
        myfield.DataType := ftString;
        myfield.Size := 100; //������·��

        myfield := FieldDefs.AddFieldDef;
        myfield.Name :='ZFILESAVE';
        myfield.DataType := ftString;
        myfield.Size := 10; //���Ϊ



        //��Ϊ ZIDֻ�������⣬����ȥ�� ,�����Զ�����ȥ��
        for i:=0 to FieldDefs.Count -1 do
        begin
          if faReadonly in FieldDefs[i].Attributes then
            FieldDefs[i].Attributes := FieldDefs[i].Attributes - [faReadonly];
          if FieldDefs[i].DataType = ftAutoInc then
            FieldDefs[i].DataType := ftInteger;
        end;
        for i:=0 to FieldDefs.Count -1 do
          FieldDefs[i].CreateField(cdsBugHistory);

        //�ظ���
        myfield := FieldDefs.AddFieldDef;
        myfield.Name :='ZUSERNAME';
        myfield.DataType := ftString;
        myfield.Size := 50;
        with myfield.CreateField(cdsBugHistory) do
        begin
          FieldKind := fkLookup;
          KeyFields := 'ZUSER_ID';
          LookupDataSet := DM.cdsUser;
          LookupKeyFields := 'ZID';
          LookupResultField := 'ZNAME';
        end;

        myfield := FieldDefs.AddFieldDef;
        myfield.Name :='ZSTATUSNAME';
        myfield.DataType := ftString;
        myfield.Size := 50;
        with myfield.CreateField(cdsBugHistory) do
        begin
          FieldKind := fkLookup;
          KeyFields := 'ZSTATUS';
          LookupDataSet := cdsBugStatus;
          LookupKeyFields := 'ZID';
          LookupResultField := 'ZNAME';
        end;

      end;

      cdsBugHistory.CreateDataSet;
    end
    else begin
      cdsBugHistory.DisableControls;
      try
        while not cdsBugHistory.IsEmpty do cdsBugHistory.Delete;
      finally
        cdsBugHistory.EnableControls;
      end;
    end;

    //дֵ
    cdsBugHistory.DisableControls;
    try
      mycds.First;
      c := 1;
      while not mycds.Eof do
      begin
        cdsBugHistory.Append;
        cdsBugHistory.FieldByName('ZISNEW').AsBoolean := False;
        cdsBugHistory.FieldByName('ZNO').AsInteger := c; inc(c);
        for i:=0 to mycds.FieldDefs.Count -1 do
          cdsBugHistory.FieldByName(mycds.FieldDefs[i].Name).AsVariant :=
            mycds.FieldByName(mycds.FieldDefs[i].Name).AsVariant;

        if cdsBugHistory.FieldByName('ZANNEXFILENAME').AsString <> '' then
          cdsBugHistory.FieldByName('ZFILESAVE').AsString := '���Ϊ...';
        cdsBugHistory.Post;
        mycds.Next;
      end;
      //cdsBugHistory.Last;  //��λ�����
    finally
      cdsBugHistory.EnableControls;
    end;

  finally
    mycds.Free;
    fLoading := myb;
  end;
end;

procedure TBugManageDlg.actBugHistory_ReSetExecute(Sender: TObject);
var
  myRecNO : integer;
begin
  if MessageBox(Handle,'���ǲ���Ҫ����������,���������������⴦������ϵ.',
    '��������',MB_ICONQUESTION+MB_YESNO)=IDNO then Exit;

  cdsBugHistory.DisableControls;
  try
    myRecNo := cdsBugHistory.RecNo;
    cdsBugHistory.Append;
    cdsBugHistory.FieldByName('ZSTATUS').AsInteger := Ord(bgsReAction);
    with TBugAeplyDlg.Create(nil) do
    try
      dblcQustionType.Enabled := False;
      dblcQustionVer.Enabled  := False;
      if ShowModal <> mrOK then
      begin
        cdsBugHistory.EnableControls;
        cdsBugHistory.Cancel;
        cdsBugHistory.DisableControls;
        cdsBugHistory.RecNo := myRecNo;
        Exit;
      end;
      cdsBugHistory.FieldByName('ZFILEPATH').AsString := edPath.Text;
    finally
      free;
    end;
  finally
    cdsBugHistory.EnableControls;
  end;
end;

procedure TBugManageDlg.cdsBugHistoryNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('ZISNEW').AsBoolean  := True;
  DataSet.FieldByName('ZBUG_ID').AsInteger :=
    cdsBugItem.FieldByName('ZID').AsInteger;
  DataSet.FieldByName('ZUSER_ID').AsInteger := ClientSystem.fEditer_id;
  DataSet.FieldByName('ZACTIONDATE').AsDateTime := ClientSystem.SysNow;
  DataSet.FieldByName('ZSTATUS').AsInteger := -1;
  DataSet.FieldByName('ZNO').AsInteger := DataSet.RecordCount+1;
end;

procedure TBugManageDlg.cdsBugHistoryBeforePost(DataSet: TDataSet);
var
  myFileName : String;
  myFileID : integer;
  mySQL : string;
  myProID : integer;
  mymailstr : string;
  myeditid : Integer;  //�����,�����ǻظ���,���ǽ����
const
  glSQL  =  'insert TB_BUG_HISTORY (ZBUG_ID,ZUSER_ID,ZSTATUS,ZCONTEXT,' +
            'ZACTIONDATE,ZANNEXFILE_ID,ZANNEXFILENAME) ' +
            'values(%d,%d,%d,''%s'',getdate(),%d,''%s'')';
  glSQL2 = 'update TB_BUG_HISTORY set ZCONTEXT=''%s'',ZACTIONDATE=getdate() '+
           'where ZID=%d';

  glSQL3 = 'update TB_BUG_ITEM set ZLASTEDITEDBY=%d,ZLASTEDITEDDATE=getdate(), '+
           'ZSTATUS=%d,ZRESOLVEDBY=%d,ZRESOLUTION=%d,ZRESOLVEDVER=%d, ' +
           'ZRESOLVEDDATE=getdate(),ZMAILTO=''%s''' +
           'where ZID=%d';
begin
  if fLoading then Exit;
  //ֻ���޸�����,����Ƚ���
  if not DataSet.FieldByName('ZISNEW').AsBoolean then
  begin
    if DataSet.FieldByName('ZUSER_ID').AsInteger <> ClientSystem.fEditer_id then
    begin
      MessageBox(Handle,'������Ļظ����ݣ����ܱ༭��',
        '��ʾ',MB_ICONWARNING+MB_OK);
      Exit;
    end;
    mySQL := format(glSQL2,[
      DataSet.FieldByName('ZCONTEXT').AsString,
      DataSet.FieldByName('ZID').AsInteger]);

    ClientSystem.fDbOpr.BeginTrans;
    ShowProgress('����...',0);
    try
      try
        ClientSystem.fDbOpr.ExeSQL(PChar(mySQL));
        mySQL := format(glSQL3,[
          DataSet.FieldByName('ZUSER_ID').Asinteger,
          DataSet.FieldByName('ZSTATUS').Asinteger,
          cdsBugItem.FieldByName('ZRESOLVEDBY').Asinteger,
          cdsBugItem.FieldByName('ZRESOLUTION').Asinteger,
          cdsBugItem.FieldByName('ZRESOLVEDVER').Asinteger,
          cdsBugItem.FieldByName('ZMAILTO').AsString,
          DataSet.FieldByName('ZBUG_ID').Asinteger]);

        ClientSystem.fDbOpr.ExeSQL(PChar(mySQL));
        ClientSystem.fDbOpr.CommitTrans;
      except
        ClientSystem.fDbOpr.RollbackTrans;
      end;
    finally
      HideProgress;
    end;
  end
  //�����ظ�
  else begin
    if DataSet.FieldByName('ZSTATUS').AsInteger < 0 then
    begin
      with TSelectBugStatusDlg.Create(nil) do
      try
        if ShowModal <> mrOk then  Exit;
        if rbAdd.Checked then
          DataSet.FieldByName('ZSTATUS').AsInteger := Ord(bgsAction)
        else if rbMeReso.Checked then
          DataSet.FieldByName('ZSTATUS').AsInteger := Ord(bgsDeath)
        else Exit;
      finally
        free;
      end;
    end;

    ClientSystem.fDbOpr.BeginTrans;
    try
      ShowProgress('����...',4);
      try
      myFileID := -1;
      UpdateProgressTitle('�ϴ��ļ�...');
      UpdateProgress(1);
      //Ҫ�ϴ������ļ�,��������ϴ�
      if FileExists(DataSet.FieldByName('ZFILEPATH').AsString) then
      begin
        myFileName := DataSet.FieldByName('ZFILEPATH').AsString;
        //ȡ���ļ���С̫����ļ������ϴ�
        if not ClientSystem.AllowFileSize(myfilename) then
        begin
          MessageBox(Handle,'�ļ�̫��ֻ���ϴ�500KB���ļ���',
            '��ʾ',MB_ICONWARNING+MB_OK);
          ClientSystem.fDbOpr.RollbackTrans;
          Exit;
        end;

        myProID := cdsBugItem.FieldByName('ZPRO_ID').Asinteger;
        if not UpBugFile(myProID,myFileName,myFileID) then
        begin
          MessageBox(Handle,'�ϴ����������⡣','��ʾ',MB_ICONERROR+MB_OK);
          ClientSystem.fDbOpr.RollbackTrans;
          Exit;
        end;
        DataSet.FieldByName('ZANNEXFILENAME').AsString :=ExtractFileName(myfileName);
        DataSet.FieldByName('ZANNEXFILE_ID').AsInteger := myFileID;
      end;


      UpdateProgressTitle('����ظ�...');
      UpdateProgress(2);
      mySQL := format(glSQL,[
        DataSet.FieldByName('ZBUG_ID').AsInteger,
        DataSet.FieldByName('ZUSER_ID').AsInteger,
        DataSet.FieldByName('ZSTATUS').AsInteger,
        DataSet.FieldByName('ZCONTEXT').AsString,
        //DataSet.FieldByName('ZACTIONDATE').AsString, //������getdate();
        DataSet.FieldByName('ZANNEXFILE_ID').AsInteger,
        DataSet.FieldByName('ZANNEXFILENAME').AsString]);


      ClientSystem.fDbOpr.ExeSQL(PChar(mySQL));
      //��û�м������˵�����,���Զ�������
      if DataSet.FieldByName('ZSTATUS').AsInteger = Ord(bgsDeath) then
        myeditid := cdsBugItem.FieldByName('ZRESOLVEDBY').AsInteger
      else
        myeditid := DataSet.FieldByName('ZUSER_ID').AsInteger;
      if DM.cdsUser.Locate('ZID',myeditid,[loPartialKey]) then
      begin
        mymailstr := Format('%s(%d)',[DM.cdsUser.FieldByName('ZNAME').AsString,
          DM.cdsUser.FieldByName('ZID').AsInteger]);
        if Pos(mymailstr,cdsBugItem.FieldByName('ZMAILTO').AsString)=0 then
        begin
          if not (cdsBugItem.State in [dsEdit,dsInsert]) then
            cdsBugItem.Edit;
          cdsBugItem.FieldByName('ZMAILTO').AsString :=
            cdsBugItem.FieldByName('ZMAILTO').AsString + ';' + mymailstr;
          //cdsBugItem.Post; //��ط�������
        end;
      end;

      if DataSet.FieldByName('ZSTATUS').AsInteger = Ord(bgsDeath) then
      begin

        mySQL := format(glSQL3,[
          DataSet.FieldByName('ZUSER_ID').Asinteger,
          DataSet.FieldByName('ZSTATUS').Asinteger,
          ClientSystem.fEditer_id,
          cdsBugPlan.FieldByName('ZID').AsInteger,
          cdsProject.FieldByName('ZID').AsInteger,
          cdsBugItem.FieldByName('ZMAILTO').AsString,
          DataSet.FieldByName('ZBUG_ID').Asinteger]);

      end
      else begin
        mySQL := format(glSQL3,[
          DataSet.FieldByName('ZUSER_ID').Asinteger,
          DataSet.FieldByName('ZSTATUS').Asinteger,
          -1,
          -1,
          -1,
          cdsBugItem.FieldByName('ZMAILTO').AsString,
          DataSet.FieldByName('ZBUG_ID').Asinteger]);
      end;

      UpdateProgressTitle('������������...');
      UpdateProgress(3);

      ClientSystem.fDbOpr.ExeSQL(PChar(mySQL));
      DataSet.FieldByName('ZISNEW').AsBoolean := False;
      ClientSystem.fDbOpr.CommitTrans;


      //�紦���ˣ������Bug����Ϣ����
      if DataSet.FieldByName('ZSTATUS').AsInteger = Ord(bgsDeath) then
      begin
        if cdsBugItem.State in [dsEdit,dsInsert] then
          cdsBugItem.Post;
        cdsBugItem.Edit;
        cdsBugItem.FieldByName('ZRESOLVEDBY').AsInteger := ClientSystem.fEditer_id;
        cdsBugItem.FieldByName('ZRESOLUTION').AsInteger := cdsBugPlan.FieldByName('ZID').AsInteger;
        cdsBugItem.FieldByName('ZRESOLVEDVER').AsInteger := cdsProject.FieldByName('ZID').AsInteger;
        cdsBugItem.FieldByName('ZRESOLVEDDATE').AsDateTime := ClientSystem.SysNow;
        cdsBugItem.FieldByName('ZSTATUS').asInteger := DataSet.FieldByName('ZSTATUS').Asinteger;
        cdsBugItem.Post;
      end
      else begin
        if cdsBugItem.State in [dsEdit,dsInsert] then
          cdsBugItem.Post;
        cdsBugItem.Edit;
        fZRESOLVEDBY := cdsBugItem.FieldByName('ZRESOLVEDBY').AsInteger;
        cdsBugItem.FieldByName('ZRESOLVEDBY').AsInteger    := -1;
        cdsBugItem.FieldByName('ZRESOLUTION').AsInteger    := -1;
        cdsBugItem.FieldByName('ZRESOLVEDVER').AsInteger   := -1;
        cdsBugItem.FieldByName('ZRESOLVEDDATE').AsVariant  := NULL;
        cdsBugItem.FieldByName('ZSTATUS').asInteger := DataSet.FieldByName('ZSTATUS').Asinteger;
        cdsBugItem.Post;
      end;

      UpdateProgressTitle('�ʼ�֪ͨ...');
      UpdateProgress(4);
      //�ʼ�֪ͨ
      Mailto(cdsBugItem.FieldByName('ZMAILTO').AsString);

      finally HideProgress; end;
    except
      //if myFileID >=0 then  //�����ϴ��˸�������Ҫɾ������
      //  ClientSystem.fdbOpr.DeleteFile(myFileID);
      ClientSystem.fDbOpr.RollbackTrans;
    end;
  end;


end;

procedure TBugManageDlg.actBugHistory_PrivBugUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := (cdsBugItem.State in [dsBrowse])
  and (cdsBugHistory.State in [dsBrowse])
  and not cdsBugItem.Bof;
end;

procedure TBugManageDlg.actBugHistory_NextBugUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := (cdsBugItem.State in [dsBrowse])
  and (cdsBugHistory.State in [dsBrowse])
  and not cdsBugItem.Eof;
end;

procedure TBugManageDlg.actBugHistory_PrivBugExecute(Sender: TObject);
begin
  cdsBugItem.Prior;
  lbBugCaption.Caption := Format('#%d %s',[cdsBugItem.FieldByName('ZID').AsInteger,
    cdsBugItem.FieldByName('ZTITLE').AsString]);
  LoadBugHistory(cdsBugItem.FieldByName('ZID').Asinteger);
end;

procedure TBugManageDlg.actBugHistory_NextBugExecute(Sender: TObject);
begin
  cdsBugItem.Next;
  lbBugCaption.Caption := Format('#%d %s',[cdsBugItem.FieldByName('ZID').AsInteger,
    cdsBugItem.FieldByName('ZTITLE').AsString]);
  LoadBugHistory(cdsBugItem.FieldByName('ZID').Asinteger);
end;

procedure TBugManageDlg.dgBugItemDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var
  mystr : string;
  myfontsize : Integer;
  myfontcolor,mybrushcolor : TColor;
  mywidth,myh : integer;
begin

  if (cdsBugItem.RecNo mod 2  = 0) and not ( gdSelected in State)  then
    dgBugItem.Canvas.Brush.Color := clSilver;

  if (cdsBugItem.FieldByName('ZSTATUS').AsInteger = Ord(bgsDeath)) then
  begin
    dgBugItem.Canvas.Font.Color := clblue;
  end;

  if cdsBugItem.FieldByName('ZVERIFYED').AsBoolean and(Column.Index = Ord(bcTitle)) then
  begin
    dgBugItem.Canvas.Font.Style := [fsBold];
  end;
  
  case Column.Index of
    Ord(bcWhoBuild) :
      if cdsBugItem.FieldByName('ZOPENEDBY').AsInteger =
         ClientSystem.fEditer_id then
      begin
        dgBugItem.Canvas.Brush.Color := clAqua;
      end;
    Ord(bcAssingeto):
      if cdsBugItem.FieldByName('ZASSIGNEDTO').AsInteger =
         ClientSystem.fEditer_id then
      begin
        dgBugItem.Canvas.Brush.Color := clYellow;
      end;
    Ord(bcwhoReso)  :
      if cdsBugItem.FieldByName('ZRESOLVEDBY').AsInteger =
         ClientSystem.fEditer_id then
      begin
        dgBugItem.Canvas.Brush.Color := clLime;
      end;
  end;

  dgBugItem.DefaultDrawColumnCell(Rect,DataCol,Column,State);
  
  if (Column.Index = Ord(bcTitle)) and
     (cdsBugItem.FieldByName('ZTAGNAME').AsString <> '') then
  begin
    dgBugItem.Canvas.FillRect(Rect);
    mystr := cdsBugItem.FieldByName('ZTAGNAME').AsString;
    myfontsize := dgBugItem.Canvas.Font.Size;
    myfontcolor := dgBugItem.Canvas.Font.Color;
    mybrushcolor := dgBugItem.Canvas.Brush.Color;
    dgBugItem.Canvas.Font.Size  := 8;
    dgBugItem.Canvas.Font.Color := clBtnFace;
    dgBugItem.Canvas.Brush.Color := clNavy;
    myh := dgBugItem.Canvas.TextHeight(mystr);
    mywidth := dgBugItem.Canvas.TextWidth(mystr);
    dgBugItem.Canvas.TextOut(Rect.Left+1,
      rect.Top + (rect.Bottom-rect.Top-myh) div 2,mystr);

    dgBugItem.Canvas.Font.Size := myfontsize;
    dgBugItem.Canvas.Font.Color := myfontcolor;
    dgBugItem.Canvas.Brush.Color := mybrushcolor;
    myh := dgBugItem.Canvas.TextHeight('��');
    dgBugItem.Canvas.TextOut(Rect.Left+mywidth+5,
      Rect.Top + (Rect.Bottom-Rect.Top-myh) div 2,
      cdsBugItem.FieldByName('ZTITLE').AsString);

    dgBugItem.Canvas.FrameRect(Rect);
  end;

end;

procedure TBugManageDlg.actBug_MeBuildExecute(Sender: TObject);
var
  myPageIndex:integer;
  mywhere : String;
begin

  try
    fPageType.fType := ptMe;
    fPageType.fWhereStr := 'ZOPENEDBY=%d';
    fPageType.fIndex := 1;
    fPageType.fName := '���Ҵ���';
    myPageIndex := 1;
    mywhere := format(fPageType.fWhereStr{'ZOPENEDBY=%d'},[ClientSystem.fEditer_id]);
    fPageType.fIndexCount := GetBugItemPageCount(myPageindex,myWhere);
    LoadBugItem(myPageindex,myWhere);
    lbPageCount.Caption := format('%d/%d',[
      fPageType.fIndex,
      fPageType.fIndexCount]);
    lbProjectName.Caption := format('%s  =>��%d��%dҳ',[
      fPageType.fName,fPageType.fIndex,fPageType.fIndexCount]);
  finally

  end;
end;

procedure TBugManageDlg.actBug_AssingToMeExecute(Sender: TObject);
var
  myPageIndex:integer;
  mywhere : String;
begin

  try
    fPageType.fType := ptMe;
    fPageType.fWhereStr := 'ZASSIGNEDTO=%d';
    fPageType.fName := 'ָ�ɸ���';
    fPageType.fIndex := 1;
    myPageIndex := 1;
    mywhere := format(fPageType.fWhereStr{'ZASSIGNEDTO=%d'},[ClientSystem.fEditer_id]);
    fPageType.fIndexCount := GetBugItemPageCount(myPageindex,myWhere);
    LoadBugItem(myPageindex,myWhere);
    lbPageCount.Caption := format('%d/%d',[
      fPageType.fIndex,
      fPageType.fIndexCount]);
    lbProjectName.Caption := format('%s  =>��%d��%dҳ',[
      fPageType.fName,fPageType.fIndex,fPageType.fIndexCount]);
  finally

  end;
end;

procedure TBugManageDlg.actBug_ResoMeExecute(Sender: TObject);
var
  myPageIndex:integer;
  mywhere : String;
begin

  try
    fPageType.fType := ptMe;
    fPageType.fWhereStr := 'ZRESOLVEDBY=%d';
    fPageType.fIndex := 1;
    fPageType.fName := '���ҽ��';

    myPageIndex := 1;
    mywhere := format(fPageType.fWhereStr{'ZRESOLVEDBY=%d'},[ClientSystem.fEditer_id]);
    fPageType.fIndexCount:= GetBugItemPageCount(myPageindex,myWhere);
    LoadBugItem(myPageindex,myWhere);
    lbPageCount.Caption := format('%d/%d',[
      fPageType.fIndex,
      fPageType.fIndexCount]);
    lbProjectName.Caption := format('%s  =>��%d��%dҳ',[
      fPageType.fName,fPageType.fIndex,fPageType.fIndexCount]);
  finally

  end;
end;

function TBugManageDlg.UpBugFile(APro_ID:integer;AFileName: String;
  var AFileID: integer): Boolean;
begin
  Result :=ClientSystem.UpFile(fsBug,APro_ID,AFileName,AfileID);
end;

procedure TBugManageDlg.DBText3DblClick(Sender: TObject);
begin
  if actBugHistory_OpenFile.Enabled then
    actBugHistory_OpenFile.Execute;
end;

procedure TBugManageDlg.actBugHistory_OpenFileExecute(Sender: TObject);
var
  myfileid : integer;
  myfilename : string;
  r    : HINST;
begin
  myfileid := cdsBugHistory.FieldByName('ZANNEXFILE_ID').AsInteger;
  myfilename := cdsBugHistory.FieldByName('ZANNEXFILEName').AsString;
  if ClientSystem.DonwFileToFileName(myfileid,myfilename) then
  begin
    //���ļ�
    r:=ShellExecute(Handle,'open',PChar(myfilename),
      nil,PChar(ExtractFileDir(myfilename)),SW_SHOW);

    //���ô򿪷�ʽ�Ի���
    if r =SE_ERR_NOASSOC then//���û�й����Ĵ򿪷�ʽ
      ShellExecute(Handle, 'open', 'Rundll32.exe',
        PChar('shell32.dll,OpenAs_RunDLL ' + myfilename), nil, SW_SHOWNORMAL);
  end;
end;

procedure TBugManageDlg.actBugHistory_OpenFileUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := not cdsBugHistory.IsEmpty
  and (cdsBugHistory.FieldByName('ZANNEXFILE_ID').AsInteger >=0);
end;

procedure TBugManageDlg.actBug_RefreshDataUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := Assigned(tvProject.Selected)
  and Assigned(tvProject.Selected.data);
end;

procedure TBugManageDlg.actBug_RefreshDataExecute(Sender: TObject);
var
  myBugData : PBugTreeNode;
  myPageindex : integer;
  mywhere : String;
begin

  try
    if fPageType.fType = ptMe then
    begin
      myPageindex := fPageType.fIndex;
      mywhere := Format(fPageType.fWhereStr,[ClientSystem.fEditer_id]);
      fPageType.fIndexCount := GetBugItemPageCount(myPageindex,myWhere);
      LoadBugItem(myPageindex,myWhere);
      lbPageCount.Caption := format('%d/%d',[
        fPageType.fIndex,
        fPageType.fIndexCount]);
      lbProjectName.Caption := format('%s  =>��%d��%dҳ',[
        fPageType.fName,fPageType.fIndex,fPageType.fIndexCount]);
    end
    else if fPageType.fType = ptQuery then
    begin
      myPageindex := fPageType.fIndex;
      mywhere := fPageType.fWhereStr;
      fPageType.fIndexCount := GetBugItemPageCount(myPageindex,myWhere);
      LoadBugItem(myPageindex,myWhere);
      lbPageCount.Caption := format('%d/%d',[
        fPageType.fIndex,
        fPageType.fIndexCount]);
      lbProjectName.Caption := format('%s  =>��%d��%dҳ',[
        fPageType.fName,fPageType.fIndex,fPageType.fIndexCount]);
    end
    else begin
      myBugData := tvProject.Selected.data;
      myPageIndex := myBugData^.fPageIndex;
      mywhere := 'ZTREE_ID=' + inttostr(myBugData^.fID);
      myBugData^.fPageCount := GetBugItemPageCount(myPageindex,myWhere);
      LoadBugItem(myPageindex,myWhere);
      lbPageCount.Caption := format('%d/%d',[
        myBugData^.fPageIndex,
        myBugData^.fPageCount]);
      lbProjectName.Caption := format('%s  =>��%d��%dҳ',[
        myBugData^.fName,myBugData^.fPageIndex,myBugData^.fPageCount]);
    end;
  finally

  end;
end;

procedure TBugManageDlg.dblkcbbSelectUsermailCloseUp(Sender: TObject);
var
  mystr : String;
  myaddstr : string;
begin
  if (Sender as TDBLookupComboBox).Text = '' then Exit;

  if cdsBugItem.State in [dsBrowse] then
    cdsBugItem.Edit;

  myaddstr := format('%s(%d)',[
      DM.cdsUser.FieldByName('ZNAME').AsString,
      DM.cdsUser.FieldByName('ZID').AsInteger]);

  myStr := cdsBugItem.FieldByName('ZMAILTO').AsString;
  if mystr <> '' then
  begin
    if Pos(myaddstr,mystr) <= 0 then
      myStr := myStr + ';' + myaddstr;
  end
  else
    myStr := myStr + myaddstr;

  cdsBugItem.FieldByName('ZMAILTO').AsString := myStr;
end;

procedure TBugManageDlg.Mailto(AEmailto: String);
var
  i     : integer;
  mysl  : TStringList;
  myStr : String;
  mysv  : TStringList;
  myMails : TStringList;
  myBugID  : integer; //Bug��IDֵ;
begin
  mysl := TStringList.Create;
  mysv := TStringList.Create;
  myMails := TStringlist.Create;
  try
    myBugID := cdsBugItem.FieldByName('ZID').AsInteger;
    //�ȼ��봴����
    DM.cdsUser.ControlsDisabled;
    try
     
      ClientSystem.SplitStr(AEmailto,mysv,';');
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
              myMails.Add(DM.cdsUser.FieldByName('ZEMAIL').AsString);
              break;
            end;
            DM.cdsUser.Next;
          end;
        end;
      end;

    finally
      DM.cdsUser.EnableControls;
    end;

    //���ýӿڷ���
    mystr := '';
    for i:=0 to myMails.Count -1 do
    begin
      if Trim(myMails[i])='' then Continue;
      if mystr = '' then
        mystr := myMails[i]
      else
        mystr := mystr + ';' + myMails[i];
    end;

    if mystr <> '' then
      ClientSystem.fDbOpr.MailTo(0,myStr,myBugID);
  finally
    mysl.Free;
    mysv.Free;
    myMails.Free;
  end;
end;

procedure TBugManageDlg.actBug_HighQueryExecute(Sender: TObject);
var
  myPageIndex:integer;
  mywhere : String;
const
  glSQL  = 'select ZID,ZNAME,ZPRO_ID from TB_BUG_TREE Order by ZSORT';
begin
  //
  //  ע��ÿ��ģ������Ȩ�޵�,����ÿ���˶�������Ȩ��
  //
  //
  if not Assigned(fHighQuery) then
  begin
    ShowProgress('���Ժ�...',0);
    try
      fHighQuery := TBugHighQueryDlg.Create(nil);
      //�����ݽ��г��ڻ�
      with fHighQuery do
      begin
        cdstemp.Data := ClientSystem.fDbOpr.ReadDataSet(PChar(glSQL));
        cdstemp.First;
        while not cdstemp.Eof do
        begin
          //Ȩ��
          if not HasModuleAction(Ord(bsBugTree),
            cdstemp.FieldByName('ZID').AsInteger,atView) then
          begin
            cdstemp.Next;
            Continue;
          end;

          cbbModule.Items.Add(cdstemp.FieldByName('ZNAME').AsString);
          cbbModuleID.Items.Add(cdstemp.FieldByName('ZPRO_ID').AsString);
          cbbTreeID.Items.Add(cdstemp.FieldByName('ZID').AsString);
          cdstemp.Next;
        end;
        dtpAmod.DateTime   := now();
        dtpBugday.DateTime := now();
        dtpAmod2.DateTime   := now();
        dtpBugday2.DateTime := now();
        dtpNeed.DateTime := Now();
        dtpNeed2.DateTime := Now();
        cdsBugCreater.CloneCursor(DM.cdsUser,True);
        cdsBugAdmder.CloneCursor(DM.cdsUser,True);
        cdsToWho.CloneCursor(DM.cdsUser,True);
        cbbTag.Items.Clear;
        DM.cdsTag.First;
        while not DM.cdsTag.Eof do
        begin
          cbbTag.Items.Add(DM.cdsTag.FieldByName('ZNAME').AsString);
          DM.cdsTag.Next;
        end;
        GetBugType();
      end;
    finally
      HideProgress;
    end;
  end;
  with fHighQuery  do
  begin
    edtCode.SelectAll;
    if ShowModal=mrOK then
    begin
      fHighQuery.Hide;
      Application.ProcessMessages;
      try
        mywhere := GetwhereStr();
        fPageType.fType := ptQuery;
        fPageType.fWhereStr := mywhere;
        fPageType.fIndex := 1;
        fPageType.fName := '�߼���ѯ';
        myPageIndex := 1;
        fPageType.fIndexCount := GetBugItemPageCount(1,myWhere);
        LoadBugItem(myPageindex,myWhere);
        lbPageCount.Caption := format('%d/%d',[
          fPageType.fIndex,
          fPageType.fIndexCount]);
        lbProjectName.Caption := format('%s  =>��%d��%dҳ',[
        fPageType.fName,fPageType.fIndex,fPageType.fIndexCount]);
      finally

      end;
    end;

  end;
end;

procedure TBugManageDlg.freeBase;
begin
  inherited;
  if Assigned(fHighQuery) then
    fHighQuery.Free;
end;

procedure TBugManageDlg.actBug_MovetoExecute(Sender: TObject);
var
  myid : integer;
  myDirId : integer;
  mystr : string;
  mySQL : string;
const
  glSQL1 = 'select ZPRO_ID,ZNAME from TB_BUG_TREE where ZID=%d';
  glSQL2 = 'update TB_BUG_ITEM set ZTREE_ID=%d,ZPRO_ID=%d,ZTREEPATH=''%s'' where ZID=%d';
begin
  //
  // Ȩ��,ֻ�д�����,�ɹ�����Ա�����ƶ�
  // �������Ա�����ƶ�
  //
  if not (ClientSystem.fEditerType in [etAdmin,etTest]) and
     (cdsBugItem.FieldByName('ZOPENEDBY').AsInteger<>ClientSystem.fEditer_id) then
  begin
    MessageBox(Handle,'ֻ������Ĵ����˻�����˲����ƶ�����','��ʾ',MB_ICONWARNING+MB_OK);
    Exit;
  end;

  myDirId := cdsBugItem.FieldByName('ZTREE_ID').AsInteger;
  mystr := InputBox('�����µķֲ���','�ֲ���:',inttostr(myDirId));

  if strtointdef(mystr,myDirID) <> myDirID then
  begin
    myDirID := strtointdef(mystr,myDirID);
    //ȷ����û�����ID��
    cdstemp.data := ClientSystem.fDbOpr.ReadDataSet(PChar(format(glSQL1,[myDirID])));
    if cdstemp.RecordCount = 0 then
    begin
      MessageBox(Handle,'��ķֲ��Ų�����','��ʾ',MB_ICONWARNING+MB_OK);
      Exit;
    end;
    myid := cdsBugItem.FieldByName('ZID').AsInteger;
    mySQL := format(glSQL2,[myDirID,
      cdstemp.FieldByName('ZPRO_ID').AsInteger ,
      cdstemp.FieldByName('ZNAME').AsString, myid]);
    ClientSystem.fDbOpr.ExeSQL(PChar(mySQL));
    cdsBugItem.Delete; //��ȥ��ǰ��
  end;

end;

procedure TBugManageDlg.actBug_MovetoUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := cdsBugItem.Active and
    (cdsBugItem.RecordCount > 0)
end;

procedure TBugManageDlg.pcBugChange(Sender: TObject);
var
  mySQL : string;
const
  glSQL  = 'select ZID,ZVER from TB_PRO_VERSION where ZPRO_ID=%d Order by ZID DESC';
begin
  //��ȡ��Ŀ
  if pcBug.ActivePageIndex = 1 then
  begin
    if cdsProject.Tag <> cdsBugItem.FieldByName('ZPRO_ID').AsInteger then
    begin
      cdsProject.Tag := cdsBugItem.FieldByName('ZPRO_ID').AsInteger;
      mySQL := format(glSQL,[cdsBugItem.FieldByName('ZPRO_ID').AsInteger]);
      cdsProject.Data := ClientSystem.fDbOpr.ReadDataSet(PChar(mySQL));
    end;
  end;
end;

procedure TBugManageDlg.lblSavetofileClick(Sender: TObject);
begin
  actBugHistory_Savetofile.Execute;
end;

procedure TBugManageDlg.actBugHistory_SavetofileExecute(Sender: TObject);
var
  myfileid : integer;
  myfilename : string;
  myname : string;
  myver : integer;
const
  glSQL  = 'select isnull(max(ZVER),-1) from  TB_FILE_ITEM where ZID=%d';
begin
  myfileid   := cdsBugHistory.FieldByName('ZANNEXFILE_ID').AsInteger;
  myfilename := cdsBugHistory.FieldByName('ZANNEXFILEName').AsString;
  dlgSave1.FileName := myfilename;
  if Pos('.',myfilename) > 0 then
    dlgSave1.DefaultExt := Copy(myfilename,Pos('.',myfilename)+1,Maxint);

  if dlgSave1.Execute then
  begin
    Application.ProcessMessages;
    myver := ClientSystem.fDbOpr.ReadInt(PChar(Format(glSQL,[myfileid])));
    if myver < 0 then
    begin
      MessageBox(Handle,'�ļ��ڷ������Ѳ�����,����ļ�ʧ��','��ʾ',MB_ICONERROR+MB_OK);
      Exit;
    end;

    myname := dlgSave1.FileName;
    if ClientSystem.DonwFileToFileName(myfileid,myver,myname) then
    begin
      ShowMessage('����ļ��ɹ�')
    end
    else
      MessageBox(Handle,'����ļ�ʧ��','��ʾ',MB_ICONERROR+MB_OK);
  end;
end;

procedure TBugManageDlg.dbtxtZFILESAVEClick(Sender: TObject);
begin
  actBugHistory_Savetofile.Execute;
end;

procedure TBugManageDlg.WMShowBugItem(var msg: TMessage);
var
  myPageIndex : Integer;
  mywherestr : string;
  myindex : integer;
  mycount : integer;
  myType : TPageType;
begin
  //
  mywherestr := fPageType.fWhereStr;
  myType := fPageType.fType;
  myindex := fpageType.fIndex;
  mycount := fpageType.fIndexCount;
  try

    fPageType.fType := ptQuery;
    fPageType.fWhereStr := Format('ZID=%d',[msg.WParam]);
    fPageType.fIndex := 1;
    fPageType.fName := '�߼���ѯ';
    myPageIndex := 1;
    fPageType.fIndexCount := GetBugItemPageCount(myPageindex,fPageType.fWhereStr);
    LoadBugItem(myPageindex,fPageType.fWhereStr);
    lbPageCount.Caption := format('%d/%d',[
      fPageType.fIndex,
      fPageType.fIndexCount]);
      lbProjectName.Caption := format('%s  =>��%d��%dҳ',[
    fPageType.fName,fPageType.fIndex,fPageType.fIndexCount]);


    if pcBug.ActivePageIndex=0 then
      pcBug.ActivePageIndex := 1;
    LoadBugHistory(msg.WParam);

  finally
    fPageType.fWhereStr := mywherestr;
    fPageType.fType := myType;
    fpageType.fIndex := myindex;
    fpageType.fIndexCount := mycount;
  end;
end;


procedure TBugManageDlg.LoadTag(AItems: TStrings);
begin
  with Dm do
  begin
    AItems.Clear;
    cdsTag.First;
    while not cdsTag.Eof do
    begin
      AItems.Add(cdsTag.FieldByName('ZNAME').AsString);
      cdsTag.Next;
    end;
    AItems.Add(gcTagNewName);
  end;
end;
{

 }

procedure TBugManageDlg.cbbTagChange(Sender: TObject);
var
  mystr : string;
begin
  if fLoading then Exit;
  if not (ClientSystem.fEditerType in [etAdmin,etDeve,etTest,etServer]) then
  begin
    MessageBox(Handle,'��û��Ȩ��','��ʾ',MB_ICONWARNING+MB_OK);
    Exit;
  end;
  
  if cbbTag.Text = gcTagNewName then
  begin
    if ClientSystem.fEditerType <>  etAdmin then
    begin
      MessageBox(Handle,'��û��Ȩ��','��ʾ',MB_ICONWARNING+MB_OK);
      Exit;
    end;
    mystr := InputBox('�±�ǩ','����(20�ַ�)','');
    if mystr = '' then Exit;

    //ȷ���Ƿ���Ч
    DM.cdsTag.DisableControls;
    try
      DM.cdsTag.First;
      while not DM.cdsTag.Eof do
      begin
        if CompareText(mystr,dm.cdsTag.FieldByName('ZNAME').AsString)=0 then
        begin
          MessageBox(Handle,'��ǩ�Ѵ���','��ʾ',MB_ICONWARNING+MB_OK);
          Exit;
        end;
        DM.cdsTag.Next;
      end;

      DM.cdsTag.Append;
      DM.cdsTag.FieldByName('ZNAME').AsString := mystr;
      DM.cdsTag.Post;
      cbbTag.Items.Insert(0,mystr);
      cbbTag.ItemIndex := 0;
    finally
      DM.cdsTag.EnableControls;
    end;

  end
  else
    mystr := cbbTag.Text;

  SetTag(mystr);

end;

procedure TBugManageDlg.SetTag(ATagName: string);
var
  mys : string;
  mystr : string;
begin
  //
  if cdsBugItem.IsEmpty then Exit;
  mystr := cdsBugItem.FieldByName('ZTAGNAME').AsString;

  if not (cdsBugItem.State in [dsEdit,dsInsert]) then
    cdsBugItem.Edit;

  if Pos(ATagName,mystr) > 0 then
  begin
    //aaa;bbbb
    mys := stringreplace(mystr,ATagName,'',[rfReplaceAll]);
    if (Length(mys) > 0) and (mys[1]=';') then
      mys := Copy(mys,2,MaxInt);
    if (Length(mys)>0) and (mys[Length(mys)]=';') then
      mys := Copy(mys,1,Length(mys)-1);  
    cdsBugItem.FieldByName('ZTAGNAME').AsString := mys;
  end
  else begin
    if mystr <> '' then
      cdsBugItem.FieldByName('ZTAGNAME').AsString :=
        Format('%s;%s',[ATagName,mystr])
    else
      cdsBugItem.FieldByName('ZTAGNAME').AsString := ATagName;
  end;

  cdsBugItem.Post;
end;

procedure TBugManageDlg.actBug_ExportExcelExecute(Sender: TObject);
var
  Eclapp:variant;
  i,j,n,c:integer;
begin

  //����Excel�ļ�

  Eclapp := createoleobject('Excel.Application');
  Eclapp.workbooks.add;
  eclapp.visible := true;

  n := 1;
  eclapp.cells[n,1]   := '��������ϵͳ ' + DateTimeToStr(Now()) ;

  n := n+2;
  Eclapp.cells[n,1] := '���';
  for i:=0 to dgBugItem.FieldCount-1 do
  begin
    Eclapp.cells[n,i+1+1]:=dgBugItem.Columns[i].Title.Caption;
  end;

  cdsBugItem.DisableControls;
  try
    cdsBugItem.First;
    n:=n+1;c := 1;
    while not cdsBugItem.Eof do
    begin
      eclapp.cells[n,1] := inttostr(c); c:=c+1;
      for j :=0 to dgBugItem.FieldCount -1 do
      begin
        eclapp.cells[n,2+j] := cdsBugItem.FieldByName(
          dgBugItem.Columns.Items[j].FieldName).AsString;
      end;
      inc(n);
      cdsBugItem.Next;
    end;
    cdsBugItem.First;
  finally
    cdsBugItem.EnableControls;
  end;

  eclapp.cells[n+1,1] := '��¼������Ϊ��'+inttostr(cdsBugItem.RecordCount)+'��';

end;

procedure TBugManageDlg.actBud_AddByDemandExecute(Sender: TObject);
var
  mystr : string;
  myBugid : Integer;
  mycds : TClientDataSet;
const
  glSQL = 'select * from TB_DEMAND where ZID=%d';
begin
  //
  if not InputQuery('����������','������',mystr) then Exit;

  myBugid := StrToIntdef(mystr,0);
  if myBugid = 0 then
  begin
    MessageBox(Handle,'��Ч�������','��ʾ',MB_ICONWARNING+MB_OK);
    Exit;
  end;

  mycds := TClientDataSet.Create(nil);
  try
    mycds.Data := ClientSystem.fDbOpr.ReadDataSet(PChar(format(glSQL,[myBugid])));
    if mycds.RecordCount = 0 then
    begin
      MessageBox(Handle,pChar('����������� D'+inttostr(myBugid)),'��ʾ',
        MB_ICONWARNING+MB_OK);
      Exit;
    end;


    if cdsBugItem.State in [dsEdit,dsInsert] then
      cdsBugItem.Post;

    cdsBugItem.First;
    cdsBugItem.Insert;
    cdsBugItem.FieldByName('ZTITLE').AsString := mycds.fieldByName('ZNAME').AsString;
    cdsBugItem.FieldByName('ZTYPE').AsInteger := 3; //��������
    cdsBugItem.FieldByName('ZDEMAND_ID').AsString := IntToStr(myBugid);
    cdsBugItem.FieldByName('ZMAILTO').AsString := mycds.FieldByName('ZMAILTO').asstring;
    cdsBugItem.FieldByName('ZPRO_ID').AsInteger := mycds.fieldByName('ZPRO_ID').AsInteger;

    LoadBugHistory(cdsBugItem.FieldByName('ZID').Asinteger);
    pcBug.ActivePageIndex := 1;
  finally
    mycds.Free;
  end;

end;

procedure TBugManageDlg.actBug_GotoDemandUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := (cdsBugItem.RecordCount > 0) and
  (cdsBugItem.FieldByName('ZDEMAND_ID').AsInteger>0);
end;

procedure TBugManageDlg.act_AllDataExecute(Sender: TObject);

  function GetwhereStr() : string;
  var
    mystr : string;
  const
    glSQL  = 'select ZID,ZNAME,ZPRO_ID from TB_BUG_TREE Order by ZSORT';
  begin
    cdstemp.Data := ClientSystem.fDbOpr.ReadDataSet(PChar(glSQL));
    cdstemp.First;
    while not cdstemp.Eof do
    begin
      //Ȩ��
      if not HasModuleAction(Ord(bsBugTree),
        cdstemp.FieldByName('ZID').AsInteger,atView) then
      begin
        cdstemp.Next;
        Continue;
      end;
      if mystr = '' then
        mystr := format('ZTREE_ID=%d',[cdstemp.FieldByName('ZPRO_ID').AsInteger])
      else
        mystr := mystr + ' or ' + format('ZTREE_ID=%d',[cdstemp.FieldByName('ZPRO_ID').AsInteger]);

      cdstemp.Next;
    end;


    Result := '(' + mystr + ')';
  end;

var
  mywhere : string;
begin
  //
  // '(ZTREE_ID=1)'
  // ע��Ŀ¼��Ȩ��
  //
  Application.ProcessMessages;

  try
    mywhere := GetwhereStr();
    fPageType.fType := ptQuery;
    fPageType.fWhereStr := mywhere;
    fPageType.fIndex := 1;
    fPageType.fName := '�߼���ѯ';

    fPageType.fIndexCount := GetBugItemPageCount(1,myWhere);
    LoadBugItem(1,myWhere);
    lbPageCount.Caption := format('%d/%d',[
      fPageType.fIndex,
      fPageType.fIndexCount]);
    lbProjectName.Caption := format('%s  =>��%d��%dҳ',[
    fPageType.fName,fPageType.fIndex,fPageType.fIndexCount]);
  finally

  end;
end;

procedure TBugManageDlg.actBug_GotoDemandExecute(Sender: TObject);
var
  myZId : Integer;
begin
  myZId := cdsBugItem.FieldByName('ZDEMAND_ID').AsInteger;
  if myZId = -1 then Exit;
  SendMessage(Application.MainForm.Handle,gcMSG_GetDemandItem,myZId,0);
end;

procedure TBugManageDlg.actBug_VerifyExecute(Sender: TObject);
begin
  if MessageBox(Handle,'�����?','��ʾ',MB_ICONQUESTION+MB_YESNO)=IDNO then
    Exit;
  if not (cdsBugItem.State in [dsEdit,dsInsert]) then
    cdsBugItem.Edit;
  cdsBugItem.FieldByName('ZVERIFYED').AsBoolean := True;
  cdsBugItem.FieldByName('ZVERIFNAME').AsInteger := ClientSystem.fEditer_id;
  cdsBugItem.FieldByName('ZVERIFYDATE').AsDateTime := ClientSystem.fDbOpr.GetSysDateTime;

end;

procedure TBugManageDlg.actBug_VerifyUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled :=
    (cdsBugItem.FieldByName('ZSTATUS').AsInteger = Ord(bgsDeath)) and
    not cdsBugItem.FieldByName('ZVERIFYED').AsBoolean and
    not (cdsBugHistory.State in [dsEdit,dsInsert]);
end;

procedure TBugManageDlg.BtnSelectedDataTimeClick(Sender: TObject);
var
  myform : TTickDateTimeDlg;
begin
  myform := TTickDateTimeDlg.Create(nil);
  myform.cal1.Date := Now();
  if myform.ShowModal = mrOk then
  begin
    if not (cdsBugItem.State in [dsEdit,dsInsert]) then
      cdsBugItem.Edit;
    cdsBugItem.FieldByName('ZNEDDDATE').AsDateTime := myform.cal1.Date;
  end;
  myform.Free;
end;

end.
