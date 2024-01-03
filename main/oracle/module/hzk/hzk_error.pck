create or replace package Hzk_Error is
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_001
  (
    i_Device_Id   number,
    i_Device_Name varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_002
  (
    i_Device_Id   number,
    i_Device_Name varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_003
  (
    i_Person_Id   number,
    i_Person_Name varchar2,
    i_Finger_No   number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_004(i_Error_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_005
  (
    i_Error_Id   number,
    i_Mark_Type  varchar2,
    i_Mark_Types Array_Varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_006
  (
    i_Error_Id      number,
    i_Person_Id     number,
    i_Person_Name   varchar2,
    i_Location_Id   number,
    i_Location_Name varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_007
  (
    i_Operlog_Type  varchar2,
    i_Operlog_Types Array_Varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_008
  (
    i_Mark_Type  varchar2,
    i_Mark_Types Array_Varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_009;
end Hzk_Error;
/
create or replace package body Hzk_Error is
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
  
    return b.Translate('HZK:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
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
    b.Raise_Extended(i_Code    => Verifix.Hzk_Error_Code || i_Code,
                     i_Message => i_Message,
                     i_Title   => i_Title,
                     i_S1      => i_S1,
                     i_S2      => i_S2,
                     i_S3      => i_S3,
                     i_S4      => i_S4,
                     i_S5      => i_S5);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_001
  (
    i_Device_Id   number,
    i_Device_Name varchar2
  ) is
  begin
    Error(i_Code    => '001',
          i_Message => t('001:message: for $1{device_name} model must be selected, device_id: $2',
                         i_Device_Name,
                         i_Device_Id),
          i_Title   => t('001:title: model must be selected'),
          i_S1      => t('001:solution: select model'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_002
  (
    i_Device_Id   number,
    i_Device_Name varchar2
  ) is
  begin
    Error(i_Code    => '002',
          i_Message => t('002:message: for $1{device_name} location must be selected, device_id: $2',
                         i_Device_Name,
                         i_Device_Id),
          i_Title   => t('002:title: location must be selected'),
          i_S1      => t('002:solution: select location'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_003
  (
    i_Person_Id   number,
    i_Person_Name varchar2,
    i_Finger_No   number
  ) is
  begin
    Error(i_Code    => '003',
          i_Message => t('003:message: finger number must be between 0 and 9, person_name: $1, person_id: $2, finger_no: $3',
                         i_Person_Name,
                         i_Person_Id,
                         i_Finger_No),
          i_S1      => t('003:solution: change finger number to any number between 0 and 9'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_004(i_Error_Id number) is
  begin
    Error(i_Code    => '004',
          i_Message => t('004:message: the status of the eval attlog must be $1{status_name}, error_id: $2',
                         Hzk_Util.t_Attlog_Error_Status(Hzk_Pref.c_Attlog_Error_Status_New),
                         i_Error_Id),
          i_Title   => t('004:title: The attlog is already evaluated'),
          i_S1      => t('004:solution: do not eval attlog that already evaluated'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_005
  (
    i_Error_Id   number,
    i_Mark_Type  varchar2,
    i_Mark_Types Array_Varchar2
  ) is
  begin
    Error(i_Code    => '005',
          i_Message => t('005:message: mark_type is wrong, error_id: $1, mark_type: $2',
                         i_Error_Id,
                         i_Mark_Type),
          i_Title   => t('005:title: mark_type is not found'),
          i_S1      => t('005:solution: 4th item must be one of $1{mark_types}',
                         Fazo.Gather(i_Mark_Types, ', ')));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_006
  (
    i_Error_Id      number,
    i_Person_Id     number,
    i_Person_Name   varchar2,
    i_Location_Id   number,
    i_Location_Name varchar2
  ) is
  begin
    Error(i_Code    => '006',
          i_Message => t('006:message: $1{person_name} is not attached to $2{location_name}, person_id: $3, location_id: $4, error_id: $5',
                         i_Person_Name,
                         i_Location_Name,
                         i_Person_Id,
                         i_Location_Id,
                         i_Error_Id),
          i_Title   => t('006:title: person is not attached to the location'),
          i_S1      => t('006:solution: attach $1{person_name} to $2{location_name} in any filial',
                         i_Person_Name,
                         i_Location_Name));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_007
  (
    i_Operlog_Type  varchar2,
    i_Operlog_Types Array_Varchar2
  ) is
  begin
    Error(i_Code    => '007',
          i_Message => t('007:message: operlog type is wrong, operlog_type: $1', i_Operlog_Type),
          i_Title   => t('007:title: operlog type is not found'),
          i_S1      => t('007:solution: operlog type(2nd item in a row) must be one of $1{operlog_types}',
                         Fazo.Gather(i_Operlog_Types, ', ')));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_008
  (
    i_Mark_Type  varchar2,
    i_Mark_Types Array_Varchar2
  ) is
  begin
    Error(i_Code    => '008',
          i_Message => t('008:message: mark_type is wrong, mark_type: $1', i_Mark_Type),
          i_Title   => t('008:title: mark_type is not found'),
          i_S1      => t('008:solution: 4th item must be one of $1{mark_types}',
                         Fazo.Gather(i_Mark_Types, ', ')));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_009 is
  begin
    Error(i_Code    => '009',
          i_Message => t('009:message: SN(serial number) not found'),
          i_S1      => t('009:solution: give serial number to SN'));
  end;

end Hzk_Error;
/
