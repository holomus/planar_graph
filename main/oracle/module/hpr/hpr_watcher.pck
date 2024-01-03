create or replace package Hpr_Watcher is
  ----------------------------------------------------------------------------------------------------
  Procedure On_Company_Add(i_Company_Id number);
end Hpr_Watcher;
/
create or replace package body Hpr_Watcher is
  ----------------------------------------------------------------------------------------------------
  Procedure On_Company_Add(i_Company_Id number) is
    v_Company_Head  number := Md_Pref.c_Company_Head;
    v_Pcode_Like    varchar2(10) := Upper(Verifix.Project_Code) || '%';
    v_Query         varchar2(4000);
    c_Oper_Group_Id Fazo.Number_Id_Aat;
    c_Book_Type_Id  Fazo.Number_Id_Aat;
    r_Oper_Group    Hpr_Oper_Groups%rowtype;
    r_Oper_Type     Hpr_Oper_Types%rowtype;
    r_Book_Type     Hpr_Book_Types%rowtype;
    v_Oper_Type     Hpr_Pref.Oper_Type_Rt;
  begin
    -- add default operation groups
    v_Query := Md_Util.Translate_Rows_Statement(i_Table     => Zt.Hpr_Oper_Groups,
                                                i_Lang_Code => z_Md_Companies.Load(i_Company_Id).Lang_Code);
  
    for r in (select *
                from Hpr_Oper_Groups t
               where t.Company_Id = v_Company_Head
                 and t.Pcode like v_Pcode_Like
               order by t.Oper_Group_Id)
    loop
      r_Oper_Group               := r;
      r_Oper_Group.Company_Id    := i_Company_Id;
      r_Oper_Group.Oper_Group_Id := Hpr_Next.Oper_Group_Id;
    
      execute immediate v_Query
        using in r_Oper_Group, out r_Oper_Group;
    
      z_Hpr_Oper_Groups.Save_Row(r_Oper_Group);
    
      c_Oper_Group_Id(r.Oper_Group_Id) := r_Oper_Group.Oper_Group_Id;
    end loop;
  
    -- add default oper types
    for r in (select *
                from Mpr_Oper_Types t
               where t.Company_Id = v_Company_Head
                 and t.Pcode like v_Pcode_Like
               order by t.Oper_Type_Id)
    loop
      v_Oper_Type.Oper_Type := r;
      r_Oper_Type           := z_Hpr_Oper_Types.Load(i_Company_Id   => v_Company_Head,
                                                     i_Oper_Type_Id => r.Oper_Type_Id);
    
      v_Oper_Type.Oper_Type.Company_Id   := i_Company_Id;
      v_Oper_Type.Oper_Type.Oper_Type_Id := Mpr_Next.Oper_Type_Id;
    
      if r_Oper_Type.Oper_Group_Id is not null then
        v_Oper_Type.Oper_Group_Id := c_Oper_Group_Id(r_Oper_Type.Oper_Group_Id);
      else
        v_Oper_Type.Oper_Group_Id := null;
      end if;
    
      v_Oper_Type.Estimation_Type    := r_Oper_Type.Estimation_Type;
      v_Oper_Type.Estimation_Formula := Hpr_Util.Formula_Fix(i_Company_Id => i_Company_Id,
                                                             i_Formula    => r_Oper_Type.Estimation_Formula);
    
      Hpr_Api.Oper_Type_Save(v_Oper_Type);
    
      z_Mpr_Oper_Types.Update_One(i_Company_Id   => i_Company_Id,
                                  i_Oper_Type_Id => v_Oper_Type.Oper_Type.Oper_Type_Id,
                                  i_Pcode        => Option_Varchar2(v_Oper_Type.Oper_Type.Pcode));
    end loop;
  
    -- add default book types
    v_Query := Md_Util.Translate_Rows_Statement(i_Table     => Zt.Hpr_Book_Types,
                                                i_Lang_Code => z_Md_Companies.Load(i_Company_Id).Lang_Code);
  
    for r in (select *
                from Hpr_Book_Types t
               where t.Company_Id = v_Company_Head
                 and t.Pcode like v_Pcode_Like
               order by t.Book_Type_Id)
    loop
      r_Book_Type              := r;
      r_Book_Type.Company_Id   := i_Company_Id;
      r_Book_Type.Book_Type_Id := Hpr_Next.Book_Type_Id;
    
      execute immediate v_Query
        using in r_Book_Type, out r_Book_Type;
    
      z_Hpr_Book_Types.Save_Row(r_Book_Type);
    
      c_Book_Type_Id(r.Book_Type_Id) := r_Book_Type.Book_Type_Id;
    end loop;
  
    for r in (select *
                from Hpr_Book_Type_Binds t
               where t.Company_Id = v_Company_Head
               order by t.Book_Type_Id)
    loop
      z_Hpr_Book_Type_Binds.Insert_One(i_Company_Id    => i_Company_Id,
                                       i_Book_Type_Id  => c_Book_Type_Id(r.Book_Type_Id),
                                       i_Oper_Group_Id => c_Oper_Group_Id(r.Oper_Group_Id));
    end loop;
  end;

end Hpr_Watcher;
/
