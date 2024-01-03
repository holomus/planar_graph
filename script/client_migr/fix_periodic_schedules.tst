PL/SQL Developer Test script 3.0
295
-- Created on 06.12.2022 by SANJAR 
declare
  v_Old_Company_Id number := 480;
  v_New_Company_Id number := 580;

  v_Subcompany_Id number := 1396;
  v_Filial_Id     number := 16177;

  v_Schedule_Id number;

  r_Schedule Htt_Schedules%rowtype;
  r_Pattern  Htt_Schedule_Patterns%rowtype;

  v_Period_Start date := to_date('01.01.2000', 'dd.mm.yyyy');

  g_Schedule_Cache Fazo.Number_Code_Aat;

  --------------------------------------------------
  Function Get_Schedule_Id
  (
    i_Schedule_Id    number,
    i_Schedule_Shift number
  ) return number is
    v_Name varchar2(1000 char);
    result number;
  begin
    select p.Name
      into v_Name
      from Old_Vx_Ref_Schedules p
     where p.Company_Id = v_Old_Company_Id
       and p.Schedule_Id = i_Schedule_Id;
  
    if i_Schedule_Shift > 0 then
      v_Name := v_Name || ' (сдвиг ' || i_Schedule_Shift || ' дней)';
    end if;
  
    begin
      select p.Schedule_Id
        into result
        from Htt_Schedules p
       where p.Company_Id = v_New_Company_Id
         and p.Filial_Id = v_Filial_Id
         and Lower(p.Name) = Lower(v_Name);
    exception
      when No_Data_Found then
        b.Raise_Error(v_Name);
    end;
    return result;
  end;

  -------------------------------------------------- 
  Function Get_New_Id
  (
    i_New_Company_Id number,
    i_Key_Name       varchar2,
    i_Old_Id         number
  ) return number is
    result number;
  begin
    select New_Id
      into result
      from Migr_Keys_Store_One So
     where So.Company_Id = i_New_Company_Id
       and So.Key_Name = i_Key_Name
       and So.Old_Id = i_Old_Id;
  
    return result;
  end;

  -------------------------------------------------- 
  Procedure Migr_Schedule_Changes
  (
    i_Old_Company_Id number,
    i_New_Company_Id number
  ) is
    v_Employee_Id      number;
    v_Total            number;
    v_Desired_Date     date;
    v_Schedule_Journal Hpd_Pref.Schedule_Change_Journal_Rt;
  
    v_Page_Id number;
  begin
    select count(*)
      into v_Total
      from (select p.*
              from Old_Vx_Tp_Timetables p
              join Old_Vx_Ref_Schedules q
                on q.Company_Id = p.Company_Id
               and q.Schedule_Id = p.Schedule_Id
               and q.Schedule_Kind = 'P'
               and q.Schedule_Id <> 915
              join Old_Vx_Hr_Employees Ep
                on Ep.Company_Id = p.Company_Id
               and Ep.Employee_Id = p.Employee_Id
               and Ep.Subcompany_Id = v_Subcompany_Id
             where p.Company_Id = v_Old_Company_Id) Qr;
  
    for r in (select Qr.*, Rownum
                from (select p.Employee_Id,
                             p.Begin_Date,
                             p.Schedule_Id Old_Schedule_Id,
                             Nvl(p.End_Date, to_date('01.01.2999', 'dd.mm.yyyy')) End_Date_Nvl,
                             mod(q.Count_Days +
                                 mod(p.Begin_Date - to_date('01.01.2022', 'dd.mm.yyyy'), q.Count_Days),
                                 q.Count_Days) Schedule_Shift
                        from Old_Vx_Tp_Timetables p
                        join Old_Vx_Ref_Schedules q
                          on q.Company_Id = p.Company_Id
                         and q.Schedule_Id = p.Schedule_Id
                         and q.Schedule_Kind = 'P'
                         and q.Schedule_Id <> 915
                        join Old_Vx_Hr_Employees Ep
                          on Ep.Company_Id = p.Company_Id
                         and Ep.Employee_Id = p.Employee_Id
                         and Ep.Subcompany_Id = v_Subcompany_Id
                       where p.Company_Id = v_Old_Company_Id) Qr
               order by Qr.Employee_Id, Qr.Begin_Date)
    loop
      Dbms_Application_Info.Set_Module('Migr_Schedule_Changes',
                                       (r.Rownum - 1) || '/' || v_Total || ' timetables');
    
      v_Employee_Id := Get_New_Id(i_New_Company_Id => i_New_Company_Id,
                                  i_Key_Name       => 'person_id',
                                  i_Old_Id         => r.Employee_Id);
    
      for St in (select *
                   from Href_Staffs p
                  where p.Company_Id = i_New_Company_Id
                    and p.Filial_Id = v_Filial_Id
                    and p.Employee_Id = v_Employee_Id)
      loop
        v_Desired_Date := Greatest(r.Begin_Date, St.Hiring_Date);
      
        continue when r.End_Date_Nvl < v_Desired_Date;
      
        Hpd_Util.Schedule_Change_Journal_New(o_Journal        => v_Schedule_Journal,
                                             i_Company_Id     => i_New_Company_Id,
                                             i_Filial_Id      => St.Filial_Id,
                                             i_Journal_Id     => Hpd_Next.Journal_Id,
                                             i_Journal_Number => null,
                                             i_Journal_Date   => r.Begin_Date,
                                             i_Journal_Name   => null,
                                             i_Division_Id    => null,
                                             i_Begin_Date     => Least(v_Desired_Date,
                                                                       Nvl(St.Dismissal_Date,
                                                                           v_Desired_Date)),
                                             i_End_Date       => null);
      
        v_Page_Id := Hpd_Next.Page_Id;
      
        Hpd_Util.Journal_Add_Schedule_Change(p_Journal     => v_Schedule_Journal,
                                             i_Page_Id     => v_Page_Id,
                                             i_Staff_Id    => St.Staff_Id,
                                             i_Schedule_Id => Get_Schedule_Id(r.Old_Schedule_Id,
                                                                              r.Schedule_Shift));
      
        Hpd_Api.Schedule_Change_Journal_Save(v_Schedule_Journal);
        Hpd_Api.Journal_Post(i_Company_Id => v_Schedule_Journal.Company_Id,
                             i_Filial_Id  => v_Schedule_Journal.Filial_Id,
                             i_Journal_Id => v_Schedule_Journal.Journal_Id);
      end loop;
    end loop;
  
    Dbms_Application_Info.Set_Module('Migr_Schedule_Changes', 'finished Migr_Schedule_Changes');
  end;
