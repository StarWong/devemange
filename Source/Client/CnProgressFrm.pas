{******************************************************************************}
{                       CnPack For Delphi/C++Builder                           }
{                     �й����Լ��Ŀ���Դ�������������                         }
{                   (C)Copyright 2001-2008 CnPack ������                       }
{                   ------------------------------------                       }
{                                                                              }
{            ���������ǿ�Դ��������������������� CnPack �ķ���Э������        }
{        �ĺ����·�����һ����                                                }
{                                                                              }
{            ������һ��������Ŀ����ϣ�������ã���û���κε���������û��        }
{        �ʺ��ض�Ŀ�Ķ������ĵ���������ϸ���������� CnPack ����Э�顣        }
{                                                                              }
{            ��Ӧ���Ѿ��Ϳ�����һ���յ�һ�� CnPack ����Э��ĸ��������        }
{        ��û�У��ɷ������ǵ���վ��                                            }
{                                                                              }
{            ��վ��ַ��http://www.cnpack.org                                   }
{            �����ʼ���master@cnpack.org                                       }
{                                                                              }
{******************************************************************************}

unit CnProgressFrm;
{* |<PRE>
================================================================================
* ������ƣ����������
* ��Ԫ���ƣ�ͨ�ý��������嵥Ԫ
* ��Ԫ���ߣ��ܾ��� (zjy@cnpack.org)
* ��    ע���ô����ɳ����ڲ����ƿ����͹رգ�����ֱ�Ӵ�������ʵ��
*           �õ�Ԫ�ṩ���¼�������������ʾ��̬��ʾ���壺
*             ShowProgress   - ��ʾ����������
*             HideProgress   - ���ؽ���������
*             UpdateProgress - ���µ�ǰ����
*             UpdateProgressTitle  - ���´������
* ʹ�÷���������Ҫ��ʾ��ʾ���ڵĵ�Ԫ��uses����Ԫ������Ҫ��ʾ��ʾ��Ϣʱֱ��
*           ֱ�ӵ���ShowXXXX���̼��ɡ�
* ע�����ͬһʱ����Ļ��ֻ����ʾһ�����ȴ��壬������ʾʱ�������д������
*           ��ʹ�ã�����ʾ�ô���Ĵ����Կ��Լ������С�
* ����ƽ̨��PWin98SE + Delphi 5.0
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6
* �� �� �����õ�Ԫ�е��ַ����в����ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnProgressFrm.pas,v 1.6 2008/03/08 02:20:17 liuxiao Exp $
* �޸ļ�¼��2008.03.08 V1.1
*                xierenxixi �޸�����÷�ʽ
*           2002.04.03 V1.0
*                ������Ԫ
================================================================================
|</PRE>}

interface



uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, StdCtrls, ComCtrls, ExtCtrls;

type

{ TProgressForm }
  TProgressType = (ptProgress,ptAction);

  TProgressForm = class(TForm)
    pnl1: TPanel;
    ProgressBar: TProgressBar;
    ani1: TAnimate;
    lblTitle: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure ShowProgress(const Title: string;ACount:integer);
{* ��ʾ���������壬����Ϊ�������}
procedure HideProgress;
{* �رս���������}
procedure UpdateProgress(Value: Integer);
{* ���µ�ǰ���ȣ�����Ϊ����ֵ��0..100}
procedure UpdateProgressTitle(const Title: string);
{* ���½�����������⣬����Ϊ����}

implementation

{$R *.DFM}

var
  ProgressForm: TProgressForm = nil;  // ����������ʵ��
  FormList: TThreadList	;  // �����õĴ����б�ָ��

// ��ʾ����
procedure ShowProgress(const Title: string;ACount:integer);
var
  i: Integer;
begin
  if not Assigned(ProgressForm) then
  begin
    ProgressForm := TProgressForm.Create(Application.MainForm);
    ProgressForm.ani1.ResName := 'MOV';
  end
  else
    ProgressForm.BringToFront;
  ProgressForm.lblTitle.Caption := Title;
  if ACount = 0 then
  begin
    ProgressForm.ani1.Visible := True;
    ProgressForm.ProgressBar.Visible := False;
    ProgressForm.ani1.Active := True;
  end
  else begin
    ProgressForm.ani1.Visible := False;
    ProgressForm.ProgressBar.Visible := True;
    ProgressForm.ProgressBar.Position := 0;
    ProgressForm.ProgressBar.Max := ACount;
  end;
  ProgressForm.Show;

  with FormList.LockList do
  try
     for i := 0 to Screen.FormCount - 1 do
    begin
      if (Screen.Forms[i] <> ProgressForm) and Screen.Forms[i].Enabled
         and (IndexOf(Screen.Forms[i])<0)  then
      begin
        Add(Screen.Forms[i]);    // ���浱ǰ���õĴ����б�
        Screen.Forms[i].Enabled := False; // ���ô���
      end;
    end;
  finally
    FormList.UnlockList;
  end;


  // xierenxixi �޸�
  //FormList := DisableTaskWindows(ProgressForm.Handle);
  ProgressForm.Update;
end;

// �رմ���
procedure HideProgress;
var
  i: Integer;
begin
  if not Assigned(ProgressForm) then Exit;
  with FormList.LockList do
  try
    for i := Count - 1 downto 0 do
    begin
      try
        TForm(Items[i]).Enabled := True;   // �ָ�ԭ����
      except
        ;
      end;
      Delete(i);
    end;
  finally
    FormList.UnlockList;
  end;

  // xierenxixi �޸�
  //EnableTaskWindows(FormList);
  
  ProgressForm.Hide;
  Application.ProcessMessages;
  ProgressForm.Free;
  ProgressForm := nil;
end;

// ���½���
procedure UpdateProgress(Value: Integer);
begin
  if Assigned(ProgressForm) then
  begin
    ProgressForm.ProgressBar.Position := Value;
    ProgressForm.Update;
    Application.ProcessMessages;
  end;
end;

// ���±���
procedure UpdateProgressTitle(const Title: string);
begin
  if Assigned(ProgressForm) then
  begin
    ProgressForm.lblTitle.Caption := Title;
    ProgressForm.Update;
    Application.ProcessMessages;
  end;
end;

initialization
  FormList:= TThreadList.Create;


finalization
  FormList.Free;

end.
