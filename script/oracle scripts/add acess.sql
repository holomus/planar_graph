declare
  v_Forms Array_Varchar2 := Array_Varchar2('/vhr/hpd/overtime+add',
                                           '/vhr/hpd/overtime+edit',
                                           '/vhr/hrm/job_template+add',
                                           '/vhr/hrm/job_template+edit',
                                           '/vhr/hrm/job_template_list');

  v_Form varchar2(1000);
begin
  for r in (select *
              from Md_Companies t
             where t.State = 'A')
  loop
    Biruni_Route.Context_Begin;
    Ui_Context.Init_Migr(i_Company_Id   => r.Company_Id,
                         i_Filial_Id    => Md_Pref.Filial_Head(r.Company_Id),
                         i_User_Id      => Md_Pref.User_System(r.Company_Id),
                         i_Project_Code => Verifix.Project_Code);
    for i in 1 .. v_Forms.Count
    loop
      v_Form := v_Forms(i);
    
      Md_Api.Form_Action_Grant(i_Company_Id => r.Company_Id,
                               i_Role_Id    => Md_Pref.Role_Id(i_Company_Id => r.Company_Id,
                                                               i_Pcode      => 'VHR:1'),
                               i_Form       => v_Form,
                               i_Action_Key => '*');
      for k in (select t.Form, t.Action_Key
                  from Md_Form_Actions t
                 where t.Form = v_Form)
      loop
        Md_Api.Form_Action_Grant(i_Company_Id => r.Company_Id,
                                 i_Role_Id    => Md_Pref.Role_Id(i_Company_Id => r.Company_Id,
                                                                 i_Pcode      => 'VHR:1'),
                                 i_Form       => k.Form,
                                 i_Action_Key => k.Action_Key);
      end loop;
    end loop;
  
    Biruni_Route.Context_End;
  end loop;

  commit;
end;
/
