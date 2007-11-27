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
