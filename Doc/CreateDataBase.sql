/*******************************************************
 *
 *  BFSS 
 *
 * ����: ������  ����:2007-10-26 
 *
 *
 *
 ******************************************************/

/*�ļ���*/
create table TB_FILE_TREE(
	ZID	int not null,
	ZNAME	VarChar(20) not null,
	ZMONTHVOLUME int default 0,             /* �������������ֵ���ޣ� */
constraint PK_TB_MEDIA  primary key (ZID)
)
go

