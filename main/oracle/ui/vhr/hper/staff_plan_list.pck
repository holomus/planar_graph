create or replace package Ui_Vhr134 is
  ----------------------------------------------------------------------------------------------------
  Function Query(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Set_Draft(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Set_New(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Set_Waiting(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Set_Completed(p Hashmap);
end Ui_Vhr134;
/
create or replace package body Ui_Vhr134 is
  ----------------------------------------------------------------------------------------------------
  Function Query(p Hashmap) return Fazo_Query is
    q        Fazo_Query;
    v_Query  varchar2(32767);
    v_Matrix Matrix_Varchar2;
  begin
    v_Query := 'select q.*,
                       (select r.person_id
                          from mrf_robots r
                         where r.company_id = :company_id
                           and r.filial_id = :filial_id
                           and r.robot_id = (select case 
                                                     when dm.manager_id <> w.robot_id then
                                                       dm.manager_id
                                                     else
                                                       (select md.manager_id
                                                          from mhr_parent_divisions pd
                                                          join mrf_division_managers md
                                                            on md.company_id = pd.company_id
                                                           and md.filial_id = pd.filial_id
                                                           and md.division_id = pd.parent_id
                                                         where pd.company_id = dm.company_id
                                                           and pd.filial_id = dm.filial_id
                                                           and pd.division_id = dm.division_id
                                                           and pd.lvl = 1)
                                                    end
                                               from mrf_division_managers dm
                                              where dm.company_id = r.company_id
                                                and dm.filial_id = r.filial_id
                                                and dm.division_id = w.org_unit_id)) manager_id,
                       w.employee_id,
                       rb.org_unit_id
                  from hper_staff_plans q
                  join href_staffs w
                    on w.company_id = q.company_id
                   and w.filial_id = q.filial_id
                   and w.staff_id = q.staff_id
                  join hpd_page_robots pr
                    on pr.company_id = q.company_id
                   and pr.filial_id = q.filial_id
                   and pr.page_id = q.journal_page_id
                  join hrm_robots rb
                    on rb.company_id = pr.company_id
                   and rb.filial_id = pr.filial_id
                   and rb.robot_id = pr.robot_id
                 where q.company_id = :company_id
                   and q.filial_id = :filial_id
                   and (q.plan_date = :plan_date or :plan_date is null)';
  
    v_Query := Uit_Href.Make_Subordinated_Query(v_Query);
  
    q := Fazo_Query(v_Query,
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'plan_date',
                                 p.o_Date('plan_date', Href_Pref.c_Date_Format_Month)));
  
    q.Number_Field('staff_plan_id',
                   'staff_id',
                   'journal_page_id',
                   'division_id',
                   'job_id',
                   'rank_id',
                   'manager_id',
                   'created_by');
    q.Number_Field('main_plan_amount',
                   'extra_plan_amount',
                   'main_fact_amount',
                   'extra_fact_amount',
                   'main_fact_percent',
                   'extra_fact_percent',
                   'c_main_fact_percent',
                   'c_extra_fact_percent',
                   'employee_id');
    q.Date_Field('plan_date',
                 'month_begin_date',
                 'month_end_date',
                 'begin_date',
                 'end_date',
                 'created_on');
    q.Varchar2_Field('employment_type', 'status', 'note', 'access_level');
  
    v_Matrix := Hper_Util.Staff_Plan_Statuses;
    q.Option_Field('status_name', 'status', v_Matrix(1), v_Matrix(2));
  
    v_Matrix := Hpd_Util.Employment_Types;
    q.Option_Field('employment_type_name', 'employment_type', v_Matrix(1), v_Matrix(2));
  
    v_Matrix := Href_Util.User_Acces_Levels;
    q.Option_Field('access_level_name', 'access_level', v_Matrix(1), v_Matrix(2));
  
    q.Refer_Field('staff_name',
                  'employee_id',
                  'mr_natural_persons',
                  'person_id',
                  'name',
                  Uit_Href.Person_Refer_Field_Filter_Query);
    q.Refer_Field('manager_name',
                  'manager_id',
                  'mr_natural_persons',
                  'person_id',
                  'name',
                  Uit_Href.Person_Refer_Field_Filter_Query);
    q.Refer_Field('division_name',
                  'division_id',
                  Uit_Hrm.Divisions_Query(i_Only_Departments => false),
                  'division_id',
                  'name',
                  Uit_Hrm.Departments_Query);
    q.Refer_Field('job_name',
                  'job_id',
                  'mhr_jobs',
                  'job_id',
                  'name',
                  'select *
                     from mhr_jobs q
                    where q.company_id = :company_id
                      and q.filial_id = :filial_id');
    q.Refer_Field('rank_name',
                  'rank_id',
                  'mhr_ranks',
                  'rank_id',
                  'name',
                  'select *
                     from mhr_ranks q
                    where q.company_id = :company_id
                      and q.filial_id = :filial_id');
    q.Refer_Field('created_by_name',
                  'created_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select * 
                     from md_users q
                    where q.company_id = :company_id');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap is
  begin
    return Fazo.Zip_Map('ual_direct_employee',
                        Href_Pref.c_User_Access_Level_Direct_Employee,
                        'ual_undirect_employee',
                        Href_Pref.c_User_Access_Level_Undirect_Employee);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    r_Data           Hper_Staff_Plans%rowtype;
    v_Staff_Plan_Ids Array_Number := Fazo.Sort(p.r_Array_Number('staff_plan_id'));
  begin
    for i in 1 .. v_Staff_Plan_Ids.Count
    loop
      r_Data := z_Hper_Staff_Plans.Load(i_Company_Id    => Ui.Company_Id,
                                        i_Filial_Id     => Ui.Filial_Id,
                                        i_Staff_Plan_Id => v_Staff_Plan_Ids(i));
    
      Uit_Href.Assert_Access_To_Staff(i_Staff_Id => r_Data.Staff_Id,
                                      i_All      => false,
                                      i_Self     => false,
                                      i_Undirect => false,
                                      i_Manual   => false);
    
      Hper_Api.Staff_Plan_Delete(i_Company_Id    => Ui.Company_Id,
                                 i_Filial_Id     => Ui.Filial_Id,
                                 i_Staff_Plan_Id => v_Staff_Plan_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Set_Draft(p Hashmap) is
    r_Data           Hper_Staff_Plans%rowtype;
    v_Staff_Plan_Ids Array_Number := p.r_Array_Number('staff_plan_id');
  begin
    for i in 1 .. v_Staff_Plan_Ids.Count
    loop
      r_Data := z_Hper_Staff_Plans.Load(i_Company_Id    => Ui.Company_Id,
                                        i_Filial_Id     => Ui.Filial_Id,
                                        i_Staff_Plan_Id => v_Staff_Plan_Ids(i));
    
      Uit_Href.Assert_Access_To_Staff(i_Staff_Id => r_Data.Staff_Id,
                                      i_All      => false,
                                      i_Self     => false,
                                      i_Undirect => false,
                                      i_Manual   => false);
    
      Hper_Api.Staff_Plan_Set_Draft(i_Company_Id    => Ui.Company_Id,
                                    i_Filial_Id     => Ui.Filial_Id,
                                    i_Staff_Plan_Id => v_Staff_Plan_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Set_New(p Hashmap) is
    r_Data Hper_Staff_Plans%rowtype;
    v_Ids  Array_Number := p.r_Array_Number('staff_plan_id');
  begin
    for i in 1 .. v_Ids.Count
    loop
      r_Data := z_Hper_Staff_Plans.Load(i_Company_Id    => Ui.Company_Id,
                                        i_Filial_Id     => Ui.Filial_Id,
                                        i_Staff_Plan_Id => v_Ids(i));
    
      Uit_Href.Assert_Access_To_Staff(i_Staff_Id => r_Data.Staff_Id,
                                      i_All      => false,
                                      i_Self     => false,
                                      i_Undirect => false,
                                      i_Manual   => false);
    
      Hper_Api.Staff_Plan_Set_New(i_Company_Id    => Ui.Company_Id,
                                  i_Filial_Id     => Ui.Filial_Id,
                                  i_Staff_Plan_Id => v_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Set_Waiting(p Hashmap) is
    r_Data Hper_Staff_Plans%rowtype;
    v_Ids  Array_Number := p.r_Array_Number('staff_plan_id');
  begin
    for i in 1 .. v_Ids.Count
    loop
      r_Data := z_Hper_Staff_Plans.Load(i_Company_Id    => Ui.Company_Id,
                                        i_Filial_Id     => Ui.Filial_Id,
                                        i_Staff_Plan_Id => v_Ids(i));
    
      Uit_Href.Assert_Access_To_Staff(i_Staff_Id => r_Data.Staff_Id,
                                      i_All      => false,
                                      i_Self     => false,
                                      i_Undirect => false,
                                      i_Manual   => false);
    
      Hper_Api.Staff_Plan_Set_Waiting(i_Company_Id    => Ui.Company_Id,
                                      i_Filial_Id     => Ui.Filial_Id,
                                      i_Staff_Plan_Id => v_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Set_Completed(p Hashmap) is
    r_Data Hper_Staff_Plans%rowtype;
    v_Ids  Array_Number := p.r_Array_Number('staff_plan_id');
  begin
    for i in 1 .. v_Ids.Count
    loop
      r_Data := z_Hper_Staff_Plans.Load(i_Company_Id    => Ui.Company_Id,
                                        i_Filial_Id     => Ui.Filial_Id,
                                        i_Staff_Plan_Id => v_Ids(i));
    
      Uit_Href.Assert_Access_To_Staff(i_Staff_Id => r_Data.Staff_Id,
                                      i_All      => false,
                                      i_Self     => false,
                                      i_Manual   => false);
    
      Hper_Api.Staff_Plan_Set_Completed(i_Company_Id    => Ui.Company_Id,
                                        i_Filial_Id     => Ui.Filial_Id,
                                        i_Staff_Plan_Id => v_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Hper_Staff_Plans
       set Company_Id           = null,
           Filial_Id            = null,
           Staff_Plan_Id        = null,
           Staff_Id             = null,
           Plan_Date            = null,
           Month_Begin_Date     = null,
           Month_End_Date       = null,
           Journal_Page_Id      = null,
           Division_Id          = null,
           Job_Id               = null,
           Rank_Id              = null,
           Employment_Type      = null,
           Begin_Date           = null,
           End_Date             = null,
           Main_Plan_Amount     = null,
           Extra_Plan_Amount    = null,
           Main_Fact_Amount     = null,
           Extra_Fact_Amount    = null,
           Main_Fact_Percent    = null,
           Extra_Fact_Percent   = null,
           c_Main_Fact_Percent  = null,
           c_Extra_Fact_Percent = null,
           Status               = null,
           Note                 = null,
           Created_By           = null,
           Created_On           = null;
    update Href_Staffs
       set Company_Id  = null,
           Filial_Id   = null,
           Staff_Id    = null,
           Employee_Id = null;
    update Hpd_Page_Robots
       set Company_Id = null,
           Filial_Id  = null,
           Page_Id    = null;
    update Hrm_Robots
       set Company_Id  = null,
           Filial_Id   = null,
           Robot_Id    = null,
           Org_Unit_Id = null;
    update Mrf_Division_Managers
       set Company_Id  = null,
           Filial_Id   = null,
           Division_Id = null,
           Manager_Id  = null;
    update Mrf_Robots
       set Company_Id = null,
           Filial_Id  = null,
           Robot_Id   = null;
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null;
    update Mhr_Divisions
       set Company_Id  = null,
           Filial_Id   = null,
           Division_Id = null,
           name        = null;
    update Mhr_Jobs
       set Company_Id = null,
           Filial_Id  = null,
           Job_Id     = null,
           name       = null;
    update Mhr_Ranks
       set Company_Id = null,
           Filial_Id  = null,
           Rank_Id    = null,
           name       = null;
    update Md_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null;
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           name       = null;
  end;

end Ui_Vhr134;
/
