unit SendMailUnits;

interface
uses
  SysUtils, Classes;

  //
  // Ŀǰֻ������OutLook
  //
  // ���͵��ʼ�:
  // Mail.Values['to'] : �ռ��˵ĵ�ַ
  // Mail.Values['subject'] : ����
  // Mail.Values['body'] : ����
  // Mail.Values['attachment0'] : ����
  // SendEmail(Application.Handle,mail);  ���͵Ķ���
  //
  function SendEmail(Handle: THandle; Mail: TStrings):   Cardinal;

implementation
uses
  Mapi; //�ʼ�����API;

function SendEmail(Handle: THandle; Mail: TStrings):   Cardinal;
type
  TAttachAccessArray   =   array   [0..0]   of   TMapiFileDesc;
  PAttachAccessArray   =   ^TAttachAccessArray;
var
  MapiMessage   :   TMapiMessage;
  Receip        :   TMapiRecipDesc;
  Attachments   :   PAttachAccessArray;
  AttachCount   :   Integer;
  iCount        :   Integer;
  FileName      :   string;
begin
  FillChar(MapiMessage,   SizeOf(MapiMessage),   #0);
  Attachments   :=   nil;
  FillChar(Receip,SizeOf(Receip),   #0);
  if Mail.Values['to'] <> '' then
  begin
    Receip.ulReserved   :=   0;
    Receip.ulRecipClass   :=   MAPI_TO;
    Receip.lpszName   :=   StrNew(PChar(Mail.Values['to']));
    Receip.lpszAddress   :=   StrNew(PChar('SMTP:'   +   Mail.Values['to']));
    Receip.ulEIDSize   :=   0;
    MapiMessage.nRecipCount   :=   1;
    MapiMessage.lpRecips   :=   @Receip;
  end;

  //��������
  AttachCount := 0;
  for iCount := 0 to MaxInt do
  begin
    if Mail.Values['attachment'+IntToStr(iCount)] = ''then
      Break;
    AttachCount := AttachCount+1;
  end;

  if AttachCount > 0 then
  begin
    GetMem(Attachments,SizeOf(TMapiFileDesc) * AttachCount);
    for iCount:=0 to (AttachCount -1) do
    begin
      FileName := Mail.Values['attachment'   +   IntToStr(iCount)];
      Attachments[iCount].ulReserved   :=   0;
      Attachments[iCount].flFlags      :=   0;
      Attachments[iCount].nPosition    :=   $FFFFFFFF;  //�����ʲô?
      Attachments[iCount].lpszPathName :=   StrNew(PChar(FileName));
      Attachments[iCount].lpszFileName :=   StrNew(PChar(ExtractFileName(FileName)));      Attachments[iCount].lpFileType   :=   nil;
    end;
    MapiMessage.nFileCount   :=   AttachCount;
    MapiMessage.lpFiles   :=   @Attachments^;
  end;

  if Mail.Values['subject']<> '' then
     MapiMessage.lpszSubject   :=  StrNew(PChar(Mail.Values['subject']));
  if Mail.Values['body'] <> ''then
     MapiMessage.lpszNoteText := StrNew(PChar(Mail.Values['body']));
   Result := MapiSendMail(0,Handle,MapiMessage,
      MAPI_DIALOG*Ord(Handle   <>   0) OR MAPI_LOGON_UI OR MAPI_NEW_SESSION,0);

  for iCount:= 0 to (AttachCount - 1) do
  begin
    strDispose(Attachments[iCount].lpszPathName);
    strDispose(Attachments[iCount].lpszFileName);
  end;

  if Assigned(MapiMessage.lpszSubject) then
    strDispose(MapiMessage.lpszSubject);
  if  Assigned(MapiMessage.lpszNoteText) then
    strDispose(MapiMessage.lpszNoteText);
  if Assigned(Receip.lpszAddress) then
    strDispose(Receip.lpszAddress);
  if Assigned(Receip.lpszName) then
    strDispose(Receip.lpszName);
end;

end.
