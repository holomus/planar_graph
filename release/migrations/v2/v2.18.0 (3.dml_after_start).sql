prompt adding new oper type
----------------------------------------------------------------------------------------------------
declare
  v_Company_Id         number;
  v_Estimation_Formula varchar2(300 char);

  --------------------------------------------------
  Procedure Oper_Type
  (
    i_Name               varchar2,
    i_Short_Name         varchar2,
    i_Oper_Group_Pcode   varchar2,
    i_Estimation_Type    varchar2,
    i_Estimation_Formula varchar2,
    i_Operation_Kind     varchar2,
    i_Oper_Type_Pcode    varchar2
  ) is
    v_Oper_Type     Hpr_Pref.Oper_Type_Rt;
    v_Oper_Type_Id  number;
    v_Oper_Group_Id number;
  begin
    begin
      select Oper_Type_Id
        into v_Oper_Type_Id
        from Mpr_Oper_Types
       where Company_Id = v_Company_Id
         and Pcode = i_Oper_Type_Pcode;
    exception
      when No_Data_Found then
        v_Oper_Type_Id := Mpr_Next.Oper_Type_Id;
    end;
  
    select Oper_Group_Id
      into v_Oper_Group_Id
      from Hpr_Oper_Groups
     where Company_Id = v_Company_Id
       and Pcode = i_Oper_Group_Pcode;
  
    Hpr_Util.Oper_Type_New(o_Oper_Type              => v_Oper_Type,
                           i_Company_Id             => v_Company_Id,
                           i_Oper_Type_Id           => v_Oper_Type_Id,
                           i_Oper_Group_Id          => v_Oper_Group_Id,
                           i_Estimation_Type        => i_Estimation_Type,
                           i_Estimation_Formula     => i_Estimation_Formula,
                           i_Operation_Kind         => i_Operation_Kind,
                           i_Name                   => i_Name,
                           i_Short_Name             => i_Short_Name,
                           i_Accounting_Type        => Mpr_Pref.c_At_Employee,
                           i_Corr_Coa_Id            => null,
                           i_Corr_Ref_Set           => null,
                           i_Income_Tax_Exists      => 'N',
                           i_Income_Tax_Rate        => null,
                           i_Pension_Payment_Exists => 'N',
                           i_Pension_Payment_Rate   => null,
                           i_Social_Payment_Exists  => 'N',
                           i_Social_Payment_Rate    => null,
                           i_Note                   => null,
                           i_State                  => 'A',
                           i_Code                   => null);
  
    Hpr_Api.Oper_Type_Save(v_Oper_Type);
  
    update Mpr_Oper_Types q
       set q.Pcode = i_Oper_Type_Pcode
     where q.Company_Id = v_Company_Id
       and q.Oper_Type_Id = v_Oper_Type_Id;
  end;

  --------------------------------------------------
  Function Identifier(i_Pcode varchar2) return varchar2 is
    result Href_Indicators.Identifier%type;
  begin
    select Identifier
      into result
      from Href_Indicators
     where Company_Id = v_Company_Id
       and Pcode = i_Pcode;
  
    return result;
  end;

begin

  for Cmp in (select *
                from Md_Companies q
               where q.State = 'A'
                 and Md_Util.Any_Project(q.Company_Id) is not null)
  loop
    v_Company_Id := Cmp.Company_Id;
  
    Ui_Context.Init_Migr(i_Company_Id   => v_Company_Id,
                         i_Filial_Id    => Md_Pref.Filial_Head(v_Company_Id),
                         i_User_Id      => Md_Pref.User_System(v_Company_Id),
                         i_Project_Code => Href_Pref.c_Pc_Verifix_Hr);
  
    v_Estimation_Formula := Identifier(Href_Pref.c_Pcode_Indicator_Wage) || ' * ' ||
                            Identifier(Href_Pref.c_Pcode_Indicator_Rate) || ' * ' ||
                            Identifier(Href_Pref.c_Pcode_Indicator_Fact_Hours) || ' / ' ||
                            Identifier(Href_Pref.c_Pcode_Indicator_Plan_Hours);
  
    -- Oper type
    Oper_Type('Месячная оплата труда (по часам)',
              'Месячная (по часам)',
              Hpr_Pref.c_Pcode_Operation_Group_Wage,
              Hpr_Pref.c_Estimation_Type_Formula,
              v_Estimation_Formula,
              Mpr_Pref.c_Ok_Accrual,
              Hpr_Pref.c_Pcode_Oper_Type_Monthly_Summarized);
  end loop;
  
  commit;
end;
/

----------------------------------------------------------------------------------------------------
prompt adding DAHUA device type
----------------------------------------------------------------------------------------------------
declare
  Procedure Device_Type
  (
    i_Name  varchar2,
    i_Pcode varchar2
  ) is
    v_Device_Type_Id number;
  begin
    begin
      select Device_Type_Id
        into v_Device_Type_Id
        from Htt_Device_Types
       where Pcode = i_Pcode;
    exception
      when No_Data_Found then
        v_Device_Type_Id := Htt_Next.Device_Type_Id;
    end;
  
    z_Htt_Device_Types.Save_One(i_Device_Type_Id => v_Device_Type_Id,
                                i_Name           => i_Name,
                                i_State          => 'A',
                                i_Pcode          => i_Pcode);
  end;

begin
  Device_Type('Verifix Dahua', Htt_Pref.c_Pcode_Device_Type_Dahua);
  
  commit;
end;
/
