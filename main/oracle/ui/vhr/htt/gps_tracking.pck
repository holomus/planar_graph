create or replace package Ui_Vhr635 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Jobs return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Location_Types return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Load_Employees(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Load_Tracks(p Hashmap) return Json_Object_t;
end Ui_Vhr635;
/
create or replace package body Ui_Vhr635 is
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
    return b.Translate('UI-VHR635:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
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
  Function Query_Location_Types return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('htt_location_types',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A'),
                    true);
  
    q.Number_Field('location_type_id');
    q.Varchar2_Field('name', 'color', 'code');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap is
    result Hashmap;
  begin
    result := Fazo.Zip_Map('date',
                           Trunc(sysdate),
                           'default_latlng',
                           Md_Pref.Filial_Default_Location(i_Company_Id => Ui.Company_Id,
                                                           i_Filial_Id  => Ui.Filial_Id));
  
    Result.Put('divisions', Fazo.Zip_Matrix(Uit_Hrm.Divisions));
    Result.Put('providers', Fazo.Zip_Matrix_Transposed(Htt_Util.Providers));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Employees(p Hashmap) return Hashmap is
    v_Date         date := Nvl(Trunc(p.o_Date('date')), Trunc(sysdate));
    v_Search       varchar2(1000) := p.o_Varchar2('search');
    v_Division_Ids Array_Number := Nvl(p.o_Array_Number('division_ids'), Array_Number());
    v_Job_Ids      Array_Number := Nvl(p.o_Array_Number('job_ids'), Array_Number());
    v_Matrix       Matrix_Varchar2;
    result         Hashmap := Hashmap();
  begin
    if v_Division_Ids.Count < 1 then
      v_Division_Ids := null;
    end if;
  
    if v_Job_Ids.Count < 1 then
      v_Job_Ids := null;
    end if;
  
    select Array_Varchar2(q.Employee_Id,
                          Np.Name,
                          Np.Gender,
                          Pd.Main_Phone,
                          s.Staff_Id,
                          s.Staff_Number,
                          s.Division_Id,
                          (select k.Name
                             from Mhr_Divisions k
                            where k.Company_Id = s.Company_Id
                              and k.Filial_Id = s.Filial_Id
                              and k.Division_Id = s.Division_Id),
                          s.Org_Unit_Id,
                          (select k.Name
                             from Mhr_Divisions k
                            where k.Company_Id = s.Company_Id
                              and k.Filial_Id = s.Filial_Id
                              and k.Division_Id = s.Org_Unit_Id),
                          s.Robot_Id,
                          (select k.Name
                             from Mrf_Robots k
                            where k.Company_Id = s.Company_Id
                              and k.Filial_Id = s.Filial_Id
                              and k.Robot_Id = s.Robot_Id),
                          s.Job_Id,
                          (select k.Name
                             from Mhr_Jobs k
                            where k.Company_Id = s.Company_Id
                              and k.Filial_Id = s.Filial_Id
                              and k.Job_Id = s.Job_Id),
                          s.Rank_Id,
                          (select k.Name
                             from Mhr_Ranks k
                            where k.Company_Id = s.Company_Id
                              and k.Filial_Id = s.Filial_Id
                              and k.Rank_Id = s.Rank_Id),
                          (select k.Photo_Sha
                             from Md_Persons k
                            where k.Company_Id = q.Company_Id
                              and k.Person_Id = q.Employee_Id))
      bulk collect
      into v_Matrix
      from Mhr_Employees q
      join Href_Staffs s
        on s.Company_Id = q.Company_Id
       and s.Filial_Id = q.Filial_Id
       and s.Employee_Id = q.Employee_Id
       and s.Hiring_Date <= v_Date
       and (s.Dismissal_Date is null or s.Dismissal_Date >= v_Date)
       and (v_Division_Ids is null or
           s.Division_Id in (select *
                                from table(v_Division_Ids)))
       and (v_Job_Ids is null or
           s.Job_Id in (select *
                           from table(v_Job_Ids)))
       and s.State = 'A'
      join Mr_Natural_Persons Np
        on Np.Company_Id = q.Company_Id
       and Np.Person_Id = q.Employee_Id
       and (v_Search is null or Lower(Np.Name) like '%' || Lower(v_Search) || '%')
      join Mr_Person_Details Pd
        on Pd.Company_Id = q.Company_Id
       and Pd.Person_Id = q.Employee_Id
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
     fetch first 300 Rows only;
  
    Result.Put('employees', Fazo.Zip_Matrix(v_Matrix));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Tracks(p Hashmap) return Json_Object_t is
    v_Date              date := Nvl(Trunc(p.o_Date('date')), Trunc(sysdate));
    v_Employee_Id       number := p.r_Number('employee_id');
    v_Staff_Id          number := p.r_Number('staff_id');
    v_Location_Type_Ids Array_Number := Nvl(p.o_Array_Number('location_type_ids'), Array_Number());
    r_Timesheet         Htt_Timesheets%rowtype;
    v_List              Glist;
    v_Data              Gmap;
    v_Vertices          Array_Varchar2;
    result              Gmap := Gmap;
  begin
    Uit_Href.Assert_Access_To_Employee(i_Employee_Id => v_Employee_Id);
  
    Result.Put('date', v_Date);
  
    --------------------------------------------------
    -- locations & polygons
    --------------------------------------------------
    if v_Location_Type_Ids.Count < 1 then
      v_Location_Type_Ids := null;
    end if;
  
    v_List := Glist;
  
    for r in (select t.Location_Id,
                     t.Name,
                     (select s.Name
                        from Md_Regions s
                       where s.Region_Id = t.Region_Id) Region_Name,
                     t.Address,
                     t.Latlng,
                     t.Accuracy,
                     (select w.Color
                        from Htt_Location_Types w
                       where w.Company_Id = t.Company_Id
                         and w.Location_Type_Id = t.Location_Type_Id) Color
                from Htt_Locations t
               where t.Company_Id = Ui.Company_Id
                 and (v_Location_Type_Ids is null or t.Location_Type_Id member of v_Location_Type_Ids)
                 and exists
               (select 1
                        from Htt_Location_Persons s
                       where s.Company_Id = Ui.Company_Id
                         and s.Filial_Id = Ui.Filial_Id
                         and s.Location_Id = t.Location_Id
                         and s.Person_Id = v_Employee_Id
                         and not exists (select 1
                                from Htt_Blocked_Person_Tracking Bp
                               where Bp.Company_Id = s.Company_Id
                                 and Bp.Filial_Id = s.Filial_Id
                                 and Bp.Employee_Id = s.Person_Id)))
    loop
      v_Data := Gmap;
    
      v_Data.Put('location_id', r.Location_Id);
      v_Data.Put('name', r.Name);
      v_Data.Put('region_name', r.Region_Name);
      v_Data.Put('address', r.Address);
      v_Data.Put('latlng', r.Latlng);
      v_Data.Put('accuracy', r.Accuracy);
      v_Data.Put('color', r.Color);
    
      select t.Latlng
        bulk collect
        into v_Vertices
        from Htt_Location_Polygon_Vertices t
       where t.Company_Id = Ui.Company_Id
         and t.Location_Id = r.Location_Id
       order by t.Order_No;
    
      v_Data.Put('polygon_vertices', v_Vertices);
    
      v_List.Push(v_Data.Val);
    end loop;
  
    Result.Put('locations', v_List);
  
    --------------------------------------------------
    -- timesheet
    --------------------------------------------------
    r_Timesheet := Htt_Util.Timesheet(i_Company_Id     => Ui.Company_Id,
                                      i_Filial_Id      => Ui.Filial_Id,
                                      i_Staff_Id       => v_Staff_Id,
                                      i_Timesheet_Date => v_Date);
  
    v_Data := Gmap;
  
    v_Data.Put('timesheet_id', r_Timesheet.Timesheet_Id);
    v_Data.Put('begin_time', r_Timesheet.Begin_Time);
    v_Data.Put('end_time', r_Timesheet.End_Time);
    v_Data.Put('break_enabled', r_Timesheet.Break_Enabled);
    v_Data.Put('break_begin_time', r_Timesheet.Break_Begin_Time);
    v_Data.Put('break_end_time', r_Timesheet.Break_End_Time);
  
    Result.Put('timesheet', v_Data);
  
    if r_Timesheet.Gps_Turnout_Enabled = 'Y' then
      Result.Put('gps_max_interval', r_Timesheet.Gps_Max_Interval);
    else
      Result.Put('gps_max_interval', 300); -- milliseconds
    end if;
  
    --------------------------------------------------
    -- tracks (input/output)
    --------------------------------------------------
    v_List := Glist;
  
    for r in (select t.*,
                     to_char(t.Track_Datetime, Href_Pref.c_Time_Format_Minute) Track_Time,
                     Htt_Util.t_Track_Type(t.Track_Type) Track_Type_Name,
                     (select q.Latlng
                        from Htt_Tracks q
                       where q.Company_Id = t.Company_Id
                         and q.Filial_Id = t.Filial_Id
                         and q.Track_Id = t.Track_Id) Latlng
                from Htt_Timesheet_Tracks t
               where t.Company_Id = Ui.Company_Id
                 and t.Filial_Id = Ui.Filial_Id
                 and t.Timesheet_Id = r_Timesheet.Timesheet_Id
                 and t.Track_Type <> Htt_Pref.c_Track_Type_Check
                 and t.Track_Used = 'Y')
    loop
      v_Data := Gmap;
    
      v_Data.Put('track_id', r.Track_Id);
      v_Data.Put('track_date', Trunc(r.Track_Datetime));
      v_Data.Put('track_time', r.Track_Time);
      v_Data.Put('track_type', r.Track_Type);
      v_Data.Put('track_type_name', r.Track_Type_Name);
      v_Data.Put('latlng', r.Latlng);
    
      v_List.Push(v_Data.Val);
    end loop;
  
    Result.Put('tracks', v_List);
  
    --------------------------------------------------
    if r_Timesheet.Day_Kind <> Htt_Pref.c_Day_Kind_Work then
      return Result.Val;
    end if;
  
    --------------------------------------------------
    -- gps tracks
    --------------------------------------------------
    v_List := Glist;
  
    for r in (select q.*,
                     (select w.Data
                        from Htt_Gps_Track_Datas w
                       where w.Company_Id = q.Company_Id
                         and w.Filial_Id = q.Filial_Id
                         and w.Track_Id = q.Track_Id) as Data
                from Htt_Gps_Tracks q
               where q.Company_Id = Ui.Company_Id
                 and q.Filial_Id = Ui.Filial_Id
                 and q.Person_Id = v_Employee_Id
                 and q.Track_Date = v_Date
               order by q.Track_Date)
    loop
      v_Data := Gmap;
    
      v_Data.Put('track_date', r.Track_Date);
      v_Data.Val.Put('data', r.Data);
    
      v_List.Push(v_Data.Val);
    end loop;
  
    Result.Put('gps_tracks', v_List);
  
    return Result.Val;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Mhr_Employees
       set Company_Id  = null,
           Filial_Id   = null,
           Employee_Id = null;
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null;
    update Href_Staffs
       set Company_Id     = null,
           Filial_Id      = null,
           Employee_Id    = null,
           Hiring_Date    = null,
           Dismissal_Date = null,
           Division_Id    = null,
           Org_Unit_Id    = null;
    update Htt_Location_Types
       set Company_Id       = null,
           Location_Type_Id = null,
           name             = null,
           State            = null,
           Code             = null;
    update Mhr_Employees
       set Company_Id  = null,
           Filial_Id   = null,
           Employee_Id = null;
    update Mhr_Jobs
       set Company_Id = null,
           Filial_Id  = null,
           Job_Id     = null,
           name       = null,
           State      = null;
  end;

end Ui_Vhr635;
/
