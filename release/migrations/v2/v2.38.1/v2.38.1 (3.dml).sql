prompt adding new indicators
----------------------------------------------------------------------------------------------------
whenever sqlerror exit failure rollback;
----------------------------------------------------------------------------------------------------
declare
  --------------------------------------------------
  Procedure Indicator
  (
    i_Company_Id number,
    i_Name       varchar2,
    i_Short_Name varchar2,
    i_Identifier varchar2,
    i_Used       varchar2,
    i_Pcode      varchar2
  ) is
    r_Indicator Href_Indicators%rowtype;
  begin
    begin
      select q.*
        into r_Indicator
        from Href_Indicators q
       where Company_Id = i_Company_Id
         and Pcode = i_Pcode;
    exception
      when No_Data_Found then
        r_Indicator.Indicator_Id := Href_Next.Indicator_Id;
        r_Indicator.State        := 'A';
    end;
  
    r_Indicator.Company_Id := i_Company_Id;
    r_Indicator.Name       := i_Name;
    r_Indicator.Short_Name := i_Short_Name;
    r_Indicator.Identifier := i_Identifier;
    r_Indicator.Used       := i_Used;
    r_Indicator.Pcode      := i_Pcode;
  
    z_Href_Indicators.Save_Row(r_Indicator);
  end;
begin
  for r in (select c.Company_Id,
                   (select Ci.User_System
                      from Md_Company_Infos Ci
                     where Ci.Company_Id = c.Company_Id) as User_System,
                   (select Ci.Filial_Head
                      from Md_Company_Infos Ci
                     where Ci.Company_Id = c.Company_Id) as Filial_Head
              from Md_Companies c)
  loop
    Ui_Context.Init_Migr(i_Company_Id   => r.Company_Id,
                         i_Filial_Id    => r.Filial_Head,
                         i_User_Id      => r.User_System,
                         i_Project_Code => Href_Pref.c_Pc_Verifix_Hr);
  
    Indicator(i_Company_Id => r.Company_Id,
              i_Name       => 'Среднемесячный бонус за эффективность',
              i_Short_Name => 'Сред. бонус за эффект.',
              i_Identifier => 'СреднемесячныйБонусЗаЭффективность',
              i_Used       => Href_Pref.c_Indicator_Used_Automatically,
              i_Pcode      => Href_Pref.c_Pcode_Indicator_Average_Perf_Bonus);
  
    Indicator(i_Company_Id => r.Company_Id,
              i_Name       => 'Среднемесячный дополнительный бонус за эффективность',
              i_Short_Name => 'Сред. доп. бонус за эффект.',
              i_Identifier => 'СреднемесячныйДополнительныйБонусЗаЭффективность',
              i_Used       => Href_Pref.c_Indicator_Used_Automatically,
              i_Pcode      => Href_Pref.c_Pcode_Indicator_Average_Perf_Extra_Bonus);
  end loop;

  commit;
end;
/
