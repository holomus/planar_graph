create or replace package Ui_Vhr137 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Standard_Plans return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Contract_Plans return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Gen_Plans(p Hashmap);
end Ui_Vhr137;
/
create or replace package body Ui_Vhr137 is
  ----------------------------------------------------------------------------------------------------  
  Function t
  (
    i_Message varchar2,
    i_P1      varchar2 := null,
    i_P2      varchar2 := null,
    i_P3      varchar2 := null,
    i_P4      varchar2 := null,
    i_P5      varchar2 := null
  ) return varchar2 is
  begin
    return b.Translate('UI-VHR137:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Standard_Plans return Fazo_Query is
    v_Subordinate_Chiefs    Array_Number := Array_Number();
    v_Subordinate_Divisions Array_Number := Array_Number();
  
    v_Matrix Matrix_Varchar2;
    v_Query  varchar2(32767);
    v_Params Hashmap;
    q        Fazo_Query;
  begin
    v_Query := 'select q.*
                  from hper_plans q
                 where q.company_id = :company_id
                   and q.filial_id = :filial_id
                   and q.plan_kind = :plan_kind';
  
    v_Params := Fazo.Zip_Map('company_id',
                             Ui.Company_Id,
                             'filial_id',
                             Ui.Filial_Id,
                             'plan_kind',
                             Hper_Pref.c_Plan_Kind_Standard,
                             'pt_main',
                             Hper_Pref.c_Plan_Type_Main,
                             'pt_extra',
                             Hper_Pref.c_Plan_Type_Extra);
  
    if Uit_Href.User_Access_All_Employees = 'N' then
      v_Subordinate_Divisions := Uit_Href.Get_Subordinate_Divisions(o_Subordinate_Chiefs => v_Subordinate_Chiefs,
                                                                    i_Direct             => true,
                                                                    i_Indirect           => true,
                                                                    i_Manual             => true);
    
      v_Query := v_Query || ' and q.division_id member of :subordinate_divisions';
    
      v_Params.Put('subordinate_divisions', v_Subordinate_Divisions);
    end if;
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('plan_id', 'division_id', 'job_id', 'rank_id');
    q.Date_Field('plan_date');
    q.Varchar2_Field('main_calc_type', 'extra_calc_type', 'employment_type', 'note');
  
    v_Matrix := Hper_Util.Plan_Calc_Types;
    q.Option_Field('main_calc_type_name', 'main_calc_type', v_Matrix(1), v_Matrix(2));
    q.Option_Field('extra_calc_type_name', 'extra_calc_type', v_Matrix(1), v_Matrix(2));
  
    q.Multi_Number_Field('main_type_ids',
                         'select q.plan_id,
                                 q.plan_type_id
                            from hper_plan_items q
                           where q.company_id = :company_id
                             and q.filial_id = :filial_id
                             and q.plan_type = :pt_main',
                         '$plan_id=@plan_id',
                         'plan_type_id');
    q.Multi_Number_Field('extra_type_ids',
                         'select q.plan_id,
                                 q.plan_type_id
                            from hper_plan_items q
                           where q.company_id = :company_id
                             and q.filial_id = :filial_id
                             and q.plan_type = :pt_extra',
                         '$plan_id=@plan_id',
                         'plan_type_id');
  
    v_Matrix := Hpd_Util.Employment_Types;
    q.Option_Field('employment_type_name', 'employment_type', v_Matrix(1), v_Matrix(2));
  
    q.Refer_Field('position_name',
                  'position_id',
                  'hrm_positions',
                  'position_id',
                  'name',
                  'select *
                     from hrm_positions q
                    where q.company_id = :company_id
                      and q.filial_id = :filial_id');
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
    q.Refer_Field('main_type_names',
                  'main_type_ids',
                  'hper_plan_types',
                  'plan_type_id',
                  'name',
                  'select *
                     from hper_plan_types q
                    where q.company_id = :company_id
                      and q.filial_id = :filial_id');
    q.Refer_Field('extra_type_names',
                  'extra_type_ids',
                  'hper_plan_types',
                  'plan_type_id',
                  'name',
                  'select *
                     from hper_plan_types q
                    where q.company_id = :company_id
                      and q.filial_id = :filial_id');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Contract_Plans return Fazo_Query is
    v_Matrix Matrix_Varchar2;
    v_Query  varchar2(32767);
    q        Fazo_Query;
  begin
    v_Query := 'select q.plan_id,
                       q.plan_date,
                       q.main_calc_type,
                       q.extra_calc_type,
                       q.journal_page_id,
                       q.employment_type,
                       w.staff_id,
                       w.employee_id,
                       r.robot_id,
                       rb.org_unit_id,
                       t.division_id,
                       t.job_id,
                       r.rank_id,
                       q.note
                  from hper_plans q
                  join hpd_journal_pages w
                    on w.company_id = q.company_id
                   and w.filial_id = q.filial_id
                   and w.page_id = q.journal_page_id
                  join hpd_page_robots r
                    on r.company_id = w.company_id
                   and r.filial_id = w.filial_id
                   and r.page_id = w.page_id
                  join mrf_robots t
                    on t.company_id = r.company_id
                   and t.filial_id = r.filial_id
                   and t.robot_id = r.robot_id
                  join hrm_robots rb
                    on rb.company_id = r.company_id
                   and rb.filial_id = r.filial_id
                   and rb.robot_id = r.robot_id
                 where q.company_id = :company_id
                   and q.filial_id = :filial_id
                   and q.plan_kind = :plan_kind';
  
    v_Query := Uit_Href.Make_Subordinated_Query(i_Query          => v_Query,
                                                i_Include_Self   => false,
                                                i_Include_Manual => true);
  
    q := Fazo_Query(v_Query,
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'plan_kind',
                                 Hper_Pref.c_Plan_Kind_Contract,
                                 'pt_main',
                                 Hper_Pref.c_Plan_Type_Main,
                                 'pt_extra',
                                 Hper_Pref.c_Plan_Type_Extra));
  
    q.Number_Field('plan_id',
                   'journal_page_id',
                   'staff_id',
                   'employee_id',
                   'robot_id',
                   'division_id',
                   'job_id',
                   'rank_id');
    q.Date_Field('plan_date');
    q.Varchar2_Field('main_calc_type',
                     'extra_calc_type',
                     'employment_type',
                     'note',
                     'access_level');
  
    v_Matrix := Hper_Util.Plan_Calc_Types;
    q.Option_Field('main_calc_type_name', 'main_calc_type', v_Matrix(1), v_Matrix(2));
    q.Option_Field('extra_calc_type_name', 'extra_calc_type', v_Matrix(1), v_Matrix(2));
  
    v_Matrix := Hpd_Util.Employment_Types;
    q.Option_Field('employment_type_name', 'employment_type', v_Matrix(1), v_Matrix(2));
  
    v_Matrix := Href_Util.User_Acces_Levels;
    q.Option_Field('access_level_name', 'access_level', v_Matrix(1), v_Matrix(2));
  
    q.Multi_Number_Field('main_type_ids',
                         'select q.plan_id,
                                 q.plan_type_id
                            from hper_plan_items q
                           where q.company_id = :company_id
                             and q.filial_id = :filial_id    
                             and q.plan_type = :pt_main',
                         '$plan_id=@plan_id',
                         'plan_type_id');
    q.Multi_Number_Field('extra_type_ids',
                         'select q.plan_id,
                                 q.plan_type_id
                            from hper_plan_items q
                           where q.company_id = :company_id
                             and q.filial_id = :filial_id
                             and q.plan_type = :pt_extra',
                         '$plan_id=@plan_id',
                         'plan_type_id');
  
    q.Refer_Field('employee_name',
                  'employee_id',
                  'mr_natural_persons',
                  'person_id',
                  'name',
                  Uit_Href.Person_Refer_Field_Filter_Query(i_Include_Self   => false,
                                                           i_Include_Manual => true));
  
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
    q.Refer_Field('main_type_names',
                  'main_type_ids',
                  'hper_plan_types',
                  'plan_type_id',
                  'name',
                  'select *
                     from hper_plan_types q
                    where q.company_id = :company_id
                      and q.filial_id = :filial_id');
    q.Refer_Field('extra_type_names',
                  'extra_type_ids',
                  'hper_plan_types',
                  'plan_type_id',
                  'name',
                  'select *
                     from hper_plan_types q
                    where q.company_id = :company_id
                      and q.filial_id = :filial_id');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap is
  begin
    return Fazo.Zip_Map('ual_direct_employee',
                        Href_Pref.c_User_Access_Level_Direct_Employee,
                        'access_all_employee',
                        Uit_Href.User_Access_All_Employees,
                        'exist_direct_employee',
                        Uit_Href.Exist_Direct_Employee);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    r_Plan     Hper_Plans%rowtype;
    r_Page     Hpd_Journal_Pages%rowtype;
    v_Plan_Ids Array_Number := p.r_Array_Number('plan_id');
  
    v_Has_Access_All        boolean := Uit_Href.User_Access_All_Employees = 'Y';
    v_Subordinate_Chiefs    Array_Number;
    v_Subordinate_Divisions Array_Number;
  
    -------------------------------------------------- 
    Procedure Assert_Access_Division(i_Division_Id number) is
    begin
      if not v_Has_Access_All and i_Division_Id not member of v_Subordinate_Divisions then
        b.Raise_Error(t('user has no access to this division, division_id=$1', i_Division_Id));
      end if;
    end;
  begin
    v_Subordinate_Divisions := Uit_Href.Get_Subordinate_Divisions(o_Subordinate_Chiefs => v_Subordinate_Chiefs,
                                                                  i_Direct             => true,
                                                                  i_Indirect           => true,
                                                                  i_Manual             => true);
  
    for i in 1 .. v_Plan_Ids.Count
    loop
      r_Plan := z_Hper_Plans.Lock_Load(i_Company_Id => Ui.Company_Id,
                                       i_Filial_Id  => Ui.Filial_Id,
                                       i_Plan_Id    => v_Plan_Ids(i));
    
      if r_Plan.Plan_Kind = Hper_Pref.c_Plan_Kind_Standard then
        Assert_Access_Division(r_Plan.Division_Id);
      else
        r_Page := z_Hpd_Journal_Pages.Lock_Load(i_Company_Id => r_Plan.Company_Id,
                                                i_Filial_Id  => r_Plan.Filial_Id,
                                                i_Page_Id    => r_Plan.Journal_Page_Id);
      
        Uit_Href.Assert_Access_To_Staff(i_Staff_Id => r_Page.Staff_Id,
                                        i_Self     => false,
                                        i_Undirect => false,
                                        i_Manual   => false);
      end if;
    
      Hper_Api.Plan_Delete(i_Company_Id => r_Plan.Company_Id,
                           i_Filial_Id  => r_Plan.Filial_Id,
                           i_Plan_Id    => r_Plan.Plan_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Gen_Plans(p Hashmap) is
  begin
    Uit_Href.Assert_Has_Access_Direct;
  
    Hper_Api.Gen_Plans(i_Company_Id => Ui.Company_Id,
                       i_Filial_Id  => Ui.Filial_Id,
                       i_Date       => p.r_Date('plan_date', Href_Pref.c_Date_Format_Month));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Hper_Plans
       set Company_Id      = null,
           Filial_Id       = null,
           Plan_Id         = null,
           Plan_Date       = null,
           Plan_Kind       = null,
           Main_Calc_Type  = null,
           Extra_Calc_Type = null,
           Division_Id     = null,
           Job_Id          = null,
           Rank_Id         = null,
           Employment_Type = null;
    update Hper_Plan_Items
       set Company_Id   = null,
           Filial_Id    = null,
           Plan_Id      = null,
           Plan_Type_Id = null,
           Plan_Type    = null;
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
    update Hper_Plan_Types
       set Company_Id   = null,
           Filial_Id    = null,
           Plan_Type_Id = null,
           name         = null;
    update Hpd_Journal_Pages
       set Company_Id  = null,
           Filial_Id   = null,
           Journal_Id  = null,
           Page_Id     = null,
           Employee_Id = null,
           Staff_Id    = null;
    update Hpd_Page_Robots
       set Company_Id = null,
           Filial_Id  = null,
           Page_Id    = null,
           Robot_Id   = null,
           Rank_Id    = null;
    update Mrf_Robots
       set Company_Id  = null,
           Filial_Id   = null,
           Robot_Id    = null,
           Division_Id = null,
           Job_Id      = null;
    update Hrm_Robots
       set Company_Id  = null,
           Filial_Id   = null,
           Robot_Id    = null,
           Org_Unit_Id = null;
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null;
    update Mhr_Employees
       set Company_Id  = null,
           Filial_Id   = null,
           Employee_Id = null;
  end;

end Ui_Vhr137;
/
