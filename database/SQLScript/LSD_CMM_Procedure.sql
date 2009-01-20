/**********************************************************
 *
 * �����洢����
 *
 * ����: ������ ʱ��: 2007-11-22
 *
 *
 *********************************************************/


/*��ҳͨ�ô���*/
CREATE PROCEDURE pt_SplitPage 
	@tblName      varchar(255),            -- ����
	@strGetFields varchar(1000) = '*',     -- ��Ҫ���ص��� 
	@fldName      varchar(255)='',         -- ������ֶ���
	@PageSize     int = 20,                -- ҳ�ߴ�
	@PageIndex    int = 1,                 -- ҳ��
	@doCount      bit = 0,                 -- ���ؼ�¼����, �� 0 ֵ�򷵻�
	@OrderType    bit = 0,                 -- ������������, �� 0 ֵ����
	@strWhere     varchar(1500) = ''       -- ��ѯ���� (ע��: ��Ҫ�� where)
AS

declare @strSQL   varchar(5000)       -- �����
declare @strTmp   varchar(110)        -- ��ʱ����
declare @strOrder varchar(400)        -- ��������

if @doCount != 0
begin
	if @strWhere !=''
		set @strSQL = 'select count(*) as Total from [' + @tblName + '] where '+@strWhere
	else
		set @strSQL = 'select count(*) as Total from [' + @tblName + ']'
end  

--���ϴ������˼�����@doCount���ݹ����Ĳ���0����ִ������ͳ�ơ����µ����д��붼��@doCountΪ0�����

else begin

if @fldName !=''
begin
	if @OrderType != 0  --���@OrderType����0����ִ�н���������Ҫ��
	begin
		set @strTmp = '<(select min'
		set @strOrder = ' order by [' + @fldName +'] desc'
	end
	else begin
		set @strTmp = '>(select max'
    		set @strOrder = ' order by [' + @fldName +'] asc'
	end
end
else begin
	set @strTmp = ''
	set @strOrder = ''
end

--����ǵ�һҳ��ִ�����ϴ��룬������ӿ�ִ���ٶ�
if @PageIndex = 1
begin
	if @strWhere != ''   
		set @strSQL = 'select top ' + str(@PageSize) +' '+@strGetFields+ '  from [' + @tblName 
                               + '] where ' + @strWhere + ' ' + @strOrder
     	else
     		set @strSQL = 'select top ' + str(@PageSize) +' '+@strGetFields+ '  from ['+ @tblName 
                               + '] '+ @strOrder

end
else begin
--���´��븳����@strSQL������ִ�е�SQL����
	set @strSQL = 'select top ' + str(@PageSize) +' '+@strGetFields+ '  from ['
		+ @tblName + '] where [' + @fldName + ']' + @strTmp + '(['+ @fldName + ']) from (select top ' 
                + str((@PageIndex-1)*@PageSize) + ' ['+ @fldName + '] from [' + @tblName + ']' + @strOrder + ') as tblTmp)'+ @strOrder

	if @strWhere != ''
    		set @strSQL = 'select top ' + str(@PageSize) +' '+@strGetFields+ '  from ['
	        + @tblName + '] where [' + @fldName + ']' + @strTmp + '(['
	        + @fldName + ']) from (select top ' + str((@PageIndex-1)*@PageSize) + ' ['
	        + @fldName + '] from [' + @tblName + '] where ' + @strWhere + ' '
	        + @strOrder + ') as tblTmp) and ' + @strWhere + ' ' + @strOrder
	end 
end   
exec (@strSQL)
--print @strSQL

go



/*Bug�������ķ����ʼ�*/
/*
����: 2008-5-21  mrlong
Ŀ��: ȡ��������ʼ�����
�޸ģ�
���   ʱ��         �޸���             �޸�����
*/

CREATE   PROCEDURE pt_MaintoByBug 
@BugID int, --BugID��
@mailtitle varchar(200) output, --���صı���
@mailtext varchar(4000) output --���ص�����
as
declare @TreePath  varchar(200)
declare @Title varchar(200)
declare @Auathor varchar(20)  
declare @BugMaxID int
declare @BugContext varchar(4000)
declare @BugReplay  varchar(20)
begin


--ȡ�����⼰����
declare my_cursor cursor 
for
select a.ZTREEPATH,a.ZTITLE,b.ZNAME from TB_BUG_ITEM as a, TB_USER_ITEM as b where a.ZID=@BugID and
a.ZOPENEDBY=b.ZID

open my_cursor
fetch next from my_cursor into @TreePath,@Title,@Auathor
close   my_cursor  
deallocate my_cursor

