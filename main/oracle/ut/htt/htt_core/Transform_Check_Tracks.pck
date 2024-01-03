create or replace package Transform_Check_Tracks is
  --%suite(htt_core)
  --%suitepath(vhr.htt.htt_core.transform_check_tracks)

  --%context(transformed to merger)

  --%test(creates two mergers)
  Procedure Test_001;

  --%test(creates input merger)
  Procedure Test_002;

  --%test(creates output merger)
  Procedure Test_003;

  --%test(creates merger before output)
  Procedure Test_004;

  --%test(creates merger before input)
  Procedure Test_005;

  --%endcontext

  --%context(not transformed to merger)

  --%test(not transformed when schedule kind is Custom)
  Procedure Test_006;

  --%test(not transformed when schedule kind is Hourly)
  Procedure Test_007;

  --%test(input track cannot be transformed to merger)
  Procedure Test_008;

  --%test(output track cannot be transformed to merger)
  Procedure Test_009;

  --%test(only first check track is transformed to merger)  
  Procedure Test_014;

  --%endcontext

  --%context(transform to input)

  --%test(creates input track when schedule kind is custom)  
  Procedure Test_017;

  --%test(creates input track when schedule kind is flexible)  
  Procedure Test_018;

  --%test(transforms only first track to input)  
  Procedure Test_019;

  --%test(transforms only first track to input, even if next track is input)  
  Procedure Test_020;

  --%test(transforms only first track to input, even if next track is output)  
  Procedure Test_021;

  --%endcontext

  --%context(not transformed to input)

  --%test(cannot transform when schedule kind is Hourly)
  Procedure Test_022;

  --%test(input is not transformed to input)
  Procedure Test_023;

  --%test(output is not transformed to input)
  Procedure Test_024;

  --%test(transforms only first track to input, even when first track is input)
  Procedure Test_025;

  --%test(transforms only first track to input, even when first track is output)
  Procedure Test_026;

  --%test(transforms only first track to input, even when first track was not transformed to input)
  Procedure Test_027;

  --%test(cannot transform when track comes before shift)
  Procedure Test_028;

  --%test(cannot transform when track comes after shift)
  Procedure Test_029;

  --%test(cannot transform when track is transformed to merger)
  Procedure Test_030;

  --%test(cannot transform when exists input merger)
  Procedure Test_031;

  --%test(cannot transform when transform input is disabled)
  Procedure Test_032;

  --%endcontext

  --%context(transformed to output)

  --%test(creates output)
  Procedure Test_033;

  --%test(transforms second track to output, when first is input)
  Procedure Test_034;

  --%test(transforms second track to output, when first is output)
  Procedure Test_035;

  --%endcontext

  --%context(transformed to output)

  --%test(first track not transformed to output when second track remains check)
  Procedure Test_036;

  --%test(first track not transformed to output when second track is output)
  Procedure Test_037;

  --%test(first track not transformed to output when second track is input)
  Procedure Test_038;

  --%test(not transformed to output when output merger exists)
  Procedure Test_039;

  --%test(not transformed to output when can be transformed to input)
  Procedure Test_040;

  --%test(not transformed when track is before shift)
  Procedure Test_041;

  --%test(not transformed when track is after shift)
  Procedure Test_042;

  --%endcontext

  --%context(transform to potential output)

  --%test(creates potential output)
  Procedure Test_043;

  --%endcontext

  -- %context(restricted type transform)

  --%test(C -> C)
  Procedure Test_044;

  --%test(I -> I)
  Procedure Test_045;

  --%test(O -> O)
  Procedure Test_046;

  --%test(O -> PO)
  Procedure Test_047;

  --%test(II -> CI)
  Procedure Test_048;

  --%test(OO -> CO)
  Procedure Test_049;

  --%test(IC -> IC)
  Procedure Test_050;

  --%test(OC -> OC)
  Procedure Test_051;

  --%test(OC -> OPO)
  Procedure Test_052;

  --%test(CO -> CPO)
  Procedure Test_053;

  --%test(IC -> IO)
  Procedure Test_054;

  --%test(CO -> IO)
  Procedure Test_055;

  --%test(Ii -> Ii)
  Procedure Test_056;

  --%test(Oo -> Oo)
  Procedure Test_057;

  -- %endcontext

  ----------------------------------------------------------------------------------------------------
  Procedure Push_Track
  (
    p_Tracks         in out nocopy Htt_Pref.Timesheet_Track_Nt,
    i_Timesheet_Id   number,
    i_Track_Id       number,
    i_Track_Datetime date,
    i_Track_Type     varchar2,
    i_Trans_Input    varchar2,
    i_Trans_Output   varchar2,
    i_Trans_Check    varchar2 := 'N'
  );

