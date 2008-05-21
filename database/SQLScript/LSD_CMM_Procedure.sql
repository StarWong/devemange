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


--set @mailtitle = "����"
--set @mailtext  = "bbbbbbbbbbbbb"

end
GO
