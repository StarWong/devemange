/******************************************************************************
*
*         �����ļ�������
*         �ļ�����BFSS_TABLES.SQ  �汾��1.0
*         �������ڣ�2007-11-9    ����:������
*         ����޸�ʱ��:2008-4-28
*
* 
*   ע��: 
*	��mssql2000��û��boolean�����ͣ�����bit�Ĵ��� 0=False 1=True
*
*   �޸�����:
*       1.����Ŀ�ĵ���Ϊtxt�ĸ�ʽ 2008-3-10   
*       2.�������񵥹���. 2008-3-11
*       3.�ļ�������ļ�Ȩ��,�������Ϊ��Ŀ¼һ����Ȩ��. 2008-4-28
*          �������ǲ�����һһ��ÿһ���ļ�����Ȩ�ޡ�
*       4.����ϵͳ������ TB_SYSPARAMS 2006-5-13
*       5.TB_USER ������ TCHECKTASK : bit 2008-8-2
*       6.���Ӳ��Թ���ģ��. ����:������ 2008-9-5
*       7.���Ӳ��Թ���ģ��Ĺرյȼ� ����:�������� 2008-11-29
*       8.������������ڵ����� ����:������ 2008-12-20
*       9.���ӷ��������� ���ߣ������� 20080-12-20
*      10.���ӼӰ൥�Ĺ��� ����: ������ 2009-7-3 
*      11.�������û����ڵ�svn�˺��� ����:������ 2009-9-30
*
******************************************************************************/

/*#########################################################
 #
 # �ļ�������
 #
 #########################################################*/

/*�ļ���Ŀ¼�ṹ*/
if exists (select * from dbo.sysobjects
  where id = object_id(N'[dbo].[TB_FILE_TREE]')
  and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TB_FILE_TREE]
go

create table TB_FILE_TREE(
	ZID	int IDENTITY (1, 1) not null, /*ID���Զ��������*/
	ZPID    int not null default -1,      /*�ϼ�ID=-1��ʾ��Ŀ¼ Ĭ��ֵΪ-1 */
	ZNAME	varchar(200) not null,        /*����*/
	ZNOTE	varchar(200),                 /*˵��*/
	ZHASCHILD bit not null,               /*=True��ʾ���¼�*/
	ZPublic  bit not null default 0,      /*���� ��ʾû��Ȩ�޴��� 2008-4-28*/
	constraint PK_TB_FILE_TREE primary key(ZID)
)
go

/*�ļ��б� TB_FILE_ITEM*/
if exists (select * from dbo.sysobjects
  where id = object_id(N'[dbo].[TB_FILE_ITEM]')
  and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TB_FILE_ITEM]
go

create table TB_FILE_ITEM(
	ZTREE_ID       int not null,           /*��ID*/
        ZSTYPE         int not null,           /*���ͣ����ļ�����=0��bug����=1����Ŀ�ĵ�=2 ���Թ���=4 ��Ŀ�ƻ�=5*/ 
	ZID	       int not null,           /*�ļ�id*/
	ZVER           int not null,           /*�ļ��İ汾��*/
	ZNAME          varchar(200) not null,  /*����*/
	ZEDITER_ID     int ,                   /*�༭��*/
        ZFILEPATH      varchar(200),           /*�ļ�·��*/
	ZSTATUS        int not null,           /*״̬ = 0 ��ʾû���˱༭ =1��ʾ�ڱ༭*/	
	ZEXT           varchar(10),            /*�ļ�����չ��*/
	ZEDITDATETIME  datetime,               /*�ļ��༭ʱ��*/
	ZSTRUCTVER     int,                    /*�����ļ��Ľṹ�汾*/
	ZTYPE          int not null,           /*�ļ����� 0=��������ļ�*/
	ZNEWVER        bit not null,           /*�Ƿ������°汾*/
	ZNOTE          text,                   /*�ļ�˵��*/
	ZSIZE          int not null,           /*�ļ���С*/
	ZParentPri     bit not null default 0, /*�Ƿ�����ϼ���Ŀ¼��Ȩ�� 2008-4-28*/
	ZOWNER         int not null default 1, /*�ļ��Ĵ����� 1=admin 2008-4-28*/
	ZCONTENTID     int ,                   /*����bug����bug��id��,���ڹ���bug���� 2012-8-29*/
	constraint PK_TB_FILE_ITEM primary key(ZTREE_ID,ZTYPE,ZID,ZVER)
)
go

/*�ļ����� TB_FILE_CONTEXT*/
if exists (select * from dbo.sysobjects
  where id = object_id(N'[dbo].[TB_FILE_CONTEXT]')
  and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TB_FILE_CONTEXT]
go

create table TB_FILE_CONTEXT(
	ZFILE_ID  int not null,          /*�ļ�ID*/
	ZGROUPID  int not null,          /*�ļ����˳���*/
	ZVER      int not null,          /*�ļ��汾*/
	ZSTREAM   image not null,        /*�ļ�������*/
	ZLOCALGUID varchar(36),          /*���صĴ��ļ���·��*/
	ZTYPE     int default 0,         /*=0��ʾ����Stream���浽����,����������ļ�����ĳĿ¼��*/
	constraint PK_TB_FILE_CONTEXT primary key(ZFILE_ID,ZGROUPID,ZVER)       
)
go

/*�û��б� TB_USER_ITEM */
if exists (select * from dbo.sysobjects
  where id = object_id(N'[dbo].[TB_USER_ITEM]')
  and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TB_USER_ITEM]
go

