//////////////////////////////////////////////////////////////
//
// ��Ʒԭ�ͣ�֧�� axure���������
// ���ߣ������� 2014-5-9
//
//
/////////////////////////////////////////////////////////////

unit PrototypeClinetfrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseChildfrm, ComCtrls, ExtCtrls, Grids, DBGrids, StdCtrls,
  Buttons, ActnList;

type
  TPrototypeClientDlg = class(TBaseChildDlg)
    pgc1: TPageControl;
    tsList: TTabSheet;
    tsView: TTabSheet;
    pnlTools: TPanel;
    pnlonvisible: TPanel;
    actlst1: TActionList;
    btnAddPro: TBitBtn;
    dbgrdList: TDBGrid;
    act_AddPro: TAction;
    procedure act_AddProExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TPrototypeClientDlg.act_AddProExecute(Sender: TObject);
begin
  //
end;

end.
