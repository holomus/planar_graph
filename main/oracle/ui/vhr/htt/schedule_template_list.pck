create or replace package Ui_Vhr354 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
end Ui_Vhr354;
/
create or replace package body Ui_Vhr354 is
  ----------------------------------------------------------------------------------------------------  
  Function Query return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('htt_schedule_templates');
  
    q.Number_Field('template_id',
                   'shift',
                   'input_acceptance',
                   'output_acceptance',
                   'track_duration',
                   'order_no');
    q.Varchar2_Field('name',
                     'description',
                     'count_late',
                     'count_early',
                     'count_lack',
                     'state',
                     'code');
  
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
    q.Option_Field('state_name',
                   'state',
                   Array_Varchar2('A', 'P'),
                   Array_Varchar2(Ui.t_Active, Ui.t_Passive));
  
    q.Map_Field('shift_time', 'htt_util.to_time($shift)');
    q.Map_Field('input_acceptance_time', 'htt_util.to_time($input_acceptance)');
    q.Map_Field('output_acceptance_time', 'htt_util.to_time($output_acceptance)');
    q.Map_Field('track_duration_time', 'htt_util.to_time($track_duration)');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Del(p Hashmap) is
    v_Template_Ids Array_Number := Fazo.Sort(p.r_Array_Number('template_id'));
  begin
    for i in 1 .. v_Template_Ids.Count
    loop
      Htt_Api.Schedule_Template_Delete(v_Template_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Validation is
  begin
    update Htt_Schedule_Templates
       set Template_Id       = null,
           name              = null,
           Description       = null,
           Schedule_Kind     = null,
           All_Days_Equal    = null,
           Count_Days        = null,
           Shift             = null,
           Input_Acceptance  = null,
           Output_Acceptance = null,
           Track_Duration    = null,
           Count_Late        = null,
           Count_Early       = null,
           Count_Lack        = null,
           Order_No          = null,
           State             = null,
           Code              = null;
  
    Uie.x(Htt_Util.To_Time(null));
  end;

end Ui_Vhr354;
/
