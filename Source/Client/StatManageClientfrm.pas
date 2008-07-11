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
    dbgrdData: TDBGrid;
    actlst1: TActionList;
    actStat: TAction;
    actExportExcel: TAction;
    btnExportExcel: TBitBtn;
    procedure actStatExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses ClinetSystemUnits;

{$R *.dfm}

procedure TStatManageClientDlg.actStatExecute(Sender: TObject);
var
  mySQL : string;
  i : integer;
const
  glSQL = 'exec pt_StatBugTaskCount ''%s'',''%s''';
begin
  //ͳ��
  mySQL := format(glSQL,[
    formatdatetime('yyyy-mm-dd',dtp1.Date),
    formatdatetime('yyyy-mm-dd',dtp2.Date)]);
  cdsData.Data := ClientSystem.fDbOpr.ReadDataSet(pchar(mySQL));
  for i :=0 to cdsData.Fields.Count -1 do
  begin
    case i of
      0:cdsData.Fields[i].DisplayLabel := '����';
      1:cdsData.Fields[i].DisplayLabel := '�������';
      2:cdsData.Fields[i].DisplayLabel := '��������';
      3:cdsData.Fields[i].DisplayLabel := '�ظ�����';
      4:cdsData.Fields[i].DisplayLabel := '���⼤��';
      5:cdsData.Fields[i].DisplayLabel := '����÷�';
      6:cdsData.Fields[i].DisplayLabel := '�������';
      7:cdsData.Fields[i].DisplayLabel := '����÷�';
      8:cdsData.Fields[i].DisplayLabel := '�ܷ�';
    end;
  end;
end;

end.