--ȡ�ֻظ����ֵ
declare my_cursor cursor
for
select isnull(max(ZID),0)  from TB_BUG_HISTORY where ZBUG_ID=@BugID 
open my_cursor
fetch next from my_cursor into @BugMaxID
close my_cursor
deallocate my_cursor

--ȡ���ظ�����
if @BugMaxID > 0
begin
	declare my_cursor cursor
	for
	select a.ZCONTEXT,b.ZNAME  from TB_BUG_HISTORY as a , TB_USER_ITEM as b where a.ZID=@BugMaxID and
	a.ZUSER_ID=b.ZID
	open my_cursor
	fetch next from my_cursor into @BugContext,@BugReplay
	close my_cursor
	deallocate my_cursor
end

--��ʽ
set @mailtitle = @Title
set @mailtext  = @TreePath  + char(13) +char(10)+
'-------------------------------------------------------------------------------------------' + char(13) + char(10)+
@BugContext + char(13) +char(10)+char(13)+char(10)+
'������:' +  @Auathor + '   �ظ���:' + @BugReplay


end
GO


/*
����: 2008-6-28  ����:������
Ŀ��: ׼�����񵥵��ʼ�����
�޸ģ�
���   ʱ��         �޸���             �޸�����
 1     2008-8-4    ������      ��������˵��ʼ�����

*/

CREATE    PROCEDURE pt_MaintoByTask
@TaskCode  varchar(30), --�����,��Ψһ��
@mailtitle varchar(200) output,   --���صı���
@mailtext varchar(4000) output, --���ص�����
@mailto   varchar(1000) output --���صķ����ʼ�����,�������;�ֿ�

as
declare @ProName  varchar(200) --��Ŀ������
declare @Prover varchar(50) --��Ŀ�İ汾��
declare @Title varchar(200)
declare @Auathor varchar(20)   --�����������
declare @TaskContext varchar(4000) --���������
declare @TaskStatus varchar(20) --����״̬
declare @myMail varchar(50)
declare @CheckMail varchar(50) --����˵�����


begin


--ȡ�����⼰����
declare my_cursor cursor 
for
select  a.ZName as TaskName,b.ZNAME as UserName,c.ZNAME as ProName , d.ZVER , e.ZName as STATUS ,a.ZDESIGN ,b.ZEMAIL,f.ZEMAIL as CheckMail  
from TB_TASK as a
left join  TB_USER_ITEM as b  on a.ZUSER_ID=b.ZID 
left join  TB_PRO_ITEM   as c  on a.ZPRO_ID=c.ZID
left join  TB_PRO_VERSION as d on d.ZID=a.ZPRO_VERSION_ID
left join  TB_TASK_PARAMS as e on e.ZTYPE=1 and e.ZID=a.ZSTATUS 
left join  TB_USER_ITEM as f on a.ZCHECKNAME=f.ZID
where a.ZCODE=@TaskCode 

open my_cursor
fetch next from my_cursor into @mailtitle,@Auathor,@ProName,@Prover,@TaskStatus,@TaskContext,@mailto,@CheckMail
close   my_cursor  
deallocate my_cursor

set @mailto =isnull(@mailto,'')+';' + isnull(@CheckMail,'')

--ȡ�������ִ����,ע��ȡ��ִ����
declare my_cursor cursor
for
select b.ZEMAIL  from TB_TASK_USER as a
left join TB_USER_ITEM as b on a.ZUSER_ID=b.ZID
where a.ZTASK_CODE=@TaskCode and a.ZCANCEL=1 

open my_cursor
fetch next from my_cursor into @myMail
while( @@fetch_status = 0)
begin
  --print @myMail
  set @mailto =isnull(@mailto,'')+';'+@myMail
  fetch next from my_cursor into @myMail
end

close   my_cursor  
deallocate my_cursor

--��ʽ

set @mailtext  = '��Ŀ:' + @ProName + '  �汾:' + @Prover + char(13) + char(10) + 
'����:' + @mailtitle  + char(13) +char(10)+
'״̬:' + @TaskStatus + char(13)+char(10)+
'-------------------------------------------------------------------------------------------' + char(13) + char(10)+
@TaskContext + char(13) +char(10)+char(13)+char(10)+
'���񴴽���:' +  @Auathor 

set @mailtitle =  '��' + @TaskStatus+' ��'+ @mailtitle


end
GO



/*
����: 2008-6-28  ����:������
Ŀ��: ͳ��
�޸ģ�
���   ʱ��         �޸���             �޸�����

*/

CREATE    PROCEDURE pt_StatBugTaskCount
@StatbeginDate datetime,
@StatendDate datetime

as

