create or replace package Ui_Vhr277 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Division_Audits(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap;
end Ui_Vhr277;
/
create or replace package body Ui_Vhr277 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Division_Audits(p Hashmap) return Fazo_Query is
    v_Events Matrix_Varchar2 := Md_Util.Events;
    q        Fazo_Query;
  begin
    q := Fazo_Query('select *
                       from x_mhr_divisions q
                      where q.t_company_id = :company_id
                        and q.t_filial_id = :filial_id 
                        and q.division_id = :division_id',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'division_id',
                                 p.r_Number('division_id')));
  
    q.Number_Field('t_audit_id',
                   't_user_id',
                   't_context_id',
                   'division_id',
                   'parent_id',
                   'division_group_id');
    q.Date_Field('t_timestamp', 't_date', 'opened_date', 'closed_date');
    q.Varchar2_Field('t_event', 't_source_project_code', 'name', 'code', 'state');
    q.Option_Field('t_event_name', 't_event', v_Events(1), v_Events(2));
    q.Refer_Field('t_user_name',
                  't_user_id',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users q
                    where q.company_id = :company_id
                    and exists (select 1
                           from md_user_filials w
                          where w.company_id = q.company_id
                            and w.user_id = q.user_id
                            and w.filial_id = :filial_id)');
    q.Refer_Field('t_source_project_name',
                  't_source_project_code',
                  'select s.project_code,
                          ui_kernel.project_name(s.project_code) project_name
                     from md_projects s',
                  'project_code',
                  'project_name',
                  'select s.project_code, 
                          ui_kernel.project_name(s.project_code) project_name
                     from md_projects s
                    where s.visible = ''Y''
                      and exists (select 1
                             from md_company_filial_projects k
                            where k.company_id = :company_id
                              and k.project_code = s.project_code
                              and k.filial_id = :filial_id)');
    q.Refer_Field('parent_name',
                  'parent_id',
                  'mhr_divisions',
                  'division_id',
                  'name',
                  'select *
                     from mhr_divisions s
                    where s.company_id = :company_id
                      and s.filial_id = :filial_id');
    q.Refer_Field('division_group_name',
                  'division_group_id',
                  'mhr_division_groups',
                  'division_group_id',
                  'name',
                  'select *
                     from mhr_division_groups s
                    where s.company_id = :company_id');
    q.Option_Field('state_name',
                   'state',
                   Array_Varchar2('A', 'P'),
                   Array_Varchar2(Ui.t_Active, Ui.t_Passive));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Staff_Id
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Manager_Id number
  ) return number is
    v_Staff_Id number;
  begin
    select q.Staff_Id
      into v_Staff_Id
      from Href_Staffs q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Robot_Id = i_Manager_Id
       and q.State = 'A'
       and q.Hiring_Date <= Trunc(sysdate)
       and (q.Dismissal_Date is null or q.Dismissal_Date >= Trunc(sysdate));
  
    return v_Staff_Id;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap is
    r_Data              Mhr_Divisions%rowtype;
    r_Division          Hrm_Divisions%rowtype;
    v_Manager_Id        number;
    v_Staff_Id          number;
    v_Schedule_Id       number;
    v_Division_Id       number := p.r_Number('division_id');
    v_Subfilial_Setting varchar2(1) := Hpr_Util.Load_Use_Subfilial_Settings(i_Company_Id => Ui.Company_Id,
                                                                            i_Filial_Id  => Ui.Filial_Id);
    v_Settings          Hrm_Settings%rowtype;
    result              Hashmap;
  begin
    Uit_Href.Assert_Access_To_Division(i_Division_Id => v_Division_Id);
  
    v_Settings := Hrm_Util.Load_Setting(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id);
  
    r_Data := z_Mhr_Divisions.Load(i_Company_Id  => Ui.Company_Id,
                                   i_Filial_Id   => Ui.Filial_Id,
                                   i_Division_Id => v_Division_Id);
  
    r_Division := z_Hrm_Divisions.Load(i_Company_Id  => r_Data.Company_Id,
                                       i_Filial_Id   => r_Data.Filial_Id,
                                       i_Division_Id => r_Data.Division_Id);
  
    result := z_Mhr_Divisions.To_Map(r_Data,
                                     z.Division_Id,
                                     z.Name,
                                     z.Opened_Date,
                                     z.Closed_Date,
                                     z.State,
                                     z.Code,
                                     z.Created_On,
                                     z.Modified_On);
  
    if r_Division.Manager_Status = Hrm_Pref.c_Division_Manager_Status_Manual then
      v_Manager_Id := z_Mrf_Division_Managers.Take(i_Company_Id => r_Data.Company_Id, --
                      i_Filial_Id => r_Data.Filial_Id, --
                      i_Division_Id => r_Data.Division_Id).Manager_Id;
    end if;
  
    v_Schedule_Id := z_Hrm_Division_Schedules.Take(i_Company_Id => r_Data.Company_Id, --
                     i_Filial_Id => r_Data.Filial_Id, --
                     i_Division_Id => r_Data.Division_Id).Schedule_Id;
  
    if v_Settings.Position_Enable = 'Y' then
      Result.Put('manager_name',
                 z_Mrf_Robots.Take(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id, i_Robot_Id => v_Manager_Id).Name);
    else
      v_Staff_Id := Get_Staff_Id(r_Data.Company_Id, r_Data.Filial_Id, v_Manager_Id);
    
      Result.Put('manager_name',
                 Href_Util.Staff_Name(i_Company_Id => r_Data.Company_Id,
                                      i_Filial_Id  => r_Data.Filial_Id,
                                      i_Staff_Id   => v_Staff_Id));
    
    end if;
  
    Result.Put('division_group_name',
               z_Mhr_Division_Groups.Take(i_Company_Id => Ui.Company_Id, i_Division_Group_Id => r_Data.Division_Group_Id).Name);
    Result.Put('schedule_name',
               z_Htt_Schedules.Take(i_Company_Id => r_Data.Company_Id, --
               i_Filial_Id => r_Data.Filial_Id, --
               i_Schedule_Id => v_Schedule_Id).Name);
    Result.Put('allow_use_subfilial', v_Subfilial_Setting);

    if v_Subfilial_Setting = 'Y' then
      Result.Put('subfilial_name',
                 z_Mrf_Subfilials.Take(i_Company_Id => Ui.Company_Id, i_Subfilial_Id => r_Division.Subfilial_Id).Name);
    end if;
    
    Result.Put('created_by_name',
               z_Md_Users.Load(i_Company_Id => r_Data.Company_Id, i_User_Id => r_Data.Created_By).Name);
    Result.Put('modified_by_name',
               z_Md_Users.Load(i_Company_Id => r_Data.Company_Id, i_User_Id => r_Data.Modified_By).Name);
    Result.Put('state_name', Md_Util.Decode(r_Data.State, 'A', Ui.t_Active, 'P', Ui.t_Passive));
    Result.Put('advanced_org_structure', v_Settings.Advanced_Org_Structure);
    Result.Put('division_kind', Hrm_Util.t_Division_Kind(r_Division.Is_Department));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Mhr_Jobs
       set Company_Id = null,
           Job_Id     = null,
           name       = null;
    update Mk_Coa
       set Company_Id = null,
           Coa_Id     = null,
           name       = null;
    update Mk_Currencies
       set Company_Id  = null,
           Currency_Id = null,
           name        = null;
    update Md_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null;
    update x_Mhr_Divisions
       set t_Company_Id          = null,
           t_Audit_Id            = null,
           t_Filial_Id           = null,
           t_Event               = null,
           t_Timestamp           = null,
           t_Date                = null,
           t_User_Id             = null,
           t_Source_Project_Code = null,
           t_Context_Id          = null,
           Division_Id           = null,
           name                  = null,
           Parent_Id             = null,
           Division_Group_Id     = null,
           Opened_Date           = null,
           Closed_Date           = null,
           State                 = null,
           Code                  = null;
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           name       = null;
    update Mhr_Division_Groups
       set Company_Id        = null,
           Division_Group_Id = null,
           name              = null;
    update Md_Projects
       set Project_Code = null,
           Visible      = null;
    update Md_Company_Projects
       set Company_Id   = null,
           Project_Code = null;
  
    Uie.x(Ui_Kernel.Project_Name(null));
  end;

end Ui_Vhr277;
/
