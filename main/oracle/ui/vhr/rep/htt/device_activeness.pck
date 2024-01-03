create or replace package Ui_Vhr319 is
  ----------------------------------------------------------------------------------------------------  
  Function Query return Fazo_Query;
end Ui_Vhr319;
/
create or replace package body Ui_Vhr319 is
  ----------------------------------------------------------------------------------------------------
  Function Query return Fazo_Query is
    v_Params Hashmap := Hashmap();
    q        Fazo_Query;
  begin
    v_Params.Put('today', sysdate);
    v_Params.Put('company_head', Md_Pref.Company_Head);
  
    q := Fazo_Query('select c.company_id,
                            min(c.name) name,
                            min(f.phone) phone,
                            min(f.email) email,
                            count(d.device_id) device_count,
                            count(case
                                    when d.diff * 24 > 1 then
                                     1
                                    else
                                     null
                                   end) as hour_inactive,
                            count(case
                                    when d.diff * 24 > 3 then
                                     1
                                    else
                                     null
                                   end) as three_hour_inactive,
                            count(case
                                    when d.diff * 24 > 12 then
                                     1
                                    else
                                     null
                                   end) as twelve_hour_inactive,
                            count(case
                                    when d.diff > 1 then
                                     1
                                    else
                                     null
                                   end) as day_inactive,
                            count(case
                                    when d.diff > 3 then
                                     1
                                    else
                                     null
                                   end) as three_day_inactive
                       from md_companies c
                       join md_company_infos f
                         on c.company_id = f.company_id
                       join (select t.company_id,
                                    t.device_id,
                                    :today - t.last_seen_on as diff
                               from htt_devices t
                              where t.state = ''A'') d
                         on c.company_id = d.company_id
                      where c.state = ''A''
                        and c.company_id <> :company_head
                      group by c.company_id',
                    v_Params);
  
    q.Number_Field('company_id',
                   'device_count',
                   'hour_inactive',
                   'three_hour_inactive',
                   'twelve_hour_inactive',
                   'day_inactive',
                   'three_day_inactive');
    q.Varchar2_Field('name', 'phone', 'email');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Md_Companies
       set Company_Id = null,
           name       = null,
           State      = null;
    update Md_Company_Infos
       set Company_Id = null,
           Phone      = null,
           Email      = null;
    update Htt_Devices
       set Company_Id   = null,
           Device_Id    = null,
           Last_Seen_On = null,
           State        = null;
  end;

end Ui_Vhr319;
/