declare @myUserName varchar(20)
declare @myUser_ID int
declare @c1 int
declare @c2 int
declare @c3 int
declare @c4 int

set @c1=0
set @c2=0
set @c3=0
set @c4=0

--����
if exists(select 1 from sysobjects where id=object_id('temp_stat')and type = 'u')
  drop table temp_stat
  
create table temp_stat
  (
  ZUSERNAME varchar(20),
  ZAnswerBugCount int , --���������� c1
  ZSubmitBugCount  int, --�ύ�������� c2
  ZReplyBugCount int,    --�ظ������� c3
)



--�Ȱ���Ա����б���
declare my_cursor cursor
for
select a.ZNAME,a.ZID  from TB_USER_ITEM as a
where a.ZSTOP=0

open my_cursor
fetch next from my_cursor into @myUserName,@myUser_ID
while( @@fetch_status = 0)
begin
  
------bug
  select @c1= count(a.ZID)   from TB_BUG_ITEM as a 
  where  a.ZRESOLVEDBY=@myUser_ID and a.ZSTATUS=1 --1��ʾ�޸����
  
  select @c2= count(a.ZID)   from TB_BUG_ITEM as a 
  where  a.ZOPENEDBY=@myUser_ID 

  select @c3= count(a.ZID)   from TB_BUG_HISTORY as a 
  where  a.ZUSER_ID=@myUser_ID
------Task
	
  insert into temp_stat(
       ZUSERNAME,
       ZAnswerBugCount,
       ZSubmitBugCount,
       ZReplyBugCount) 
  values(
       @myUserName,
       @c1,
       @c2,
       @c3) 
  fetch next from my_cursor into @myUserName, @myUser_ID
end

close   my_cursor  
deallocate my_cursor

select * from temp_stat
GO


/*
����: 2008-6-28  ����:������
Ŀ��: ͳ��
�޸ģ�
���   ʱ��         �޸���             �޸�����

*/

CREATE    PROCEDURE pt_StatBugTaskCount
@StatbeginDate datetime,
@StatendDate datetime

as

declare @myUserName varchar(20)
declare @myUser_ID int
declare @myUser_Type int --��Ա������ 0=Admin  1=������Ա 2=������Ա,3=������Ա

declare @c1 int
declare @c2 int
declare @c3 int
declare @c4 int
declare @c5 int
declare @c6 int
declare @c7 int
declare @c8 int  --��������������
declare @c9 int --�������������
declare @c10 int 


set @c1=0
set @c2=0
set @c3=0
set @c4=0
set @c5=0
set @c6=0
set @c7=0
set @c8=0
set @c9=0
set @c10=0

--����
if exists(select 1 from sysobjects where id=object_id('temp_stat')and type = 'u')
  drop table temp_stat
  
create table temp_stat
  (
  ZUSERNAME varchar(20) ,
  ZAnswerBugCount int , --���������� c1
  ZSubmitBugCount  int, --�ύ�������� c2
  ZReplyBugCount int,    --�ظ������� c3
  ZReActionBug int,       --���ⱻ������ c4
  ZBugFraction int,          --�������

  ZTaskCount int,            --��ɵ�������
  ZTaskFraction int,         --�������

  ZBuildTestCount  int,  --C8
  ZAnswerTestCount int , --C9
  ZSOCRE int ,  --C10 

  ZTotal int                       --�ܷ�
  
  
)



--�Ȱ���Ա����б���
declare my_cursor cursor
for
select a.ZNAME,a.ZID,a.ZTYPE  from TB_USER_ITEM as a
where a.ZSTOP=0

open my_cursor
fetch next from my_cursor into @myUserName,@myUser_ID,@myUser_Type
while( @@fetch_status = 0)
begin
 
