create or replace package Ui_Vhr30 is
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
end Ui_Vhr30;
/
create or replace package body Ui_Vhr30 is
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap is
    v_Templates Matrix_Varchar2;
    result      Hashmap := Hashmap();
  begin
    select Array_Varchar2(t.Template_Id,
                           t.Name,
                           t.Description,
                           Htt_Util.t_Schedule_Kind(t.Schedule_Kind),
                           Decode(t.Shift, 0, 'N', 'Y'),
                           t.Count_Late,
                           t.Count_Early,
                           t.Count_Lack,
                           case
                             when exists (select 1
                                     from Htt_Schedule_Template_Marks m
                                    where m.Template_Id = t.Template_Id) then
                              'Y'
                             else
                              'N'
                           end)
      bulk collect
      into v_Templates
      from Htt_Schedule_Templates t
     where t.State = 'A'
     order by t.Order_No;
  
    Result.Put('references',
               Fazo.Zip_Map('sk_custom',
                            Htt_Pref.c_Schedule_Kind_Custom,
                            'sk_hourly',
                            Htt_Pref.c_Schedule_Kind_Hourly,
                            'sk_flexible',
                            Htt_Pref.c_Schedule_Kind_Flexible));
  
    Result.Put('templates', Fazo.Zip_Matrix(v_Templates));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Query return Fazo_Query is
    v_Matrix Matrix_Varchar2;
    q        Fazo_Query;
  begin
    q := Fazo_Query('htt_schedules',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id),
                    true);
  
    q.Number_Field('schedule_id',
                   'shift',
                   'input_acceptance',
                   'output_acceptance',
                   'track_duration',
                   'calendar_id',
                   'created_by',
                   'modified_by');
    q.Varchar2_Field('name',
                     'count_late',
                     'count_early',
                     'count_lack',
                     'count_free',
                     'take_holidays',
                     'take_nonworking',
                     'state',
                     'code',
                     'barcode');
    q.Varchar2_Field('schedule_kind', 'pcode', 'take_additional_rest_days');
    q.Date_Field('created_on', 'modified_on');
  
    q.Refer_Field('calendar_name',
                  'calendar_id',
                  'htt_calendars',
                  'calendar_id',
                  'name',
                  'select w.* 
                     from htt_calendars w 
                    where w.company_id = :company_id
                      and w.filial_id = :filial_id');
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
  
    q.Option_Field('count_late_name',
                   'count_late',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
    q.Option_Field('count_early_name',
                   'count_early',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
    q.Option_Field('count_lack_name',
                   'count_lack',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
    q.Option_Field('count_free_name',
                   'count_free',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
    q.Option_Field('take_holidays_name',
                   'take_holidays',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
    q.Option_Field('take_nonworking_name',
                   'take_nonworking',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
    q.Option_Field('take_additional_rest_days_name',
                   'take_additional_rest_days',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
    q.Option_Field('state_name',
                   'state',
                   Array_Varchar2('A', 'P'),
                   Array_Varchar2(Ui.t_Active, Ui.t_Passive));
  
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
  Procedure Del(p Hashmap) is
    v_Schedule_Ids Array_Number := p.r_Array_Number('schedule_id');
  begin
    for i in 1 .. v_Schedule_Ids.Count
    loop
      Htt_Api.Schedule_Delete(i_Company_Id  => Ui.Company_Id,
                              i_Filial_Id   => Ui.Filial_Id,
                              i_Schedule_Id => v_Schedule_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Validation is
  begin
    update Htt_Schedules
       set Company_Id                = null,
           Filial_Id                 = null,
           Schedule_Id               = null,
           name                      = null,
           Shift                     = null,
           Schedule_Kind             = null,
           Input_Acceptance          = null,
           Output_Acceptance         = null,
           Track_Duration            = null,
           Count_Late                = null,
           Count_Early               = null,
           Count_Lack                = null,
           Count_Free                = null,
           Calendar_Id               = null,
           Take_Holidays             = null,
           Take_Nonworking           = null,
           Take_Additional_Rest_Days = null,
           State                     = null,
           Code                      = null,
           Barcode                   = null,
           Pcode                     = null,
           Created_By                = null,
           Created_On                = null,
           Modified_By               = null,
           Modified_On               = null;
    update Htt_Calendars
       set Company_Id  = null,
           Filial_Id   = null,
           Calendar_Id = null,
           name        = null;
  
    Uie.x(Htt_Util.To_Time(null));
  end;

end Ui_Vhr30;
/