create table TB_USER_ITEM(
	ZID        int IDENTITY (1, 1) not null,         /*�Զ�������ID*/
	ZNAME      varchar(20) not null,                 /*�û���*/
	ZPASS      varchar(20),                          /*����*/
	ZSTOP      bit,                                  /*�Ƿ����*/
	ZTYPE      int not null,                         /*����=0ϵͳ�û�,1=������Ա 2=������Ա,3=������Ա ����ɾ��*/
	ZEMAIL     varchar(50),                          /*����*/
	ZGROUP_ID  int,                                  /*��ID*/
	ZPRIVGROUP int,                                  /*Ȩ����*/
	ZCHECKTASK bit default 0,                        /*�������* 2008-8-2*/
	ZSVNNAME   varchar(20),                          /*SVN���˺��� 2009-9-30*/
	constraint PK_TB_USER_ITEM primary key(ZID)       
)
go

/*�û�Ȩ�ޱ� TB_USER_PRIVILEGE */
if exists (select * from dbo.sysobjects
  where id = object_id(N'[dbo].[TB_USER_PRIVILEGE]')
  and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TB_USER_PRIVILEGE]
go

create table TB_USER_PRIVILEGE(
	ZID            int IDENTITY (1, 1) not null, /*IDֵ*/
	ZUSER_ID       int not null,    /*�û�ID*/
	ZSTYLE         int not null,    /*���� �Ǵ��ģ��*/
	ZSUBSTYLE      int not null,    /*������ ����,�༭�б�*/
	ZMODULEID      int not null,    /*ģ��ID�����ļ���Ŀ¼��ID ����ID*/
	ZRIGHTMASK     int not null,    /*Ȩ������  1=�鿴 2=�޸� 4=ɾ�� 8=����*/
	constraint PK_TB_USER_PRIVILEGE primary key(ZID,ZUSER_ID,ZSTYLE,ZMODULEID)   
)
go


/*#########################################################
 #
 # ��Ŀ���� 
 #
 #########################################################*/

/*��Ŀ�б�*/
if exists (select * from dbo.sysobjects
  where id = object_id(N'[dbo].[TB_PRO_ITEM]')
  and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TB_PRO_ITEM]
go

create table TB_PRO_ITEM(
	ZID            int IDENTITY (1, 1) not null,             /*��ĿID*/
	ZNAME          varchar(200) not null,                    /*��Ŀ����*/
	ZOPENDATE      datetime not null,                        /*��Ŀ��ʼʱ��*/
	ZLASTVER       varchar(50),                              /*��Ŀ�����°汾*/
	ZLASTDATE      datetime,                                 /*��Ŀ������ʱ��*/
	ZMANAGERID     int ,                                     /*��Ŀ�ĸ�����*/
	ZUNITS         varchar(200),                             /*��Ŀ��ʹ�õ�λ*/     
	ZHIGHVERID     int not null default -1,                  /*���°汾�ŵ�IDֵ*/
	ZTESTTEAM      varchar(100),                             /*����С���Ա ��ʽ ����(���) ,�����Զ����ɲ�������.*/
	ZSVNLOGGUID    varchar(36),                              /*��Ŀ��SVN��־GUID*/
	constraint PK_TB_PRO_ITEM primary key(ZID)   
)
go

/*��Ŀ�汾*/
if exists (select * from dbo.sysobjects
  where id = object_id(N'[dbo].[TB_PRO_VERSION]')
  and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TB_PRO_VERSION]
go

create table TB_PRO_VERSION(
	ZID            int IDENTITY (1, 1) not null,             /*�汾ID*/
	ZPRO_ID        int not null,                             /*��ĿID*/
	ZVER           varchar(50) not null,                     /*�汾�Ÿ�ʽ 1.2.5.67*/
	ZUPDATEDATE    datetime,                                 /*����ʱ��*/
	ZCONTEXT       text,                                     /*����˵��*/
	ZMUSTVER       bit,                                      /*�Ƿ��Ǳ�����µİ汾*/
	constraint PK_TB_PRO_VERSION primary key(ZID,ZPRO_ID)   
)
go

/*��Ŀ�ĵ��б�*/
if exists (select * from dbo.sysobjects
  where id = object_id(N'[dbo].[TB_PRO_DOCUMENT]')
  and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TB_PRO_DOCUMENT]
go

create table TB_PRO_DOCUMENT(
	ZID            int IDENTITY (1, 1) not null,             /*ID*/
	ZPID           int not null,                             /*�ϼ�ID = -1 ��ʾ��Ŀ¼*/
	ZNAME          varchar(200),                             /*�ĵ�����*/ 
  	ZSTYLE         int not null,                             /*���� = 0 Ŀ¼��=1�ĵ�*/ 
	ZSORT          int ,                                     /*�����*/
	ZHASCHILD      bit not null,                             /*�Ƿ����¼�*/
	ZDOCTYPE       int ,                                     /*�ĵ����� 0=Excel 1=txt*/
        ZCONTEXT       text,                                     /*���� 2008-3-11*/
	constraint PK_TB_PRO_DOCUMENT primary key(ZID),   
)
go

/*����*/
if exists (select * from dbo.sysobjects
  where id = object_id(N'[dbo].[TB_TASK]')
  and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TB_TASK]
go
create table TB_TASK(
	ZCODE           varchar(30) not null,                   /*���а�һ���Ĺ������� ��Ա���_TASK_ʱ��*/
	ZTYPE           int not null,                           /*���� ��������=0,�������=1*/
	ZNAME			varchar(100),                   /*����*/
	ZUSER_ID        int ,					/*������*/				/*�����Ƶ���,���йر����񵥹���*/
	ZPRO_ID         int not null,                           /*��ĿID*/
	ZPRO_VERSION_ID int not null,                           /*��Ŀ�汾,ֻ�ж���������������*/
	ZDESIGN         text,                                   /*��Ŀ�����˵��*/
	ZTESTCASE       text,                                   /*��������*/
	ZSTATUS         int not null,                           /*״̬ ���ַ�=0 ; ִ����=1 ; ����=2; ���=3 ; �ر�=4;����=5*/
	ZDATE           datetime,                               /*�Ƶ�ʱ��*/
	ZPALNDAY        float not null default 1,               /*�ƻ�����(��)*/

	ZBEGINDATE      datetime,	                        /*����ʼʱ��(�ռ�ʱ��) ������ִ��������,��ʱ״̬���Ϊִ����*/
	ZDAY            float,                                  /*ʵ�ʵ�����*/
	ZSUCCESSDATE    datetime,                               /*���ʱ��*/
	ZCLOSEDATE      datetime,                               /*�ر�ʱ��*/
	ZCHECKNAME      int not null default 0,                 /*�����*/
	ZOVERWORK       bit  default 0,                         /*�Ƿ��ǼӰ�����*/
	
	
	constraint PK_TB_TASK primary key(ZCODE) 
)
go

