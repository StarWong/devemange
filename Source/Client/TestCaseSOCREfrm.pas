////////////////////////////////////////////////////////////////////////////////
//
// ��Ŀ: ������������
// ģ��: ���Դ�ֹ���
// ����: ������ ����ʱ��: 2008-11-29
//
//
// �޸�:       
//
//
//
////////////////////////////////////////////////////////////////////////////////
unit TestCaseSOCREfrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseDialogfrm, StdCtrls, Buttons, DBCtrls, DB, DBClient, Mask,
  ExtCtrls;

type
  TTestCaseSOCREDlg = class(TBaseDialog)
    lbl1: TLabel;
    lbl2: TLabel;
    dblkcbbZCLOSESTATUS: TDBLookupComboBox;
    btnCancel: TBitBtn;
    btnOk: TBitBtn;
    cds1: TClientDataSet;
    ds1: TDataSource;
    edt1: TEdit;
    lbl4: TLabel;
    dbedtZREMORK: TDBEdit;
    lbl5: TLabel;
    lbl6: TLabel;
    lbl7: TLabel;
    lbl8: TLabel;
    lbl3: TLabel;
    procedure cds1AfterScroll(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation
uses
  TestManageClient;

{$R *.dfm}

procedure TTestCaseSOCREDlg.cds1AfterScroll(DataSet: TDataSet);
begin
  case DataSet.FieldByName('ZID').AsInteger of
    0: edt1.Text := '5';
    1: edt1.Text := '2';
    2: edt1.Text := '1';
    3: edt1.Text := '0';
    4: edt1.Text := '-2';
  end;
end;

end.
