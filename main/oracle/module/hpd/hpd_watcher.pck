create or replace package Hpd_Watcher is
  ----------------------------------------------------------------------------------------------------
  Procedure On_Company_Add(i_Company_Id number);
end Hpd_Watcher;
/
create or replace package body Hpd_Watcher is
  ----------------------------------------------------------------------------------------------------
  Procedure On_Company_Add(i_Company_Id number) is
    v_Company_Head     number := Md_Pref.c_Company_Head;
    v_Pcode_Like       varchar2(10) := Upper(Verifix.Project_Code) || '%';
    v_Query            varchar2(4000);
    r_Journal_Type     Hpd_Journal_Types%rowtype;
    r_Application_Type Hpd_Application_Types%rowtype;
    v_Lang_Code        varchar2(5) := z_Md_Companies.Load(i_Company_Id).Lang_Code;
  begin
    -- add default journal types
    v_Query := Md_Util.Translate_Rows_Statement(i_Table     => Zt.Hpd_Journal_Types,
                                                i_Lang_Code => v_Lang_Code);
  
    for r in (select *
                from Hpd_Journal_Types t
               where t.Company_Id = v_Company_Head
                 and t.Pcode like v_Pcode_Like
               order by t.Order_No)
    loop
      r_Journal_Type                 := r;
      r_Journal_Type.Company_Id      := i_Company_Id;
      r_Journal_Type.Journal_Type_Id := Hpd_Next.Journal_Type_Id;
    
      execute immediate v_Query
        using in r_Journal_Type, out r_Journal_Type;
    
      z_Hpd_Journal_Types.Save_Row(r_Journal_Type);
    end loop;
  
    -- add default application types
    v_Query := Md_Util.Translate_Rows_Statement(i_Table     => Zt.Hpd_Application_Types,
                                                i_Lang_Code => v_Lang_Code);
  
    for r in (select *
                from Hpd_Application_Types t
               where t.Company_Id = v_Company_Head
                 and t.Pcode like v_Pcode_Like
               order by t.Order_No)
    loop
      r_Application_Type                     := r;
      r_Application_Type.Company_Id          := i_Company_Id;
      r_Application_Type.Application_Type_Id := Hpd_Next.Application_Type_Id;
    
      execute immediate v_Query
        using in r_Application_Type, out r_Application_Type;
    
      z_Hpd_Application_Types.Save_Row(r_Application_Type);
    end loop;
  end;

end Hpd_Watcher;
/