/*����ִ����*/
if exists (select * from dbo.sysobjects
  where id = object_id(N'[dbo].[TB_TASK_USER]')
  and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TB_TASK_USER]
go
create table TB_TASK_USER(
	ZTASK_CODE      varchar(30) not null,
	ZUSER_ID        int not null,			        /*ִ�е���*/
	ZTASKSCORE      float,                                  /*����÷�*/ 
	ZPERFACT        float,                                  /*���ַ���*/
	ZSCORE          float,                                  /*�÷� = ����÷�*��������*/
	ZREMASK         varchar(200),                           /*��ע*/
	ZSCOREDATE      datetime,                               /*���ֵ�ʱ�䣬����ͳ��һ���µĵ÷�*/
        ZRATE           float not null default 1,               /*��������*/ 
	ZCANCEL	        bit not null default 1,                 /*ȡ��ִ��*/
	ZSELFSCORE      float,                                  /*�Զ�����*/
	constraint PK_TB_TASK_USER primary key(ZTASK_CODE,ZUSER_ID)
)
go

/*������ϸ*/
if exists (select * from dbo.sysobjects
  where id = object_id(N'[dbo].[TB_TASK_ITEM]')
  and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TB_TASK_ITEM]
go
create table TB_TASK_ITEM(
	ZID			int IDENTITY (1, 1) not null,
	ZTASK_CODE		varchar(30) not null,
	ZDATE			datetime,
	ZDESIGN         text,					/*����˵��*/
	ZUSER_ID        int  not null,                          /*��д��Ա*/

	constraint PK_TB_TASK_ITEM primary key(ZID)
)
go

/*���񵥲�����*/
if exists (select * from dbo.sysobjects
  where id = object_id(N'[dbo].[TB_TASK_PARAMS]')
  and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TB_TASK_PARAMS]
go

create table TB_TASK_PARAMS(
	ZTYPE 	     int not null,                                   /*����*/
	ZID          int not null,                                   /*IDֵ*/
	ZNAME        varchar(200)                                    /*ֵ*/
	constraint PK_TB_TASK_PARAMS primary key(ZTYPE,ZID)  
)
go

/*##########################################################
 #
 # BUG���� 
 #
 ###########################################################*/

/*BUG���ṹ*/
if exists (select * from dbo.sysobjects
  where id = object_id(N'[dbo].[TB_BUG_TREE]')
  and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TB_BUG_TREE]
go

create table TB_BUG_TREE(
	ZID            int IDENTITY (1, 1) not null,             /*BUG ID*/
	ZPID           int not null,                             /*�ϼ�BUG��ĿID*/
	ZPRO_ID        int not null,                             /*��Ӧ��������Ŀ*/
	ZNAME          varchar(200) not null,                    /*����*/ 
	ZAddDATE       datetime not null,                        /*���ӵ�ʱ��*/
	ZSORT          int not null,                             /*�����*/
	ZHASCHILD      bit not null,                             /*=True��ʾ���¼�*/
	constraint PK_TB_BUG_TREE primary key(ZID)   
)
go

/*BUG�б�*/
if exists (select * from dbo.sysobjects
  where id = object_id(N'[dbo].[TB_BUG_ITEM]')
  and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TB_BUG_ITEM]
go

create table TB_BUG_ITEM(
	ZID            int  not null,                             /*BUG ID*/
	ZTREE_ID       int  not null,                             /*BUG��ĿID*/
	ZPRO_ID        int  not null,                             /*������Ŀ��ĿID*/
	ZTREEPATH      varchar(200) not null,                     /*��Ŀ·��*/ 
	ZTITLE         varchar(200),                             /*��Ŀ����*/
	ZOS            int  not null,                            /*����ϵͳ*/
	ZTYPE          int,                                       /*��������*/
	ZLEVEL         int  not null,                            /*BUG�ڼ�*/
	ZSTATUS        int  not null,                            /*BUG״̬*/
	ZMAILTO        varchar(200),                             /*�ʼ�������,��#13#10�ֿ�*/
	ZOPENEDBY      int  not null,                            /*BUG������*/
	ZOPENEDDATE    datetime not null,                       /*����ʱ��*/
	ZOPENVER       int not null,                             /*��ʱ������İ汾*/
	ZASSIGNEDTO    int,                                       /*���ɸ�*/
	ZSUBASSIGNEDTO int,                                       /*�ӷ��ɸ� 2012-3-30*/
        ZASSIGNEDDATE  datetime,                                 /*����ʱ��*/
	ZRESOLVEDBY    int,                                       /*�����*/
	ZRESOLUTION    int,                                       /*�������*/
	ZRESOLVEDVER   int,                                       /*����İ汾*/
	ZRESOLVEDDATE  datetime,                                  /*�����ʱ��*/
	ZLASTEDITEDBY  int not null,                              /*����޸ĵ���*/
	ZLASTEDITEDDATE datetime not null,                       /*����޸ĵ�ʱ��*/ 
	ZOVERFRACTION  bit not null default 0 ,                  /*=True��ʾ�Ѽǹ�����*/ 
	ZTAGNAME       varchar(100),                              /*��ǩ �����ǩ����;�ŷֿ� */ 
	ZTERM          int ,                                       /*Ҫ������(6)*/
	ZDEMAND_ID     int default -1,                            /*����ID��*/ 
	ZNEDDDATE      datetime,                                  /*Ҫ��ʱ�� Ҫ��������ʱ����*/
	ZVERIFYDATE    datetime,                                  /*���ʱ��*/
	ZVERIFYED      bit not null default 0 ,                  /*�Ƿ�����˹���*/
	ZVERIFNAME     int,                                        /*�����*/
	ZWORKTIME      float default 0,                           /*Ҫ���ڣ�Сʱ��*/
	ZWORKLEVEL     float default 1,                           /*BUG�Ѷ�ϵ��*/
	ZWORKSCORE     float default 0,                           /*�÷�*/
	ZNOTDEMAND     bit not null default 0,                    /*=True ��ʾ������ȷ*/
	
	constraint PK_TB_BUG_ITEM primary key(ZID desc,ZTREE_ID)   
)
go
  --����������޸�����Ϊ���� 
  CREATE  INDEX [TK_BUG_ITEM_LastDate] ON [dbo].[TB_BUG_ITEM]([ZLASTEDITEDDATE] DESC ) ON [PRIMARY]
