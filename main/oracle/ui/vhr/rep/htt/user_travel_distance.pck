create or replace package Ui_Vhr672 is
  ----------------------------------------------------------------------------------------------------
  Procedure Save_Preferences(p Hashmap);
  ----------------------------------------------------------------------------------------------------  
  Function Query_Jobs return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Employees(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Procedure Run(p Hashmap);
end Ui_Vhr672;
/
create or replace package body Ui_Vhr672 is
  ----------------------------------------------------------------------------------------------------
  g_Setting_Code Md_User_Settings.Setting_Code%type := 'UI_VHR672:SETTINGS';
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
    return b.Translate('UI-VHR672:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Preferences(p Hashmap) is
  begin
    Ui.User_Setting_Save(i_Setting_Code => g_Setting_Code, i_Setting_Value => p.Json());
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Preferences return Hashmap is
  begin
    return Fazo.Parse_Map(Ui.User_Setting_Load(i_Setting_Code  => g_Setting_Code,
                                               i_Default_Value => '{}'));
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Query_Jobs return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('mhr_jobs',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'state',
                                 'A'),
                    true);
  
    q.Number_Field('job_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Employees(p Hashmap) return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select q.employee_id,
                            (select w.name
                               from mr_natural_persons w
                              where w.company_id = q.company_id
                                and w.person_id = q.employee_id) as name,
                            w.employee_number
                       from href_staffs q
                       join mhr_employees w
                         on w.company_id = q.company_id 
                        and w.filial_id = :filial_id
                        and w.employee_id = q.employee_id
                        and w.state = :state
                      where q.company_id = :company_id
                        and q.filial_id = :filial_id
                        and q.staff_kind = :sk_primary
                        and q.state = :state
                        and q.hiring_date <= :end_date
                        and (q.dismissal_date is null or q.dismissal_date >= :begin_date)',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'sk_primary',
                                 Href_Pref.c_Staff_Kind_Primary,
                                 'begin_date',
                                 p.r_Date('begin_date'),
                                 'end_date',
                                 p.r_Date('end_date'),
                                 'state',
                                 'A'));
  
    q.Number_Field('employee_id');
    q.Varchar2_Field('name', 'employee_number');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Model return Hashmap is
    result Hashmap := Hashmap();
  begin
    Result.Put('divisions', Fazo.Zip_Matrix(Uit_Hrm.Divisions));
    Result.Put('begin_date', Trunc(sysdate, 'mon'));
    Result.Put('end_date', Trunc(sysdate));
    Result.Put('default_time_limit', Htt_Pref.c_Pref_Default_Gps_Time_Limit);
    Result.Put('default_distance_limit', Htt_Pref.c_Pref_Default_Gps_Distance_Limit);
    Result.Put('settings', Load_Preferences);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Merge_Distances
  (
    i_Distance_Groups   Htt_Pref.Gps_Distance_Group_Nt,
    i_Distance_Interval number
  ) return Htt_Pref.Gps_Distance_Group_Nt is
    v_Distance_Group Htt_Pref.Gps_Distance_Group_Rt;
    v_Group          Htt_Pref.Gps_Distance_Group_Rt;
    v_Merged_Group   Htt_Pref.Gps_Distance_Group_Rt;
  
    v_Temp_Groups     Htt_Pref.Gps_Distance_Group_Nt := Htt_Pref.Gps_Distance_Group_Nt();
    v_Distance_Groups Htt_Pref.Gps_Distance_Group_Nt := Htt_Pref.Gps_Distance_Group_Nt();
  
    --------------------------------------------------   
    Function Is_Nearby(i_Group Htt_Pref.Gps_Distance_Group_Rt) return boolean is
      v_f_Count Htt_Pref.Gps_Distance_Group_Rt;
    begin
      for i in 1 .. v_Temp_Groups.Count
      loop
        v_f_Count := v_Temp_Groups(i);
      
        if Htt_Geo_Util.Calc_Distance(i_Point1_Lat => v_f_Count.Lat,
                                      i_Point1_Lng => v_f_Count.Lng,
                                      i_Point2_Lat => i_Group.Lat,
                                      i_Point2_Lng => i_Group.Lng) < i_Distance_Interval then
          return true;
        end if;
      end loop;
    
      return false;
    end;
  
    --------------------------------------------------
    Function Merge_Group return Htt_Pref.Gps_Distance_Group_Rt is
      v_Lat_Summ number := 0;
      v_Lng_Summ number := 0;
    begin
      for i in 1 .. v_Temp_Groups.Count
      loop
        v_Lat_Summ := v_Lat_Summ + v_Temp_Groups(i).Lat;
        v_Lng_Summ := v_Lng_Summ + v_Temp_Groups(i).Lng;
      end loop;
    
      v_Merged_Group.Lat        := Round(v_Lat_Summ / v_Temp_Groups.Count, 18);
      v_Merged_Group.Lng        := Round(v_Lng_Summ / v_Temp_Groups.Count, 18);
      v_Merged_Group.Accuracy   := v_Temp_Groups(v_Temp_Groups.Count).Accuracy;
      v_Merged_Group.Track_Time := v_Temp_Groups(v_Temp_Groups.Count).Track_Time;
    
      return v_Merged_Group;
    end;
  begin
    v_Distance_Group.Lat        := i_Distance_Groups(1).Lat;
    v_Distance_Group.Lng        := i_Distance_Groups(1).Lng;
    v_Distance_Group.Accuracy   := i_Distance_Groups(1).Accuracy;
    v_Distance_Group.Track_Time := i_Distance_Groups(1).Track_Time;
  
    v_Temp_Groups.Extend;
    v_Temp_Groups(v_Temp_Groups.Count) := v_Distance_Group;
  
    for i in 2 .. i_Distance_Groups.Count
    loop
      v_Group := i_Distance_Groups(i);
    
      if v_Temp_Groups.Count = 0 then
        v_Temp_Groups.Extend;
        v_Temp_Groups(v_Temp_Groups.Count) := v_Group;
        continue;
      end if;
    
      if Is_Nearby(v_Group) then
        v_Temp_Groups.Extend;
        v_Temp_Groups(v_Temp_Groups.Count) := v_Group;
      else
        v_Distance_Groups.Extend;
        v_Distance_Groups(v_Distance_Groups.Count) := Merge_Group;
      
        v_Temp_Groups := Htt_Pref.Gps_Distance_Group_Nt();
      end if;
    end loop;
  
    if v_Temp_Groups.Count > 0 then
      v_Distance_Groups.Extend;
      v_Distance_Groups(v_Distance_Groups.Count) := Merge_Group;
    end if;
  
    return v_Distance_Groups;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Calc_Distances
  (
    i_Begin_Date            date,
    i_End_Date              date,
    i_Person_Id             number,
    i_Time_Interval         number,
    i_Distance_Interval     number,
    o_Total_Distance        out number,
    o_Own_Location_Distance out number,
    o_Own_Location_Names    out varchar2,
    o_Other_Distance        out number,
    o_Other_Location_Names  out varchar2
  ) return number is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
  
    v_All_Location_Ids        Array_Number;
    v_Use_Person_Location_Ids Array_Number := Array_Number();
    v_Use_Other_Location_Ids  Array_Number := Array_Number();
  
    v_Own_Distance     number := 0;
    v_Total_Distance   number := 0;
    v_Distance         number;
    v_Count            number := 1;
    v_Person_Locations Fazo.Number_Code_Aat;
    v_Time_Group_Count Fazo.Number_Code_Aat;
  
    v_Matrix     Matrix_Varchar2;
    v_1_Array    Array_Varchar2;
    v_2_Array    Array_Varchar2;
    v_Date_Array Array_Date;
  
    v_Time_Groups       Htt_Pref.Gps_Time_Group_Nt := Htt_Pref.Gps_Time_Group_Nt();
    v_Time_Group        Htt_Pref.Gps_Time_Group_Rt;
    v_1_Time_Group      Htt_Pref.Gps_Time_Group_Rt;
    v_2_Time_Group      Htt_Pref.Gps_Time_Group_Rt;
    v_Begin_Loop_Number number;
  
    v_Distance_Groups  Htt_Pref.Gps_Distance_Group_Nt := Htt_Pref.Gps_Distance_Group_Nt();
    v_Distance_Group   Htt_Pref.Gps_Distance_Group_Rt;
    v_1_Distance_Group Htt_Pref.Gps_Distance_Group_Rt;
    v_2_Distance_Group Htt_Pref.Gps_Distance_Group_Rt;
  
    v_Unit_Id number := 1;
  
    --------------------------------------------------      
    Function Unit_Next_Val return number is
    begin
      return v_Unit_Id + 1;
    end;
  
    --------------------------------------------------   
    Procedure Cache_Person_Locations is
    begin
      for r in (select q.Location_Id
                  from Htt_Location_Persons q
                 where q.Company_Id = v_Company_Id
                   and q.Filial_Id = v_Filial_Id
                   and q.Person_Id = i_Person_Id
                   and exists (select 1
                          from Htt_Location_Polygon_Vertices w
                         where w.Company_Id = v_Company_Id
                           and w.Location_Id = q.Location_Id)
                   and not exists (select 1
                          from Htt_Blocked_Person_Tracking Bp
                         where Bp.Company_Id = q.Company_Id
                           and Bp.Filial_Id = q.Filial_Id
                           and Bp.Employee_Id = q.Person_Id))
      loop
        v_Person_Locations(r.Location_Id) := r.Location_Id;
      end loop;
    end;
  
    --------------------------------------------------
    Function Check_Person_Location(i_Location_Id number) return boolean is
      v_Dummy number;
    begin
      v_Dummy := v_Person_Locations(i_Location_Id);
    
      return true;
    exception
      when No_Data_Found then
        return false;
    end;
  
    --------------------------------------------------   
    Procedure Calculate_Routes
    (
      i_Distance_Groups   Htt_Pref.Gps_Distance_Group_Nt,
      i_Distance_Interval number
    ) is
      v_Merged_Groups Htt_Pref.Gps_Distance_Group_Nt;
    begin
      v_Merged_Groups := Merge_Distances(i_Distance_Groups   => i_Distance_Groups,
                                         i_Distance_Interval => i_Distance_Interval);
    
      for i in 1 .. v_Merged_Groups.Count - 1
      loop
        v_1_Distance_Group := v_Distance_Groups(i);
        v_2_Distance_Group := v_Distance_Groups(i + 1);
      
        v_Distance := Htt_Geo_Util.Calc_Distance(i_Point1_Lat => v_1_Distance_Group.Lat,
                                                 i_Point1_Lng => v_1_Distance_Group.Lng,
                                                 i_Point2_Lat => v_2_Distance_Group.Lat,
                                                 i_Point2_Lng => v_2_Distance_Group.Lng);
      
        v_Total_Distance := v_Total_Distance + v_Distance;
      
        for j in 1 .. v_All_Location_Ids.Count
        loop
          if Htt_Geo_Util.Is_Point_In_Polygon(i_Company_Id  => v_Company_Id,
                                              i_Location_Id => v_All_Location_Ids(j),
                                              i_Point_Lat   => v_1_Distance_Group.Lat,
                                              i_Point_Lng   => v_1_Distance_Group.Lng) = 'Y' and
             Htt_Geo_Util.Is_Point_In_Polygon(i_Company_Id  => v_Company_Id,
                                              i_Location_Id => v_All_Location_Ids(j),
                                              i_Point_Lat   => v_2_Distance_Group.Lat,
                                              i_Point_Lng   => v_2_Distance_Group.Lng) = 'Y' then
          
            if Check_Person_Location(v_All_Location_Ids(j)) then
              v_Own_Distance := v_Own_Distance + v_Distance;
            
              v_Use_Person_Location_Ids.Extend();
              v_Use_Person_Location_Ids(v_Use_Person_Location_Ids.Count) := v_All_Location_Ids(j);
            else
              v_Use_Other_Location_Ids.Extend;
              v_Use_Other_Location_Ids(v_Use_Other_Location_Ids.Count) := v_All_Location_Ids(j);
            end if;
          
            exit;
          end if;
        end loop;
      end loop;
    end;
  begin
    Cache_Person_Locations;
  
    select q.Location_Id
      bulk collect
      into v_All_Location_Ids
      from Htt_Locations q
     where q.Company_Id = v_Company_Id
       and exists (select 1
              from Htt_Location_Filials w
             where w.Company_Id = v_Company_Id
               and w.Filial_Id = v_Filial_Id
               and w.Location_Id = q.Location_Id)
       and exists (select 1
              from Htt_Location_Polygon_Vertices r
             where r.Company_Id = v_Company_Id
               and r.Location_Id = q.Location_Id);
  
    -- Load all GPS Datas
    select Array_Varchar2(q.Lat, q.Lng, q.Accuracy), q.Track_Time
      bulk collect
      into v_Matrix, v_Date_Array
      from (Htt_Util.Gps_Track_Datas(i_Company_Id => v_Company_Id,
                                     i_Filial_Id  => v_Filial_Id,
                                     i_Person_Id  => i_Person_Id,
                                     i_Begin_Date => i_Begin_Date,
                                     i_End_Date   => i_End_Date)) q
     order by q.Track_Time;
  
    if v_Matrix.Count = 0 then
      return null;
    end if;
  
    -- seperate to time groups
    -- set 1-info
    v_Time_Group.Unit_Number := v_Unit_Id;
    v_Time_Group.Lat         := v_Matrix(1) (1);
    v_Time_Group.Lng         := v_Matrix(1) (2);
    v_Time_Group.Accuracy    := v_Matrix(1) (3);
    v_Time_Group.Track_Time  := v_Date_Array(1);
  
    v_Time_Groups.Extend;
    v_Time_Groups(v_Time_Groups.Count) := v_Time_Group;
    v_Time_Group_Count(v_Unit_Id) := v_Count;
  
    for i in 1 .. v_Matrix.Count - 1
    loop
      v_1_Array := v_Matrix(i);
      v_2_Array := v_Matrix(i + 1);
    
      if Htt_Util.Time_Diff(i_Time1 => v_Date_Array(i + 1), i_Time2 => v_Date_Array(i)) >
         i_Time_Interval then
        v_Unit_Id := Unit_Next_Val;
        v_Count   := 1;
      end if;
    
      v_Time_Group.Unit_Number := v_Unit_Id;
      v_Time_Group.Lat         := v_2_Array(1);
      v_Time_Group.Lng         := v_2_Array(2);
      v_Time_Group.Accuracy    := v_2_Array(3);
      v_Time_Group.Track_Time  := v_Date_Array(i + 1);
    
      v_Time_Groups.Extend;
      v_Time_Groups(v_Time_Groups.Count) := v_Time_Group;
    
      v_Count := v_Count + 1;
      v_Time_Group_Count(v_Unit_Id) := v_Count;
    end loop;
    -- end seperate time groups
  
    -- seperate distance groups
    -- set first data 
    for i in 1 .. v_Time_Groups.Count
    loop
      if v_Time_Group_Count(v_Time_Groups(i).Unit_Number) > 1 then
        v_Begin_Loop_Number := i;
        exit;
      end if;
    end loop;
  
    if v_Begin_Loop_Number is null then
      return null;
    end if;
  
    v_Distance_Group.Lat        := v_Time_Groups(v_Begin_Loop_Number).Lat;
    v_Distance_Group.Lng        := v_Time_Groups(v_Begin_Loop_Number).Lng;
    v_Distance_Group.Accuracy   := v_Time_Groups(v_Begin_Loop_Number).Accuracy;
    v_Distance_Group.Track_Time := v_Time_Groups(v_Begin_Loop_Number).Track_Time;
  
    v_Distance_Groups.Extend;
    v_Distance_Groups(v_Distance_Groups.Count) := v_Distance_Group;
  
    for i in v_Begin_Loop_Number .. v_Time_Groups.Count - 1
    loop
      v_1_Time_Group := v_Time_Groups(i);
      v_2_Time_Group := v_Time_Groups(i + 1);
    
      v_Distance_Group.Lat        := v_2_Time_Group.Lat;
      v_Distance_Group.Lng        := v_2_Time_Group.Lng;
      v_Distance_Group.Accuracy   := v_2_Time_Group.Accuracy;
      v_Distance_Group.Track_Time := v_2_Time_Group.Track_Time;
    
      if v_1_Time_Group.Unit_Number = v_2_Time_Group.Unit_Number then
        v_Distance_Groups.Extend;
        v_Distance_Groups(v_Distance_Groups.Count) := v_Distance_Group;
      else
        -- Calculate        
        Calculate_Routes(i_Distance_Groups   => v_Distance_Groups,
                         i_Distance_Interval => i_Distance_Interval);
      
        v_Distance_Groups := Htt_Pref.Gps_Distance_Group_Nt();
        v_Distance_Groups.Extend;
        v_Distance_Groups(v_Distance_Groups.Count) := v_Distance_Group;
      
      end if;
    end loop;
  
    if v_Distance_Groups.Count > 0 then
      -- Calculate
      Calculate_Routes(i_Distance_Groups   => v_Distance_Groups,
                       i_Distance_Interval => i_Distance_Interval);
    end if;
  
    -- set results
    o_Own_Location_Distance := v_Own_Distance;
    o_Other_Distance        := v_Total_Distance - v_Own_Distance;
    o_Total_Distance        := v_Total_Distance;
  
    select Listagg(q.Name, ', ')
      into o_Own_Location_Names
      from Htt_Locations q
     where q.Company_Id = v_Company_Id
       and q.Location_Id in (select distinct Column_Value
                               from table(v_Use_Person_Location_Ids));
  
    select Listagg(q.Name, ', ')
      into o_Other_Location_Names
      from Htt_Locations q
     where q.Company_Id = v_Company_Id
       and q.Location_Id in (select distinct Column_Value
                               from table(v_Use_Other_Location_Ids));
  
    return 1;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Run_Gps_Distance
  (
    i_Begin_Date   date,
    i_End_Date     date,
    i_Division_Ids Array_Number,
    i_Job_Ids      Array_Number,
    i_Employee_Ids Array_Number
  ) is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
  
    v_Settings             Hashmap := Load_Preferences;
    v_Show_Employee_Number boolean := Nvl(v_Settings.o_Varchar2('employee_number'), 'N') = 'Y';
    v_Show_Division        boolean := Nvl(v_Settings.o_Varchar2('division'), 'N') = 'Y';
    v_Show_Job             boolean := Nvl(v_Settings.o_Varchar2('job'), 'N') = 'Y';
    v_Show_Rank            boolean := Nvl(v_Settings.o_Varchar2('rank'), 'N') = 'Y';
    v_Show_Manager         boolean := Nvl(v_Settings.o_Varchar2('manager'), 'N') = 'Y';
  
    v_Division_Names Array_Varchar2;
    v_Job_Names      Array_Varchar2;
    v_Nls_Language   varchar2(100) := Uit_Href.Get_Nls_Language;
  
    v_Division_Count number := i_Division_Ids.Count;
    v_Job_Count      number := i_Job_Ids.Count;
    v_Employee_Count number := i_Employee_Ids.Count;
  
    v_Total_Distance        number;
    v_Own_Location_Distance number;
    v_Own_Location_Names    varchar2(4000);
    v_Other_Distance        number;
    v_Other_Location_Names  varchar2(4000);
  
    v_Column number := 1;
    v_Dummy  number;
  
    a b_Table := b_Report.New_Table();
  
    --------------------------------------------------
    Procedure Print_Header
    (
      i_Name         varchar2,
      i_Colspan      number,
      i_Rowspan      number,
      i_Column_Width number
    ) is
    begin
      a.Data(i_Name, i_Colspan => i_Colspan, i_Rowspan => i_Rowspan);
      for i in 1 .. i_Colspan
      loop
        a.Column_Width(v_Column, i_Column_Width);
        v_Column := v_Column + 1;
      end loop;
    end;
  
    --------------------------------------------------
    Procedure Print_Info is
    begin
      a.Current_Style('root bold');
    
      a.New_Row;
      if i_Division_Ids.Count > 0 then
        a.New_Row;
      
        select d.Name
          bulk collect
          into v_Division_Names
          from Mhr_Divisions d
         where d.Company_Id = v_Company_Id
           and d.Filial_Id = v_Filial_Id
           and d.Division_Id member of i_Division_Ids;
      
        a.Data(t('division: $1', Fazo.Gather(v_Division_Names, ', ')), i_Colspan => 5);
      end if;
    
      if i_Job_Ids.Count > 0 then
        a.New_Row;
      
        select d.Name
          bulk collect
          into v_Job_Names
          from Mhr_Jobs d
         where d.Company_Id = v_Company_Id
           and d.Filial_Id = v_Filial_Id
           and d.Job_Id member of i_Job_Ids;
      
        a.Data(t('job: $1', Fazo.Gather(v_Job_Names, ', ')), i_Colspan => 5);
      end if;
    
      a.New_Row;
      a.Data(t('date: from $1 to $2', --
               to_char(i_Begin_Date, 'dd mon yyyy', v_Nls_Language),
               to_char(i_End_Date, 'dd mon yyyy', v_Nls_Language)),
             i_Colspan => 5);
    end;
  
    --------------------------------------------------
    Procedure Print_Header is
    begin
      a.Current_Style('header');
    
      a.New_Row;
      a.New_Row;
      Print_Header(t('rownum'), 1, 1, 50);
    
      Print_Header(t('employee_name'), 1, 1, 250);
    
      if v_Show_Employee_Number then
        Print_Header(t('employee number'), 1, 1, 100);
      end if;
    
      if v_Show_Division then
        Print_Header(t('division'), 1, 1, 150);
      end if;
    
      if v_Show_Job then
        Print_Header(t('job'), 1, 1, 150);
      end if;
    
      if v_Show_Rank then
        Print_Header(t('rank'), 1, 1, 150);
      end if;
    
      if v_Show_Manager then
        Print_Header(t('manager'), 1, 1, 150);
      end if;
    
      Print_Header(t('all distance'), 1, 1, 100);
    
      Print_Header(t('in own locations'), 1, 1, 100);
    
      Print_Header(t('own location names'), 1, 1, 200);
    
      Print_Header(t('in other locations'), 1, 1, 100);
    
      Print_Header(t('other location names'), 1, 1, 200);
    end;
  begin
    Print_Info;
  
    Print_Header;
  
    a.Current_Style('body_centralized');
  
    -- print Body
    for r in (select Rownum,
                     q.Company_Id,
                     q.Filial_Id,
                     q.Division_Id,
                     q.Job_Id,
                     q.Rank_Id,
                     q.Staff_Id,
                     q.Employee_Id,
                     (select w.Name
                        from Mr_Natural_Persons w
                       where w.Company_Id = q.Company_Id
                         and w.Person_Id = q.Employee_Id) as Employee_Name
                from Href_Staffs q
               where q.Company_Id = v_Company_Id
                 and q.Filial_Id = v_Filial_Id
                 and q.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
                 and (v_Division_Count = 0 or
                     q.Division_Id in (select Column_Value
                                          from table(i_Division_Ids)))
                 and (v_Job_Count = 0 or
                     q.Job_Id in (select Column_Value
                                     from table(i_Job_Ids)))
                 and (v_Employee_Count = 0 or
                     q.Employee_Id in (select Column_Value
                                          from table(i_Employee_Ids)))
                 and q.Hiring_Date <= i_End_Date
                 and (q.Dismissal_Date is null or q.Dismissal_Date >= i_End_Date)
                 and q.State = 'A'
                 and exists (select 1
                        from Mhr_Employees w
                       where w.Company_Id = v_Company_Id
                         and w.Filial_Id = v_Filial_Id
                         and w.Employee_Id = q.Employee_Id
                         and w.State = 'A'))
    loop
      v_Total_Distance := 0;
    
      a.New_Row;
      a.Data(r.Rownum);
      a.Data(r.Employee_Name);
    
      if v_Show_Employee_Number then
        a.Data(z_Mhr_Employees.Load(i_Company_Id => r.Company_Id, i_Filial_Id => r.Filial_Id, i_Employee_Id => r.Employee_Id).Employee_Number);
      end if;
    
      if v_Show_Division then
        a.Data(z_Mhr_Divisions.Load(i_Company_Id => r.Company_Id, i_Filial_Id => r.Filial_Id, i_Division_Id => r.Division_Id).Name);
      end if;
    
      if v_Show_Job then
        a.Data(z_Mhr_Jobs.Load(i_Company_Id => r.Company_Id, i_Filial_Id => r.Filial_Id, i_Job_Id => r.Job_Id).Name);
      end if;
    
      if v_Show_Rank then
        a.Data(z_Mhr_Ranks.Take(i_Company_Id => r.Company_Id, i_Filial_Id => r.Filial_Id, i_Rank_Id => r.Rank_Id).Name);
      end if;
    
      if v_Show_Manager then
        a.Data(Href_Util.Get_Manager_Name(i_Company_Id => r.Company_Id,
                                          i_Filial_Id  => r.Filial_Id,
                                          i_Staff_Id   => r.Staff_Id));
      end if;
    
      v_Dummy := Calc_Distances(i_Begin_Date            => i_Begin_Date,
                                i_End_Date              => i_End_Date,
                                i_Person_Id             => r.Employee_Id,
                                i_Time_Interval         => Nvl(v_Settings.o_Number('time_interval'),
                                                               Htt_Pref.c_Pref_Default_Gps_Time_Limit),
                                i_Distance_Interval     => Nvl(v_Settings.o_Number('distance_interval'),
                                                               Htt_Pref.c_Pref_Default_Gps_Distance_Limit),
                                o_Total_Distance        => v_Total_Distance,
                                o_Own_Location_Distance => v_Own_Location_Distance,
                                o_Own_Location_Names    => v_Own_Location_Names,
                                o_Other_Distance        => v_Other_Distance,
                                o_Other_Location_Names  => v_Other_Location_Names);
    
      if v_Dummy is null then
        a.Data(0);
        a.Data(0);
        a.Data();
        a.Data(0);
        a.Data();
      else
        a.Data(Round(v_Total_Distance / 1000, 2));
        a.Data(Round(v_Own_Location_Distance / 1000, 2));
        a.Data(v_Own_Location_Names);
        a.Data(Round(v_Other_Distance / 1000, 2));
      
        if v_Other_Distance > 0 then
          if v_Other_Location_Names is not null then
            a.Data(v_Other_Location_Names || ' ' || t('and others'));
          else
            a.Data(t('others'));
          end if;
        else
          a.Data();
        end if;
      end if;
    
    end loop;
  
    b_Report.Add_Sheet(i_Name => Ui.Current_Form_Name, p_Table => a);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Run(p Hashmap) is
  begin
    b_Report.Open_Book_With_Styles(i_Report_Type => p.o_Varchar2('rt'),
                                   i_File_Name   => Ui.Current_Form_Name);
  
    -- style body centralized
    b_Report.New_Style(i_Style_Name        => 'body_centralized',
                       i_Parent_Style_Name => 'body',
                       i_Horizontal_Align  => b_Report.a_Center,
                       i_Vertical_Align    => b_Report.a_Middle);
  
    Run_Gps_Distance(i_Begin_Date   => p.r_Date('begin_date'),
                     i_End_Date     => p.r_Date('end_date'),
                     i_Division_Ids => Nvl(p.o_Array_Number('division_ids'), Array_Number()),
                     i_Job_Ids      => Nvl(p.o_Array_Number('job_ids'), Array_Number()),
                     i_Employee_Ids => Nvl(p.o_Array_Number('employee_ids'), Array_Number()));
  
    b_Report.Close_Book();
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Validation is
  begin
    update Mhr_Jobs
       set Company_Id = null,
           Job_Id     = null,
           Filial_Id  = null,
           name       = null,
           State      = null;
    update Href_Staffs
       set Company_Id     = null,
           Filial_Id      = null,
           Staff_Id       = null,
           Staff_Kind     = null,
           Employee_Id    = null,
           Hiring_Date    = null,
           Dismissal_Date = null,
           State          = null;
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null;
    update Mhr_Employees
       set Company_Id      = null,
           Filial_Id       = null,
           Employee_Id     = null,
           Employee_Number = null;
  end;

end Ui_Vhr672;
/
