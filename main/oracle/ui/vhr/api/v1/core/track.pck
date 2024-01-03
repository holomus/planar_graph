create or replace package Ui_Vhr348 is
  ----------------------------------------------------------------------------------------------------
  Function List_Tracks(p Hashmap) return Json_Object_t;
end Ui_Vhr348;
/
create or replace package body Ui_Vhr348 is
  ----------------------------------------------------------------------------------------------------
  Function List_Tracks(p Hashmap) return Json_Object_t is
    v_Company_Id number := Ui.Company_Id;
    v_Filial_Id  number := Ui.Filial_Id;
  
    v_Start_Id number;
    v_Last_Id  number;
    v_Limit    number;
  
    v_Employee_Ids   Array_Number := Nvl(p.o_Array_Number('employee_ids'), Array_Number());
    v_Emp_Count      number := v_Employee_Ids.Count;
    v_Begin_Datetime date := p.r_Date('begin_datetime');
    v_End_Datetime   date := p.r_Date('end_datetime');
    v_Begin_Date     date := Trunc(v_Begin_Datetime);
    v_End_Date       date := Trunc(v_End_Datetime);
  
    v_Track  Gmap;
    v_Tracks Glist := Glist();
  begin
    Uit_Mx.Prepare_Fetch_Params(o_Start_Id  => v_Start_Id, --
                                o_Limit     => v_Limit,
                                i_Max_Limit => 1000);
  
    for c in (select *
                from (select s.Person_Id Employee_Id,
                             s.Location_Id,
                             Nvl((select Tps.Track_Type
                                   from (select Tt.Track_Type
                                           from Htt_Timesheet_Tracks Tt
                                          where Tt.Company_Id = s.Company_Id
                                            and Tt.Filial_Id = s.Filial_Id
                                            and Tt.Track_Id = s.Track_Id
                                          group by Tt.Track_Type) Tps
                                  order by Decode(Tps.Track_Type,
                                                  Htt_Pref.c_Track_Type_Input,
                                                  1,
                                                  Htt_Pref.c_Track_Type_Output,
                                                  2,
                                                  Htt_Pref.c_Track_Type_Merger,
                                                  3,
                                                  Htt_Pref.c_Track_Type_Potential_Output,
                                                  4,
                                                  5)
                                  fetch first row only),
                                 s.Original_Type) Track_Type,
                             s.Track_Datetime,
                             s.Track_Id,
                             s.Modified_On,
                             s.Company_Id,
                             s.Filial_Id,
                             s.Modified_Id,
                             (select q.Schedule_Id
                                from Href_Staffs g
                                join Htt_Timesheets q
                                  on q.Company_Id = s.Company_Id
                                 and q.Filial_Id = s.Filial_Id
                                 and q.Staff_Id = g.Staff_Id
                                 and q.Timesheet_Date = s.Track_Date
                               where g.Company_Id = v_Company_Id
                                 and g.Filial_Id = v_Filial_Id
                                 and g.Employee_Id = s.Person_Id
                                 and g.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
                                 and g.Hiring_Date <= v_End_Date
                                 and Nvl(g.Dismissal_Date, v_Begin_Date) >= v_Begin_Date
                                 and g.State = 'A') Schedule_Id
                        from Htt_Tracks s
                       where s.Company_Id = v_Company_Id
                         and s.Filial_Id = v_Filial_Id
                         and (v_Emp_Count = 0 or s.Person_Id member of v_Employee_Ids)
                         and s.Track_Datetime between v_Begin_Datetime and v_End_Datetime) Qr
               where Qr.Company_Id = v_Company_Id
                 and Qr.Filial_Id = v_Filial_Id
                 and Qr.Modified_Id > v_Start_Id
               order by Qr.Modified_Id
               fetch first v_Limit Rows only)
    loop
      v_Track := Gmap();
    
      v_Track.Put('track_id', c.Track_Id);
      v_Track.Put('schedule_id', c.Schedule_Id);
      v_Track.Put('employee_id', c.Employee_Id);
      v_Track.Put('location_id', c.Location_Id);
      v_Track.Put('track_type', c.Track_Type);
      v_Track.Put('track_datetime', c.Track_Datetime);
    
      v_Last_Id := c.Modified_Id;
    
      v_Tracks.Push(v_Track.Val);
    end loop;
  
    return Uit_Mx.Prepare_Api_Response(i_Result_List => v_Tracks, --
                                       i_Modified_Id => v_Last_Id);
  end;

end Ui_Vhr348;
/