-- 0=Admin  1=������Ա 2=������Ա,3=������Ա
-----------------------------------bug----------------------------------------

  /*�������*/
  select @c1= count(a.ZID)   from TB_BUG_ITEM as a 
  where  a.ZRESOLVEDBY=@myUser_ID and a.ZSTATUS=1 and  --1��ʾ�޸����
              (a.ZRESOLVEDDATE between  @StatbeginDate and  @StatendDate)
         
   /*��������*/
  select @c2= count(a.ZID)   from TB_BUG_ITEM as a   
  where  a.ZOPENEDBY=@myUser_ID and
             (a.ZOPENEDDATE between  @StatbeginDate and  @StatendDate)
  
  /*�ظ�����*/
  select @c3= count(a.ZID)   from TB_BUG_HISTORY as a 
  where  a.ZUSER_ID=@myUser_ID and ( ZSTATUS=0)  and --0��ʾ���
    (a.ZACTIONDATE between @StatbeginDate and  @StatendDate )
 
   /*��������*/
  select @c4=count(a.ZID) from  TB_BUG_ITEM as a 
  where  a.ZSTATUS=2 and (a.ZOVERFRACTION=1) and   --  ZOVERFRACTION =1��ʾ�ѼǷ�
  exists(select * from TB_BUG_HISTORY as b where b.ZSTATUS=2 and b.ZBUG_ID=a.ZID 
          and b.ZUSER_ID= @myUser_ID
           and b.ZACTIONDATE between @StatbeginDate and  @StatendDate)

  /*�������*/  
  select @c5= count(a.ZID)   from TB_BUG_ITEM as a 
  where  a.ZRESOLVEDBY=@myUser_ID and a.ZSTATUS=1 and  --1��ʾ�޸����
             (a.ZOVERFRACTION=0) and
              (a.ZRESOLVEDDATE between  @StatbeginDate and  @StatendDate)

-------------------------------Task--------------------------------------------
  /*�������񵥸���*/
 select @c6=count(a.ZTASK_CODE) from  TB_TASK_USER as a
 where (a.ZUSER_ID=@myUser_ID)  and
  ( a.ZSCOREDATE between @StatbeginDate and  @StatendDate)

  /*����÷�*/
   select @c7=sum(a.ZSCORE) from  TB_TASK_USER as a , TB_TASK as b
 where (a.ZUSER_ID=@myUser_ID)  and (a.ZTASK_CODE=b.ZCODE) and (b.ZSTATUS=4) and
  ( a.ZSCOREDATE between @StatbeginDate and  @StatendDate)

----------------------------Test--------------------------------------------------
  /*��������������*/
   select @c8= count(a.ZID)   from TB_TEST_ITEM as a 
   where  a.ZOPENEDBY=@myUser_ID and
              (a.ZOPENEDDATE between  @StatbeginDate and  @StatendDate)

 /*�������������*/
    select @c9= count(a.ZID)   from TB_TEST_ITEM as a 
    where  a.ZTESTRESULTBY=@myUser_ID and
              (a.ZSTATUS = 3) and --3=�ر�
              (a.ZRESULTDATE between  @StatbeginDate and  @StatendDate)

/*���������÷�*/
   if (@myUser_Type =1) or (@myUser_Type=0)
   begin
      select @c10= sum(a.ZCLOSESOCRE)   from TB_TEST_ITEM as a 
       where  a.ZOPENEDBY=@myUser_ID and
              (a.ZSTATUS = 3) and --3=�ر�
              (a.ZRESULTDATE between  @StatbeginDate and  @StatendDate)
   end
   else begin
      select @c10 = @c9
   end
  	
  insert into temp_stat(
       ZUSERNAME,
       ZAnswerBugCount,
       ZSubmitBugCount,
        ZReplyBugCount,
       ZReActionBug,
       ZBugFraction,

      ZTaskCount,
       ZTaskFraction,

     ZBuildTestCount  ,  
     ZAnswerTestCount  , 
     ZSOCRE,

      ZTotal
     ) 
  values(
       @myUserName,
        @c1,
       @c2,
        @c3,
       @c4,
       @c5,
 
       @c6,
       @c7,

       @c8,
       @c9,
       @c10,

       isnull(@c5,0)+isnull(@c7,0)+isnull(@c10,0) );
 
  fetch next from my_cursor into @myUserName, @myUser_ID,@myUser_Type
end

close   my_cursor  
deallocate my_cursor

select * from temp_stat
GO


/*
����: 2008-7-11  ����:������
Ŀ��: ͳ����Ŀ�Ĵ������
�޸ģ�
���   ʱ��         �޸���             �޸�����

*/

CREATE    PROCEDURE pt_StatBugProjectTaskCount
@StatbeginDate datetime,
@StatendDate datetime

as

declare @myProName varchar(200)
declare @myPro_ID int
declare @c1 int
declare @c2 int
declare @c3 int


set @c1=0
set @c2=0
set @c3=0


--����
if exists(select 1 from sysobjects where id=object_id('temp_prostat')and type = 'u')
  drop table temp_prostat
  
create table temp_prostat
  (
  ZPRONAME varchar(200) ,  --��Ŀ����
  ZSubmitBugCount  int,  --�ύ�������� c1
  ZAnswerBugCount int , --���������� c2
  ZNoAnswerBugCount int  --û�д���������� c3
)



--�Ȱ�����б���
declare my_cursor cursor
for
select a.ZNAME,a.ZID  from TB_BUG_TREE as a order by a.ZID,a.ZSORT

