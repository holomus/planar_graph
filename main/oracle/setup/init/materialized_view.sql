begin
  for r in (select 'DROP MATERIALIZED VIEW ' || Object_Name Ddl
              from User_Objects t
             where t.Object_Name = Upper('Htt_Employee_Monthly_Attendances_Mv')
               and t.Object_Type = 'MATERIALIZED VIEW'
             order by t.Object_Id desc)
  loop
    execute immediate r.Ddl;
  end loop;
end;
/

create Materialized View Htt_Employee_Monthly_Attendances_Mv as
  select k.Company_Id,
         k.Filial_Id,
         k.Staff_Id,
         k.Employee_Id,
         k.Month,
         count(case
                  when k.Input_Time is not null and k.Fact_Late > 0 then
                   1
                  else
                   null
                end) as Late_Cnt,
         count(case
                  when k.Output_Time is not null and k.Fact_Early > 0 then
                   1
                  else
                   null
                end) as Early_Cnt,
         count(case
                  when k.Plan_Time <= k.Fact_Intime + k.Fact_Absence then
                   1
                  else
                   null
                end) as Intime_Cnt,
         count(case
                  when k.Fact_Intime <= 0 then
                   1
                  else
                   null
                end) as Absence_Cnt
    from (select k.Company_Id,
                 k.Filial_Id,
                 k.Staff_Id,
                 k.Employee_Id,
                 Trunc(k.Timesheet_Date, 'MON') as month,
                 k.Input_Time,
                 k.Output_Time,
                 k.Plan_Time,
                 Nvl((select t.Fact_Value
                       from Htt_Timesheet_Facts t
                      where t.Company_Id = k.Company_Id
                        and t.Filial_Id = k.Filial_Id
                        and t.Timesheet_Id = k.Timesheet_Id
                        and t.Time_Kind_Id = (select Tk.Time_Kind_Id
                                                from Htt_Time_Kinds Tk
                                               where Tk.Company_Id = k.Company_Id
                                                 and Tk.Pcode = 'VHR:2')),
                     0) as Fact_Late,
                 Nvl((select sum(t.Fact_Value)
                       from Htt_Timesheet_Facts t
                      where t.Company_Id = k.Company_Id
                        and t.Filial_Id = k.Filial_Id
                        and t.Timesheet_Id = k.Timesheet_Id
                        and t.Time_Kind_Id in
                            (select Tk.Time_Kind_Id
                               from Htt_Time_Kinds Tk
                               left join Htt_Time_Kinds p
                                 on p.Company_Id = Tk.Company_Id
                                and p.Time_Kind_Id = Tk.Parent_Id
                              where Tk.Company_Id = k.Company_Id
                                and (Tk.Pcode = 'VHR:1' or p.Pcode = 'VHR:1'))),
                     0) as Fact_Intime,
                 Nvl((select t.Fact_Value
                       from Htt_Timesheet_Facts t
                      where t.Company_Id = k.Company_Id
                        and t.Filial_Id = k.Filial_Id
                        and t.Timesheet_Id = k.Timesheet_Id
                        and t.Time_Kind_Id = (select Tk.Time_Kind_Id
                                                from Htt_Time_Kinds Tk
                                               where Tk.Company_Id = k.Company_Id
                                                 and Tk.Pcode = 'VHR:3')),
                     0) as Fact_Early,
                 Nvl((select sum(t.Fact_Value)
                       from Htt_Timesheet_Facts t
                      where t.Company_Id = k.Company_Id
                        and t.Filial_Id = k.Filial_Id
                        and t.Timesheet_Id = k.Timesheet_Id
                        and t.Time_Kind_Id in
                            (select Tk.Time_Kind_Id
                               from Htt_Time_Kinds Tk
                               left join Htt_Time_Kinds p
                                 on p.Company_Id = Tk.Company_Id
                                and p.Time_Kind_Id = Tk.Parent_Id
                              where Tk.Company_Id = k.Company_Id
                                and (Tk.Pcode in ('VHR:4', 'VHR:9', 'VHR:8', 'VHR:10', 'VHR:11') or
                                    p.Pcode in ('VHR:4', 'VHR:9', 'VHR:8', 'VHR:10', 'VHR:11')))),
                     0) as Fact_Absence
            from Htt_Timesheets k
           where k.Timesheet_Date between Trunc(Add_Months(sysdate, -12), 'yyyy') and
                 Last_Day(Trunc(sysdate))
             and k.Day_Kind = 'W'
             and exists (select 1
                    from Md_Companies c
                   where c.Company_Id = k.Company_Id
                     and c.State = 'A')
             and exists (select 1
                    from Md_Filials f
                   where f.Company_Id = k.Company_Id
                     and f.Filial_Id = k.Filial_Id
                     and f.State = 'A')
             and not exists (select 1
                    from Hlic_Unlicensed_Employees Le
                   where Le.Company_Id = k.Company_Id
                     and Le.Employee_Id = k.Employee_Id
                     and Le.Licensed_Date = k.Timesheet_Date)) k
   group by k.Company_Id, k.Filial_Id, k.Staff_Id, k.Employee_Id, k.Month;
   
create index Htt_Employee_Monthly_Attendances_Mv_i1 on Htt_Employee_Monthly_Attendances_Mv(Company_Id, Filial_Id, Staff_id, Month);
