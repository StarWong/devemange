unit StatManageClientfrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseChildfrm, ExtCtrls, ComCtrls, StdCtrls, Buttons, DB,
  DBClient, Grids, DBGrids, ActnList;

type
  TStatManageClientDlg = class(TBaseChildDlg)
    pnlTool: TPanel;
    lbl1: TLabel;
    dtp1: TDateTimePicker;
    dtp2: TDateTimePicker;
    lbl2: TLabel;
    btnStat: TBitBtn;
    cdsData: TClientDataSet;
    dsData: TDataSource;
    actlst1: TActionList;
    actStat: TAction;
    actExportExcel: TAction;
    btnExportExcel: TBitBtn;
    dlgSave1: TSaveDialog;
    actDownMother: TAction;
    actUpMother: TAction;
    btnUpMother: TBitBtn;
    btnDownMother: TBitBtn;
    tbc1: TTabControl;
    dbgrdData: TDBGrid;
    btnCurrMother: TBitBtn;
    actCurrMother: TAction;
    actChart: TAction;
    btn1: TBitBtn;
    procedure actStatExecute(Sender: TObject);
    procedure actExportExcelExecute(Sender: TObject);
    procedure actExportExcelUpdate(Sender: TObject);
    procedure actUpMotherExecute(Sender: TObject);
    procedure actDownMotherExecute(Sender: TObject);
    procedure tbc1Changing(Sender: TObject; var AllowChange: Boolean);
    procedure actCurrMotherExecute(Sender: TObject);
    procedure actChartExecute(Sender: TObject);
    procedure actChartUpdate(Sender: TObject);
    procedure dbgrdDataDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure initBase; override;
  end;

implementation


uses
  ClinetSystemUnits,
  StatChartExfrm,
  ComObj;

const
  gcMotheday : array[1..12] of Integer = (31,28,31,30,31,30,31,31,30,31,30,31);

{$R *.dfm}

procedure TStatManageClientDlg.actStatExecute(Sender: TObject);
var
  mySQL : string;
  i : integer;
const
  glSQL = 'exec pt_StatBugTaskCount ''%s'',''%s''';
  glSQL2 = 'exec pt_StatBugProjectTaskCount ''%s'',''%s''';
begin
  //ͳ��
  ShowProgress('���Ժ�...',0);
  try
    if tbc1.TabIndex = 0 then  //����Ա
    begin
      mySQL := format(glSQL,[
        formatdatetime('yyyy-mm-dd',dtp1.Date),
        formatdatetime('yyyy-mm-dd',dtp2.Date)]);
      cdsData.Data := ClientSystem.fDbOpr.ReadDataSet(pchar(mySQL));
      for i :=0 to cdsData.Fields.Count -1 do
      begin
        case i of
          0:cdsData.Fields[i].DisplayLabel  := '����';
          1:cdsData.Fields[i].DisplayLabel  := '�������';
          2:cdsData.Fields[i].DisplayLabel  := '��������';
          3:cdsData.Fields[i].DisplayLabel  := '�ظ�����';
          4:cdsData.Fields[i].DisplayLabel  := '���⼤��';
          5:cdsData.Fields[i].DisplayLabel  := '����÷�';
          6:cdsData.Fields[i].DisplayLabel  := '�������';
          7:cdsData.Fields[i].DisplayLabel  := '����÷�';
          8:cdsData.Fields[i].DisplayLabel  := '�Ӱ����';
          9:cdsData.Fields[i].DisplayLabel  := 'SVN�ύ��';
          10:cdsData.Fields[i].DisplayLabel := '�ύ������';
          11:cdsData.Fields[i].DisplayLabel := '��ɲ�����';
          12:cdsData.Fields[i].DisplayLabel := '���Ե÷�' ;
          13:cdsData.Fields[i].DisplayLabel := '�ܷ�';
        end;
        cdsData.Fields[i].DisplayWidth := 10;

        if cdsData.Fields[i].DataType in [ftInteger] then
        begin
          (cdsData.Fields[i] as TIntegerField).DisplayFormat := '#';
        end;

        if cdsData.Fields[i].DataType in [ftFloat] then
        begin
          (cdsData.Fields[i] as TFloatField).DisplayFormat := '#.###';
        end;

      end;
    end
    else begin  //����Ŀ
      mySQL := format(glSQL2,[
        formatdatetime('yyyy-mm-dd',dtp1.Date),
        formatdatetime('yyyy-mm-dd',dtp2.Date)]);
      cdsData.Data := ClientSystem.fDbOpr.ReadDataSet(pchar(mySQL));
      for i :=0 to cdsData.Fields.Count -1 do
      begin
        case i of
          0:
            begin
              cdsData.Fields[i].DisplayLabel := '��Ŀ';
              cdsData.Fields[i].DisplayWidth := 40;
            end;
          1:cdsData.Fields[i].DisplayLabel := '�ύ��������';
          2:cdsData.Fields[i].DisplayLabel := '�Ѵ��������';
          3:cdsData.Fields[i].DisplayLabel := 'û�д�������';
        end;

        if cdsData.Fields[i].DataType in [ftInteger] then
        begin
          (cdsData.Fields[i] as TIntegerField).DisplayFormat := '#';
        end;

        if cdsData.Fields[i].DataType in [ftFloat] then
        begin
          (cdsData.Fields[i] as TFloatField).DisplayFormat := '#.###';
        end;

      end;
    end;
  finally
    HideProgress;
  end;