go

/*BUG�Ļظ���Ϣ*/
if exists (select * from dbo.sysobjects
  where id = object_id(N'[dbo].[TB_BUG_HISTORY]')
  and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TB_BUG_HISTORY]
go

create table TB_BUG_HISTORY(
	ZID            int IDENTITY (1, 1) not null,             /*�ظ� ID*/
	ZBUG_ID        int not null,                             /*BUG��ID*/
	ZUSER_ID       int not null,                             /*�û�ID*/
	ZSTATUS        int not null,                             /*״̬*/ 
	ZACTIONDATE    datetime not null,                        /*ʱ��*/
	ZCONTEXT       text,                                     /*����*/
	ZANNEXFILE_ID  int,                                      /*�������ݣ�������ͼƬ�����ֱ��*/
	ZANNEXFILENAME varchar(50),                              /*��������*/
	ZNOTDEMAND     bit not null default 0,                    /*=True ��ʾ������ȷ*/
	constraint PK_TB_BUG_HISTORY primary key(ZID,ZBUG_ID)   
)
go

/*BUG������*/
if exists (select * from dbo.sysobjects
  where id = object_id(N'[dbo].[TB_BUG_PARAMS]')
  and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TB_BUG_PARAMS]
go

create table TB_BUG_PARAMS(
	ZTYPE 	     int not null,                                   /*����*/
	ZID          int not null,                                   /*IDֵ*/
	ZNAME        varchar(200)                                    /*ֵ*/
	constraint PK_TB_BUG_PARAMS primary key(ZTYPE,ZID)  
)
go


/*ÿ��һ��*/
if exists (select * from dbo.sysobjects
  where id = object_id(N'[dbo].[TB_TODAYSAY]')
  and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TB_TODAYSAY]
go

create table TB_TODAYSAY(
	ZID          int IDENTITY (1, 1) not null,                   /*IDֵ,�Զ���������*/
	ZNAME        varchar(200),                                   /*����*/
	ZDATE        datetime,                                       /*����ʱ��*/
	ZSTOP        bit default 1                                   /*ֹͣ 1=True 0=False*/                 
	constraint PK_TB_TODAYSAY primary key(ZID)  
)
go

/*ϵͳ������*/
if exists (select * from dbo.sysobjects
  where id = object_id(N'[dbo].[TB_SYSPARAMS]')
  and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TB_SYSPARAMS]
go

create table TB_SYSPARAMS(
	ZNAME        varchar(20),                                   /*����*/
	ZVALUE       varchar(200),
	ZREMARK      varchar(100)                                   /*��ע*/ 
	constraint PK_TB_SYSPARAMS primary key(ZNAME)  
)
go

/*##########################################################
 #
 # ���Ա� 
 #
 ###########################################################*/

/*��������*/
if exists (select * from dbo.sysobjects
  where id = object_id(N'[dbo].[TB_TEST_ITEM]')
  and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TB_TEST_ITEM]
go

create table TB_TEST_ITEM(
	ZID          int not null,                                  /*���*/
	ZNAME        varchar(20),                                   /*����*/
	ZSTATUS      int not null,                                  /*״̬=3*/
	ZOPENEDBY    int not null,                                  /*������*/
	ZOPENEDDATE  datetime not null,                             /*����ʱ��*/
	ZLEVEL       int,                                           /*���ȼ�=0*/
	ZTYPE        int,                                           /*Ҫ���Ե�����=1*/
	ZASSIGNEDTO  int,                                           /*ָ�ɸ�*/
	ZRESULT      int,                                           /*���Խ��*/
	ZTESTRESULTBY int not null,                                 /*���Խ����,���ִ�е���*/
	ZRESULTDATE  datetime not null,                             /*�����Ե�ʱ��*/
	ZTESTMETHOD  int,                                           /*���Է���=2*/
	ZCASEBUG     varchar(50),                                   /*���bug*/
	ZCASETASK    varchar(50),                                   /*�������*/
	ZMAILTO      varchar(100),                                  /*�ʼ�֪ͨ*/
	ZSUBMISBY    int,                                           /*�ύ��*/
	ZTESTNOTE    text,                                          /*���Ժ���˵��*/
	
	--���Ե���Ŀ	
	ZPRO_ID      int,                                           /*��ĿID*/
	ZPRO_VER     int,                                           /*��Ŀ�汾*/
	ZPRO_SVN     int,                                           /*svn�İ汾��*/
	ZREMORK      varchar(200),                                  /*��ע*/

	--�ر�״̬ ���ߣ������� 2008-11-29
	ZCLOSESTATUS int ,                                          /*0=�� 1=�� 2=һ�� 3=��Ч 4=�۷�*/
	ZCLOSESOCRE  int not null default 0,                        /*��ֵ,��Ҫ��������*/
	ZTAGNAME       varchar(100),                                /*��ǩ �����ǩ����;�ŷֿ� */
	ZDEMAND_ID     int default -1,                              /*����ID��*/  
	

	constraint PK_TB_TEST_ITEM primary key(ZID)  
)
go

