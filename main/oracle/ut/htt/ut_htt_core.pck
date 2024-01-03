create or replace package Ut_Htt_Core is
  --%suite(htt_core)
  --%suitepath(vhr.htt.htt_core)
  --%beforeall(ut_vhr_util.create_filial)
  --%beforeeach(ut_vhr_util.context_begin)
  --%aftereach(biruni_route.context_end)

  --%context(transform track types)
  --%beforeall(create_basic_staff, create_device, create_timesheet, create_tracks)

  --%context(third track datetime 19:00)

  --%test(transform_check_check_check)
  Procedure Transform_Check_Check_Check;

  --%test(transform_check_check_output)
  --%beforetest(update_check_check_output)
  Procedure Transform_Check_Check_Output;

  --%test(transform_input_check_check)
  --%beforetest(update_input_check_check)
  Procedure Transform_Input_Check_Check;

  --%test(transform_check_input_output)
  --%beforetest(update_check_input_output)
  Procedure Transform_Check_Input_Output;

  --%test(transform_input_output_check)
  --%beforetest(update_input_output_check)
  Procedure Transform_Input_Output_Check;

  --%test(transform_input_output_changed_check)
  --%beforetest(update_input_output_changed_check)
  Procedure Transform_Input_Output_Changed_Check;

  --%test(transform_check_input_changed_output)
  --%beforetest(update_check_input_changed_output)
  Procedure Transform_Check_Input_Changed_Output;

  --%test(transform_input_output_changed_output)
  --%beforetest(update_input_output_changed_output)
  Procedure Transform_Input_Output_Changed_Output;

  --%test(transform_input_input_changed_output)
  --%beforetest(update_input_input_changed_output)
  Procedure Transform_Input_Input_Changed_Output;

  --%endcontext

  --%context(third track datetime 17:00)
  --%beforeall(update_third_track_datetime, update_first_track_type)

  --%test(transform_input_check_check_secondary)
  Procedure Transform_Input_Check_Check_Secondary;

  --%test(transform_input_output_check_secondary)
  --%beforetest(update_input_output_check_secondary)
  Procedure Transform_Input_Output_Check_Secondary;

  --%test(transform_input_check_potential_check_secondary)
  --%beforetest(update_input_check_potential_check_secondary)
  Procedure Transform_Input_Check_Potential_Check_Secondary;

  --%test(transform_input_check_potential_output_secondary)
  --%beforetest(update_input_check_potential_output_secondary)
  Procedure Transform_Input_Check_Potential_Output_Secondary;

  --%endcontext

  --%context(device authogen turned off)

  --%test(transform_device_no_autogen_inputs)
  --%beforetest(update_device_no_autogen_inputs)
  Procedure Transform_Device_No_Autogen_Inputs;

  --%test(transform_device_no_autogen_outputs)
  --%beforetest(update_device_no_autogen_outputs)
  Procedure Transform_Device_No_Autogen_Outputs;

  --%test(transform_device_no_autogen)
  --%beforetest(update_device_no_autogen_inputs, update_device_no_autogen_outputs)
  Procedure Transform_Device_No_Autogen;

  --%endcontext

  --%test(transform_check_check_check_potential)
  --%beforetest(update_check_check_check_potential)
  Procedure Transform_Check_Check_Check_Potential;

  --%endcontext

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Basic_Staff;
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Timesheet;
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Device;
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Tracks;
  ----------------------------------------------------------------------------------------------------
  Procedure Update_Third_Track_Datetime;
  ----------------------------------------------------------------------------------------------------
  Procedure Update_First_Track_Type;
  ----------------------------------------------------------------------------------------------------
  Procedure Update_Check_Check_Output;
  ----------------------------------------------------------------------------------------------------
  Procedure Update_Input_Check_Check;
  ----------------------------------------------------------------------------------------------------
  Procedure Update_Check_Input_Output;
  ----------------------------------------------------------------------------------------------------
  Procedure Update_Input_Output_Check;
  ----------------------------------------------------------------------------------------------------
  Procedure Update_Input_Output_Changed_Check;
  ----------------------------------------------------------------------------------------------------
  Procedure Update_Check_Input_Changed_Output;
  ----------------------------------------------------------------------------------------------------
  Procedure Update_Input_Output_Changed_Output;
  ----------------------------------------------------------------------------------------------------
  Procedure Update_Input_Input_Changed_Output;
  ----------------------------------------------------------------------------------------------------
  Procedure Update_Input_Output_Check_Secondary;
  ----------------------------------------------------------------------------------------------------
  Procedure Update_Input_Check_Potential_Check_Secondary;
  ----------------------------------------------------------------------------------------------------
  Procedure Update_Input_Check_Potential_Output_Secondary;
  ----------------------------------------------------------------------------------------------------
  Procedure Update_Device_No_Autogen_Inputs;
  ----------------------------------------------------------------------------------------------------
  Procedure Update_Device_No_Autogen_Outputs;
  ----------------------------------------------------------------------------------------------------
  Procedure Update_Check_Check_Check_Potential;
