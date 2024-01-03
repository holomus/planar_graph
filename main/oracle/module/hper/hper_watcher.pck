create or replace package Hper_Watcher is
  ----------------------------------------------------------------------------------------------------
  Procedure On_Company_Add(i_Company_Id number);
end Hper_Watcher;
/
create or replace package body Hper_Watcher is
  ----------------------------------------------------------------------------------------------------
  Procedure On_Company_Add(i_Company_Id number) is
    v_Company_Head number := Md_Pref.Company_Head;
    v_Pc_Like      varchar2(10) := Upper(Verifix.Project_Code) || '%';
    v_Query        varchar2(4000);
    r_Task_Group   Ms_Task_Groups%rowtype;
  begin
    v_Query := Md_Util.Translate_Rows_Statement(i_Table     => Zt.Ms_Task_Groups,
                                                i_Lang_Code => z_Md_Companies.Load(i_Company_Id).Lang_Code);
  
    for r in (select *
                from Ms_Task_Groups t
               where t.Company_Id = v_Company_Head
                 and t.Pcode like v_Pc_Like)
    loop
      r_Task_Group               := r;
      r_Task_Group.Company_Id    := i_Company_Id;
      r_Task_Group.Task_Group_Id := Ms_Next.Task_Group_Id;
    
      execute immediate v_Query
        using in r_Task_Group, out r_Task_Group;
    
      z_Ms_Task_Groups.Insert_Row(r_Task_Group);
    end loop;
  end;
  
end Hper_Watcher;
/