end;

procedure TStatManageClientDlg.initBase;
var
  y,m,d : word;
begin
  DecodeDate(now(),y,m,d);
  dtp1.Date := strtodatetime(format('%d-%d-1',[y,m]));
  dtp2.Date := strtodatetime(format('%d-%d-%d',[y,m,gcMotheday[m]]));
end;

procedure TStatManageClientDlg.actExportExcelExecute(Sender: TObject);
var
  Eclapp:variant;
  i,j,n,c:integer;
begin

  //����Excel�ļ�

  Eclapp := createoleobject('Excel.Application');
  Eclapp.workbooks.add;
  eclapp.visible := true;

  n := 1;
  eclapp.cells[n,1]   := format('ͳ���ڼ�:%s �� %s',[datetostr(dtp1.Date),
    datetostr(dtp2.Date)]);

  n := n+2;
  Eclapp.cells[n,1] := '���';
  for i:=0 to dbgrdData.FieldCount-1 do
  begin
    Eclapp.cells[n,i+1+1]:=dbgrdData.Columns[i].Title.Caption;
  end;

  cdsData.DisableControls;
  try
    cdsData.First;
    n:=n+1;c := 1;
    while not cdsData.Eof do
    begin
      eclapp.cells[n,1] := inttostr(c); c:=c+1;
      for j:=0 to cdsData.FieldCount -1 do
      begin
        eclapp.cells[n,2+j] := cdsData.Fields[j].AsString;
      end;
      inc(n);
      cdsData.Next;
    end;
    cdsData.First;
  finally
    cdsData.EnableControls;
  end;


  eclapp.cells[n+1,1] := '��¼������Ϊ��'+inttostr(cdsData.RecordCount)+'��';

end;

procedure TStatManageClientDlg.actExportExcelUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := cdsData.Active and (cdsData.RecordCount > 0);
end;

procedure TStatManageClientDlg.actUpMotherExecute(Sender: TObject);
var
  y,m,d : word;
begin
  DecodeDate(dtp1.Date,y,m,d);
  if m = 1 then //��ʾһ�·�
  begin
    y := y -1;
    m := 12;
  end
  else m := m-1;
  dtp1.Date := strtodatetime(format('%d-%d-1',[y,m]));
  dtp2.Date := strtodatetime(format('%d-%d-%d',[y,m,gcMotheday[m]]));

  actStat.Execute;
end;

procedure TStatManageClientDlg.actDownMotherExecute(Sender: TObject);
var
  y,m,d : word;
begin
  DecodeDate(dtp1.Date,y,m,d);
  if m = 12 then //��ʾһ�·�
  begin
    y := y +1;
    m := 1;
  end
  else m := m+1;
  dtp1.Date := strtodatetime(format('%d-%d-1',[y,m]));
  dtp2.Date := strtodatetime(format('%d-%d-%d',[y,m,gcMotheday[m]]));
  actStat.Execute;
end;

procedure TStatManageClientDlg.tbc1Changing(Sender: TObject;
  var AllowChange: Boolean);
begin
  if cdsData.Active then cdsData.Active := False;
end;

procedure TStatManageClientDlg.actCurrMotherExecute(Sender: TObject);
var
  y,m,d : word;
begin
  DecodeDate(now(),y,m,d);
  dtp1.Date := strtodatetime(format('%d-%d-1',[y,m]));
  dtp2.Date := strtodatetime(format('%d-%d-%d',[y,m,gcMotheday[m]]));
  actStat.Execute;
end;

procedure TStatManageClientDlg.actChartExecute(Sender: TObject);
begin
  with TStatChartDlg.Create(nil) do
  try
    cds1.Data := cdsData.Data;

    dbcht1.Foot.Text.Add(format('ͳ���ڼ�:%s �� %s',[datetostr(dtp1.Date),
    datetostr(dtp2.Date)]));

    ShowModal;
  finally
    Free;
  end;
end;

procedure TStatManageClientDlg.actChartUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := cdsData.Active and
  (cdsData.RecordCount > 0) and (tbc1.TabIndex=0);
end;

procedure TStatManageClientDlg.dbgrdDataDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  if (cdsData.RecNo mod 2  = 0) and not ( gdSelected in State)  then
    dbgrdData.Canvas.Brush.Color := clSilver;

  dbgrdData.DefaultDrawColumnCell(Rect,DataCol,Column,State);

end;

end.