open my_cursor
fetch next from my_cursor into @myProName,@myPro_ID
while( @@fetch_status = 0)
begin
 
-----------------------------------bug----------------------------------------

        
   /*��������*/
  select @c1= count(a.ZID)   from TB_BUG_ITEM as a   
  where  a.ZTREE_ID=@myPro_ID and
             (a.ZOPENEDDATE between  @StatbeginDate and  @StatendDate)

  /*�������*/
  select @c2= count(a.ZID)   from TB_BUG_ITEM as a 
  where  a.ZTREE_ID=@myPro_ID and a.ZSTATUS=1 and  --1��ʾ�޸����
              (a.ZOPENEDDATE between  @StatbeginDate and  @StatendDate)

  
  /*û�к���������*/
  select @c3= count(a.ZID)   from TB_BUG_ITEM as a 
  where  a.ZTREE_ID=@myPro_ID and a.ZSTATUS<>1 and  --1��ʾ�޸����
              (a.ZOPENEDDATE between  @StatbeginDate and  @StatendDate)



	
  insert into temp_prostat(
      ZPRONAME ,
      ZSubmitBugCount,
      ZAnswerBugCount,
      ZNoAnswerBugCount 
     ) 
  values(
       @myProName,
       @c1,
       @c2,
       @c3 ); 

  fetch next from my_cursor into @myProName, @myPro_ID
end

close   my_cursor  
deallocate my_cursor

select * from temp_prostat

GO





/*���Թ������ķ����ʼ�*/
/*
����: 2008-10-6  mrlong
Ŀ��: ȡ�����Ե��ʼ�����
�޸ģ�
���   ʱ��         �޸���             �޸�����
*/

CREATE   PROCEDURE pt_MaintoByTest
@TestID int, --TestID��
@mailtitle varchar(200) output, --���صı���
@mailtext varchar(4000) output --���ص�����
as
declare @Title varchar(200)
declare @ProName varchar(200) --��Ŀ����
declare @Auathor varchar(20)  
declare @TestContext varchar(2000) --����
declare @Status int --״̬ 1 ��� 2 ���� 3 �ر�

begin


--ȡ�����⼰����
declare my_cursor cursor 
for
select a.ZNAME,b.ZNAME,a.ZSTATUS  from TB_TEST_ITEM as a, TB_USER_ITEM as b where a.ZID=@TestID and
a.ZOPENEDBY=b.ZID

open my_cursor
fetch next from my_cursor into @Title,@Auathor,@Status
close   my_cursor  
deallocate my_cursor

--ȡ����Ŀ������汾��
declare my_cursor cursor 
for
select b.ZNAME from TB_TEST_ITEM as a, TB_PRO_ITEM as b where a.ZID=@TestID and
a.ZPRO_ID=b.ZID

open my_cursor
fetch next from my_cursor into @ProName
close   my_cursor  
deallocate my_cursor

--����
if @Status =2
begin
 set @TestContext  = '���Ա�����'
end

if @Status =3
begin
 set @TestContext  = '���Թر�'
end




--��ʽ
set @mailtitle = @Title
set @mailtext  = @ProName + char(13) +char(10)+
'-------------------------------------------------------------------------------------------' + char(13) + char(10)+
@TestContext + char(13) +char(10)+char(13)+char(10)+
'������:' +  @Auathor 


end
GO

/******************************************************************************
����: 2008-12-20  ����:������
Ŀ��: ����̨, 
�޸ģ�
���   ʱ��         �޸���             �޸�����
  1    2009-1-15   ������   ���Ӵ���ʱ��
����:
   USERID ,USERTYPE , 

����: ��

********************************************************************************/

CREATE    PROCEDURE pt_UserDayWork
@USERID int,
@USERTYPE int

as

declare @RowName varchar(255)
declare @RowType int
declare @RowContentID int --����id ���ڹ���
declare @RowState int --�Ƿ��ѹر���
declare @RowTagName varchar(100)
declare @RowClose int
declare @RowDate datetime --����ʱ�� 
declare @myc int
declare @myid int

set @RowState = 0


--����
if exists(select 1 from sysobjects where id=object_id('temp_usr_daywork')and type = 'u')
  drop table temp_usr_daywork
  
create table temp_usr_daywork
  (
  ZROWID int,      --���
  ZROWPART bit , --=True Ϊ�ֲ���
  ZROWNAME varchar(255), --����,������bug����������������
  ZROWTYPE int , --������ 0 bug 1 cbug  2 test   3 ctest   4 plan  5 Release 6 CRelease 7 other
  ZROWLEVE int , --�ȼ�  	
  ZCONTENTID int,  --����ID,����bug����bug��id    
  ZCLOSE bit , --�Ƿ��ѹرյ���
  ZTAGNAME varchar(100), --��ǩ
 ZBUILDDATE datetime,  --����ʱ��
)

