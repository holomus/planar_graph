create or replace package Ut_Vhr_Util is
  c_Gen_Year constant date := '01.01.2022';
  ---------------------------------------------------------------------------------------------------- 
  Procedure Context_Begin_With_Filial;
  ----------------------------------------------------------------------------------------------------
  Function Create_Filial
  (
    i_Company_Id    number,
    i_Filial_Id     number := Md_Next.Person_Id,
    i_Name          varchar2 := 'Test Filial',
    i_State         varchar2 := 'A',
    i_Timezone_Code varchar2 := 'Asia/Tashkent',
    i_Order_No      number := null,
    i_Photo_Sha     varchar2 := null
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Procedure Create_Filial;
  ----------------------------------------------------------------------------------------------------  
  Procedure Context_Begin;
  ----------------------------------------------------------------------------------------------------
  Function Create_Division
  (
    i_Company_Id        number,
    i_Division_Id       number := Mhr_Next.Division_Id,
    i_Filial_Id         number,
    i_Name              varchar2 := null,
    i_Parent_Id         number := null,
    i_Division_Group_Id number := null,
    i_Opened_Date       date := Trunc(sysdate),
    i_Closed_Date       date := null,
    i_State             varchar2 := 'A',
    i_Code              varchar2 := null
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Create_Job
  (
    i_Company_Id        number,
    i_Job_Id            number := Mhr_Next.Job_Id,
    i_Filial_Id         number,
    i_Name              varchar2 := null,
    i_Job_Group_Id      number := null,
    i_Expense_Coa_Id    number := null,
    i_Expense_Ref_Set   varchar2 := null,
    i_State             varchar2 := 'A',
    i_Code              varchar2 := null,
    i_c_Divisions_Exist varchar2 := 'N'
  ) return number;
  ----------------------------------------------------------------------------------------------------  
  Function Create_Location
  (
    i_Company_Id       number,
    i_Location_Id      number := null,
    i_Name             varchar2 := null,
    i_Location_Type_Id number := null,
    i_Timezone_Code    varchar2 := null,
    i_Region_Id        number := null,
    i_Address          varchar2 := null,
    i_Latlng           varchar2 := null,
    i_Accuracy         number := null,
    i_State            varchar2 := 'A',
    i_Code             varchar2 := null
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Create_Schedule_Three_Days_One_Rest
  (
    i_Company_Id number,
    i_Filial_Id  number
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Create_Employee
  (
    i_Company_Id           number,
    i_Filial_Id            number,
    i_Person_Id            number := null,
    i_First_Name           varchar2 := null,
    i_Last_Name            varchar2 := null,
    i_Middle_Name          varchar2 := null,
    i_Gender               varchar2 := null,
    i_Birthday             date := null,
    i_Photo_Sha            varchar2 := null,
    i_Tin                  varchar2 := null,
    i_Iapa                 varchar2 := null,
    i_Npin                 varchar2 := null,
    i_Region_Id            number := null,
    i_Main_Phone           varchar2 := null,
    i_Email                varchar2 := null,
    i_Address              varchar2 := null,
    i_Legal_Address        varchar2 := null,
    i_Key_Person           varchar2 := 'N',
    i_Access_All_Employees varchar2 := 'N',
    i_Code                 varchar2 := null,
    i_State                varchar2 := 'A'
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Create_Robot
  (
    i_Company_Id          number,
    i_Filial_Id           number,
    i_Robot_Id            number := Mrf_Next.Robot_Id,
    i_Name                varchar2 := null,
    i_Code                varchar2 := null,
    i_Robot_Group_Id      number := null,
    i_State               varchar2 := 'A',
    i_Division_Id         number,
    i_Job_Id              number,
    i_Opened_Date         date := c_Gen_Year,
    i_Closed_Date         date := null,
    i_Schedule_Id         number := null,
    i_Rank_Id             number := null,
    i_Labor_Function_Id   number := null,
    i_Description         varchar2 := null,
    i_Hiring_Condition    varchar2 := null,
    i_Contractual_Wage    varchar2 := 'Y',
    i_Wage_Scale_Id       number := null,
    i_Vacation_Days_Limit number := null,
    i_Indicators          Href_Pref.Indicator_Nt := Href_Pref.Indicator_Nt(),
    i_Oper_Types          Href_Pref.Oper_Type_Nt := Href_Pref.Oper_Type_Nt()
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Create_Generic_Schedule
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Schedule_Id number := Htt_Next.Schedule_Id,
    i_Name        varchar2 := null,
    i_Year        date := c_Gen_Year
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Create_Generic_Hiring_Journal
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Hire_Date    date := c_Gen_Year,
    i_Save_Journal boolean := true,
    i_Post_Journal boolean := true,
    i_Job_Id       number := null,
    i_Division_Id  number := null,
    i_Robot_Id     number := null,
    i_Employee_Id  number := null
  ) return Hpd_Pref.Hiring_Journal_Rt;
  ----------------------------------------------------------------------------------------------------
  Function Create_Transfer_Journal
  (
    i_Company_Id          number,
    i_Filial_Id           number,
    i_Journal_Date        date := Trunc(sysdate),
    i_Transfer_Begin      date := Trunc(sysdate),
    i_Transfer_End        date := null,
    i_Employee_Id         number,
    i_Schedule_Id         number := null,
    i_Vacation_Days_Limit number := null,
    i_Transfer_Reason     varchar2 := null,
    i_Transfer_Base       varchar2 := null,
    i_Robot               Hpd_Pref.Robot_Rt,
    i_Contract            Hpd_Pref.Contract_Rt := null,
    i_Indicators          Href_Pref.Indicator_Nt := null,
    i_Oper_Types          Href_Pref.Oper_Type_Nt := null,
    i_Journal_Save        boolean := true,
    i_Journal_Post        boolean := true
  ) return Hpd_Pref.Transfer_Journal_Rt;
  ----------------------------------------------------------------------------------------------------
  Function Create_Dismissal_Journal
  (
    i_Company_Id           number,
    i_Filial_Id            number,
    i_Save_Journal         boolean := true,
    i_Post_Journal         boolean := true,
    i_Staff_Id             number,
    i_Dimissal_Date        date := Trunc(sysdate),
    i_Dismisal_Reason_Id   number := null,
    i_Employment_Source_Id number := null,
    i_Base_On_Doc          varchar2 := null,
    i_Note                 varchar2 := null
  ) return Hpd_Pref.Dismissal_Journal_Rt;
  ----------------------------------------------------------------------------------------------------
  Function Create_Generic_Hired_Staff
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Hire_Date  date := c_Gen_Year
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Create_Staff_With_Basic_Data
  (
    i_Company_Id      number,
    i_Filial_Id       number,
    i_With_Agreements boolean := true,
    i_Division_Id     number := null,
    i_Employee_Id     number := null,
    i_Secondary       boolean := false
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Procedure Insert_Agreement
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Staff_Id    number,
    i_Trans_Type  varchar2,
    i_Period      date,
    i_Robot_Id    number := null,
    i_Division_Id number := null,
    i_Job_Id      number := null,
    i_Schedule_Id number := null,
    i_Days_Limit  number := null
  );
  ----------------------------------------------------------------------------------------------------
  Function Create_Time_Kind
  (
    i_Company_Id   number,
    i_Time_Kind_Id number := null,
    i_Name         varchar2 := null,
    i_Letter_Code  varchar2 := null,
    i_Digital_Code varchar2 := null,
    i_Parent_Id    number := null,
    i_Plan_Load    varchar2 := null,
    i_Requestable  varchar2 := null,
    i_Bg_Color     varchar2 := null,
    i_Color        varchar2 := null,
    i_State        varchar2 := null,
    i_Pcode        varchar2 := null
  ) return number;
  ----------------------------------------------------------------------------------------------------    
  Function Create_Request_Kind
  (
    i_Company_Id               number,
    i_Request_Kind_Id          number := null,
    i_Name                     varchar2 := null,
    i_Time_Kind_Id             number := null,
    i_Annually_Limited         varchar2 := null,
    i_Day_Count_Type           varchar2 := null,
    i_Annual_Day_Limit         varchar2 := null,
    i_User_Permitted           varchar2 := null,
    i_Allow_Unused_Time        varchar2 := null,
    i_Request_Restriction_Days varchar2 := null,
    i_State                    varchar2 := null
  ) return number;
  ----------------------------------------------------------------------------------------------------    
  Function Create_Request
  (
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Request_Id      number := null,
    i_Request_Kind_Id number := null,
    i_Staff_Id        number,
    i_Begin_Time      date := null,
    i_End_Time        date := null,
    i_Request_Type    varchar2 := null,
    i_Manager_Note    varchar2 := null,
    i_Note            varchar2 := null,
    i_Status          varchar2 := null,
    i_Barcode         varchar2 := null
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Create_Plan_Change
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Change_Id    number := null,
    i_Staff_Id     number,
    i_Change_Kind  varchar2 := null,
    i_Manager_Note varchar2 := null,
    i_Note         varchar2 := null,
    i_Status       varchar2 := null
  ) return number;
end Ut_Vhr_Util;
/
create or replace package body Ut_Vhr_Util is
  ----------------------------------------------------------------------------------------------------
  g_Filial_Id number;

  ----------------------------------------------------------------------------------------------------
  Procedure Context_Begin_With_Filial is
    v_Filial_Id number;
  begin
    Ut_Util.Context_Begin;
  
    v_Filial_Id := Create_Filial(i_Company_Id => Md_Pref.Company_Head);
  
    Biruni_Route.Context_End;
  
    Ut_Util.Context_Begin(i_Filial_Id => v_Filial_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Create_Filial
  (
    i_Company_Id    number,
    i_Filial_Id     number := Md_Next.Person_Id,
    i_Name          varchar2 := 'Test Filial',
    i_State         varchar2 := 'A',
    i_Timezone_Code varchar2 := 'Asia/Tashkent',
    i_Order_No      number := null,
    i_Photo_Sha     varchar2 := null
  ) return number is
    r_Filial Md_Filials%rowtype;
  begin
    z_Md_Filials.Init(p_Row           => r_Filial,
                      i_Company_Id    => i_Company_Id,
                      i_Filial_Id     => i_Filial_Id,
                      i_Name          => i_Name,
                      i_State         => i_State,
                      i_Timezone_Code => i_Timezone_Code,
                      i_Order_No      => i_Order_No);
  
    Md_Api.Person_Save(i_Company_Id => r_Filial.Company_Id,
                       i_Person_Id  => r_Filial.Filial_Id,
                       i_Name       => r_Filial.Name,
                       i_Photo_Sha  => i_Photo_Sha,
                       Is_Legal     => true);
  
    Md_Api.Filial_Save(r_Filial);
  
    return r_Filial.Filial_Id;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Create_Filial is
  begin
    Ut_Util.Context_Begin;
    g_Filial_Id := Create_Filial(Ui.Company_Id);
    Biruni_Route.Context_End;
  
    Ui_Context.Init(i_User_Id      => Md_Pref.User_System(Ui.Company_Id),
                    i_Project_Code => Verifix.Project_Code,
                    i_Filial_Id    => g_Filial_Id);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Context_Begin is
  begin
    Ut_Util.Context_Begin(i_Filial_Id => g_Filial_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Create_Division
  (
    i_Company_Id        number,
    i_Division_Id       number := Mhr_Next.Division_Id,
    i_Filial_Id         number,
    i_Name              varchar2 := null,
    i_Parent_Id         number := null,
    i_Division_Group_Id number := null,
    i_Opened_Date       date := Trunc(sysdate),
    i_Closed_Date       date := null,
    i_State             varchar2 := 'A',
    i_Code              varchar2 := null
  ) return number is
    r_Division Mhr_Divisions%rowtype;
  begin
    z_Mhr_Divisions.Init(p_Row               => r_Division,
                         i_Company_Id        => i_Company_Id,
                         i_Division_Id       => i_Division_Id,
                         i_Filial_Id         => i_Filial_Id,
                         i_Name              => Nvl(i_Name,
                                                    'Test Division (' || i_Division_Id || ')'),
                         i_Parent_Id         => i_Parent_Id,
                         i_Division_Group_Id => i_Division_Group_Id,
                         i_Opened_Date       => i_Opened_Date,
                         i_Closed_Date       => i_Closed_Date,
                         i_State             => i_State,
                         i_Code              => i_Code);
  
    Mhr_Api.Division_Save(r_Division);
  
    return r_Division.Division_Id;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Create_Job
  (
    i_Company_Id        number,
    i_Job_Id            number := Mhr_Next.Job_Id,
    i_Filial_Id         number,
    i_Name              varchar2 := null,
    i_Job_Group_Id      number := null,
    i_Expense_Coa_Id    number := null,
    i_Expense_Ref_Set   varchar2 := null,
    i_State             varchar2 := 'A',
    i_Code              varchar2 := null,
    i_c_Divisions_Exist varchar2 := 'N'
  ) return number is
    r_Job Mhr_Jobs%rowtype;
  begin
    z_Mhr_Jobs.Init(p_Row               => r_Job,
                    i_Company_Id        => i_Company_Id,
                    i_Job_Id            => i_Job_Id,
                    i_Filial_Id         => i_Filial_Id,
                    i_Name              => Nvl(i_Name, 'Test Job (' || i_Job_Id || ')'),
                    i_Job_Group_Id      => i_Job_Group_Id,
                    i_Expense_Coa_Id    => i_Expense_Coa_Id,
                    i_Expense_Ref_Set   => i_Expense_Ref_Set,
                    i_State             => i_State,
                    i_Code              => i_Code,
                    i_c_Divisions_Exist => i_c_Divisions_Exist);
  
    Mhr_Api.Job_Save(r_Job);
  
    return r_Job.Job_Id;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Create_Location
  (
    i_Company_Id       number,
    i_Location_Id      number := null,
    i_Name             varchar2 := null,
    i_Location_Type_Id number := null,
    i_Timezone_Code    varchar2 := null,
    i_Region_Id        number := null,
    i_Address          varchar2 := null,
    i_Latlng           varchar2 := null,
    i_Accuracy         number := null,
    i_State            varchar2 := 'A',
    i_Code             varchar2 := null
  ) return number is
    v_Location_Id number := Htt_Next.Location_Id;
    r_Location    Htt_Locations%rowtype;
  begin
    r_Location.Company_Id       := i_Company_Id;
    r_Location.Location_Id      := Nvl(i_Location_Id, v_Location_Id);
    r_Location.Name             := Nvl(i_Name, 'Test Location(' || v_Location_Id || ')');
    r_Location.Location_Type_Id := i_Location_Type_Id;
    r_Location.Timezone_Code    := i_Timezone_Code;
    r_Location.Region_Id        := i_Region_Id;
    r_Location.Address          := i_Address;
    r_Location.Latlng           := Nvl(i_Latlng, '41.31157961770429,69.24758434252');
    r_Location.Accuracy         := Nvl(i_Accuracy, 100);
    r_Location.State            := Nvl(i_State, 'A');
    r_Location.Code             := i_Code;
  
    Htt_Api.Location_Save(r_Location);
  
    return v_Location_Id;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Create_Schedule_Three_Days_One_Rest
  (
    i_Company_Id number,
    i_Filial_Id  number
  ) return number is
    v_Schedule_Id   number := Htt_Next.Schedule_Id;
    v_Schedule_Date date;
  
    -------------------------------------------------- 
    Procedure Save_Schedule_Day
    (
      i_Schedule_Date date,
      i_Is_Rest       boolean := false
    ) is
      r_Schedule_Day Htt_Schedule_Days%rowtype;
    begin
      r_Schedule_Day.Company_Id       := i_Company_Id;
      r_Schedule_Day.Filial_Id        := i_Filial_Id;
      r_Schedule_Day.Schedule_Id      := v_Schedule_Id;
      r_Schedule_Day.Schedule_Date    := i_Schedule_Date;
      r_Schedule_Day.Day_Kind         := Htt_Pref.c_Day_Kind_Rest;
      r_Schedule_Day.Shift_Begin_Time := i_Schedule_Date;
      r_Schedule_Day.Shift_End_Time   := i_Schedule_Date + interval '24' Hour;
      r_Schedule_Day.Input_Border     := i_Schedule_Date;
      r_Schedule_Day.Output_Border    := i_Schedule_Date + interval '24' Hour;
      r_Schedule_Day.Full_Time        := 0;
      r_Schedule_Day.Plan_Time        := 0;
    
      if not i_Is_Rest then
        r_Schedule_Day.Day_Kind         := Htt_Pref.c_Day_Kind_Work;
        r_Schedule_Day.Begin_Time       := i_Schedule_Date + interval '9' Hour;
        r_Schedule_Day.End_Time         := i_Schedule_Date + interval '18' Hour;
        r_Schedule_Day.Break_Enabled    := 'Y';
        r_Schedule_Day.Break_Begin_Time := i_Schedule_Date + interval '13' Hour;
        r_Schedule_Day.Break_End_Time   := i_Schedule_Date + interval '14' Hour;
        r_Schedule_Day.Full_Time        := 480;
        r_Schedule_Day.Plan_Time        := 480;
      end if;
    
      z_Htt_Schedule_Days.Save_Row(r_Schedule_Day);
    end;
  begin
    z_Htt_Schedules.Insert_One(i_Company_Id        => i_Company_Id,
                               i_Filial_Id         => i_Filial_Id,
                               i_Schedule_Id       => v_Schedule_Id,
                               i_Name              => 'Test Schedule' || ' (' || v_Schedule_Id || ' )',
                               i_Count_Late        => 'Y',
                               i_Count_Early       => 'Y',
                               i_Count_Lack        => 'Y',
                               i_Calendar_Id       => null,
                               i_Take_Holidays     => 'N',
                               i_Take_Nonworking   => 'N',
                               i_State             => 'A',
                               i_Code              => null,
                               i_Barcode           => null,
                               i_Shift             => 0,
                               i_Input_Acceptance  => 0,
                               i_Output_Acceptance => 0,
                               i_Track_Duration    => 1440);
  
    v_Schedule_Date := c_Gen_Year;
  
    Save_Schedule_Day(v_Schedule_Date);
  
    v_Schedule_Date := v_Schedule_Date + 1;
  
    Save_Schedule_Day(v_Schedule_Date);
  
    v_Schedule_Date := v_Schedule_Date + 1;
  
    Save_Schedule_Day(v_Schedule_Date, true);
  
    return v_Schedule_Id;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Create_Employee
  (
    i_Company_Id           number,
    i_Filial_Id            number,
    i_Person_Id            number := null,
    i_First_Name           varchar2 := null,
    i_Last_Name            varchar2 := null,
    i_Middle_Name          varchar2 := null,
    i_Gender               varchar2 := null,
    i_Birthday             date := null,
    i_Photo_Sha            varchar2 := null,
    i_Tin                  varchar2 := null,
    i_Iapa                 varchar2 := null,
    i_Npin                 varchar2 := null,
    i_Region_Id            number := null,
    i_Main_Phone           varchar2 := null,
    i_Email                varchar2 := null,
    i_Address              varchar2 := null,
    i_Legal_Address        varchar2 := null,
    i_Key_Person           varchar2 := 'N',
    i_Access_All_Employees varchar2 := 'N',
    i_Code                 varchar2 := null,
    i_State                varchar2 := 'A'
  ) return number is
    v_Employee Href_Pref.Employee_Rt;
  begin
    Href_Util.Person_New(o_Person               => v_Employee.Person,
                         i_Company_Id           => i_Company_Id,
                         i_Person_Id            => Coalesce(i_Person_Id, Md_Next.Person_Id),
                         i_First_Name           => Nvl(i_First_Name,
                                                       'Test Person (' || i_Person_Id || ')'),
                         i_Last_Name            => i_Last_Name,
                         i_Middle_Name          => i_Middle_Name,
                         i_Gender               => i_Gender,
                         i_Birthday             => i_Birthday,
                         i_Photo_Sha            => i_Photo_Sha,
                         i_Tin                  => i_Tin,
                         i_Iapa                 => i_Iapa,
                         i_Npin                 => i_Npin,
                         i_Region_Id            => i_Region_Id,
                         i_Main_Phone           => i_Main_Phone,
                         i_Email                => i_Email,
                         i_Address              => i_Address,
                         i_Legal_Address        => i_Legal_Address,
                         i_Key_Person           => i_Key_Person,
                         i_Access_All_Employees => i_Access_All_Employees,
                         i_State                => i_State,
                         i_Code                 => i_Code);
  
    v_Employee.Filial_Id := i_Filial_Id;
    v_Employee.State     := i_State;
  
    Href_Api.Employee_Save(v_Employee);
  
    return v_Employee.Person.Person_Id;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Create_Robot
  (
    i_Company_Id          number,
    i_Filial_Id           number,
    i_Robot_Id            number := Mrf_Next.Robot_Id,
    i_Name                varchar2 := null,
    i_Code                varchar2 := null,
    i_Robot_Group_Id      number := null,
    i_State               varchar2 := 'A',
    i_Division_Id         number,
    i_Job_Id              number,
    i_Opened_Date         date := c_Gen_Year,
    i_Closed_Date         date := null,
    i_Schedule_Id         number := null,
    i_Rank_Id             number := null,
    i_Labor_Function_Id   number := null,
    i_Description         varchar2 := null,
    i_Hiring_Condition    varchar2 := null,
    i_Contractual_Wage    varchar2 := 'Y',
    i_Wage_Scale_Id       number := null,
    i_Vacation_Days_Limit number := null,
    i_Indicators          Href_Pref.Indicator_Nt := Href_Pref.Indicator_Nt(),
    i_Oper_Types          Href_Pref.Oper_Type_Nt := Href_Pref.Oper_Type_Nt()
  ) return number is
    v_Robot Hrm_Pref.Robot_Rt;
  begin
    Hrm_Util.Robot_New(o_Robot                => v_Robot,
                       i_Company_Id           => i_Company_Id,
                       i_Filial_Id            => i_Filial_Id,
                       i_Robot_Id             => i_Robot_Id,
                       i_Name                 => Nvl(i_Name, 'Test Robot (' || i_Robot_Id || ')'),
                       i_Code                 => i_Code,
                       i_Robot_Group_Id       => i_Robot_Group_Id,
                       i_Division_Id          => i_Division_Id,
                       i_Job_Id               => i_Job_Id,
                       i_State                => i_State,
                       i_Opened_Date          => i_Opened_Date,
                       i_Closed_Date          => i_Closed_Date,
                       i_Schedule_Id          => i_Schedule_Id,
                       i_Rank_Id              => i_Rank_Id,
                       i_Vacation_Days_Limit  => i_Vacation_Days_Limit,
                       i_Labor_Function_Id    => i_Labor_Function_Id,
                       i_Description          => i_Description,
                       i_Hiring_Condition     => i_Hiring_Condition,
                       i_Contractual_Wage     => i_Contractual_Wage,
                       i_Wage_Scale_Id        => i_Wage_Scale_Id,
                       i_Allowed_Division_Ids => Array_Number());
  
    v_Robot.Indicators := i_Indicators;
    v_Robot.Oper_Types := i_Oper_Types;
  
    Hrm_Api.Robot_Save(v_Robot);
  
    return v_Robot.Robot.Robot_Id;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Create_Generic_Schedule
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Schedule_Id number := Htt_Next.Schedule_Id,
    i_Name        varchar2 := null,
    i_Year        date := c_Gen_Year
  ) return number is
    v_Schedule     Htt_Pref.Schedule_Rt;
    v_Schedule_Day Htt_Pref.Schedule_Day_Rt;
    v_Day_Marks    Htt_Pref.Schedule_Day_Marks_Rt;
    v_Pattern      Htt_Pref.Schedule_Pattern_Rt;
    v_Pattern_Day  Htt_Pref.Schedule_Pattern_Day_Rt;
  
    v_Year_Begin   date := Trunc(i_Year, 'yyyy');
    v_Year_End     date := Add_Months(v_Year_Begin, 12) - 1;
    v_Current_Date date := v_Year_Begin;
    v_Start_Date   date := Trunc(v_Year_Begin, 'iw');
    v_Year         number := Extract(year from v_Year_Begin);
  begin
    Htt_Util.Schedule_New(o_Schedule          => v_Schedule,
                          i_Company_Id        => i_Company_Id,
                          i_Filial_Id         => i_Filial_Id,
                          i_Schedule_Id       => i_Schedule_Id,
                          i_Name              => Nvl(i_Name,
                                                     'Test Schedule (' || i_Schedule_Id || ')'),
                          i_Shift             => 0,
                          i_Input_Acceptance  => 0,
                          i_Output_Acceptance => 0,
                          i_Track_Duration    => 1440,
                          i_Count_Late        => 'Y',
                          i_Count_Early       => 'Y',
                          i_Count_Lack        => 'Y',
                          i_Calendar_Id       => null,
                          i_Take_Holidays     => 'N',
                          i_Take_Nonworking   => 'N',
                          i_State             => 'A',
                          i_Code              => null,
                          i_Year              => v_Year);
  
    Htt_Util.Schedule_Pattern_New(o_Pattern        => v_Pattern,
                                  i_Schedule_Kind  => Htt_Pref.c_Schedule_Kind_Weekly,
                                  i_All_Days_Equal => 'Y',
                                  i_Count_Days     => 7);
  
    for i in 1 .. v_Pattern.Count_Days
    loop
    
      Htt_Util.Schedule_Pattern_Day_New(o_Pattern_Day      => v_Pattern_Day,
                                        i_Day_No           => i,
                                        i_Day_Kind         => Htt_Pref.c_Day_Kind_Work,
                                        i_Begin_Time       => 540,
                                        i_End_Time         => 1080,
                                        i_Break_Enabled    => 'Y',
                                        i_Break_Begin_Time => 780,
                                        i_Break_End_Time   => 840,
                                        i_Plan_Time        => 480);
      if i > 5 then
        v_Pattern_Day.Day_Kind         := Htt_Pref.c_Day_Kind_Rest;
        v_Pattern_Day.Begin_Time       := null;
        v_Pattern_Day.End_Time         := null;
        v_Pattern_Day.Break_Enabled    := null;
        v_Pattern_Day.Break_Begin_Time := null;
        v_Pattern_Day.Break_End_Time   := null;
        v_Pattern_Day.Plan_Time        := 0;
      end if;
    
      v_Pattern_Day.Pattern_Marks := Htt_Pref.Mark_Nt();
    
      Htt_Util.Schedule_Pattern_Day_Add(o_Schedule_Pattern => v_Pattern, i_Day => v_Pattern_Day);
    end loop;
  
    v_Schedule.Pattern := v_Pattern;
  
    while v_Current_Date != v_Year_End
    loop
      v_Pattern_Day := v_Pattern.Pattern_Day((v_Current_Date - v_Start_Date) mod
                                             v_Pattern.Count_Days + 1);
    
      Htt_Util.Schedule_Day_New(o_Day              => v_Schedule_Day,
                                i_Schedule_Date    => v_Current_Date,
                                i_Day_Kind         => v_Pattern_Day.Day_Kind,
                                i_Begin_Time       => v_Pattern_Day.Begin_Time,
                                i_End_Time         => v_Pattern_Day.End_Time,
                                i_Break_Enabled    => v_Pattern_Day.Break_Enabled,
                                i_Break_Begin_Time => v_Pattern_Day.Break_Begin_Time,
                                i_Break_End_Time   => v_Pattern_Day.Break_End_Time,
                                i_Plan_Time        => v_Pattern_Day.Plan_Time);
    
      Htt_Util.Schedule_Day_Add(o_Schedule => v_Schedule, i_Day => v_Schedule_Day);
    
      Htt_Util.Schedule_Day_Marks_New(o_Schedule_Day_Marks => v_Day_Marks,
                                      i_Schedule_Date      => v_Current_Date);
      v_Day_Marks.Marks := v_Pattern_Day.Pattern_Marks;
    
      Htt_Util.Schedule_Day_Marks_Add(o_Schedule => v_Schedule, i_Day_Marks => v_Day_Marks);
    
      v_Current_Date := v_Current_Date + 1;
    end loop;
  
    Htt_Api.Schedule_Save(v_Schedule);
  
    return v_Schedule.Schedule_Id;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Create_Generic_Hiring_Journal
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Hire_Date    date := c_Gen_Year,
    i_Save_Journal boolean := true,
    i_Post_Journal boolean := true,
    i_Job_Id       number := null,
    i_Division_Id  number := null,
    i_Robot_Id     number := null,
    i_Employee_Id  number := null
  ) return Hpd_Pref.Hiring_Journal_Rt is
    v_Robot       Hpd_Pref.Robot_Rt;
    v_Contract    Hpd_Pref.Contract_Rt;
    v_Journal     Hpd_Pref.Hiring_Journal_Rt;
    v_Division_Id number;
    v_Job_Id      number;
  begin
    Hpd_Util.Hiring_Journal_New(o_Journal         => v_Journal,
                                i_Company_Id      => i_Company_Id,
                                i_Filial_Id       => i_Filial_Id,
                                i_Journal_Id      => Hpd_Next.Journal_Id,
                                i_Journal_Type_Id => Hpd_Util.Journal_Type_Id(i_Company_Id => Ui.Company_Id,
                                                                              i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Hiring_Multiple),
                                i_Journal_Date    => i_Hire_Date,
                                i_Journal_Name    => 'Hiring Test');
  
    v_Division_Id := Nvl(i_Division_Id,
                         Create_Division(i_Company_Id => i_Company_Id, i_Filial_Id => i_Filial_Id));
    v_Job_Id      := Nvl(i_Job_Id,
                         Create_Job(i_Company_Id => i_Company_Id, i_Filial_Id => i_Filial_Id));
  
    Hpd_Util.Robot_New(o_Robot           => v_Robot,
                       i_Robot_Id        => Nvl(i_Robot_Id,
                                                Create_Robot(i_Company_Id  => i_Company_Id,
                                                             i_Filial_Id   => i_Filial_Id,
                                                             i_Division_Id => v_Division_Id,
                                                             i_Job_Id      => v_Job_Id,
                                                             i_Opened_Date => i_Hire_Date)),
                       i_Rank_Id         => null,
                       i_Division_Id     => v_Division_Id,
                       i_Job_Id          => v_Job_Id,
                       i_Employment_Type => Hpd_Pref.c_Employment_Type_Main_Job,
                       i_Fte             => 1,
                       i_Fte_Id          => Href_Util.Fte_Id(i_Company_Id => i_Company_Id,
                                                             i_Pcode      => Href_Pref.c_Pcode_Fte_Full_Time));
  
    Hpd_Util.Journal_Add_Hiring(p_Journal      => v_Journal,
                                i_Page_Id      => Hpd_Next.Page_Id,
                                i_Employee_Id  => Nvl(i_Employee_Id,
                                                      Create_Employee(i_Company_Id => i_Company_Id,
                                                                      i_Filial_Id  => i_Filial_Id)),
                                i_Staff_Number => Md_Core.Gen_Number(i_Company_Id => i_Company_Id,
                                                                     i_Filial_Id  => i_Filial_Id,
                                                                     i_Table      => Zt.Hpd_Hirings,
                                                                     i_Column     => z.Staff_Number),
                                
                                i_Hiring_Date          => i_Hire_Date,
                                i_Trial_Period         => 30,
                                i_Employment_Source_Id => null,
                                i_Schedule_Id          => Create_Generic_Schedule(i_Company_Id => i_Company_Id,
                                                                                  i_Filial_Id  => i_Filial_Id,
                                                                                  i_Year       => i_Hire_Date),
                                i_Vacation_Days_Limit  => 15,
                                i_Robot                => v_Robot,
                                i_Contract             => v_Contract,
                                i_Indicators           => Href_Pref.Indicator_Nt(),
                                i_Oper_Types           => Href_Pref.Oper_Type_Nt());
  
    if i_Save_Journal then
      Hpd_Api.Hiring_Journal_Save(v_Journal);
    end if;
  
    if i_Save_Journal and i_Post_Journal then
      Hpd_Api.Journal_Post(i_Company_Id => v_Journal.Company_Id,
                           i_Filial_Id  => v_Journal.Filial_Id,
                           i_Journal_Id => v_Journal.Journal_Id);
    end if;
  
    return v_Journal;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Create_Transfer_Journal
  (
    i_Company_Id          number,
    i_Filial_Id           number,
    i_Journal_Date        date := Trunc(sysdate),
    i_Transfer_Begin      date := Trunc(sysdate),
    i_Transfer_End        date := null,
    i_Employee_Id         number,
    i_Schedule_Id         number := null,
    i_Vacation_Days_Limit number := null,
    i_Transfer_Reason     varchar2 := null,
    i_Transfer_Base       varchar2 := null,
    i_Robot               Hpd_Pref.Robot_Rt,
    i_Contract            Hpd_Pref.Contract_Rt := null,
    i_Indicators          Href_Pref.Indicator_Nt := null,
    i_Oper_Types          Href_Pref.Oper_Type_Nt := null,
    i_Journal_Save        boolean := true,
    i_Journal_Post        boolean := true
  ) return Hpd_Pref.Transfer_Journal_Rt is
    v_Journal     Hpd_Pref.Transfer_Journal_Rt;
    v_Schedule_Id number;
  begin
    v_Schedule_Id := Create_Schedule_Three_Days_One_Rest(i_Company_Id, i_Filial_Id);
  
    Hpd_Util.Transfer_Journal_New(o_Journal         => v_Journal,
                                  i_Company_Id      => i_Company_Id,
                                  i_Filial_Id       => i_Filial_Id,
                                  i_Journal_Id      => Hpd_Next.Journal_Id,
                                  i_Journal_Type_Id => Hpd_Util.Journal_Type_Id(i_Company_Id => i_Company_Id,
                                                                                i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Transfer),
                                  i_Journal_Date    => i_Journal_Date,
                                  i_Journal_Name    => 'Test Transfer');
  
    Hpd_Util.Journal_Add_Transfer(p_Journal             => v_Journal,
                                  i_Page_Id             => Hpd_Next.Page_Id,
                                  i_Transfer_Begin      => i_Transfer_Begin,
                                  i_Transfer_End        => i_Transfer_End,
                                  i_Staff_Id            => Href_Util.Get_Primary_Staff_Id(i_Company_Id  => i_Company_Id,
                                                                                          i_Filial_Id   => i_Filial_Id,
                                                                                          i_Employee_Id => i_Employee_Id,
                                                                                          i_Date        => i_Transfer_Begin),
                                  i_Schedule_Id         => Nvl(i_Schedule_Id, v_Schedule_Id),
                                  i_Vacation_Days_Limit => i_Vacation_Days_Limit,
                                  i_Transfer_Reason     => i_Transfer_Reason,
                                  i_Transfer_Base       => i_Transfer_Base,
                                  i_Robot               => i_Robot,
                                  i_Contract            => i_Contract,
                                  i_Indicators          => i_Indicators,
                                  i_Oper_Types          => i_Oper_Types);
  
    if i_Journal_Save then
      Hpd_Api.Transfer_Journal_Save(v_Journal);
    end if;
  
    if i_Journal_Save and i_Journal_Post then
      Hpd_Api.Journal_Post(i_Company_Id => v_Journal.Company_Id,
                           i_Filial_Id  => v_Journal.Filial_Id,
                           i_Journal_Id => v_Journal.Journal_Id);
    end if;
  
    return v_Journal;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Create_Dismissal_Journal
  (
    i_Company_Id           number,
    i_Filial_Id            number,
    i_Save_Journal         boolean := true,
    i_Post_Journal         boolean := true,
    i_Staff_Id             number,
    i_Dimissal_Date        date := Trunc(sysdate),
    i_Dismisal_Reason_Id   number := null,
    i_Employment_Source_Id number := null,
    i_Base_On_Doc          varchar2 := null,
    i_Note                 varchar2 := null
  ) return Hpd_Pref.Dismissal_Journal_Rt is
    v_Journal Hpd_Pref.Dismissal_Journal_Rt;
  begin
    Hpd_Util.Dismissal_Journal_New(o_Journal         => v_Journal,
                                   i_Company_Id      => i_Company_Id,
                                   i_Filial_Id       => i_Filial_Id,
                                   i_Journal_Id      => Hpd_Next.Journal_Id,
                                   i_Journal_Type_Id => Hpd_Util.Journal_Type_Id(i_Company_Id => Ui.Company_Id,
                                                                                 i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Dismissal),
                                   i_Journal_Date    => Trunc(sysdate),
                                   i_Journal_Name    => 'Test Journal');
  
    Hpd_Util.Journal_Add_Dismissal(p_Journal              => v_Journal,
                                   i_Page_Id              => Hpd_Next.Page_Id,
                                   i_Staff_Id             => i_Staff_Id,
                                   i_Dismissal_Date       => i_Dimissal_Date,
                                   i_Dismissal_Reason_Id  => i_Dismisal_Reason_Id,
                                   i_Employment_Source_Id => i_Employment_Source_Id,
                                   i_Based_On_Doc         => i_Base_On_Doc,
                                   i_Note                 => i_Note);
  
    if i_Save_Journal then
      Hpd_Api.Dismissal_Journal_Save(v_Journal);
    end if;
  
    if i_Save_Journal and i_Post_Journal then
      Hpd_Api.Journal_Post(i_Company_Id => v_Journal.Company_Id,
                           i_Filial_Id  => v_Journal.Filial_Id,
                           i_Journal_Id => v_Journal.Journal_Id);
    end if;
  
    return v_Journal;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Create_Generic_Hired_Staff
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Hire_Date  date := c_Gen_Year
  ) return number is
    v_Journal  Hpd_Pref.Hiring_Journal_Rt;
    v_Staff_Id number;
  begin
    v_Journal := Create_Generic_Hiring_Journal(i_Company_Id => i_Company_Id,
                                               i_Filial_Id  => i_Filial_Id,
                                               i_Hire_Date  => i_Hire_Date);
  
    select Jp.Staff_Id
      into v_Staff_Id
      from Hpd_Journal_Pages Jp
     where Jp.Company_Id = v_Journal.Company_Id
       and Jp.Filial_Id = v_Journal.Filial_Id
       and Jp.Journal_Id = v_Journal.Journal_Id
       and Rownum = 1;
  
    return v_Staff_Id;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Insert_Agreement
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Staff_Id    number,
    i_Trans_Type  varchar2,
    i_Period      date,
    i_Robot_Id    number := null,
    i_Division_Id number := null,
    i_Job_Id      number := null,
    i_Schedule_Id number := null,
    i_Days_Limit  number := null
  ) is
    v_Journal_Id number := Hpd_Next.Journal_Id;
    v_Page_Id    number := Hpd_Next.Page_Id;
    v_Trans_Id   number := Hpd_Next.Trans_Id;
  begin
    z_Hpd_Journals.Insert_One(i_Company_Id      => i_Company_Id,
                              i_Filial_Id       => i_Filial_Id,
                              i_Journal_Id      => v_Journal_Id,
                              i_Journal_Type_Id => Hpd_Util.Journal_Type_Id(i_Company_Id => i_Company_Id,
                                                                            i_Pcode      => Hpd_Pref.c_Pcode_Journal_Type_Hiring),
                              i_Journal_Number  => 'not a number',
                              i_Journal_Date    => Trunc(sysdate),
                              i_Journal_Name    => 'not a name',
                              i_Posted          => 'Y');
  
    z_Hpd_Journal_Pages.Insert_One(i_Company_Id  => i_Company_Id,
                                   i_Filial_Id   => i_Filial_Id,
                                   i_Journal_Id  => v_Journal_Id,
                                   i_Page_Id     => v_Page_Id,
                                   i_Employee_Id => Href_Util.Get_Employee_Id(i_Company_Id => i_Company_Id,
                                                                              i_Filial_Id  => i_Filial_Id,
                                                                              i_Staff_Id   => i_Staff_Id),
                                   i_Staff_Id    => i_Staff_Id);
  
    z_Hpd_Transactions.Insert_One(i_Company_Id => i_Company_Id,
                                  i_Filial_Id  => i_Filial_Id,
                                  i_Trans_Id   => v_Trans_Id,
                                  i_Staff_Id   => i_Staff_Id,
                                  i_Trans_Type => i_Trans_Type,
                                  i_Begin_Date => i_Period,
                                  i_Order_No   => 1,
                                  i_Journal_Id => v_Journal_Id,
                                  i_Page_Id    => v_Page_Id,
                                  i_Tag        => 'Test Tag',
                                  i_Event      => Hpd_Pref.c_Transaction_Event_In_Progress);
  
    case i_Trans_Type
      when Hpd_Pref.c_Transaction_Type_Robot then
        z_Hpd_Trans_Robots.Insert_One(i_Company_Id       => i_Company_Id,
                                      i_Filial_Id        => i_Filial_Id,
                                      i_Trans_Id         => v_Trans_Id,
                                      i_Robot_Id         => i_Robot_Id,
                                      i_Division_Id      => i_Division_Id,
                                      i_Job_Id           => i_Job_Id,
                                      i_Employment_Type  => Hpd_Pref.c_Employment_Type_Main_Job,
                                      i_Fte              => 1,
                                      i_Contractual_Wage => 'Y');
      when Hpd_Pref.c_Transaction_Type_Schedule then
        z_Hpd_Trans_Schedules.Insert_One(i_Company_Id  => i_Company_Id,
                                         i_Filial_Id   => i_Filial_Id,
                                         i_Trans_Id    => v_Trans_Id,
                                         i_Schedule_Id => i_Schedule_Id);
      when Hpd_Pref.c_Transaction_Type_Vacation_Limit then
        z_Hpd_Trans_Vacation_Limits.Insert_One(i_Company_Id => i_Company_Id,
                                               i_Filial_Id  => i_Filial_Id,
                                               i_Trans_Id   => v_Trans_Id,
                                               i_Days_Limit => i_Days_Limit);
      else
        null;
    end case;
  
    z_Hpd_Agreements.Insert_One(i_Company_Id => i_Company_Id,
                                i_Filial_Id  => i_Filial_Id,
                                i_Staff_Id   => i_Staff_Id,
                                i_Trans_Type => i_Trans_Type,
                                i_Period     => i_Period,
                                i_Trans_Id   => v_Trans_Id,
                                i_Action     => Hpd_Pref.c_Transaction_Action_Continue);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Create_Staff_With_Basic_Data
  (
    i_Company_Id      number,
    i_Filial_Id       number,
    i_With_Agreements boolean := true,
    i_Division_Id     number := null,
    i_Employee_Id     number := null,
    i_Secondary       boolean := false
  ) return number is
    v_Division_Id number;
    v_Job_Id      number;
    v_Schedule_Id number;
    v_Employee_Id number;
    v_Robot_Id    number;
    v_Staff_Id    number := Href_Next.Staff_Id;
    v_Date        date := c_Gen_Year;
  begin
    v_Division_Id := Nvl(i_Division_Id,
                         Create_Division(i_Company_Id  => i_Company_Id,
                                         i_Filial_Id   => i_Filial_Id,
                                         i_Opened_Date => v_Date));
    v_Job_Id      := Create_Job(i_Company_Id => i_Company_Id, i_Filial_Id => i_Filial_Id);
    v_Schedule_Id := Create_Schedule_Three_Days_One_Rest(i_Company_Id => i_Company_Id,
                                                         i_Filial_Id  => i_Filial_Id);
  
    if not z_Mhr_Employees.Exist(i_Company_Id  => i_Company_Id,
                                 i_Filial_Id   => i_Filial_Id,
                                 i_Employee_Id => i_Employee_Id) then
      v_Employee_Id := Create_Employee(i_Company_Id => i_Company_Id,
                                       i_Filial_Id  => i_Filial_Id,
                                       i_Person_Id  => i_Employee_Id);
    end if;
  
    v_Robot_Id := Create_Robot(i_Company_Id  => i_Company_Id,
                               i_Filial_Id   => i_Filial_Id,
                               i_Division_Id => v_Division_Id,
                               i_Job_Id      => v_Job_Id,
                               i_Opened_Date => v_Date);
  
    z_Href_Staffs.Insert_One(i_Company_Id   => i_Company_Id,
                             i_Filial_Id    => i_Filial_Id,
                             i_Staff_Id     => v_Staff_Id,
                             i_Staff_Number => Md_Core.Gen_Number(i_Company_Id => i_Company_Id,
                                                                  i_Filial_Id  => i_Filial_Id,
                                                                  i_Table      => Zt.Href_Staffs,
                                                                  i_Column     => z.Staff_Number),
                             i_Employee_Id  => v_Employee_Id,
                             i_Hiring_Date  => v_Date,
                             i_Division_Id  => v_Division_Id,
                             i_Job_Id       => v_Job_Id,
                             i_Fte          => 1,
                             i_Schedule_Id  => v_Schedule_Id,
                             i_Robot_Id     => v_Robot_Id,
                             i_Staff_Kind   => case
                                                 when not i_Secondary then
                                                  Href_Pref.c_Staff_Kind_Primary
                                                 else
                                                  Href_Pref.c_Staff_Kind_Secondary
                                               end,
                             i_State        => 'A');
  
    if i_With_Agreements then
      Insert_Agreement(i_Company_Id  => i_Company_Id,
                       i_Filial_Id   => i_Filial_Id,
                       i_Staff_Id    => v_Staff_Id,
                       i_Trans_Type  => Hpd_Pref.c_Transaction_Type_Robot,
                       i_Period      => v_Date,
                       i_Robot_Id    => v_Robot_Id,
                       i_Division_Id => v_Division_Id,
                       i_Job_Id      => v_Job_Id);
    
      Insert_Agreement(i_Company_Id  => i_Company_Id,
                       i_Filial_Id   => i_Filial_Id,
                       i_Staff_Id    => v_Staff_Id,
                       i_Trans_Type  => Hpd_Pref.c_Transaction_Type_Schedule,
                       i_Period      => v_Date,
                       i_Schedule_Id => v_Schedule_Id);
    
      Insert_Agreement(i_Company_Id => i_Company_Id,
                       i_Filial_Id  => i_Filial_Id,
                       i_Staff_Id   => v_Staff_Id,
                       i_Trans_Type => Hpd_Pref.c_Transaction_Type_Vacation_Limit,
                       i_Period     => v_Date,
                       i_Days_Limit => 15);
    end if;
  
    return v_Staff_Id;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Create_Time_Kind
  (
    i_Company_Id   number,
    i_Time_Kind_Id number := null,
    i_Name         varchar2 := null,
    i_Letter_Code  varchar2 := null,
    i_Digital_Code varchar2 := null,
    i_Parent_Id    number := null,
    i_Plan_Load    varchar2 := null,
    i_Requestable  varchar2 := null,
    i_Bg_Color     varchar2 := null,
    i_Color        varchar2 := null,
    i_State        varchar2 := null,
    i_Pcode        varchar2 := null
  ) return number is
    v_Time_Kind_Id number := Nvl(i_Time_Kind_Id, Htt_Next.Time_Kind_Id);
  begin
    z_Htt_Time_Kinds.Insert_One(i_Company_Id   => i_Company_Id,
                                i_Time_Kind_Id => v_Time_Kind_Id,
                                i_Name         => Nvl(i_Name, 'Test Time kind Name'),
                                i_Letter_Code  => Nvl(i_Letter_Code, 'TTK'),
                                i_Digital_Code => i_Digital_Code,
                                i_Parent_Id    => i_Parent_Id,
                                i_Plan_Load    => Nvl(i_Plan_Load, Htt_Pref.c_Plan_Load_Full),
                                i_Requestable  => Nvl(i_Requestable, 'Y'),
                                i_Bg_Color     => i_Bg_Color,
                                i_Color        => i_Color,
                                i_State        => Nvl(i_State, 'A'),
                                i_Pcode        => i_Pcode);
  
    return v_Time_Kind_Id;
  end;

  ----------------------------------------------------------------------------------------------------    
  Function Create_Request_Kind
  (
    i_Company_Id               number,
    i_Request_Kind_Id          number := null,
    i_Name                     varchar2 := null,
    i_Time_Kind_Id             number := null,
    i_Annually_Limited         varchar2 := null,
    i_Day_Count_Type           varchar2 := null,
    i_Annual_Day_Limit         varchar2 := null,
    i_User_Permitted           varchar2 := null,
    i_Allow_Unused_Time        varchar2 := null,
    i_Request_Restriction_Days varchar2 := null,
    i_State                    varchar2 := null
  ) return number is
    v_Request_Kind_Id number := Nvl(i_Request_Kind_Id, Htt_Next.Request_Kind_Id);
  begin
    z_Htt_Request_Kinds.Insert_One(i_Company_Id               => i_Company_Id,
                                   i_Request_Kind_Id          => v_Request_Kind_Id,
                                   i_Name                     => Nvl(i_Name,
                                                                     'Test request kind name (' ||
                                                                     v_Request_Kind_Id || ')'),
                                   i_Time_Kind_Id             => Nvl(i_Time_Kind_Id,
                                                                     Create_Time_Kind(i_Company_Id)),
                                   i_Annually_Limited         => Nvl(i_Annually_Limited, 'Y'),
                                   i_Day_Count_Type           => Nvl(i_Day_Count_Type, 'C'),
                                   i_Annual_Day_Limit         => i_Annual_Day_Limit,
                                   i_User_Permitted           => Nvl(i_User_Permitted, 'Y'),
                                   i_Allow_Unused_Time        => Nvl(i_Allow_Unused_Time, 'Y'),
                                   i_Request_Restriction_Days => i_Request_Restriction_Days,
                                   i_State                    => Nvl(i_State, 'A'));
  
    return v_Request_Kind_Id;
  end;

  ----------------------------------------------------------------------------------------------------    
  Function Create_Request
  (
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Request_Id      number := null,
    i_Request_Kind_Id number := null,
    i_Staff_Id        number,
    i_Begin_Time      date := null,
    i_End_Time        date := null,
    i_Request_Type    varchar2 := null,
    i_Manager_Note    varchar2 := null,
    i_Note            varchar2 := null,
    i_Status          varchar2 := null,
    i_Barcode         varchar2 := null
  ) return number is
    v_Request_Id number := Nvl(i_Request_Id, Htt_Next.Request_Id);
  begin
    z_Htt_Requests.Insert_One(i_Company_Id      => i_Company_Id,
                              i_Filial_Id       => i_Filial_Id,
                              i_Request_Id      => v_Request_Id,
                              i_Request_Kind_Id => Nvl(i_Request_Kind_Id,
                                                       Create_Request_Kind(i_Company_Id)),
                              i_Staff_Id        => i_Staff_Id,
                              i_Begin_Time      => Nvl(i_Begin_Time, Trunc(sysdate)),
                              i_End_Time        => Nvl(i_End_Time, Trunc(sysdate)),
                              i_Request_Type    => Nvl(i_Request_Type,
                                                       Htt_Pref.c_Request_Type_Multiple_Days),
                              i_Manager_Note    => i_Manager_Note,
                              i_Note            => i_Note,
                              i_Status          => Nvl(i_Status, Htt_Pref.c_Request_Status_New),
                              i_Barcode         => Nvl(i_Barcode, 'BARCODE'));
  
    return v_Request_Id;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Create_Plan_Change
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Change_Id    number := null,
    i_Staff_Id     number,
    i_Change_Kind  varchar2 := null,
    i_Manager_Note varchar2 := null,
    i_Note         varchar2 := null,
    i_Status       varchar2 := null
  ) return number is
    v_Change_Id number := Nvl(i_Change_Id, Htt_Next.Change_Id);
    v_Date      date := Trunc(sysdate);
  begin
    z_Htt_Timesheets.Insert_One(i_Company_Id       => i_Company_Id,
                                i_Filial_Id        => i_Filial_Id,
                                i_Timesheet_Id     => Htt_Next.Timesheet_Id,
                                i_Timesheet_Date   => v_Date,
                                i_Staff_Id         => i_Staff_Id,
                                i_Employee_Id      => Href_Util.Get_Employee_Id(i_Company_Id => i_Company_Id,
                                                                                i_Filial_Id  => i_Filial_Id,
                                                                                i_Staff_Id   => i_Staff_Id),
                                i_Schedule_Id      => Create_Generic_Schedule(i_Company_Id => i_Company_Id,
                                                                              i_Filial_Id  => i_Filial_Id),
                                i_Calendar_Id      => null,
                                i_Day_Kind         => Htt_Pref.c_Day_Kind_Rest,
                                i_Track_Duration   => 86400,
                                i_Count_Late       => 'Y',
                                i_Count_Early      => 'Y',
                                i_Count_Lack       => 'Y',
                                i_Shift_Begin_Time => sysdate,
                                i_Shift_End_Time   => sysdate + 1,
                                i_Input_Border     => sysdate,
                                i_Output_Border    => sysdate + 2,
                                i_Begin_Time       => null,
                                i_End_Time         => null,
                                i_Break_Enabled    => null,
                                i_Break_Begin_Time => null,
                                i_Break_End_Time   => null,
                                i_Plan_Time        => 0,
                                i_Full_Time        => 0,
                                i_Input_Time       => null,
                                i_Output_Time      => null,
                                i_Planned_Marks    => 0,
                                i_Done_Marks       => 0);
  
    z_Htt_Plan_Changes.Insert_One(i_Company_Id   => i_Company_Id,
                                  i_Filial_Id    => i_Filial_Id,
                                  i_Change_Id    => v_Change_Id,
                                  i_Staff_Id     => i_Staff_Id,
                                  i_Change_Kind  => Nvl(i_Change_Kind,
                                                        Htt_Pref.c_Change_Kind_Change_Plan),
                                  i_Manager_Note => i_Manager_Note,
                                  i_Note         => i_Note,
                                  i_Status       => Nvl(i_Status, 'N'));
  
    z_Htt_Change_Days.Insert_One(i_Company_Id       => i_Company_Id,
                                 i_Filial_Id        => i_Filial_Id,
                                 i_Change_Id        => v_Change_Id,
                                 i_Change_Date      => Trunc(sysdate),
                                 i_Swapped_Date     => null,
                                 i_Staff_Id         => i_Staff_Id,
                                 i_Day_Kind         => Htt_Pref.c_Day_Kind_Rest,
                                 i_Begin_Time       => null,
                                 i_End_Time         => null,
                                 i_Break_Enabled    => null,
                                 i_Break_Begin_Time => null,
                                 i_Break_End_Time   => null,
                                 i_Plan_Time        => 0,
                                 i_Full_Time        => 0);
  
    return v_Change_Id;
  end;

end Ut_Vhr_Util;
/
