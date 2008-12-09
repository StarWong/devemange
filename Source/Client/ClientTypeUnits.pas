unit ClientTypeUnits;

interface
uses
  windows,ExcelUnits;
type

  //
  // Ȩ�޹��������
  //
  TModuleType = (mtFile=100,mtBug=200,mtProject=300,mtUser=400,mtDoc=500,
    mtTest=600,mtPlan=700,mtAnt=800);
  //�ļ�����ģ��
  TFileSubModuleStype = (fsmDir=1,fsmfile=2);
  //BUG��Ŀ����
  TBugSubModuleStype = (bsBugTree=1
                         );
  //��Ŀ����
  TProjectSubModuleStype = (psVersion=1,psTask=2
    );
  //��Ŀ�ĵ�
  TDocSubModuleStype = (bsDocTree=1);


  //Ȩ�޲���Ȩ��
  TActionType = (atView,atUpdate,atInsert,atDelete);
  TActionTypes = set of  TActionType;


  //�ļ�����������
  TFileStype = (fsFile,fsBug,fsDoc);

  //BUG��״̬
  TBugStatus = (bgsAction,bgsDeath,bgsReAction,bgsClose); //��ģ����޸ĵ�,������,�ر�

  //���񵥵�״̬
  //���ַ�=0 ; ִ����=1 ; ����=2; ���=3 ; �ر�=4;����=5
  TTaskStatus = (tsRelass,tsing,tsUndo,tsSccuess,tsClose,tsAction);

  PFileTreeNode = ^TFileTreeNode;
  TFileTreeNode = record
    fParent : PFileTreeNode;   //������
    fID   : integer;
    fPID  : integer;
    fName : String;
    fNote : String;
    fhasChild : Boolean;
    fOpenInherit  : Boolean; //=True ��ʾ�̳��ϼ��Ĵ򿪷�ʽ
    fOpenExe      : String;  // Exe��·��
    fOpenExt      : String;  // �򿪵���չ
    fPublic       : Boolean; //=True ��ʾ����,������Ȩ��
  end;

  PFileItem = ^TFileItem;
  TFileItem = record
    fTreeID : integer;
    fID : integer;
    fVer : integer;
    fName : String;
    fEditer_id : integer; //�༭�˵�id
    fEditer : String;     //�༭�˵�����
    fFilePath : String;
    fStatus : integer;    //״̬
    fExt : String;
    fEditDateTime : TDateTime;
    fStructVer : integer;
    fType : integer;      //����
    fSzie : integer;      //�ļ���С
    fParentPri : Boolean; //�Ƿ����Ŀ¼��Ȩ��
    fOwner : Integer;     //������
    fOwnerName : string;
  end;

  PBugTreeNode = ^TBugTreeNode;
  TBugTreeNode = record
    fParent : PBugTreeNode;
    fID     : integer;
    fPID    : integer;
    fPRO_ID : integer; //��ĿIDֵ
    fName   : string;
    fAddDate: TDateTime;
    fSort   : integer;
    fhasChild : Boolean;
    fhasLoad : Boolean; //��ʾ�Ѽ������Ӽ�
    fPageIndex : integer; //��ǰ��ҳ��,Ĭ��Ϊ1;
    fPageCount : integer; //ҳ����
  end;

  PProjectDoc = ^TProjectDoc;
  TProjectDoc = record
    fParent : PProjectDoc;
    fID   : integer;
    fPid  : integer;
    fStyle : integer;     //����  ���� = 0 Ŀ¼��=1�ĵ�
    fName : String;
    fSort      : integer;
    fExcelFile : TExcelFile;
    fhasChild  : Boolean;
    fIsLoad    : Boolean; //�Ƿ��Ѽ��ع���
  end;


const
  gcActionView   = 1;
  gcActionUpdate = 2;
  acActionInsert = 4;
  acActionDelete = 8;
const
  gcSoftChar    = '��';
  gcDecSoftChar = '��';
  gcfiledir     = '�ļ���';

  ActionTypeName : array [atView..atDelete] of String  =
  ('�鿴','�޸�','����','ɾ��');

  TaskStatusName : array [tsRelass..tsAction] of String =
  ('���ַ�','ִ����','����','���','�ر�','����');

const
  gcMSG_TickCount = $0400{WM_USER} +1;  //���͵�mainfrm��ʾ
  gcMSG_GetBugItem = $0400{WM_USER} +2; //���͵�bug,��ʾ����
  gcLogDir = 'Log'; //��־Ŀ¼


implementation


end.
