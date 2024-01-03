prompt adding new oper group
----------------------------------------------------------------------------------------------------
declare
  --------------------------------------------------
  Procedure Operation_Group
  (
    i_Company_Id         number,
    i_Operation_Kind     varchar2,
    i_Name               varchar2,
    i_Estimation_Type    varchar2,
    i_Estimation_Formula varchar2,
    i_Pcode              varchar2
  ) is
    v_Oper_Group_Id number;
  begin
    begin
      select Oper_Group_Id
        into v_Oper_Group_Id
        from Hpr_Oper_Groups
       where Company_Id = i_Company_Id
         and Pcode = i_Pcode;
    exception
      when No_Data_Found then
        v_Oper_Group_Id := Hpr_Next.Oper_Group_Id;
    end;
  
    z_Hpr_Oper_Groups.Save_One(i_Company_Id         => i_Company_Id,
                               i_Oper_Group_Id      => v_Oper_Group_Id,
                               i_Operation_Kind     => i_Operation_Kind,
                               i_Name               => i_Name,
                               i_Estimation_Type    => i_Estimation_Type,
                               i_Estimation_Formula => i_Estimation_Formula,
                               i_Pcode              => i_Pcode);
  end;

  --------------------------------------------------
  Procedure Book_Type_Bind
  (
    i_Company_Id       number,
    i_Book_Type_Pcode  varchar2,
    i_Oper_Group_Pcode varchar2
  ) is
    v_Book_Type_Id  number;
    v_Oper_Group_Id number;
  begin
    select Book_Type_Id
      into v_Book_Type_Id
      from Hpr_Book_Types
     where Company_Id = i_Company_Id
       and Pcode = i_Book_Type_Pcode;
  
    select Oper_Group_Id
      into v_Oper_Group_Id
      from Hpr_Oper_Groups
     where Company_Id = i_Company_Id
       and Pcode = i_Oper_Group_Pcode;
  
    z_Hpr_Book_Type_Binds.Insert_Try(i_Company_Id    => i_Company_Id,
                                     i_Book_Type_Id  => v_Book_Type_Id,
                                     i_Oper_Group_Id => v_Oper_Group_Id);
  end;

begin
  for r in (select *
              from Md_Companies q)
  loop
    Operation_Group(i_Company_Id         => r.Company_Id,
                    i_Operation_Kind     => Mpr_Pref.c_Ok_Accrual,
                    i_Name               => 'Повременная оплата труда и надбавки (без штрафов)',
                    i_Estimation_Type    => Hpr_Pref.c_Estimation_Type_Formula,
                    i_Estimation_Formula => 'Оклад',
                    i_Pcode              => Hpr_Pref.c_Pcode_Operation_Group_Wage_No_Deduction);
  
    Book_Type_Bind(i_Company_Id       => r.Company_Id,
                   i_Book_Type_Pcode  => Hpr_Pref.c_Pcode_Book_Type_Wage,
                   i_Oper_Group_Pcode => Hpr_Pref.c_Pcode_Operation_Group_Wage_No_Deduction);
  end loop;
  
  commit;
end;
/