begin
  Ui_Auth.Logon_As_System(v_New_Company_Id);

  for r in (select Ks.New_Id         New_Schedule_Id, --
                   Qr.Schedule_Id    Old_Schedule_Id,
                   Qr.Schedule_Shift
              from (select q.Schedule_Id,
                           mod(q.Count_Days +
                               mod(p.Begin_Date - to_date('01.01.2022', 'dd.mm.yyyy'), q.Count_Days),
                               q.Count_Days) Schedule_Shift
                      from Old_Vx_Tp_Timetables p
                      join Old_Vx_Ref_Schedules q
                        on q.Company_Id = p.Company_Id
                       and q.Schedule_Id = p.Schedule_Id
                       and q.Schedule_Kind = 'P'
                      join Old_Vx_Hr_Employees Ep
                        on Ep.Company_Id = p.Company_Id
                       and Ep.Employee_Id = p.Employee_Id
                       and Ep.Subcompany_Id = v_Subcompany_Id
                     where p.Company_Id = v_Old_Company_Id
                     group by q.Schedule_Id,
                              mod(q.Count_Days +
                                  mod(p.Begin_Date - to_date('01.01.2022', 'dd.mm.yyyy'),
                                      q.Count_Days),
                                  q.Count_Days)) Qr
              join Migr_Keys_Store_Two Ks
                on Ks.Company_Id = v_New_Company_Id
               and Ks.Filial_Id = v_Filial_Id
               and Ks.Key_Name = 'schedule_id'
               and Ks.Old_Id = Qr.Schedule_Id
             where Qr.Schedule_Shift > 0)
  loop
    r_Schedule := z_Htt_Schedules.Load(i_Company_Id  => v_New_Company_Id,
                                       i_Filial_Id   => v_Filial_Id,
                                       i_Schedule_Id => r.New_Schedule_Id);
    r_Pattern  := z_Htt_Schedule_Patterns.Load(i_Company_Id  => v_New_Company_Id,
                                               i_Filial_Id   => v_Filial_Id,
                                               i_Schedule_Id => r.New_Schedule_Id);
  
    r_Schedule.Name := r_Schedule.Name || ' (сдвиг ' || r.Schedule_Shift || ' дней)';
  
    v_Schedule_Id := Htt_Next.Schedule_Id;
  
    z_Htt_Schedules.Insert_One(i_Company_Id        => v_New_Company_Id,
                               i_Filial_Id         => v_Filial_Id,
                               i_Schedule_Id       => v_Schedule_Id,
                               i_Name              => r_Schedule.Name,
                               i_Shift             => r_Schedule.Shift,
                               i_Input_Acceptance  => r_Schedule.Input_Acceptance,
                               i_Output_Acceptance => r_Schedule.Output_Acceptance,
                               i_Track_Duration    => r_Schedule.Track_Duration,
                               i_Count_Late        => r_Schedule.Count_Late,
                               i_Count_Early       => r_Schedule.Count_Early,
                               i_Count_Lack        => r_Schedule.Count_Lack,
                               i_Calendar_Id       => r_Schedule.Calendar_Id,
                               i_Take_Holidays     => r_Schedule.Take_Holidays,
                               i_Take_Nonworking   => r_Schedule.Take_Nonworking,
                               i_State             => r_Schedule.State,
                               i_Code              => r_Schedule.Code,
                               i_Barcode           => r_Schedule.Barcode,
                               i_Pcode             => r_Schedule.Pcode);
  
    z_Htt_Schedule_Patterns.Insert_One(i_Company_Id     => r_Pattern.Company_Id,
                                       i_Filial_Id      => r_Pattern.Filial_Id,
                                       i_Schedule_Id    => v_Schedule_Id,
                                       i_Schedule_Kind  => r_Pattern.Schedule_Kind,
                                       i_All_Days_Equal => r_Pattern.All_Days_Equal,
                                       i_Count_Days     => r_Pattern.Count_Days);
  
    insert into Htt_Schedule_Pattern_Days
      (Company_Id,
       Filial_Id,
       Schedule_Id,
       Day_No,
       Day_Kind,
       Plan_Time,
       Begin_Time,
       End_Time,
       Break_Enabled,
       Break_Begin_Time,
       Break_End_Time)
      select Pd.Company_Id,
             Pd.Filial_Id,
             v_Schedule_Id,
             mod((Pd.Day_No - 1) + r.Schedule_Shift, r_Pattern.Count_Days) + 1,
             Pd.Day_Kind,
             Pd.Plan_Time,
             Pd.Begin_Time,
             Pd.End_Time,
             Pd.Break_Enabled,
             Pd.Break_Begin_Time,
             Pd.Break_End_Time
        from Htt_Schedule_Pattern_Days Pd
       where Pd.Company_Id = v_New_Company_Id
         and Pd.Filial_Id = v_Filial_Id
         and Pd.Schedule_Id = r.New_Schedule_Id;
  
    insert into Htt_Schedule_Pattern_Marks
      (Company_Id, Filial_Id, Schedule_Id, Day_No, Begin_Time, End_Time)
      select Pm.Company_Id,
             Pm.Filial_Id,
             v_Schedule_Id,
             mod((Pm.Day_No - 1) + r.Schedule_Shift, r_Pattern.Count_Days) + 1,
             Pm.Begin_Time,
             Pm.End_Time
        from Htt_Schedule_Pattern_Marks Pm
       where Pm.Company_Id = v_New_Company_Id
         and Pm.Filial_Id = v_Filial_Id
         and Pm.Schedule_Id = r.New_Schedule_Id;
  
    g_Schedule_Cache(r.Old_Schedule_Id || ':' || r.Schedule_Shift) := v_Schedule_Id;
  end loop;

  Biruni_Route.Context_Begin;
  Client_Migr.Gen_Schedule_Days(i_New_Company_Id => v_New_Company_Id,
                                i_Year           => 2022,
                                i_Filial_Id      => v_Filial_Id);
  Biruni_Route.Context_End;

  Biruni_Route.Context_Begin;
  Client_Migr.Gen_Schedule_Days(i_New_Company_Id => v_New_Company_Id,
                                i_Year           => 2023,
                                i_Filial_Id      => v_Filial_Id);
  Biruni_Route.Context_End;

  Biruni_Route.Context_Begin;
  Migr_Schedule_Changes(i_Old_Company_Id => v_Old_Company_Id, --
                        i_New_Company_Id => v_New_Company_Id);
  Biruni_Route.Context_End;
end;
0
0
