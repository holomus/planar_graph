PL/SQL Developer Test script 3.0
151
-- Created on 12/28/2022 by SANJAR 
declare
  v_Company_Count number;
  v_Gen_Year      number := 2023;

  -------------------------------------------------- 
  Procedure Log_Error(i_Company_Id number) is
  begin
    insert into Gen_Year_Errors
      (Company_Id, Error_Message)
    values
      (i_Company_Id, Dbms_Utility.Format_Error_Stack || ' ' || Dbms_Utility.Format_Error_Backtrace);
  end;

  --------------------------------------------------
  Procedure Gen_Default_Calendar
  (
    i_Calendar Htt_Calendars%rowtype,
    i_Year     number
  ) is
    v_Calendar  Htt_Pref.Calendar_Rt;
    v_Rest_Days Array_Number;
    v_Prev_Year number := i_Year - 1;
  begin
    select Rd.Week_Day_No
      bulk collect
      into v_Rest_Days
      from Htt_Calendar_Rest_Days Rd
     where Rd.Company_Id = i_Calendar.Company_Id
       and Rd.Filial_Id = i_Calendar.Filial_Id
       and Rd.Calendar_Id = i_Calendar.Calendar_Id;
  
    Htt_Util.Calendar_New(o_Calendar    => v_Calendar,
                          i_Company_Id  => i_Calendar.Company_Id,
                          i_Filial_Id   => i_Calendar.Filial_Id,
                          i_Calendar_Id => i_Calendar.Calendar_Id,
                          i_Name        => i_Calendar.Name,
                          i_Code        => i_Calendar.Company_Id,
                          i_Year        => i_Year,
                          i_Rest_Day    => v_Rest_Days);
  
    for r in (select Cd.Name, to_char(Cd.Calendar_Date, 'dd.mm.') Date_Char
                from Htt_Calendar_Days Cd
               where Cd.Company_Id = i_Calendar.Company_Id
                 and Cd.Filial_Id = i_Calendar.Filial_Id
                 and Cd.Calendar_Id = i_Calendar.Calendar_Id
                 and Cd.Day_Kind = Htt_Pref.c_Day_Kind_Holiday
                 and Cd.Calendar_Date in
                     (to_date('01.01.' || v_Prev_Year, 'dd.mm.yyyy'),
                      to_date('08.03.' || v_Prev_Year, 'dd.mm.yyyy'),
                      to_date('21.03.' || v_Prev_Year, 'dd.mm.yyyy'),
                      to_date('09.05.' || v_Prev_Year, 'dd.mm.yyyy'),
                      to_date('01.09.' || v_Prev_Year, 'dd.mm.yyyy'),
                      to_date('01.10.' || v_Prev_Year, 'dd.mm.yyyy'),
                      to_date('08.12.' || v_Prev_Year, 'dd.mm.yyyy')))
    loop
      Htt_Util.Calendar_Add_Day(o_Calendar      => v_Calendar,
                                i_Calendar_Date => to_date(r.Date_Char || i_Year, 'dd.mm.yyyy'),
                                i_Name          => r.Name,
                                i_Day_Kind      => Htt_Pref.c_Day_Kind_Holiday,
                                i_Swapped_Date  => null);
    end loop;
  
    Htt_Api.Calendar_Save(v_Calendar);
  end;

  --------------------------------------------------
  Procedure Gen_Calendar(i_Company_Id number) is
    v_Filial_Head number := Md_Pref.Filial_Head(i_Company_Id);
    v_User_System number := Md_Pref.User_System(i_Company_Id);
  begin
    for r in (select q.Company_Id, q.Filial_Id
                from Md_Filials q
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id <> v_Filial_Head
                 and q.State = 'A'
                 and exists (select 1
                        from Md_Company_Filial_Modules Cm
                       where Cm.Company_Id = q.Company_Id
                         and Cm.Project_Code = Verifix.Project_Code
                         and Cm.Filial_Id = q.Filial_Id))
    loop
      Biruni_Route.Context_Begin;
    
      Ui_Context.Init(i_User_Id      => v_User_System,
                      i_Filial_Id    => r.Filial_Id,
                      i_Project_Code => Verifix.Project_Code);
    
      for Cl in (select *
                   from Htt_Calendars p
                  where p.Company_Id = r.Company_Id
                    and p.Filial_Id = r.Filial_Id
                    and p.Pcode = Htt_Pref.c_Pcode_Default_Calendar
                    and exists (select 1
                           from Htt_Calendar_Days Sd
                          where Sd.Company_Id = p.Company_Id
                            and Sd.Filial_Id = p.Filial_Id
                            and Sd.Calendar_Id = p.Calendar_Id
                            and Extract(year from Sd.Calendar_Date) = v_Gen_Year - 1)
                    and not exists
                  (select 1
                           from Htt_Calendar_Days Cd
                          where Cd.Company_Id = p.Company_Id
                            and Cd.Filial_Id = p.Filial_Id
                            and Cd.Calendar_Id = p.Calendar_Id
                            and Extract(year from Cd.Calendar_Date) = v_Gen_Year))
      loop
        Gen_Default_Calendar(i_Calendar => Cl, i_Year => v_Gen_Year);
      end loop;
    
      Biruni_Route.Context_End;
    end loop;
  end;

begin
  select count(c.Company_Id)
    into v_Company_Count
    from Md_Companies c
   where c.State = 'A'
     and (exists (select 1
                    from Md_Company_Projects Cp
                   where Cp.Company_Id = c.Company_Id
                     and Cp.Project_Code = Verifix.Project_Code) or
          c.Company_Id = Md_Pref.c_Company_Head);

  for Cmp in (select Qr.Company_Id, Rownum Rn
                from (select c.Company_Id
                        from Md_Companies c
                       where c.State = 'A'
                         and (exists (select 1
                                        from Md_Company_Projects Cp
                                       where Cp.Company_Id = c.Company_Id
                                         and Cp.Project_Code = Verifix.Project_Code) or
                              c.Company_Id = Md_Pref.c_Company_Head)
                       order by c.Company_Id) Qr)
  loop
    Dbms_Application_Info.Set_Module('gen calendar',
                                     (Cmp.Rn - 1) || '/' || v_Company_Count || ' generated');
  
    begin
      savepoint Try_Catch;
      Gen_Calendar(Cmp.Company_Id);
    exception
      when others then
        rollback to Try_Catch;
        Log_Error(Cmp.Company_Id);
    end;
  
    commit;
  end loop;
end;
0
0
