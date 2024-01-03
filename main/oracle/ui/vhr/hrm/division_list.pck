create or replace package Ui_Vhr276 is
  ----------------------------------------------------------------------------------------------------
  Function Query(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
end Ui_Vhr276;
/
create or replace package body Ui_Vhr276 is
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap is
  begin
    return Fazo.Zip_Map('table_name_division', Zt.Mhr_Divisions.Name);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query(p Hashmap) return Fazo_Query is
    v_Parent_Id       number := p.o_Number('parent_id');
    v_Query           varchar2(4000);
    v_Params          Hashmap;
    v_Position_Enable varchar(1);
    q                 Fazo_Query;
  begin
    v_Position_Enable := Hrm_Util.Load_Setting(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id).Position_Enable;
  
    v_Query := 'select q.*,
                       hd.is_department,
                       hd.subfilial_id,
                       case 
                         when hd.manager_status = :ms_manual then
                           (select w.manager_id
                              from mrf_division_managers w
                             where w.company_id = q.company_id
                               and w.filial_id = q.filial_id
                               and w.division_id = q.division_id)
                         else 
                           null
                         end manager_id,
                        (select w.schedule_id
                           from hrm_division_schedules w
                          where w.company_id = q.company_id
                            and w.filial_id = q.filial_id
                            and w.division_id = q.division_id) schedule_id';
  
    v_Params := Fazo.Zip_Map('company_id',
                             Ui.Company_Id,
                             'filial_id',
                             Ui.Filial_Id,
                             'user_admin',
                             Md_Pref.User_Admin(Ui.Company_Id),
                             'ms_manual',
                             Hrm_Pref.c_Division_Manager_Status_Manual);
  
    if Uit_Href.User_Access_All_Employees = 'Y' then
      v_Query := v_Query || ', ''Y'' access_action';
    else
      v_Query := v_Query || ', (case
                                  when q.division_id member of :division_ids then
                                   ''Y''
                                  else
                                   ''N''
                                end) access_action';
    
      v_Params.Put('division_ids',
                   Uit_Href.Get_Subordinate_Divisions(i_Direct   => true,
                                                      i_Indirect => true,
                                                      i_Manual   => true));
    end if;
  
    v_Query := v_Query || ' from mhr_divisions q
                            join hrm_divisions hd
                              on hd.company_id = q.company_id
                             and hd.filial_id = q.filial_id 
                             and hd.division_id = q.division_id
                           where q.company_id = :company_id
                             and q.filial_id = :filial_id';
  
    if v_Parent_Id is not null then
      v_Query := v_Query || ' and q.parent_id = :parent_id';
      v_Params.Put('parent_id', v_Parent_Id);
    else
      v_Query := v_Query || ' and q.parent_id is null';
    end if;
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('division_id',
                   'parent_id',
                   'manager_id',
                   'schedule_id',
                   'division_group_id',
                   'subfilial_id',
                   'created_by',
                   'modified_by');
    q.Varchar2_Field('name', 'state', 'code', 'access_action', 'is_department');
    q.Date_Field('opened_date', 'closed_date', 'created_on', 'modified_on');
  
    if v_Position_Enable = 'Y' then
      q.Refer_Field('manager_name',
                    'manager_id',
                    'mrf_robots',
                    'robot_id',
                    'name',
                    'select *
                       from mrf_robots w
                      where w.company_id = :company_id
                        and w.filial_id = :filial_id');
    else
      q.Map_Field('manager_name',
                  'select w.name
                     from mrf_robots q
                     join mr_natural_persons w
                       on q.person_id = w.person_id
                    where q.robot_id = $manager_id
                      and q.company_id = :company_id
                      and q.filial_id = :filial_id');
    end if;
  
    q.Refer_Field('division_group_name',
                  'division_group_id',
                  'mhr_division_groups',
                  'division_group_id',
                  'name',
                  'select *
                     from mhr_division_groups s
                    where s.company_id = :company_id');
    q.Refer_Field('schedule_name',
                  'schedule_id',
                  'htt_schedules',
                  'schedule_id',
                  'name',
                  'select *
                     from htt_schedules s
                    where s.company_id = :company_id
                      and s.filial_id = :filial_id');
    q.Refer_Field('subfilial_name',
                  'subfilial_id',
                  'mrf_subfilials',
                  'subfilial_id',
                  'name',
                  'select * 
                     from mrf_subfilials q
                    where q.company_id = :company_id');
    q.Refer_Field('created_by_name',
                  'created_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select * 
                     from md_users w 
                    where w.company_id = :company_id
                      and exists (select 1
                             from md_user_filials t
                            where t.company_id = w.company_id
                              and t.user_id = w.user_id
                              and t.filial_id = :filial_id)');
    q.Refer_Field('modified_by_name',
                  'modified_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select * 
                     from md_users w 
                    where w.company_id = :company_id
                      and exists (select 1
                             from md_user_filials t
                            where t.company_id = w.company_id
                              and t.user_id = w.user_id
                              and t.filial_id = :filial_id)');
  
    q.Option_Field('state_name',
                   'state',
                   Array_Varchar2('A', 'P'),
                   Array_Varchar2(Ui.t_Active, Ui.t_Passive));
    q.Option_Field('is_department_name',
                   'is_department',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Hrm_Util.t_Division_Kind_Department,
                                  Hrm_Util.t_Division_Kind_Team));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Division_Ids Array_Number := p.r_Array_Number('division_id');
  begin
    for i in 1 .. v_Division_Ids.Count
    loop
      Uit_Href.Assert_Access_To_Division(i_Division_Id => v_Division_Ids(i));
    
      Mhr_Api.Division_Delete(i_Company_Id  => Ui.Company_Id,
                              i_Filial_Id   => Ui.Filial_Id,
                              i_Division_Id => v_Division_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Mhr_Divisions
       set Company_Id        = null,
           Filial_Id         = null,
           Division_Id       = null,
           name              = null,
           Parent_Id         = null,
           Division_Group_Id = null,
           Opened_Date       = null,
           Closed_Date       = null,
           State             = null,
           Code              = null,
           Created_By        = null,
           Created_On        = null,
           Modified_By       = null,
           Modified_On       = null;
  
    update Mrf_Division_Managers
       set Company_Id  = null,
           Filial_Id   = null,
           Division_Id = null,
           Manager_Id  = null;
  
    update Hrm_Division_Schedules
       set Company_Id  = null,
           Filial_Id   = null,
           Division_Id = null,
           Schedule_Id = null;
  
    update Htt_Schedules
       set Company_Id  = null,
           Filial_Id   = null,
           Schedule_Id = null,
           name        = null;
  
    update Mhr_Division_Groups
       set Company_Id        = null,
           Division_Group_Id = null,
           name              = null;
  
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           name       = null;
  
    update Mrf_Robots
       set Company_Id = null,
           Filial_Id  = null,
           Robot_Id   = null,
           Person_Id  = null,
           name       = null;
  
    update Md_User_Filials
       set Company_Id = null,
           Filial_Id  = null,
           User_Id    = null;
  
    update Mr_Natural_Persons
       set Person_Id = null,
           name      = null;
  
    update Hrm_Divisions
       set Company_Id     = null,
           Filial_Id      = null,
           Division_Id    = null,
           Is_Department  = null,
           Manager_Status = null;
  end;

end Ui_Vhr276;
/
