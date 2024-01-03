create or replace package Hes_Error is
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
  Procedure Raise_006(i_Request_Max_Days number);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_007
  (
    i_Error_Code    varchar2,
    i_Error_Message varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_008;
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_009;
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_010;
end Hes_Error;
/
create or replace package body Hes_Error is
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
    return b.Translate('HES:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
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
    b.Raise_Extended(i_Code    => Verifix.Hes_Error_Code || i_Code,
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
          i_Message => t('001:message: at least one of "gps determination" and "face recognition" must be enabled'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_002 is
  begin
    Error(i_Code    => '002',
          i_Message => t('002:message:qr code limit time must be less than 24 hours'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_003 is
  begin
    Error(i_Code    => '003',
          i_Message => t('003:message:Billz subject is empty. subject must be provided'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_004 is
  begin
    Error(i_Code    => '004',
          i_Message => t('004:message:Billz secret_key is empty. secret_key must be provided'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_005 is
  begin
    Error(i_Code => '005', i_Message => t('005:message:Billz credentials are not provided'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_006(i_Request_Max_Days number) is
  begin
    Error(i_Code    => '006',
          i_Message => t('006:message:request date period must be smaller than $1 days',
                         i_Request_Max_Days));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_007
  (
    i_Error_Code    varchar2,
    i_Error_Message varchar2
  ) is
  begin
    Error(i_Code    => '007',
          i_Message => t('007:message:Billz API returned an error. code = $1, message = $2',
                         i_Error_Code,
                         i_Error_Message));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_008 is
  begin
    Error(i_Code    => '008',
          i_Message => t('008:message:Billz API returned neither a result nor an error'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_009 is
  begin
    Error(i_Code    => '009',
          i_Message => t('009:message:you do not have access to create/update request'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_010 is
  begin
    Error(i_Code    => '010',
          i_Message => t('010:message:you do not have access to create/update change'));
  end;

end Hes_Error;
/
