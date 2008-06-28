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


begin


--ȡ�����⼰����
declare my_cursor cursor 
for
select  a.ZName as TaskName,b.ZNAME as UserName,c.ZNAME as ProName , d.ZVER , e.ZName as STATUS ,a.ZDESIGN ,b.ZEMAIL from TB_TASK as a
left join  TB_USER_ITEM as b  on a.ZUSER_ID=b.ZID 
left join  TB_PRO_ITEM   as c  on a.ZPRO_ID=c.ZID
left join  TB_PRO_VERSION as d on d.ZID=a.ZPRO_VERSION_ID
left join  TB_TASK_PARAMS as e on e.ZTYPE=1 and e.ZID=a.ZSTATUS 
where a.ZCODE=@TaskCode 

open my_cursor
fetch next from my_cursor into @mailtitle,@Auathor,@ProName,@Prover,@TaskStatus,@TaskContext,@mailto
close   my_cursor  
deallocate my_cursor


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


