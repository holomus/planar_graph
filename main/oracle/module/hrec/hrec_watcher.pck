create or replace package Hrec_Watcher is
  ----------------------------------------------------------------------------------------------------
  Procedure On_Company_Add(i_Company_Id number);
end Hrec_Watcher;
/
create or replace package body Hrec_Watcher is
  ----------------------------------------------------------------------------------------------------
  Procedure On_Company_Add(i_Company_Id number) is
    v_Company_Head       number := Md_Pref.c_Company_Head;
    v_Lang_Code          varchar2(5) := z_Md_Companies.Load(i_Company_Id).Lang_Code;
    v_Pcode_Like         varchar2(10) := Upper(Verifix.Project_Code) || '%';
    v_Query              varchar2(4000);
    v_Vacancy_Type_Query varchar2(4000);
    r_Stage              Hrec_Stages%rowtype;
    r_Funnel             Hrec_Funnels%rowtype;
    r_Vacancy_Group      Hrec_Vacancy_Groups%rowtype;
    r_Vacancy_Type       Hrec_Vacancy_Types%rowtype;
  begin
    -- add default vacancy group
    v_Query := Md_Util.Translate_Rows_Statement(i_Table     => Zt.Hrec_Vacancy_Groups,
                                                i_Lang_Code => v_Lang_Code);
  
    v_Vacancy_Type_Query := Md_Util.Translate_Rows_Statement(i_Table     => Zt.Hrec_Vacancy_Types,
                                                             i_Lang_Code => v_Lang_Code);
  
    for r in (select *
                from Hrec_Vacancy_Groups q
               where q.Company_Id = v_Company_Head
                 and q.Pcode like v_Pcode_Like
               order by q.Order_No)
    loop
      r_Vacancy_Group                  := r;
      r_Vacancy_Group.Company_Id       := i_Company_Id;
      r_Vacancy_Group.Vacancy_Group_Id := Hrec_Next.Vacancy_Group_Id;
    
      execute immediate v_Query
        using in r_Vacancy_Group, out r_Vacancy_Group;
    
      z_Hrec_Vacancy_Groups.Save_Row(r_Vacancy_Group);
    
      for t in (select *
                  from Hrec_Vacancy_Types w
                 where w.Company_Id = v_Company_Head
                   and w.Vacancy_Group_Id = r.Vacancy_Group_Id
                   and w.Pcode like v_Pcode_Like)
      loop
        r_Vacancy_Type                  := t;
        r_Vacancy_Type.Company_Id       := i_Company_Id;
        r_Vacancy_Type.Vacancy_Group_Id := r_Vacancy_Group.Vacancy_Group_Id;
        r_Vacancy_Type.Vacancy_Type_Id  := Hrec_Next.Vacancy_Type_Id;
      
        execute immediate v_Vacancy_Type_Query
          using in r_Vacancy_Type, out r_Vacancy_Type;
      
        z_Hrec_Vacancy_Types.Save_Row(r_Vacancy_Type);
      end loop;
    end loop;
  
    -- add default stages
    v_Query := Md_Util.Translate_Rows_Statement(i_Table     => Zt.Hrec_Stages,
                                                i_Lang_Code => v_Lang_Code);
  
    for r in (select *
                from Hrec_Stages t
               where t.Company_Id = v_Company_Head
                 and t.Pcode like v_Pcode_Like
               order by t.Order_No)
    loop
      r_Stage            := r;
      r_Stage.Company_Id := i_Company_Id;
      r_Stage.Stage_Id   := Hrec_Next.Stage_Id;
    
      execute immediate v_Query
        using in r_Stage, out r_Stage;
    
      z_Hrec_Stages.Save_Row(r_Stage);
    end loop;
  
    -- add default funnels
    v_Query := Md_Util.Translate_Rows_Statement(i_Table     => Zt.Hrec_Funnels,
                                                i_Lang_Code => v_Lang_Code);
  
    for r in (select *
                from Hrec_Funnels t
               where t.Company_Id = v_Company_Head
                 and t.Pcode like v_Pcode_Like)
    loop
      r_Funnel            := r;
      r_Funnel.Company_Id := i_Company_Id;
      r_Funnel.Funnel_Id  := Hrec_Next.Funnel_Id;
    
      execute immediate v_Query
        using in r_Funnel, out r_Funnel;
    
      z_Hrec_Funnels.Save_Row(r_Funnel);
    end loop;
  
    -- connect todo stage with Head Hunter's To do stage
  
    z_Hrec_Hh_Integration_Stages.Save_One(i_Company_Id => i_Company_Id,
                                          i_Stage_Id   => Hrec_Util.Stage_Id_By_Pcode(i_Company_Id => i_Company_Id,
                                                                                      i_Pcode      => Hrec_Pref.c_Pcode_Stage_Todo),
                                          i_Stage_Code => Hrec_Pref.c_Hh_Todo_Stage_Code);
  end;

end Hrec_Watcher;
/
