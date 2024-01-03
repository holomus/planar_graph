create or replace package Ui_Vhr333 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Schedules return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Block_Employee_Tracking(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Unblock_Employee_Tracking(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Get_Org_Units(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Change_Org_Unit(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Change_Employee_Activation(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Change_User_Activation(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Change_Schedule(p Hashmap);
end Ui_Vhr333;
/
create or replace package body Ui_Vhr333 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Schedules return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('htt_schedules',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'state',
                                 'A'),
                    true);
  
    q.Number_Field('schedule_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query(p Hashmap) return Fazo_Query is
    v_Query  varchar2(32767);
    v_Params Hashmap := Hashmap;
    v_Matrix Matrix_Varchar2;
    q        Fazo_Query;
  begin
    v_Query := 'select q.employee_id,
                       q.employee_number,
                       q.state,
                       decode(q.state, ''A'', ''Y'', ''N'') as employee_activated,
                       q.created_by,
                       q.created_on,
                       q.modified_by,
                       q.modified_on,
                       s.staff_id,
                       s.hiring_date,
                       s.dismissal_date,
                       (select r.person_id
                          from mrf_robots r
                         where r.company_id = :company_id
                           and r.filial_id = :filial_id
                           and r.robot_id = (select case 
                                                     when dm.manager_id <> s.robot_id then
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
                                                and dm.division_id = s.org_unit_id)) manager_id,
                       s.division_id,
                       s.org_unit_id,
                       s.robot_id,
                       s.job_id,
                       s.rank_id,
                       s.schedule_id,
                       s.dismissal_reason_id,
                       s.dismissal_note,
                       s.fte_id,
                       s.employment_type,
                       uit_href.get_staff_status(s.hiring_date, s.dismissal_date, :filter_date) as status,
                       k.photo_sha,
                       w.name,
                       w.first_name,
                       w.last_name,
                       w.middle_name,
                       w.gender,
                       w.birthday,
                       (uit_href.calc_age(w.birthday)) age,
                       w.code,
                       m.tin,
                       m.region_id,
                       m.main_phone,
                       k.email,
                       m.address,
                       m.legal_address,
                       n.extra_phone,
                       n.iapa,
                       n.npin,
                       n.corporate_email,
                       n.nationality_id,
                       c.fixed_term,
                       c.expiry_date,
                       (case
                           when exists (select 1
                                   from htt_blocked_person_tracking bp
                                  where bp.company_id = :company_id
                                    and bp.filial_id = :filial_id
                                    and bp.employee_id = q.employee_id) then
                            ''Y''
                           else
                            ''N''   
                       end) is_tracking_blocked,       
                       (case 
                           when (h.hiring_date + h.trial_period) >= :curr_date then
                            ''Y''
                           else
                            ''N''
                        end) on_trial_period,
                       (select p.doc_series || '' '' || p.doc_number
                          from href_person_documents p
                         where p.company_id = :company_id
                           and p.person_id = q.employee_id
                           and p.doc_type_id = :doc_type_id
                           and rownum = 1) passport_info,
                       ht.qr_code,
                       ht.pin,
                       nvl((select ''Y''
                              from htt_person_photos pp
                             where pp.company_id = :company_id
                               and pp.person_id = q.employee_id
                               and rownum = 1), ''N'') face_reg_photos_exist,
                       nvl((select ''Y''
                              from hzk_person_fprints fp
                             where fp.company_id = :company_id
                               and fp.person_id = q.employee_id
                               and rownum = 1), ''N'') fprint_exist,
                       decode(u.state,
                              ''A'',
                              nvl((select ''Y''
                                    from md_user_filials uf
                                   where uf.company_id = u.company_id
                                     and uf.filial_id = :filial_id
                                     and uf.user_id = u.user_id),
                                  ''N''),
                              ''N'') as user_activated,
                       u.login,
                       case
                          when q.employee_id = :user_id 
                            or uit_hrm.access_to_hidden_salary_job(i_job_id => s.job_id) = ''Y'' then
                           hpd_util.get_closest_wage(:company_id, :filial_id, s.staff_id, nvl(s.dismissal_date, :curr_date))
                          else
                           -1
                        end as wage,
                        uit_href.get_person_document_owe_status(q.employee_id) person_document_owe_status,
                        hpd_util.Trans_Id_By_Period(:company_id, :filial_id, s.staff_id, :trans_type, :curr_date) trans_id,
                        hpd_util.get_closest_wage_scale_id(i_company_id => s.company_id,
                                                           i_filial_id  => s.filial_id,
                                                           i_staff_id   => s.staff_id,
                                                           i_period     => :filter_date) wage_scale_id
                  from mhr_employees q
                  join md_persons k
                    on k.company_id = q.company_id
                   and k.person_id = q.employee_id
                  join mr_natural_persons w
                    on w.company_id = k.company_id
                   and w.person_id = k.person_id
                  join mr_person_details m
                    on m.company_id = w.company_id
                   and m.person_id = w.person_id
                  left join md_users u
                    on u.company_id = q.company_id
                   and u.user_id = q.employee_id                  
                  left join href_person_details n
                    on n.company_id = w.company_id
                   and n.person_id = w.person_id
                  left join href_staffs s
                    on s.company_id = q.company_id
                   and s.filial_id = q.filial_id
                   and s.employee_id = q.employee_id
                   and s.staff_kind = :sk_primary
                   and s.state = ''A''
                   and s.hiring_date = (select max(s1.hiring_date)
                                          from href_staffs s1
                                         where s1.company_id = q.company_id
                                           and s1.filial_id = q.filial_id
                                           and s1.employee_id = q.employee_id
                                           and s1.staff_kind = :sk_primary
                                           and s1.state = ''A''
                                           and s1.hiring_date <= :filter_date)
                  left join hpd_hirings h
                    on h.company_id = s.company_id
                   and h.filial_id = s.filial_id
                   and h.staff_id = s.staff_id
                  left join hpd_page_contracts c 
                    on c.company_id = s.company_id
                   and c.filial_id = s.filial_id
                   and c.page_id = h.page_id
                  left join htt_persons ht
                    on ht.company_id = q.company_id
                   and ht.person_id = q.employee_id
                 where q.company_id = :company_id
                   and q.filial_id = :filial_id';
  
    v_Query := Uit_Href.Make_Subordinated_Query(i_Query => v_Query, i_Include_Manual => true);
  
    v_Params.Put('company_id', Ui.Company_Id);
    v_Params.Put('filial_id', Ui.Filial_Id);
    v_Params.Put('sk_primary', Href_Pref.c_Staff_Kind_Primary);
    v_Params.Put('filter_date', Nvl(p.o_Date('date'), Trunc(sysdate)));
    v_Params.Put('curr_date', Trunc(sysdate));
    v_Params.Put('user_id', Ui.User_Id);
    v_Params.Put('trans_type', Hpd_Pref.c_Transaction_Type_Operation);
    v_Params.Put('doc_type_id',
                 Href_Util.Doc_Type_Id(i_Company_Id => Ui.Company_Id,
                                       i_Pcode      => Href_Pref.c_Pcode_Document_Type_Default_Passport));
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('employee_id',
                   'staff_id',
                   'region_id',
                   'created_by',
                   'modified_by',
                   'division_id',
                   'job_id',
                   'schedule_id',
                   'manager_id',
                   'dismissal_reason_id');
    q.Number_Field('nationality_id',
                   'age',
                   'wage',
                   'fte_id',
                   'rank_id',
                   'org_unit_id',
                   'trans_id',
                   'wage_scale_id',
                   'robot_id');
  
    q.Varchar2_Field('employee_number',
                     'name',
                     'first_name',
                     'last_name',
                     'middle_name',
                     'gender',
                     'photo_sha',
                     'tin',
                     'iapa',
                     'npin');
    q.Varchar2_Field('main_phone',
                     'email',
                     'address',
                     'legal_address',
                     'code',
                     'dismissal_note',
                     'status',
                     'access_level',
                     'face_reg_photos_exist',
                     'login');
    q.Varchar2_Field('fprint_exist',
                     'qr_code',
                     'employee_activated',
                     'user_activated',
                     'state',
                     'extra_phone',
                     'corporate_email',
                     'passport_info',
                     'fixed_term',
                     'on_trial_period');
    q.Varchar2_Field('person_document_owe_status', 'pin', 'employment_type', 'is_tracking_blocked');
  
    q.Date_Field('hiring_date',
                 'dismissal_date',
                 'birthday',
                 'expiry_date',
                 'created_on',
                 'modified_on');
  
    v_Matrix := Href_Util.Staff_Statuses;
  
    q.Option_Field('status_name', 'status', v_Matrix(1), v_Matrix(2));
  
    v_Matrix := Md_Util.Person_Genders;
  
    q.Option_Field('gender_name', 'gender', v_Matrix(1), v_Matrix(2));
  
    v_Matrix := Href_Util.User_Acces_Levels;
  
    q.Option_Field('access_level_name', 'access_level', v_Matrix(1), v_Matrix(2));
    q.Option_Field('face_reg_photos_exist_name',
                   'face_reg_photos_exist',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
    q.Option_Field('fprint_exist_name',
                   'fprint_exist',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
    q.Option_Field('employee_activated_name',
                   'employee_activated',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
    q.Option_Field('user_activated_name',
                   'user_activated',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
    q.Option_Field('fixed_term_name',
                   'fixed_term',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
    q.Option_Field('on_trial_period_name',
                   'on_trial_period',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
    q.Option_Field('is_tracking_blocked_name',
                   'is_tracking_blocked',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
  
    v_Matrix := Href_Util.Person_Document_Owe_Status;
  
    q.Option_Field('person_document_owe_status_name',
                   'person_document_owe_status',
                   v_Matrix(1),
                   v_Matrix(2));
  
    v_Matrix := Hpd_Util.Employment_Types(true);
  
    q.Option_Field('employment_type_name', 'employment_type', v_Matrix(1), v_Matrix(2));
  
    q.Map_Field('required_doc_types_count', 'uit_href.get_required_doc_types_count($employee_id)');
    q.Map_Field('person_documents_count', 'uit_href.get_person_documents_count($employee_id)');
  
    q.Refer_Field('manager_name',
                  'manager_id',
                  'mr_natural_persons',
                  'person_id',
                  'name',
                  Uit_Href.Person_Refer_Field_Filter_Query);
    q.Refer_Field('nationality_name',
                  'nationality_id',
                  'href_nationalities',
                  'nationality_id',
                  'name',
                  'select *
                     from href_nationalities s 
                    where s.company_id = :company_id');
    q.Refer_Field('region_name',
                  'region_id',
                  'md_regions',
                  'region_id',
                  'name',
                  'select *
                     from md_regions s 
                    where s.company_id = :company_id');
    q.Refer_Field('created_by_name',
                  'created_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users s
                    where s.company_id = :company_id');
    q.Refer_Field('modified_by_name',
                  'modified_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users s
                    where s.company_id = :company_id');
    q.Refer_Field('division_name',
                  'division_id',
                  Uit_Hrm.Divisions_Query(i_Only_Departments => false),
                  'division_id',
                  'name',
                  Uit_Hrm.Departments_Query);
    q.Refer_Field('org_unit_name',
                  'org_unit_id',
                  Uit_Hrm.Divisions_Query(i_Only_Departments => false),
                  'division_id',
                  'name',
                  Uit_Hrm.Divisions_Query(i_Only_Departments => false));
    q.Refer_Field('job_name',
                  'job_id',
                  'mhr_jobs',
                  'job_id',
                  'name',
                  'select * 
                     from mhr_jobs q 
                    where q.company_id = :company_id
                      and q.filial_id = :filial_id');
    q.Refer_Field('schedule_name',
                  'schedule_id',
                  'htt_schedules',
                  'schedule_id',
                  'name',
                  'select * 
                     from htt_schedules q 
                    where q.company_id = :company_id
                      and q.filial_id = :filial_id');
    q.Refer_Field('dismissal_reason_name',
                  'dismissal_reason_id',
                  'href_dismissal_reasons',
                  'dismissal_reason_id',
                  'name',
                  'select * 
                     from href_dismissal_reasons q 
                    where q.company_id = :company_id');
    q.Refer_Field('wage_scale_name',
                  'wage_scale_id',
                  'hrm_wage_scales',
                  'wage_scale_id',
                  'name',
                  'select w.* 
                     from hrm_wage_scales w
                    where w.company_id = :company_id
                      and w.filial_id = :filial_id');
  
    q.Multi_Number_Field('location_ids',
                         'select w.location_id, w.person_id
                            from htt_location_persons w
                           where w.company_id = :company_id
                             and w.filial_id = :filial_id
                             and not exists (select *
                                from htt_blocked_person_tracking bp
                               where bp.company_id = w.company_id
                                 and bp.filial_id = w.filial_id
                                 and bp.employee_id = w.person_id)',
                         '@person_id=$employee_id',
                         'location_id');
    q.Refer_Field('location_names',
                  'location_ids',
                  'htt_locations',
                  'location_id',
                  'name',
                  'select lc.*
                     from htt_locations lc
                    where exists (select 1
                             from htt_location_filials w
                            where w.company_id = :company_id
                              and w.filial_id = :filial_id
                              and w.location_id = lc.location_id)');
  
    q.Multi_Number_Field('edu_stage_ids',
                         'select distinct e.edu_stage_id, e.person_id
                            from href_person_edu_stages e 
                           where e.company_id = :company_id',
                         '@person_id = $employee_id',
                         'edu_stage_id');
    q.Refer_Field('edu_stage_names',
                  'edu_stage_ids',
                  'href_edu_stages',
                  'edu_stage_id',
                  'name',
                  'select *
                     from href_edu_stages w
                    where w.company_id = :company_id');
  
    q.Multi_Number_Field('institution_ids',
                         'select distinct e.institution_id, e.person_id
                            from href_person_edu_stages e 
                           where e.company_id = :company_id',
                         '@person_id = $employee_id',
                         'institution_id');
    q.Refer_Field('institution_names',
                  'institution_ids',
                  'href_institutions',
                  'institution_id',
                  'name',
                  'select *
                     from href_institutions w
                    where w.company_id = :company_id');
  
    q.Multi_Number_Field('specialty_ids',
                         'select distinct e.specialty_id, e.person_id
                            from href_person_edu_stages e 
                           where e.company_id = :company_id',
                         '@person_id = $employee_id',
                         'specialty_id');
    q.Refer_Field('specialty_names',
                  'specialty_ids',
                  'href_specialties',
                  'specialty_id',
                  'name',
                  'select *
                     from href_specialties w
                    where w.company_id = :company_id');
    q.Refer_Field('fte_name',
                  'fte_id',
                  'href_ftes',
                  'fte_id',
                  'name',
                  'select *
                     from href_ftes s 
                    where s.company_id = :company_id');
    q.Refer_Field('rank_name',
                  'rank_id',
                  'mhr_ranks',
                  'rank_id',
                  'name',
                  'select * 
                     from mhr_ranks q 
                    where q.company_id = :company_id 
                      and q.filial_id = :filial_id');
    q.Multi_Number_Field('oper_type_ids',
                         'select w.oper_type_id, w.trans_id 
                            from hpd_trans_oper_types w
                           where w.company_id = :company_id
                             and w.filial_id = :filial_id',
                         '@trans_id = $trans_id',
                         'oper_type_id');
    q.Refer_Field('oper_type_names',
                  'oper_type_ids',
                  'mpr_oper_types',
                  'oper_type_id',
                  'name',
                  'select w.* 
                     from mpr_oper_types w
                    where w.company_id = :company_id');
    q.Refer_Field('robot_name',
                  'robot_id',
                  'mrf_robots',
                  'robot_id',
                  'name',
                  'select w.* 
                     from mrf_robots w
                    where w.company_id = :company_id
                      and w.filial_id = :filial_id
                      and exists (select 1 
                             from mrf_robot_persons rp
                            where rp.company_id = w.company_id
                              and rp.filial_id = w.filial_id
                              and rp.robot_id = w.robot_id)');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Block_Employee_Tracking(p Hashmap) is
    v_Company_Id   number := Ui.Company_Id;
    v_Filial_Id    number := Ui.Filial_Id;
    v_Employee_Ids Array_Number := Fazo.Sort(p.r_Array_Number('employee_id'));
  begin
    for i in 1 .. v_Employee_Ids.Count
    loop
      Htt_Api.Block_Employee_Tracking(i_Company_Id  => v_Company_Id,
                                      i_Filial_Id   => v_Filial_Id,
                                      i_Employee_Id => v_Employee_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Unblock_Employee_Tracking(p Hashmap) is
    v_Company_Id   number := Ui.Company_Id;
    v_Filial_Id    number := Ui.Filial_Id;
    v_Employee_Ids Array_Number := Fazo.Sort(p.r_Array_Number('employee_id'));
  begin
    for i in 1 .. v_Employee_Ids.Count
    loop
      Htt_Api.Unblock_Employee_Tracking(i_Company_Id  => v_Company_Id,
                                        i_Filial_Id   => v_Filial_Id,
                                        i_Employee_Id => v_Employee_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Org_Units(p Hashmap) return Hashmap is
    result Hashmap := Hashmap();
  begin
    Result.Put('org_units',
               Fazo.Zip_Matrix(Uit_Hrm.Get_Org_Units(i_Division_Id => p.r_Number('division_id'))));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Change_Org_Unit(p Hashmap) is
    v_Staff_Id number := p.r_Number('staff_id');
    v_Robot_Id number;
  begin
    v_Robot_Id := z_Href_Staffs.Load(i_Company_Id => Ui.Company_Id, --
                  i_Filial_Id => Ui.Filial_Id, --
                  i_Staff_Id => v_Staff_Id).Robot_Id;
  
    Hrm_Api.Update_Org_Unit(i_Company_Id  => Ui.Company_Id,
                            i_Filial_Id   => Ui.Filial_Id,
                            i_Robot_Id    => v_Robot_Id,
                            i_Org_Unit_Id => p.o_Number('org_unit_id'));
  
    Hpd_Core.Staff_Refresh_Cache(i_Company_Id => Ui.Company_Id,
                                 i_Filial_Id  => Ui.Filial_Id,
                                 i_Staff_Id   => v_Staff_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap is
    v_Matrix   Matrix_Varchar2 := Matrix_Varchar2();
    v_Settings Hrm_Settings%rowtype;
    v_Is_Pro   varchar2(1) := 'N';
    result     Hashmap := Hashmap();
  begin
    if Md_Util.Grant_Has(i_Company_Id   => Ui.Company_Id,
                         i_Project_Code => Ui.Project_Code,
                         i_Filial_Id    => Ui.Filial_Id,
                         i_User_Id      => Ui.User_Id,
                         i_Form         => Uit_Href.c_Form_Rep_Timesheet,
                         i_Action_Key   => Md_Pref.c_Form_Sign) then
      Fazo.Push(v_Matrix,
                Uit_Href.c_Form_Rep_Timesheet || ':run',
                Ui_Kernel.Form_Name(Uit_Href.c_Form_Rep_Timesheet),
                Uit_Href.c_Form_Rep_Timesheet);
    end if;
  
    v_Settings := Hrm_Util.Load_Setting(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id);
  
    Result.Put('position_enable', v_Settings.Position_Enable);
    Result.Put('advanced_org_structure', v_Settings.Advanced_Org_Structure);
    Result.Put('reports', Fazo.Zip_Matrix(v_Matrix));
    Result.Put('access_all_employee', Uit_Href.User_Access_All_Employees);
    Result.Put('badge_template_value',
               z_Href_Badge_Templates.Take(Href_Util.Company_Badge_Template_Id(Ui.Company_Id)).Html_Value);
    Result.Put('filial_photo_sha',
               z_Md_Persons.Load(i_Company_Id => Ui.Company_Id, --
               i_Person_Id => Ui.Filial_Id).Photo_Sha);
    Result.Put('company_name', Md_Util.Company_Name(Ui.Company_Id));
  
    if Uit_Href.Is_Pro(Ui.Company_Id) then
      v_Is_Pro := 'Y';
    end if;
  
    Result.Put('is_pro', v_Is_Pro);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Employee_Ids Array_Number := Fazo.Sort(p.r_Array_Number('employee_id'));
  begin
    Uit_Href.Assert_Access_All_Employees;
  
    for i in 1 .. v_Employee_Ids.Count
    loop
      Href_Api.Employee_Delete(i_Company_Id  => Ui.Company_Id,
                               i_Filial_Id   => Ui.Filial_Id,
                               i_Employee_Id => v_Employee_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Change_Employee_Activation(p Hashmap) is
    r_Employee                Mhr_Employees%rowtype;
    v_Employee_Ids            Array_Number := Fazo.Sort(p.r_Array_Number('employee_id'));
    v_State                   varchar2(1) := p.r_Varchar2('state');
    v_Location_Global_Sync_On boolean := Htt_Util.Location_Sync_Global_Load(i_Company_Id => Ui.Company_Id,
                                                                            i_Filial_Id  => Ui.Filial_Id) = 'Y';
  begin
    Uit_Href.Assert_Access_All_Employees;
  
    for i in 1 .. v_Employee_Ids.Count
    loop
      r_Employee := z_Mhr_Employees.Lock_Load(i_Company_Id  => Ui.Company_Id,
                                              i_Filial_Id   => Ui.Filial_Id,
                                              i_Employee_Id => v_Employee_Ids(i));
    
      r_Employee.State := v_State;
    
      Mhr_Api.Employee_Save(r_Employee);
    
      if v_Location_Global_Sync_On then
        Htt_Api.Person_Global_Sync_All_Location(i_Company_Id => Ui.Company_Id,
                                                i_Filial_Id  => Ui.Filial_Id,
                                                i_Person_Id  => v_Employee_Ids(i));
      end if;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Change_User_Activation(p Hashmap) is
    r_Person   Mr_Natural_Persons%rowtype;
    r_User     Md_Users%rowtype;
    v_User_Ids Array_Number := Fazo.Sort(p.r_Array_Number('employee_id'));
    v_State    varchar2(1) := p.r_Varchar2('state');
    v_Role_Id  number;
  begin
    Uit_Href.Assert_Access_All_Employees;
  
    v_Role_Id := Md_Util.Role_Id(i_Company_Id => Ui.Company_Id,
                                 i_Pcode      => Href_Pref.c_Pcode_Role_Staff);
  
    for i in 1 .. v_User_Ids.Count
    loop
      if not z_Md_Users.Exist(i_Company_Id => Ui.Company_Id,
                              i_User_Id    => v_User_Ids(i),
                              o_Row        => r_User) then
        r_Person := z_Mr_Natural_Persons.Load(i_Company_Id => Ui.Company_Id, --
                                              i_Person_Id  => v_User_Ids(i));
      
        z_Md_Users.Init(p_Row        => r_User,
                        i_Company_Id => r_Person.Company_Id,
                        i_User_Id    => r_Person.Person_Id,
                        i_Name       => r_Person.Name,
                        i_User_Kind  => Md_Pref.c_Uk_Normal,
                        i_Gender     => r_Person.Gender,
                        i_State      => 'A');
      
        Md_Api.User_Save(r_User);
      
        Md_Api.Role_Grant(i_Company_Id => r_Person.Company_Id,
                          i_User_Id    => r_Person.Person_Id,
                          i_Filial_Id  => Ui.Filial_Id,
                          i_Role_Id    => v_Role_Id);
      end if;
    
      if v_State = 'A' then
        if r_User.State = 'P' then
          Href_Error.Raise_030(r_User.Name);
        end if;
      
        Md_Api.User_Add_Filial(i_Company_Id => r_User.Company_Id,
                               i_User_Id    => r_User.User_Id,
                               i_Filial_Id  => Ui.Filial_Id);
      else
        Md_Api.User_Remove_Filial(i_Company_Id   => r_User.Company_Id,
                                  i_User_Id      => r_User.User_Id,
                                  i_Filial_Id    => Ui.Filial_Id,
                                  i_Remove_Roles => false);
      end if;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Change_Schedule(p Hashmap) is
    v_Staff_Ids   Array_Number := p.r_Array_Number('staff_id');
    v_Begin_Date  date := p.r_Date('begin_date');
    v_End_Date    date := p.o_Date('end_date');
    v_Schedule_Id number := p.r_Number('schedule_id');
    v_Company_Id  number := Ui.Company_Id;
    v_Filial_Id   number := Ui.Filial_Id;
    p_Schedule    Hpd_Pref.Schedule_Change_Journal_Rt;
    r_Staff       Href_Staffs%rowtype;
  begin
    for i in 1 .. v_Staff_Ids.Count
    loop
      r_Staff := z_Href_Staffs.Lock_Load(i_Company_Id => v_Company_Id,
                                         i_Filial_Id  => v_Filial_Id,
                                         i_Staff_Id   => v_Staff_Ids(i));
    
      Uit_Href.Assert_Access_To_Staff(i_Staff_Id => r_Staff.Staff_Id, i_Self => false);
    
      Hpd_Util.Schedule_Change_Journal_New(o_Journal        => p_Schedule,
                                           i_Company_Id     => r_Staff.Company_Id,
                                           i_Filial_Id      => r_Staff.Filial_Id,
                                           i_Journal_Id     => Hpd_Next.Journal_Id,
                                           i_Journal_Number => null,
                                           i_Journal_Date   => v_Begin_Date,
                                           i_Journal_Name   => null,
                                           i_Division_Id    => r_Staff.Division_Id,
                                           i_Begin_Date     => v_Begin_Date,
                                           i_End_Date       => v_End_Date);
    
      Hpd_Util.Journal_Add_Schedule_Change(p_Journal     => p_Schedule,
                                           i_Page_Id     => Hpd_Next.Page_Id,
                                           i_Staff_Id    => r_Staff.Staff_Id,
                                           i_Schedule_Id => v_Schedule_Id);
    
      Hpd_Api.Schedule_Change_Journal_Save(p_Schedule);
    
      Hpd_Api.Journal_Post(i_Company_Id => p_Schedule.Company_Id,
                           i_Filial_Id  => p_Schedule.Filial_Id,
                           i_Journal_Id => p_Schedule.Journal_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Mhr_Employees
       set Company_Id      = null,
           Filial_Id       = null,
           Employee_Id     = null,
           Employee_Number = null,
           Division_Id     = null,
           Job_Id          = null,
           State           = null,
           Created_By      = null,
           Created_On      = null,
           Modified_By     = null,
           Modified_On     = null;
    update Href_Staffs
       set Company_Id          = null,
           Filial_Id           = null,
           Staff_Id            = null,
           Employee_Id         = null,
           Hiring_Date         = null,
           Dismissal_Date      = null,
           Robot_Id            = null,
           Division_Id         = null,
           Job_Id              = null,
           Schedule_Id         = null,
           Dismissal_Reason_Id = null,
           Fte_Id              = null,
           Staff_Kind          = null,
           State               = null;
    update Mrf_Division_Managers
       set Company_Id  = null,
           Filial_Id   = null,
           Division_Id = null,
           Manager_Id  = null;
    update Mrf_Robots
       set Company_Id = null,
           Filial_Id  = null,
           Robot_Id   = null,
           Person_Id  = null,
           name       = null;
    update Mr_Natural_Persons
       set Company_Id  = null,
           Person_Id   = null,
           First_Name  = null,
           Last_Name   = null,
           Middle_Name = null,
           Gender      = null,
           Birthday    = null,
           State       = null,
           Code        = null;
    update Md_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null,
           Photo_Sha  = null,
           Email      = null;
    update Mr_Person_Details
       set Company_Id    = null,
           Person_Id     = null,
           Tin           = null,
           Main_Phone    = null,
           Address       = null,
           Legal_Address = null,
           Region_Id     = null;
    update Href_Person_Edu_Stages
       set Person_Id      = null,
           Edu_Stage_Id   = null,
           Institution_Id = null,
           Specialty_Id   = null;
    update Hrm_Hidden_Salary_Job_Groups
       set Company_Id   = null,
           Job_Group_Id = null;
    update Href_Edu_Stages
       set Company_Id   = null,
           Edu_Stage_Id = null,
           name         = null;
    update Href_Institutions
       set Company_Id     = null,
           Institution_Id = null,
           name           = null;
    update Href_Specialties
       set Company_Id   = null,
           Specialty_Id = null,
           name         = null;
    update Href_Person_Details
       set Company_Id      = null,
           Person_Id       = null,
           Extra_Phone     = null,
           Iapa            = null,
           Npin            = null,
           Corporate_Email = null,
           Nationality_Id  = null;
    update Href_Nationalities
       set Company_Id     = null,
           Nationality_Id = null,
           name           = null;
    update Md_Regions
       set Company_Id = null,
           Region_Id  = null,
           name       = null;
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
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
    update Htt_Schedules
       set Company_Id  = null,
           Filial_Id   = null,
           Schedule_Id = null,
           name        = null;
    update Href_Dismissal_Reasons
       set Company_Id          = null,
           Dismissal_Reason_Id = null,
           name                = null;
    update Htt_Location_Filials
       set Company_Id  = null,
           Filial_Id   = null,
           Location_Id = null;
    update Htt_Locations
       set Company_Id  = null,
           Location_Id = null,
           name        = null;
    update Htt_Location_Persons
       set Company_Id  = null,
           Filial_Id   = null,
           Location_Id = null,
           Person_Id   = null;
    update Htt_Person_Photos
       set Company_Id = null,
           Person_Id  = null;
    update Hzk_Person_Fprints
       set Company_Id = null,
           Person_Id  = null;
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           State      = null;
    update Md_User_Filials
       set Company_Id = null,
           User_Id    = null,
           Filial_Id  = null;
    update Href_Ftes
       set Company_Id = null,
           Fte_Id     = null,
           name       = null;
    update Mhr_Ranks
       set Company_Id = null,
           Filial_Id  = null,
           Rank_Id    = null,
           name       = null;
    update Href_Person_Documents
       set Company_Id  = null,
           Person_Id   = null,
           Doc_Type_Id = null,
           Doc_Series  = null,
           Doc_Number  = null;
    update Hpd_Page_Contracts
       set Company_Id  = null,
           Filial_Id   = null,
           Page_Id     = null,
           Fixed_Term  = null,
           Expiry_Date = null;
    update Hpd_Hirings
       set Company_Id   = null,
           Filial_Id    = null,
           Page_Id      = null,
           Staff_Id     = null,
           Hiring_Date  = null,
           Trial_Period = null;
    update Htt_Persons
       set Company_Id = null,
           Person_Id  = null,
           Pin        = null,
           Qr_Code    = null;
    update Hpd_Trans_Oper_Types
       set Company_Id   = null,
           Filial_Id    = null,
           Trans_Id     = null,
           Oper_Type_Id = null;
    update Mpr_Oper_Types
       set Company_Id   = null,
           Oper_Type_Id = null,
           name         = null;
    update Mrf_Robot_Persons
       set Company_Id = null,
           Filial_Id  = null,
           Robot_Id   = null;
    update Htt_Schedules
       set Company_Id  = null,
           Filial_Id   = null,
           Schedule_Id = null,
           name        = null,
           State       = null;
    update Hrm_Wage_Scales
       set Company_Id    = null,
           Filial_Id     = null,
           Wage_Scale_Id = null,
           name          = null;
    update Htt_Blocked_Person_Tracking
       set Company_Id  = null,
           Filial_Id   = null,
           Employee_Id = null;
    Uie.x(Hpd_Util.Get_Closest_Wage_Scale_Id(i_Company_Id => null,
                                             i_Filial_Id  => null,
                                             i_Staff_Id   => null,
                                             i_Period     => null));
    Uie.x(Hpd_Util.Trans_Id_By_Period(i_Company_Id => null,
                                      i_Filial_Id  => null,
                                      i_Staff_Id   => null,
                                      i_Trans_Type => null,
                                      i_Period     => null));
    Uie.x(Uit_Href.Get_Staff_Status(i_Hiring_Date    => null,
                                    i_Dismissal_Date => null,
                                    i_Date           => null));
    Uie.x(Uit_Href.Calc_Age(null));
    Uie.x(Hpd_Util.Get_Closest_Job_Id(i_Company_Id => null,
                                      i_Filial_Id  => null,
                                      i_Staff_Id   => null,
                                      i_Period     => null));
    Uie.x(Hpd_Util.Get_Closest_Wage(i_Company_Id => null,
                                    i_Filial_Id  => null,
                                    i_Staff_Id   => null,
                                    i_Period     => null));
    Uie.x(Uit_Hrm.Access_To_Hidden_Salary_Job(null, null));
    Uie.x(Uit_Href.Get_Person_Document_Owe_Status(null));
    Uie.x(Uit_Href.Get_Required_Doc_Types_Count(null));
    Uie.x(Uit_Href.Get_Person_Documents_Count(null));
  end;

end Ui_Vhr333;
/