end Ut_Htt_Core;
/
create or replace package body Ut_Htt_Core is
  ----------------------------------------------------------------------------------------------------
  type Timesheet_Tracks_Rt is record(
    First_Track  number,
    Second_Track number,
    Third_Track  number);

  ----------------------------------------------------------------------------------------------------
  -- all default time valus are in second
  ---------------------------------------------------------------------------------------------------- 
  c_Default_Begin_Time            constant number := 32400;
  c_Default_End_Time              constant number := 64800;
  c_Default_Break_Begin_Time      constant number := 46800;
  c_Default_Break_End_Time        constant number := 50400;
  c_Default_Plan_Time             constant number := 28800;
  c_Default_Input_Time            constant number := 32400;
  c_Default_Second_Track_Time     constant number := 43200;
  c_Default_Output_Time           constant number := 68400;
  c_Default_Secondary_Output_Time constant number := 61200;
  ---------------------------------------------------------------------------------------------------- 
  g_Staff        Href_Staffs%rowtype;
  g_Timesheet_Id number;
  g_Device_Id    number;
  g_Tracks       Timesheet_Tracks_Rt;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Basic_Staff is
  begin
    g_Staff.Staff_Id := Ut_Vhr_Util.Create_Staff_With_Basic_Data(i_Company_Id => Ui.Company_Id,
                                                                 i_Filial_Id  => Ui.Filial_Id);
  
    g_Staff := z_Href_Staffs.Load(i_Company_Id => Ui.Company_Id,
                                  i_Filial_Id  => Ui.Filial_Id,
                                  i_Staff_Id   => g_Staff.Staff_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Timesheet is
    v_Curr_Date        date := Trunc(sysdate);
    v_Begin_Time       date;
    v_End_Time         date;
    v_Break_Begin_Time date;
    v_Break_End_Time   date;
  begin
    g_Timesheet_Id := Htt_Next.Timesheet_Id;
  
    v_Begin_Time       := v_Curr_Date + Numtodsinterval(c_Default_Begin_Time, 'second');
    v_End_Time         := v_Curr_Date + Numtodsinterval(c_Default_End_Time, 'second');
    v_Break_Begin_Time := v_Curr_Date + Numtodsinterval(c_Default_Break_Begin_Time, 'second');
    v_Break_End_Time   := v_Curr_Date + Numtodsinterval(c_Default_Break_End_Time, 'second');
  
    z_Htt_Timesheets.Insert_One(i_Company_Id       => g_Staff.Company_Id,
                                i_Filial_Id        => g_Staff.Filial_Id,
                                i_Timesheet_Id     => g_Timesheet_Id,
                                i_Timesheet_Date   => v_Curr_Date,
                                i_Staff_Id         => g_Staff.Staff_Id,
                                i_Employee_Id      => g_Staff.Employee_Id,
                                i_Schedule_Id      => g_Staff.Schedule_Id,
                                i_Calendar_Id      => null,
                                i_Day_Kind         => Htt_Pref.c_Day_Kind_Work,
                                i_Track_Duration   => 86400,
                                i_Count_Late       => 'Y',
                                i_Count_Early      => 'Y',
                                i_Count_Lack       => 'Y',
                                i_Shift_Begin_Time => v_Curr_Date,
                                i_Shift_End_Time   => v_Curr_Date + 1,
                                i_Input_Border     => v_Curr_Date,
                                i_Output_Border    => v_Curr_Date + 1,
                                i_Begin_Time       => v_Begin_Time,
                                i_End_Time         => v_End_Time,
                                i_Break_Enabled    => 'Y',
                                i_Break_Begin_Time => v_Break_Begin_Time,
                                i_Break_End_Time   => v_Break_End_Time,
                                i_Plan_Time        => c_Default_Plan_Time,
                                i_Full_Time        => c_Default_Plan_Time,
                                i_Input_Time       => null,
                                i_Output_Time      => null,
                                i_Planned_Marks    => 0,
                                i_Done_Marks       => 0);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Device is
  begin
    g_Device_Id := Htt_Next.Device_Id;
  
    z_Htt_Devices.Insert_One(i_Company_Id      => Ui.Company_Id,
                             i_Device_Id       => g_Device_Id,
                             i_Name            => 'test device',
                             i_Device_Type_Id  => Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Hikvision),
                             i_Serial_Number   => 'test serial number',
                             i_Model_Id        => null,
                             i_Location_Id     => null,
                             i_Track_Types     => null,
                             i_Mark_Types      => null,
                             i_Emotion_Types   => null,
                             i_Lang_Code       => null,
                             i_Use_Settings    => 'Y',
                             i_Last_Seen_On    => null,
                             i_Host            => null,
                             i_Login           => null,
                             i_Password        => null,
                             i_State           => 'A',
                             i_Autogen_Inputs  => 'Y',
                             i_Autogen_Outputs => 'Y');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Tracks is
    v_Curr_Date date := Trunc(sysdate);
  
    v_Track_Id       number;
    v_Track_Datetime date;
  begin
    for i in 1 .. 3
    loop
      v_Track_Id := Htt_Next.Track_Id;
    
      if i = 1 then
        v_Track_Datetime := v_Curr_Date + Numtodsinterval(c_Default_Input_Time, 'second');
      
        g_Tracks.First_Track := v_Track_Id;
      elsif i = 2 then
        v_Track_Datetime := v_Curr_Date + Numtodsinterval(c_Default_Second_Track_Time, 'second');
      
        g_Tracks.Second_Track := v_Track_Id;
      else
        v_Track_Datetime := v_Curr_Date + Numtodsinterval(c_Default_Output_Time, 'second');
      
        g_Tracks.Third_Track := v_Track_Id;
      end if;
    
      z_Htt_Tracks.Insert_One(i_Company_Id     => Ui.Company_Id,
                              i_Filial_Id      => Ui.Filial_Id,
                              i_Track_Id       => v_Track_Id,
                              i_Track_Date     => v_Curr_Date,
                              i_Track_Time     => v_Track_Datetime,
                              i_Track_Datetime => v_Track_Datetime,
                              i_Person_Id      => g_Staff.Employee_Id,
                              i_Track_Type     => Htt_Pref.c_Track_Type_Check,
                              i_Mark_Type      => Htt_Pref.c_Mark_Type_Manual,
                              i_Device_Id      => g_Device_Id,
                              i_Location_Id    => null,
                              i_Latlng         => null,
                              i_Accuracy       => null,
                              i_Photo_Sha      => null,
                              i_Note           => null,
                              i_Is_Valid       => 'Y',
                              i_Status         => Htt_Pref.c_Track_Status_Draft,
                              i_Original_Type  => Htt_Pref.c_Track_Type_Check);
    
      z_Htt_Timesheet_Tracks.Insert_One(i_Company_Id     => Ui.Company_Id,
                                        i_Filial_Id      => Ui.Filial_Id,
                                        i_Timesheet_Id   => g_Timesheet_Id,
                                        i_Track_Id       => v_Track_Id,
                                        i_Track_Datetime => v_Track_Datetime,
                                        i_Track_Type     => Htt_Pref.c_Track_Type_Check,
                                        i_Track_Used     => 'Y');
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Transform
  (
    i_First_Type       varchar2,
    i_First_Changed    boolean,
    i_First_Potential  boolean,
    i_Second_Type      varchar2,
    i_Second_Changed   boolean,
    i_Second_Potential boolean,
    i_Third_Type       varchar2,
    i_Third_Changed    boolean,
    i_Third_Potential  boolean
  ) is
  
    --------------------------------------------------
    Procedure Assert_Track
    (
      i_Track_Id      number,
      i_Track_Type    varchar2,
      i_Track_Changed boolean,
      i_Is_Potential  boolean
    ) is
      r_Track Htt_Tracks%rowtype;
    
      -------------------------------------------------- 
      Function Is_Potential return boolean is
        v_Dummy varchar2(1);
      begin
        select 'x'
          into v_Dummy
          from Htt_Potential_Outputs Pt
         where Pt.Company_Id = Ui.Company_Id
           and Pt.Filial_Id = Ui.Filial_Id
           and Pt.Track_Id = i_Track_Id
           and Rownum = 1;
      
        return true;
      exception
        when No_Data_Found then
          return false;
      end;
    
      -------------------------------------------------- 
      Procedure Assert_Timesheet_Track_Type is
      begin
        for r in (select Tt.Track_Type
                    from Htt_Timesheet_Tracks Tt
                   where Tt.Company_Id = Ui.Company_Id
                     and Tt.Filial_Id = Ui.Filial_Id
                     and Tt.Track_Id = i_Track_Id)
        loop
          Ut.Expect(r.Track_Type).To_Equal(i_Track_Type);
        end loop;
      end;
    begin
      Ut.Expect(z_Htt_Tracks.Exist(i_Company_Id => Ui.Company_Id,
                                   i_Filial_Id  => Ui.Filial_Id,
                                   i_Track_Id   => i_Track_Id,
                                   o_Row        => r_Track)).To_Be_True();
    
      Ut.Expect(r_Track.Track_Type).To_Equal(i_Track_Type);
    
      Assert_Timesheet_Track_Type;
    
      if i_Track_Changed then
        Ut.Expect(r_Track.Original_Type).To_Equal(Htt_Pref.c_Track_Type_Check);
      else
        Ut.Expect(r_Track.Original_Type).To_Equal(r_Track.Track_Type);
      end if;
    
      Ut.Expect(Is_Potential).To_Equal(i_Is_Potential);
    end;
  begin
    Assert_Track(i_Track_Id      => g_Tracks.First_Track,
                 i_Track_Type    => i_First_Type,
                 i_Track_Changed => i_First_Changed,
                 i_Is_Potential  => i_First_Potential);
  
    Assert_Track(i_Track_Id      => g_Tracks.Second_Track,
                 i_Track_Type    => i_Second_Type,
                 i_Track_Changed => i_Second_Changed,
                 i_Is_Potential  => i_Second_Potential);
  
    Assert_Track(i_Track_Id      => g_Tracks.Third_Track,
                 i_Track_Type    => i_Third_Type,
                 i_Track_Changed => i_Third_Changed,
                 i_Is_Potential  => i_Third_Potential);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Update_Track_Type
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Track_Id      number,
    i_Track_Type    varchar2,
    i_Original_Type varchar2
  ) is
  begin
    z_Htt_Tracks.Update_One(i_Company_Id    => i_Company_Id,
                            i_Filial_Id     => i_Filial_Id,
                            i_Track_Id      => i_Track_Id,
                            i_Track_Type    => Option_Varchar2(i_Track_Type),
                            i_Original_Type => Option_Varchar2(i_Original_Type));
  
    update Htt_Timesheet_Tracks Tt
       set Tt.Track_Type = i_Track_Type
     where Tt.Company_Id = i_Company_Id
       and Tt.Filial_Id = i_Filial_Id
       and Tt.Track_Id = i_Track_Id;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Transform_Check_Check_Check is
  begin
    Htt_Core.Transform_Check_Track_Type(i_Company_Id     => Ui.Company_Id,
                                        i_Filial_Id      => Ui.Filial_Id,
                                        i_Timesheet_Ids  => Array_Number(g_Timesheet_Id),
                                        i_Check_End_Time => true);
  
    Assert_Transform(i_First_Type       => Htt_Pref.c_Track_Type_Input,
                     i_First_Changed    => true,
                     i_First_Potential  => false,
                     i_Second_Type      => Htt_Pref.c_Track_Type_Check,
                     i_Second_Changed   => false,
                     i_Second_Potential => false,
                     i_Third_Type       => Htt_Pref.c_Track_Type_Output,
                     i_Third_Changed    => true,
                     i_Third_Potential  => false);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Update_Check_Check_Output is
  begin
    Update_Track_Type(i_Company_Id    => Ui.Company_Id,
                      i_Filial_Id     => Ui.Filial_Id,
                      i_Track_Id      => g_Tracks.Third_Track,
                      i_Track_Type    => Htt_Pref.c_Track_Type_Output,
                      i_Original_Type => Htt_Pref.c_Track_Type_Output);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Transform_Check_Check_Output is
  begin
    Htt_Core.Transform_Check_Track_Type(i_Company_Id     => Ui.Company_Id,
                                        i_Filial_Id      => Ui.Filial_Id,
                                        i_Timesheet_Ids  => Array_Number(g_Timesheet_Id),
                                        i_Check_End_Time => true);
  
    Assert_Transform(i_First_Type       => Htt_Pref.c_Track_Type_Input,
                     i_First_Changed    => true,
                     i_First_Potential  => false,
                     i_Second_Type      => Htt_Pref.c_Track_Type_Check,
                     i_Second_Changed   => false,
                     i_Second_Potential => false,
                     i_Third_Type       => Htt_Pref.c_Track_Type_Output,
                     i_Third_Changed    => false,
                     i_Third_Potential  => false);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Update_Input_Check_Check is
  begin
    Update_Track_Type(i_Company_Id    => Ui.Company_Id,
                      i_Filial_Id     => Ui.Filial_Id,
                      i_Track_Id      => g_Tracks.First_Track,
                      i_Track_Type    => Htt_Pref.c_Track_Type_Input,
                      i_Original_Type => Htt_Pref.c_Track_Type_Input);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Transform_Input_Check_Check is
  begin
    Htt_Core.Transform_Check_Track_Type(i_Company_Id     => Ui.Company_Id,
                                        i_Filial_Id      => Ui.Filial_Id,
                                        i_Timesheet_Ids  => Array_Number(g_Timesheet_Id),
                                        i_Check_End_Time => true);
  
    Assert_Transform(i_First_Type       => Htt_Pref.c_Track_Type_Input,
                     i_First_Changed    => false,
                     i_First_Potential  => false,
                     i_Second_Type      => Htt_Pref.c_Track_Type_Check,
                     i_Second_Changed   => false,
                     i_Second_Potential => false,
                     i_Third_Type       => Htt_Pref.c_Track_Type_Output,
                     i_Third_Changed    => true,
                     i_Third_Potential  => false);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Update_Check_Input_Output is
  begin
    Update_Track_Type(i_Company_Id    => Ui.Company_Id,
                      i_Filial_Id     => Ui.Filial_Id,
                      i_Track_Id      => g_Tracks.Second_Track,
                      i_Track_Type    => Htt_Pref.c_Track_Type_Input,
                      i_Original_Type => Htt_Pref.c_Track_Type_Input);
  
    Update_Track_Type(i_Company_Id    => Ui.Company_Id,
                      i_Filial_Id     => Ui.Filial_Id,
                      i_Track_Id      => g_Tracks.Third_Track,
                      i_Track_Type    => Htt_Pref.c_Track_Type_Output,
                      i_Original_Type => Htt_Pref.c_Track_Type_Output);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Transform_Check_Input_Output is
  begin
    Htt_Core.Transform_Check_Track_Type(i_Company_Id     => Ui.Company_Id,
                                        i_Filial_Id      => Ui.Filial_Id,
                                        i_Timesheet_Ids  => Array_Number(g_Timesheet_Id),
                                        i_Check_End_Time => true);
  
    Assert_Transform(i_First_Type       => Htt_Pref.c_Track_Type_Input,
                     i_First_Changed    => true,
                     i_First_Potential  => false,
                     i_Second_Type      => Htt_Pref.c_Track_Type_Input,
                     i_Second_Changed   => false,
                     i_Second_Potential => false,
                     i_Third_Type       => Htt_Pref.c_Track_Type_Output,
                     i_Third_Changed    => false,
                     i_Third_Potential  => false);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Update_Input_Output_Check is
  begin
    Update_Track_Type(i_Company_Id    => Ui.Company_Id,
                      i_Filial_Id     => Ui.Filial_Id,
                      i_Track_Id      => g_Tracks.First_Track,
                      i_Track_Type    => Htt_Pref.c_Track_Type_Input,
                      i_Original_Type => Htt_Pref.c_Track_Type_Input);
  
    Update_Track_Type(i_Company_Id    => Ui.Company_Id,
                      i_Filial_Id     => Ui.Filial_Id,
                      i_Track_Id      => g_Tracks.Second_Track,
                      i_Track_Type    => Htt_Pref.c_Track_Type_Output,
                      i_Original_Type => Htt_Pref.c_Track_Type_Output);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Transform_Input_Output_Check is
  begin
    Htt_Core.Transform_Check_Track_Type(i_Company_Id     => Ui.Company_Id,
                                        i_Filial_Id      => Ui.Filial_Id,
                                        i_Timesheet_Ids  => Array_Number(g_Timesheet_Id),
                                        i_Check_End_Time => true);
  
    Assert_Transform(i_First_Type       => Htt_Pref.c_Track_Type_Input,
                     i_First_Changed    => false,
                     i_First_Potential  => false,
                     i_Second_Type      => Htt_Pref.c_Track_Type_Output,
                     i_Second_Changed   => false,
                     i_Second_Potential => false,
                     i_Third_Type       => Htt_Pref.c_Track_Type_Output,
                     i_Third_Changed    => true,
                     i_Third_Potential  => false);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Update_Input_Output_Changed_Check is
  begin
    Update_Track_Type(i_Company_Id    => Ui.Company_Id,
                      i_Filial_Id     => Ui.Filial_Id,
                      i_Track_Id      => g_Tracks.First_Track,
                      i_Track_Type    => Htt_Pref.c_Track_Type_Input,
                      i_Original_Type => Htt_Pref.c_Track_Type_Input);
  
    Update_Track_Type(i_Company_Id    => Ui.Company_Id,
                      i_Filial_Id     => Ui.Filial_Id,
                      i_Track_Id      => g_Tracks.Second_Track,
                      i_Track_Type    => Htt_Pref.c_Track_Type_Output,
                      i_Original_Type => Htt_Pref.c_Track_Type_Check);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Transform_Input_Output_Changed_Check is
  begin
    Htt_Core.Transform_Check_Track_Type(i_Company_Id     => Ui.Company_Id,
                                        i_Filial_Id      => Ui.Filial_Id,
                                        i_Timesheet_Ids  => Array_Number(g_Timesheet_Id),
                                        i_Check_End_Time => true);
  
    Assert_Transform(i_First_Type       => Htt_Pref.c_Track_Type_Input,
                     i_First_Changed    => false,
                     i_First_Potential  => false,
                     i_Second_Type      => Htt_Pref.c_Track_Type_Check,
                     i_Second_Changed   => false,
                     i_Second_Potential => false,
                     i_Third_Type       => Htt_Pref.c_Track_Type_Output,
                     i_Third_Changed    => true,
                     i_Third_Potential  => false);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Update_Check_Input_Changed_Output is
  begin
    Update_Track_Type(i_Company_Id    => Ui.Company_Id,
                      i_Filial_Id     => Ui.Filial_Id,
                      i_Track_Id      => g_Tracks.Second_Track,
                      i_Track_Type    => Htt_Pref.c_Track_Type_Input,
                      i_Original_Type => Htt_Pref.c_Track_Type_Check);
  
    Update_Track_Type(i_Company_Id    => Ui.Company_Id,
                      i_Filial_Id     => Ui.Filial_Id,
                      i_Track_Id      => g_Tracks.Third_Track,
                      i_Track_Type    => Htt_Pref.c_Track_Type_Output,
                      i_Original_Type => Htt_Pref.c_Track_Type_Output);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Transform_Check_Input_Changed_Output is
  begin
    Htt_Core.Transform_Check_Track_Type(i_Company_Id     => Ui.Company_Id,
                                        i_Filial_Id      => Ui.Filial_Id,
                                        i_Timesheet_Ids  => Array_Number(g_Timesheet_Id),
                                        i_Check_End_Time => true);
  
    Assert_Transform(i_First_Type       => Htt_Pref.c_Track_Type_Input,
                     i_First_Changed    => true,
                     i_First_Potential  => false,
                     i_Second_Type      => Htt_Pref.c_Track_Type_Check,
                     i_Second_Changed   => false,
                     i_Second_Potential => false,
                     i_Third_Type       => Htt_Pref.c_Track_Type_Output,
                     i_Third_Changed    => false,
                     i_Third_Potential  => false);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Update_Input_Output_Changed_Output is
  begin
    Update_Track_Type(i_Company_Id    => Ui.Company_Id,
                      i_Filial_Id     => Ui.Filial_Id,
                      i_Track_Id      => g_Tracks.First_Track,
                      i_Track_Type    => Htt_Pref.c_Track_Type_Input,
                      i_Original_Type => Htt_Pref.c_Track_Type_Input);
  
    Update_Track_Type(i_Company_Id    => Ui.Company_Id,
                      i_Filial_Id     => Ui.Filial_Id,
                      i_Track_Id      => g_Tracks.Second_Track,
                      i_Track_Type    => Htt_Pref.c_Track_Type_Output,
                      i_Original_Type => Htt_Pref.c_Track_Type_Check);
  
    Update_Track_Type(i_Company_Id    => Ui.Company_Id,
                      i_Filial_Id     => Ui.Filial_Id,
                      i_Track_Id      => g_Tracks.Third_Track,
                      i_Track_Type    => Htt_Pref.c_Track_Type_Output,
                      i_Original_Type => Htt_Pref.c_Track_Type_Output);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Transform_Input_Output_Changed_Output is
  begin
    Htt_Core.Transform_Check_Track_Type(i_Company_Id     => Ui.Company_Id,
                                        i_Filial_Id      => Ui.Filial_Id,
                                        i_Timesheet_Ids  => Array_Number(g_Timesheet_Id),
                                        i_Check_End_Time => true);
  
    Assert_Transform(i_First_Type       => Htt_Pref.c_Track_Type_Input,
                     i_First_Changed    => false,
                     i_First_Potential  => false,
                     i_Second_Type      => Htt_Pref.c_Track_Type_Check,
                     i_Second_Changed   => false,
                     i_Second_Potential => false,
                     i_Third_Type       => Htt_Pref.c_Track_Type_Output,
                     i_Third_Changed    => false,
                     i_Third_Potential  => false);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Update_Input_Input_Changed_Output is
  begin
    Update_Track_Type(i_Company_Id    => Ui.Company_Id,
                      i_Filial_Id     => Ui.Filial_Id,
                      i_Track_Id      => g_Tracks.First_Track,
                      i_Track_Type    => Htt_Pref.c_Track_Type_Input,
                      i_Original_Type => Htt_Pref.c_Track_Type_Input);
  
    Update_Track_Type(i_Company_Id    => Ui.Company_Id,
                      i_Filial_Id     => Ui.Filial_Id,
                      i_Track_Id      => g_Tracks.Second_Track,
                      i_Track_Type    => Htt_Pref.c_Track_Type_Input,
                      i_Original_Type => Htt_Pref.c_Track_Type_Check);
  
    Update_Track_Type(i_Company_Id    => Ui.Company_Id,
                      i_Filial_Id     => Ui.Filial_Id,
                      i_Track_Id      => g_Tracks.Third_Track,
                      i_Track_Type    => Htt_Pref.c_Track_Type_Output,
                      i_Original_Type => Htt_Pref.c_Track_Type_Output);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Transform_Input_Input_Changed_Output is
  begin
    Htt_Core.Transform_Check_Track_Type(i_Company_Id     => Ui.Company_Id,
                                        i_Filial_Id      => Ui.Filial_Id,
                                        i_Timesheet_Ids  => Array_Number(g_Timesheet_Id),
                                        i_Check_End_Time => true);
  
    Assert_Transform(i_First_Type       => Htt_Pref.c_Track_Type_Input,
                     i_First_Changed    => false,
                     i_First_Potential  => false,
                     i_Second_Type      => Htt_Pref.c_Track_Type_Check,
                     i_Second_Changed   => false,
                     i_Second_Potential => false,
                     i_Third_Type       => Htt_Pref.c_Track_Type_Output,
                     i_Third_Changed    => false,
                     i_Third_Potential  => false);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Update_Third_Track_Datetime is
    v_Track_Datetime date := Trunc(sysdate) +
                             Numtodsinterval(c_Default_Secondary_Output_Time, 'second');
  begin
    z_Htt_Tracks.Update_One(i_Company_Id     => Ui.Company_Id,
                            i_Filial_Id      => Ui.Filial_Id,
                            i_Track_Id       => g_Tracks.Third_Track,
                            i_Track_Time     => Option_Timestamp(v_Track_Datetime),
                            i_Track_Datetime => Option_Date(v_Track_Datetime));
  
    update Htt_Timesheet_Tracks Tt
       set Tt.Track_Datetime = v_Track_Datetime
     where Tt.Company_Id = Ui.Company_Id
       and Tt.Filial_Id = Ui.Filial_Id
       and Tt.Track_Id = g_Tracks.Third_Track;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Update_First_Track_Type is
  begin
    Update_Track_Type(i_Company_Id    => Ui.Company_Id,
                      i_Filial_Id     => Ui.Filial_Id,
                      i_Track_Id      => g_Tracks.First_Track,
                      i_Track_Type    => Htt_Pref.c_Track_Type_Input,
                      i_Original_Type => Htt_Pref.c_Track_Type_Input);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Transform_Input_Check_Check_Secondary is
  begin
    Htt_Core.Transform_Check_Track_Type(i_Company_Id     => Ui.Company_Id,
                                        i_Filial_Id      => Ui.Filial_Id,
                                        i_Timesheet_Ids  => Array_Number(g_Timesheet_Id),
                                        i_Check_End_Time => true);
  
    Assert_Transform(i_First_Type       => Htt_Pref.c_Track_Type_Input,
                     i_First_Changed    => false,
                     i_First_Potential  => false,
                     i_Second_Type      => Htt_Pref.c_Track_Type_Check,
                     i_Second_Changed   => false,
                     i_Second_Potential => false,
                     i_Third_Type       => Htt_Pref.c_Track_Type_Check,
                     i_Third_Changed    => false,
                     i_Third_Potential  => true);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Update_Input_Output_Check_Secondary is
  begin
    Update_Track_Type(i_Company_Id    => Ui.Company_Id,
                      i_Filial_Id     => Ui.Filial_Id,
                      i_Track_Id      => g_Tracks.Second_Track,
                      i_Track_Type    => Htt_Pref.c_Track_Type_Output,
                      i_Original_Type => Htt_Pref.c_Track_Type_Output);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Transform_Input_Output_Check_Secondary is
  begin
    Htt_Core.Transform_Check_Track_Type(i_Company_Id     => Ui.Company_Id,
                                        i_Filial_Id      => Ui.Filial_Id,
                                        i_Timesheet_Ids  => Array_Number(g_Timesheet_Id),
                                        i_Check_End_Time => true);
  
    Assert_Transform(i_First_Type       => Htt_Pref.c_Track_Type_Input,
                     i_First_Changed    => false,
                     i_First_Potential  => false,
                     i_Second_Type      => Htt_Pref.c_Track_Type_Output,
                     i_Second_Changed   => false,
                     i_Second_Potential => false,
                     i_Third_Type       => Htt_Pref.c_Track_Type_Check,
                     i_Third_Changed    => false,
                     i_Third_Potential  => true);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Update_Input_Check_Potential_Check_Secondary is
  begin
    z_Htt_Potential_Outputs.Insert_One(i_Company_Id     => Ui.Company_Id,
                                       i_Filial_Id      => Ui.Filial_Id,
                                       i_Employee_Id    => g_Staff.Employee_Id,
                                       i_Track_Date     => Trunc(sysdate),
                                       i_Track_Id       => g_Tracks.Second_Track,
                                       i_Track_Datetime => Trunc(sysdate) +
                                                           Numtodsinterval(c_Default_Second_Track_Time,
                                                                           'second'),
                                       i_Device_Id      => g_Device_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Transform_Input_Check_Potential_Check_Secondary is
  begin
    Htt_Core.Transform_Check_Track_Type(i_Company_Id     => Ui.Company_Id,
                                        i_Filial_Id      => Ui.Filial_Id,
                                        i_Timesheet_Ids  => Array_Number(g_Timesheet_Id),
                                        i_Check_End_Time => true);
  
    Assert_Transform(i_First_Type       => Htt_Pref.c_Track_Type_Input,
                     i_First_Changed    => false,
                     i_First_Potential  => false,
                     i_Second_Type      => Htt_Pref.c_Track_Type_Check,
                     i_Second_Changed   => false,
                     i_Second_Potential => false,
                     i_Third_Type       => Htt_Pref.c_Track_Type_Check,
                     i_Third_Changed    => false,
                     i_Third_Potential  => true);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Update_Input_Check_Potential_Output_Secondary is
  begin
    z_Htt_Potential_Outputs.Insert_One(i_Company_Id     => Ui.Company_Id,
                                       i_Filial_Id      => Ui.Filial_Id,
                                       i_Employee_Id    => g_Staff.Employee_Id,
                                       i_Track_Date     => Trunc(sysdate),
                                       i_Track_Id       => g_Tracks.Second_Track,
                                       i_Track_Datetime => Trunc(sysdate) +
                                                           Numtodsinterval(c_Default_Second_Track_Time,
                                                                           'second'),
                                       i_Device_Id      => g_Device_Id);
  
    Update_Track_Type(i_Company_Id    => Ui.Company_Id,
                      i_Filial_Id     => Ui.Filial_Id,
                      i_Track_Id      => g_Tracks.Third_Track,
                      i_Track_Type    => Htt_Pref.c_Track_Type_Output,
                      i_Original_Type => Htt_Pref.c_Track_Type_Output);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Transform_Input_Check_Potential_Output_Secondary is
  begin
    Htt_Core.Transform_Check_Track_Type(i_Company_Id     => Ui.Company_Id,
                                        i_Filial_Id      => Ui.Filial_Id,
                                        i_Timesheet_Ids  => Array_Number(g_Timesheet_Id),
                                        i_Check_End_Time => true);
  
    Assert_Transform(i_First_Type       => Htt_Pref.c_Track_Type_Input,
                     i_First_Changed    => false,
                     i_First_Potential  => false,
                     i_Second_Type      => Htt_Pref.c_Track_Type_Check,
                     i_Second_Changed   => false,
                     i_Second_Potential => false,
                     i_Third_Type       => Htt_Pref.c_Track_Type_Output,
                     i_Third_Changed    => false,
                     i_Third_Potential  => false);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Update_Device_No_Autogen_Inputs is
  begin
    z_Htt_Devices.Update_One(i_Company_Id     => Ui.Company_Id,
                             i_Device_Id      => g_Device_Id,
                             i_Autogen_Inputs => Option_Varchar2('N'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Transform_Device_No_Autogen_Inputs is
  begin
    Htt_Core.Transform_Check_Track_Type(i_Company_Id     => Ui.Company_Id,
                                        i_Filial_Id      => Ui.Filial_Id,
                                        i_Timesheet_Ids  => Array_Number(g_Timesheet_Id),
                                        i_Check_End_Time => true);
  
    Assert_Transform(i_First_Type       => Htt_Pref.c_Track_Type_Check,
                     i_First_Changed    => false,
                     i_First_Potential  => false,
                     i_Second_Type      => Htt_Pref.c_Track_Type_Check,
                     i_Second_Changed   => false,
                     i_Second_Potential => false,
                     i_Third_Type       => Htt_Pref.c_Track_Type_Output,
                     i_Third_Changed    => true,
                     i_Third_Potential  => false);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Update_Device_No_Autogen_Outputs is
  begin
    z_Htt_Devices.Update_One(i_Company_Id      => Ui.Company_Id,
                             i_Device_Id       => g_Device_Id,
                             i_Autogen_Outputs => Option_Varchar2('N'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Transform_Device_No_Autogen_Outputs is
  begin
    Htt_Core.Transform_Check_Track_Type(i_Company_Id     => Ui.Company_Id,
                                        i_Filial_Id      => Ui.Filial_Id,
                                        i_Timesheet_Ids  => Array_Number(g_Timesheet_Id),
                                        i_Check_End_Time => true);
  
    Assert_Transform(i_First_Type       => Htt_Pref.c_Track_Type_Input,
                     i_First_Changed    => true,
                     i_First_Potential  => false,
                     i_Second_Type      => Htt_Pref.c_Track_Type_Check,
                     i_Second_Changed   => false,
                     i_Second_Potential => false,
                     i_Third_Type       => Htt_Pref.c_Track_Type_Check,
                     i_Third_Changed    => false,
                     i_Third_Potential  => false);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Transform_Device_No_Autogen is
  begin
    Htt_Core.Transform_Check_Track_Type(i_Company_Id     => Ui.Company_Id,
                                        i_Filial_Id      => Ui.Filial_Id,
                                        i_Timesheet_Ids  => Array_Number(g_Timesheet_Id),
                                        i_Check_End_Time => true);
  
    Assert_Transform(i_First_Type       => Htt_Pref.c_Track_Type_Check,
                     i_First_Changed    => false,
                     i_First_Potential  => false,
                     i_Second_Type      => Htt_Pref.c_Track_Type_Check,
                     i_Second_Changed   => false,
                     i_Second_Potential => false,
                     i_Third_Type       => Htt_Pref.c_Track_Type_Check,
                     i_Third_Changed    => false,
                     i_Third_Potential  => false);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Update_Check_Check_Check_Potential is
  begin
    z_Htt_Potential_Outputs.Insert_One(i_Company_Id     => Ui.Company_Id,
                                       i_Filial_Id      => Ui.Filial_Id,
                                       i_Employee_Id    => g_Staff.Employee_Id,
                                       i_Track_Date     => Trunc(sysdate),
                                       i_Track_Id       => g_Tracks.Third_Track,
                                       i_Track_Datetime => Trunc(sysdate) +
                                                           Numtodsinterval(c_Default_Secondary_Output_Time,
                                                                           'second'),
                                       i_Device_Id      => g_Device_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Transform_Check_Check_Check_Potential is
  begin
    Htt_Core.Transform_Check_Track_Type(i_Company_Id     => Ui.Company_Id,
                                        i_Filial_Id      => Ui.Filial_Id,
                                        i_Timesheet_Ids  => Array_Number(g_Timesheet_Id),
                                        i_Check_End_Time => false);
  
    Assert_Transform(i_First_Type       => Htt_Pref.c_Track_Type_Input,
                     i_First_Changed    => true,
                     i_First_Potential  => false,
                     i_Second_Type      => Htt_Pref.c_Track_Type_Check,
                     i_Second_Changed   => false,
                     i_Second_Potential => false,
                     i_Third_Type       => Htt_Pref.c_Track_Type_Output,
                     i_Third_Changed    => true,
                     i_Third_Potential  => false);
  end;

end Ut_Htt_Core;
/
