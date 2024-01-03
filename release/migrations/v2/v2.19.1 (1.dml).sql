prompt change some names oper groups, oper types and book types
----------------------------------------------------------------------------------------------------
declare
  v_Company_Head number := Md_Pref.c_Company_Head;
  v_Pcode_Like   varchar2(10) := Upper(Href_Pref.c_Pc_Verifix_Hr) || '%';
  v_Query        varchar2(32767);

  --------------------------------------------------
  Procedure Indicators
  (
    i_Company_Id number,
    i_Lang_Code  varchar2
  ) is
    r_Data Href_Indicators%rowtype;
  begin
    v_Query := Md_Util.Translate_Rows_Statement(i_Table     => Zt.Href_Indicators,
                                                i_Lang_Code => i_Lang_Code);
  
    for r in (select *
                from Href_Indicators t
               where t.Company_Id = i_Company_Id
                 and t.Pcode like v_Pcode_Like)
    loop
      r_Data := r;
    
      execute immediate v_Query
        using in r_Data, out r_Data;
    
      z_Href_Indicators.Update_One(i_Company_Id    => r_Data.Company_Id,
                                   i_Indicator_Id  => r_Data.Indicator_Id,
                                   i_Name          => Option_Varchar2(r_Data.Name),
                                   i_Short_Name    => Option_varchar2(r_Data.Short_Name));
    end loop;
  end;
  
  --------------------------------------------------
  Procedure Oper_Groups
  (
    i_Company_Id number,
    i_Lang_Code  varchar2
  ) is
    r_Data Hpr_Oper_Groups%rowtype;
  begin
    v_Query := Md_Util.Translate_Rows_Statement(i_Table     => Zt.Hpr_Oper_Groups,
                                                i_Lang_Code => i_Lang_Code);
  
    for r in (select *
                from Hpr_Oper_Groups t
               where t.Company_Id = i_Company_Id
                 and t.Pcode like v_Pcode_Like)
    loop
      r_Data := r;
    
      execute immediate v_Query
        using in r_Data, out r_Data;
    
      z_Hpr_Oper_Groups.Update_One(i_Company_Id    => r_Data.Company_Id,
                                   i_Oper_Group_Id => r_Data.Oper_Group_Id,
                                   i_Name          => Option_Varchar2(r_Data.Name));
    end loop;
  end;

  --------------------------------------------------
  Procedure Oper_Types
  (
    i_Company_Id number,
    i_Lang_Code  varchar2
  ) is
    r_Data Mpr_Oper_Types%rowtype;
  
    --------------------------------------------------
    Function Name_Used
    (
      i_Company_Id   number,
      i_Oper_Type_Id number,
      i_Name         varchar2
    ) return boolean is
      v_Dummy varchar2(1);
    begin
      select 'x'
        into v_Dummy
        from Mpr_Oper_Types p
       where p.Company_Id = i_Company_Id
         and p.Oper_Type_Id <> i_Oper_Type_Id
         and Lower(p.Name) = Lower(i_Name);
    
      return true;
    exception
      when No_Data_Found then
        return false;
    end;
  begin
    v_Query := Md_Util.Translate_Rows_Statement(i_Table     => Zt.Mpr_Oper_Types,
                                                i_Lang_Code => i_Lang_Code);
  
    for r in (select *
                from Mpr_Oper_Types t
               where t.Company_Id = i_Company_Id
                 and t.Pcode like v_Pcode_Like)
    loop
      r_Data := r;
    
      execute immediate v_Query
        using in r_Data, out r_Data;
    
      continue when Name_Used(i_Company_Id   => r_Data.Company_Id,
                              i_Oper_Type_Id => r_Data.Oper_Type_Id,
                              i_Name         => r_Data.Name);
    
      z_Mpr_Oper_Types.Update_One(i_Company_Id   => r_Data.Company_Id,
                                  i_Oper_Type_Id => r_Data.Oper_Type_Id,
                                  i_Name         => Option_Varchar2(r_Data.Name),
                                  i_Short_Name   => Option_Varchar2(r_Data.Short_Name));
    end loop;
  end;

  --------------------------------------------------
  Procedure Book_Types
  (
    i_Company_Id number,
    i_Lang_Code  varchar2
  ) is
    r_Data Hpr_Book_Types%rowtype;
  begin
    v_Query := Md_Util.Translate_Rows_Statement(i_Table     => Zt.Hpr_Book_Types,
                                                i_Lang_Code => i_Lang_Code);
  
    for r in (select *
                from Hpr_Book_Types t
               where t.Company_Id = i_Company_Id
                 and t.Pcode like v_Pcode_Like)
    loop
      r_Data := r;
    
      execute immediate v_Query
        using in r_Data, out r_Data;
    
      z_Hpr_Book_Types.Update_One(i_Company_Id   => r_Data.Company_Id,
                                  i_Book_Type_Id => r_Data.Book_Type_Id,
                                  i_Name         => Option_Varchar2(r_Data.Name));
    end loop;
  end;
  
  --------------------------------------------------
  Procedure Time_Kinds
  (
    i_Company_Id number,
    i_Lang_Code  varchar2
  ) is
    r_Data Htt_Time_Kinds%rowtype;
  
    --------------------------------------------------
    Function Name_Used
    (
      i_Company_Id   number,
      i_Time_Kind_Id number,
      i_Name         varchar2,
      i_Letter_Code  varchar2
    ) return boolean is
      v_Dummy varchar2(1);
    begin
      select 'x'
        into v_Dummy
        from Htt_Time_Kinds p
       where p.Company_Id = i_Company_Id
         and p.Time_Kind_Id <> i_Time_Kind_Id
         and (Lower(p.Name) = Lower(i_Name) or Lower(p.Letter_Code) = Lower(i_Letter_Code));
    
      return true;
    exception
      when No_Data_Found then
        return false;
    end;
  begin
    v_Query := Md_Util.Translate_Rows_Statement(i_Table     => Zt.Htt_Time_Kinds,
                                                i_Lang_Code => i_Lang_Code);
  
    for r in (select *
                from Htt_Time_Kinds t
               where t.Company_Id = i_Company_Id
                 and t.Pcode like v_Pcode_Like)
    loop
      r_Data := r;
    
      execute immediate v_Query
        using in r_Data, out r_Data;
    
      continue when Name_Used(i_Company_Id   => r_Data.Company_Id,
                              i_Time_Kind_Id => r_Data.Time_Kind_Id,
                              i_Name         => r_Data.Name,
                              i_Letter_Code  => r_Data.Letter_Code);
    
      z_Htt_Time_Kinds.Update_One(i_Company_Id   => r_Data.Company_Id,
                                  i_Time_Kind_Id => r_Data.Time_Kind_Id,
                                  i_Name         => Option_Varchar2(r_Data.Name),
                                  i_Letter_Code  => Option_Varchar2(r_Data.Letter_Code));
    end loop;
  end;