/*TEST�Ļظ���Ϣ*/
if exists (select * from dbo.sysobjects
  where id = object_id(N'[dbo].[TB_TEST_RESULT]')
  and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TB_TEST_RESULT]
go

create table TB_TEST_RESULT(
	ZID            int IDENTITY (1, 1) not null,             /*ID*/
	ZTEST_ID       int not null,                             /*TEST��ID*/
	ZACTION        varchar(100),                             /*���붯��*/ 
	ZTRUEVALUE     varchar(100),                             /*��������������������*/ 
	ZINFACE        varchar(100),                             /*ʵ��ֵ*/
	ZPASS          bit not null default 0,                   /*�Ƿ�ͨ��*/ 
	ZUSER_ID       int ,                                     /*������*/
	constraint PK_TB_TEST_HISTORY primary key(ZID,ZTEST_ID)   
)
go

/*���Բ�����*/
if exists (select * from dbo.sysobjects
  where id = object_id(N'[dbo].[TB_TEST_PARAMS]')
  and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TB_TEST_PARAMS]
go

create table TB_TEST_PARAMS(
	ZTYPE 	     int not null,                                   /*����*/
	ZID          int not null,                                   /*IDֵ*/
	ZNAME        varchar(200)                                    /*ֵ*/
	constraint PK_TB_TEST_PARAMS primary key(ZTYPE,ZID)  
)
go

/*##########################################################
 #
 # ��Ŀ���ȹ��� PLAN
 #
 ###########################################################*/


/*�ƻ�����*/
if exists (select * from dbo.sysobjects
  where id = object_id(N'[dbo].[TB_PLAN]')
  and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TB_PLAN]
go

create table TB_PLAN(
	ZGUID        varchar(36) not null,                          /*���*/
	ZID          int IDENTITY (1, 1) not null,                  /*IDֵ*/
	ZNAME        varchar(20),                                   /*����*/
	ZSTATUS      int not null,                                  /*״̬=5(�ر�)*/
	ZPRO_ID      int ,                                          /*��Ӧ����ĿID��*/
	ZSUMTEXT     text,                                          /*��Ŀ����ܽ�*/
	ZPM          int ,                                          /*��Ŀ����*/
	ZBUILDDATE   datetime,                                      /*����ʱ��*/
	ZMEMBER      varchar(200),                                  /*��Ŀ��Ա,��������Ϊ�ʼ�֪ͨ*/ 
	

	constraint PK_TB_PLAN primary key(ZGUID)  
)
go

/*�ƻ�����*/

if exists (select * from dbo.sysobjects
  where id = object_id(N'[dbo].[TB_PLAN_ITEM]')
  and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TB_PLAN_ITEM]
go

create table TB_PLAN_ITEM(
	ZGUID        varchar(36) not null,                          /*���*/
	ZPLAN_GUID   varchar(36) not null,                          /*�ƻ���ĿGUID*/
	ZNAME        varchar(255),                                  /*����*/
	ZSTATUS      int not null,                                  /*״̬=5(�ر�)*/
	ZPBDATE      datetime,                                      /*�ƻ���ʼʱ��*/
	ZPEDATE      datetime,                                      /*�ƻ�����ʱ��*/
	ZFBDATE      datetime,                                      /*ʵ�ʿ�ʼʱ��*/
	ZFEDATE      datetime,                                      /*ʵ�ʽ���ʱ��*/
	ZCHILDCOUNT  int not null default 0,                        /*��������*/
	ZPASSCOUNT   int not null default 0,                        /*�����������*/
	ZMAINDEVE    int ,                                          /*��Ҫ������*/
	ZSORT        int ,                                          /*�����*/ 
	ZREMARK      varchar(255),                                  /*��ע*/
	ZPROJECTTIME float default 0,                               /*����*/
	ZCREATEDATE  datetime,                                      /*��������*/ 
	ZMAILTO      varchar(200),                                  /*�ʼ�֪ͨ������*/
	

	constraint PK_TB_PLAN_ITEM primary key(ZGUID,ZPLAN_GUID)  
)
go

/*�ƻ���ϸ�� detail*/
if exists (select * from dbo.sysobjects
  where id = object_id(N'[dbo].[TB_PLAN_DETAIL]')
  and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TB_PLAN_DETAIL]
go

create table TB_PLAN_DETAIL(
	ZID          int not null,                                  /*���*/
	ZITEM_GUID   varchar(36) not null,                          /*�ƻ���ĿGUID*/
	ZNAME        varchar(255),                                  /*����*/
	ZSTATUS      int not null,                                  /*״̬=5(�ر�)*/
	ZDEVE        int ,                                          /*������*/
	ZCONTENT     text,                                          /*Ҫ������*/
	ZSOCRE       int,                                           /*�÷�*/
	ZTESTCASE    varchar(100),                                  /*�������� �������;�ŷֿ�*/

	constraint PK_TB_PLAN_DETAIL primary key(ZID)  
)
go

/*�ƻ�������*/
if exists (select * from dbo.sysobjects
  where id = object_id(N'[dbo].[TB_PLAN_PARAMS]')
  and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TB_PLAN_PARAMS]
go

create table TB_PLAN_PARAMS(
	ZTYPE 	     int not null,                                   /*����*/
	ZID          int not null,                                   /*IDֵ*/
	ZNAME        varchar(200)                                    /*ֵ*/
	constraint PK_TB_PLAN_PARAMS primary key(ZTYPE,ZID)  
)
go


/*�Զ�������Ŀ*/
if exists (select * from dbo.sysobjects
  where id = object_id(N'[dbo].[TB_ANT]')
  and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TB_ANT]
go

