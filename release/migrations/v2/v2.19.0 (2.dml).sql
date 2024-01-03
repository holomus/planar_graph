prompt updating schedules
---------------------------------------------------------------------------------------------------- 
update htt_schedules p
   set p.schedule_kind = 'C';
commit;

----------------------------------------------------------------------------------------------------
declare
begin
  for r in (select *
              from Md_Companies q)
  loop
    for Fil in (select *
                  from Md_Filials Fl
                 where Fl.Company_Id = r.Company_Id)
    loop
      update Htt_Timesheets p
         set p.Schedule_Kind = 'C'
       where p.Company_Id = Fil.Company_Id
         and p.Filial_Id = Fil.Filial_Id;
      commit;
    end loop;
  end loop;
end;
/

----------------------------------------------------------------------------------------------------
declare
begin
  for r in (select *
              from Md_Companies q)
  loop
    for Fil in (select *
                  from Md_Filials Fl
                 where Fl.Company_Id = r.Company_Id)
    loop
      update Htt_Tracks t
         set t.Trans_Input  = Nvl((select q.Autogen_Inputs
                                    from Htt_Devices q
                                   where q.Company_Id = Fil.Company_Id
                                     and q.Device_Id = t.Device_Id),
                                  'N'),
             t.Trans_Output = Nvl((select q.Autogen_Outputs
                                    from Htt_Devices q
                                   where q.Company_Id = Fil.Company_Id
                                     and q.Device_Id = t.Device_Id),
                                  'N')
       where t.Company_Id = Fil.Company_Id
         and t.Filial_Id = Fil.Filial_Id;
      commit;
    end loop;
  end loop;
end;
/

----------------------------------------------------------------------------------------------------
declare
begin
  for r in (select *
              from Md_Companies q)
  loop
    for Fil in (select *
                  from Md_Filials Fl
                 where Fl.Company_Id = r.Company_Id)
    loop
      update Htt_Timesheet_Tracks t
         set (t.Trans_Input, t.Trans_Output) =
             (select q.Trans_Input, q.Trans_Output
                from Htt_Tracks q
               where q.Company_Id = Fil.Company_Id
                 and q.Filial_Id = Fil.Filial_Id
                 and q.Track_Id = t.Track_Id)
       where t.Company_Id = Fil.Company_Id
         and t.Filial_Id = Fil.Filial_Id;
      commit;
    end loop;
  end loop;
end;
/

----------------------------------------------------------------------------------------------------
prompt inserting into acms devices
----------------------------------------------------------------------------------------------------
insert into Htt_Acms_Devices q
  (q.Company_Id,
   q.Device_Id,
   q.Dynamic_Ip,
   q.Ip_Address,
   q.Port,
   q.Protocol,
   q.Host,
   q.Login,
   q.Password)
  select w.Company_Id,
         w.Device_Id,
         w.Dynamic_Ip,
         w.Ip_Address,
         w.Port,
         w.Protocol,
         w.Host,
         w.Login,
         w.Password
    from Htt_Hikvision_Devices w;
commit;
