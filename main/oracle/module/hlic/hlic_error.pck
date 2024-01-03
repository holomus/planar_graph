create or replace package Hlic_Error is
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_001;
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_002(i_Exceed_Amount number);
end Hlic_Error;
/
create or replace package body Hlic_Error is
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
    return b.Translate('HLIC:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
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
    b.Raise_Extended(i_Code    => Verifix.Hlic_Error_Code || i_Code,
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
          i_Message => t('001:message:units not initialized for run_units_revising'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_002(i_Exceed_Amount number) is
  begin
    Error(i_Code    => '002',
          i_Message => t('002:message:required licenses exceeded available amount by $1{exceed_amount}',
                         i_Exceed_Amount),
          i_Title   => t('002:title:not enough licenses'),
          i_S1      => t('002:solution:buy additional licenses'));
  end;

end Hlic_Error;
/