set @myc = 1

-------------------------------------ָ�ɸ��ҵ�bug(0)-----------------------------------------------------------------------------------------------------------------------------
set @RowType = 0
 insert into   temp_usr_daywork
  (ZROWPART,  ZROWNAME,  ZROWTYPE)
  values  ( 1,  'ָ�ɸ��ҵ�BUG',  @RowType)
set @myc = @myc+1
set @myid = 0
declare my_cursor cursor
for 
select top 10  ZTITLE,ZID,ZTAGNAME,ZOPENEDDATE  from TB_BUG_ITEM 
where ( ZSTATUS<>1) and ZASSIGNEDTO=@USERID order by ZOPENEDDATE desc , ZTERM

open my_cursor
fetch next from my_cursor into  @RowName,@RowContentID,@RowTagName,@RowDate

while( @@fetch_status = 0)
begin
  set @myid = @myid+1
   insert into   temp_usr_daywork
  (ZROWID,ZROWPART,  ZROWNAME,  ZROWTYPE,   ZROWLEVE, ZCONTENTID,ZCLOSE,ZTAGNAME,ZBUILDDATE)
  values  ( @myid,  0,   @RowName,  @RowType,@myc,@RowContentID,0,ltrim(rtrim(@RowTagName)),@RowDate)
  set @myc =  @myc+1

  fetch next from my_cursor into @RowName,@RowContentID,@RowTagName,@RowDate
end


if @myid = 0 
  delete  from temp_usr_daywork where  ZROWTYPE=@RowType

close   my_cursor  
deallocate my_cursor

---------------------------------���Ҵ�����bug(1)----------------------------------------------------------------
set @RowType = 1
 insert into   temp_usr_daywork
  (ZROWPART,  ZROWNAME,  ZROWTYPE)
  values  ( 1,  '���Ҵ�����BUG',  @RowType)
set @myc = @myc+1
set @myid = 0

declare my_cursor cursor
for 
select top 10  ZTITLE,ZID,ZSTATUS,ZTAGNAME,ZOPENEDDATE  from TB_BUG_ITEM 
where  ZOPENEDBY=@USERID order by ZOPENEDDATE desc , ZTERM

open my_cursor
fetch next from my_cursor into  @RowName,@RowContentID,@RowState,@RowTagName,@RowDate

while( @@fetch_status = 0)
begin
  set @myid = @myid+1
  print @RowState 
  if @RowState = 1 
     set @RowClose = 1
  else
    set  @RowClose = 0
  insert into   temp_usr_daywork
  (ZROWID,ZROWPART,  ZROWNAME,  ZROWTYPE,   ZROWLEVE, ZCONTENTID,ZCLOSE,ZTAGNAME,ZBUILDDATE)
  values  ( @myid,  0,   @RowName,  @RowType,@myc,@RowContentID,@RowClose,ltrim(rtrim(@RowTagName)),@RowDate)
  set @myc =  @myc+1

  fetch next from my_cursor into @RowName,@RowContentID,@RowState,@RowTagName,@RowDate
end

if @myid = 0 
  delete  from temp_usr_daywork where  ZROWTYPE=@RowType

close   my_cursor  
deallocate my_cursor


--------------------------------------------��Ҫ���Ե�����test(2)-------------------------------------------------------------------------------------------------------------------------------------
set @RowType = 2
 insert into   temp_usr_daywork
  (ZROWPART,  ZROWNAME,  ZROWTYPE)
  values  ( 1,  'Ҫ�Ҳ��Ե�����',  @RowType)
set @myc = @myc+1
set @myid = 0
declare my_cursor cursor
for 
select top 10  ZNAME,ZID,ZTAGNAME,ZOPENEDDATE  from TB_TEST_ITEM 
where ( ZSTATUS<>3) and ZASSIGNEDTO=@USERID order by ZOPENEDDATE desc

open my_cursor
fetch next from my_cursor into  @RowName,@RowContentID,@RowTagName,@Rowdate

while( @@fetch_status = 0)
begin
 set @myid = @myid + 1
  insert into   temp_usr_daywork
  (ZROWID,ZROWPART,  ZROWNAME,  ZROWTYPE,   ZROWLEVE, ZCONTENTID,ZTAGNAME,ZBUILDDATE)
  values  ( @myid,  0,   @RowName,  @RowType,@myc,@RowContentID,ltrim(rtrim(@RowTagName)),@RowDate)
  set @myc = @myc+1
  
  fetch next from my_cursor into @RowName,@RowContentID,@RowTagName,@Rowdate
