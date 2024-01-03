create or replace package Hide_Error is
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_001;
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_002;
  ---------------------------------------------------------------------------------------------------- 
  Procedure Raise_003;
  ---------------------------------------------------------------------------------------------------- 
  Procedure Raise_004(i_Element_Name varchar2);
  ---------------------------------------------------------------------------------------------------- 
  Procedure Raise_005
  (
    i_Element_Name varchar2,
    i_Is_Before    boolean := false
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_006(i_Variable_Name varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_007;
end Hide_Error;
/
create or replace package body Hide_Error is
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
    return b.Translate('hide:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
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
    b.Raise_Extended(i_Code    => Verifix.Hide_Error_Code || i_Code,
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
    Error(i_Code => '001', i_Message => t('001:message:brackets are placed incorrectly'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_002 is
  begin
    Error(i_Code => '002', i_Message => t('002:message:cannot be divided by zero'));
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Raise_003 is
  begin
    Error(i_Code    => '003',
          i_Message => t('003:message:recursion exceeds the maximum number of steps'));
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Raise_004(i_Element_Name varchar2) is
  begin
    Error(i_Code    => '004',
          i_Message => t('004:message:an arithmetic operation is omitted before the $1{element_name}',
                         i_Element_Name));
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Raise_005
  (
    i_Element_Name varchar2,
    i_Is_Before    boolean := false
  ) is
    v_Message varchar2(500) := t('005:message:an variable is omitted after the $1{element_name}',
                                 i_Element_Name);
  begin
    if i_Is_Before then
      v_Message := t('005:message:an variable is omitted before the $1{element_name}',
                     i_Element_Name);
    end if;
  
    Error(i_Code => '005', i_Message => v_Message);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_006(i_Variable_Name varchar2) is
  begin
    Error(i_Code    => '006',
          i_Message => t('006:message:there is no value for $1{variable_name} variable.',
                         i_Variable_Name));
  end;
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_007 is
  begin
    Error(i_Code => '007', i_Message => t('007:message:wrong operator was chosen'));
  end;

end Hide_Error;
/
