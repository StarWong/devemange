/******************************************************************************
*
*         �����ļ�������
*         �ļ�����BFSS_TABLES.SQ  �汾��1.0
*         ���ݿ���ڻ�����
*         �������ڣ�2007-11-9    ����:������
*
******************************************************************************/


insert into TB_USER_ITEM (ZNAME,ZPASS,ZSTOP,ZTYPE) values('admin','123456',0,0);
insert into TB_FILE_TREE (ZPID,ZNAME,ZHASCHILD) values(-1,'$/',0);
insert into TB_PRO_DOCUMENT (ZPID,ZNAME,ZSTYLE,ZHASCHILD) values(-1,'$/',0,0);

/*######################
 #BUG����
 ######################*/
/*BUG��״̬*/
insert into TB_BUG_PARAMS (ZTYPE,ZID,ZNAME) values(1,0,'�');
insert into TB_BUG_PARAMS (ZTYPE,ZID,ZNAME) values(1,1,'�޸����');
insert into TB_BUG_PARAMS (ZTYPE,ZID,ZNAME) values(1,2,'������');
/*BUG�Ľ������*/
insert into TB_BUG_PARAMS (ZTYPE,ZID,ZNAME) values(2,0,'�޸�');
insert into TB_BUG_PARAMS (ZTYPE,ZID,ZNAME) values(2,1,'�������⣬���޸�');
insert into TB_BUG_PARAMS (ZTYPE,ZID,ZNAME) values(2,2,'��ʱ���޸�');
/*BUG����ϵͳ*/
insert into TB_BUG_PARAMS (ZTYPE,ZID,ZNAME) values(3,0,'win98');
insert into TB_BUG_PARAMS (ZTYPE,ZID,ZNAME) values(3,1,'win2000');
insert into TB_BUG_PARAMS (ZTYPE,ZID,ZNAME) values(3,2,'xp');
insert into TB_BUG_PARAMS (ZTYPE,ZID,ZNAME) values(3,3,'vista');
/*BUG������*/
insert into TB_BUG_PARAMS (ZTYPE,ZID,ZNAME) values(4,0,'�������');
insert into TB_BUG_PARAMS (ZTYPE,ZID,ZNAME) values(4,1,'�������');
insert into TB_BUG_PARAMS (ZTYPE,ZID,ZNAME) values(4,2,'��Ʊ��');
insert into TB_BUG_PARAMS (ZTYPE,ZID,ZNAME) values(4,3,'��������');
insert into TB_BUG_PARAMS (ZTYPE,ZID,ZNAME) values(4,4,'����У��');
insert into TB_BUG_PARAMS (ZTYPE,ZID,ZNAME) values(4,5,'�������');
insert into TB_BUG_PARAMS (ZTYPE,ZID,ZNAME) values(4,6,'���԰���');
/*BUG�ȼ�*/
insert into TB_BUG_PARAMS (ZTYPE,ZID,ZNAME) values(5,0,'���ش���');
insert into TB_BUG_PARAMS (ZTYPE,ZID,ZNAME) values(5,1,'һ�����');
insert into TB_BUG_PARAMS (ZTYPE,ZID,ZNAME) values(5,2,'�ɲ��Ĵ���');

/*����״̬*/
insert into TB_TASK_PARAMS (ZTYPE,ZID,ZNAME) values(1,0,'���ַ�');
insert into TB_TASK_PARAMS (ZTYPE,ZID,ZNAME) values(1,1,'ִ����');
insert into TB_TASK_PARAMS (ZTYPE,ZID,ZNAME) values(1,2,'����');
insert into TB_TASK_PARAMS (ZTYPE,ZID,ZNAME) values(1,3,'���');
insert into TB_TASK_PARAMS (ZTYPE,ZID,ZNAME) values(1,4,'�ر�');
insert into TB_TASK_PARAMS (ZTYPE,ZID,ZNAME) values(1,5,'����');
/*��������*/
insert into TB_TASK_PARAMS (ZTYPE,ZID,ZNAME) values(2,0,'��������');
insert into TB_TASK_PARAMS (ZTYPE,ZID,ZNAME) values(2,1,'�������');
/*ϵͳ����*/
insert into TB_SYSPARAMS (ZNAME,ZVALUE) values('wiki','');
insert into TB_SYSPARAMS (ZNAME,ZVALUE) values('ProductDownload','');
insert into TB_SYSPARAMS (ZNAME,ZVALUE) values('Calendar','');

/*���Բ���*/
insert into TB_TEST_PARAMS (ZTYPE,ZID,ZNAME) values(0,0,'һ��');
insert into TB_TEST_PARAMS (ZTYPE,ZID,ZNAME) values(0,1,'����');
insert into TB_TEST_PARAMS (ZTYPE,ZID,ZNAME) values(0,2,'����');
insert into TB_TEST_PARAMS (ZTYPE,ZID,ZNAME) values(0,3,'�ļ�');
--���Ե�����
insert into TB_TEST_PARAMS (ZTYPE,ZID,ZNAME) values(1,0,'���ܲ���');
insert into TB_TEST_PARAMS (ZTYPE,ZID,ZNAME) values(1,1,'�������');
insert into TB_TEST_PARAMS (ZTYPE,ZID,ZNAME) values(1,2,'��Ԫ����');
--���Է���=2
insert into TB_TEST_PARAMS (ZTYPE,ZID,ZNAME) values(2,0,'�ںв���');
insert into TB_TEST_PARAMS (ZTYPE,ZID,ZNAME) values(2,1,'�ű�����');
--����״̬ZSTATUS
insert into TB_TEST_PARAMS (ZTYPE,ZID,ZNAME) values(3,0,'�');
insert into TB_TEST_PARAMS (ZTYPE,ZID,ZNAME) values(3,1,'�޸����');
insert into TB_TEST_PARAMS (ZTYPE,ZID,ZNAME) values(3,2,'������');
insert into TB_TEST_PARAMS (ZTYPE,ZID,ZNAME) values(3,3,'�ر�');

GO