end

if @myid = 0 
  delete  from temp_usr_daywork where  ZROWTYPE=@RowType

close   my_cursor  
deallocate my_cursor


--------------------------------------------�Ҵ������Ե�����(3)------------------------------------------------------------------------------------------------------------------------------------
set @RowType = 3
 insert into   temp_usr_daywork
  (ZROWPART,  ZROWNAME,  ZROWTYPE)
  values  ( 1,  '���Ҵ�����������',  @RowType)
set @myc = @myc+1
set @myid = 0
declare my_cursor cursor
for 
select top 10  ZNAME,ZID,ZSTATUS,ZTAGNAME,ZOPENEDDATE  from TB_TEST_ITEM 
where  ZOPENEDBY=@USERID order by ZOPENEDDATE desc

open my_cursor
fetch next from my_cursor into  @RowName,@RowContentID,@RowState,@RowTagName,@RowDate

while( @@fetch_status = 0)
begin
  set @myid = @myid + 1
  if @RowState = 3 --3Ϊ�ر�
    set @RowClose = 1
  else
    set @RowClose = 0
	
  insert into   temp_usr_daywork
  (ZROWID,ZROWPART,  ZROWNAME,  ZROWTYPE,   ZROWLEVE, ZCONTENTID,ZCLOSE,ZTAGNAME,ZBUILDDATE)
  values  ( @myid,  0,   @RowName,  @RowType,@myc,@RowContentID,@RowClose,ltrim(rtrim(@RowTagName)),@RowDate)
  set @myc = @myc+1
  
  fetch next from my_cursor into @RowName,@RowContentID,@RowState,@RowTagName,@RowDate
end

if @myid = 0 
  delete  from temp_usr_daywork where  ZROWTYPE=@RowType

close   my_cursor  
deallocate my_cursor


--------------------------plan(4)------------------------------------------------------------------------------------------------------------------------------------------------
set @RowType = 4
 insert into   temp_usr_daywork
  (ZROWPART,  ZROWNAME,  ZROWTYPE)
  values  ( 1,  'Ҫ����ɵ�����',  @RowType)
set @myc = @myc+1
set @myid = 0
declare my_cursor cursor
for 
select top 10 a.ZNAME + '(' + b.ZNAME + ')'  as subName ,a.ZID  from TB_PLAN_DETAIL as a , TB_PLAN_ITEM as b 
where ( a.ZSTATUS=0) and ZDEVE=@USERID and a.ZITEM_GUID=b.ZGUID order by ZID desc

open my_cursor
fetch next from my_cursor into  @RowName,@RowContentID

while( @@fetch_status = 0)
begin
  set @myid = @myid + 1  
  insert into   temp_usr_daywork
  (ZROWID,ZROWPART,  ZROWNAME,  ZROWTYPE,   ZROWLEVE, ZCONTENTID)
  values  ( @myid,  0,   @RowName,  @RowType,@myc,@RowContentID)
  set @myc = @myc+1
  

  fetch next from my_cursor into @RowName,@RowContentID
end

if @myid = 0 
  delete  from temp_usr_daywork where  ZROWTYPE=@RowType

close   my_cursor  
deallocate my_cursor


---------------------------------Release(5)-------------------------------------------------
set @RowType = 5
 insert into   temp_usr_daywork
  (ZROWPART,  ZROWNAME,  ZROWTYPE)
  values  ( 1,  'Ҫ���ϴ�����Ŀ',  @RowType)
set @myc = @myc+1
set @myid = 0
declare my_cursor cursor
for 
select top 5  ZNAME,ZID,ZOPENDATE  from TB_RELEASE_ITEM 
where ( ZSTATUS<>1) and ZASSIGNEDTO=@USERID order by ZOPENDATE desc

open my_cursor
fetch next from my_cursor into  @RowName,@RowContentID,@RowDate

while( @@fetch_status = 0)
begin
 set @myid = @myid + 1
  insert into   temp_usr_daywork
  (ZROWID,ZROWPART,  ZROWNAME,  ZROWTYPE,   ZROWLEVE, ZCONTENTID,ZBUILDDATE)
  values  ( @myid,  0,   @RowName,  @RowType,@myc,@RowContentID,@RowDate)
  set @myc = @myc+1
  
  fetch next from my_cursor into @RowName,@RowContentID,@RowDate
end

if @myid = 0 
  delete  from temp_usr_daywork where  ZROWTYPE=@RowType

close   my_cursor  
deallocate my_cursor

