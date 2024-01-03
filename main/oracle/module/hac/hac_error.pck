create or replace package Hac_Error is
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_001;
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_002;
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_003;
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_004;
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_005;
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_006(i_Token varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_007(i_Event_Type_Code number);
end Hac_Error;
/
create or replace package body Hac_Error is
  ----------------------------------------------------------------------------------------------------
  Function t
  (
    i_Message varchar2,
    i_P1      varchar2 := null,
    i_P2      varchar2 := null,
    i_P3      varchar2 := null,
    i_P4      varchar2 := null,
    i_P5      varchar2 := null
  ) return varchar2 is
  begin
    return b.Translate('HAC:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Error
  (
    i_Code    varchar2,
    i_Message varchar2,
    i_Title   varchar2 := null,
    i_S1      varchar2 := null,
    i_S2      varchar2 := null,
    i_S3      varchar2 := null,
    i_S4      varchar2 := null,
    i_S5      varchar2 := null
  ) is
  begin
    b.Raise_Extended(i_Code    => Verifix.Hac_Error_Code || i_Code,
                     i_Message => i_Message,
                     i_Title   => i_Title,
                     i_S1      => i_S1,
                     i_S2      => i_S2,
                     i_S3      => i_S3,
                     i_S4      => i_S4,
                     i_S5      => i_S5);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_001 is
  begin
    Error(i_Code    => '001',
          i_Message => t('001:message:only one primary attachment to is allowed to one device'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_002 is
  begin
    Error(i_Code    => '002',
          i_Message => t('002:message:device must have primary company attached to it'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_003 is
  begin
    Error(i_Code    => '003',
          i_Message => t('003:message:cannot delete primary attachment to company'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_004 is
  begin
    Error(i_Code    => '004',
          i_Message => t('004:message:synchronised company must have same server_id as target server_id'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_005 is
  begin
    Error(i_Code    => '005',
          i_Message => t('005:message:company not ready for work'),
          i_S1      => t('005:solution:provide person group code'),
          i_S2      => t('005:solution:provide department code'),
          i_S3      => t('005:solution:provide organization code'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_006(i_Token varchar2) is
  begin
    Error(i_Code    => '006',
          i_Message => t('006:message:no server with provided token, token = $1', i_Token),
          i_S1      => t('006:solution:set new server token and resubscribe events'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_007(i_Event_Type_Code number) is
  begin
    Error(i_Code    => '007',
          i_Message => t('007:message:unknown event type provided, event type code = $1',
                         i_Event_Type_Code));
  end;

end Hac_Error;
/
