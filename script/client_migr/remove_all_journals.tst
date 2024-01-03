PL/SQL Developer Test script 3.0
162
-- Created on 07.12.2022 by SANJAR 
declare
  v_Old_Company_Id number := 480;
  v_Company_Id     number := 580;

  v_Subcompany_Id number := 4542;
  v_Filial_Id     number := 48905;

  v_Hiring          number := Hpd_Util.Journal_Type_Id(i_Company_Id => v_Company_Id,
                                                       i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Hiring);
  v_Transfer        number := Hpd_Util.Journal_Type_Id(i_Company_Id => v_Company_Id,
                                                       i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Transfer);
  v_Dismissal       number := Hpd_Util.Journal_Type_Id(i_Company_Id => v_Company_Id,
                                                       i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Dismissal);
  v_Schedule_Change number := Hpd_Util.Journal_Type_Id(i_Company_Id => v_Company_Id,
                                                       i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Schedule_Change);

  v_Affected_Divisions Array_Number;

  --------------------------------------------------
  Procedure Remove_Managers is
  begin
    for r in (select *
                from Mhr_Divisions p
               where p.Company_Id = v_Company_Id
                 and p.Filial_Id = v_Filial_Id)
    loop
      Hrm_Api.Division_Manager_Delete(i_Company_Id  => r.Company_Id,
                                      i_Filial_Id   => r.Filial_Id,
                                      i_Division_Id => r.Division_Id);
    end loop;
  
    update Mrf_Robots p
       set p.Manager_Id = null
     where p.Company_Id = v_Company_Id
       and p.Filial_Id = v_Filial_Id
       and p.Manager_Id is not null;
  end;

  -------------------------------------------------- 
  Procedure Remove_Plan_Changes is
  begin
    for r in (select *
                from Htt_Plan_Changes p
               where p.Company_Id = v_Company_Id
                 and p.Filial_Id = v_Filial_Id)
    loop
      if r.Status in (Htt_Pref.c_Change_Status_Approved,
                      Htt_Pref.c_Change_Status_Completed,
                      Htt_Pref.c_Change_Status_Denied) then
        Htt_Api.Change_Reset(i_Company_Id => r.Company_Id,
                             i_Filial_Id  => r.Filial_Id,
                             i_Change_Id  => r.Change_Id);
      end if;
    
      Htt_Api.Change_Delete(i_Company_Id => r.Company_Id,
                            i_Filial_Id  => r.Filial_Id,
                            i_Change_Id  => r.Change_Id);
    end loop;
  end;

  --------------------------------------------------
  Procedure Delete_Journals(i_Journal_Type_Id number) is
  begin
    for r in (select *
                from Hpd_Journals p
               where p.Company_Id = v_Company_Id
                 and p.Filial_Id = v_Filial_Id
                 and p.Journal_Type_Id = i_Journal_Type_Id
                 and exists (select *
                        from Hpd_Journal_Pages Jp
                       where Jp.Company_Id = p.Company_Id
                         and Jp.Filial_Id = p.Filial_Id
                         and Jp.Journal_Id = p.Journal_Id))
    loop
      begin
        if r.Posted = 'Y' then
          Hpd_Api.Journal_Unpost(i_Company_Id => r.Company_Id,
                                 i_Filial_Id  => r.Filial_Id,
                                 i_Journal_Id => r.Journal_Id);
        end if;
      
        Hpd_Api.Journal_Delete(i_Company_Id => r.Company_Id,
                               i_Filial_Id  => r.Filial_Id,
                               i_Journal_Id => r.Journal_Id);
      exception
        when others then
          null;
      end;
    end loop;
  end;
begin
  Ui_Auth.Logon_As_System(v_Company_Id);

    delete Migr_Used_Keys p
   where p.Company_Id = v_Company_Id
     and p.Key_Name = 'vx_hr_emp_job'
     and p.Old_Id in (select q.Emp_Job_Id
                        from Old_Vx_Hr_Emp_Jobs q
                        join Old_Vx_Hr_Employees Ep
                          on Ep.Company_Id = q.Company_Id
                         and Ep.Employee_Id = q.Employee_Id
                         and Ep.Subcompany_Id = v_Subcompany_Id
                       where q.Company_Id = v_Old_Company_Id);
  
  delete Migr_Used_Keys p
   where p.Company_Id = v_Company_Id
     and p.Key_Name = 'page_id'
     and p.Old_Id in (select q.Emp_Job_Id
                        from Old_Vx_Hr_Emp_Jobs q
                        join Old_Vx_Hr_Employees Ep
                          on Ep.Company_Id = q.Company_Id
                         and Ep.Employee_Id = q.Employee_Id
                         and Ep.Subcompany_Id = v_Subcompany_Id
                       where q.Company_Id = v_Old_Company_Id);
  
  delete Migr_Used_Keys p
   where p.Company_Id = v_Company_Id
     and p.Key_Name = 'page_filial_id'
     and p.Old_Id in (select q.Emp_Job_Id
                        from Old_Vx_Hr_Emp_Jobs q
                        join Old_Vx_Hr_Employees Ep
                          on Ep.Company_Id = q.Company_Id
                         and Ep.Employee_Id = q.Employee_Id
                         and Ep.Subcompany_Id = v_Subcompany_Id
                       where q.Company_Id = v_Old_Company_Id);
  
  delete Migr_Used_Keys p
   where p.Company_Id = v_Company_Id
     and p.Key_Name = 'timetable_id'
     and p.Old_Id in (select q.Timetable_Id
                        from Old_Vx_Tp_Timetables q
                        join Old_Vx_Hr_Employees Ep
                          on Ep.Company_Id = q.Company_Id
                         and Ep.Employee_Id = q.Employee_Id
                         and Ep.Subcompany_Id = v_Subcompany_Id
                       where q.Company_Id = v_Old_Company_Id);
  
  Biruni_Route.Context_Begin;
  Remove_Plan_Changes;
  Biruni_Route.Context_End;
  
  Biruni_Route.Context_Begin;
  Remove_Managers;
  Biruni_Route.Context_End;
  
  Biruni_Route.Context_Begin;
  Delete_Journals(v_Schedule_Change);
  Biruni_Route.Context_End;

  Biruni_Route.Context_Begin;
  Delete_Journals(v_Dismissal);
  Biruni_Route.Context_End;
  --
  Biruni_Route.Context_Begin;
  Delete_Journals(v_Transfer);
  Biruni_Route.Context_End;
  -- 
  Biruni_Route.Context_Begin;
  Delete_Journals(v_Hiring);
  Biruni_Route.Context_End;
end;
0
0