-------------------------------Creaet Release (6)---------------------------------------------------------------
set @RowType = 6
 insert into   temp_usr_daywork
  (ZROWPART,  ZROWNAME,  ZROWTYPE)
  values  ( 1,  '���ҷ�����Ŀ',  @RowType)
set @myc = @myc+1
set @myid = 0
declare my_cursor cursor
for 
select top 5  ZNAME,ZID,ZSTATUS,ZOPENDATE  from TB_RELEASE_ITEM 
where  ZOPENEDBY=@USERID order by ZOPENDATE desc

open my_cursor
fetch next from my_cursor into  @RowName,@RowContentID,@RowState,@RowDate

while( @@fetch_status = 0)
begin
  set @myid = @myid + 1
  if @RowState = 1 --1Ϊ�ر�
    set @RowClose = 1
  else
    set @RowClose = 0
	
  insert into   temp_usr_daywork
  (ZROWID,ZROWPART,  ZROWNAME,  ZROWTYPE,   ZROWLEVE, ZCONTENTID,ZCLOSE,ZBUILDDATE)
  values  ( @myid,  0,   @RowName,  @RowType,@myc,@RowContentID,@RowClose,@RowDate)
  set @myc = @myc+1
  
  fetch next from my_cursor into @RowName,@RowContentID,@RowState,@RowDate
end

if @myid = 0 
  delete  from temp_usr_daywork where  ZROWTYPE=@RowType

close   my_cursor  
deallocate my_cursor


-----------------------------other-------------------------------------------------------------

select * from temp_usr_daywork
GO



/*�����������ķ����ʼ�*/
/*
����: 2008-12-20  mrlong
Ŀ��: ȡ������������ʼ�����
�޸ģ�
���   ʱ��         �޸���             �޸�����
*/

CREATE   PROCEDURE pt_MaintoByRelease
@ReleaseID int, --TestID��
@mailtitle varchar(200) output, --���صı���
@mailtext varchar(4000) output --���ص�����
as
declare @Title varchar(200)
declare @ProName varchar(200) --��Ŀ����
declare @Auathor varchar(20)  
declare @ReleaseContext varchar(2000) --����
declare @Status int --״̬ 0 ����  1 �ر�
declare @UrlType int --������ʽ 0 ��վ , 1 FTP 2 ��������
declare @Url varchar(200) --����������
declare @UrlTypeName varchar(30)

begin


--ȡ�����⼰����
declare my_cursor cursor 
for
select a.ZNAME,b.ZNAME,a.ZSTATUS,a.ZPROCONTENT,a.ZURLTYPE,a.ZURL
 from TB_RELEASE_ITEM as a, TB_USER_ITEM as b where a.ZID=@ReleaseID and
a.ZOPENEDBY=b.ZID

open my_cursor
fetch next from my_cursor into @Title,@Auathor,@Status,@ReleaseContext,@UrlType,@Url
close   my_cursor  
deallocate my_cursor

--ȡ����Ŀ����
declare my_cursor cursor 
for
select b.ZNAME from TB_RELEASE_ITEM as a, TB_PRO_ITEM as b where a.ZID=@ReleaseID and
a.ZPRO_ID=b.ZID

open my_cursor
fetch next from my_cursor into @ProName
close   my_cursor  
deallocate my_cursor

--��������
if @UrlType = 0
   set @UrlTypeName = '��˾��վ'
if @UrlType = 1 
   set @UrlTypeName = '��˾FTP'
if @UrlType = 2 
   set @UrlTypeName = '��������' 

--����
if @Status =0
begin
 set @ReleaseContext  = '�������޸���ϣ����ύ�����������ȴ�������'  + char(13)+char(10)  +
   '��������' +  @UrlTypeName + char(13) + char(10) + 
   '����·����' +  @Url + char(13) + char(10) + 
   '-------------------------------------------------------------------------------------------------' + char(13) + char(10) 
   +@ReleaseContext
end

if @Status =1
begin
 set @ReleaseContext  = '��Ŀ�Ѳ�' +  char(13)+char(10)+
   '��������' +  @UrlTypeName + char(13) + char(10) + 
   '����·����' +  @Url + char(13) + char(10) + 
    '-------------------------------------------------------------------------------------------------' + char(13) + char(10) 
  + @ReleaseContext
end



--��ʽ
set @mailtitle = '(��������) ' + @Title
set @mailtext  = @ProName + char(13) +char(10)+
'-------------------------------------------------------------------------------------------' + char(13) + char(10)+
@ReleaseContext + char(13) +char(10)+char(13)+char(10) +
'���ʼ��ɿ�������ϵͳ����������ֱ�ӻظ���' +
'������:' +  @Auathor 


end
GO
