create or replace package Hface_Error is
  ----------------------------------------------------------------------------------------------------
  Function Error_Map_003 return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Error_Map_004 return Hashmap;
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
end Hface_Error;
/
create or replace package body Hface_Error is
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
    return b.Translate('HFACE:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
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
    b.Raise_Extended(i_Code    => Verifix.Hface_Error_Code || i_Code,
                     i_Message => i_Message,
                     i_Title   => i_Title,
                     i_S1      => i_S1,
                     i_S2      => i_S2,
                     i_S3      => i_S3,
                     i_S4      => i_S4,
                     i_S5      => i_S5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Error_Map
  (
    i_Code      varchar2,
    i_Message   varchar2,
    i_Title     varchar2 := null,
    i_Solutions Array_Varchar2 := Array_Varchar2()
  ) return Hashmap is
    v_Map Hashmap;
  begin
    v_Map := Fazo.Zip_Map('code', --
                          Verifix.Hface_Error_Code || i_Code,
                          'message',
                          i_Message);
  
    v_Map.Put('title', Nvl(i_Title, t('title:error')));
  
    if i_Solutions.Count > 0 then
      v_Map.Put('solutions', i_Solutions);
    end if;
  
    return v_Map;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Error_Map_003 return Hashmap is
  begin
    return Error_Map(i_Code      => '003',
                     i_Message   => t('003:message:face recognition service couldnt recognize any faces in image'),
                     i_Title     => t('003:title:no face found'),
                     i_Solutions => Array_Varchar2(t('003:solution:try again with another image')));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Error_Map_004 return Hashmap is
  begin
    return Error_Map(i_Code    => '004',
                     i_Message => t('004:message:couldnt establish connection with face recognition service, try again later'),
                     i_Title   => t('004:title:connection failure'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_001 is
  begin
    Error(i_Code => '001', i_Message => t('001:message:recognition settings are not provided'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_002 is
  begin
    Error(i_Code    => '002',
          i_Message => t('002:message:duplicate prevention value must be in (Y, N)'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_003 is
  begin
    Error(i_Code    => '003',
          i_Message => t('003:message:face recognition service couldnt recognize any faces in image'),
          i_Title   => t('003:title:no face found'),
          i_S1      => t('003:solution:try again with another image'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_004 is
  begin
    Error(i_Code    => '004',
          i_Message => t('004:message:couldnt establish connection with face recognition service, try again later'),
          i_Title   => t('004:title:connection failure'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_005 is
  begin
    Error(i_Code    => '005',
          i_Message => t('005:message:duplicate prevention is enabled'),
          i_Title   => t('005:title:illegal action'));
  end;

end Hface_Error;
/
