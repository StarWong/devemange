///////////////////////////////////////////////////////////////////////////////
//  ���ã�����ִ�����ݿ�����Ľӿ���
//  �ļ�����BFSSDbOprIntf.pas  �汾��1.0
//  �ӿ�֧�ֿ�: BFSSDBOpr.dll  
//  �������ڣ�2007-11-1       ���ߣ�������
//
//
//  �޸�ʱ��: 2007-11-28 ����: ������
//  �޸�����: ����mailto�ӿ�
//  ����޸�: 2009-2-21
//
//  ������AppServer�ӿڵ�����
//
//******************************************************************************}
//
// ʹ�÷���:
//   �ڹ������ֶ���:
//
//   function CreateBfssDBOpr(AConnectStype:Word): IDbOperator; stdcall;
//    ����: AConnectStype = 0 ��ʾ����DCOM����
//                        = 1 ��ʾ����Socke����
//   function CreateDbOperator; stdcall; external 'DBapi.api';
//
//
////////////////////////////////////////////////////////////////////////////////
// �޸�:
//   1.���Ӳ��Ե��ʼ�֪ͨ���� Test = 3 ����:������ 2008-10-6
//   2.�����ʼ�ֱ�ӷ��͹��� ���ߣ������� 2009-2-20
//
//
///////////////////////////////////////////////////////////////////////////////
unit DbApiIntf;

interface

uses
  Windows, DBClient;

const
  cnEmptyIntValue: Integer = -1;
  cnCurDbOprVersion = 1;

type

  TConnectStype = (csDCOM,csSocket); 

  IDbOperator = interface
    ['{D6C3AF62-934A-40A9-99C8-D31143F428A0}']
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
    //
    // DoExecute ��ִ�в���SQL�����Param��������������,
    // ��ExeSQL ��ͬ�ģ�ExeSQLû��Param����ֵ
    // ����:
    //  ASqlStr ΪSQL���
    //  AParams ���� PackageParams(cdsQuery.Params) �������á�
    //
    procedure DoExecute(ASqlStr:WideString;AParams: OleVariant); stdcall;

    //4.AppServer �ӿ�
    function Login(const AName: WideString; const APass: WideString):integer;stdcall;
    function CopyFile(AFile_ID: Integer; AVer: Integer; ATree_ID: Integer): Integer; safecall;
    function DeleteFile(AFile_ID: Integer): Integer; safecall;
    function UpFileChunk(AFile_ID: Integer; AVer: Integer; AGroupID: Integer; AStream: OleVariant): Integer; safecall;
    //
    // AStyle ���ͣ�Ŀǰֻ��Bug=0 , Task=1 ,Test=2
    // AMails ��ʾ�����б��� mrlong.com@gmail.com;mrlng_xp@163.com
    // AContextID ���ݣ��ǰ�������ȷ���ġ���bug����bug_idֵ, Task ������IDֵ=-1
    //
    //�����񵥵������ ����:������ 2008-6-28
    // AMails : string ��ʾ���񵥺�
    //
    //
    procedure MailTo(AStyle: Integer; const AMails: WideString; AContextID: Integer); safecall;
    //
    // ֱ�ӷ����ʼ�
    //  AMails Ϊ���͵ĵ�ַ ��ʽΪ mrlong.com@gmail.com;mrlong_xp@163.com �����;�ŷֿ�
    //  ATitle Ϊ�ʼ��ı���
    //  AContent  Ϊ�ʼ�������
    //
    //
    procedure MailToEx(const AMails: WideString; ATitle : WideString; AContent: WideString); safecall;

    //ȡ��ϵͳʱ��
    function GetSysDateTime: OleVariant; stdcall;
    //5.����
    function Connected(): Boolean; stdcall;
    function Version : integer;stdcall;
    function AppServer : Variant; stdcall;

    //6.�ϴ��ļ� 2012-8-28
    //AStyle = 1 ��ʾbug����
    //       = 4 ��ʾ���Թ����ϵĸ���
    //       = 8 ��ʾ��Ʒԭ���ϵĸ���
    //AContentid Ϊ���ݵ�id ����bug��������bugid��
    function UpFile(AStyle:Integer;AContentid:Integer;AFileName:WideString):Integer; stdcall;
    function DownFile(AFileID:Integer;AFileName:WideString):Integer;stdcall;
    

  end;


implementation

end.