create table TB_ANT(
	ZGUID varchar(36) not null,       --GUID 
	ZID  int IDENTITY (1, 1) not null,
	ZNAME varchar(200),
	ZPRO_ID  int ,                   --��Ӧ����Ŀ
	ZIP varchar(20) not null,        --IP
	ZPYFILE varchar(200) not null,   --python�ļ�
	ZREMARK text ,                   --����˵��
	ZDATE datetime,                  --����ʱ��
	ZSVN int,                        --SVN�汾�� 
	ZVERSION varchar(20),            --�汾��(����汾��)
	ZSVN_URL varchar(200),           --��ʾSVN��־�Ľű� URL
	ZSVN_LATEST_VERSION int,         --SVN�������ϵİ汾��
	ZCOMPILETEXT text,               --����ı�����Ϣ
	ZLANGTYPE int default 0,         -- 0 = Delphi 1=Java 2012-6-30
	ZWEBURL varchar(200),            -- web��Ŀ��url·��������ֱ������ȥ 2012-6-30 
	ZLOCALSVNBAT varchar(200),       --svn����bat�ļ���
	ZCOMPLIEPARAM varchar(100),      --���������ת��������������Ҫ�����ĸ���ģ�� 2013-8-8

	
	
	constraint PK_TB_ANT primary key(ZGUID)  
)
go

/*������־ 2013-6-20*/
create table TB_ANT_LOG(
	ZID  int IDENTITY (1, 1) not null,
	ZANT_GUID varchar(36) not null,
	ZPRO_ID int,        --��Ӧ����Ŀ
	ZUSER_ID int ,      --˭�ڱ���
	ZVERSION int,       --����汾��
	ZDATE  datetime,    --����ʱ��
	ZLOG text,          --������־������ǽ�����У���Ҫ̫�ֻ࣬�ǳ�������� 

	constraint PK_TB_ANT_LOG primary key(ZID,ZANT_GUID) 
)
go

/*��ǩ*/
if exists (select * from dbo.sysobjects
  where id = object_id(N'[dbo].[TB_TAG]')
  and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TB_TAG]
go

create table TB_TAG(
	ZID            int IDENTITY (1, 1) not null,  
	ZNAME varchar(20),                    --����
	ZCOLOR int ,                          --��ɫ
	constraint PK_TB_TAG primary key(ZNAME)  
)
go


/*��������*/
if exists (select * from dbo.sysobjects
  where id = object_id(N'[dbo].[TB_RELEASE_ITEM]')
  and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TB_RELEASE_ITEM]
go

create table TB_RELEASE_ITEM(
	ZID          int not null,            --ID��Ϊ����
	ZNAME        varchar(200),            --����
	ZVERSION     varchar(30),             --�汾��  
	ZPRO_ID      int ,                    --��Ӧ���ĸ���Ŀ
	ZASSIGNEDTO  int ,                    --ָ�ɸ�˭����
	ZRELEASEDATE datetime not null,       --����ʱ��
	ZOPENEDBY    int ,                    --������
	ZOPENDATE    datetime not null,       --����ʱ��
	ZNEEDTERM    int,                     --Ҫ�󷢲�������(0), ����0 ����1, ����2������3,�пվ��ϴ�4��
	ZURLTYPE     int not null,            --����·��(1), 0 ��վ , 1 FTP 2 ��������    
	ZURL         varchar(200),            --�����ı���·��
	ZPRODUCTURL  varchar(200),            --��Ʒ��·��
	ZPROCONTENT  text,                    --��Ʒ���ݡ�
	ZMAILTO      varchar(200),            --�ʼ�֪ͨ
	ZSTATUS      int not null,            --״̬(2) , 0 ���� 1 �������ϴ���
	ZRELEASER    int ,                    --�ϴ���
	ZBACKUP      bit ,                    --�Ƿ�Ҫ�����ļ�  
	constraint PK_TB_RELEASE_ITEM primary key(ZID)  
)
go


/*�������������*/
if exists (select * from dbo.sysobjects
  where id = object_id(N'[dbo].[TB_RELEASE_PARAMS]')
  and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TB_RELEASE_PARAMS]
go

create table TB_RELEASE_PARAMS(
	ZTYPE 	     int not null,                                   /*����*/
	ZID          int not null,                                   /*IDֵ*/
	ZNAME        varchar(200)                                    /*ֵ*/
	constraint PK_TB_RELEASE_PARAMS primary key(ZTYPE,ZID)  
)
go



/*SVN�ӽ�������*/
if exists (select * from dbo.sysobjects
  where id = object_id(N'[dbo].[TB_SVN_COMMITS]')
  and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TB_SVN_COMMITS]
go

create table TB_SVN_COMMITS(
	ZSVN_GUID    varchar(36) not null,                           
	ZVERSION     int not null,                                   
	ZID          int IDENTITY (1, 1) not null,                   /*���������Ⱥ�*/
	ZAUTHOR      varchar(50),                                    /*����*/
	ZDATE        datetime,
	ZMESSAGE     text
	constraint PK_TB_SVN_COMMITS primary key(ZSVN_GUID,ZVERSION)  
)
go

/*SVN�ӽ�����ϸ*/
if exists (select * from dbo.sysobjects
  where id = object_id(N'[dbo].[TB_SVN_CHANGES]')
  and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TB_SVN_CHANGES]
go

create table TB_SVN_CHANGES(
	ZSVN_GUID    varchar(36) not null,                           
	ZVERSION     int not null,                                   /*�汾��*/
	ZID          int IDENTITY (1, 1) not null,
	ZACTION      varchar(10),                                    /*����*/
	ZPATH        varchar(200),
	ZCOPY_PATH   varchar(200),
	ZCOPY_VERSION int,

	constraint PK_TB_SVN_CHANGES primary key(ZSVN_GUID,ZVERSION,ZID)  
)
go

