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
        ZSTYPE         int not null,           /*���ͣ����ļ�����bug������Ŀ�ĵ�*/ 
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
	ZTESTTEAM      varchar(100),                             /*����С���Ա ��ʽ ����(���) ,�����Զ����ɲ�������.     
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

	ZBEGINDATE      datetime,	                        /*����ʼʱ�� ������ִ��������,��ʱ״̬���Ϊִ����*/
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
	ZID				int IDENTITY (1, 1) not null,
	ZTASK_CODE		varchar(30) not null,
	ZDATE			datetime,
	ZDESIGN         text,									/*����˵��*/
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
	ZTITLE         varchar(200),                              /*��Ŀ����*/
	ZOS            int  not null,                             /*����ϵͳ*/
	ZTYPE          int,                                       /*��������*/
	ZLEVEL         int  not null,                             /*BUG�ڼ�*/
	ZSTATUS        int  not null,                             /*BUG״̬*/
	ZMAILTO        varchar(200),                              /*�ʼ�������,��#13#10�ֿ�*/
	ZOPENEDBY      int  not null,                             /*BUG������*/
	ZOPENEDDATE    datetime not null,                         /*����ʱ��*/
	ZOPENVER       int not null,                              /*��ʱ������İ汾*/
	ZASSIGNEDTO    int,                                       /*���ɸ�*/
        ZASSIGNEDDATE  datetime,                                  /*����ʱ��*/
	ZRESOLVEDBY    int,                                       /*�����*/
	ZRESOLUTION    int,                                       /*�������*/
	ZRESOLVEDVER   int,                                       /*����İ汾*/
	ZRESOLVEDDATE  datetime,                                  /*�����ʱ��*/
	ZLASTEDITEDBY  int not null,                              /*����޸ĵ���*/
	ZLASTEDITEDDATE datetime not null,                        /*����޸ĵ�ʱ��*/ 
	ZOVERFRACTION  bit not null default 0                     /*=True��ʾ�Ѽǹ�����*/ 
	
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
	
	--���Ե���Ŀ	
	ZPRO_ID      int,                                           /*��ĿID*/
	ZPRO_VER     int,                                           /*��Ŀ�汾*/
	ZPRO_SVN     int,                                           /*svn�İ汾��*/
	ZREMORK      varchar(200),                                  /*��ע*/

	--�ر�״̬ ���ߣ������� 2008-11-29
	ZCLOSESTATUS int ,                                          /*0=�� 1=�� 2=һ�� 3=��Ч 4=�۷�*/
	ZCLOSESOCRE  int not null default 0,                        /*��ֵ,��Ҫ��������*/
	

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













