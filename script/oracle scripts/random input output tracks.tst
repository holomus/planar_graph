PL/SQL Developer Test script 3.0
229
declare
  -- Local variables here
  c_Company_Id number := 0;
  c_Filial_Id  number := 106;

  c_Staff_Id_Start number := 804;
  c_Staff_Id_Stop  number := 809;

  c_Min_Date date := '01.01.2023';
  c_Max_Date date := '31.01.2023';

  v_Input_Datetime  date;
  v_Sec_Input       date;
  v_Output_Datetime date;
  v_Check_Datetime  date;
  v_Inputs          Array_Date;
  v_Sec_Inputs      Array_Date;
  v_Outputs         Array_Date;
  r_Track           Htt_Tracks%rowtype;

  v_Location_Ids Array_Number;
  v_Device_Ids   Array_Number;

  v_Track_Types Array_Varchar2 := Array_Varchar2(Htt_Pref.c_Track_Type_Check,
                                                 Htt_Pref.c_Track_Type_Input,
                                                 Htt_Pref.c_Track_Type_Output);

  v_Yes_No Array_Varchar2 := Array_Varchar2('Y', 'N');

  v_Track_Type varchar2(1);

  v_Cnt number;
begin
  -- Test statements here
  Biruni_Route.Context_Begin;

  Ui_Auth.Logon_As_System(c_Company_Id);

  Dbms_Random.Seed(198);

  select count(*)
    into v_Cnt
    from Href_Staffs s
   where s.Company_Id = c_Company_Id
     and s.Filial_Id = c_Filial_Id
     and s.Staff_Id between c_Staff_Id_Start and c_Staff_Id_Stop;

  with Test as
   (select c_Min_Date Min_Date, c_Max_Date Max_Date
      from Dual)
  select Min_Date + level - 1 New_Date
    bulk collect
    into v_Inputs
    from Test
  connect by level <= Max_Date - Min_Date;

  select Lf.Location_Id
    bulk collect
    into v_Location_Ids
    from Htt_Location_Filials Lf
   where Lf.Company_Id = c_Company_Id
     and Lf.Filial_Id = c_Filial_Id;

  select Lf.Device_Id
    bulk collect
    into v_Device_Ids
    from Htt_Devices Lf
   where Lf.Company_Id = c_Company_Id;

  /*  with Test as
   (select c_Min_Date Min_Date, c_Max_Date Max_Date
      from Dual)
  select Min_Date + level - 1 New_Date
    bulk collect
    into v_Sec_Inputs
    from Test
  connect by level <= Max_Date - Min_Date;
  
  with Test as
   (select c_Min_Date Min_Date, c_Max_Date Max_Date
      from Dual)
  select Min_Date + level - 1 New_Date
    bulk collect
    into v_Outputs
    from Test
  connect by level <= Max_Date - Min_Date;*/

  for r in (select s.*, Rownum Rn
              from Href_Staffs s
             where s.Company_Id = c_Company_Id
               and s.Filial_Id = c_Filial_Id
               and s.Staff_Id between c_Staff_Id_Start and c_Staff_Id_Stop)
  loop
    for i in 1 .. v_Inputs.Count
    loop
      begin
        v_Input_Datetime  := v_Inputs(i) + Dbms_Random.Value(0.3, 0.4);
        v_Sec_Input       := v_Inputs(i) + Dbms_Random.Value(0, 1);
        v_Output_Datetime := v_Inputs(i) + Dbms_Random.Value(0.7, 0.8);
      
        for k in 0 .. 23
        loop
          v_Check_Datetime := v_Inputs(i) + Numtodsinterval(k, 'hour') +
                              Numtodsinterval(Href_Util.Random_Integer(0, 59), 'minute');
        
          if Href_Util.Random_Integer(1, 4) = 1 then
            v_Track_Type := v_Track_Types(Href_Util.Random_Integer(1, 3));
          
            z_Htt_Tracks.Insert_One(i_Company_Id     => c_Company_Id,
                                    i_Filial_Id      => c_Filial_Id,
                                    i_Track_Id       => Htt_Next.Track_Id,
                                    i_Track_Date     => Trunc(v_Check_Datetime),
                                    i_Track_Time     => v_Check_Datetime,
                                    i_Track_Datetime => v_Check_Datetime,
                                    i_Person_Id      => r.Employee_Id,
                                    i_Track_Type     => v_Track_Type,
                                    i_Mark_Type      => Htt_Pref.c_Mark_Type_Manual,
                                    i_Device_Id      => v_Device_Ids(Href_Util.Random_Integer(1,
                                                                                              v_Device_Ids.Count)),
                                    i_Location_Id    => v_Location_Ids(Href_Util.Random_Integer(1,
                                                                                                v_Location_Ids.Count)),
                                    i_Latlng         => null,
                                    i_Accuracy       => null,
                                    i_Photo_Sha      => null,
                                    i_Note           => null,
                                    i_Original_Type  => v_Track_Type,
                                    i_Is_Valid       => 'Y',
                                    i_Status         => Htt_Pref.c_Track_Status_Draft,
                                    i_Trans_Input    => v_Yes_No(Href_Util.Random_Integer(1, 2)),
                                    i_Trans_Output   => v_Yes_No(Href_Util.Random_Integer(1, 2)));
          end if;
        end loop;
      
        /*if Dbms_Random.Random mod 2 = 0 then
          z_Htt_Tracks.Insert_One(i_Company_Id     => c_Company_Id,
                                  i_Filial_Id      => c_Filial_Id,
                                  i_Track_Id       => Htt_Next.Track_Id,
                                  i_Track_Date     => Trunc(v_Input_Datetime),
                                  i_Track_Time     => v_Input_Datetime,
                                  i_Track_Datetime => v_Input_Datetime,
                                  i_Person_Id      => r.Employee_Id,
                                  i_Track_Type     => Htt_Pref.c_Track_Type_Input,
                                  i_Mark_Type      => Htt_Pref.c_Mark_Type_Manual,
                                  i_Device_Id      => null,
                                  i_Location_Id    => null,
                                  i_Latlng         => null,
                                  i_Accuracy       => null,
                                  i_Photo_Sha      => null,
                                  i_Note           => null,
                                  i_Original_Type  => Htt_Pref.c_Track_Type_Input,
                                  i_Is_Valid       => 'Y',
                                  i_Status         => Htt_Pref.c_Track_Status_Draft);
        
          --Htt_Api.Track_Add(r_Track);
        end if;
        
        if Dbms_Random.Random mod 3 = 0 then
          z_Htt_Tracks.Insert_One(i_Company_Id     => c_Company_Id,
                                  i_Filial_Id      => c_Filial_Id,
                                  i_Track_Id       => Htt_Next.Track_Id,
                                  i_Track_Date     => Trunc(v_Sec_Input),
                                  i_Track_Time     => v_Sec_Input,
                                  i_Track_Datetime => v_Sec_Input,
                                  i_Person_Id      => r.Employee_Id,
                                  i_Track_Type     => Htt_Pref.c_Track_Type_Input,
                                  i_Mark_Type      => Htt_Pref.c_Mark_Type_Manual,
                                  i_Device_Id      => null,
                                  i_Location_Id    => null,
                                  i_Latlng         => null,
                                  i_Accuracy       => null,
                                  i_Photo_Sha      => null,
                                  i_Note           => null,
                                  i_Original_Type  => Htt_Pref.c_Track_Type_Input,
                                  i_Is_Valid       => 'Y',
                                  i_Status         => Htt_Pref.c_Track_Status_Draft);
        
          --Htt_Api.Track_Add(r_Track);
        end if;
        
        if Dbms_Random.Random mod 2 = 0 then
          z_Htt_Tracks.Insert_One(i_Company_Id     => c_Company_Id,
                                  i_Filial_Id      => c_Filial_Id,
                                  i_Track_Id       => Htt_Next.Track_Id,
                                  i_Track_Date     => Trunc(v_Output_Datetime),
                                  i_Track_Time     => v_Output_Datetime,
                                  i_Track_Datetime => v_Output_Datetime,
                                  i_Person_Id      => r.Employee_Id,
                                  i_Track_Type     => Htt_Pref.c_Track_Type_Output,
                                  i_Mark_Type      => Htt_Pref.c_Mark_Type_Manual,
                                  i_Device_Id      => null,
                                  i_Location_Id    => null,
                                  i_Latlng         => null,
                                  i_Accuracy       => null,
                                  i_Photo_Sha      => null,
                                  i_Note           => null,
                                  i_Original_Type  => Htt_Pref.c_Track_Type_Output,
                                  i_Is_Valid       => 'Y',
                                  i_Status         => Htt_Pref.c_Track_Status_Draft);
        
          --Htt_Api.Track_Add(r_Track);
        end if;*/
      exception
        when others then
          null;
      end;
    end loop;
  
    Dbms_Application_Info.Set_Module('inserting tracks', r.Rn || '/' || v_Cnt || ' persons');
  end loop;

  insert into Htt_Dirty_Timesheets
    (Company_Id, Filial_Id, Timesheet_Id, Locked)
    select p.Company_Id, p.Filial_Id, p.Timesheet_Id, 'N'
      from Htt_Timesheets p
     where p.Company_Id = c_Company_Id
       and p.Filial_Id = c_Filial_Id
       and p.Staff_Id between c_Staff_Id_Start and c_Staff_Id_Stop
       and p.Timesheet_Date between c_Min_Date and c_Max_Date;

  Htt_Core.Revised_Timesheets;

  Biruni_Route.Context_End;
  commit;
exception
  when others then
    Dbms_Output.Put_Line(Dbms_Utility.Format_Error_Stack());
    Dbms_Output.Put_Line(Dbms_Utility.Format_Error_Backtrace());
    rollback;
end;
0
2

r_Track.Track_Datetime