/*״̬��*/
if exists (select * from dbo.sysobjects
  where id = object_id(N'[dbo].[TB_STATE]')
  and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TB_STATE]
go

create table TB_STATE(
	ZID          int ,         /*=0��ʾ��Ŀ����*/
	ZSTATECODE   int,          /*״̬�� =0 ��ʾ��ʼ =1��ʾ������ =2 ��������*/ 
	ZUSER_ID     int ,         /*��������*/
	ZSTATETIME   datetime,     /*����������ʱ��*/
	ZNOTE        varchar(200), /*��ע*/
	
	constraint PK_TB_STATE primary key(ZID)
)
go

/*�Ӱ൥����*/
if exists (select * from dbo.sysobjects
  where id = object_id(N'[dbo].[TB_WORKOVERTIME]')
  and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TB_WORKOVERTIME]
go

create table TB_WORKOVERTIME(
	ZID           int IDENTITY (1, 1) not null,/*=�Ӱ�ID*/
	ZUSER_ID      int,                         /*�Ӱ���*/
	ZDATE         varchar(20),                 /*����*/
	ZDATETIME     datetime,                    /*�Ӱ�Ŀ�ʼʱ��* ���Ŀǰ�ǹ̶����� ����6:00*/
	ZLASTDATETIME datetime,                    /*�Ӱ���°�ʱ��*/
	ZADDRESS      varchar(50),                 /*�Ӱ�ĵص�*/
	ZCONTENT      text,                        /*�Ӱ������*/
	ZCHECK_USER_ID int default -1,             /*�����ID��û�������=-1*/
	ZMINUTE        int default 0,              /*�Ӱ�ķ���*/ 
	ZSTATUS        int not null,               /*״̬=0 ���� 1=ͬ�� 2=��ͬ�� 3=�ϵ�*/
	ZWEEKEND       bit default 0,              /*�Ƿ�����ĩ��ڼ��ռӰ�*/
	ZBUILDDATE    datetime,                    /*�Ƶ�ʱ��*/
	ZDECTIME      int default 0,               /*��ȥ���� ����Ч������ */
	ZRATE         float,                       /*ϵ��*/
	
	constraint PK_TB_WORKOVERTIME primary key(ZID)
)
go

/*�Ӱ൥������*/
if exists (select * from dbo.sysobjects
  where id = object_id(N'[dbo].[TB_WORKOVERTIME_PARAMS]')
  and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TB_WORKOVERTIME_PARAMS]
go

create table TB_WORKOVERTIME_PARAMS(
	ZTYPE 	     int not null,                                   /*����*/
	ZID          int not null,                                   /*IDֵ*/
	ZNAME        varchar(200)                                    /*ֵ*/
	constraint PK_TB_WORKOVERTIME_PARAMS primary key(ZTYPE,ZID)  
)
go

/*�������*/
if exists (select * from dbo.sysobjects
  where id = object_id(N'[dbo].[TB_DEMAND]')
  and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TB_DEMAND]
go

create table TB_DEMAND(
	ZID            int  not null,              /*����ID*/
	ZNAME         varchar(100),                /*��������*/    
	ZUSER_ID      int,                         /*������д��*/
	ZBUILDDATE    datetime,                    /*�Ƶ�ʱ��*/
	ZCONTENT      text,                        /*��������*/
	ZNEEDDATE     datetime,                    /*Ҫ��ʱ��*/
	ZISRESET      bit,                         /*�Ƿ��ѱ����*/    
	ZPRO_ID       int,                         /*���������Ŀ*/
	ZCUSTOMER     text,                        /*�ͻ���Ϣ*/
	ZANNEXFILE_ID  int,                        /*�������ݣ�������ͼƬ�����ֱ��*/
	ZANNEXFILENAME varchar(50),                /*��������*/
	ZSTATUS        int not null,               /*״̬=0 �Ƶ� 1=���� 2=�ܾ� 3=�ѱ��*/
	ZCHECK_USER_ID int ,                       /*�����*/
	ZMAILTO        varchar(200),               /*�ʼ�������,��#13#10�ֿ�*/
	ZREMARK        text,                       /*��ע*/
	
	constraint PK_TB_DEMAND primary key(ZID)
)
go

/*������������*/
if exists (select * from dbo.sysobjects
  where id = object_id(N'[dbo].[TB_DEMAND_PARAMS]')
  and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TB_DEMAND_PARAMS]
go

create table TB_DEMAND_PARAMS(
	ZTYPE 	     int not null,                                   /*����*/
	ZID          int not null,                                   /*IDֵ*/
	ZNAME        varchar(200)                                    /*ֵ*/
	constraint PK_TB_DEMAND_PARAMS primary key(ZTYPE,ZID)  
)
go

/*��չwebӦ�� */
if exists (select * from dbo.sysobjects
  where id = object_id(N'[dbo].[TB_EXTENDWEB]')
  and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TB_EXTENDWEB]
go

create table TB_EXTENDWEB(
	ZTYPE 	     int not null,                                   /*���� 0=rul 1=html*/
	ZID          int IDENTITY (1, 1) not null,                   /*IDֵ*/
	ZNAME        varchar(50),                                    /*����*/
	ZVALUE       text,                                           /*ֵ*/  
	ZSORT        int,                                            /*�����*/
	constraint PK_TB_EXTENDWEB primary key(ZID)  
)
go


/*���չ���*/
if exists (select * from dbo.sysobjects
  where id = object_id(N'[dbo].[TB_TODAYRESULT]')
  and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TB_TODAYRESULT]
go