end Transform_Check_Tracks;
/
create or replace package body Transform_Check_Tracks is
  c_Company_Head constant number := Md_Pref.Company_Head;
  c_Filial_Head  constant number := Md_Pref.Filial_Head(c_Company_Head);

  ----------------------------------------------------------------------------------------------------
  Procedure Push_Track
  (
    p_Tracks         in out nocopy Htt_Pref.Timesheet_Track_Nt,
    i_Timesheet_Id   number,
    i_Track_Id       number,
    i_Track_Datetime date,
    i_Track_Type     varchar2,
    i_Trans_Input    varchar2,
    i_Trans_Output   varchar2,
    i_Trans_Check    varchar2 := 'N'
  ) is
    v_Track Htt_Pref.Timesheet_Track_Rt;
  begin
    v_Track := Htt_Pref.Timesheet_Track_Rt(Company_Id     => c_Company_Head,
                                           Filial_Id      => c_Filial_Head,
                                           Timesheet_Id   => i_Timesheet_Id,
                                           Track_Id       => i_Track_Id,
                                           Track_Datetime => i_Track_Datetime,
                                           Track_Type     => i_Track_Type,
                                           Trans_Input    => i_Trans_Input,
                                           Trans_Output   => i_Trans_Output,
                                           Trans_Check    => i_Trans_Check);
  
    p_Tracks.Extend;
    p_Tracks(p_Tracks.Count) := v_Track;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Track
  (
    i_Track          Htt_Pref.Timesheet_Track_Rt,
    i_Timesheet_Id   number,
    i_Track_Id       number,
    i_Track_Datetime date,
    i_Track_Type     varchar2,
    i_Trans_Input    varchar2,
    i_Trans_Output   varchar2,
    i_Trans_Check    varchar2 := 'N'
  ) is
  begin
    Ut.Expect(i_Track.Timesheet_Id).To_Equal(i_Timesheet_Id);
    Ut.Expect(i_Track.Track_Id).To_Equal(i_Track_Id);
    Ut.Expect(i_Track.Track_Datetime).To_Equal(i_Track_Datetime);
    Ut.Expect(i_Track.Track_Type).To_Equal(i_Track_Type);
    Ut.Expect(i_Track.Trans_Input).To_Equal(i_Trans_Input);
    Ut.Expect(i_Track.Trans_Output).To_Equal(i_Trans_Output);
    Ut.Expect(i_Track.Trans_Check).To_Equal(i_Trans_Check);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Test_001 is
    v_Tracks       Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
    v_Trans_Tracks Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
  
    v_Merger_Interval interval day to second := Numtodsinterval(Htt_Pref.c_Default_Merge_Border,
                                                                'second');
  
    v_Shift_Begin   date := to_date('01.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Shift_End     date := to_date('02.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Input_Border  date := v_Shift_Begin - v_Merger_Interval;
    v_Output_Border date := v_Shift_End + v_Merger_Interval;
    v_End_Time      date := v_Shift_End;
  
    v_Datetime_1 date := to_date('01.01.2023 08:50', 'dd.mm.yyyy hh24:mi');
    v_Datetime_2 date := to_date('02.01.2023 09:10', 'dd.mm.yyyy hh24:mi');
  begin
    -- prepare
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 1,
               i_Track_Datetime => v_Datetime_1,
               i_Track_Type     => Htt_Pref.c_Track_Type_Check,
               i_Trans_Input    => 'N',
               i_Trans_Output   => 'N');
  
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 2,
               i_Track_Datetime => v_Datetime_2,
               i_Track_Type     => Htt_Pref.c_Track_Type_Check,
               i_Trans_Input    => 'N',
               i_Trans_Output   => 'N');
  
    -- execute
    Htt_Core.Transform_Check_Tracks(p_Tracks           => v_Tracks,
                                    p_Trans_Tracks     => v_Trans_Tracks,
                                    i_Company_Id       => c_Company_Head,
                                    i_Filial_Id        => c_Filial_Head,
                                    i_Schedule_Kind    => Htt_Pref.c_Schedule_Kind_Flexible,
                                    i_Shift_Begin_Time => v_Shift_Begin,
                                    i_Shift_End_Time   => v_Shift_End,
                                    i_Input_Border     => v_Input_Border,
                                    i_Output_Border    => v_Output_Border,
                                    i_End_Time         => v_End_Time);
  
    -- assert
    Ut.Expect(v_Tracks.Count).To_Equal(2);
    Ut.Expect(v_Trans_Tracks.Count).To_Equal(2);
  
    Assert_Track(i_Track          => v_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Shift_Begin,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Merger,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'N');
  
    Assert_Track(i_Track          => v_Tracks(2),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 2,
                 i_Track_Datetime => v_Shift_End,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Merger,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'N');
  
    Assert_Track(i_Track          => v_Trans_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Shift_Begin,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Merger,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'N');
  
    Assert_Track(i_Track          => v_Trans_Tracks(2),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 2,
                 i_Track_Datetime => v_Shift_End,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Merger,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'N');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Test_002 is
    v_Tracks       Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
    v_Trans_Tracks Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
  
    v_Merger_Interval interval day to second := Numtodsinterval(Htt_Pref.c_Default_Merge_Border,
                                                                'second');
  
    v_Shift_Begin   date := to_date('01.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Shift_End     date := to_date('02.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Input_Border  date := v_Shift_Begin - v_Merger_Interval;
    v_Output_Border date := v_Shift_End + v_Merger_Interval;
    v_End_Time      date := v_Shift_End;
  
    v_Datetime_1 date := to_date('01.01.2023 08:50', 'dd.mm.yyyy hh24:mi');
  begin
    -- prepare
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 1,
               i_Track_Datetime => v_Datetime_1,
               i_Track_Type     => Htt_Pref.c_Track_Type_Check,
               i_Trans_Input    => 'N',
               i_Trans_Output   => 'N');
  
    -- execute
    Htt_Core.Transform_Check_Tracks(p_Tracks           => v_Tracks,
                                    p_Trans_Tracks     => v_Trans_Tracks,
                                    i_Company_Id       => c_Company_Head,
                                    i_Filial_Id        => c_Filial_Head,
                                    i_Schedule_Kind    => Htt_Pref.c_Schedule_Kind_Flexible,
                                    i_Shift_Begin_Time => v_Shift_Begin,
                                    i_Shift_End_Time   => v_Shift_End,
                                    i_Input_Border     => v_Input_Border,
                                    i_Output_Border    => v_Output_Border,
                                    i_End_Time         => v_End_Time);
  
    -- assert
    Ut.Expect(v_Tracks.Count).To_Equal(1);
    Ut.Expect(v_Trans_Tracks.Count).To_Equal(1);
  
    Assert_Track(i_Track          => v_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Shift_Begin,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Merger,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'N');
  
    Assert_Track(i_Track          => v_Trans_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Shift_Begin,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Merger,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'N');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Test_003 is
    v_Tracks       Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
    v_Trans_Tracks Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
  
    v_Merger_Interval interval day to second := Numtodsinterval(Htt_Pref.c_Default_Merge_Border,
                                                                'second');
  
    v_Shift_Begin   date := to_date('31.12.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Shift_End     date := to_date('01.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Input_Border  date := v_Shift_Begin - v_Merger_Interval;
    v_Output_Border date := v_Shift_End + v_Merger_Interval;
    v_End_Time      date := v_Shift_End;
  
    v_Datetime_1 date := to_date('01.01.2023 08:50', 'dd.mm.yyyy hh24:mi');
  begin
    -- prepare
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 1,
               i_Track_Datetime => v_Datetime_1,
               i_Track_Type     => Htt_Pref.c_Track_Type_Check,
               i_Trans_Input    => 'N',
               i_Trans_Output   => 'N');
  
    -- execute
    Htt_Core.Transform_Check_Tracks(p_Tracks           => v_Tracks,
                                    p_Trans_Tracks     => v_Trans_Tracks,
                                    i_Company_Id       => c_Company_Head,
                                    i_Filial_Id        => c_Filial_Head,
                                    i_Schedule_Kind    => Htt_Pref.c_Schedule_Kind_Flexible,
                                    i_Shift_Begin_Time => v_Shift_Begin,
                                    i_Shift_End_Time   => v_Shift_End,
                                    i_Input_Border     => v_Input_Border,
                                    i_Output_Border    => v_Output_Border,
                                    i_End_Time         => v_End_Time);
  
    -- assert
    Ut.Expect(v_Tracks.Count).To_Equal(1);
    Ut.Expect(v_Trans_Tracks.Count).To_Equal(1);
  
    Assert_Track(i_Track          => v_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Shift_End,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Merger,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'N');
  
    Assert_Track(i_Track          => v_Trans_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Shift_End,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Merger,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'N');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Test_004 is
    v_Tracks       Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
    v_Trans_Tracks Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
  
    v_Merger_Interval interval day to second := Numtodsinterval(Htt_Pref.c_Default_Merge_Border,
                                                                'second');
  
    v_Shift_Begin   date := to_date('01.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Shift_End     date := to_date('02.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Input_Border  date := v_Shift_Begin - v_Merger_Interval;
    v_Output_Border date := v_Shift_End + v_Merger_Interval;
    v_End_Time      date := v_Shift_End;
  
    v_Datetime_1 date := to_date('01.01.2023 08:50', 'dd.mm.yyyy hh24:mi');
    v_Datetime_2 date := to_date('01.01.2023 09:10', 'dd.mm.yyyy hh24:mi');
  begin
    -- prepare
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 2,
               i_Track_Datetime => v_Datetime_2,
               i_Track_Type     => Htt_Pref.c_Track_Type_Output,
               i_Trans_Input    => 'N',
               i_Trans_Output   => 'N');
  
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 1,
               i_Track_Datetime => v_Datetime_1,
               i_Track_Type     => Htt_Pref.c_Track_Type_Check,
               i_Trans_Input    => 'N',
               i_Trans_Output   => 'N');
  
    -- execute
    Htt_Core.Transform_Check_Tracks(p_Tracks           => v_Tracks,
                                    p_Trans_Tracks     => v_Trans_Tracks,
                                    i_Company_Id       => c_Company_Head,
                                    i_Filial_Id        => c_Filial_Head,
                                    i_Schedule_Kind    => Htt_Pref.c_Schedule_Kind_Flexible,
                                    i_Shift_Begin_Time => v_Shift_Begin,
                                    i_Shift_End_Time   => v_Shift_End,
                                    i_Input_Border     => v_Input_Border,
                                    i_Output_Border    => v_Output_Border,
                                    i_End_Time         => v_End_Time);
  
    -- assert
    Ut.Expect(v_Tracks.Count).To_Equal(2);
    Ut.Expect(v_Trans_Tracks.Count).To_Equal(1);
  
    Assert_Track(i_Track          => v_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Shift_Begin,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Merger,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'N');
  
    Assert_Track(i_Track          => v_Tracks(2),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 2,
                 i_Track_Datetime => v_Datetime_2,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Output,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'N');
  
    Assert_Track(i_Track          => v_Trans_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Shift_Begin,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Merger,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'N');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Test_005 is
    v_Tracks       Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
    v_Trans_Tracks Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
  
    v_Merger_Interval interval day to second := Numtodsinterval(Htt_Pref.c_Default_Merge_Border,
                                                                'second');
  
    v_Shift_Begin   date := to_date('31.12.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Shift_End     date := to_date('01.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Input_Border  date := v_Shift_Begin - v_Merger_Interval;
    v_Output_Border date := v_Shift_End + v_Merger_Interval;
    v_End_Time      date := v_Shift_End;
  
    v_Datetime_1 date := to_date('01.01.2023 08:50', 'dd.mm.yyyy hh24:mi');
    v_Datetime_2 date := to_date('01.01.2023 09:10', 'dd.mm.yyyy hh24:mi');
  begin
    -- prepare
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 2,
               i_Track_Datetime => v_Datetime_2,
               i_Track_Type     => Htt_Pref.c_Track_Type_Check,
               i_Trans_Input    => 'N',
               i_Trans_Output   => 'N');
  
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 1,
               i_Track_Datetime => v_Datetime_1,
               i_Track_Type     => Htt_Pref.c_Track_Type_Input,
               i_Trans_Input    => 'N',
               i_Trans_Output   => 'N');
  
    -- execute
    Htt_Core.Transform_Check_Tracks(p_Tracks           => v_Tracks,
                                    p_Trans_Tracks     => v_Trans_Tracks,
                                    i_Company_Id       => c_Company_Head,
                                    i_Filial_Id        => c_Filial_Head,
                                    i_Schedule_Kind    => Htt_Pref.c_Schedule_Kind_Flexible,
                                    i_Shift_Begin_Time => v_Shift_Begin,
                                    i_Shift_End_Time   => v_Shift_End,
                                    i_Input_Border     => v_Input_Border,
                                    i_Output_Border    => v_Output_Border,
                                    i_End_Time         => v_End_Time);
  
    -- assert
    Ut.Expect(v_Tracks.Count).To_Equal(2);
    Ut.Expect(v_Trans_Tracks.Count).To_Equal(1);
  
    Assert_Track(i_Track          => v_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Datetime_1,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Input,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'N');
  
    Assert_Track(i_Track          => v_Tracks(2),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 2,
                 i_Track_Datetime => v_Shift_End,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Merger,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'N');
  
    Assert_Track(i_Track          => v_Trans_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 2,
                 i_Track_Datetime => v_Shift_End,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Merger,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'N');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Test_006 is
    v_Tracks       Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
    v_Trans_Tracks Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
  
    v_Merger_Interval interval day to second := Numtodsinterval(Htt_Pref.c_Default_Merge_Border,
                                                                'second');
  
    v_Shift_Begin   date := to_date('01.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Shift_End     date := to_date('02.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Input_Border  date := v_Shift_Begin - v_Merger_Interval;
    v_Output_Border date := v_Shift_End + v_Merger_Interval;
    v_End_Time      date := v_Shift_End;
  
    v_Datetime_1 date := to_date('01.01.2023 08:50', 'dd.mm.yyyy hh24:mi');
  begin
    -- prepare
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 1,
               i_Track_Datetime => v_Datetime_1,
               i_Track_Type     => Htt_Pref.c_Track_Type_Check,
               i_Trans_Input    => 'N',
               i_Trans_Output   => 'N');
  
    -- execute
    Htt_Core.Transform_Check_Tracks(p_Tracks           => v_Tracks,
                                    p_Trans_Tracks     => v_Trans_Tracks,
                                    i_Company_Id       => c_Company_Head,
                                    i_Filial_Id        => c_Filial_Head,
                                    i_Schedule_Kind    => Htt_Pref.c_Schedule_Kind_Custom,
                                    i_Shift_Begin_Time => v_Shift_Begin,
                                    i_Shift_End_Time   => v_Shift_End,
                                    i_Input_Border     => v_Input_Border,
                                    i_Output_Border    => v_Output_Border,
                                    i_End_Time         => v_End_Time);
  
    -- assert
    Ut.Expect(v_Tracks.Count).To_Equal(1);
    Ut.Expect(v_Trans_Tracks.Count).To_Equal(0);
  
    Assert_Track(i_Track          => v_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Datetime_1,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Check,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'N');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Test_007 is
    v_Tracks       Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
    v_Trans_Tracks Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
  
    v_Merger_Interval interval day to second := Numtodsinterval(Htt_Pref.c_Default_Merge_Border,
                                                                'second');
  
    v_Shift_Begin   date := to_date('01.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Shift_End     date := to_date('02.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Input_Border  date := v_Shift_Begin - v_Merger_Interval;
    v_Output_Border date := v_Shift_End + v_Merger_Interval;
    v_End_Time      date := v_Shift_End;
  
    v_Datetime_1 date := to_date('01.01.2023 08:50', 'dd.mm.yyyy hh24:mi');
  begin
    -- prepare
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 1,
               i_Track_Datetime => v_Datetime_1,
               i_Track_Type     => Htt_Pref.c_Track_Type_Check,
               i_Trans_Input    => 'N',
               i_Trans_Output   => 'N');
  
    -- execute
    Htt_Core.Transform_Check_Tracks(p_Tracks           => v_Tracks,
                                    p_Trans_Tracks     => v_Trans_Tracks,
                                    i_Company_Id       => c_Company_Head,
                                    i_Filial_Id        => c_Filial_Head,
                                    i_Schedule_Kind    => Htt_Pref.c_Schedule_Kind_Hourly,
                                    i_Shift_Begin_Time => v_Shift_Begin,
                                    i_Shift_End_Time   => v_Shift_End,
                                    i_Input_Border     => v_Input_Border,
                                    i_Output_Border    => v_Output_Border,
                                    i_End_Time         => v_End_Time);
  
    -- assert
    Ut.Expect(v_Tracks.Count).To_Equal(1);
    Ut.Expect(v_Trans_Tracks.Count).To_Equal(0);
  
    Assert_Track(i_Track          => v_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Datetime_1,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Check,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'N');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Test_008 is
    v_Tracks       Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
    v_Trans_Tracks Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
  
    v_Merger_Interval interval day to second := Numtodsinterval(Htt_Pref.c_Default_Merge_Border,
                                                                'second');
  
    v_Shift_Begin   date := to_date('31.12.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Shift_End     date := to_date('01.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Input_Border  date := v_Shift_Begin - v_Merger_Interval;
    v_Output_Border date := v_Shift_End + v_Merger_Interval;
    v_End_Time      date := v_Shift_End;
  
    v_Datetime_1 date := to_date('01.01.2023 08:50', 'dd.mm.yyyy hh24:mi');
  begin
    -- prepare
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 1,
               i_Track_Datetime => v_Datetime_1,
               i_Track_Type     => Htt_Pref.c_Track_Type_Input,
               i_Trans_Input    => 'N',
               i_Trans_Output   => 'N');
  
    -- execute
    Htt_Core.Transform_Check_Tracks(p_Tracks           => v_Tracks,
                                    p_Trans_Tracks     => v_Trans_Tracks,
                                    i_Company_Id       => c_Company_Head,
                                    i_Filial_Id        => c_Filial_Head,
                                    i_Schedule_Kind    => Htt_Pref.c_Schedule_Kind_Flexible,
                                    i_Shift_Begin_Time => v_Shift_Begin,
                                    i_Shift_End_Time   => v_Shift_End,
                                    i_Input_Border     => v_Input_Border,
                                    i_Output_Border    => v_Output_Border,
                                    i_End_Time         => v_End_Time);
  
    -- assert
    Ut.Expect(v_Tracks.Count).To_Equal(1);
    Ut.Expect(v_Trans_Tracks.Count).To_Equal(0);
  
    Assert_Track(i_Track          => v_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Datetime_1,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Input,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'N');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Test_009 is
    v_Tracks       Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
    v_Trans_Tracks Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
  
    v_Merger_Interval interval day to second := Numtodsinterval(Htt_Pref.c_Default_Merge_Border,
                                                                'second');
  
    v_Shift_Begin   date := to_date('31.12.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Shift_End     date := to_date('01.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Input_Border  date := v_Shift_Begin - v_Merger_Interval;
    v_Output_Border date := v_Shift_End + v_Merger_Interval;
    v_End_Time      date := v_Shift_End;
  
    v_Datetime_1 date := to_date('01.01.2023 08:50', 'dd.mm.yyyy hh24:mi');
  begin
    -- prepare
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 1,
               i_Track_Datetime => v_Datetime_1,
               i_Track_Type     => Htt_Pref.c_Track_Type_Output,
               i_Trans_Input    => 'N',
               i_Trans_Output   => 'N');
  
    -- execute
    Htt_Core.Transform_Check_Tracks(p_Tracks           => v_Tracks,
                                    p_Trans_Tracks     => v_Trans_Tracks,
                                    i_Company_Id       => c_Company_Head,
                                    i_Filial_Id        => c_Filial_Head,
                                    i_Schedule_Kind    => Htt_Pref.c_Schedule_Kind_Flexible,
                                    i_Shift_Begin_Time => v_Shift_Begin,
                                    i_Shift_End_Time   => v_Shift_End,
                                    i_Input_Border     => v_Input_Border,
                                    i_Output_Border    => v_Output_Border,
                                    i_End_Time         => v_End_Time);
  
    -- assert
    Ut.Expect(v_Tracks.Count).To_Equal(1);
    Ut.Expect(v_Trans_Tracks.Count).To_Equal(0);
  
    Assert_Track(i_Track          => v_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Datetime_1,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Output,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'N');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Test_014 is
    v_Tracks       Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
    v_Trans_Tracks Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
  
    v_Merger_Interval interval day to second := Numtodsinterval(Htt_Pref.c_Default_Merge_Border,
                                                                'second');
  
    v_Shift_Begin   date := to_date('01.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Shift_End     date := to_date('02.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Input_Border  date := v_Shift_Begin - v_Merger_Interval;
    v_Output_Border date := v_Shift_End + v_Merger_Interval;
    v_End_Time      date := v_Shift_End;
  
    v_Datetime_1 date := to_date('01.01.2023 08:50', 'dd.mm.yyyy hh24:mi');
    v_Datetime_2 date := to_date('01.01.2023 09:10', 'dd.mm.yyyy hh24:mi');
  begin
    -- prepare
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 1,
               i_Track_Datetime => v_Datetime_1,
               i_Track_Type     => Htt_Pref.c_Track_Type_Check,
               i_Trans_Input    => 'N',
               i_Trans_Output   => 'N');
  
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 2,
               i_Track_Datetime => v_Datetime_2,
               i_Track_Type     => Htt_Pref.c_Track_Type_Check,
               i_Trans_Input    => 'N',
               i_Trans_Output   => 'N');
  
    -- execute
    Htt_Core.Transform_Check_Tracks(p_Tracks           => v_Tracks,
                                    p_Trans_Tracks     => v_Trans_Tracks,
                                    i_Company_Id       => c_Company_Head,
                                    i_Filial_Id        => c_Filial_Head,
                                    i_Schedule_Kind    => Htt_Pref.c_Schedule_Kind_Flexible,
                                    i_Shift_Begin_Time => v_Shift_Begin,
                                    i_Shift_End_Time   => v_Shift_End,
                                    i_Input_Border     => v_Input_Border,
                                    i_Output_Border    => v_Output_Border,
                                    i_End_Time         => v_End_Time);
  
    -- assert
    Ut.Expect(v_Tracks.Count).To_Equal(2);
    Ut.Expect(v_Trans_Tracks.Count).To_Equal(1);
  
    Assert_Track(i_Track          => v_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Shift_Begin,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Merger,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'N');
  
    Assert_Track(i_Track          => v_Tracks(2),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 2,
                 i_Track_Datetime => v_Datetime_2,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Check,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'N');
  
    Assert_Track(i_Track          => v_Trans_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Shift_Begin,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Merger,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'N');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Test_017 is
    v_Tracks       Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
    v_Trans_Tracks Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
  
    v_Merger_Interval interval day to second := Numtodsinterval(Htt_Pref.c_Default_Merge_Border,
                                                                'second');
  
    v_Shift_Begin   date := to_date('01.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Shift_End     date := to_date('02.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Input_Border  date := v_Shift_Begin - v_Merger_Interval;
    v_Output_Border date := v_Shift_End + v_Merger_Interval;
    v_End_Time      date := v_Shift_End;
  
    v_Datetime_1 date := to_date('01.01.2023 09:30', 'dd.mm.yyyy hh24:mi');
  begin
    -- prepare
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 1,
               i_Track_Datetime => v_Datetime_1,
               i_Track_Type     => Htt_Pref.c_Track_Type_Check,
               i_Trans_Input    => 'Y',
               i_Trans_Output   => 'N');
  
    -- execute
    Htt_Core.Transform_Check_Tracks(p_Tracks           => v_Tracks,
                                    p_Trans_Tracks     => v_Trans_Tracks,
                                    i_Company_Id       => c_Company_Head,
                                    i_Filial_Id        => c_Filial_Head,
                                    i_Schedule_Kind    => Htt_Pref.c_Schedule_Kind_Custom,
                                    i_Shift_Begin_Time => v_Shift_Begin,
                                    i_Shift_End_Time   => v_Shift_End,
                                    i_Input_Border     => v_Input_Border,
                                    i_Output_Border    => v_Output_Border,
                                    i_End_Time         => v_End_Time);
  
    -- assert
    Ut.Expect(v_Tracks.Count).To_Equal(1);
    Ut.Expect(v_Trans_Tracks.Count).To_Equal(1);
  
    Assert_Track(i_Track          => v_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Datetime_1,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Input,
                 i_Trans_Input    => 'Y',
                 i_Trans_Output   => 'N');
  
    Assert_Track(i_Track          => v_Trans_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Datetime_1,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Input,
                 i_Trans_Input    => 'Y',
                 i_Trans_Output   => 'N');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Test_018 is
    v_Tracks       Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
    v_Trans_Tracks Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
  
    v_Merger_Interval interval day to second := Numtodsinterval(Htt_Pref.c_Default_Merge_Border,
                                                                'second');
  
    v_Shift_Begin   date := to_date('01.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Shift_End     date := to_date('02.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Input_Border  date := v_Shift_Begin - v_Merger_Interval;
    v_Output_Border date := v_Shift_End + v_Merger_Interval;
    v_End_Time      date := v_Shift_End;
  
    v_Datetime_1 date := to_date('01.01.2023 09:30', 'dd.mm.yyyy hh24:mi');
  begin
    -- prepare
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 1,
               i_Track_Datetime => v_Datetime_1,
               i_Track_Type     => Htt_Pref.c_Track_Type_Check,
               i_Trans_Input    => 'Y',
               i_Trans_Output   => 'N');
  
    -- execute
    Htt_Core.Transform_Check_Tracks(p_Tracks           => v_Tracks,
                                    p_Trans_Tracks     => v_Trans_Tracks,
                                    i_Company_Id       => c_Company_Head,
                                    i_Filial_Id        => c_Filial_Head,
                                    i_Schedule_Kind    => Htt_Pref.c_Schedule_Kind_Flexible,
                                    i_Shift_Begin_Time => v_Shift_Begin,
                                    i_Shift_End_Time   => v_Shift_End,
                                    i_Input_Border     => v_Input_Border,
                                    i_Output_Border    => v_Output_Border,
                                    i_End_Time         => v_End_Time);
  
    -- assert
    Ut.Expect(v_Tracks.Count).To_Equal(1);
    Ut.Expect(v_Trans_Tracks.Count).To_Equal(1);
  
    Assert_Track(i_Track          => v_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Datetime_1,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Input,
                 i_Trans_Input    => 'Y',
                 i_Trans_Output   => 'N');
  
    Assert_Track(i_Track          => v_Trans_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Datetime_1,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Input,
                 i_Trans_Input    => 'Y',
                 i_Trans_Output   => 'N');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Test_019 is
    v_Tracks       Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
    v_Trans_Tracks Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
  
    v_Merger_Interval interval day to second := Numtodsinterval(Htt_Pref.c_Default_Merge_Border,
                                                                'second');
  
    v_Shift_Begin   date := to_date('01.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Shift_End     date := to_date('02.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Input_Border  date := v_Shift_Begin - v_Merger_Interval;
    v_Output_Border date := v_Shift_End + v_Merger_Interval;
    v_End_Time      date := v_Shift_End;
  
    v_Datetime_1 date := to_date('01.01.2023 09:30', 'dd.mm.yyyy hh24:mi');
    v_Datetime_2 date := to_date('01.01.2023 09:45', 'dd.mm.yyyy hh24:mi');
  begin
    -- prepare
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 1,
               i_Track_Datetime => v_Datetime_1,
               i_Track_Type     => Htt_Pref.c_Track_Type_Check,
               i_Trans_Input    => 'Y',
               i_Trans_Output   => 'N');
  
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 2,
               i_Track_Datetime => v_Datetime_2,
               i_Track_Type     => Htt_Pref.c_Track_Type_Check,
               i_Trans_Input    => 'Y',
               i_Trans_Output   => 'N');
  
    -- execute
    Htt_Core.Transform_Check_Tracks(p_Tracks           => v_Tracks,
                                    p_Trans_Tracks     => v_Trans_Tracks,
                                    i_Company_Id       => c_Company_Head,
                                    i_Filial_Id        => c_Filial_Head,
                                    i_Schedule_Kind    => Htt_Pref.c_Schedule_Kind_Flexible,
                                    i_Shift_Begin_Time => v_Shift_Begin,
                                    i_Shift_End_Time   => v_Shift_End,
                                    i_Input_Border     => v_Input_Border,
                                    i_Output_Border    => v_Output_Border,
                                    i_End_Time         => v_End_Time);
  
    -- assert
    Ut.Expect(v_Tracks.Count).To_Equal(2);
    Ut.Expect(v_Trans_Tracks.Count).To_Equal(1);
  
    Assert_Track(i_Track          => v_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Datetime_1,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Input,
                 i_Trans_Input    => 'Y',
                 i_Trans_Output   => 'N');
  
    Assert_Track(i_Track          => v_Tracks(2),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 2,
                 i_Track_Datetime => v_Datetime_2,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Check,
                 i_Trans_Input    => 'Y',
                 i_Trans_Output   => 'N');
  
    Assert_Track(i_Track          => v_Trans_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Datetime_1,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Input,
                 i_Trans_Input    => 'Y',
                 i_Trans_Output   => 'N');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Test_020 is
    v_Tracks       Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
    v_Trans_Tracks Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
  
    v_Merger_Interval interval day to second := Numtodsinterval(Htt_Pref.c_Default_Merge_Border,
                                                                'second');
  
    v_Shift_Begin   date := to_date('01.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Shift_End     date := to_date('02.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Input_Border  date := v_Shift_Begin - v_Merger_Interval;
    v_Output_Border date := v_Shift_End + v_Merger_Interval;
    v_End_Time      date := v_Shift_End;
  
    v_Datetime_1 date := to_date('01.01.2023 09:30', 'dd.mm.yyyy hh24:mi');
    v_Datetime_2 date := to_date('01.01.2023 09:45', 'dd.mm.yyyy hh24:mi');
  begin
    -- prepare
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 1,
               i_Track_Datetime => v_Datetime_1,
               i_Track_Type     => Htt_Pref.c_Track_Type_Check,
               i_Trans_Input    => 'Y',
               i_Trans_Output   => 'N');
  
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 2,
               i_Track_Datetime => v_Datetime_2,
               i_Track_Type     => Htt_Pref.c_Track_Type_Input,
               i_Trans_Input    => 'N',
               i_Trans_Output   => 'N');
  
    -- execute
    Htt_Core.Transform_Check_Tracks(p_Tracks           => v_Tracks,
                                    p_Trans_Tracks     => v_Trans_Tracks,
                                    i_Company_Id       => c_Company_Head,
                                    i_Filial_Id        => c_Filial_Head,
                                    i_Schedule_Kind    => Htt_Pref.c_Schedule_Kind_Flexible,
                                    i_Shift_Begin_Time => v_Shift_Begin,
                                    i_Shift_End_Time   => v_Shift_End,
                                    i_Input_Border     => v_Input_Border,
                                    i_Output_Border    => v_Output_Border,
                                    i_End_Time         => v_End_Time);
  
    -- assert
    Ut.Expect(v_Tracks.Count).To_Equal(2);
    Ut.Expect(v_Trans_Tracks.Count).To_Equal(1);
  
    Assert_Track(i_Track          => v_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Datetime_1,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Input,
                 i_Trans_Input    => 'Y',
                 i_Trans_Output   => 'N');
  
    Assert_Track(i_Track          => v_Tracks(2),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 2,
                 i_Track_Datetime => v_Datetime_2,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Input,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'N');
  
    Assert_Track(i_Track          => v_Trans_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Datetime_1,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Input,
                 i_Trans_Input    => 'Y',
                 i_Trans_Output   => 'N');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Test_021 is
    v_Tracks       Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
    v_Trans_Tracks Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
  
    v_Merger_Interval interval day to second := Numtodsinterval(Htt_Pref.c_Default_Merge_Border,
                                                                'second');
  
    v_Shift_Begin   date := to_date('01.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Shift_End     date := to_date('02.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Input_Border  date := v_Shift_Begin - v_Merger_Interval;
    v_Output_Border date := v_Shift_End + v_Merger_Interval;
    v_End_Time      date := v_Shift_End;
  
    v_Datetime_1 date := to_date('01.01.2023 09:30', 'dd.mm.yyyy hh24:mi');
    v_Datetime_2 date := to_date('01.01.2023 09:45', 'dd.mm.yyyy hh24:mi');
  begin
    -- prepare
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 1,
               i_Track_Datetime => v_Datetime_1,
               i_Track_Type     => Htt_Pref.c_Track_Type_Check,
               i_Trans_Input    => 'Y',
               i_Trans_Output   => 'N');
  
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 2,
               i_Track_Datetime => v_Datetime_2,
               i_Track_Type     => Htt_Pref.c_Track_Type_Output,
               i_Trans_Input    => 'N',
               i_Trans_Output   => 'N');
  
    -- execute
    Htt_Core.Transform_Check_Tracks(p_Tracks           => v_Tracks,
                                    p_Trans_Tracks     => v_Trans_Tracks,
                                    i_Company_Id       => c_Company_Head,
                                    i_Filial_Id        => c_Filial_Head,
                                    i_Schedule_Kind    => Htt_Pref.c_Schedule_Kind_Flexible,
                                    i_Shift_Begin_Time => v_Shift_Begin,
                                    i_Shift_End_Time   => v_Shift_End,
                                    i_Input_Border     => v_Input_Border,
                                    i_Output_Border    => v_Output_Border,
                                    i_End_Time         => v_End_Time);
  
    -- assert
    Ut.Expect(v_Tracks.Count).To_Equal(2);
    Ut.Expect(v_Trans_Tracks.Count).To_Equal(1);
  
    Assert_Track(i_Track          => v_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Datetime_1,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Input,
                 i_Trans_Input    => 'Y',
                 i_Trans_Output   => 'N');
  
    Assert_Track(i_Track          => v_Tracks(2),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 2,
                 i_Track_Datetime => v_Datetime_2,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Output,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'N');
  
    Assert_Track(i_Track          => v_Trans_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Datetime_1,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Input,
                 i_Trans_Input    => 'Y',
                 i_Trans_Output   => 'N');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Test_022 is
    v_Tracks       Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
    v_Trans_Tracks Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
  
    v_Merger_Interval interval day to second := Numtodsinterval(Htt_Pref.c_Default_Merge_Border,
                                                                'second');
  
    v_Shift_Begin   date := to_date('01.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Shift_End     date := to_date('02.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Input_Border  date := v_Shift_Begin - v_Merger_Interval;
    v_Output_Border date := v_Shift_End + v_Merger_Interval;
    v_End_Time      date := v_Shift_End;
  
    v_Datetime_1 date := to_date('01.01.2023 09:30', 'dd.mm.yyyy hh24:mi');
  begin
    -- prepare
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 1,
               i_Track_Datetime => v_Datetime_1,
               i_Track_Type     => Htt_Pref.c_Track_Type_Check,
               i_Trans_Input    => 'Y',
               i_Trans_Output   => 'N');
  
    -- execute
    Htt_Core.Transform_Check_Tracks(p_Tracks           => v_Tracks,
                                    p_Trans_Tracks     => v_Trans_Tracks,
                                    i_Company_Id       => c_Company_Head,
                                    i_Filial_Id        => c_Filial_Head,
                                    i_Schedule_Kind    => Htt_Pref.c_Schedule_Kind_Hourly,
                                    i_Shift_Begin_Time => v_Shift_Begin,
                                    i_Shift_End_Time   => v_Shift_End,
                                    i_Input_Border     => v_Input_Border,
                                    i_Output_Border    => v_Output_Border,
                                    i_End_Time         => v_End_Time);
  
    -- assert
    Ut.Expect(v_Tracks.Count).To_Equal(1);
    Ut.Expect(v_Trans_Tracks.Count).To_Equal(0);
  
    Assert_Track(i_Track          => v_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Datetime_1,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Check,
                 i_Trans_Input    => 'Y',
                 i_Trans_Output   => 'N');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Test_023 is
    v_Tracks       Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
    v_Trans_Tracks Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
  
    v_Merger_Interval interval day to second := Numtodsinterval(Htt_Pref.c_Default_Merge_Border,
                                                                'second');
  
    v_Shift_Begin   date := to_date('01.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Shift_End     date := to_date('02.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Input_Border  date := v_Shift_Begin - v_Merger_Interval;
    v_Output_Border date := v_Shift_End + v_Merger_Interval;
    v_End_Time      date := v_Shift_End;
  
    v_Datetime_1 date := to_date('01.01.2023 09:30', 'dd.mm.yyyy hh24:mi');
  begin
    -- prepare
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 1,
               i_Track_Datetime => v_Datetime_1,
               i_Track_Type     => Htt_Pref.c_Track_Type_Input,
               i_Trans_Input    => 'Y',
               i_Trans_Output   => 'N');
  
    -- execute
    Htt_Core.Transform_Check_Tracks(p_Tracks           => v_Tracks,
                                    p_Trans_Tracks     => v_Trans_Tracks,
                                    i_Company_Id       => c_Company_Head,
                                    i_Filial_Id        => c_Filial_Head,
                                    i_Schedule_Kind    => Htt_Pref.c_Schedule_Kind_Flexible,
                                    i_Shift_Begin_Time => v_Shift_Begin,
                                    i_Shift_End_Time   => v_Shift_End,
                                    i_Input_Border     => v_Input_Border,
                                    i_Output_Border    => v_Output_Border,
                                    i_End_Time         => v_End_Time);
  
    -- assert
    Ut.Expect(v_Tracks.Count).To_Equal(1);
    Ut.Expect(v_Trans_Tracks.Count).To_Equal(0);
  
    Assert_Track(i_Track          => v_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Datetime_1,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Input,
                 i_Trans_Input    => 'Y',
                 i_Trans_Output   => 'N');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Test_024 is
    v_Tracks       Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
    v_Trans_Tracks Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
  
    v_Merger_Interval interval day to second := Numtodsinterval(Htt_Pref.c_Default_Merge_Border,
                                                                'second');
  
    v_Shift_Begin   date := to_date('01.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Shift_End     date := to_date('02.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Input_Border  date := v_Shift_Begin - v_Merger_Interval;
    v_Output_Border date := v_Shift_End + v_Merger_Interval;
    v_End_Time      date := v_Shift_End;
  
    v_Datetime_1 date := to_date('01.01.2023 09:30', 'dd.mm.yyyy hh24:mi');
  begin
    -- prepare
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 1,
               i_Track_Datetime => v_Datetime_1,
               i_Track_Type     => Htt_Pref.c_Track_Type_Output,
               i_Trans_Input    => 'Y',
               i_Trans_Output   => 'N');
  
    -- execute
    Htt_Core.Transform_Check_Tracks(p_Tracks           => v_Tracks,
                                    p_Trans_Tracks     => v_Trans_Tracks,
                                    i_Company_Id       => c_Company_Head,
                                    i_Filial_Id        => c_Filial_Head,
                                    i_Schedule_Kind    => Htt_Pref.c_Schedule_Kind_Flexible,
                                    i_Shift_Begin_Time => v_Shift_Begin,
                                    i_Shift_End_Time   => v_Shift_End,
                                    i_Input_Border     => v_Input_Border,
                                    i_Output_Border    => v_Output_Border,
                                    i_End_Time         => v_End_Time);
  
    -- assert
    Ut.Expect(v_Tracks.Count).To_Equal(1);
    Ut.Expect(v_Trans_Tracks.Count).To_Equal(0);
  
    Assert_Track(i_Track          => v_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Datetime_1,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Output,
                 i_Trans_Input    => 'Y',
                 i_Trans_Output   => 'N');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Test_025 is
    v_Tracks       Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
    v_Trans_Tracks Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
  
    v_Merger_Interval interval day to second := Numtodsinterval(Htt_Pref.c_Default_Merge_Border,
                                                                'second');
  
    v_Shift_Begin   date := to_date('01.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Shift_End     date := to_date('02.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Input_Border  date := v_Shift_Begin - v_Merger_Interval;
    v_Output_Border date := v_Shift_End + v_Merger_Interval;
    v_End_Time      date := v_Shift_End;
  
    v_Datetime_1 date := to_date('01.01.2023 09:30', 'dd.mm.yyyy hh24:mi');
    v_Datetime_2 date := to_date('01.01.2023 09:45', 'dd.mm.yyyy hh24:mi');
  begin
    -- prepare
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 1,
               i_Track_Datetime => v_Datetime_1,
               i_Track_Type     => Htt_Pref.c_Track_Type_Input,
               i_Trans_Input    => 'N',
               i_Trans_Output   => 'N');
  
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 2,
               i_Track_Datetime => v_Datetime_2,
               i_Track_Type     => Htt_Pref.c_Track_Type_Check,
               i_Trans_Input    => 'Y',
               i_Trans_Output   => 'N');
  
    -- execute
    Htt_Core.Transform_Check_Tracks(p_Tracks           => v_Tracks,
                                    p_Trans_Tracks     => v_Trans_Tracks,
                                    i_Company_Id       => c_Company_Head,
                                    i_Filial_Id        => c_Filial_Head,
                                    i_Schedule_Kind    => Htt_Pref.c_Schedule_Kind_Flexible,
                                    i_Shift_Begin_Time => v_Shift_Begin,
                                    i_Shift_End_Time   => v_Shift_End,
                                    i_Input_Border     => v_Input_Border,
                                    i_Output_Border    => v_Output_Border,
                                    i_End_Time         => v_End_Time);
  
    -- assert
    Ut.Expect(v_Tracks.Count).To_Equal(2);
    Ut.Expect(v_Trans_Tracks.Count).To_Equal(0);
  
    Assert_Track(i_Track          => v_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Datetime_1,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Input,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'N');
  
    Assert_Track(i_Track          => v_Tracks(2),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 2,
                 i_Track_Datetime => v_Datetime_2,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Check,
                 i_Trans_Input    => 'Y',
                 i_Trans_Output   => 'N');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Test_026 is
    v_Tracks       Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
    v_Trans_Tracks Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
  
    v_Merger_Interval interval day to second := Numtodsinterval(Htt_Pref.c_Default_Merge_Border,
                                                                'second');
  
    v_Shift_Begin   date := to_date('01.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Shift_End     date := to_date('02.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Input_Border  date := v_Shift_Begin - v_Merger_Interval;
    v_Output_Border date := v_Shift_End + v_Merger_Interval;
    v_End_Time      date := v_Shift_End;
  
    v_Datetime_1 date := to_date('01.01.2023 09:30', 'dd.mm.yyyy hh24:mi');
    v_Datetime_2 date := to_date('01.01.2023 09:45', 'dd.mm.yyyy hh24:mi');
  begin
    -- prepare
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 1,
               i_Track_Datetime => v_Datetime_1,
               i_Track_Type     => Htt_Pref.c_Track_Type_Output,
               i_Trans_Input    => 'N',
               i_Trans_Output   => 'N');
  
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 2,
               i_Track_Datetime => v_Datetime_2,
               i_Track_Type     => Htt_Pref.c_Track_Type_Check,
               i_Trans_Input    => 'Y',
               i_Trans_Output   => 'N');
  
    -- execute
    Htt_Core.Transform_Check_Tracks(p_Tracks           => v_Tracks,
                                    p_Trans_Tracks     => v_Trans_Tracks,
                                    i_Company_Id       => c_Company_Head,
                                    i_Filial_Id        => c_Filial_Head,
                                    i_Schedule_Kind    => Htt_Pref.c_Schedule_Kind_Flexible,
                                    i_Shift_Begin_Time => v_Shift_Begin,
                                    i_Shift_End_Time   => v_Shift_End,
                                    i_Input_Border     => v_Input_Border,
                                    i_Output_Border    => v_Output_Border,
                                    i_End_Time         => v_End_Time);
  
    -- assert
    Ut.Expect(v_Tracks.Count).To_Equal(2);
    Ut.Expect(v_Trans_Tracks.Count).To_Equal(0);
  
    Assert_Track(i_Track          => v_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Datetime_1,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Output,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'N');
  
    Assert_Track(i_Track          => v_Tracks(2),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 2,
                 i_Track_Datetime => v_Datetime_2,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Check,
                 i_Trans_Input    => 'Y',
                 i_Trans_Output   => 'N');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Test_027 is
    v_Tracks       Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
    v_Trans_Tracks Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
  
    v_Merger_Interval interval day to second := Numtodsinterval(Htt_Pref.c_Default_Merge_Border,
                                                                'second');
  
    v_Shift_Begin   date := to_date('01.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Shift_End     date := to_date('02.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Input_Border  date := v_Shift_Begin - v_Merger_Interval;
    v_Output_Border date := v_Shift_End + v_Merger_Interval;
    v_End_Time      date := v_Shift_End;
  
    v_Datetime_1 date := to_date('01.01.2023 09:30', 'dd.mm.yyyy hh24:mi');
    v_Datetime_2 date := to_date('01.01.2023 09:45', 'dd.mm.yyyy hh24:mi');
  begin
    -- prepare
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 1,
               i_Track_Datetime => v_Datetime_1,
               i_Track_Type     => Htt_Pref.c_Track_Type_Check,
               i_Trans_Input    => 'N',
               i_Trans_Output   => 'N');
  
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 2,
               i_Track_Datetime => v_Datetime_2,
               i_Track_Type     => Htt_Pref.c_Track_Type_Check,
               i_Trans_Input    => 'Y',
               i_Trans_Output   => 'N');
  
    -- execute
    Htt_Core.Transform_Check_Tracks(p_Tracks           => v_Tracks,
                                    p_Trans_Tracks     => v_Trans_Tracks,
                                    i_Company_Id       => c_Company_Head,
                                    i_Filial_Id        => c_Filial_Head,
                                    i_Schedule_Kind    => Htt_Pref.c_Schedule_Kind_Flexible,
                                    i_Shift_Begin_Time => v_Shift_Begin,
                                    i_Shift_End_Time   => v_Shift_End,
                                    i_Input_Border     => v_Input_Border,
                                    i_Output_Border    => v_Output_Border,
                                    i_End_Time         => v_End_Time);
  
    -- assert
    Ut.Expect(v_Tracks.Count).To_Equal(2);
    Ut.Expect(v_Trans_Tracks.Count).To_Equal(0);
  
    Assert_Track(i_Track          => v_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Datetime_1,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Check,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'N');
  
    Assert_Track(i_Track          => v_Tracks(2),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 2,
                 i_Track_Datetime => v_Datetime_2,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Check,
                 i_Trans_Input    => 'Y',
                 i_Trans_Output   => 'N');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Test_028 is
    v_Tracks       Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
    v_Trans_Tracks Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
  
    v_Merger_Interval interval day to second := Numtodsinterval(Htt_Pref.c_Default_Merge_Border,
                                                                'second');
  
    v_Shift_Begin   date := to_date('01.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Shift_End     date := to_date('02.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Input_Border  date := v_Shift_Begin - v_Merger_Interval;
    v_Output_Border date := v_Shift_End + v_Merger_Interval;
    v_End_Time      date := v_Shift_End;
  
    v_Datetime_1 date := to_date('01.01.2023 08:30', 'dd.mm.yyyy hh24:mi');
  begin
    -- prepare
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 1,
               i_Track_Datetime => v_Datetime_1,
               i_Track_Type     => Htt_Pref.c_Track_Type_Check,
               i_Trans_Input    => 'Y',
               i_Trans_Output   => 'N');
  
    -- execute
    Htt_Core.Transform_Check_Tracks(p_Tracks           => v_Tracks,
                                    p_Trans_Tracks     => v_Trans_Tracks,
                                    i_Company_Id       => c_Company_Head,
                                    i_Filial_Id        => c_Filial_Head,
                                    i_Schedule_Kind    => Htt_Pref.c_Schedule_Kind_Flexible,
                                    i_Shift_Begin_Time => v_Shift_Begin,
                                    i_Shift_End_Time   => v_Shift_End,
                                    i_Input_Border     => v_Input_Border,
                                    i_Output_Border    => v_Output_Border,
                                    i_End_Time         => v_End_Time);
  
    -- assert
    Ut.Expect(v_Tracks.Count).To_Equal(1);
    Ut.Expect(v_Trans_Tracks.Count).To_Equal(0);
  
    Assert_Track(i_Track          => v_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Datetime_1,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Check,
                 i_Trans_Input    => 'Y',
                 i_Trans_Output   => 'N');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Test_029 is
    v_Tracks       Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
    v_Trans_Tracks Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
  
    v_Merger_Interval interval day to second := Numtodsinterval(Htt_Pref.c_Default_Merge_Border,
                                                                'second');
  
    v_Shift_Begin   date := to_date('01.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Shift_End     date := to_date('02.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Input_Border  date := v_Shift_Begin - v_Merger_Interval;
    v_Output_Border date := v_Shift_End + v_Merger_Interval;
    v_End_Time      date := v_Shift_End;
  
    v_Datetime_1 date := to_date('02.01.2023 09:30', 'dd.mm.yyyy hh24:mi');
  begin
    -- prepare
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 1,
               i_Track_Datetime => v_Datetime_1,
               i_Track_Type     => Htt_Pref.c_Track_Type_Check,
               i_Trans_Input    => 'Y',
               i_Trans_Output   => 'N');
  
    -- execute
    Htt_Core.Transform_Check_Tracks(p_Tracks           => v_Tracks,
                                    p_Trans_Tracks     => v_Trans_Tracks,
                                    i_Company_Id       => c_Company_Head,
                                    i_Filial_Id        => c_Filial_Head,
                                    i_Schedule_Kind    => Htt_Pref.c_Schedule_Kind_Flexible,
                                    i_Shift_Begin_Time => v_Shift_Begin,
                                    i_Shift_End_Time   => v_Shift_End,
                                    i_Input_Border     => v_Input_Border,
                                    i_Output_Border    => v_Output_Border,
                                    i_End_Time         => v_End_Time);
  
    -- assert
    Ut.Expect(v_Tracks.Count).To_Equal(1);
    Ut.Expect(v_Trans_Tracks.Count).To_Equal(0);
  
    Assert_Track(i_Track          => v_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Datetime_1,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Check,
                 i_Trans_Input    => 'Y',
                 i_Trans_Output   => 'N');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Test_030 is
    v_Tracks       Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
    v_Trans_Tracks Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
  
    v_Merger_Interval interval day to second := Numtodsinterval(Htt_Pref.c_Default_Merge_Border,
                                                                'second');
  
    v_Shift_Begin   date := to_date('01.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Shift_End     date := to_date('02.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Input_Border  date := v_Shift_Begin - v_Merger_Interval;
    v_Output_Border date := v_Shift_End + v_Merger_Interval;
    v_End_Time      date := v_Shift_End;
  
    v_Datetime_1 date := to_date('01.01.2023 09:05', 'dd.mm.yyyy hh24:mi');
  begin
    -- prepare
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 1,
               i_Track_Datetime => v_Datetime_1,
               i_Track_Type     => Htt_Pref.c_Track_Type_Check,
               i_Trans_Input    => 'Y',
               i_Trans_Output   => 'N');
  
    -- execute
    Htt_Core.Transform_Check_Tracks(p_Tracks           => v_Tracks,
                                    p_Trans_Tracks     => v_Trans_Tracks,
                                    i_Company_Id       => c_Company_Head,
                                    i_Filial_Id        => c_Filial_Head,
                                    i_Schedule_Kind    => Htt_Pref.c_Schedule_Kind_Flexible,
                                    i_Shift_Begin_Time => v_Shift_Begin,
                                    i_Shift_End_Time   => v_Shift_End,
                                    i_Input_Border     => v_Input_Border,
                                    i_Output_Border    => v_Output_Border,
                                    i_End_Time         => v_End_Time);
  
    -- assert
    Ut.Expect(v_Tracks.Count).To_Equal(1);
    Ut.Expect(v_Trans_Tracks.Count).To_Equal(1);
  
    Assert_Track(i_Track          => v_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Shift_Begin,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Merger,
                 i_Trans_Input    => 'Y',
                 i_Trans_Output   => 'N');
  
    Assert_Track(i_Track          => v_Trans_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Shift_Begin,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Merger,
                 i_Trans_Input    => 'Y',
                 i_Trans_Output   => 'N');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Test_031 is
    v_Tracks       Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
    v_Trans_Tracks Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
  
    v_Merger_Interval interval day to second := Numtodsinterval(Htt_Pref.c_Default_Merge_Border,
                                                                'second');
  
    v_Shift_Begin   date := to_date('01.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Shift_End     date := to_date('02.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Input_Border  date := v_Shift_Begin - v_Merger_Interval;
    v_Output_Border date := v_Shift_End + v_Merger_Interval;
    v_End_Time      date := v_Shift_End;
  
    v_Datetime_1 date := to_date('01.01.2023 08:55', 'dd.mm.yyyy hh24:mi');
    v_Datetime_2 date := to_date('01.01.2023 09:10', 'dd.mm.yyyy hh24:mi');
  begin
    -- prepare
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 1,
               i_Track_Datetime => v_Datetime_1,
               i_Track_Type     => Htt_Pref.c_Track_Type_Check,
               i_Trans_Input    => 'Y',
               i_Trans_Output   => 'N');
  
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 2,
               i_Track_Datetime => v_Datetime_2,
               i_Track_Type     => Htt_Pref.c_Track_Type_Check,
               i_Trans_Input    => 'Y',
               i_Trans_Output   => 'N');
  
    -- execute
    Htt_Core.Transform_Check_Tracks(p_Tracks           => v_Tracks,
                                    p_Trans_Tracks     => v_Trans_Tracks,
                                    i_Company_Id       => c_Company_Head,
                                    i_Filial_Id        => c_Filial_Head,
                                    i_Schedule_Kind    => Htt_Pref.c_Schedule_Kind_Flexible,
                                    i_Shift_Begin_Time => v_Shift_Begin,
                                    i_Shift_End_Time   => v_Shift_End,
                                    i_Input_Border     => v_Input_Border,
                                    i_Output_Border    => v_Output_Border,
                                    i_End_Time         => v_End_Time);
  
    -- assert
    Ut.Expect(v_Tracks.Count).To_Equal(2);
    Ut.Expect(v_Trans_Tracks.Count).To_Equal(1);
  
    Assert_Track(i_Track          => v_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Shift_Begin,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Merger,
                 i_Trans_Input    => 'Y',
                 i_Trans_Output   => 'N');
  
    Assert_Track(i_Track          => v_Tracks(2),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 2,
                 i_Track_Datetime => v_Datetime_2,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Check,
                 i_Trans_Input    => 'Y',
                 i_Trans_Output   => 'N');
  
    Assert_Track(i_Track          => v_Trans_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Shift_Begin,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Merger,
                 i_Trans_Input    => 'Y',
                 i_Trans_Output   => 'N');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Test_032 is
    v_Tracks       Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
    v_Trans_Tracks Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
  
    v_Merger_Interval interval day to second := Numtodsinterval(Htt_Pref.c_Default_Merge_Border,
                                                                'second');
  
    v_Shift_Begin   date := to_date('01.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Shift_End     date := to_date('02.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Input_Border  date := v_Shift_Begin - v_Merger_Interval;
    v_Output_Border date := v_Shift_End + v_Merger_Interval;
    v_End_Time      date := v_Shift_End;
  
    v_Datetime_1 date := to_date('01.01.2023 09:30', 'dd.mm.yyyy hh24:mi');
  begin
    -- prepare
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 1,
               i_Track_Datetime => v_Datetime_1,
               i_Track_Type     => Htt_Pref.c_Track_Type_Check,
               i_Trans_Input    => 'N',
               i_Trans_Output   => 'N');
  
    -- execute
    Htt_Core.Transform_Check_Tracks(p_Tracks           => v_Tracks,
                                    p_Trans_Tracks     => v_Trans_Tracks,
                                    i_Company_Id       => c_Company_Head,
                                    i_Filial_Id        => c_Filial_Head,
                                    i_Schedule_Kind    => Htt_Pref.c_Schedule_Kind_Flexible,
                                    i_Shift_Begin_Time => v_Shift_Begin,
                                    i_Shift_End_Time   => v_Shift_End,
                                    i_Input_Border     => v_Input_Border,
                                    i_Output_Border    => v_Output_Border,
                                    i_End_Time         => v_End_Time);
  
    -- assert
    Ut.Expect(v_Tracks.Count).To_Equal(1);
    Ut.Expect(v_Trans_Tracks.Count).To_Equal(0);
  
    Assert_Track(i_Track          => v_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Datetime_1,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Check,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'N');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Test_033 is
    v_Tracks       Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
    v_Trans_Tracks Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
  
    v_Merger_Interval interval day to second := Numtodsinterval(Htt_Pref.c_Default_Merge_Border,
                                                                'second');
  
    v_Shift_Begin   date := to_date('01.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Shift_End     date := to_date('02.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Input_Border  date := v_Shift_Begin - v_Merger_Interval;
    v_Output_Border date := v_Shift_End + v_Merger_Interval;
    v_End_Time      date := v_Shift_End;
  
    v_Datetime_1 date := to_date('01.01.2023 09:30', 'dd.mm.yyyy hh24:mi');
  begin
    -- prepare
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 1,
               i_Track_Datetime => v_Datetime_1,
               i_Track_Type     => Htt_Pref.c_Track_Type_Check,
               i_Trans_Input    => 'N',
               i_Trans_Output   => 'Y');
  
    -- execute
    Htt_Core.Transform_Check_Tracks(p_Tracks           => v_Tracks,
                                    p_Trans_Tracks     => v_Trans_Tracks,
                                    i_Company_Id       => c_Company_Head,
                                    i_Filial_Id        => c_Filial_Head,
                                    i_Schedule_Kind    => Htt_Pref.c_Schedule_Kind_Flexible,
                                    i_Shift_Begin_Time => v_Shift_Begin,
                                    i_Shift_End_Time   => v_Shift_End,
                                    i_Input_Border     => v_Input_Border,
                                    i_Output_Border    => v_Output_Border,
                                    i_End_Time         => v_End_Time);
  
    -- assert
    Ut.Expect(v_Tracks.Count).To_Equal(1);
    Ut.Expect(v_Trans_Tracks.Count).To_Equal(1);
  
    Assert_Track(i_Track          => v_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Datetime_1,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Output,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'Y');
  
    Assert_Track(i_Track          => v_Trans_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Datetime_1,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Output,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'Y');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Test_034 is
    v_Tracks       Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
    v_Trans_Tracks Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
  
    v_Merger_Interval interval day to second := Numtodsinterval(Htt_Pref.c_Default_Merge_Border,
                                                                'second');
  
    v_Shift_Begin   date := to_date('01.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Shift_End     date := to_date('02.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Input_Border  date := v_Shift_Begin - v_Merger_Interval;
    v_Output_Border date := v_Shift_End + v_Merger_Interval;
    v_End_Time      date := v_Shift_End;
  
    v_Datetime_1 date := to_date('01.01.2023 09:30', 'dd.mm.yyyy hh24:mi');
    v_Datetime_2 date := to_date('01.01.2023 09:45', 'dd.mm.yyyy hh24:mi');
  begin
    -- prepare
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 1,
               i_Track_Datetime => v_Datetime_1,
               i_Track_Type     => Htt_Pref.c_Track_Type_Input,
               i_Trans_Input    => 'N',
               i_Trans_Output   => 'N');
  
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 2,
               i_Track_Datetime => v_Datetime_2,
               i_Track_Type     => Htt_Pref.c_Track_Type_Check,
               i_Trans_Input    => 'N',
               i_Trans_Output   => 'Y');
  
    -- execute
    Htt_Core.Transform_Check_Tracks(p_Tracks           => v_Tracks,
                                    p_Trans_Tracks     => v_Trans_Tracks,
                                    i_Company_Id       => c_Company_Head,
                                    i_Filial_Id        => c_Filial_Head,
                                    i_Schedule_Kind    => Htt_Pref.c_Schedule_Kind_Flexible,
                                    i_Shift_Begin_Time => v_Shift_Begin,
                                    i_Shift_End_Time   => v_Shift_End,
                                    i_Input_Border     => v_Input_Border,
                                    i_Output_Border    => v_Output_Border,
                                    i_End_Time         => v_End_Time);
  
    -- assert
    Ut.Expect(v_Tracks.Count).To_Equal(2);
    Ut.Expect(v_Trans_Tracks.Count).To_Equal(1);
  
    Assert_Track(i_Track          => v_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Datetime_1,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Input,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'N');
  
    Assert_Track(i_Track          => v_Tracks(2),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 2,
                 i_Track_Datetime => v_Datetime_2,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Output,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'Y');
  
    Assert_Track(i_Track          => v_Trans_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 2,
                 i_Track_Datetime => v_Datetime_2,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Output,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'Y');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Test_035 is
    v_Tracks       Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
    v_Trans_Tracks Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
  
    v_Merger_Interval interval day to second := Numtodsinterval(Htt_Pref.c_Default_Merge_Border,
                                                                'second');
  
    v_Shift_Begin   date := to_date('01.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Shift_End     date := to_date('02.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Input_Border  date := v_Shift_Begin - v_Merger_Interval;
    v_Output_Border date := v_Shift_End + v_Merger_Interval;
    v_End_Time      date := v_Shift_End;
  
    v_Datetime_1 date := to_date('01.01.2023 09:30', 'dd.mm.yyyy hh24:mi');
    v_Datetime_2 date := to_date('01.01.2023 09:45', 'dd.mm.yyyy hh24:mi');
  begin
    -- prepare
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 1,
               i_Track_Datetime => v_Datetime_1,
               i_Track_Type     => Htt_Pref.c_Track_Type_Output,
               i_Trans_Input    => 'N',
               i_Trans_Output   => 'N');
  
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 2,
               i_Track_Datetime => v_Datetime_2,
               i_Track_Type     => Htt_Pref.c_Track_Type_Check,
               i_Trans_Input    => 'N',
               i_Trans_Output   => 'Y');
  
    -- execute
    Htt_Core.Transform_Check_Tracks(p_Tracks           => v_Tracks,
                                    p_Trans_Tracks     => v_Trans_Tracks,
                                    i_Company_Id       => c_Company_Head,
                                    i_Filial_Id        => c_Filial_Head,
                                    i_Schedule_Kind    => Htt_Pref.c_Schedule_Kind_Flexible,
                                    i_Shift_Begin_Time => v_Shift_Begin,
                                    i_Shift_End_Time   => v_Shift_End,
                                    i_Input_Border     => v_Input_Border,
                                    i_Output_Border    => v_Output_Border,
                                    i_End_Time         => v_End_Time);
  
    -- assert
    Ut.Expect(v_Tracks.Count).To_Equal(2);
    Ut.Expect(v_Trans_Tracks.Count).To_Equal(1);
  
    Assert_Track(i_Track          => v_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Datetime_1,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Output,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'N');
  
    Assert_Track(i_Track          => v_Tracks(2),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 2,
                 i_Track_Datetime => v_Datetime_2,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Output,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'Y');
  
    Assert_Track(i_Track          => v_Trans_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 2,
                 i_Track_Datetime => v_Datetime_2,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Output,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'Y');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Test_036 is
    v_Tracks       Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
    v_Trans_Tracks Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
  
    v_Merger_Interval interval day to second := Numtodsinterval(Htt_Pref.c_Default_Merge_Border,
                                                                'second');
  
    v_Shift_Begin   date := to_date('01.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Shift_End     date := to_date('02.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Input_Border  date := v_Shift_Begin - v_Merger_Interval;
    v_Output_Border date := v_Shift_End + v_Merger_Interval;
    v_End_Time      date := v_Shift_End;
  
    v_Datetime_1 date := to_date('01.01.2023 09:30', 'dd.mm.yyyy hh24:mi');
    v_Datetime_2 date := to_date('01.01.2023 09:45', 'dd.mm.yyyy hh24:mi');
  begin
    -- prepare
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 1,
               i_Track_Datetime => v_Datetime_1,
               i_Track_Type     => Htt_Pref.c_Track_Type_Check,
               i_Trans_Input    => 'N',
               i_Trans_Output   => 'Y');
  
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 2,
               i_Track_Datetime => v_Datetime_2,
               i_Track_Type     => Htt_Pref.c_Track_Type_Check,
               i_Trans_Input    => 'N',
               i_Trans_Output   => 'N');
  
    -- execute
    Htt_Core.Transform_Check_Tracks(p_Tracks           => v_Tracks,
                                    p_Trans_Tracks     => v_Trans_Tracks,
                                    i_Company_Id       => c_Company_Head,
                                    i_Filial_Id        => c_Filial_Head,
                                    i_Schedule_Kind    => Htt_Pref.c_Schedule_Kind_Flexible,
                                    i_Shift_Begin_Time => v_Shift_Begin,
                                    i_Shift_End_Time   => v_Shift_End,
                                    i_Input_Border     => v_Input_Border,
                                    i_Output_Border    => v_Output_Border,
                                    i_End_Time         => v_End_Time);
  
    -- assert
    Ut.Expect(v_Tracks.Count).To_Equal(2);
    Ut.Expect(v_Trans_Tracks.Count).To_Equal(0);
  
    Assert_Track(i_Track          => v_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Datetime_1,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Check,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'Y');
  
    Assert_Track(i_Track          => v_Tracks(2),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 2,
                 i_Track_Datetime => v_Datetime_2,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Check,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'N');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Test_037 is
    v_Tracks       Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
    v_Trans_Tracks Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
  
    v_Merger_Interval interval day to second := Numtodsinterval(Htt_Pref.c_Default_Merge_Border,
                                                                'second');
  
    v_Shift_Begin   date := to_date('01.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Shift_End     date := to_date('02.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Input_Border  date := v_Shift_Begin - v_Merger_Interval;
    v_Output_Border date := v_Shift_End + v_Merger_Interval;
    v_End_Time      date := v_Shift_End;
  
    v_Datetime_1 date := to_date('01.01.2023 09:30', 'dd.mm.yyyy hh24:mi');
    v_Datetime_2 date := to_date('01.01.2023 09:45', 'dd.mm.yyyy hh24:mi');
  begin
    -- prepare
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 1,
               i_Track_Datetime => v_Datetime_1,
               i_Track_Type     => Htt_Pref.c_Track_Type_Check,
               i_Trans_Input    => 'N',
               i_Trans_Output   => 'Y');
  
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 2,
               i_Track_Datetime => v_Datetime_2,
               i_Track_Type     => Htt_Pref.c_Track_Type_Output,
               i_Trans_Input    => 'N',
               i_Trans_Output   => 'Y');
  
    -- execute
    Htt_Core.Transform_Check_Tracks(p_Tracks           => v_Tracks,
                                    p_Trans_Tracks     => v_Trans_Tracks,
                                    i_Company_Id       => c_Company_Head,
                                    i_Filial_Id        => c_Filial_Head,
                                    i_Schedule_Kind    => Htt_Pref.c_Schedule_Kind_Flexible,
                                    i_Shift_Begin_Time => v_Shift_Begin,
                                    i_Shift_End_Time   => v_Shift_End,
                                    i_Input_Border     => v_Input_Border,
                                    i_Output_Border    => v_Output_Border,
                                    i_End_Time         => v_End_Time);
  
    -- assert
    Ut.Expect(v_Tracks.Count).To_Equal(2);
    Ut.Expect(v_Trans_Tracks.Count).To_Equal(0);
  
    Assert_Track(i_Track          => v_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Datetime_1,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Check,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'Y');
  
    Assert_Track(i_Track          => v_Tracks(2),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 2,
                 i_Track_Datetime => v_Datetime_2,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Output,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'Y');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Test_038 is
    v_Tracks       Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
    v_Trans_Tracks Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
  
    v_Merger_Interval interval day to second := Numtodsinterval(Htt_Pref.c_Default_Merge_Border,
                                                                'second');
  
    v_Shift_Begin   date := to_date('01.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Shift_End     date := to_date('02.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Input_Border  date := v_Shift_Begin - v_Merger_Interval;
    v_Output_Border date := v_Shift_End + v_Merger_Interval;
    v_End_Time      date := v_Shift_End;
  
    v_Datetime_1 date := to_date('01.01.2023 09:30', 'dd.mm.yyyy hh24:mi');
    v_Datetime_2 date := to_date('01.01.2023 09:45', 'dd.mm.yyyy hh24:mi');
  begin
    -- prepare
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 1,
               i_Track_Datetime => v_Datetime_1,
               i_Track_Type     => Htt_Pref.c_Track_Type_Check,
               i_Trans_Input    => 'N',
               i_Trans_Output   => 'Y');
  
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 2,
               i_Track_Datetime => v_Datetime_2,
               i_Track_Type     => Htt_Pref.c_Track_Type_Input,
               i_Trans_Input    => 'N',
               i_Trans_Output   => 'Y');
  
    -- execute
    Htt_Core.Transform_Check_Tracks(p_Tracks           => v_Tracks,
                                    p_Trans_Tracks     => v_Trans_Tracks,
                                    i_Company_Id       => c_Company_Head,
                                    i_Filial_Id        => c_Filial_Head,
                                    i_Schedule_Kind    => Htt_Pref.c_Schedule_Kind_Flexible,
                                    i_Shift_Begin_Time => v_Shift_Begin,
                                    i_Shift_End_Time   => v_Shift_End,
                                    i_Input_Border     => v_Input_Border,
                                    i_Output_Border    => v_Output_Border,
                                    i_End_Time         => v_End_Time);
  
    -- assert
    Ut.Expect(v_Tracks.Count).To_Equal(2);
    Ut.Expect(v_Trans_Tracks.Count).To_Equal(0);
  
    Assert_Track(i_Track          => v_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Datetime_1,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Check,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'Y');
  
    Assert_Track(i_Track          => v_Tracks(2),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 2,
                 i_Track_Datetime => v_Datetime_2,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Input,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'Y');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Test_039 is
    v_Tracks       Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
    v_Trans_Tracks Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
  
    v_Merger_Interval interval day to second := Numtodsinterval(Htt_Pref.c_Default_Merge_Border,
                                                                'second');
  
    v_Shift_Begin   date := to_date('01.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Shift_End     date := to_date('02.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Input_Border  date := v_Shift_Begin - v_Merger_Interval;
    v_Output_Border date := v_Shift_End + v_Merger_Interval;
    v_End_Time      date := v_Shift_End;
  
    v_Datetime_1 date := to_date('02.01.2023 08:30', 'dd.mm.yyyy hh24:mi');
    v_Datetime_2 date := to_date('02.01.2023 09:10', 'dd.mm.yyyy hh24:mi');
  begin
    -- prepare
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 1,
               i_Track_Datetime => v_Datetime_1,
               i_Track_Type     => Htt_Pref.c_Track_Type_Check,
               i_Trans_Input    => 'N',
               i_Trans_Output   => 'Y');
  
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 2,
               i_Track_Datetime => v_Datetime_2,
               i_Track_Type     => Htt_Pref.c_Track_Type_Check,
               i_Trans_Input    => 'N',
               i_Trans_Output   => 'Y');
  
    -- execute
    Htt_Core.Transform_Check_Tracks(p_Tracks           => v_Tracks,
                                    p_Trans_Tracks     => v_Trans_Tracks,
                                    i_Company_Id       => c_Company_Head,
                                    i_Filial_Id        => c_Filial_Head,
                                    i_Schedule_Kind    => Htt_Pref.c_Schedule_Kind_Flexible,
                                    i_Shift_Begin_Time => v_Shift_Begin,
                                    i_Shift_End_Time   => v_Shift_End,
                                    i_Input_Border     => v_Input_Border,
                                    i_Output_Border    => v_Output_Border,
                                    i_End_Time         => v_End_Time);
  
    -- assert
    Ut.Expect(v_Tracks.Count).To_Equal(2);
    Ut.Expect(v_Trans_Tracks.Count).To_Equal(1);
  
    Assert_Track(i_Track          => v_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Datetime_1,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Check,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'Y');
  
    Assert_Track(i_Track          => v_Tracks(2),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 2,
                 i_Track_Datetime => v_Shift_End,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Merger,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'Y');
  
    Assert_Track(i_Track          => v_Trans_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 2,
                 i_Track_Datetime => v_Shift_End,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Merger,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'Y');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Test_040 is
    v_Tracks       Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
    v_Trans_Tracks Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
  
    v_Merger_Interval interval day to second := Numtodsinterval(Htt_Pref.c_Default_Merge_Border,
                                                                'second');
  
    v_Shift_Begin   date := to_date('01.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Shift_End     date := to_date('02.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Input_Border  date := v_Shift_Begin - v_Merger_Interval;
    v_Output_Border date := v_Shift_End + v_Merger_Interval;
    v_End_Time      date := v_Shift_End;
  
    v_Datetime_1 date := to_date('01.01.2023 09:30', 'dd.mm.yyyy hh24:mi');
  begin
    -- prepare
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 1,
               i_Track_Datetime => v_Datetime_1,
               i_Track_Type     => Htt_Pref.c_Track_Type_Check,
               i_Trans_Input    => 'Y',
               i_Trans_Output   => 'Y');
  
    -- execute
    Htt_Core.Transform_Check_Tracks(p_Tracks           => v_Tracks,
                                    p_Trans_Tracks     => v_Trans_Tracks,
                                    i_Company_Id       => c_Company_Head,
                                    i_Filial_Id        => c_Filial_Head,
                                    i_Schedule_Kind    => Htt_Pref.c_Schedule_Kind_Flexible,
                                    i_Shift_Begin_Time => v_Shift_Begin,
                                    i_Shift_End_Time   => v_Shift_End,
                                    i_Input_Border     => v_Input_Border,
                                    i_Output_Border    => v_Output_Border,
                                    i_End_Time         => v_End_Time);
  
    -- assert
    Ut.Expect(v_Tracks.Count).To_Equal(1);
    Ut.Expect(v_Trans_Tracks.Count).To_Equal(1);
  
    Assert_Track(i_Track          => v_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Datetime_1,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Input,
                 i_Trans_Input    => 'Y',
                 i_Trans_Output   => 'Y');
  
    Assert_Track(i_Track          => v_Trans_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Datetime_1,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Input,
                 i_Trans_Input    => 'Y',
                 i_Trans_Output   => 'Y');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Test_041 is
    v_Tracks       Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
    v_Trans_Tracks Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
  
    v_Merger_Interval interval day to second := Numtodsinterval(Htt_Pref.c_Default_Merge_Border,
                                                                'second');
  
    v_Shift_Begin   date := to_date('01.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Shift_End     date := to_date('02.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Input_Border  date := v_Shift_Begin - v_Merger_Interval;
    v_Output_Border date := v_Shift_End + v_Merger_Interval;
    v_End_Time      date := v_Shift_End;
  
    v_Datetime_1 date := to_date('01.01.2023 08:58', 'dd.mm.yyyy hh24:mi');
    v_Datetime_2 date := to_date('01.01.2023 08:59', 'dd.mm.yyyy hh24:mi');
  begin
    -- prepare
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 1,
               i_Track_Datetime => v_Datetime_1,
               i_Track_Type     => Htt_Pref.c_Track_Type_Check,
               i_Trans_Input    => 'N',
               i_Trans_Output   => 'Y');
  
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 2,
               i_Track_Datetime => v_Datetime_2,
               i_Track_Type     => Htt_Pref.c_Track_Type_Check,
               i_Trans_Input    => 'N',
               i_Trans_Output   => 'Y');
  
    -- execute
    Htt_Core.Transform_Check_Tracks(p_Tracks           => v_Tracks,
                                    p_Trans_Tracks     => v_Trans_Tracks,
                                    i_Company_Id       => c_Company_Head,
                                    i_Filial_Id        => c_Filial_Head,
                                    i_Schedule_Kind    => Htt_Pref.c_Schedule_Kind_Custom,
                                    i_Shift_Begin_Time => v_Shift_Begin,
                                    i_Shift_End_Time   => v_Shift_End,
                                    i_Input_Border     => v_Input_Border,
                                    i_Output_Border    => v_Output_Border,
                                    i_End_Time         => v_End_Time);
  
    -- assert
    Ut.Expect(v_Tracks.Count).To_Equal(2);
    Ut.Expect(v_Trans_Tracks.Count).To_Equal(0);
  
    Assert_Track(i_Track          => v_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Datetime_1,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Check,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'Y');
  
    Assert_Track(i_Track          => v_Tracks(2),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 2,
                 i_Track_Datetime => v_Datetime_2,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Check,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'Y');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Test_042 is
    v_Tracks       Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
    v_Trans_Tracks Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
  
    v_Merger_Interval interval day to second := Numtodsinterval(Htt_Pref.c_Default_Merge_Border,
                                                                'second');
  
    v_Shift_Begin   date := to_date('01.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Shift_End     date := to_date('02.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
    v_Input_Border  date := v_Shift_Begin - v_Merger_Interval;
    v_Output_Border date := v_Shift_End + v_Merger_Interval;
    v_End_Time      date := v_Shift_End;
  
    v_Datetime_1 date := to_date('02.01.2023 09:01', 'dd.mm.yyyy hh24:mi');
    v_Datetime_2 date := to_date('02.01.2023 09:02', 'dd.mm.yyyy hh24:mi');
  begin
    -- prepare
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 1,
               i_Track_Datetime => v_Datetime_1,
               i_Track_Type     => Htt_Pref.c_Track_Type_Check,
               i_Trans_Input    => 'N',
               i_Trans_Output   => 'Y');
  
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 2,
               i_Track_Datetime => v_Datetime_2,
               i_Track_Type     => Htt_Pref.c_Track_Type_Check,
               i_Trans_Input    => 'N',
               i_Trans_Output   => 'Y');
  
    -- execute
    Htt_Core.Transform_Check_Tracks(p_Tracks           => v_Tracks,
                                    p_Trans_Tracks     => v_Trans_Tracks,
                                    i_Company_Id       => c_Company_Head,
                                    i_Filial_Id        => c_Filial_Head,
                                    i_Schedule_Kind    => Htt_Pref.c_Schedule_Kind_Custom,
                                    i_Shift_Begin_Time => v_Shift_Begin,
                                    i_Shift_End_Time   => v_Shift_End,
                                    i_Input_Border     => v_Input_Border,
                                    i_Output_Border    => v_Output_Border,
                                    i_End_Time         => v_End_Time);
  
    -- assert
    Ut.Expect(v_Tracks.Count).To_Equal(2);
    Ut.Expect(v_Trans_Tracks.Count).To_Equal(0);
  
    Assert_Track(i_Track          => v_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Datetime_1,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Check,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'Y');
  
    Assert_Track(i_Track          => v_Tracks(2),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 2,
                 i_Track_Datetime => v_Datetime_2,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Check,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'Y');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Test_043 is
    v_Tracks       Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
    v_Trans_Tracks Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
  
    v_Merger_Interval interval day to second := Numtodsinterval(Htt_Pref.c_Default_Merge_Border,
                                                                'second');
  
    v_Shift_Interval interval day to second := Numtodsinterval(9, 'hour');
  
    v_Curr_Date date := Trunc(sysdate);
  
    v_Shift_Begin   date := v_Curr_Date + v_Shift_Interval;
    v_Shift_End     date := v_Shift_Begin + 1;
    v_Input_Border  date := v_Shift_Begin - v_Merger_Interval;
    v_Output_Border date := v_Shift_End + v_Merger_Interval;
    v_End_Time      date := v_Shift_End;
  
    v_Datetime_1 date := v_End_Time - (5 * v_Merger_Interval);
    v_Datetime_2 date := v_End_Time - (4 * v_Merger_Interval);
  begin
    -- prepare
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 1,
               i_Track_Datetime => v_Datetime_1,
               i_Track_Type     => Htt_Pref.c_Track_Type_Check,
               i_Trans_Input    => 'Y',
               i_Trans_Output   => 'Y');
  
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 2,
               i_Track_Datetime => v_Datetime_2,
               i_Track_Type     => Htt_Pref.c_Track_Type_Check,
               i_Trans_Input    => 'Y',
               i_Trans_Output   => 'Y');
  
    -- execute
    Htt_Core.Transform_Check_Tracks(p_Tracks           => v_Tracks,
                                    p_Trans_Tracks     => v_Trans_Tracks,
                                    i_Company_Id       => c_Company_Head,
                                    i_Filial_Id        => c_Filial_Head,
                                    i_Schedule_Kind    => Htt_Pref.c_Schedule_Kind_Flexible,
                                    i_Shift_Begin_Time => v_Shift_Begin,
                                    i_Shift_End_Time   => v_Shift_End,
                                    i_Input_Border     => v_Input_Border,
                                    i_Output_Border    => v_Output_Border,
                                    i_End_Time         => v_End_Time);
  
    -- assert
    Ut.Expect(v_Tracks.Count).To_Equal(2);
    Ut.Expect(v_Trans_Tracks.Count).To_Equal(2);
  
    Assert_Track(i_Track          => v_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Datetime_1,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Input,
                 i_Trans_Input    => 'Y',
                 i_Trans_Output   => 'Y');
  
    Assert_Track(i_Track          => v_Tracks(2),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 2,
                 i_Track_Datetime => v_Datetime_2,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Potential_Output,
                 i_Trans_Input    => 'Y',
                 i_Trans_Output   => 'Y');
  
    Assert_Track(i_Track          => v_Trans_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Datetime_1,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Input,
                 i_Trans_Input    => 'Y',
                 i_Trans_Output   => 'Y');
  
    Assert_Track(i_Track          => v_Trans_Tracks(2),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 2,
                 i_Track_Datetime => v_Datetime_2,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Potential_Output,
                 i_Trans_Input    => 'Y',
                 i_Trans_Output   => 'Y');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Test_044 is
    v_Tracks       Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
    v_Trans_Tracks Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
  
    v_Merger_Interval interval day to second := Numtodsinterval(Htt_Pref.c_Default_Merge_Border,
                                                                'second');
  
    v_Shift_Begin   date := to_date('01.01.2023 00:00', 'dd.mm.yyyy hh24:mi');
    v_Shift_End     date := to_date('02.01.2023 00:00', 'dd.mm.yyyy hh24:mi');
    v_Input_Border  date := v_Shift_Begin - v_Merger_Interval;
    v_Output_Border date := v_Shift_End + v_Merger_Interval;
    v_End_Time      date := to_date('01.01.2023 18:00', 'dd.mm.yyyy hh24:mi');
  
    v_Datetime_1 date := to_date('01.01.2023 08:50', 'dd.mm.yyyy hh24:mi');
  begin
    -- prepare
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 1,
               i_Track_Datetime => v_Datetime_1,
               i_Track_Type     => Htt_Pref.c_Track_Type_Check,
               i_Trans_Input    => 'N',
               i_Trans_Output   => 'N',
               i_Trans_Check    => 'Y');
  
    -- execute
    Htt_Core.Transform_Check_Tracks(p_Tracks           => v_Tracks,
                                    p_Trans_Tracks     => v_Trans_Tracks,
                                    i_Company_Id       => c_Company_Head,
                                    i_Filial_Id        => c_Filial_Head,
                                    i_Schedule_Kind    => Htt_Pref.c_Schedule_Kind_Flexible,
                                    i_Shift_Begin_Time => v_Shift_Begin,
                                    i_Shift_End_Time   => v_Shift_End,
                                    i_Input_Border     => v_Input_Border,
                                    i_Output_Border    => v_Output_Border,
                                    i_End_Time         => v_End_Time);
  
    -- assert
    Ut.Expect(v_Tracks.Count).To_Equal(1);
    Ut.Expect(v_Trans_Tracks.Count).To_Equal(0);
  
    Assert_Track(i_Track          => v_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Datetime_1,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Check,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'N',
                 i_Trans_Check    => 'Y');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Test_045 is
    v_Tracks       Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
    v_Trans_Tracks Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
  
    v_Merger_Interval interval day to second := Numtodsinterval(Htt_Pref.c_Default_Merge_Border,
                                                                'second');
  
    v_Shift_Begin   date := to_date('01.01.2023 00:00', 'dd.mm.yyyy hh24:mi');
    v_Shift_End     date := to_date('02.01.2023 00:00', 'dd.mm.yyyy hh24:mi');
    v_Input_Border  date := v_Shift_Begin - v_Merger_Interval;
    v_Output_Border date := v_Shift_End + v_Merger_Interval;
    v_End_Time      date := v_Shift_End;
  
    v_Datetime_1 date := to_date('01.01.2023 08:50', 'dd.mm.yyyy hh24:mi');
  begin
    -- prepare
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 1,
               i_Track_Datetime => v_Datetime_1,
               i_Track_Type     => Htt_Pref.c_Track_Type_Input,
               i_Trans_Input    => 'N',
               i_Trans_Output   => 'N',
               i_Trans_Check    => 'Y');
  
    -- execute
    Htt_Core.Transform_Check_Tracks(p_Tracks           => v_Tracks,
                                    p_Trans_Tracks     => v_Trans_Tracks,
                                    i_Company_Id       => c_Company_Head,
                                    i_Filial_Id        => c_Filial_Head,
                                    i_Schedule_Kind    => Htt_Pref.c_Schedule_Kind_Flexible,
                                    i_Shift_Begin_Time => v_Shift_Begin,
                                    i_Shift_End_Time   => v_Shift_End,
                                    i_Input_Border     => v_Input_Border,
                                    i_Output_Border    => v_Output_Border,
                                    i_End_Time         => v_End_Time);
  
    -- assert
    Ut.Expect(v_Tracks.Count).To_Equal(1);
    Ut.Expect(v_Trans_Tracks.Count).To_Equal(0);
  
    Assert_Track(i_Track          => v_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Datetime_1,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Input,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'N',
                 i_Trans_Check    => 'Y');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Test_046 is
    v_Tracks       Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
    v_Trans_Tracks Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
  
    v_Merger_Interval interval day to second := Numtodsinterval(Htt_Pref.c_Default_Merge_Border,
                                                                'second');
  
    v_Shift_Begin   date := to_date('01.01.2023 00:00', 'dd.mm.yyyy hh24:mi');
    v_Shift_End     date := to_date('02.01.2023 00:00', 'dd.mm.yyyy hh24:mi');
    v_Input_Border  date := v_Shift_Begin - v_Merger_Interval;
    v_Output_Border date := v_Shift_End + v_Merger_Interval;
    v_End_Time      date := to_date('01.01.2023 08:00', 'dd.mm.yyyy hh24:mi');
  
    v_Datetime_1 date := to_date('01.01.2023 08:50', 'dd.mm.yyyy hh24:mi');
  begin
    -- prepare
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 1,
               i_Track_Datetime => v_Datetime_1,
               i_Track_Type     => Htt_Pref.c_Track_Type_Output,
               i_Trans_Input    => 'N',
               i_Trans_Output   => 'N',
               i_Trans_Check    => 'Y');
  
    -- execute
    Htt_Core.Transform_Check_Tracks(p_Tracks           => v_Tracks,
                                    p_Trans_Tracks     => v_Trans_Tracks,
                                    i_Company_Id       => c_Company_Head,
                                    i_Filial_Id        => c_Filial_Head,
                                    i_Schedule_Kind    => Htt_Pref.c_Schedule_Kind_Flexible,
                                    i_Shift_Begin_Time => v_Shift_Begin,
                                    i_Shift_End_Time   => v_Shift_End,
                                    i_Input_Border     => v_Input_Border,
                                    i_Output_Border    => v_Output_Border,
                                    i_End_Time         => v_End_Time);
  
    -- assert
    Ut.Expect(v_Tracks.Count).To_Equal(1);
    Ut.Expect(v_Trans_Tracks.Count).To_Equal(0);
  
    Assert_Track(i_Track          => v_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Datetime_1,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Output,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'N',
                 i_Trans_Check    => 'Y');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Test_047 is
    v_Tracks       Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
    v_Trans_Tracks Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
  
    v_Merger_Interval interval day to second := Numtodsinterval(Htt_Pref.c_Default_Merge_Border,
                                                                'second');
  
    v_Shift_Begin   date := sysdate - Numtodsinterval(120, 'minute');
    v_Shift_End     date := sysdate + Numtodsinterval(120, 'minute');
    v_Input_Border  date := v_Shift_Begin - v_Merger_Interval;
    v_Output_Border date := v_Shift_End + v_Merger_Interval;
    v_End_Time      date := sysdate + Numtodsinterval(60, 'minute');
  
    v_Datetime_1 date := sysdate;
  begin
    -- prepare
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 1,
               i_Track_Datetime => v_Datetime_1,
               i_Track_Type     => Htt_Pref.c_Track_Type_Output,
               i_Trans_Input    => 'N',
               i_Trans_Output   => 'N',
               i_Trans_Check    => 'Y');
  
    -- execute
    Htt_Core.Transform_Check_Tracks(p_Tracks           => v_Tracks,
                                    p_Trans_Tracks     => v_Trans_Tracks,
                                    i_Company_Id       => c_Company_Head,
                                    i_Filial_Id        => c_Filial_Head,
                                    i_Schedule_Kind    => Htt_Pref.c_Schedule_Kind_Flexible,
                                    i_Shift_Begin_Time => v_Shift_Begin,
                                    i_Shift_End_Time   => v_Shift_End,
                                    i_Input_Border     => v_Input_Border,
                                    i_Output_Border    => v_Output_Border,
                                    i_End_Time         => v_End_Time);
  
    -- assert
    Ut.Expect(v_Tracks.Count).To_Equal(1);
    Ut.Expect(v_Trans_Tracks.Count).To_Equal(1);
  
    Assert_Track(i_Track          => v_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Datetime_1,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Potential_Output,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'N',
                 i_Trans_Check    => 'Y');
  
    Assert_Track(i_Track          => v_Trans_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Datetime_1,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Potential_Output,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'N',
                 i_Trans_Check    => 'Y');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Test_048 is
    v_Tracks       Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
    v_Trans_Tracks Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
  
    v_Merger_Interval interval day to second := Numtodsinterval(Htt_Pref.c_Default_Merge_Border,
                                                                'second');
  
    v_Shift_Begin   date := to_date('01.01.2023 00:00', 'dd.mm.yyyy hh24:mi');
    v_Shift_End     date := to_date('02.01.2023 00:00', 'dd.mm.yyyy hh24:mi');
    v_Input_Border  date := v_Shift_Begin - v_Merger_Interval;
    v_Output_Border date := v_Shift_End + v_Merger_Interval;
    v_End_Time      date := v_Shift_End;
  
    v_Datetime_1 date := to_date('01.01.2023 08:50', 'dd.mm.yyyy hh24:mi');
    v_Datetime_2 date := to_date('01.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
  begin
    -- prepare
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 1,
               i_Track_Datetime => v_Datetime_1,
               i_Track_Type     => Htt_Pref.c_Track_Type_Input,
               i_Trans_Input    => 'N',
               i_Trans_Output   => 'N',
               i_Trans_Check    => 'Y');
  
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 2,
               i_Track_Datetime => v_Datetime_2,
               i_Track_Type     => Htt_Pref.c_Track_Type_Input,
               i_Trans_Input    => 'N',
               i_Trans_Output   => 'N',
               i_Trans_Check    => 'Y');
  
    -- execute
    Htt_Core.Transform_Check_Tracks(p_Tracks           => v_Tracks,
                                    p_Trans_Tracks     => v_Trans_Tracks,
                                    i_Company_Id       => c_Company_Head,
                                    i_Filial_Id        => c_Filial_Head,
                                    i_Schedule_Kind    => Htt_Pref.c_Schedule_Kind_Flexible,
                                    i_Shift_Begin_Time => v_Shift_Begin,
                                    i_Shift_End_Time   => v_Shift_End,
                                    i_Input_Border     => v_Input_Border,
                                    i_Output_Border    => v_Output_Border,
                                    i_End_Time         => v_End_Time);
  
    -- assert
    Ut.Expect(v_Tracks.Count).To_Equal(2);
    Ut.Expect(v_Trans_Tracks.Count).To_Equal(1);
  
    Assert_Track(i_Track          => v_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Datetime_1,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Check,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'N',
                 i_Trans_Check    => 'Y');
  
    Assert_Track(i_Track          => v_Tracks(2),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 2,
                 i_Track_Datetime => v_Datetime_2,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Input,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'N',
                 i_Trans_Check    => 'Y');
  
    Assert_Track(i_Track          => v_Trans_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Datetime_1,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Check,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'N',
                 i_Trans_Check    => 'Y');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Test_049 is
    v_Tracks       Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
    v_Trans_Tracks Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
  
    v_Merger_Interval interval day to second := Numtodsinterval(Htt_Pref.c_Default_Merge_Border,
                                                                'second');
  
    v_Shift_Begin   date := to_date('01.01.2023 00:00', 'dd.mm.yyyy hh24:mi');
    v_Shift_End     date := to_date('02.01.2023 00:00', 'dd.mm.yyyy hh24:mi');
    v_Input_Border  date := v_Shift_Begin - v_Merger_Interval;
    v_Output_Border date := v_Shift_End + v_Merger_Interval;
    v_End_Time      date := to_date('01.01.2023 08:00', 'dd.mm.yyyy hh24:mi');
  
    v_Datetime_1 date := to_date('01.01.2023 08:50', 'dd.mm.yyyy hh24:mi');
    v_Datetime_2 date := to_date('01.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
  begin
    -- prepare
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 1,
               i_Track_Datetime => v_Datetime_1,
               i_Track_Type     => Htt_Pref.c_Track_Type_Output,
               i_Trans_Input    => 'N',
               i_Trans_Output   => 'N',
               i_Trans_Check    => 'Y');
  
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 2,
               i_Track_Datetime => v_Datetime_2,
               i_Track_Type     => Htt_Pref.c_Track_Type_Output,
               i_Trans_Input    => 'N',
               i_Trans_Output   => 'N',
               i_Trans_Check    => 'Y');
  
    -- execute
    Htt_Core.Transform_Check_Tracks(p_Tracks           => v_Tracks,
                                    p_Trans_Tracks     => v_Trans_Tracks,
                                    i_Company_Id       => c_Company_Head,
                                    i_Filial_Id        => c_Filial_Head,
                                    i_Schedule_Kind    => Htt_Pref.c_Schedule_Kind_Flexible,
                                    i_Shift_Begin_Time => v_Shift_Begin,
                                    i_Shift_End_Time   => v_Shift_End,
                                    i_Input_Border     => v_Input_Border,
                                    i_Output_Border    => v_Output_Border,
                                    i_End_Time         => v_End_Time);
  
    -- assert
    Ut.Expect(v_Tracks.Count).To_Equal(2);
    Ut.Expect(v_Trans_Tracks.Count).To_Equal(1);
  
    Assert_Track(i_Track          => v_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Datetime_1,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Check,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'N',
                 i_Trans_Check    => 'Y');
  
    Assert_Track(i_Track          => v_Tracks(2),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 2,
                 i_Track_Datetime => v_Datetime_2,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Output,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'N',
                 i_Trans_Check    => 'Y');
  
    Assert_Track(i_Track          => v_Trans_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Datetime_1,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Check,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'N',
                 i_Trans_Check    => 'Y');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Test_050 is
    v_Tracks       Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
    v_Trans_Tracks Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
  
    v_Merger_Interval interval day to second := Numtodsinterval(Htt_Pref.c_Default_Merge_Border,
                                                                'second');
  
    v_Shift_Begin   date := to_date('01.01.2023 00:00', 'dd.mm.yyyy hh24:mi');
    v_Shift_End     date := to_date('02.01.2023 00:00', 'dd.mm.yyyy hh24:mi');
    v_Input_Border  date := v_Shift_Begin - v_Merger_Interval;
    v_Output_Border date := v_Shift_End + v_Merger_Interval;
    v_End_Time      date := to_date('01.01.2023 08:00', 'dd.mm.yyyy hh24:mi');
  
    v_Datetime_1 date := to_date('01.01.2023 08:50', 'dd.mm.yyyy hh24:mi');
    v_Datetime_2 date := to_date('01.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
  begin
    -- prepare
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 1,
               i_Track_Datetime => v_Datetime_1,
               i_Track_Type     => Htt_Pref.c_Track_Type_Input,
               i_Trans_Input    => 'N',
               i_Trans_Output   => 'N',
               i_Trans_Check    => 'Y');
  
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 2,
               i_Track_Datetime => v_Datetime_2,
               i_Track_Type     => Htt_Pref.c_Track_Type_Check,
               i_Trans_Input    => 'N',
               i_Trans_Output   => 'N',
               i_Trans_Check    => 'Y');
  
    -- execute
    Htt_Core.Transform_Check_Tracks(p_Tracks           => v_Tracks,
                                    p_Trans_Tracks     => v_Trans_Tracks,
                                    i_Company_Id       => c_Company_Head,
                                    i_Filial_Id        => c_Filial_Head,
                                    i_Schedule_Kind    => Htt_Pref.c_Schedule_Kind_Flexible,
                                    i_Shift_Begin_Time => v_Shift_Begin,
                                    i_Shift_End_Time   => v_Shift_End,
                                    i_Input_Border     => v_Input_Border,
                                    i_Output_Border    => v_Output_Border,
                                    i_End_Time         => v_End_Time);
  
    -- assert
    Ut.Expect(v_Tracks.Count).To_Equal(2);
    Ut.Expect(v_Trans_Tracks.Count).To_Equal(0);
  
    Assert_Track(i_Track          => v_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Datetime_1,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Input,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'N',
                 i_Trans_Check    => 'Y');
  
    Assert_Track(i_Track          => v_Tracks(2),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 2,
                 i_Track_Datetime => v_Datetime_2,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Check,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'N',
                 i_Trans_Check    => 'Y');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Test_051 is
    v_Tracks       Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
    v_Trans_Tracks Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
  
    v_Merger_Interval interval day to second := Numtodsinterval(Htt_Pref.c_Default_Merge_Border,
                                                                'second');
  
    v_Shift_Begin   date := to_date('01.01.2023 00:00', 'dd.mm.yyyy hh24:mi');
    v_Shift_End     date := to_date('02.01.2023 00:00', 'dd.mm.yyyy hh24:mi');
    v_Input_Border  date := v_Shift_Begin - v_Merger_Interval;
    v_Output_Border date := v_Shift_End + v_Merger_Interval;
    v_End_Time      date := to_date('01.01.2023 08:00', 'dd.mm.yyyy hh24:mi');
  
    v_Datetime_1 date := to_date('01.01.2023 08:50', 'dd.mm.yyyy hh24:mi');
    v_Datetime_2 date := to_date('01.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
  begin
    -- prepare
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 1,
               i_Track_Datetime => v_Datetime_1,
               i_Track_Type     => Htt_Pref.c_Track_Type_Output,
               i_Trans_Input    => 'N',
               i_Trans_Output   => 'N',
               i_Trans_Check    => 'Y');
  
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 2,
               i_Track_Datetime => v_Datetime_2,
               i_Track_Type     => Htt_Pref.c_Track_Type_Check,
               i_Trans_Input    => 'N',
               i_Trans_Output   => 'N',
               i_Trans_Check    => 'Y');
  
    -- execute
    Htt_Core.Transform_Check_Tracks(p_Tracks           => v_Tracks,
                                    p_Trans_Tracks     => v_Trans_Tracks,
                                    i_Company_Id       => c_Company_Head,
                                    i_Filial_Id        => c_Filial_Head,
                                    i_Schedule_Kind    => Htt_Pref.c_Schedule_Kind_Flexible,
                                    i_Shift_Begin_Time => v_Shift_Begin,
                                    i_Shift_End_Time   => v_Shift_End,
                                    i_Input_Border     => v_Input_Border,
                                    i_Output_Border    => v_Output_Border,
                                    i_End_Time         => v_End_Time);
  
    -- assert
    Ut.Expect(v_Tracks.Count).To_Equal(2);
    Ut.Expect(v_Trans_Tracks.Count).To_Equal(0);
  
    Assert_Track(i_Track          => v_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Datetime_1,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Output,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'N',
                 i_Trans_Check    => 'Y');
  
    Assert_Track(i_Track          => v_Tracks(2),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 2,
                 i_Track_Datetime => v_Datetime_2,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Check,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'N',
                 i_Trans_Check    => 'Y');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Test_052 is
    v_Tracks       Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
    v_Trans_Tracks Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
  
    v_Merger_Interval interval day to second := Numtodsinterval(Htt_Pref.c_Default_Merge_Border,
                                                                'second');
  
    v_Shift_Begin   date := sysdate - Numtodsinterval(120, 'minute');
    v_Shift_End     date := sysdate + Numtodsinterval(120, 'minute');
    v_Input_Border  date := v_Shift_Begin - v_Merger_Interval;
    v_Output_Border date := v_Shift_End + v_Merger_Interval;
    v_End_Time      date := sysdate + Numtodsinterval(60, 'minute');
  
    v_Datetime_1 date := sysdate + Numtodsinterval(5, 'minute');
    v_Datetime_2 date := sysdate + Numtodsinterval(10, 'minute');
  begin
    -- prepare
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 1,
               i_Track_Datetime => v_Datetime_1,
               i_Track_Type     => Htt_Pref.c_Track_Type_Output,
               i_Trans_Input    => 'N',
               i_Trans_Output   => 'N',
               i_Trans_Check    => 'Y');
  
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 2,
               i_Track_Datetime => v_Datetime_2,
               i_Track_Type     => Htt_Pref.c_Track_Type_Check,
               i_Trans_Input    => 'Y',
               i_Trans_Output   => 'Y',
               i_Trans_Check    => 'Y');
  
    -- execute
    Htt_Core.Transform_Check_Tracks(p_Tracks           => v_Tracks,
                                    p_Trans_Tracks     => v_Trans_Tracks,
                                    i_Company_Id       => c_Company_Head,
                                    i_Filial_Id        => c_Filial_Head,
                                    i_Schedule_Kind    => Htt_Pref.c_Schedule_Kind_Flexible,
                                    i_Shift_Begin_Time => v_Shift_Begin,
                                    i_Shift_End_Time   => v_Shift_End,
                                    i_Input_Border     => v_Input_Border,
                                    i_Output_Border    => v_Output_Border,
                                    i_End_Time         => v_End_Time);
  
    -- assert
    Ut.Expect(v_Tracks.Count).To_Equal(2);
    Ut.Expect(v_Trans_Tracks.Count).To_Equal(1);
  
    Assert_Track(i_Track          => v_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Datetime_1,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Output,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'N',
                 i_Trans_Check    => 'Y');
  
    Assert_Track(i_Track          => v_Tracks(2),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 2,
                 i_Track_Datetime => v_Datetime_2,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Potential_Output,
                 i_Trans_Input    => 'Y',
                 i_Trans_Output   => 'Y',
                 i_Trans_Check    => 'Y');
  
    Assert_Track(i_Track          => v_Trans_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 2,
                 i_Track_Datetime => v_Datetime_2,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Potential_Output,
                 i_Trans_Input    => 'Y',
                 i_Trans_Output   => 'Y',
                 i_Trans_Check    => 'Y');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Test_053 is
    v_Tracks       Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
    v_Trans_Tracks Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
  
    v_Merger_Interval interval day to second := Numtodsinterval(Htt_Pref.c_Default_Merge_Border,
                                                                'second');
  
    v_Shift_Begin   date := sysdate - Numtodsinterval(120, 'minute');
    v_Shift_End     date := sysdate + Numtodsinterval(120, 'minute');
    v_Input_Border  date := v_Shift_Begin - v_Merger_Interval;
    v_Output_Border date := v_Shift_End + v_Merger_Interval;
    v_End_Time      date := sysdate + Numtodsinterval(60, 'minute');
  
    v_Datetime_1 date := sysdate + Numtodsinterval(5, 'minute');
    v_Datetime_2 date := sysdate + Numtodsinterval(10, 'minute');
  begin
    -- prepare
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 1,
               i_Track_Datetime => v_Datetime_1,
               i_Track_Type     => Htt_Pref.c_Track_Type_Check,
               i_Trans_Input    => 'N',
               i_Trans_Output   => 'N',
               i_Trans_Check    => 'N');
  
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 2,
               i_Track_Datetime => v_Datetime_2,
               i_Track_Type     => Htt_Pref.c_Track_Type_Output,
               i_Trans_Input    => 'N',
               i_Trans_Output   => 'N',
               i_Trans_Check    => 'Y');
  
    -- execute
    Htt_Core.Transform_Check_Tracks(p_Tracks           => v_Tracks,
                                    p_Trans_Tracks     => v_Trans_Tracks,
                                    i_Company_Id       => c_Company_Head,
                                    i_Filial_Id        => c_Filial_Head,
                                    i_Schedule_Kind    => Htt_Pref.c_Schedule_Kind_Flexible,
                                    i_Shift_Begin_Time => v_Shift_Begin,
                                    i_Shift_End_Time   => v_Shift_End,
                                    i_Input_Border     => v_Input_Border,
                                    i_Output_Border    => v_Output_Border,
                                    i_End_Time         => v_End_Time);
  
    -- assert
    Ut.Expect(v_Tracks.Count).To_Equal(2);
    Ut.Expect(v_Trans_Tracks.Count).To_Equal(1);
  
    Assert_Track(i_Track          => v_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Datetime_1,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Check,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'N',
                 i_Trans_Check    => 'N');
  
    Assert_Track(i_Track          => v_Tracks(2),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 2,
                 i_Track_Datetime => v_Datetime_2,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Potential_Output,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'N',
                 i_Trans_Check    => 'Y');
  
    Assert_Track(i_Track          => v_Trans_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 2,
                 i_Track_Datetime => v_Datetime_2,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Potential_Output,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'N',
                 i_Trans_Check    => 'Y');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Test_054 is
    v_Tracks       Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
    v_Trans_Tracks Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
  
    v_Merger_Interval interval day to second := Numtodsinterval(Htt_Pref.c_Default_Merge_Border,
                                                                'second');
  
    v_Shift_Begin   date := to_date('01.01.2023 00:00', 'dd.mm.yyyy hh24:mi');
    v_Shift_End     date := to_date('02.01.2023 00:00', 'dd.mm.yyyy hh24:mi');
    v_Input_Border  date := v_Shift_Begin - v_Merger_Interval;
    v_Output_Border date := v_Shift_End + v_Merger_Interval;
    v_End_Time      date := to_date('01.01.2023 08:00', 'dd.mm.yyyy hh24:mi');
  
    v_Datetime_1 date := to_date('01.01.2023 08:50', 'dd.mm.yyyy hh24:mi');
    v_Datetime_2 date := to_date('01.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
  begin
    -- prepare
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 1,
               i_Track_Datetime => v_Datetime_1,
               i_Track_Type     => Htt_Pref.c_Track_Type_Input,
               i_Trans_Input    => 'N',
               i_Trans_Output   => 'N',
               i_Trans_Check    => 'Y');
  
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 2,
               i_Track_Datetime => v_Datetime_2,
               i_Track_Type     => Htt_Pref.c_Track_Type_Check,
               i_Trans_Input    => 'Y',
               i_Trans_Output   => 'Y',
               i_Trans_Check    => 'Y');
  
    -- execute
    Htt_Core.Transform_Check_Tracks(p_Tracks           => v_Tracks,
                                    p_Trans_Tracks     => v_Trans_Tracks,
                                    i_Company_Id       => c_Company_Head,
                                    i_Filial_Id        => c_Filial_Head,
                                    i_Schedule_Kind    => Htt_Pref.c_Schedule_Kind_Flexible,
                                    i_Shift_Begin_Time => v_Shift_Begin,
                                    i_Shift_End_Time   => v_Shift_End,
                                    i_Input_Border     => v_Input_Border,
                                    i_Output_Border    => v_Output_Border,
                                    i_End_Time         => v_End_Time);
  
    -- assert
    Ut.Expect(v_Tracks.Count).To_Equal(2);
    Ut.Expect(v_Trans_Tracks.Count).To_Equal(1);
  
    Assert_Track(i_Track          => v_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Datetime_1,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Input,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'N',
                 i_Trans_Check    => 'Y');
  
    Assert_Track(i_Track          => v_Tracks(2),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 2,
                 i_Track_Datetime => v_Datetime_2,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Output,
                 i_Trans_Input    => 'Y',
                 i_Trans_Output   => 'Y',
                 i_Trans_Check    => 'Y');
  
    Assert_Track(i_Track          => v_Trans_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 2,
                 i_Track_Datetime => v_Datetime_2,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Output,
                 i_Trans_Input    => 'Y',
                 i_Trans_Output   => 'Y',
                 i_Trans_Check    => 'Y');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Test_055 is
    v_Tracks       Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
    v_Trans_Tracks Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
  
    v_Merger_Interval interval day to second := Numtodsinterval(Htt_Pref.c_Default_Merge_Border,
                                                                'second');
  
    v_Shift_Begin   date := to_date('01.01.2023 00:00', 'dd.mm.yyyy hh24:mi');
    v_Shift_End     date := to_date('02.01.2023 00:00', 'dd.mm.yyyy hh24:mi');
    v_Input_Border  date := v_Shift_Begin - v_Merger_Interval;
    v_Output_Border date := v_Shift_End + v_Merger_Interval;
    v_End_Time      date := to_date('01.01.2023 08:00', 'dd.mm.yyyy hh24:mi');
  
    v_Datetime_1 date := to_date('01.01.2023 08:50', 'dd.mm.yyyy hh24:mi');
    v_Datetime_2 date := to_date('01.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
  begin
    -- prepare
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 1,
               i_Track_Datetime => v_Datetime_1,
               i_Track_Type     => Htt_Pref.c_Track_Type_Check,
               i_Trans_Input    => 'Y',
               i_Trans_Output   => 'Y',
               i_Trans_Check    => 'Y');
  
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 2,
               i_Track_Datetime => v_Datetime_2,
               i_Track_Type     => Htt_Pref.c_Track_Type_Output,
               i_Trans_Input    => 'N',
               i_Trans_Output   => 'N',
               i_Trans_Check    => 'Y');
  
    -- execute
    Htt_Core.Transform_Check_Tracks(p_Tracks           => v_Tracks,
                                    p_Trans_Tracks     => v_Trans_Tracks,
                                    i_Company_Id       => c_Company_Head,
                                    i_Filial_Id        => c_Filial_Head,
                                    i_Schedule_Kind    => Htt_Pref.c_Schedule_Kind_Flexible,
                                    i_Shift_Begin_Time => v_Shift_Begin,
                                    i_Shift_End_Time   => v_Shift_End,
                                    i_Input_Border     => v_Input_Border,
                                    i_Output_Border    => v_Output_Border,
                                    i_End_Time         => v_End_Time);
  
    -- assert
    Ut.Expect(v_Tracks.Count).To_Equal(2);
    Ut.Expect(v_Trans_Tracks.Count).To_Equal(1);
  
    Assert_Track(i_Track          => v_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Datetime_1,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Input,
                 i_Trans_Input    => 'Y',
                 i_Trans_Output   => 'Y',
                 i_Trans_Check    => 'Y');
  
    Assert_Track(i_Track          => v_Tracks(2),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 2,
                 i_Track_Datetime => v_Datetime_2,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Output,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'N',
                 i_Trans_Check    => 'Y');
  
    Assert_Track(i_Track          => v_Trans_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Datetime_1,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Input,
                 i_Trans_Input    => 'Y',
                 i_Trans_Output   => 'Y',
                 i_Trans_Check    => 'Y');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Test_056 is
    v_Tracks       Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
    v_Trans_Tracks Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
  
    v_Merger_Interval interval day to second := Numtodsinterval(Htt_Pref.c_Default_Merge_Border,
                                                                'second');
  
    v_Shift_Begin   date := to_date('01.01.2023 00:00', 'dd.mm.yyyy hh24:mi');
    v_Shift_End     date := to_date('02.01.2023 00:00', 'dd.mm.yyyy hh24:mi');
    v_Input_Border  date := v_Shift_Begin - v_Merger_Interval;
    v_Output_Border date := v_Shift_End + v_Merger_Interval;
    v_End_Time      date := to_date('01.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
  
    v_Datetime_1 date := to_date('01.01.2023 08:50', 'dd.mm.yyyy hh24:mi');
    v_Datetime_2 date := to_date('01.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
  begin
    -- prepare
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 1,
               i_Track_Datetime => v_Datetime_1,
               i_Track_Type     => Htt_Pref.c_Track_Type_Input,
               i_Trans_Input    => 'N',
               i_Trans_Output   => 'N',
               i_Trans_Check    => 'Y');
  
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 2,
               i_Track_Datetime => v_Datetime_2,
               i_Track_Type     => Htt_Pref.c_Track_Type_Input,
               i_Trans_Input    => 'N',
               i_Trans_Output   => 'N',
               i_Trans_Check    => 'N');
  
    -- execute
    Htt_Core.Transform_Check_Tracks(p_Tracks           => v_Tracks,
                                    p_Trans_Tracks     => v_Trans_Tracks,
                                    i_Company_Id       => c_Company_Head,
                                    i_Filial_Id        => c_Filial_Head,
                                    i_Schedule_Kind    => Htt_Pref.c_Schedule_Kind_Flexible,
                                    i_Shift_Begin_Time => v_Shift_Begin,
                                    i_Shift_End_Time   => v_Shift_End,
                                    i_Input_Border     => v_Input_Border,
                                    i_Output_Border    => v_Output_Border,
                                    i_End_Time         => v_End_Time);
  
    -- assert
    Ut.Expect(v_Tracks.Count).To_Equal(2);
    Ut.Expect(v_Trans_Tracks.Count).To_Equal(0);
  
    Assert_Track(i_Track          => v_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Datetime_1,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Input,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'N',
                 i_Trans_Check    => 'Y');
  
    Assert_Track(i_Track          => v_Tracks(2),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 2,
                 i_Track_Datetime => v_Datetime_2,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Input,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'N',
                 i_Trans_Check    => 'N');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Test_057 is
    v_Tracks       Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
    v_Trans_Tracks Htt_Pref.Timesheet_Track_Nt := Htt_Pref.Timesheet_Track_Nt();
  
    v_Merger_Interval interval day to second := Numtodsinterval(Htt_Pref.c_Default_Merge_Border,
                                                                'second');
  
    v_Shift_Begin   date := to_date('01.01.2023 00:00', 'dd.mm.yyyy hh24:mi');
    v_Shift_End     date := to_date('02.01.2023 00:00', 'dd.mm.yyyy hh24:mi');
    v_Input_Border  date := v_Shift_Begin - v_Merger_Interval;
    v_Output_Border date := v_Shift_End + v_Merger_Interval;
    v_End_Time      date := to_date('01.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
  
    v_Datetime_1 date := to_date('01.01.2023 08:50', 'dd.mm.yyyy hh24:mi');
    v_Datetime_2 date := to_date('01.01.2023 09:00', 'dd.mm.yyyy hh24:mi');
  begin
    -- prepare
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 1,
               i_Track_Datetime => v_Datetime_1,
               i_Track_Type     => Htt_Pref.c_Track_Type_Output,
               i_Trans_Input    => 'N',
               i_Trans_Output   => 'N',
               i_Trans_Check    => 'Y');
  
    Push_Track(p_Tracks         => v_Tracks,
               i_Timesheet_Id   => 1,
               i_Track_Id       => 2,
               i_Track_Datetime => v_Datetime_2,
               i_Track_Type     => Htt_Pref.c_Track_Type_Output,
               i_Trans_Input    => 'N',
               i_Trans_Output   => 'N',
               i_Trans_Check    => 'N');
  
    -- execute
    Htt_Core.Transform_Check_Tracks(p_Tracks           => v_Tracks,
                                    p_Trans_Tracks     => v_Trans_Tracks,
                                    i_Company_Id       => c_Company_Head,
                                    i_Filial_Id        => c_Filial_Head,
                                    i_Schedule_Kind    => Htt_Pref.c_Schedule_Kind_Flexible,
                                    i_Shift_Begin_Time => v_Shift_Begin,
                                    i_Shift_End_Time   => v_Shift_End,
                                    i_Input_Border     => v_Input_Border,
                                    i_Output_Border    => v_Output_Border,
                                    i_End_Time         => v_End_Time);
  
    -- assert
    Ut.Expect(v_Tracks.Count).To_Equal(2);
    Ut.Expect(v_Trans_Tracks.Count).To_Equal(0);
  
    Assert_Track(i_Track          => v_Tracks(1),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 1,
                 i_Track_Datetime => v_Datetime_1,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Output,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'N',
                 i_Trans_Check    => 'Y');
  
    Assert_Track(i_Track          => v_Tracks(2),
                 i_Timesheet_Id   => 1,
                 i_Track_Id       => 2,
                 i_Track_Datetime => v_Datetime_2,
                 i_Track_Type     => Htt_Pref.c_Track_Type_Output,
                 i_Trans_Input    => 'N',
                 i_Trans_Output   => 'N',
                 i_Trans_Check    => 'N');
  end;

end Transform_Check_Tracks;
/
