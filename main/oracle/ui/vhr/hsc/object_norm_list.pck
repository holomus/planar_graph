create or replace package Ui_Vhr494 is
  ----------------------------------------------------------------------------------------------------
  Function Seconds_To_Time(i_Seconds number) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Frequency_To_Text
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Norm_Id    number
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Query_Objects return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
end Ui_Vhr494;
/
create or replace package body Ui_Vhr494 is
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
    return b.Translate('UI-VHR494:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Seconds_To_Time(i_Seconds number) return varchar2 is
    v_Hours number;
  begin
    v_Hours := Trunc(i_Seconds / 3600);
    return Fazo.Gather(Array_Varchar2(Lpad(v_Hours, 2, '0'),
                                      Lpad(Trunc((i_Seconds - v_Hours * 3600) / 60), 2, '0'),
                                      Lpad(mod(i_Seconds, 60), 2, '0')),
                       ':');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Frequency_To_Text
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Norm_Id    number
  ) return varchar2 is
    v_Sunday date := sysdate - to_char(sysdate, 'D');
    v_Array  Array_Varchar2;
  begin
    select case
              when q.Action_Period = Hsc_Pref.c_Action_Period_Week then
               to_char(v_Sunday + w.Day_No, 'Dy')
              else
               to_char(w.Day_No)
            end || ' (' || w.Frequency || ')'
      bulk collect
      into v_Array
      from Hsc_Object_Norms q
      join Hsc_Object_Norm_Actions w
        on w.Company_Id = q.Company_Id
       and w.Filial_Id = q.Filial_Id
       and w.Norm_Id = q.Norm_Id
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Norm_Id = i_Norm_Id;
  
    if Fazo.Is_Empty(v_Array) then
      return t('predictable');
    end if;
  
    return Fazo.Gather(v_Array, ', ');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Objects return Fazo_Query is
    v_Param Hashmap := Fazo.Zip_Map('company_id', --
                                    Ui.Company_Id,
                                    'filial_id',
                                    Ui.Filial_Id,
                                    'state',
                                    'A');
    q       Fazo_Query;
  begin
    v_Param.Put('allowed_divisions', Uit_Href.Get_All_Subordinate_Divisions);
    v_Param.Put('access_all_employee', Uit_Href.User_Access_All_Employees);
  
    q := Fazo_Query('select q.*,
                            w.name
                       from hsc_objects q
                       join mhr_divisions w
                         on w.company_id = q.company_id
                        and w.filial_id = q.filial_id
                        and w.division_id = q.object_id
                        and w.state = :state
                      where q.company_id = :company_id
                        and q.filial_id = :filial_id
                        and (:access_all_employee = ''Y'' or q.object_id member of :allowed_divisions)',
                    v_Param);
  
    q.Number_Field('object_id', 'modified_by');
    q.Varchar2_Field('name');
    q.Date_Field('modified_on');
  
    q.Refer_Field('modified_by_name',
                  'modified_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users t
                    where t.company_id = :company_id');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query(p Hashmap) return Fazo_Query is
    v_Query  varchar2(4000);
    v_Params Hashmap;
    q        Fazo_Query;
  begin
    v_Query := 'select q.*,
                      (select s.measure_id
                         from hsc_drivers s
                        where s.driver_id = q.driver_id) measure_id
                 from hsc_object_norms q
                where q.company_id = :company_id
                  and q.filial_id = :filial_id
                  and (:access_all_employee = ''Y'' or q.object_id member of :allowed_divisions)';
  
    v_Params := Fazo.Zip_Map('company_id', --
                             Ui.Company_Id,
                             'filial_id',
                             Ui.Filial_Id);
  
    v_Params.Put('allowed_divisions', Uit_Href.Get_All_Subordinate_Divisions);
    v_Params.Put('access_all_employee', Uit_Href.User_Access_All_Employees);
  
    if p.Has('object_id') then
      v_Query := v_Query || ' and q.object_id = :object_id';
    
      v_Params.Put('object_id', p.r_Number('object_id'));
    end if;
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('object_id',
                   'norm_id',
                   'area_id',
                   'process_id',
                   'action_id',
                   'driver_id',
                   'job_id',
                   'time_value');
    q.Number_Field('measure_id', 'modified_by', 'created_by');
    q.Date_Field('created_on', 'modified_on');
  
    q.Refer_Field('object_name',
                  'object_id',
                  'mhr_divisions',
                  'division_id',
                  'name',
                  'select *
                     from mhr_divisions t
                    where t.company_id = :company_id
                      and t.filial_id = :filial_id
                      and (:access_all_employee = ''Y'' 
                          or t.division_id member of :allowed_divisions)');
    q.Refer_Field('area_name',
                  'area_id',
                  'hsc_areas',
                  'area_id',
                  'name',
                  'select *
                     from hsc_areas t
                    where t.company_id = :company_id
                      and t.filial_id = :filial_id');
    q.Refer_Field('process_name',
                  'process_id',
                  'hsc_processes',
                  'process_id',
                  'name',
                  'select *
                     from hsc_processes t
                    where t.company_id = :company_id
                      and t.filial_id = :filial_id');
    q.Refer_Field('action_name',
                  'action_id',
                  'hsc_process_actions',
                  'action_id',
                  'name',
                  'select *
                     from hsc_process_actions t
                    where t.company_id = :company_id
                      and t.filial_id = :filial_id');
    q.Refer_Field('driver_name',
                  'driver_id',
                  'hsc_drivers',
                  'driver_id',
                  'name',
                  'select *
                     from hsc_drivers t
                    where t.company_id = :company_id
                      and t.filial_id = :filial_id');
    q.Refer_Field('job_name',
                  'job_id',
                  'mhr_jobs',
                  'job_id',
                  'name',
                  'select *
                     from mhr_jobs t
                    where t.company_id = :company_id
                      and t.filial_id = :filial_id');
    q.Refer_Field('created_by_name',
                  'created_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users t
                    where t.company_id = :company_id');
    q.Refer_Field('modified_by_name',
                  'modified_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users t
                    where t.company_id = :company_id');
    q.Refer_Field('measure_name',
                  'measure_id',
                  'mr_measures',
                  'measure_id',
                  'name',
                  'select *
                     from mr_measures t
                    where t.company_id = :company_id');
    q.Refer_Field('measure_short_name',
                  'measure_id',
                  'mr_measures',
                  'measure_id',
                  'short_name',
                  'select *
                     from mr_measures t
                    where t.company_id = :company_id');
  
    q.Map_Field('time_value_txt', 'Ui_Vhr494.Seconds_To_Time($time_value)');
    q.Map_Field('frequency_txt', 'Ui_Vhr494.Frequency_To_Text(:company_id, :filial_id, $norm_id)');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Norm_Ids Array_Number := Fazo.Sort(p.r_Array_Number('norm_id'));
  begin
    for i in 1 .. v_Norm_Ids.Count
    loop
      Hsc_Api.Object_Norm_Delete(i_Company_Id => Ui.Company_Id,
                                 i_Filial_Id  => Ui.Filial_Id,
                                 i_Norm_Id    => v_Norm_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Hsc_Object_Norms
       set Company_Id  = null,
           Filial_Id   = null,
           Object_Id   = null,
           Norm_Id     = null,
           Process_Id  = null,
           Action_Id   = null,
           Driver_Id   = null,
           Division_Id = null,
           Job_Id      = null,
           Time_Value  = null,
           Created_By  = null,
           Created_On  = null,
           Modified_By = null,
           Modified_On = null;
    update Mhr_Divisions
       set Company_Id  = null,
           Filial_Id   = null,
           Division_Id = null,
           name        = null;
    update Hsc_Areas
       set Company_Id = null,
           Filial_Id  = null,
           Area_Id    = null,
           name       = null;
    update Hsc_Processes
       set Company_Id = null,
           Filial_Id  = null,
           Process_Id = null,
           name       = null;
    update Hsc_Process_Actions
       set Company_Id = null,
           Filial_Id  = null,
           Action_Id  = null,
           name       = null;
    update Hsc_Drivers
       set Company_Id = null,
           Filial_Id  = null,
           Driver_Id  = null,
           name       = null;
    update Mhr_Jobs
       set Company_Id = null,
           Filial_Id  = null,
           Job_Id     = null,
           name       = null;
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           name       = null;
  end;

end Ui_Vhr494;
/
