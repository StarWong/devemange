unit ClientTypeUnits;

interface

type

  TModuleType = (mtFile=100,mtBug=200,mtProject=300,mtUser=400);
  //�ļ�����ģ��
  TFileSubModuleStype = (fsmfile,fsmDir);
  //BUG��Ŀ����
  TBugSubModuleStype = (bsBugTree=1
                         );
  //��Ŀ����
  TProjectSubModuleStype = (psVersion=1
    );

  //�ļ������ڵ�Tree_ID����Bug�ĸ���Bugֵ
  TFileTreeDirStype = (ftdBug=-2);

  //Ȩ�޲���Ȩ��
  TActionType = (atView,atUpdate,atInsert,atDelete);
  TActionTypes = set of  TActionType;

  //BUG��״̬
  TBugStatus = (bgsAction,bgsDeath); //��ģ����޸ĵ�

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


const
  gcActionView   = 1;
  gcActionUpdate = 2;
  acActionInsert = 4;
  acActionDelete = 8;
const
  gcSoftChar    = '��';
  gcDecSoftChar = '��';
  gcfiledir     = '�ļ���';


implementation


end.