create table TB_TODAYRESULT(
	ZID          int IDENTITY (1, 1) not null,                   /*����*/
	ZTYPE 	     int not null,                                   /*���� 0=�������� 1=bug 2=svn 3=���� 4=�ٱ� */
	ZUSER_ID     int not null,                                   /*˭�Ĺ���*/
	ZDATETIME    datetime,                                       /*����ʱ��,����ʱ��*/
	ZCONTENTID   int,                                            /*���ǲ���������дID,bug��дbug*/
	ZCONTENT     varchar(200),                                   /*����*/
	ZNOTE        text,                                           /*ԭ��*/
	ZWRITER      int,                                            /*����ϵͳд*/
	ZACTION      int,                                            /*=0 ��ʾ�Ǽ���� 1=����ӷֵ�*/
	ZSCORE       float,                                          /*�÷�,�Կ������õ� 2012-6-30*/
	
	constraint PK_TB_TODAYRESULT primary key(ZID)  
)
go

/*��־��*/
if exists (select * from dbo.sysobjects
  where id = object_id(N'[dbo].[TB_LOG]')
  and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TB_LOG]
go

create table TB_LOG(
	ZID          int IDENTITY (1, 1) not null,                   /*����*/
	ZUSER_ID     int not null,                                   /*˭*/
	ZDATETIME    datetime,                                       /*ʱ��*/
	ZCONTENT     varchar(200),                                   /*����*/
	
	constraint PK_TB_LOG primary key(ZID)  
)
go


/*��Ϣ��*/
if exists (select * from dbo.sysobjects
  where id = object_id(N'[dbo].[TB_MSG]')
  and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TB_MSG]
go

create table TB_MSG(
	ZID          int IDENTITY (1, 1) not null,                   /*����*/
	ZUSER_ID     int not null,                                   /*����˭*/
	ZDATETIME    datetime,                                       /*ʱ��*/
	ZCODE        int ,                                           /*���ݵ�ID������Bug����bug��Code*/ 
	ZCONTENT     varchar(200),                                   /*����*/
	ZTYPE        int,                                            /*���� 0=bug , 1=��������*/
	ZSEND_ID     varchar(200),                                   /*�ĸ��ˣ��������|�ֿ�*/
	
	constraint PK_TB_MSG primary key(ZID)  
)
go


/*�����*/
create table TB_QUESTION_CLASS(
	ZGUID varchar(36) not null,
	ZCODE varchar(20) not null,    --����
	ZTITLE varchar(200),           --����Ҫ��
	ZNOTE varchar(250) ,           --������� 
	ZPOWER varchar(250),           --�����;�ֿ����û����ƣ���ʾ��Ȩ��������Ŀ
	ZSORT int default 0,           --�����

	constraint PK_TB_QUESTIONCLASS primary key(ZGUID)  	
)
go

/*������ݱ�*/
create table TB_QUESTION(
	ZCLASS_GUID varchar(36) not null,  --����GUID
	ZQCODE varchar(50) not null,       --��Ŀ�����,������Զ����ɵ�. ZCODE-0001 �ĸ�ʽ.
	ZQTITLE varchar(200) not null,     --��Ŀ�ı���
	ZQCENTENT text ,                   --��Ŀ������
	ZANSWER text,                      --��
	ZUSER_ID int  not null,            --������ID
	ZDATETIME datetime,                --����ʱ��
	ZSTOP bit default 0,               --=Ture ��ʾ����ʹ��
	ZIDX int default 1,                --������, �������� ZCODE-0001 ���������

	constraint PK_TB_QUESTION primary key(ZCLASS_GUID,ZQCODE) 
)
go

/*�ȼ���Ӧ������*/
create table TB_QUESTION_DEVELEVEL(
	ZID       int IDENTITY (1, 1) not null,	 --����
	ZDEVENAME  varchar(50) not null,         --�ȼ�����
	ZSORT     int default 0,                 --�����
	ZQUCLASS_CODE_1 varchar(20),
	ZQUCLASS_NUM_1 int default 0,
	ZQUCLASS_SCORE_1 int default 0,         --ÿ���÷�

	ZQUCLASS_CODE_2 varchar(20),
	ZQUCLASS_NUM_2 int default 0,
	ZQUCLASS_SCORE_2 int default 0,

	ZQUCLASS_CODE_3 varchar(20),
	ZQUCLASS_NUM_3 int default 0,
	ZQUCLASS_SCORE_3 int default 0,

	ZQUCLASS_CODE_4 varchar(20),
	ZQUCLASS_NUM_4 int default 0,
	ZQUCLASS_SCORE_4 int default 0,

	ZQUCLASS_CODE_5 varchar(20),
	ZQUCLASS_NUM_5 int default 0,
	ZQUCLASS_SCORE_5 int default 0,

	ZQUCLASS_CODE_6 varchar(20),
	ZQUCLASS_NUM_6 int default 0,
	ZQUCLASS_SCORE_6 int default 0,

	ZQUCLASS_CODE_7 varchar(20),
	ZQUCLASS_NUM_7 int default 0,
	ZQUCLASS_SCORE_7 int default 0,

	ZQUCLASS_CODE_8 varchar(20),
	ZQUCLASS_NUM_8 int default 0,
	ZQUCLASS_SCORE_8 int default 0,

	ZQUCLASS_CODE_9 varchar(20),
	ZQUCLASS_NUM_9 int default 0,
	ZQUCLASS_SCORE_9 int default 0,

	ZQUCLASS_CODE_10 varchar(20),
	ZQUCLASS_NUM_10 int default 0,
	ZQUCLASS_SCORE_10 int default 0,

	constraint PK_TB_QUESTION_DEVELEVEL primary key(ZID) 

)
go

/*��Ʒԭ��*/
/*������ݱ�*/
create table TB_PROTOTYPE(
	PRTY_GUID varchar(36) not null,    --��Ʒԭ�͵�GUID
	PRTY_NAME varchar(200) not null,   --ԭ������
	ZUSER_ID int  not null,            --������ID
	PRTY_DATETIME datetime,            --����ʱ��
	PRTY_DIRNAME varchar(100),         --Ŀ¼����,����ָ��������ļ���ַ
  	
	constraint PK_TB_PROTOTYPE primary key(PRTY_GUID) 
)
go


















