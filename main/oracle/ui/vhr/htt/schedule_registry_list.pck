create or replace package Ui_Vhr445 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Post(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Unpost(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
end Ui_Vhr445;
/
create or replace package body Ui_Vhr445 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query is
    v_Matrix Matrix_Varchar2;
    v_Query  varchar2(4000);
    v_Params Hashmap;
    q        Fazo_Query;
  begin
    v_Query := 'select *
                  from htt_schedule_registries r
                 where r.company_id = :company_id
                   and r.filial_id = :filial_id
                   and r.registry_kind = :kind';
  
    v_Params := Fazo.Zip_Map('company_id',
                             Ui.Company_Id,
                             'filial_id',
                             Ui.Filial_Id,
                             'kind',
                             Uit_Htt.Get_Registry_Kind);
  
    if Uit_Href.User_Access_All_Employees = 'N' then
      v_Query := v_Query || ' and r.division_id in (select column_value from table(:division_ids))';
    
      v_Params.Put('division_ids',
                   Uit_Href.Get_Subordinate_Divisions(i_Direct   => true,
                                                      i_Indirect => true,
                                                      i_Manual   => true));
    end if;
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('registry_id',
                   'division_id',
                   'calendar_id',
                   'shift',
                   'input_acceptance',
                   'output_acceptance',
                   'track_duration',
                   'created_by',
                   'modified_by');
    q.Varchar2_Field('registry_number', 'schedule_kind', 'note', 'posted');
    q.Date_Field('registry_date', 'month', 'created_on', 'modified_on');
  
    q.Refer_Field('division_name',
                  'division_id',
                  Uit_Hrm.Divisions_Query(i_Only_Departments => false),
                  'division_id',
                  'name',
                  Uit_Hrm.Departments_Query);
    q.Refer_Field('calendar_name',
                  'calendar_id',
                  'htt_calendars',
                  'calendar_id',
                  'name',
                  'select * 
                     from htt_calendars q 
                    where q.company_id = :company_id
                      and q.filial_id = :filial_id');
    q.Refer_Field('created_by_name',
                  'created_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select w.* 
                     from md_users w 
                    where w.company_id = :company_id');
    q.Refer_Field('modified_by_name',
                  'modified_by',
                  'md_users',
                  'user_id',
                  'name',
                  'select w.* 
                     from md_users w 
                    where w.company_id = :company_id');
  
    q.Option_Field('posted_name',
                   'posted',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
  
    v_Matrix := Htt_Util.Schedule_Kinds;
  
    q.Option_Field(i_Name  => 'schedule_kind_name',
                   i_For   => 'schedule_kind',
                   i_Codes => v_Matrix(1),
                   i_Names => v_Matrix(2));
  
    q.Map_Field('shift_time', 'htt_util.to_time($shift)');
    q.Map_Field('input_acceptance_time', 'htt_util.to_time($input_acceptance)');
    q.Map_Field('output_acceptance_time', 'htt_util.to_time($output_acceptance)');
    q.Map_Field('track_duration_time', 'htt_util.to_time($track_duration)');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap is
    result Hashmap := Hashmap();
  begin
    Result.Put('references',
               Fazo.Zip_Map('sk_custom',
                            Htt_Pref.c_Schedule_Kind_Custom,
                            'sk_hourly',
                            Htt_Pref.c_Schedule_Kind_Hourly,
                            'sk_flexible',
                            Htt_Pref.c_Schedule_Kind_Flexible));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Post(p Hashmap) is
    v_Company_Id   number := Ui.Company_Id;
    v_Filial_Id    number := Ui.Filial_Id;
    v_Registry_Ids Array_Number := Fazo.Sort(p.r_Array_Number('registry_id'));
    r_Registry     Htt_Schedule_Registries%rowtype;
  begin
    for i in 1 .. v_Registry_Ids.Count
    loop
      r_Registry := z_Htt_Schedule_Registries.Lock_Load(i_Company_Id  => v_Company_Id,
                                                        i_Filial_Id   => v_Filial_Id,
                                                        i_Registry_Id => v_Registry_Ids(i));
    
      Uit_Htt.Assert_Access_Registry_Kind(r_Registry.Registry_Kind);
      Uit_Htt.Assert_Access_To_Schedule_Kind(r_Registry.Schedule_Kind);
    
      Htt_Api.Schedule_Registry_Post(i_Registry_Id => r_Registry.Registry_Id,
                                     i_Company_Id  => r_Registry.Company_Id,
                                     i_Filial_Id   => r_Registry.Filial_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Unpost(p Hashmap) is
    v_Company_Id   number := Ui.Company_Id;
    v_Filial_Id    number := Ui.Filial_Id;
    v_Registry_Ids Array_Number := Fazo.Sort(p.r_Array_Number('registry_id'));
    r_Registry     Htt_Schedule_Registries%rowtype;
  begin
    for i in 1 .. v_Registry_Ids.Count
    loop
      r_Registry := z_Htt_Schedule_Registries.Lock_Load(i_Company_Id  => v_Company_Id,
                                                        i_Filial_Id   => v_Filial_Id,
                                                        i_Registry_Id => v_Registry_Ids(i));
    
      Uit_Htt.Assert_Access_Registry_Kind(r_Registry.Registry_Kind);
      Uit_Htt.Assert_Access_To_Schedule_Kind(r_Registry.Schedule_Kind);
    
      Htt_Api.Schedule_Registry_Unpost(i_Registry_Id => r_Registry.Registry_Id,
                                       i_Company_Id  => r_Registry.Company_Id,
                                       i_Filial_Id   => r_Registry.Filial_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Company_Id   number := Ui.Company_Id;
    v_Filial_Id    number := Ui.Filial_Id;
    v_Registry_Ids Array_Number := Fazo.Sort(p.r_Array_Number('registry_id'));
    r_Registry     Htt_Schedule_Registries%rowtype;
  begin
    for i in 1 .. v_Registry_Ids.Count
    loop
      r_Registry := z_Htt_Schedule_Registries.Lock_Load(i_Company_Id  => v_Company_Id,
                                                        i_Filial_Id   => v_Filial_Id,
                                                        i_Registry_Id => v_Registry_Ids(i));
    
      Uit_Htt.Assert_Access_Registry_Kind(r_Registry.Registry_Kind);
      Uit_Htt.Assert_Access_To_Schedule_Kind(r_Registry.Schedule_Kind);
    
      Htt_Api.Schedule_Registry_Delete(i_Company_Id  => r_Registry.Company_Id,
                                       i_Filial_Id   => r_Registry.Filial_Id,
                                       i_Registry_Id => r_Registry.Registry_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Htt_Schedule_Registries
       set Company_Id        = null,
           Filial_Id         = null,
           Registry_Id       = null,
           Registry_Date     = null,
           Registry_Number   = null,
           Registry_Kind     = null,
           Schedule_Kind     = null,
           month             = null,
           Division_Id       = null,
           Note              = null,
           Posted            = null,
           Shift             = null,
           Input_Acceptance  = null,
           Output_Acceptance = null,
           Track_Duration    = null,
           Created_By        = null,
           Created_On        = null,
           Modified_By       = null,
           Modified_On       = null;
    update Mhr_Divisions
       set Company_Id  = null,
           Filial_Id   = null,
           Division_Id = null,
           name        = null;
    update Htt_Calendars
       set Company_Id  = null,
           Filial_Id   = null,
           Calendar_Id = null,
           name        = null;
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           name       = null;
    Uie.x(Htt_Util.To_Time(null));
  end;

end Ui_Vhr445;
/