begin
  Biruni_Route.Context_Begin;   

  for Cmp in (select c.Company_Id,
                     c.Lang_Code,
                     (select Ci.Filial_Head
                        from Md_Company_Infos Ci
                       where Ci.Company_Id = c.Company_Id) as Filial_Head,
                     (select Ci.User_System
                        from Md_Company_Infos Ci
                       where Ci.Company_Id = c.Company_Id) as User_System
                from Md_Companies c
               where c.Company_Id <> v_Company_Head)
  loop
    Ui_Context.Init_Migr(i_Company_Id   => Cmp.Company_Id,
                         i_Filial_Id    => Cmp.Filial_Head,
                         i_User_Id      => Cmp.User_System,
                         i_Project_Code => Href_Pref.c_Pc_Verifix_Hr);
  
    Indicators(i_Company_Id => Cmp.Company_Id, i_Lang_Code => Cmp.Lang_Code);
    Oper_Groups(i_Company_Id => Cmp.Company_Id, i_Lang_Code => Cmp.Lang_Code);
    Oper_Types(i_Company_Id => Cmp.Company_Id, i_Lang_Code => Cmp.Lang_Code);
    Book_Types(i_Company_Id => Cmp.Company_Id, i_Lang_Code => Cmp.Lang_Code);
    Time_Kinds(i_Company_Id => Cmp.Company_Id, i_Lang_Code => Cmp.Lang_Code);
  end loop;

  Biruni_Route.Context_End;

  commit;
end;
/
