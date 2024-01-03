prompt migr from 23.12.2022 (2.dml)
----------------------------------------------------------------------------------------------------
prompt materialized view Htt_Employee_Monthly_Attendances_Mv
----------------------------------------------------------------------------------------------------
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
   
----------------------------------------------------------------------------------------------------     
prompt add action keys to mobile
----------------------------------------------------------------------------------------------------
declare
  v_Form varchar2(100) := '/vhr/hes/staff';

  v_Manager_Actions Array_Varchar2 := Array_Varchar2('request_reset',
                                                     'request_approve',                                                                                                          
                                                     'request_deny',                                                     
                                                     'request_delete',                                                                                                          
                                                     'change_approve',
                                                     'change_deny',                                                     
                                                     'change_delete',
                                                     'change_reset');
  v_Hr_Actions      Array_Varchar2 := Array_Varchar2('request_approve',
                                                     'request_deny',
                                                     'request_delete',
                                                     'request_reset',
                                                     'request_complete',
                                                     'change_approve',
                                                     'change_deny',
                                                     'change_delete',
                                                     'change_reset', 
                                                     'change_complete');
  v_Staff_Actions   Array_Varchar2 := Array_Varchar2('request_reset',
                                                     'request_approve',                                                                                                          
                                                     'request_deny',                                                     
                                                     'request_delete',                                                                                                          
                                                     'change_approve',
                                                     'change_deny',                                                     
                                                     'change_delete',
                                                     'change_reset');

  --------------------------------------------------
  Procedure Role_Form_Action_Grant
  (
    i_Company_Id number,
    i_Role_Id    number,
    i_Action_Key varchar2
  ) is
    r_Form          Md_Forms%rowtype := z_Md_Forms.Load(v_Form);
    r_Form_Action   Md_Form_Actions%rowtype;
    v_Filial_Access varchar2(10);
    v_Can_Save      boolean;
  begin
    for r in (select *
                from Md_User_Roles t
               where t.Company_Id = i_Company_Id
                 and t.Role_Id = i_Role_Id)
    loop
      v_Can_Save := false;
    
      if Md_Pref.Filial_Head(i_Company_Id) = r.Filial_Id then
        v_Filial_Access := 'H';
      else
        v_Filial_Access := 'F';
      end if;
    
      r_Form_Action := z_Md_Form_Actions.Take(i_Form => v_Form, i_Action_Key => i_Action_Key);
    
      if r_Form_Action.Filial_Access in ('A', v_Filial_Access) then
        v_Can_Save := true;
      end if;
    
      if v_Can_Save then
        z_Md_Gen_User_Form_Actions.Save_One(i_Company_Id => r.Company_Id,
                                            i_Filial_Id  => r.Filial_Id,
                                            i_User_Id    => r.User_Id,
                                            i_Form       => v_Form,
                                            i_Action_Key => i_Action_Key,
                                            i_Touched    => 'Y');
      end if;
    end loop;
  end;

  --------------------------------------------------
  Procedure Company_Fix(i_Company_Id number) is
    r_Role            Md_Roles%rowtype;
    v_Hr_Role_Id      number := Md_Util.Role_Id(i_Company_Id => i_Company_Id,
                                                i_Pcode      => Href_Pref.c_Pcode_Role_Hr);
    v_Staff_Role_Id   number := Md_Util.Role_Id(i_Company_Id => i_Company_Id,
                                                i_Pcode      => Href_Pref.c_Pcode_Role_Staff);
    v_Manager_Role_Id number := Md_Util.Role_Id(i_Company_Id => i_Company_Id,
                                                i_Pcode      => Href_Pref.c_Pcode_Role_Supervisor);
  begin  
    -- for hr
    r_Role := z_Md_Roles.Load(i_Company_Id => i_Company_Id, i_Role_Id => v_Hr_Role_Id);
  
    for j in 1 .. v_Hr_Actions.Count
    loop
      z_Md_Role_Form_Actions.Insert_Try(i_Company_Id => i_Company_Id,
                                        i_Role_Id    => v_Hr_Role_Id,
                                        i_Form       => v_Form,
                                        i_Action_Key => v_Hr_Actions(j));
    
      if r_Role.State = 'A' then
        Role_Form_Action_Grant(i_Company_Id => i_Company_Id,
                               i_Role_Id    => v_Hr_Role_Id,
                               i_Action_Key => v_Hr_Actions(j));
      end if;
    end loop;
  
    -- for staff
    r_Role := z_Md_Roles.Load(i_Company_Id => i_Company_Id, i_Role_Id => v_Staff_Role_Id);
  
    for j in 1 .. v_Staff_Actions.Count
    loop
      z_Md_Role_Form_Actions.Insert_Try(i_Company_Id => i_Company_Id,
                                        i_Role_Id    => v_Staff_Role_Id,
                                        i_Form       => v_Form,
                                        i_Action_Key => v_Staff_Actions(j));
    
      if r_Role.State = 'A' then
        Role_Form_Action_Grant(i_Company_Id => i_Company_Id,
                               i_Role_Id    => v_Staff_Role_Id,
                               i_Action_Key => v_Staff_Actions(j));
      end if;
    end loop;
  
    -- for manager
    r_Role := z_Md_Roles.Load(i_Company_Id => i_Company_Id, i_Role_Id => v_Manager_Role_Id);
  
    for j in 1 .. v_Manager_Actions.Count
    loop
      z_Md_Role_Form_Actions.Insert_Try(i_Company_Id => i_Company_Id,
                                        i_Role_Id    => v_Manager_Role_Id,
                                        i_Form       => v_Form,
                                        i_Action_Key => v_Manager_Actions(j));
    
      if r_Role.State = 'A' then
        Role_Form_Action_Grant(i_Company_Id => i_Company_Id,
                               i_Role_Id    => v_Manager_Role_Id,
                               i_Action_Key => v_Manager_Actions(j));
      end if;
    end loop;
  end;
begin
  Biruni_Route.Context_Begin;

  for r in (select c.Company_Id,
                   (select i.Filial_Head
                      from Md_Company_Infos i
                     where i.Company_Id = c.Company_Id) Filial_Head,
                   (select i.User_System
                      from Md_Company_Infos i
                     where i.Company_Id = c.Company_Id) User_System
              from Md_Companies c)
  loop
    Ui_Context.Init_Migr(i_Company_Id   => r.Company_Id,
                         i_Filial_Id    => r.Filial_Head,
                         i_User_Id      => r.User_System,
                         i_Project_Code => Href_Pref.c_Pc_Verifix_Hr);
  
    Company_Fix(r.Company_Id);
  end loop;

  Biruni_Route.Context_End;
 commit;
end;
/ 
