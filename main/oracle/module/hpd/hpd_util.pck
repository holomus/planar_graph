create or replace package Hpd_Util is
  ----------------------------------------------------------------------------------------------------
  -- hiring
  ----------------------------------------------------------------------------------------------------
  Function Journal_View_Uri
  (
    i_Company_Id      number,
    i_Journal_Type_Id number
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Procedure Hiring_Journal_New
  (
    o_Journal         out Hpd_Pref.Hiring_Journal_Rt,
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Journal_Id      number,
    i_Journal_Type_Id number,
    i_Journal_Number  varchar2,
    i_Journal_Date    date,
    i_Journal_Name    varchar2,
    i_Lang_Code       varchar2 := null
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Journal_Add_Hiring
  (
    p_Journal              in out nocopy Hpd_Pref.Hiring_Journal_Rt,
    i_Page_Id              number,
    i_Employee_Id          number,
    i_Staff_Number         varchar2,
    i_Hiring_Date          date,
    i_Dismissal_Date       date := null,
    i_Trial_Period         number,
    i_Employment_Source_Id number,
    i_Schedule_Id          number,
    i_Vacation_Days_Limit  number,
    i_Is_Booked            varchar2,
    i_Robot                Hpd_Pref.Robot_Rt,
    i_Contract             Hpd_Pref.Contract_Rt,
    i_Cv_Contract          Hpd_Pref.Cv_Contract_Rt := null,
    i_Indicators           Href_Pref.Indicator_Nt,
    i_Oper_Types           Href_Pref.Oper_Type_Nt,
    i_Currency_Id          number := null
  );
  ----------------------------------------------------------------------------------------------------
  -- transfer
  ----------------------------------------------------------------------------------------------------
  Procedure Transfer_Journal_New
  (
    o_Journal         out Hpd_Pref.Transfer_Journal_Rt,
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Journal_Id      number,
    i_Journal_Type_Id number,
    i_Journal_Number  varchar2,
    i_Journal_Date    date,
    i_Journal_Name    varchar2,
    i_Lang_Code       varchar2 := null
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Journal_Add_Transfer
  (
    p_Journal             in out nocopy Hpd_Pref.Transfer_Journal_Rt,
    i_Page_Id             number,
    i_Transfer_Begin      date,
    i_Transfer_End        date,
    i_Staff_Id            number,
    i_Schedule_Id         number,
    i_Vacation_Days_Limit number,
    i_Is_Booked           varchar2,
    i_Transfer_Reason     varchar2,
    i_Transfer_Base       varchar2,
    i_Robot               Hpd_Pref.Robot_Rt,
    i_Contract            Hpd_Pref.Contract_Rt,
    i_Indicators          Href_Pref.Indicator_Nt,
    i_Oper_Types          Href_Pref.Oper_Type_Nt,
    i_Currency_Id         number := null
  );
  ----------------------------------------------------------------------------------------------------
  -- dismissal
  ----------------------------------------------------------------------------------------------------
  Procedure Dismissal_Journal_New
  (
    o_Journal         out Hpd_Pref.Dismissal_Journal_Rt,
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Journal_Id      number,
    i_Journal_Type_Id number,
    i_Journal_Number  varchar2,
    i_Journal_Date    date,
    i_Journal_Name    varchar2,
    i_Lang_Code       varchar2 := null
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Journal_Add_Dismissal
  (
    p_Journal              in out nocopy Hpd_Pref.Dismissal_Journal_Rt,
    i_Page_Id              number,
    i_Staff_Id             number,
    i_Dismissal_Date       date,
    i_Dismissal_Reason_Id  number,
    i_Employment_Source_Id number,
    i_Based_On_Doc         varchar2,
    i_Note                 varchar2
  );
  ----------------------------------------------------------------------------------------------------
  -- wage change
  ----------------------------------------------------------------------------------------------------
  Procedure Wage_Change_Journal_New
  (
    o_Journal         out Hpd_Pref.Wage_Change_Journal_Rt,
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Journal_Id      number,
    i_Journal_Type_Id number,
    i_Journal_Number  varchar2,
    i_Journal_Date    date,
    i_Journal_Name    varchar2,
    i_Lang_Code       varchar2 := null
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Journal_Add_Wage_Change
  (
    p_Journal     in out nocopy Hpd_Pref.Wage_Change_Journal_Rt,
    i_Page_Id     number,
    i_Staff_Id    number,
    i_Change_Date date,
    i_Indicators  Href_Pref.Indicator_Nt,
    i_Oper_Types  Href_Pref.Oper_Type_Nt,
    i_Currency_Id number := null
  );
  ----------------------------------------------------------------------------------------------------
  -- rank change
  ----------------------------------------------------------------------------------------------------
  Procedure Rank_Change_Journal_New
  (
    o_Journal         out Hpd_Pref.Rank_Change_Journal_Rt,
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Journal_Id      number,
    i_Journal_Number  varchar2,
    i_Journal_Date    date,
    i_Journal_Name    varchar2,
    i_Lang_Code       varchar2 := null,
    i_Journal_Type_Id number,
    i_Source_Table    varchar2 := null,
    i_Source_Id       number := null
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Journal_Add_Rank_Change
  (
    p_Journal     in out nocopy Hpd_Pref.Rank_Change_Journal_Rt,
    i_Page_Id     number,
    i_Staff_Id    number,
    i_Change_Date date,
    i_Rank_Id     number
  );
  ----------------------------------------------------------------------------------------------------
  -- vacation limit change
  ----------------------------------------------------------------------------------------------------
  Procedure Limit_Change_Journal_New
  (
    o_Journal        out Hpd_Pref.Limit_Change_Journal_Rt,
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Journal_Id     number,
    i_Journal_Number varchar2,
    i_Journal_Date   date,
    i_Journal_Name   varchar2,
    i_Lang_Code      varchar2 := null,
    i_Division_Id    number,
    i_Days_Limit     number,
    i_Change_Date    date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Limit_Change_Add_Page
  (
    p_Journal  in out nocopy Hpd_Pref.Limit_Change_Journal_Rt,
    i_Page_Id  number,
    i_Staff_Id number
  );
  ----------------------------------------------------------------------------------------------------
  -- schedule change
  ----------------------------------------------------------------------------------------------------
  Procedure Schedule_Change_Journal_New
  (
    o_Journal        out Hpd_Pref.Schedule_Change_Journal_Rt,
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Journal_Id     number,
    i_Journal_Number varchar2,
    i_Journal_Date   date,
    i_Journal_Name   varchar2,
    i_Division_Id    number,
    i_Begin_Date     date,
    i_End_Date       date,
    i_Lang_Code      varchar2 := null
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Journal_Add_Schedule_Change
  (
    p_Journal     in out nocopy Hpd_Pref.Schedule_Change_Journal_Rt,
    i_Page_Id     number,
    i_Staff_Id    number,
    i_Schedule_Id number
  );
  ----------------------------------------------------------------------------------------------------
  -- sick leave
  ----------------------------------------------------------------------------------------------------
  Procedure Sick_Leave_Journal_New
  (
    o_Journal         out Hpd_Pref.Sick_Leave_Journal_Rt,
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Journal_Id      number,
    i_Journal_Type_Id number,
    i_Journal_Number  varchar2,
    i_Journal_Date    date,
    i_Journal_Name    varchar2,
    i_Lang_Code       varchar2 := null
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Journal_Add_Sick_Leave
  (
    p_Journal           in out nocopy Hpd_Pref.Sick_Leave_Journal_Rt,
    i_Timeoff_Id        number,
    i_Staff_Id          number,
    i_Reason_Id         number,
    i_Coefficient       number,
    i_Sick_Leave_Number varchar2,
    i_Begin_Date        date,
    i_End_Date          date,
    i_Shas              Array_Varchar2
  );
  ----------------------------------------------------------------------------------------------------
  -- business trips
  ----------------------------------------------------------------------------------------------------
  Procedure Business_Trip_Journal_New
  (
    o_Journal         out Hpd_Pref.Business_Trip_Journal_Rt,
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Journal_Id      number,
    i_Journal_Type_Id number,
    i_Journal_Number  varchar2,
    i_Journal_Date    date,
    i_Journal_Name    varchar2,
    i_Lang_Code       varchar2 := null
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Journal_Add_Business_Trip
  (
    p_Journal    in out nocopy Hpd_Pref.Business_Trip_Journal_Rt,
    i_Timeoff_Id number,
    i_Staff_Id   number,
    i_Region_Ids Array_Number,
    i_Person_Id  number,
    i_Reason_Id  number,
    i_Begin_Date date,
    i_End_Date   date,
    i_Note       varchar2,
    i_Shas       Array_Varchar2
  );
  ----------------------------------------------------------------------------------------------------
  -- vacations
  ----------------------------------------------------------------------------------------------------
  Procedure Vacation_Journal_New
  (
    o_Journal         out Hpd_Pref.Vacation_Journal_Rt,
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Journal_Id      number,
    i_Journal_Type_Id number,
    i_Journal_Number  varchar2,
    i_Journal_Date    date,
    i_Journal_Name    varchar2,
    i_Lang_Code       varchar2 := null
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Journal_Add_Vacation
  (
    p_Journal      in out nocopy Hpd_Pref.Vacation_Journal_Rt,
    i_Timeoff_Id   number,
    i_Staff_Id     number,
    i_Time_Kind_Id number,
    i_Begin_Date   date,
    i_End_Date     date,
    i_Shas         Array_Varchar2
  );
  ----------------------------------------------------------------------------------------------------
  -- overtime
  ----------------------------------------------------------------------------------------------------
  Procedure Overtime_Add
  (
    p_Overtimes        in out nocopy Hpd_Pref.Overtime_Nt,
    i_Overtime_Date    date,
    i_Overtime_Seconds number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Journal_Add_Overtime
  (
    p_Journal     in out nocopy Hpd_Pref.Overtime_Journal_Rt,
    i_Staff_Id    number,
    i_Month       date,
    i_Overtime_Id number,
    i_Overtimes   Hpd_Pref.Overtime_Nt
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Overtime_Journal_New
  (
    o_Overtime_Journal out Hpd_Pref.Overtime_Journal_Rt,
    i_Company_Id       number,
    i_Filial_Id        number,
    i_Journal_Id       number,
    i_Journal_Number   varchar2,
    i_Journal_Date     date,
    i_Journal_Name     varchar2,
    i_Division_Id      number := null,
    i_Lang_Code        varchar2 := null
  );
  ----------------------------------------------------------------------------------------------------
  -- timebook adjustment
  ----------------------------------------------------------------------------------------------------
  Procedure Timebook_Adjustment_Journal_New
  (
    o_Journal         out Hpd_Pref.Timebook_Adjustment_Journal_Rt,
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Journal_Id      number,
    i_Journal_Number  varchar2,
    i_Journal_Date    date,
    i_Journal_Name    varchar2,
    i_Division_Id     number,
    i_Adjustment_Date date,
    i_Lang_Code       varchar2 := null
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Timebook_Adjustment_Add_Adjustment
  (
    p_Journal    in out Hpd_Pref.Timebook_Adjustment_Journal_Rt,
    i_Adjustment Hpd_Pref.Adjustment_Rt
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Adjustment_New
  (
    o_Adjustment out Hpd_Pref.Adjustment_Rt,
    i_Page_Id    number,
    i_Staff_Id   number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Adjustment_Add_Kind
  (
    p_Adjustment   in out Hpd_Pref.Adjustment_Rt,
    i_Kind         varchar2,
    i_Free_Time    number,
    i_Overtime     number,
    i_Turnout_Time number
  );
  ----------------------------------------------------------------------------------------------------
  -- journal page parts
  ----------------------------------------------------------------------------------------------------
  Procedure Robot_New
  (
    o_Robot           out Hpd_Pref.Robot_Rt,
    i_Robot_Id        number,
    i_Division_Id     number,
    i_Job_Id          number,
    i_Org_Unit_Id     number := null,
    i_Rank_Id         number := null,
    i_Allow_Rank      varchar2 := 'Y',
    i_Wage_Scale_Id   number := null,
    i_Employment_Type varchar2,
    i_Fte_Id          number,
    i_Fte             number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Contract_New
  (
    o_Contract             out Hpd_Pref.Contract_Rt,
    i_Contract_Number      varchar2,
    i_Contract_Date        date,
    i_Fixed_Term           varchar2,
    i_Expiry_Date          date,
    i_Fixed_Term_Base_Id   number,
    i_Concluding_Term      varchar2,
    i_Hiring_Conditions    varchar2,
    i_Other_Conditions     varchar2,
    i_Workplace_Equipment  varchar2,
    i_Representative_Basis varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Oper_Type_Add
  (
    p_Oper_Type     in out nocopy Href_Pref.Oper_Type_Nt,
    i_Oper_Type_Id  number,
    i_Indicator_Ids Array_Number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Indicator_Add
  (
    p_Indicator       in out nocopy Href_Pref.Indicator_Nt,
    i_Indicator_Id    number,
    i_Indicator_Value number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Cv_Contract_New
  (
    o_Contract                 out Hpd_Pref.Cv_Contract_Rt,
    i_Company_Id               number,
    i_Filial_Id                number,
    i_Contract_Id              number,
    i_Contract_Number          varchar2,
    i_Page_Id                  number := null,
    i_Division_Id              number,
    i_Person_Id                number,
    i_Begin_Date               date,
    i_End_Date                 date,
    i_Contract_Kind            varchar2,
    i_Contract_Employment_Kind varchar2,
    i_Access_To_Add_Item       varchar2,
    i_Early_Closed_Date        date := null,
    i_Early_Closed_Note        varchar2 := null,
    i_Note                     varchar2 := null
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Cv_Contract_Add_Item
  (
    o_Contract         in out nocopy Hpd_Pref.Cv_Contract_Rt,
    i_Contract_Item_Id number,
    i_Name             varchar2,
    i_Quantity         number,
    i_Amount           number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Cv_Contract_Add_File
  (
    o_Contract in out nocopy Hpd_Pref.Cv_Contract_Rt,
    i_File_Sha varchar2,
    i_Note     varchar2 := null
  );
  ----------------------------------------------------------------------------------------------------
  -- application
  ----------------------------------------------------------------------------------------------------
  Procedure Application_Create_Robot_New
  (
    o_Application    out Hpd_Pref.Application_Create_Robot_Rt,
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Application_Id number,
    i_Name           varchar2,
    i_Opened_Date    date,
    i_Division_Id    number,
    i_Job_Id         number,
    i_Quantity       number,
    i_Note           varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Application_Hiring_New
  (
    o_Application    out Hpd_Pref.Application_Hiring_Rt,
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Application_Id number,
    i_Hiring_Date    date,
    i_Robot_Id       number,
    i_Note           varchar2,
    -- person info
    i_First_Name      varchar2,
    i_Last_Name       varchar2,
    i_Middle_Name     varchar2,
    i_Birthday        date,
    i_Gender          varchar2,
    i_Phone           varchar2,
    i_Email           varchar2,
    i_Photo_Sha       varchar2,
    i_Address         varchar2,
    i_Legal_Address   varchar2,
    i_Region_Id       number,
    i_Passport_Series varchar2,
    i_Passport_Number varchar2,
    i_Npin            varchar2,
    i_Iapa            varchar2,
    i_Employment_Type varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Application_Transfer_New
  (
    o_Application    out Hpd_Pref.Application_Transfer_Rt,
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Application_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Application_Add_Transfer
  (
    o_Application         in out nocopy Hpd_Pref.Application_Transfer_Rt,
    i_Application_Unit_Id number,
    i_Staff_Id            number,
    i_Transfer_Begin      date,
    i_Robot_Id            number,
    i_Note                varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Application_Dismissal_New
  (
    o_Application         out Hpd_Pref.Application_Dismissal_Rt,
    i_Company_Id          number,
    i_Filial_Id           number,
    i_Application_Id      number,
    i_Staff_Id            number,
    i_Dismissal_Date      date,
    i_Dismissal_Reason_Id number,
    i_Note                varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Function Journal_Type_Id
  (
    i_Company_Id number,
    i_Pcode      varchar2
  ) return number Result_Cache;
  ----------------------------------------------------------------------------------------------------
  Function Is_Hiring_Journal
  (
    i_Company_Id      number,
    i_Journal_Type_Id number
  ) return boolean;
  ----------------------------------------------------------------------------------------------------
  Function Is_Contractor_Journal
  (
    i_Company_Id      number,
    i_Journal_Type_Id number
  ) return boolean;
  ----------------------------------------------------------------------------------------------------
  Function Is_Transfer_Journal
  (
    i_Company_Id      number,
    i_Journal_Type_Id number
  ) return boolean;
  ----------------------------------------------------------------------------------------------------
  Function Is_Dismissal_Journal
  (
    i_Company_Id      number,
    i_Journal_Type_Id number
  ) return boolean;
  ----------------------------------------------------------------------------------------------------
  Function Is_Wage_Change_Journal
  (
    i_Company_Id      number,
    i_Journal_Type_Id number
  ) return boolean;
  ----------------------------------------------------------------------------------------------------
  Function Is_Rank_Change_Journal
  (
    i_Company_Id      number,
    i_Journal_Type_Id number
  ) return boolean;
  ----------------------------------------------------------------------------------------------------
  Function Is_Limit_Change_Journal
  (
    i_Company_Id      number,
    i_Journal_Type_Id number
  ) return boolean;
  ----------------------------------------------------------------------------------------------------
  Function Is_Schedule_Change_Journal
  (
    i_Company_Id      number,
    i_Journal_Type_Id number
  ) return boolean;
  ----------------------------------------------------------------------------------------------------
  Function Is_Sick_Leave_Journal
  (
    i_Company_Id      number,
    i_Journal_Type_Id number
  ) return boolean;
  ----------------------------------------------------------------------------------------------------
  Function Is_Business_Trip_Journal
  (
    i_Company_Id      number,
    i_Journal_Type_Id number
  ) return boolean;
  ----------------------------------------------------------------------------------------------------
  Function Is_Vacation_Journal
  (
    i_Company_Id      number,
    i_Journal_Type_Id number
  ) return boolean;
  ----------------------------------------------------------------------------------------------------
  Function Is_Overtime_Journal
  (
    i_Company_Id      number,
    i_Journal_Type_Id number
  ) return boolean;
  ----------------------------------------------------------------------------------------------------
  Function Is_Timebook_Adjustment_Journal
  (
    i_Company_Id      number,
    i_Journal_Type_Id number
  ) return boolean;
  ----------------------------------------------------------------------------------------------------
  Function Transfer_Kind(i_Transfer_End date := null) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Cast_Staff_Kind_By_Emp_Type(i_Employment_Type varchar2) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Get_Changing_Transaction
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Trans_Type varchar2,
    i_Period     date
  ) return Hpd_Transactions%rowtype;
  ----------------------------------------------------------------------------------------------------
  Procedure Closest_Trans_Info
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Trans_Type varchar2,
    i_Period     date,
    o_Trans_Id   out number,
    o_Action     out varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Closest_Trans_Info
  (
    i_Company_Id       number,
    i_Filial_Id        number,
    i_Staff_Id         number,
    i_Trans_Type       varchar2,
    i_Period           date,
    i_Except_Jounal_Id number := null,
    o_Trans_Id         out number,
    o_Action           out varchar2,
    o_Period           out date
  );
  ----------------------------------------------------------------------------------------------------
  Function Trans_Id_By_Period
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Trans_Type varchar2,
    i_Period     date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Closest_Schedule
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Period     date
  ) return Hpd_Trans_Schedules%rowtype;
  ----------------------------------------------------------------------------------------------------
  Function Closest_Currency
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Period     date
  ) return Hpd_Trans_Currencies%rowtype;
  ----------------------------------------------------------------------------------------------------
  Function Closest_Vacation_Limit
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Period     date
  ) return Hpd_Trans_Vacation_Limits%rowtype;
  ----------------------------------------------------------------------------------------------------
  Function Closest_Rank
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Period     date
  ) return Hpd_Trans_Ranks%rowtype;
  ----------------------------------------------------------------------------------------------------
  Function Closest_Robot
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Period     date
  ) return Hpd_Trans_Robots%rowtype;
  ----------------------------------------------------------------------------------------------------
  Function Get_Closest_Contract
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Period     date
  ) return Hpd_Page_Contracts%rowtype;
  ----------------------------------------------------------------------------------------------------
  Function Get_Closest_Robot
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Period     date
  ) return Mrf_Robots%rowtype;
  ----------------------------------------------------------------------------------------------------
  Function Get_Closest_Hrm_Robot
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Period     date
  ) return Hrm_Robots%rowtype;
  ----------------------------------------------------------------------------------------------------
  Function Get_Closest_Fte
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Period     date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Get_Closest_Robot_Id
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Period     date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Get_Closest_Org_Unit_Id
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Period     date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Get_Closest_Division_Id
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Period     date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Get_Closest_Job_Id
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Period     date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Get_Closest_Rank_Id
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Period     date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Get_Closest_Schedule_Id
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Period     date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Get_Closest_Currency_Id
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Period     date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Get_Closest_Vacation_Days_Limit
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Period     date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Get_Closest_Contractual_Wage
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Period     date
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Get_Closest_Wage_Scale_Id
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Period     date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Get_Closest_Indicator_Value
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Staff_Id     number,
    i_Indicator_Id number,
    i_Period       date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Get_Closest_Oper_Type_Id
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Staff_Id      number,
    i_Oper_Group_Id number,
    i_Period        date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Get_Closest_Oper_Type_Ids
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Staff_Id      number,
    i_Oper_Group_Id number,
    i_Period        date
  ) return Array_Number;
  ----------------------------------------------------------------------------------------------------
  Function Get_Closest_Wage
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Period     date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Get_Closest_Contractual_Indicator_Value
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Staff_Id     number,
    i_Indicator_Id number,
    i_Period       date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Get_Current_Limit_Days
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Period     date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Get_Opened_Transaction_Dates
  (
    i_Company_Id        number,
    i_Filial_Id         number,
    i_Staff_Id          number,
    i_Begin_Date        date,
    i_End_Date          date,
    i_Trans_Types       Array_Varchar2,
    i_With_Wage_Scale   boolean := false,
    i_Partition_By_Year boolean := false
  ) return Hpd_Pref.Transaction_Part_Nt;
  ----------------------------------------------------------------------------------------------------
  Function Get_Trans_Code
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Trans_Id   number,
    i_Trans_Type varchar2
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Singular_Journal
  (
    i_Company_Id       number,
    i_Filial_Id        number,
    i_Journal_Id       number,
    i_Page_Id          number,
    i_Journal_Type_Id  number,
    i_Singular_Type_Id number,
    i_Pages_Cnt        number
  );
  ----------------------------------------------------------------------------------------------------
  Function Staff_Timebook_Adjustment_Calced
  (
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Staff_Id        number,
    i_Adjustment_Date date,
    i_Kind            varchar2,
    i_Journal_Id      number := null
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function User_Name
  (
    i_Company_Id number,
    i_User_Id    number
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Journal_Type_Name
  (
    i_Company_Id      number,
    i_Journal_Type_Id number
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Application_Type_Name
  (
    i_Company_Id          number,
    i_Application_Type_Id number
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Application_Type_Id
  (
    i_Company_Id number,
    i_Pcode      varchar2
  ) return number Result_Cache;
  ----------------------------------------------------------------------------------------------------
  Function Application_Has_Result
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Application_Id number
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Tname_Page(i_Page_Id number) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Tname_Overtime(i_Overtime_Id number) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Tname_Timeoffs(i_Timeoff_Id number) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Table_Uri_Journal(i_Journal_Id number) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Table_Uri_Page(i_Page_Id number) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Table_Uri_Overtime(i_Overtime_Id number) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Table_Uri_Timeoff(i_Timeoff_Id number) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Application_Grant_Part
  (
    i_Company_Id          number,
    i_Application_Type_Id number
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------           
  Function Sign_Process_Id_By_Pcode
  (
    i_Company_Id number,
    i_Pcode      varchar2
  ) return number;
  ----------------------------------------------------------------------------------------------------         
  Function Journal_Type_Sign_Template_Id
  (
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Journal_Type_Id number
  ) return number;
  ----------------------------------------------------------------------------------------------------         
  Function Has_Journal_Type_Sign_Template
  (
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Journal_Type_Id number
  ) return boolean;
  ----------------------------------------------------------------------------------------------------         
  Function Load_Sign_Document_Status
  (
    i_Company_Id  number,
    i_Document_Id number
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Employment_Type_Main_Job return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Employment_Type_External_Parttime return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Employment_Type_Internal_Parttime return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Employment_Type(i_Employment_Type varchar2) return varchar2;
  Function Employment_Types(i_Include_Contractors boolean := false) return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Lock_Interval_Kind(i_Lock_Interval_Kind varchar2) return varchar2;
  Function Lock_Interval_Kinds return Matrix_Varchar2;
  Function Charge_Lock_Interval_Kinds return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Trial_Period(i_Trial_Period varchar2) return varchar2;
  Function Trial_Periods return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Transfer_Kind(i_Transfer_Kind varchar2) return varchar2;
  Function Transfer_Kinds return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Journal_Type(i_Journal_Type varchar2) return varchar2;
  Function Journal_Types return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Fte_Kinds return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Adjustment_Kind(i_Adjustment_Kind varchar2) return varchar2;
  Function Adjustment_Kinds return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Cv_Contract_Kind(i_Contract_Kind varchar2) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Cv_Contract_Kinds return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Application_Status(i_Status varchar2) return varchar2;
  Function Application_Statuses return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Contract_Employment(i_Status varchar2) return varchar2;
  Function Contract_Employments return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  -- journal notification
  ----------------------------------------------------------------------------------------------------
  Function t_Notification_Title_Journal_Post
  (
    i_Company_Id      number,
    i_User_Id         number,
    i_Journal_Type_Id number
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Notification_Title_Journal_Unpost
  (
    i_Company_Id      number,
    i_User_Id         number,
    i_Journal_Type_Id number
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Notification_Title_Journal_Save
  (
    i_Company_Id      number,
    i_User_Id         number,
    i_Journal_Type_Id number
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Notification_Title_Journal_Update
  (
    i_Company_Id      number,
    i_User_Id         number,
    i_Journal_Type_Id number
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Notification_Title_Journal_Delete
  (
    i_Company_Id      number,
    i_User_Id         number,
    i_Journal_Type_Id number
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  -- application notification
  ----------------------------------------------------------------------------------------------------
  Function t_Notification_Title_Application_Created
  (
    i_Company_Id          number,
    i_User_Id             number,
    i_Application_Type_Id number,
    i_Application_Number  varchar2
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Notification_Title_Application_Status_Changed
  (
    i_Company_Id          number,
    i_User_Id             number,
    i_Application_Type_Id number,
    i_Application_Number  varchar2,
    i_Old_Status          varchar2,
    i_New_Status          varchar2
  ) return varchar2;
end Hpd_Util;
/
create or replace package body Hpd_Util is
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
    return b.Translate('HPD:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  -- uri of journal view forms by journal_type id
  Function Journal_View_Uri
  (
    i_Company_Id      number,
    i_Journal_Type_Id number
  ) return varchar2 is
    v_Pcode varchar2(20);
  begin
    v_Pcode := z_Hpd_Journal_Types.Take(i_Company_Id => i_Company_Id, i_Journal_Type_Id => i_Journal_Type_Id).Pcode;
  
    case v_Pcode
      when Hpd_Pref.c_Pcode_Journal_Type_Hiring then
        return Hpd_Pref.c_Form_Hiring_Journal_View;
      when Hpd_Pref.c_Pcode_Journal_Type_Hiring_Multiple then
        return Hpd_Pref.c_Form_Hiring_Multiple_View;
      when Hpd_Pref.c_Pcode_Journal_Type_Transfer then
        return Hpd_Pref.c_Form_Transfer_View;
      when Hpd_Pref.c_Pcode_Journal_Type_Transfer_Multiple then
        return Hpd_Pref.c_Form_Transfer_Multiple_View;
      when Hpd_Pref.c_Pcode_Journal_Type_Dismissal then
        return Hpd_Pref.c_Form_Dismissal_View;
      when Hpd_Pref.c_Pcode_Journal_Type_Dismissal_Multiple then
        return Hpd_Pref.c_Form_Dismissal_Multiple_View;
      when Hpd_Pref.c_Pcode_Journal_Type_Rank_Change then
        return Hpd_Pref.c_Form_Rank_Change_View;
      when Hpd_Pref.c_Pcode_Journal_Type_Limit_Change then
        return Hpd_Pref.c_Form_Vacation_Limit_Change_View;
      when Hpd_Pref.c_Pcode_Journal_Type_Wage_Change then
        return Hpd_Pref.c_Form_Wage_Change_View;
        --  you should add this part when multiple wage change view form created.
      when Hpd_Pref.c_Pcode_Journal_Type_Schedule_Change then
        return Hpd_Pref.c_Form_Schedule_Change_View;
      when Hpd_Pref.c_Pcode_Journal_Type_Timebook_Adjustment then
        return Hpd_Pref.c_Form_Timebook_Adjustment_View;
      else
        return null;
    end case;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Hiring_Journal_New
  (
    o_Journal         out Hpd_Pref.Hiring_Journal_Rt,
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Journal_Id      number,
    i_Journal_Type_Id number,
    i_Journal_Number  varchar2,
    i_Journal_Date    date,
    i_Journal_Name    varchar2,
    i_Lang_Code       varchar2 := null
  ) is
  begin
    o_Journal.Company_Id      := i_Company_Id;
    o_Journal.Filial_Id       := i_Filial_Id;
    o_Journal.Journal_Id      := i_Journal_Id;
    o_Journal.Journal_Type_Id := i_Journal_Type_Id;
    o_Journal.Journal_Number  := i_Journal_Number;
    o_Journal.Journal_Date    := i_Journal_Date;
    o_Journal.Journal_Name    := i_Journal_Name;
    o_Journal.Lang_Code       := i_Lang_Code;
  
    o_Journal.Hirings := Hpd_Pref.Hiring_Nt();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Journal_Add_Hiring
  (
    p_Journal              in out nocopy Hpd_Pref.Hiring_Journal_Rt,
    i_Page_Id              number,
    i_Employee_Id          number,
    i_Staff_Number         varchar2,
    i_Hiring_Date          date,
    i_Dismissal_Date       date := null,
    i_Trial_Period         number,
    i_Employment_Source_Id number,
    i_Schedule_Id          number,
    i_Vacation_Days_Limit  number,
    i_Is_Booked            varchar2,
    i_Robot                Hpd_Pref.Robot_Rt,
    i_Contract             Hpd_Pref.Contract_Rt,
    i_Cv_Contract          Hpd_Pref.Cv_Contract_Rt := null,
    i_Indicators           Href_Pref.Indicator_Nt,
    i_Oper_Types           Href_Pref.Oper_Type_Nt,
    i_Currency_Id          number := null
  ) is
    v_Hiring Hpd_Pref.Hiring_Rt;
  begin
    v_Hiring.Page_Id              := i_Page_Id;
    v_Hiring.Employee_Id          := i_Employee_Id;
    v_Hiring.Staff_Number         := i_Staff_Number;
    v_Hiring.Hiring_Date          := i_Hiring_Date;
    v_Hiring.Dismissal_Date       := i_Dismissal_Date;
    v_Hiring.Trial_Period         := i_Trial_Period;
    v_Hiring.Employment_Source_Id := i_Employment_Source_Id;
    v_Hiring.Schedule_Id          := i_Schedule_Id;
    v_Hiring.Currency_Id          := i_Currency_Id;
    v_Hiring.Vacation_Days_Limit  := i_Vacation_Days_Limit;
    v_Hiring.Is_Booked            := i_Is_Booked;
    v_Hiring.Robot                := i_Robot;
    v_Hiring.Contract             := i_Contract;
    v_Hiring.Cv_Contract          := i_Cv_Contract;
    v_Hiring.Indicators           := i_Indicators;
    v_Hiring.Oper_Types           := i_Oper_Types;
  
    p_Journal.Hirings.Extend();
    p_Journal.Hirings(p_Journal.Hirings.Count) := v_Hiring;
  end;

  ----------------------------------------------------------------------------------------------------
  -- transfer
  ----------------------------------------------------------------------------------------------------
  Procedure Transfer_Journal_New
  (
    o_Journal         out Hpd_Pref.Transfer_Journal_Rt,
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Journal_Id      number,
    i_Journal_Type_Id number,
    i_Journal_Number  varchar2,
    i_Journal_Date    date,
    i_Journal_Name    varchar2,
    i_Lang_Code       varchar2 := null
  ) is
  begin
    o_Journal.Company_Id      := i_Company_Id;
    o_Journal.Filial_Id       := i_Filial_Id;
    o_Journal.Journal_Id      := i_Journal_Id;
    o_Journal.Journal_Type_Id := i_Journal_Type_Id;
    o_Journal.Journal_Number  := i_Journal_Number;
    o_Journal.Journal_Date    := i_Journal_Date;
    o_Journal.Journal_Name    := i_Journal_Name;
    o_Journal.Lang_Code       := i_Lang_Code;
    o_Journal.Transfers       := Hpd_Pref.Transfer_Nt();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Journal_Add_Transfer
  (
    p_Journal             in out nocopy Hpd_Pref.Transfer_Journal_Rt,
    i_Page_Id             number,
    i_Transfer_Begin      date,
    i_Transfer_End        date,
    i_Staff_Id            number,
    i_Schedule_Id         number,
    i_Vacation_Days_Limit number,
    i_Is_Booked           varchar2,
    i_Transfer_Reason     varchar2,
    i_Transfer_Base       varchar2,
    i_Robot               Hpd_Pref.Robot_Rt,
    i_Contract            Hpd_Pref.Contract_Rt,
    i_Indicators          Href_Pref.Indicator_Nt,
    i_Oper_Types          Href_Pref.Oper_Type_Nt,
    i_Currency_Id         number := null
  ) is
    v_Transfer Hpd_Pref.Transfer_Rt;
  begin
    v_Transfer.Page_Id             := i_Page_Id;
    v_Transfer.Transfer_Begin      := i_Transfer_Begin;
    v_Transfer.Transfer_End        := i_Transfer_End;
    v_Transfer.Staff_Id            := i_Staff_Id;
    v_Transfer.Schedule_Id         := i_Schedule_Id;
    v_Transfer.Currency_Id         := i_Currency_Id;
    v_Transfer.Vacation_Days_Limit := i_Vacation_Days_Limit;
    v_Transfer.Is_Booked           := i_Is_Booked;
    v_Transfer.Transfer_Reason     := i_Transfer_Reason;
    v_Transfer.Transfer_Base       := i_Transfer_Base;
    v_Transfer.Robot               := i_Robot;
    v_Transfer.Contract            := i_Contract;
    v_Transfer.Indicators          := i_Indicators;
    v_Transfer.Oper_Types          := i_Oper_Types;
  
    p_Journal.Transfers.Extend();
    p_Journal.Transfers(p_Journal.Transfers.Count) := v_Transfer;
  end;

  ----------------------------------------------------------------------------------------------------
  -- dismissal
  ----------------------------------------------------------------------------------------------------
  Procedure Dismissal_Journal_New
  (
    o_Journal         out Hpd_Pref.Dismissal_Journal_Rt,
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Journal_Id      number,
    i_Journal_Type_Id number,
    i_Journal_Number  varchar2,
    i_Journal_Date    date,
    i_Journal_Name    varchar2,
    i_Lang_Code       varchar2 := null
  ) is
  begin
    o_Journal.Company_Id      := i_Company_Id;
    o_Journal.Filial_Id       := i_Filial_Id;
    o_Journal.Journal_Id      := i_Journal_Id;
    o_Journal.Journal_Type_Id := i_Journal_Type_Id;
    o_Journal.Journal_Number  := i_Journal_Number;
    o_Journal.Journal_Date    := i_Journal_Date;
    o_Journal.Journal_Name    := i_Journal_Name;
    o_Journal.Lang_Code       := i_Lang_Code;
  
    o_Journal.Dismissals := Hpd_Pref.Dismissal_Nt();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Journal_Add_Dismissal
  (
    p_Journal              in out nocopy Hpd_Pref.Dismissal_Journal_Rt,
    i_Page_Id              number,
    i_Staff_Id             number,
    i_Dismissal_Date       date,
    i_Dismissal_Reason_Id  number,
    i_Employment_Source_Id number,
    i_Based_On_Doc         varchar2,
    i_Note                 varchar2
  ) is
    v_Dismissal Hpd_Pref.Dismissal_Rt;
  begin
    v_Dismissal.Page_Id              := i_Page_Id;
    v_Dismissal.Staff_Id             := i_Staff_Id;
    v_Dismissal.Dismissal_Date       := i_Dismissal_Date;
    v_Dismissal.Dismissal_Reason_Id  := i_Dismissal_Reason_Id;
    v_Dismissal.Employment_Source_Id := i_Employment_Source_Id;
    v_Dismissal.Based_On_Doc         := i_Based_On_Doc;
    v_Dismissal.Note                 := i_Note;
  
    p_Journal.Dismissals.Extend();
    p_Journal.Dismissals(p_Journal.Dismissals.Count) := v_Dismissal;
  end;

  ----------------------------------------------------------------------------------------------------
  -- wage change
  ----------------------------------------------------------------------------------------------------
  Procedure Wage_Change_Journal_New
  (
    o_Journal         out Hpd_Pref.Wage_Change_Journal_Rt,
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Journal_Id      number,
    i_Journal_Type_Id number,
    i_Journal_Number  varchar2,
    i_Journal_Date    date,
    i_Journal_Name    varchar2,
    i_Lang_Code       varchar2 := null
  ) is
  begin
    o_Journal.Company_Id      := i_Company_Id;
    o_Journal.Filial_Id       := i_Filial_Id;
    o_Journal.Journal_Id      := i_Journal_Id;
    o_Journal.Journal_Type_Id := i_Journal_Type_Id;
    o_Journal.Journal_Number  := i_Journal_Number;
    o_Journal.Journal_Date    := i_Journal_Date;
    o_Journal.Journal_Name    := i_Journal_Name;
    o_Journal.Lang_Code       := i_Lang_Code;
  
    o_Journal.Wage_Changes := Hpd_Pref.Wage_Change_Nt();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Journal_Add_Wage_Change
  (
    p_Journal     in out nocopy Hpd_Pref.Wage_Change_Journal_Rt,
    i_Page_Id     number,
    i_Staff_Id    number,
    i_Change_Date date,
    i_Indicators  Href_Pref.Indicator_Nt,
    i_Oper_Types  Href_Pref.Oper_Type_Nt,
    i_Currency_Id number := null
  ) is
    v_Wage_Change Hpd_Pref.Wage_Change_Rt;
  begin
    v_Wage_Change.Page_Id     := i_Page_Id;
    v_Wage_Change.Staff_Id    := i_Staff_Id;
    v_Wage_Change.Change_Date := i_Change_Date;
    v_Wage_Change.Currency_Id := i_Currency_Id;
    v_Wage_Change.Indicators  := i_Indicators;
    v_Wage_Change.Oper_Types  := i_Oper_Types;
  
    p_Journal.Wage_Changes.Extend();
    p_Journal.Wage_Changes(p_Journal.Wage_Changes.Count) := v_Wage_Change;
  end;

  ----------------------------------------------------------------------------------------------------
  -- rank change
  ----------------------------------------------------------------------------------------------------
  Procedure Rank_Change_Journal_New
  (
    o_Journal         out Hpd_Pref.Rank_Change_Journal_Rt,
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Journal_Id      number,
    i_Journal_Number  varchar2,
    i_Journal_Date    date,
    i_Journal_Name    varchar2,
    i_Lang_Code       varchar2 := null,
    i_Journal_Type_Id number,
    i_Source_Table    varchar2 := null,
    i_Source_Id       number := null
  ) is
  begin
    o_Journal.Company_Id      := i_Company_Id;
    o_Journal.Filial_Id       := i_Filial_Id;
    o_Journal.Journal_Id      := i_Journal_Id;
    o_Journal.Journal_Number  := i_Journal_Number;
    o_Journal.Journal_Date    := i_Journal_Date;
    o_Journal.Journal_Name    := i_Journal_Name;
    o_Journal.Journal_Type_Id := i_Journal_Type_Id;
    o_Journal.Source_Table    := i_Source_Table;
    o_Journal.Source_Id       := i_Source_Id;
    o_Journal.Lang_Code       := i_Lang_Code;
  
    o_Journal.Rank_Changes := Hpd_Pref.Rank_Change_Nt();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Journal_Add_Rank_Change
  (
    p_Journal     in out nocopy Hpd_Pref.Rank_Change_Journal_Rt,
    i_Page_Id     number,
    i_Staff_Id    number,
    i_Change_Date date,
    i_Rank_Id     number
  ) is
    v_Rank_Change Hpd_Pref.Rank_Change_Rt;
  begin
    v_Rank_Change.Page_Id     := i_Page_Id;
    v_Rank_Change.Staff_Id    := i_Staff_Id;
    v_Rank_Change.Change_Date := i_Change_Date;
    v_Rank_Change.Rank_Id     := i_Rank_Id;
  
    p_Journal.Rank_Changes.Extend();
    p_Journal.Rank_Changes(p_Journal.Rank_Changes.Count) := v_Rank_Change;
  end;

  ----------------------------------------------------------------------------------------------------
  -- vacation limit change
  ----------------------------------------------------------------------------------------------------
  Procedure Limit_Change_Journal_New
  (
    o_Journal        out Hpd_Pref.Limit_Change_Journal_Rt,
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Journal_Id     number,
    i_Journal_Number varchar2,
    i_Journal_Date   date,
    i_Journal_Name   varchar2,
    i_Lang_Code      varchar2 := null,
    i_Division_Id    number,
    i_Days_Limit     number,
    i_Change_Date    date
  ) is
  begin
    o_Journal.Company_Id     := i_Company_Id;
    o_Journal.Filial_Id      := i_Filial_Id;
    o_Journal.Journal_Id     := i_Journal_Id;
    o_Journal.Journal_Number := i_Journal_Number;
    o_Journal.Journal_Date   := i_Journal_Date;
    o_Journal.Journal_Name   := i_Journal_Name;
    o_Journal.Division_Id    := i_Division_Id;
    o_Journal.Days_Limit     := i_Days_Limit;
    o_Journal.Change_Date    := i_Change_Date;
    o_Journal.Lang_Code      := i_Lang_Code;
  
    o_Journal.Pages := Hpd_Pref.Page_Nt();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Limit_Change_Add_Page
  (
    p_Journal  in out nocopy Hpd_Pref.Limit_Change_Journal_Rt,
    i_Page_Id  number,
    i_Staff_Id number
  ) is
    v_Page Hpd_Pref.Page_Rt;
  begin
    v_Page.Page_Id  := i_Page_Id;
    v_Page.Staff_Id := i_Staff_Id;
  
    p_Journal.Pages.Extend();
    p_Journal.Pages(p_Journal.Pages.Count) := v_Page;
  end;

  ----------------------------------------------------------------------------------------------------
  -- schedule change
  ----------------------------------------------------------------------------------------------------
  Procedure Schedule_Change_Journal_New
  (
    o_Journal        out Hpd_Pref.Schedule_Change_Journal_Rt,
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Journal_Id     number,
    i_Journal_Number varchar2,
    i_Journal_Date   date,
    i_Journal_Name   varchar2,
    i_Division_Id    number,
    i_Begin_Date     date,
    i_End_Date       date,
    i_Lang_Code      varchar2 := null
  ) is
  begin
    o_Journal.Company_Id     := i_Company_Id;
    o_Journal.Filial_Id      := i_Filial_Id;
    o_Journal.Journal_Id     := i_Journal_Id;
    o_Journal.Journal_Number := i_Journal_Number;
    o_Journal.Journal_Date   := i_Journal_Date;
    o_Journal.Journal_Name   := i_Journal_Name;
    o_Journal.Division_Id    := i_Division_Id;
    o_Journal.Begin_Date     := i_Begin_Date;
    o_Journal.End_Date       := i_End_Date;
    o_Journal.Lang_Code      := i_Lang_Code;
  
    o_Journal.Schedule_Changes := Hpd_Pref.Schedule_Change_Nt();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Journal_Add_Schedule_Change
  (
    p_Journal     in out nocopy Hpd_Pref.Schedule_Change_Journal_Rt,
    i_Page_Id     number,
    i_Staff_Id    number,
    i_Schedule_Id number
  ) is
    v_Schedule_Change Hpd_Pref.Schedule_Change_Rt;
  begin
    v_Schedule_Change.Page_Id     := i_Page_Id;
    v_Schedule_Change.Staff_Id    := i_Staff_Id;
    v_Schedule_Change.Schedule_Id := i_Schedule_Id;
  
    p_Journal.Schedule_Changes.Extend;
    p_Journal.Schedule_Changes(p_Journal.Schedule_Changes.Count) := v_Schedule_Change;
  end;

  ----------------------------------------------------------------------------------------------------
  -- sick leave
  ----------------------------------------------------------------------------------------------------
  Procedure Sick_Leave_Journal_New
  (
    o_Journal         out Hpd_Pref.Sick_Leave_Journal_Rt,
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Journal_Id      number,
    i_Journal_Type_Id number,
    i_Journal_Number  varchar2,
    i_Journal_Date    date,
    i_Journal_Name    varchar2,
    i_Lang_Code       varchar2 := null
  ) is
  begin
    o_Journal.Company_Id      := i_Company_Id;
    o_Journal.Filial_Id       := i_Filial_Id;
    o_Journal.Journal_Id      := i_Journal_Id;
    o_Journal.Journal_Type_Id := i_Journal_Type_Id;
    o_Journal.Journal_Number  := i_Journal_Number;
    o_Journal.Journal_Date    := i_Journal_Date;
    o_Journal.Journal_Name    := i_Journal_Name;
    o_Journal.Lang_Code       := i_Lang_Code;
  
    o_Journal.Sick_Leaves := Hpd_Pref.Sick_Leave_Nt();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Journal_Add_Sick_Leave
  (
    p_Journal           in out nocopy Hpd_Pref.Sick_Leave_Journal_Rt,
    i_Timeoff_Id        number,
    i_Staff_Id          number,
    i_Reason_Id         number,
    i_Coefficient       number,
    i_Sick_Leave_Number varchar2,
    i_Begin_Date        date,
    i_End_Date          date,
    i_Shas              Array_Varchar2
  ) is
    v_Sick_Leave Hpd_Pref.Sick_Leave_Rt;
  begin
    v_Sick_Leave.Timeoff_Id        := i_Timeoff_Id;
    v_Sick_Leave.Staff_Id          := i_Staff_Id;
    v_Sick_Leave.Reason_Id         := i_Reason_Id;
    v_Sick_Leave.Coefficient       := i_Coefficient;
    v_Sick_Leave.Sick_Leave_Number := i_Sick_Leave_Number;
    v_Sick_Leave.Begin_Date        := i_Begin_Date;
    v_Sick_Leave.End_Date          := i_End_Date;
    v_Sick_Leave.Shas              := i_Shas;
  
    p_Journal.Sick_Leaves.Extend();
    p_Journal.Sick_Leaves(p_Journal.Sick_Leaves.Count) := v_Sick_Leave;
  end;

  ----------------------------------------------------------------------------------------------------
  -- business trips
  ----------------------------------------------------------------------------------------------------
  Procedure Business_Trip_Journal_New
  (
    o_Journal         out Hpd_Pref.Business_Trip_Journal_Rt,
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Journal_Id      number,
    i_Journal_Type_Id number,
    i_Journal_Number  varchar2,
    i_Journal_Date    date,
    i_Journal_Name    varchar2,
    i_Lang_Code       varchar2 := null
  ) is
  begin
    o_Journal.Company_Id      := i_Company_Id;
    o_Journal.Filial_Id       := i_Filial_Id;
    o_Journal.Journal_Id      := i_Journal_Id;
    o_Journal.Journal_Type_Id := i_Journal_Type_Id;
    o_Journal.Journal_Number  := i_Journal_Number;
    o_Journal.Journal_Date    := i_Journal_Date;
    o_Journal.Journal_Name    := i_Journal_Name;
    o_Journal.Lang_Code       := i_Lang_Code;
  
    o_Journal.Business_Trips := Hpd_Pref.Business_Trip_Nt();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Journal_Add_Business_Trip
  (
    p_Journal    in out nocopy Hpd_Pref.Business_Trip_Journal_Rt,
    i_Timeoff_Id number,
    i_Staff_Id   number,
    i_Region_Ids Array_Number,
    i_Person_Id  number,
    i_Reason_Id  number,
    i_Begin_Date date,
    i_End_Date   date,
    i_Note       varchar2,
    i_Shas       Array_Varchar2
  ) is
    v_Business_Trip Hpd_Pref.Business_Trip_Rt;
  begin
    v_Business_Trip.Timeoff_Id := i_Timeoff_Id;
    v_Business_Trip.Staff_Id   := i_Staff_Id;
    v_Business_Trip.Region_Ids := i_Region_Ids;
    v_Business_Trip.Person_Id  := i_Person_Id;
    v_Business_Trip.Reason_Id  := i_Reason_Id;
    v_Business_Trip.Begin_Date := i_Begin_Date;
    v_Business_Trip.End_Date   := i_End_Date;
    v_Business_Trip.Note       := i_Note;
    v_Business_Trip.Shas       := i_Shas;
  
    p_Journal.Business_Trips.Extend();
    p_Journal.Business_Trips(p_Journal.Business_Trips.Count) := v_Business_Trip;
  end;

  ----------------------------------------------------------------------------------------------------
  -- vacations
  ----------------------------------------------------------------------------------------------------
  Procedure Vacation_Journal_New
  (
    o_Journal         out Hpd_Pref.Vacation_Journal_Rt,
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Journal_Id      number,
    i_Journal_Type_Id number,
    i_Journal_Number  varchar2,
    i_Journal_Date    date,
    i_Journal_Name    varchar2,
    i_Lang_Code       varchar2 := null
  ) is
  begin
    o_Journal.Company_Id      := i_Company_Id;
    o_Journal.Filial_Id       := i_Filial_Id;
    o_Journal.Journal_Id      := i_Journal_Id;
    o_Journal.Journal_Type_Id := i_Journal_Type_Id;
    o_Journal.Journal_Number  := i_Journal_Number;
    o_Journal.Journal_Date    := i_Journal_Date;
    o_Journal.Journal_Name    := i_Journal_Name;
    o_Journal.Lang_Code       := i_Lang_Code;
  
    o_Journal.Vacations := Hpd_Pref.Vacation_Nt();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Journal_Add_Vacation
  (
    p_Journal      in out nocopy Hpd_Pref.Vacation_Journal_Rt,
    i_Timeoff_Id   number,
    i_Staff_Id     number,
    i_Time_Kind_Id number,
    i_Begin_Date   date,
    i_End_Date     date,
    i_Shas         Array_Varchar2
  ) is
    v_Vacation Hpd_Pref.Vacation_Rt;
  begin
    v_Vacation.Timeoff_Id   := i_Timeoff_Id;
    v_Vacation.Staff_Id     := i_Staff_Id;
    v_Vacation.Time_Kind_Id := i_Time_Kind_Id;
    v_Vacation.Begin_Date   := i_Begin_Date;
    v_Vacation.End_Date     := i_End_Date;
    v_Vacation.Shas         := i_Shas;
  
    p_Journal.Vacations.Extend();
    p_Journal.Vacations(p_Journal.Vacations.Count) := v_Vacation;
  end;

  ----------------------------------------------------------------------------------------------------
  -- overtime
  ----------------------------------------------------------------------------------------------------
  Procedure Overtime_Add
  (
    p_Overtimes        in out nocopy Hpd_Pref.Overtime_Nt,
    i_Overtime_Date    date,
    i_Overtime_Seconds number
  ) is
    v_Overtime Hpd_Pref.Overtime_Rt;
  begin
    v_Overtime.Overtime_Date    := i_Overtime_Date;
    v_Overtime.Overtime_Seconds := i_Overtime_Seconds;
  
    p_Overtimes.Extend();
    p_Overtimes(p_Overtimes.Count) := v_Overtime;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Journal_Add_Overtime
  (
    p_Journal     in out nocopy Hpd_Pref.Overtime_Journal_Rt,
    i_Staff_Id    number,
    i_Month       date,
    i_Overtime_Id number,
    i_Overtimes   Hpd_Pref.Overtime_Nt
  ) is
    v_Overtime_Staff Hpd_Pref.Overtime_Staff_Rt;
  begin
    v_Overtime_Staff.Staff_Id    := i_Staff_Id;
    v_Overtime_Staff.Month       := i_Month;
    v_Overtime_Staff.Overtime_Id := i_Overtime_Id;
    v_Overtime_Staff.Overtimes   := i_Overtimes;
  
    p_Journal.Overtime_Staffs.Extend();
    p_Journal.Overtime_Staffs(p_Journal.Overtime_Staffs.Count) := v_Overtime_Staff;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Overtime_Journal_New
  (
    o_Overtime_Journal out Hpd_Pref.Overtime_Journal_Rt,
    i_Company_Id       number,
    i_Filial_Id        number,
    i_Journal_Id       number,
    i_Journal_Number   varchar2,
    i_Journal_Date     date,
    i_Journal_Name     varchar2,
    i_Division_Id      number := null,
    i_Lang_Code        varchar2 := null
  ) is
  begin
    o_Overtime_Journal.Company_Id      := i_Company_Id;
    o_Overtime_Journal.Filial_Id       := i_Filial_Id;
    o_Overtime_Journal.Journal_Id      := i_Journal_Id;
    o_Overtime_Journal.Journal_Number  := i_Journal_Number;
    o_Overtime_Journal.Journal_Date    := i_Journal_Date;
    o_Overtime_Journal.Journal_Name    := i_Journal_Name;
    o_Overtime_Journal.Lang_Code       := i_Lang_Code;
    o_Overtime_Journal.Division_Id     := i_Division_Id;
    o_Overtime_Journal.Overtime_Staffs := Hpd_Pref.Overtime_Staff_Nt();
  end;

  ----------------------------------------------------------------------------------------------------
  -- timebook adjustment
  ----------------------------------------------------------------------------------------------------
  Procedure Timebook_Adjustment_Journal_New
  (
    o_Journal         out Hpd_Pref.Timebook_Adjustment_Journal_Rt,
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Journal_Id      number,
    i_Journal_Number  varchar2,
    i_Journal_Date    date,
    i_Journal_Name    varchar2,
    i_Division_Id     number,
    i_Adjustment_Date date,
    i_Lang_Code       varchar2 := null
  ) is
  begin
    o_Journal.Company_Id      := i_Company_Id;
    o_Journal.Filial_Id       := i_Filial_Id;
    o_Journal.Journal_Id      := i_Journal_Id;
    o_Journal.Journal_Number  := i_Journal_Number;
    o_Journal.Journal_Date    := i_Journal_Date;
    o_Journal.Journal_Name    := i_Journal_Name;
    o_Journal.Division_Id     := i_Division_Id;
    o_Journal.Adjustment_Date := i_Adjustment_Date;
    o_Journal.Lang_Code       := i_Lang_Code;
  
    o_Journal.Adjustments := Hpd_Pref.Adjustment_Nt();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Timebook_Adjustment_Add_Adjustment
  (
    p_Journal    in out Hpd_Pref.Timebook_Adjustment_Journal_Rt,
    i_Adjustment Hpd_Pref.Adjustment_Rt
  ) is
  begin
    p_Journal.Adjustments.Extend;
    p_Journal.Adjustments(p_Journal.Adjustments.Count) := i_Adjustment;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Adjustment_New
  (
    o_Adjustment out Hpd_Pref.Adjustment_Rt,
    i_Page_Id    number,
    i_Staff_Id   number
  ) is
  begin
    o_Adjustment.Page_Id  := i_Page_Id;
    o_Adjustment.Staff_Id := i_Staff_Id;
  
    o_Adjustment.Kinds := Hpd_Pref.Adjustment_Kind_Nt();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Adjustment_Add_Kind
  (
    p_Adjustment   in out Hpd_Pref.Adjustment_Rt,
    i_Kind         varchar2,
    i_Free_Time    number,
    i_Overtime     number,
    i_Turnout_Time number
  ) is
    v_Kind Hpd_Pref.Adjustment_Kind_Rt;
  begin
    v_Kind.Kind         := i_Kind;
    v_Kind.Free_Time    := i_Free_Time;
    v_Kind.Overtime     := i_Overtime;
    v_Kind.Turnout_Time := i_Turnout_Time;
  
    p_Adjustment.Kinds.Extend;
    p_Adjustment.Kinds(p_Adjustment.Kinds.Count) := v_Kind;
  end;

  ----------------------------------------------------------------------------------------------------
  -- journal page parts
  ----------------------------------------------------------------------------------------------------
  Procedure Robot_New
  (
    o_Robot           out Hpd_Pref.Robot_Rt,
    i_Robot_Id        number,
    i_Division_Id     number,
    i_Job_Id          number,
    i_Org_Unit_Id     number := null,
    i_Rank_Id         number := null,
    i_Allow_Rank      varchar2 := 'Y',
    i_Wage_Scale_Id   number := null,
    i_Employment_Type varchar2,
    i_Fte_Id          number,
    i_Fte             number
  ) is
  begin
    o_Robot.Robot_Id        := i_Robot_Id;
    o_Robot.Division_Id     := i_Division_Id;
    o_Robot.Job_Id          := i_Job_Id;
    o_Robot.Org_Unit_Id     := i_Org_Unit_Id;
    o_Robot.Rank_Id         := i_Rank_Id;
    o_Robot.Allow_Rank      := i_Allow_Rank;
    o_Robot.Wage_Scale_Id   := i_Wage_Scale_Id;
    o_Robot.Employment_Type := i_Employment_Type;
    o_Robot.Fte_Id          := i_Fte_Id;
    o_Robot.Fte             := i_Fte;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Contract_New
  (
    o_Contract             out Hpd_Pref.Contract_Rt,
    i_Contract_Number      varchar2,
    i_Contract_Date        date,
    i_Fixed_Term           varchar2,
    i_Expiry_Date          date,
    i_Fixed_Term_Base_Id   number,
    i_Concluding_Term      varchar2,
    i_Hiring_Conditions    varchar2,
    i_Other_Conditions     varchar2,
    i_Workplace_Equipment  varchar2,
    i_Representative_Basis varchar2
  ) is
  begin
    o_Contract.Contract_Number      := i_Contract_Number;
    o_Contract.Contract_Date        := i_Contract_Date;
    o_Contract.Fixed_Term           := i_Fixed_Term;
    o_Contract.Expiry_Date          := i_Expiry_Date;
    o_Contract.Fixed_Term_Base_Id   := i_Fixed_Term_Base_Id;
    o_Contract.Concluding_Term      := i_Concluding_Term;
    o_Contract.Hiring_Conditions    := i_Hiring_Conditions;
    o_Contract.Other_Conditions     := i_Other_Conditions;
    o_Contract.Workplace_Equipment  := i_Workplace_Equipment;
    o_Contract.Representative_Basis := i_Representative_Basis;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Oper_Type_Add
  (
    p_Oper_Type     in out nocopy Href_Pref.Oper_Type_Nt,
    i_Oper_Type_Id  number,
    i_Indicator_Ids Array_Number
  ) is
    v_Oper_Type Href_Pref.Oper_Type_Rt;
  begin
    v_Oper_Type.Oper_Type_Id  := i_Oper_Type_Id;
    v_Oper_Type.Indicator_Ids := i_Indicator_Ids;
  
    p_Oper_Type.Extend;
    p_Oper_Type(p_Oper_Type.Count) := v_Oper_Type;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Indicator_Add
  (
    p_Indicator       in out nocopy Href_Pref.Indicator_Nt,
    i_Indicator_Id    number,
    i_Indicator_Value number
  ) is
    v_Indicator Href_Pref.Indicator_Rt;
  begin
    v_Indicator.Indicator_Id    := i_Indicator_Id;
    v_Indicator.Indicator_Value := i_Indicator_Value;
  
    p_Indicator.Extend;
    p_Indicator(p_Indicator.Count) := v_Indicator;
  end;

  ----------------------------------------------------------------------------------------------------
  -- CV Contracts
  ----------------------------------------------------------------------------------------------------
  Procedure Cv_Contract_New
  (
    o_Contract                 out Hpd_Pref.Cv_Contract_Rt,
    i_Company_Id               number,
    i_Filial_Id                number,
    i_Contract_Id              number,
    i_Contract_Number          varchar2,
    i_Page_Id                  number := null,
    i_Division_Id              number,
    i_Person_Id                number,
    i_Begin_Date               date,
    i_End_Date                 date,
    i_Contract_Kind            varchar2,
    i_Contract_Employment_Kind varchar2,
    i_Access_To_Add_Item       varchar2,
    i_Early_Closed_Date        date := null,
    i_Early_Closed_Note        varchar2 := null,
    i_Note                     varchar2 := null
  ) is
  begin
    o_Contract.Company_Id               := i_Company_Id;
    o_Contract.Filial_Id                := i_Filial_Id;
    o_Contract.Contract_Id              := i_Contract_Id;
    o_Contract.Contract_Number          := i_Contract_Number;
    o_Contract.Page_Id                  := i_Page_Id;
    o_Contract.Division_Id              := i_Division_Id;
    o_Contract.Person_Id                := i_Person_Id;
    o_Contract.Begin_Date               := i_Begin_Date;
    o_Contract.End_Date                 := i_End_Date;
    o_Contract.Contract_Kind            := i_Contract_Kind;
    o_Contract.Contract_Employment_Kind := i_Contract_Employment_Kind;
    o_Contract.Access_To_Add_Item       := i_Access_To_Add_Item;
    o_Contract.Early_Closed_Date        := i_Early_Closed_Date;
    o_Contract.Early_Closed_Note        := i_Early_Closed_Note;
    o_Contract.Note                     := i_Note;
  
    o_Contract.Items := Hpd_Pref.Cv_Contract_Item_Nt();
    o_Contract.Files := Hpd_Pref.Cv_Contract_File_Nt();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Cv_Contract_Add_Item
  (
    o_Contract         in out nocopy Hpd_Pref.Cv_Contract_Rt,
    i_Contract_Item_Id number,
    i_Name             varchar2,
    i_Quantity         number,
    i_Amount           number
  ) is
    v_Item Hpd_Pref.Cv_Contract_Item_Rt;
  begin
    v_Item.Contract_Item_Id := i_Contract_Item_Id;
    v_Item.Name             := i_Name;
    v_Item.Quantity         := i_Quantity;
    v_Item.Amount           := i_Amount;
  
    o_Contract.Items.Extend;
    o_Contract.Items(o_Contract.Items.Count) := v_Item;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Cv_Contract_Add_File
  (
    o_Contract in out nocopy Hpd_Pref.Cv_Contract_Rt,
    i_File_Sha varchar2,
    i_Note     varchar2 := null
  ) is
    v_File Hpd_Pref.Cv_Contract_File_Rt;
  begin
    v_File.File_Sha := i_File_Sha;
    v_File.Note     := i_Note;
  
    o_Contract.Files.Extend;
    o_Contract.Files(o_Contract.Files.Count) := v_File;
  end;

  ----------------------------------------------------------------------------------------------------
  -- Application
  ----------------------------------------------------------------------------------------------------
  Procedure Application_Create_Robot_New
  (
    o_Application    out Hpd_Pref.Application_Create_Robot_Rt,
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Application_Id number,
    i_Name           varchar2,
    i_Opened_Date    date,
    i_Division_Id    number,
    i_Job_Id         number,
    i_Quantity       number,
    i_Note           varchar2
  ) is
  begin
    o_Application.Company_Id     := i_Company_Id;
    o_Application.Filial_Id      := i_Filial_Id;
    o_Application.Application_Id := i_Application_Id;
    o_Application.Name           := i_Name;
    o_Application.Opened_Date    := i_Opened_Date;
    o_Application.Division_Id    := i_Division_Id;
    o_Application.Job_Id         := i_Job_Id;
    o_Application.Quantity       := i_Quantity;
    o_Application.Note           := i_Note;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Application_Hiring_New
  (
    o_Application    out Hpd_Pref.Application_Hiring_Rt,
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Application_Id number,
    i_Hiring_Date    date,
    i_Robot_Id       number,
    i_Note           varchar2,
    -- person info
    i_First_Name      varchar2,
    i_Last_Name       varchar2,
    i_Middle_Name     varchar2,
    i_Birthday        date,
    i_Gender          varchar2,
    i_Phone           varchar2,
    i_Email           varchar2,
    i_Photo_Sha       varchar2,
    i_Address         varchar2,
    i_Legal_Address   varchar2,
    i_Region_Id       number,
    i_Passport_Series varchar2,
    i_Passport_Number varchar2,
    i_Npin            varchar2,
    i_Iapa            varchar2,
    i_Employment_Type varchar2
  ) is
  begin
    o_Application.Company_Id      := i_Company_Id;
    o_Application.Filial_Id       := i_Filial_Id;
    o_Application.Application_Id  := i_Application_Id;
    o_Application.Hiring_Date     := i_Hiring_Date;
    o_Application.Robot_Id        := i_Robot_Id;
    o_Application.Note            := i_Note;
    o_Application.First_Name      := i_First_Name;
    o_Application.Last_Name       := i_Last_Name;
    o_Application.Middle_Name     := i_Middle_Name;
    o_Application.Birthday        := i_Birthday;
    o_Application.Gender          := i_Gender;
    o_Application.Phone           := i_Phone;
    o_Application.Email           := i_Email;
    o_Application.Photo_Sha       := i_Photo_Sha;
    o_Application.Address         := i_Address;
    o_Application.Legal_Address   := i_Legal_Address;
    o_Application.Region_Id       := i_Region_Id;
    o_Application.Passport_Series := i_Passport_Series;
    o_Application.Passport_Number := i_Passport_Number;
    o_Application.Npin            := i_Npin;
    o_Application.Iapa            := i_Iapa;
    o_Application.Employment_Type := i_Employment_Type;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Application_Transfer_New
  (
    o_Application    out Hpd_Pref.Application_Transfer_Rt,
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Application_Id number
  ) is
  begin
    o_Application.Company_Id     := i_Company_Id;
    o_Application.Filial_Id      := i_Filial_Id;
    o_Application.Application_Id := i_Application_Id;
  
    o_Application.Transfer_Units := Hpd_Pref.Application_Transfer_Unit_Nt();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Application_Add_Transfer
  (
    o_Application         in out nocopy Hpd_Pref.Application_Transfer_Rt,
    i_Application_Unit_Id number,
    i_Staff_Id            number,
    i_Transfer_Begin      date,
    i_Robot_Id            number,
    i_Note                varchar2
  ) is
    v_Transfer Hpd_Pref.Application_Transfer_Unit_Rt;
  begin
    v_Transfer.Application_Unit_Id := i_Application_Unit_Id;
    v_Transfer.Staff_Id            := i_Staff_Id;
    v_Transfer.Transfer_Begin      := i_Transfer_Begin;
    v_Transfer.Robot_Id            := i_Robot_Id;
    v_Transfer.Note                := i_Note;
  
    o_Application.Transfer_Units.Extend();
    o_Application.Transfer_Units(o_Application.Transfer_Units.Count) := v_Transfer;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Application_Dismissal_New
  (
    o_Application         out Hpd_Pref.Application_Dismissal_Rt,
    i_Company_Id          number,
    i_Filial_Id           number,
    i_Application_Id      number,
    i_Staff_Id            number,
    i_Dismissal_Date      date,
    i_Dismissal_Reason_Id number,
    i_Note                varchar2
  ) is
  begin
    o_Application.Company_Id          := i_Company_Id;
    o_Application.Filial_Id           := i_Filial_Id;
    o_Application.Application_Id      := i_Application_Id;
    o_Application.Staff_Id            := i_Staff_Id;
    o_Application.Dismissal_Date      := i_Dismissal_Date;
    o_Application.Dismissal_Reason_Id := i_Dismissal_Reason_Id;
    o_Application.Note                := i_Note;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Journal_Type_Id
  (
    i_Company_Id number,
    i_Pcode      varchar2
  ) return number Result_Cache is
    result number;
  begin
    select q.Journal_Type_Id
      into result
      from Hpd_Journal_Types q
     where q.Company_Id = i_Company_Id
       and q.Pcode = i_Pcode;
  
    return result;
  exception
    when No_Data_Found then
      Hpd_Error.Raise_043;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Is_Hiring_Journal
  (
    i_Company_Id      number,
    i_Journal_Type_Id number
  ) return boolean is
  begin
    return i_Journal_Type_Id in(Journal_Type_Id(i_Company_Id, Hpd_Pref.c_Pcode_Journal_Type_Hiring),
                                Journal_Type_Id(i_Company_Id,
                                                Hpd_Pref.c_Pcode_Journal_Type_Hiring_Multiple));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Is_Contractor_Journal
  (
    i_Company_Id      number,
    i_Journal_Type_Id number
  ) return boolean is
  begin
    return i_Journal_Type_Id in(Journal_Type_Id(i_Company_Id,
                                                Hpd_Pref.c_Pcode_Journal_Type_Hiring_Contractor));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Is_Transfer_Journal
  (
    i_Company_Id      number,
    i_Journal_Type_Id number
  ) return boolean is
  begin
    return i_Journal_Type_Id in(Journal_Type_Id(i_Company_Id,
                                                Hpd_Pref.c_Pcode_Journal_Type_Transfer),
                                Journal_Type_Id(i_Company_Id,
                                                Hpd_Pref.c_Pcode_Journal_Type_Transfer_Multiple));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Is_Dismissal_Journal
  (
    i_Company_Id      number,
    i_Journal_Type_Id number
  ) return boolean is
  begin
    return i_Journal_Type_Id in(Journal_Type_Id(i_Company_Id,
                                                Hpd_Pref.c_Pcode_Journal_Type_Dismissal),
                                Journal_Type_Id(i_Company_Id,
                                                Hpd_Pref.c_Pcode_Journal_Type_Dismissal_Multiple));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Is_Wage_Change_Journal
  (
    i_Company_Id      number,
    i_Journal_Type_Id number
  ) return boolean is
  begin
    return i_Journal_Type_Id in(Journal_Type_Id(i_Company_Id,
                                                Hpd_Pref.c_Pcode_Journal_Type_Wage_Change),
                                Journal_Type_Id(i_Company_Id,
                                                Hpd_Pref.c_Pcode_Journal_Type_Wage_Change_Multiple));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Is_Rank_Change_Journal
  (
    i_Company_Id      number,
    i_Journal_Type_Id number
  ) return boolean is
  begin
    return i_Journal_Type_Id in(Journal_Type_Id(i_Company_Id,
                                                Hpd_Pref.c_Pcode_Journal_Type_Rank_Change),
                                Journal_Type_Id(i_Company_Id,
                                                Hpd_Pref.c_Pcode_Journal_Type_Rank_Change_Multiple));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Is_Limit_Change_Journal
  (
    i_Company_Id      number,
    i_Journal_Type_Id number
  ) return boolean is
  begin
    return i_Journal_Type_Id = Journal_Type_Id(i_Company_Id,
                                               Hpd_Pref.c_Pcode_Journal_Type_Limit_Change);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Is_Schedule_Change_Journal
  (
    i_Company_Id      number,
    i_Journal_Type_Id number
  ) return boolean is
  begin
    return i_Journal_Type_Id = Journal_Type_Id(i_Company_Id,
                                               Hpd_Pref.c_Pcode_Journal_Type_Schedule_Change);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Is_Sick_Leave_Journal
  (
    i_Company_Id      number,
    i_Journal_Type_Id number
  ) return boolean is
  begin
    return i_Journal_Type_Id in(Journal_Type_Id(i_Company_Id,
                                                Hpd_Pref.c_Pcode_Journal_Type_Sick_Leave),
                                Journal_Type_Id(i_Company_Id,
                                                Hpd_Pref.c_Pcode_Journal_Type_Sick_Leave_Multiple));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Is_Business_Trip_Journal
  (
    i_Company_Id      number,
    i_Journal_Type_Id number
  ) return boolean is
  begin
    return i_Journal_Type_Id in(Journal_Type_Id(i_Company_Id,
                                                Hpd_Pref.c_Pcode_Journal_Type_Business_Trip),
                                Journal_Type_Id(i_Company_Id,
                                                Hpd_Pref.c_Pcode_Journal_Type_Business_Trip_Multiple));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Is_Vacation_Journal
  (
    i_Company_Id      number,
    i_Journal_Type_Id number
  ) return boolean is
  begin
    return i_Journal_Type_Id in(Journal_Type_Id(i_Company_Id,
                                                Hpd_Pref.c_Pcode_Journal_Type_Vacation),
                                Journal_Type_Id(i_Company_Id,
                                                Hpd_Pref.c_Pcode_Journal_Type_Vacation_Multiple));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Is_Timebook_Adjustment_Journal
  (
    i_Company_Id      number,
    i_Journal_Type_Id number
  ) return boolean is
  begin
    return i_Journal_Type_Id = Journal_Type_Id(i_Company_Id,
                                               Hpd_Pref.c_Pcode_Journal_Type_Timebook_Adjustment);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Is_Overtime_Journal
  (
    i_Company_Id      number,
    i_Journal_Type_Id number
  ) return boolean is
  begin
    return i_Journal_Type_Id = Journal_Type_Id(i_Company_Id,
                                               Hpd_Pref.c_Pcode_Journal_Type_Overtime);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Transfer_Kind(i_Transfer_End date := null) return varchar2 is
  begin
    if i_Transfer_End is null then
      return Hpd_Pref.c_Transfer_Kind_Permanently;
    end if;
  
    return Hpd_Pref.c_Transfer_Kind_Temporarily;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Cast_Staff_Kind_By_Emp_Type(i_Employment_Type varchar2) return varchar2 is
  begin
    if i_Employment_Type = Hpd_Pref.c_Employment_Type_Internal_Parttime then
      return Href_Pref.c_Staff_Kind_Secondary;
    end if;
  
    return Href_Pref.c_Staff_Kind_Primary;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Changing_Transaction
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Trans_Type varchar2,
    i_Period     date
  ) return Hpd_Transactions%rowtype is
    result Hpd_Transactions%rowtype;
  begin
    select q.*
      into result
      from Hpd_Transactions q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Staff_Id = i_Staff_Id
       and q.Trans_Type = i_Trans_Type
       and q.Event in
           (Hpd_Pref.c_Transaction_Event_To_Be_Integrated, Hpd_Pref.c_Transaction_Event_In_Progress)
       and q.Begin_Date <= i_Period
       and Nvl(q.End_Date, Href_Pref.c_Max_Date) >= i_Period
     order by q.Begin_Date desc, q.Order_No desc
     fetch first row only;
  
    return result;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Closest_Trans_Info
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Trans_Type varchar2,
    i_Period     date,
    o_Trans_Id   out number,
    o_Action     out varchar2
  ) is
  begin
    select q.Trans_Id, q.Action
      into o_Trans_Id, o_Action
      from Hpd_Agreements q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Staff_Id = i_Staff_Id
       and q.Trans_Type = i_Trans_Type
       and q.Period = (select max(w.Period)
                         from Hpd_Agreements w
                        where w.Company_Id = i_Company_Id
                          and w.Filial_Id = i_Filial_Id
                          and w.Staff_Id = i_Staff_Id
                          and w.Trans_Type = i_Trans_Type
                          and w.Period <= i_Period);
  exception
    when No_Data_Found then
      o_Trans_Id := null;
      o_Action   := null;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Closest_Trans_Info
  (
    i_Company_Id       number,
    i_Filial_Id        number,
    i_Staff_Id         number,
    i_Trans_Type       varchar2,
    i_Period           date,
    i_Except_Jounal_Id number := null,
    o_Trans_Id         out number,
    o_Action           out varchar2,
    o_Period           out date
  ) is
  begin
    if i_Except_Jounal_Id is null then
      select q.Trans_Id, q.Action, q.Period
        into o_Trans_Id, o_Action, o_Period
        from Hpd_Agreements q
       where q.Company_Id = i_Company_Id
         and q.Filial_Id = i_Filial_Id
         and q.Staff_Id = i_Staff_Id
         and q.Trans_Type = i_Trans_Type
         and q.Period = (select max(w.Period)
                           from Hpd_Agreements w
                          where w.Company_Id = i_Company_Id
                            and w.Filial_Id = i_Filial_Id
                            and w.Staff_Id = i_Staff_Id
                            and w.Trans_Type = i_Trans_Type
                            and w.Period <= i_Period);
    else
      select q.Trans_Id, q.Action, q.Period
        into o_Trans_Id, o_Action, o_Period
        from Hpd_Agreements q
       where q.Company_Id = i_Company_Id
         and q.Filial_Id = i_Filial_Id
         and q.Staff_Id = i_Staff_Id
         and q.Trans_Type = i_Trans_Type
         and q.Period = (select max(w.Period)
                           from Hpd_Agreements w
                          where w.Company_Id = i_Company_Id
                            and w.Filial_Id = i_Filial_Id
                            and w.Staff_Id = i_Staff_Id
                            and w.Trans_Type = i_Trans_Type
                            and w.Period <= i_Period
                            and exists (select *
                                   from Hpd_Transactions Tr
                                  where Tr.Company_Id = i_Company_Id
                                    and Tr.Filial_Id = i_Filial_Id
                                    and Tr.Trans_Id = w.Trans_Id
                                    and Tr.Journal_Id <> i_Except_Jounal_Id))
         and exists (select *
                from Hpd_Transactions Tr
               where Tr.Company_Id = i_Company_Id
                 and Tr.Filial_Id = i_Filial_Id
                 and Tr.Trans_Id = q.Trans_Id
                 and Tr.Journal_Id <> i_Except_Jounal_Id);
    end if;
  exception
    when No_Data_Found then
      o_Trans_Id := null;
      o_Action   := null;
      o_Period   := null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Trans_Id_By_Period
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Trans_Type varchar2,
    i_Period     date
  ) return number is
    v_Trans_Id number;
    v_Action   varchar2(1);
  begin
    Closest_Trans_Info(i_Company_Id => i_Company_Id,
                       i_Filial_Id  => i_Filial_Id,
                       i_Staff_Id   => i_Staff_Id,
                       i_Trans_Type => i_Trans_Type,
                       i_Period     => i_Period,
                       o_Trans_Id   => v_Trans_Id,
                       o_Action     => v_Action);
  
    if v_Action = Hpd_Pref.c_Transaction_Action_Continue then
      return v_Trans_Id;
    end if;
  
    return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Closest_Schedule
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Period     date
  ) return Hpd_Trans_Schedules%rowtype is
    v_Trans_Id number;
  begin
    v_Trans_Id := Trans_Id_By_Period(i_Company_Id => i_Company_Id,
                                     i_Filial_Id  => i_Filial_Id,
                                     i_Staff_Id   => i_Staff_Id,
                                     i_Trans_Type => Hpd_Pref.c_Transaction_Type_Schedule,
                                     i_Period     => i_Period);
  
    if v_Trans_Id is null then
      return null;
    end if;
  
    return z_Hpd_Trans_Schedules.Load(i_Company_Id => i_Company_Id,
                                      i_Filial_Id  => i_Filial_Id,
                                      i_Trans_Id   => v_Trans_Id);
  
  end;

  ----------------------------------------------------------------------------------------------------
  Function Closest_Currency
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Period     date
  ) return Hpd_Trans_Currencies%rowtype is
    v_Trans_Id number;
  begin
    v_Trans_Id := Trans_Id_By_Period(i_Company_Id => i_Company_Id,
                                     i_Filial_Id  => i_Filial_Id,
                                     i_Staff_Id   => i_Staff_Id,
                                     i_Trans_Type => Hpd_Pref.c_Transaction_Type_Currency,
                                     i_Period     => i_Period);
  
    if v_Trans_Id is null then
      return null;
    end if;
  
    return z_Hpd_Trans_Currencies.Load(i_Company_Id => i_Company_Id,
                                       i_Filial_Id  => i_Filial_Id,
                                       i_Trans_Id   => v_Trans_Id);
  
  end;

  ----------------------------------------------------------------------------------------------------
  Function Closest_Rank
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Period     date
  ) return Hpd_Trans_Ranks%rowtype is
    v_Trans_Id number;
  begin
    v_Trans_Id := Trans_Id_By_Period(i_Company_Id => i_Company_Id,
                                     i_Filial_Id  => i_Filial_Id,
                                     i_Staff_Id   => i_Staff_Id,
                                     i_Trans_Type => Hpd_Pref.c_Transaction_Type_Rank,
                                     i_Period     => i_Period);
  
    if v_Trans_Id is null then
      return null;
    end if;
  
    return z_Hpd_Trans_Ranks.Take(i_Company_Id => i_Company_Id,
                                  i_Filial_Id  => i_Filial_Id,
                                  i_Trans_Id   => v_Trans_Id);
  
  end;

  ----------------------------------------------------------------------------------------------------
  Function Closest_Vacation_Limit
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Period     date
  ) return Hpd_Trans_Vacation_Limits%rowtype is
    v_Trans_Id number;
  begin
    v_Trans_Id := Trans_Id_By_Period(i_Company_Id => i_Company_Id,
                                     i_Filial_Id  => i_Filial_Id,
                                     i_Staff_Id   => i_Staff_Id,
                                     i_Trans_Type => Hpd_Pref.c_Transaction_Type_Vacation_Limit,
                                     i_Period     => i_Period);
  
    if v_Trans_Id is null then
      return null;
    end if;
  
    return z_Hpd_Trans_Vacation_Limits.Load(i_Company_Id => i_Company_Id,
                                            i_Filial_Id  => i_Filial_Id,
                                            i_Trans_Id   => v_Trans_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Closest_Contract
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Period     date
  ) return Hpd_Page_Contracts%rowtype is
    v_Trans_Id number;
    v_Page_Id  number;
  begin
    v_Trans_Id := Trans_Id_By_Period(i_Company_Id => i_Company_Id,
                                     i_Filial_Id  => i_Filial_Id,
                                     i_Staff_Id   => i_Staff_Id,
                                     i_Trans_Type => Hpd_Pref.c_Transaction_Type_Robot,
                                     i_Period     => i_Period);
  
    if v_Trans_Id is null then
      return null;
    end if;
  
    v_Page_Id := z_Hpd_Transactions.Load(i_Company_Id => i_Company_Id, --
                 i_Filial_Id => i_Filial_Id, --
                 i_Trans_Id => v_Trans_Id).Page_Id;
  
    return z_Hpd_Page_Contracts.Take(i_Company_Id => i_Company_Id,
                                     i_Filial_Id  => i_Filial_Id,
                                     i_Page_Id    => v_Page_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Closest_Robot
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Period     date
  ) return Hpd_Trans_Robots%rowtype is
    v_Trans_Id number;
  begin
    v_Trans_Id := Trans_Id_By_Period(i_Company_Id => i_Company_Id,
                                     i_Filial_Id  => i_Filial_Id,
                                     i_Staff_Id   => i_Staff_Id,
                                     i_Trans_Type => Hpd_Pref.c_Transaction_Type_Robot,
                                     i_Period     => i_Period);
  
    if v_Trans_Id is null then
      return null;
    end if;
  
    return z_Hpd_Trans_Robots.Load(i_Company_Id => i_Company_Id,
                                   i_Filial_Id  => i_Filial_Id,
                                   i_Trans_Id   => v_Trans_Id);
  
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Closest_Robot
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Period     date
  ) return Mrf_Robots%rowtype is
    r_Closest_Robot Hpd_Trans_Robots%rowtype;
  begin
    r_Closest_Robot := Closest_Robot(i_Company_Id => i_Company_Id,
                                     i_Filial_Id  => i_Filial_Id,
                                     i_Staff_Id   => i_Staff_Id,
                                     i_Period     => i_Period);
  
    if r_Closest_Robot.Company_Id is null then
      return null;
    end if;
  
    return z_Mrf_Robots.Load(i_Company_Id => r_Closest_Robot.Company_Id,
                             i_Filial_Id  => r_Closest_Robot.Filial_Id,
                             i_Robot_Id   => r_Closest_Robot.Robot_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Closest_Hrm_Robot
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Period     date
  ) return Hrm_Robots%rowtype is
    r_Closest_Robot Hpd_Trans_Robots%rowtype;
  begin
    r_Closest_Robot := Closest_Robot(i_Company_Id => i_Company_Id,
                                     i_Filial_Id  => i_Filial_Id,
                                     i_Staff_Id   => i_Staff_Id,
                                     i_Period     => i_Period);
  
    if r_Closest_Robot.Company_Id is null then
      return null;
    end if;
  
    return z_Hrm_Robots.Load(i_Company_Id => r_Closest_Robot.Company_Id,
                             i_Filial_Id  => r_Closest_Robot.Filial_Id,
                             i_Robot_Id   => r_Closest_Robot.Robot_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Closest_Fte
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Period     date
  ) return number is
    r_Closest_Robot Hpd_Trans_Robots%rowtype;
  begin
    r_Closest_Robot := Closest_Robot(i_Company_Id => i_Company_Id,
                                     i_Filial_Id  => i_Filial_Id,
                                     i_Staff_Id   => i_Staff_Id,
                                     i_Period     => i_Period);
  
    if r_Closest_Robot.Company_Id is null then
      return null;
    end if;
  
    return r_Closest_Robot.Fte;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Closest_Robot_Id
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Period     date
  ) return number is
  begin
    return Closest_Robot(i_Company_Id => i_Company_Id,
                         i_Filial_Id  => i_Filial_Id,
                         i_Staff_Id   => i_Staff_Id,
                         i_Period     => i_Period).Robot_Id;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Closest_Org_Unit_Id
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Period     date
  ) return number is
    r_Robot Hrm_Robots%rowtype;
  begin
    r_Robot := Get_Closest_Hrm_Robot(i_Company_Id => i_Company_Id,
                                     i_Filial_Id  => i_Filial_Id,
                                     i_Staff_Id   => i_Staff_Id,
                                     i_Period     => i_Period);
  
    return r_Robot.Org_Unit_Id;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Closest_Division_Id
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Period     date
  ) return number is
    r_Robot Mrf_Robots%rowtype;
  begin
    r_Robot := Get_Closest_Robot(i_Company_Id => i_Company_Id,
                                 i_Filial_Id  => i_Filial_Id,
                                 i_Staff_Id   => i_Staff_Id,
                                 i_Period     => i_Period);
  
    return r_Robot.Division_Id;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Closest_Job_Id
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Period     date
  ) return number is
    r_Robot Mrf_Robots%rowtype;
  begin
    r_Robot := Get_Closest_Robot(i_Company_Id => i_Company_Id,
                                 i_Filial_Id  => i_Filial_Id,
                                 i_Staff_Id   => i_Staff_Id,
                                 i_Period     => i_Period);
  
    return r_Robot.Job_Id;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Closest_Rank_Id
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Period     date
  ) return number is
  begin
    return Closest_Rank(i_Company_Id => i_Company_Id,
                        i_Filial_Id  => i_Filial_Id,
                        i_Staff_Id   => i_Staff_Id,
                        i_Period     => i_Period).Rank_Id;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Closest_Schedule_Id
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Period     date
  ) return number is
  begin
    return Closest_Schedule(i_Company_Id => i_Company_Id,
                            i_Filial_Id  => i_Filial_Id,
                            i_Staff_Id   => i_Staff_Id,
                            i_Period     => i_Period).Schedule_Id;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Closest_Currency_Id
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Period     date
  ) return number is
  begin
    return Closest_Currency(i_Company_Id => i_Company_Id,
                            i_Filial_Id  => i_Filial_Id,
                            i_Staff_Id   => i_Staff_Id,
                            i_Period     => i_Period).Currency_Id;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Closest_Vacation_Days_Limit
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Period     date
  ) return number is
  begin
    return Closest_Vacation_Limit(i_Company_Id => i_Company_Id,
                                  i_Filial_Id  => i_Filial_Id,
                                  i_Staff_Id   => i_Staff_Id,
                                  i_Period     => i_Period).Days_Limit;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Closest_Contractual_Wage
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Period     date
  ) return varchar2 is
  begin
    return Closest_Robot(i_Company_Id => i_Company_Id,
                         i_Filial_Id  => i_Filial_Id,
                         i_Staff_Id   => i_Staff_Id,
                         i_Period     => i_Period).Contractual_Wage;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Closest_Wage_Scale_Id
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Period     date
  ) return number is
  begin
    return Closest_Robot(i_Company_Id => i_Company_Id,
                         i_Filial_Id  => i_Filial_Id,
                         i_Staff_Id   => i_Staff_Id,
                         i_Period     => i_Period).Wage_Scale_Id;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Closest_Indicator_Value
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Staff_Id     number,
    i_Indicator_Id number,
    i_Period       date
  ) return number is
    v_Trans_Id number;
  begin
    v_Trans_Id := Trans_Id_By_Period(i_Company_Id => i_Company_Id,
                                     i_Filial_Id  => i_Filial_Id,
                                     i_Staff_Id   => i_Staff_Id,
                                     i_Trans_Type => Hpd_Pref.c_Transaction_Type_Operation,
                                     i_Period     => i_Period);
  
    if v_Trans_Id is null then
      return null;
    end if;
  
    return z_Hpd_Trans_Indicators.Take(i_Company_Id   => i_Company_Id,
                                       i_Filial_Id    => i_Filial_Id,
                                       i_Trans_Id     => v_Trans_Id,
                                       i_Indicator_Id => i_Indicator_Id).Indicator_Value;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Closest_Oper_Type_Id
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Staff_Id      number,
    i_Oper_Group_Id number,
    i_Period        date
  ) return number is
    v_Trans_Id number;
  
    --------------------------------------------------
    Function Take_Oper_Type_Id
    (
      i_Company_Id    number,
      i_Filial_Id     number,
      i_Trans_Id      number,
      i_Oper_Group_Id number
    ) return number is
      result number;
    begin
      begin
        select t.Oper_Type_Id
          into result
          from Hpd_Trans_Oper_Types t
         where t.Company_Id = i_Company_Id
           and t.Filial_Id = i_Filial_Id
           and t.Trans_Id = i_Trans_Id
           and exists (select *
                  from Hpr_Oper_Types s
                 where s.Company_Id = t.Company_Id
                   and s.Oper_Type_Id = t.Oper_Type_Id
                   and s.Oper_Group_Id = i_Oper_Group_Id);
      
        return result;
      exception
        when No_Data_Found then
          return null;
        when Too_Many_Rows then
          Hpd_Error.Raise_044(i_Staff_Name      => Href_Util.Staff_Name(i_Company_Id => i_Company_Id,
                                                                        i_Filial_Id  => i_Filial_Id,
                                                                        i_Staff_Id   => i_Staff_Id),
                              i_Oper_Group_Name => z_Hpr_Oper_Groups.Load(i_Company_Id => i_Company_Id, --
                                                   i_Oper_Group_Id => i_Oper_Group_Id).Name);
      end;
    end;
  begin
    v_Trans_Id := Trans_Id_By_Period(i_Company_Id => i_Company_Id,
                                     i_Filial_Id  => i_Filial_Id,
                                     i_Staff_Id   => i_Staff_Id,
                                     i_Trans_Type => Hpd_Pref.c_Transaction_Type_Operation,
                                     i_Period     => i_Period);
  
    if v_Trans_Id is null then
      return null;
    end if;
  
    return Take_Oper_Type_Id(i_Company_Id    => i_Company_Id,
                             i_Filial_Id     => i_Filial_Id,
                             i_Trans_Id      => v_Trans_Id,
                             i_Oper_Group_Id => i_Oper_Group_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Closest_Oper_Type_Ids
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Staff_Id      number,
    i_Oper_Group_Id number,
    i_Period        date
  ) return Array_Number is
    v_Trans_Id number;
  
    --------------------------------------------------
    Function Load_Oper_Type_Ids
    (
      i_Company_Id    number,
      i_Filial_Id     number,
      i_Trans_Id      number,
      i_Oper_Group_Id number
    ) return Array_Number is
      result Array_Number;
    begin
      begin
        select t.Oper_Type_Id
          bulk collect
          into result
          from Hpd_Trans_Oper_Types t
         where t.Company_Id = i_Company_Id
           and t.Filial_Id = i_Filial_Id
           and t.Trans_Id = i_Trans_Id
           and exists (select *
                  from Hpr_Oper_Types s
                 where s.Company_Id = t.Company_Id
                   and s.Oper_Type_Id = t.Oper_Type_Id
                   and s.Oper_Group_Id = i_Oper_Group_Id);
      
        return result;
      end;
    end;
  begin
    v_Trans_Id := Trans_Id_By_Period(i_Company_Id => i_Company_Id,
                                     i_Filial_Id  => i_Filial_Id,
                                     i_Staff_Id   => i_Staff_Id,
                                     i_Trans_Type => Hpd_Pref.c_Transaction_Type_Operation,
                                     i_Period     => i_Period);
  
    if v_Trans_Id is null then
      return Array_Number();
    end if;
  
    return Load_Oper_Type_Ids(i_Company_Id    => i_Company_Id,
                              i_Filial_Id     => i_Filial_Id,
                              i_Trans_Id      => v_Trans_Id,
                              i_Oper_Group_Id => i_Oper_Group_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Closest_Wage
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Period     date
  ) return number is
  begin
    if Get_Closest_Contractual_Wage(i_Company_Id => i_Company_Id,
                                    i_Filial_Id  => i_Filial_Id,
                                    i_Staff_Id   => i_Staff_Id,
                                    i_Period     => i_Period) = 'N' then
      return Hrm_Util.Closest_Wage(i_Company_Id    => i_Company_Id,
                                   i_Filial_Id     => i_Filial_Id,
                                   i_Wage_Scale_Id => Get_Closest_Wage_Scale_Id(i_Company_Id => i_Company_Id,
                                                                                i_Filial_Id  => i_Filial_Id,
                                                                                i_Staff_Id   => i_Staff_Id,
                                                                                i_Period     => i_Period),
                                   i_Period        => i_Period,
                                   i_Rank_Id       => Get_Closest_Rank_Id(i_Company_Id => i_Company_Id,
                                                                          i_Filial_Id  => i_Filial_Id,
                                                                          i_Staff_Id   => i_Staff_Id,
                                                                          i_Period     => i_Period));
    else
      return Get_Closest_Indicator_Value(i_Company_Id   => i_Company_Id,
                                         i_Filial_Id    => i_Filial_Id,
                                         i_Staff_Id     => i_Staff_Id,
                                         i_Indicator_Id => Href_Util.Indicator_Id(i_Company_Id => i_Company_Id,
                                                                                  i_Pcode      => Href_Pref.c_Pcode_Indicator_Wage),
                                         i_Period       => i_Period);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Closest_Contractual_Indicator_Value
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Staff_Id     number,
    i_Indicator_Id number,
    i_Period       date
  ) return number is
    r_Trans_Robots Hpd_Trans_Robots%rowtype;
    v_Rank_Id      number;
    result         number;
  begin
    r_Trans_Robots := Closest_Robot(i_Company_Id => i_Company_Id,
                                    i_Filial_Id  => i_Filial_Id,
                                    i_Staff_Id   => i_Staff_Id,
                                    i_Period     => i_Period);
  
    if r_Trans_Robots.Contractual_Wage = 'N' then
      v_Rank_Id := Get_Closest_Rank_Id(i_Company_Id => i_Company_Id,
                                       i_Filial_Id  => i_Filial_Id,
                                       i_Staff_Id   => i_Staff_Id,
                                       i_Period     => i_Period);
    
      result := Hrm_Util.Closest_Wage_Scale_Indicator_Value(i_Company_Id    => i_Company_Id,
                                                            i_Filial_Id     => i_Filial_Id,
                                                            i_Wage_Scale_Id => r_Trans_Robots.Wage_Scale_Id,
                                                            i_Indicator_Id  => i_Indicator_Id,
                                                            i_Period        => i_Period,
                                                            i_Rank_Id       => v_Rank_Id);
    end if;
  
    if result is null then
      result := Get_Closest_Indicator_Value(i_Company_Id   => i_Company_Id,
                                            i_Filial_Id    => i_Filial_Id,
                                            i_Staff_Id     => i_Staff_Id,
                                            i_Indicator_Id => i_Indicator_Id,
                                            i_Period       => i_Period);
    end if;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Current_Limit_Days
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number,
    i_Period     date
  ) return number is
    result number;
  begin
    select q.Free_Days
      into result
      from Hpd_Vacation_Turnover q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Staff_Id = i_Staff_Id
       and q.Period = (select max(q.Period)
                         from Hpd_Vacation_Turnover q
                        where q.Company_Id = i_Company_Id
                          and q.Filial_Id = i_Filial_Id
                          and q.Staff_Id = i_Staff_Id
                          and q.Period < i_Period
                          and q.Period >= Trunc(i_Period, 'yyyy'));
  
    return result;
  
  exception
    when No_Data_Found then
      return Get_Closest_Vacation_Days_Limit(i_Company_Id => i_Company_Id,
                                             i_Filial_Id  => i_Filial_Id,
                                             i_Staff_Id   => i_Staff_Id,
                                             i_Period     => i_Period);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Opened_Transaction_Dates
  (
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Staff_Id        number,
    i_Begin_Date      date,
    i_End_Date        date,
    i_Trans_Type      varchar2,
    i_With_Wage_Scale boolean := false
  ) return Array_Date is
    v_Trans_Id        number;
    v_Action          varchar2(1);
    v_Prev_Trans_Code varchar2(4000);
    v_Trans_Code      varchar2(4000);
    r_Robot           Hpd_Trans_Robots%rowtype;
    result            Array_Date := Array_Date();
  begin
    Closest_Trans_Info(i_Company_Id => i_Company_Id,
                       i_Filial_Id  => i_Filial_Id,
                       i_Staff_Id   => i_Staff_Id,
                       i_Trans_Type => i_Trans_Type,
                       i_Period     => i_Begin_Date,
                       o_Trans_Id   => v_Trans_Id,
                       o_Action     => v_Action);
  
    v_Prev_Trans_Code := Get_Trans_Code(i_Company_Id => i_Company_Id,
                                        i_Filial_Id  => i_Filial_Id,
                                        i_Trans_Id   => null,
                                        i_Trans_Type => i_Trans_Type);
  
    for r in (select Qr.Period Period_Begin,
                     Lead(Qr.Period) Over(order by Qr.Period) - 1 Period_End,
                     Qr.Trans_Id,
                     Qr.Action
                from (select p.Period, p.Trans_Id, p.Action
                        from Hpd_Agreements p
                       where p.Company_Id = i_Company_Id
                         and p.Filial_Id = i_Filial_Id
                         and p.Staff_Id = i_Staff_Id
                         and p.Trans_Type = i_Trans_Type
                         and p.Period between i_Begin_Date and i_End_Date
                      union
                      select i_Begin_Date, v_Trans_Id, v_Action
                        from Dual) Qr)
    loop
      exit when r.Action = Hpd_Pref.c_Transaction_Action_Stop;
    
      if i_With_Wage_Scale and i_Trans_Type = Hpd_Pref.c_Transaction_Type_Robot then
        r_Robot := Closest_Robot(i_Company_Id => i_Company_Id,
                                 i_Filial_Id  => i_Filial_Id,
                                 i_Staff_Id   => i_Staff_Id,
                                 i_Period     => r.Period_Begin);
      
        result := result multiset union distinct
                  Hrm_Util.Register_Change_Dates(i_Company_Id    => i_Company_Id,
                                                 i_Filial_Id     => i_Filial_Id,
                                                 i_Wage_Scale_Id => r_Robot.Wage_Scale_Id,
                                                 i_Begin_Date    => r.Period_Begin,
                                                 i_End_Date      => Nvl(r.Period_End, i_End_Date));
      end if;
    
      v_Trans_Code := Get_Trans_Code(i_Company_Id => i_Company_Id,
                                     i_Filial_Id  => i_Filial_Id,
                                     i_Trans_Id   => r.Trans_Id,
                                     i_Trans_Type => i_Trans_Type);
    
      if v_Prev_Trans_Code <> v_Trans_Code then
        Fazo.Push(result, r.Period_Begin);
      
        v_Prev_Trans_Code := v_Trans_Code;
      end if;
    end loop;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Opened_Transaction_Dates
  (
    i_Company_Id        number,
    i_Filial_Id         number,
    i_Staff_Id          number,
    i_Begin_Date        date,
    i_End_Date          date,
    i_Trans_Types       Array_Varchar2,
    i_With_Wage_Scale   boolean := false,
    i_Partition_By_Year boolean := false
  ) return Hpd_Pref.Transaction_Part_Nt is
    v_Partition_Fmt  varchar2(4) := 'Mon';
    v_Dismissal_Date date;
    v_Opened_Dates   Array_Date;
    v_Part           Hpd_Pref.Transaction_Part_Rt;
    result           Hpd_Pref.Transaction_Part_Nt := Hpd_Pref.Transaction_Part_Nt();
    v_Index          number;
    v_Count          number;
  
    --------------------------------------------------
    Function Get_Last_Day(i_Date date) return date is
    begin
      if i_Partition_By_Year then
        return Htt_Util.Year_Last_Day(i_Date);
      end if;
      return Last_Day(i_Date);
    end;
  begin
    if i_Partition_By_Year then
      v_Partition_Fmt := 'yyyy';
    end if;
  
    v_Dismissal_Date := z_Href_Staffs.Load(i_Company_Id => i_Company_Id, --
                        i_Filial_Id => i_Filial_Id, --
                        i_Staff_Id => i_Staff_Id).Dismissal_Date;
  
    v_Opened_Dates := Array_Date(Least(i_End_Date, Nvl(v_Dismissal_Date, i_End_Date)) + 1);
  
    for i in 1 .. i_Trans_Types.Count
    loop
      v_Opened_Dates := v_Opened_Dates multiset union distinct
                        Get_Opened_Transaction_Dates(i_Company_Id      => i_Company_Id,
                                                     i_Filial_Id       => i_Filial_Id,
                                                     i_Staff_Id        => i_Staff_Id,
                                                     i_Begin_Date      => i_Begin_Date,
                                                     i_End_Date        => i_End_Date,
                                                     i_Trans_Type      => i_Trans_Types(i),
                                                     i_With_Wage_Scale => i_With_Wage_Scale);
    end loop;
  
    Fazo.Sort(v_Opened_Dates);
  
    v_Part.Part_Begin := v_Opened_Dates(1);
    v_Index           := 2;
    v_Count           := v_Opened_Dates.Count;
  
    while v_Index <= v_Count
    loop
      v_Part.Part_End := v_Opened_Dates(v_Index) - 1;
    
      if Trunc(v_Part.Part_Begin, v_Partition_Fmt) = Trunc(v_Part.Part_End, v_Partition_Fmt) then
        v_Index := v_Index + 1;
      else
        v_Part.Part_End := Get_Last_Day(v_Part.Part_Begin);
      end if;
    
      Result.Extend;
      result(Result.Count) := v_Part;
    
      v_Part.Part_Begin := v_Part.Part_End + 1;
    end loop;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Trans_Code
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Trans_Id   number,
    i_Trans_Type varchar2
  ) return varchar2 is
    r_Robot      Hpd_Trans_Robots%rowtype;
    v_Indicators Array_Varchar2;
    result       Gmap := Gmap;
  begin
    case i_Trans_Type
      when Hpd_Pref.c_Transaction_Type_Robot then
        r_Robot := z_Hpd_Trans_Robots.Take(i_Company_Id => i_Company_Id,
                                           i_Filial_Id  => i_Filial_Id,
                                           i_Trans_Id   => i_Trans_Id);
      
        Result.Put(z.Robot_Id, r_Robot.Robot_Id);
        Result.Put(z.Division_Id, r_Robot.Division_Id);
        Result.Put(z.Job_Id, r_Robot.Job_Id);
        Result.Put(z.Fte_Id, r_Robot.Fte_Id);
        Result.Put(z.Fte, r_Robot.Fte);
        Result.Put(z.Wage_Scale_Id, r_Robot.Wage_Scale_Id);
      when Hpd_Pref.c_Transaction_Type_Schedule then
        Result.Put(z.Schedule_Id,
                   z_Hpd_Trans_Schedules.Take(i_Company_Id => i_Company_Id, --
                   i_Filial_Id => i_Filial_Id, --
                   i_Trans_Id => i_Trans_Id).Schedule_Id);
      when Hpd_Pref.c_Transaction_Type_Currency then
        Result.Put(z.Currency_Id,
                   z_Hpd_Trans_Currencies.Take(i_Company_Id => i_Company_Id, --
                   i_Filial_Id => i_Filial_Id, --
                   i_Trans_Id => i_Trans_Id).Currency_Id);
      when Hpd_Pref.c_Transaction_Type_Rank then
        Result.Put(z.Rank_Id,
                   z_Hpd_Trans_Ranks.Take(i_Company_Id => i_Company_Id, --
                   i_Filial_Id => i_Filial_Id, --
                   i_Trans_Id => i_Trans_Id).Rank_Id);
      when Hpd_Pref.c_Transaction_Type_Vacation_Limit then
        Result.Put(z.Days_Limit,
                   z_Hpd_Trans_Vacation_Limits.Take(i_Company_Id => i_Company_Id, --
                   i_Filial_Id => i_Filial_Id, --
                   i_Trans_Id => i_Trans_Id).Days_Limit);
      when Hpd_Pref.c_Transaction_Type_Operation then
        select Json_Object('o' value Ti.Oper_Type_Id,
                           'i' value Tv.Indicator_Id,
                           'e' value Tv.Indicator_Value null on null)
          bulk collect
          into v_Indicators
          from Hpd_Trans_Oper_Type_Indicators Ti
          join Hpd_Trans_Indicators Tv
            on Tv.Company_Id = Ti.Company_Id
           and Tv.Filial_Id = Ti.Filial_Id
           and Tv.Trans_Id = Ti.Trans_Id
           and Tv.Indicator_Id = Ti.Indicator_Id
         where Ti.Company_Id = i_Company_Id
           and Ti.Filial_Id = i_Filial_Id
           and Ti.Trans_Id = i_Trans_Id
         order by Ti.Oper_Type_Id, Tv.Indicator_Id, Tv.Indicator_Value;
      
        Result.Put(Zt.Hpd_Trans_Oper_Types.Name, v_Indicators);
      else
        null;
    end case;
  
    return Result.Json();
  end;

  ----------------------------------------------------------------------------------------------------
  Function Tname_Page(i_Page_Id number) return varchar2 is
    r_Page Hpd_Journal_Pages%rowtype;
    result varchar2(4000);
  begin
    result := b.Translate(Ui_Kernel.Gen_Table_Message(Lower(Zt.Hpd_Journal_Pages.Name)));
  
    if i_Page_Id is null then
      return result;
    end if;
  
    r_Page := z_Hpd_Journal_Pages.Take(i_Company_Id => Md_Env.Company_Id,
                                       i_Filial_Id  => Md_Env.Filial_Id,
                                       i_Page_Id    => i_Page_Id);
  
    return result || ': ' || t('# $1{staff_name}',
                               Href_Util.Staff_Name(i_Company_Id => r_Page.Company_Id,
                                                    i_Filial_Id  => r_Page.Filial_Id,
                                                    i_Staff_Id   => r_Page.Staff_Id));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Tname_Overtime(i_Overtime_Id number) return varchar2 is
    r_Overtime Hpd_Journal_Overtimes%rowtype;
    result     varchar2(4000);
  begin
    result := b.Translate(Ui_Kernel.Gen_Table_Message(Lower(Zt.Hpd_Journal_Overtimes.Name)));
  
    if i_Overtime_Id is null then
      return result;
    end if;
  
    r_Overtime := z_Hpd_Journal_Overtimes.Take(i_Company_Id  => Md_Env.Company_Id,
                                               i_Filial_Id   => Md_Env.Filial_Id,
                                               i_Overtime_Id => i_Overtime_Id);
  
    return result || ': ' || t('# $1{staff_name}',
                               Href_Util.Staff_Name(i_Company_Id => r_Overtime.Company_Id,
                                                    i_Filial_Id  => r_Overtime.Filial_Id,
                                                    i_Staff_Id   => r_Overtime.Staff_Id));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Tname_Timeoffs(i_Timeoff_Id number) return varchar2 is
    r_Timeoffs Hpd_Journal_Timeoffs%rowtype;
    result     varchar2(4000);
  begin
    result := b.Translate(Ui_Kernel.Gen_Table_Message(Lower(Zt.Hpd_Journal_Timeoffs.Name)));
  
    if i_Timeoff_Id is null then
      return result;
    end if;
  
    r_Timeoffs := z_Hpd_Journal_Timeoffs.Take(i_Company_Id => Md_Env.Company_Id,
                                              i_Filial_Id  => Md_Env.Filial_Id,
                                              i_Timeoff_Id => i_Timeoff_Id);
  
    return result || ': ' || t('# $1{staff_name}',
                               Href_Util.Staff_Name(i_Company_Id => r_Timeoffs.Company_Id,
                                                    i_Filial_Id  => r_Timeoffs.Filial_Id,
                                                    i_Staff_Id   => r_Timeoffs.Staff_Id));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Table_Uri_Journal(i_Journal_Id number) return varchar2 is
    v_Journal_Type_Id number;
    v_Pcode           varchar2(20);
    v_Uri             varchar2(100);
  begin
    v_Journal_Type_Id := z_Hpd_Journals.Take(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id, i_Journal_Id => i_Journal_Id).Journal_Type_Id;
    v_Pcode           := z_Hpd_Journal_Types.Take(i_Company_Id => Ui.Company_Id, i_Journal_Type_Id => v_Journal_Type_Id).Pcode;
  
    if v_Pcode in
       (Hpd_Pref.c_Pcode_Journal_Type_Hiring, Hpd_Pref.c_Pcode_Journal_Type_Hiring_Multiple) then
      v_Uri := '/vhr/hpd/audit/hiring_audit';
    elsif v_Pcode in
          (Hpd_Pref.c_Pcode_Journal_Type_Transfer, Hpd_Pref.c_Pcode_Journal_Type_Transfer_Multiple) then
      v_Uri := '/vhr/hpd/audit/transfer_audit';
    elsif v_Pcode in (Hpd_Pref.c_Pcode_Journal_Type_Dismissal,
                      Hpd_Pref.c_Pcode_Journal_Type_Dismissal_Multiple) then
      v_Uri := '/vhr/hpd/audit/dismissal_audit';
    elsif v_Pcode = Hpd_Pref.c_Pcode_Journal_Type_Wage_Change then
      v_Uri := '/vhr/hpd/audit/wage_change_audit';
    elsif v_Pcode = Hpd_Pref.c_Pcode_Journal_Type_Schedule_Change then
      v_Uri := '/vhr/hpd/audit/schedule_change_audit';
    elsif v_Pcode = Hpd_Pref.c_Pcode_Journal_Type_Sick_Leave then
      v_Uri := '/vhr/hpd/audit/sick_leave_audit';
    elsif v_Pcode = Hpd_Pref.c_Pcode_Journal_Type_Business_Trip then
      v_Uri := '/vhr/hpd/audit/businnes_trip_audit';
    elsif v_Pcode = Hpd_Pref.c_Pcode_Journal_Type_Overtime then
      v_Uri := '/vhr/hpd/audit/overtime_audit';
    end if;
  
    return v_Uri || '?journal_id=' || i_Journal_Id;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Table_Uri_Page(i_Page_Id number) return varchar2 is
    v_Journal_Id number;
  begin
    v_Journal_Id := z_Hpd_Journal_Pages.Take(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id, i_Page_Id => i_Page_Id).Journal_Id;
  
    return Table_Uri_Journal(v_Journal_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Table_Uri_Overtime(i_Overtime_Id number) return varchar2 is
    v_Journal_Id number;
  begin
    v_Journal_Id := z_Hpd_Journal_Overtimes.Take(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id, i_Overtime_Id => i_Overtime_Id).Journal_Id;
  
    return Table_Uri_Journal(v_Journal_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Table_Uri_Timeoff(i_Timeoff_Id number) return varchar2 is
    v_Journal_Id number;
  begin
    v_Journal_Id := z_Hpd_Journal_Timeoffs.Take(i_Company_Id => Ui.Company_Id, i_Filial_Id => Ui.Filial_Id, i_Timeoff_Id => i_Timeoff_Id).Journal_Id;
  
    return Table_Uri_Journal(v_Journal_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Singular_Journal
  (
    i_Company_Id       number,
    i_Filial_Id        number,
    i_Journal_Id       number,
    i_Page_Id          number,
    i_Journal_Type_Id  number,
    i_Singular_Type_Id number,
    i_Pages_Cnt        number
  ) is
    --------------------------------------------------
    Function Has_Other_Pages return boolean is
      v_Dummy varchar2(1);
    begin
      select 'x'
        into v_Dummy
        from Hpd_Journal_Pages Jp
       where Jp.Company_Id = i_Company_Id
         and Jp.Filial_Id = i_Filial_Id
         and Jp.Journal_Id = i_Journal_Id
         and Jp.Page_Id <> i_Page_Id
         and Rownum = 1;
    
      return true;
    exception
      when No_Data_Found then
        return false;
    end;
  begin
    if i_Journal_Type_Id <> i_Singular_Type_Id then
      return;
    end if;
  
    if i_Pages_Cnt <> 1 then
      Hpd_Error.Raise_045;
    end if;
  
    if Has_Other_Pages then
      Hpd_Error.Raise_047;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Staff_Timebook_Adjustment_Calced
  (
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Staff_Id        number,
    i_Adjustment_Date date,
    i_Kind            varchar2,
    i_Journal_Id      number := null
  ) return varchar2 is
    v_Dummy varchar2(1);
  begin
    select 'X'
      into v_Dummy
      from Hpd_Lock_Adjustments q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Staff_Id = i_Staff_Id
       and q.Adjustment_Date = i_Adjustment_Date
       and q.Kind = i_Kind
       and (i_Journal_Id is null or q.Journal_Id <> i_Journal_Id);
  
    return 'Y';
  exception
    when No_Data_Found then
      return 'N';
  end;

  ----------------------------------------------------------------------------------------------------
  Function User_Name
  (
    i_Company_Id number,
    i_User_Id    number
  ) return varchar2 is
  begin
    return z_Md_Users.Load(i_Company_Id => i_Company_Id, i_User_Id => i_User_Id).Name;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Journal_Type_Name
  (
    i_Company_Id      number,
    i_Journal_Type_Id number
  ) return varchar2 is
  begin
    return z_Hpd_Journal_Types.Load(i_Company_Id      => i_Company_Id,
                                    i_Journal_Type_Id => i_Journal_Type_Id).Name;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Application_Type_Name
  (
    i_Company_Id          number,
    i_Application_Type_Id number
  ) return varchar2 is
  begin
    return z_Hpd_Application_Types.Load(i_Company_Id          => i_Company_Id,
                                        i_Application_Type_Id => i_Application_Type_Id).Name;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Application_Type_Id
  (
    i_Company_Id number,
    i_Pcode      varchar2
  ) return number Result_Cache is
    result number;
  begin
    select q.Application_Type_Id
      into result
      from Hpd_Application_Types q
     where q.Company_Id = i_Company_Id
       and q.Pcode = i_Pcode;
  
    return result;
  exception
    when No_Data_Found then
      Hpd_Error.Raise_057;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Application_Has_Result
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Application_Id number
  ) return varchar2 is
    v_Application_Type_Id number;
    v_Pcode               varchar2(50);
    v_Dummy               number;
  begin
    v_Application_Type_Id := z_Hpd_Applications.Load(i_Company_Id => i_Company_Id, i_Filial_Id => i_Filial_Id, --
                             i_Application_Id => i_Application_Id).Application_Type_Id;
  
    v_Pcode := z_Hpd_Application_Types.Load(i_Company_Id => i_Company_Id, i_Application_Type_Id => v_Application_Type_Id).Pcode;
  
    begin
      if v_Pcode = Hpd_Pref.c_Pcode_Application_Type_Create_Robot then
        --------------------------------------------------
        select 1
          into v_Dummy
          from Hpd_Application_Robots t
         where t.Company_Id = i_Company_Id
           and t.Filial_Id = i_Filial_Id
           and t.Application_Id = i_Application_Id
           and Rownum = 1;
      else
        --------------------------------------------------
        select 1
          into v_Dummy
          from Hpd_Application_Journals t
         where t.Company_Id = i_Company_Id
           and t.Filial_Id = i_Filial_Id
           and t.Application_Id = i_Application_Id
           and exists (select *
                  from Hpd_Journals q
                 where q.Company_Id = t.Company_Id
                   and q.Filial_Id = t.Filial_Id
                   and q.Journal_Id = t.Journal_Id
                   and q.Posted = 'Y');
      end if;
    exception
      when No_Data_Found then
        return 'N';
    end;
  
    return 'Y';
  end;

  ----------------------------------------------------------------------------------------------------
  -- application grant part
  ----------------------------------------------------------------------------------------------------
  Function Application_Grant_Part
  (
    i_Company_Id          number,
    i_Application_Type_Id number
  ) return varchar2 is
    v_Pcode Hpd_Application_Types.Pcode%type;
  begin
    v_Pcode := z_Hpd_Application_Types.Load(i_Company_Id => i_Company_Id, i_Application_Type_Id => i_Application_Type_Id).Pcode;
  
    case v_Pcode
      when Hpd_Pref.c_Pcode_Application_Type_Create_Robot then
        return Hpd_Pref.c_App_Grant_Part_Create_Robot;
      when Hpd_Pref.c_Pcode_Application_Type_Hiring then
        return Hpd_Pref.c_App_Grant_Part_Hiring;
      when Hpd_Pref.c_Pcode_Application_Type_Transfer then
        return Hpd_Pref.c_App_Grant_Part_Transfer;
      when Hpd_Pref.c_Pcode_Application_Type_Transfer_Multiple then
        return Hpd_Pref.c_App_Grant_Part_Transfer;
      when Hpd_Pref.c_Pcode_Application_Type_Dismissal then
        return Hpd_Pref.c_App_Grant_Part_Dismissal;
    end case;
  end;

  ----------------------------------------------------------------------------------------------------           
  Function Sign_Process_Id_By_Pcode
  (
    i_Company_Id number,
    i_Pcode      varchar2
  ) return number is
    v_Process_Id number;
  begin
    select q.Process_Id
      into v_Process_Id
      from Mdf_Sign_Processes q
     where q.Company_Id = i_Company_Id
       and q.Pcode = i_Pcode;
  
    return v_Process_Id;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------         
  Function Journal_Type_Sign_Template_Id
  (
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Journal_Type_Id number
  ) return number is
    v_Template_Id number;
  begin
    select q.Template_Id
      into v_Template_Id
      from Hpd_Sign_Templates q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Journal_Type_Id = i_Journal_Type_Id;
  
    return v_Template_Id;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------         
  Function Has_Journal_Type_Sign_Template
  (
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Journal_Type_Id number
  ) return boolean is
    v_Template_Id number;
  begin
    v_Template_Id := Journal_Type_Sign_Template_Id(i_Company_Id      => i_Company_Id,
                                                   i_Filial_Id       => i_Filial_Id,
                                                   i_Journal_Type_Id => i_Journal_Type_Id);
  
    if v_Template_Id is not null then
      return true;
    else
      return false;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------         
  Function Load_Sign_Document_Status
  (
    i_Company_Id  number,
    i_Document_Id number
  ) return varchar2 is
  begin
    return z_Mdf_Sign_Documents.Take(i_Company_Id => i_Company_Id, i_Document_Id => i_Document_Id).Status;
  end;

  ----------------------------------------------------------------------------------------------------
  -- employment type
  ----------------------------------------------------------------------------------------------------
  Function t_Employment_Type_Main_Job return varchar2 is
  begin
    return t('employment_type:main_job');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Employment_Type_External_Parttime return varchar2 is
  begin
    return t('employment_type:external_parttime');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Employment_Type_Internal_Parttime return varchar2 is
  begin
    return t('employment_type:internal_parttime');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Employment_Type_Contractor return varchar2 is
  begin
    return t('employment_type:contractor');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Employment_Type(i_Employment_Type varchar2) return varchar2 is
  begin
    return --
    case i_Employment_Type --
    when Hpd_Pref.c_Employment_Type_Main_Job then t_Employment_Type_Main_Job --
    when Hpd_Pref.c_Employment_Type_External_Parttime then t_Employment_Type_External_Parttime --
    when Hpd_Pref.c_Employment_Type_Internal_Parttime then t_Employment_Type_Internal_Parttime --
    when Hpd_Pref.c_Employment_Type_Contractor then t_Employment_Type_Contractor --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Employment_Types(i_Include_Contractors boolean := false) return Matrix_Varchar2 is
    v_Types      Array_Varchar2 := Array_Varchar2(Hpd_Pref.c_Employment_Type_Main_Job,
                                                  Hpd_Pref.c_Employment_Type_External_Parttime,
                                                  Hpd_Pref.c_Employment_Type_Internal_Parttime);
    v_Translates Array_Varchar2 := Array_Varchar2(t_Employment_Type_Main_Job,
                                                  t_Employment_Type_External_Parttime,
                                                  t_Employment_Type_Internal_Parttime);
  begin
    if i_Include_Contractors then
      Fazo.Push(v_Types, Hpd_Pref.c_Employment_Type_Contractor);
      Fazo.Push(v_Translates, t_Employment_Type_Contractor);
    end if;
  
    return Matrix_Varchar2(v_Types, v_Translates);
  end;

  ----------------------------------------------------------------------------------------------------
  -- lock interval kind
  ----------------------------------------------------------------------------------------------------
  Function t_Lock_Interval_Kind_Timebook return varchar2 is
  begin
    return t('lock_interval_kind:timebook');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Lock_Interval_Kind_Timeoff return varchar2 is
  begin
    return t('lock_interval_kind:timeoff');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Lock_Interval_Kind_Performance return varchar2 is
  begin
    return t('lock_interval_kind:performance');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Lock_Interval_Kind_Sales_Bonus_Personal_Sales return varchar2 is
  begin
    return t('lock_interval_kind:sales bonus personal sales');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Lock_Interval_Kind_Sales_Bonus_Department_Sales return varchar2 is
  begin
    return t('lock_interval_kind:sales bonus department sales');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Lock_Interval_Kind_Sales_Bonus_Successful_Delivery return varchar2 is
  begin
    return t('lock_interval_kind:sales bonus successful delivery');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Lock_Interval_Kind(i_Lock_Interval_Kind varchar2) return varchar2 is
  begin
    return --
    case i_Lock_Interval_Kind --
    when Hpd_Pref.c_Lock_Interval_Kind_Timebook then t_Lock_Interval_Kind_Timebook --
    when Hpd_Pref.c_Lock_Interval_Kind_Timeoff then t_Lock_Interval_Kind_Timeoff --
    when Hpd_Pref.c_Lock_Interval_Kind_Performance then t_Lock_Interval_Kind_Performance --
    when Hpd_Pref.c_Lock_Interval_Kind_Sales_Bonus_Personal_Sales then t_Lock_Interval_Kind_Sales_Bonus_Personal_Sales --
    when Hpd_Pref.c_Lock_Interval_Kind_Sales_Bonus_Department_Sales then t_Lock_Interval_Kind_Sales_Bonus_Department_Sales --
    when Hpd_Pref.c_Lock_Interval_Kind_Sales_Bonus_Successful_Delivery then t_Lock_Interval_Kind_Sales_Bonus_Successful_Delivery --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Lock_Interval_Kinds return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Hpd_Pref.c_Lock_Interval_Kind_Timebook,
                                          Hpd_Pref.c_Lock_Interval_Kind_Timeoff,
                                          Hpd_Pref.c_Lock_Interval_Kind_Performance,
                                          Hpd_Pref.c_Lock_Interval_Kind_Sales_Bonus_Personal_Sales,
                                          Hpd_Pref.c_Lock_Interval_Kind_Sales_Bonus_Department_Sales,
                                          Hpd_Pref.c_Lock_Interval_Kind_Sales_Bonus_Successful_Delivery),
                           Array_Varchar2(t_Lock_Interval_Kind_Timebook,
                                          t_Lock_Interval_Kind_Timeoff,
                                          t_Lock_Interval_Kind_Performance,
                                          t_Lock_Interval_Kind_Sales_Bonus_Personal_Sales,
                                          t_Lock_Interval_Kind_Sales_Bonus_Department_Sales,
                                          t_Lock_Interval_Kind_Sales_Bonus_Successful_Delivery));
  end;

  ----------------------------------------------------------------------------------------------------
  Function Charge_Lock_Interval_Kinds return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Hpd_Pref.c_Lock_Interval_Kind_Timebook,
                                          Hpd_Pref.c_Lock_Interval_Kind_Timeoff,
                                          Hpd_Pref.c_Lock_Interval_Kind_Performance),
                           Array_Varchar2(t_Lock_Interval_Kind_Timebook,
                                          t_Lock_Interval_Kind_Timeoff,
                                          t_Lock_Interval_Kind_Performance));
  end;

  ----------------------------------------------------------------------------------------------------
  -- trial period
  ----------------------------------------------------------------------------------------------------
  Function t_Trial_Period_Exists return varchar2 is
  begin
    return t('trial_period:exists');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Trial_Period_Not_Exists return varchar2 is
  begin
    return t('trial_period:not_exists');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Trial_Period(i_Trial_Period varchar2) return varchar2 is
  begin
    return --
    case i_Trial_Period --
    when 'Y' then t_Trial_Period_Exists --
    when 'N' then t_Trial_Period_Not_Exists --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Trial_Periods return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2('Y', --
                                          'N'),
                           Array_Varchar2(t_Trial_Period_Exists, --
                                          t_Trial_Period_Not_Exists));
  end;

  ----------------------------------------------------------------------------------------------------
  -- transfer kind
  ----------------------------------------------------------------------------------------------------
  Function t_Transfer_Kind_Permanently return varchar2 is
  begin
    return t('transfer_kind:permanently');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Transfer_Kind_Temporarily return varchar2 is
  begin
    return t('transfer_kind:temporarily');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Transfer_Kind(i_Transfer_Kind varchar2) return varchar2 is
  begin
    return --
    case i_Transfer_Kind --
    when Hpd_Pref.c_Transfer_Kind_Permanently then t_Transfer_Kind_Permanently --
    when Hpd_Pref.c_Transfer_Kind_Temporarily then t_Transfer_Kind_Temporarily --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Transfer_Kinds return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Hpd_Pref.c_Transfer_Kind_Permanently,
                                          Hpd_Pref.c_Transfer_Kind_Temporarily),
                           Array_Varchar2(t_Transfer_Kind_Permanently, --
                                          t_Transfer_Kind_Temporarily));
  end;

  ----------------------------------------------------------------------------------------------------
  -- journal types
  ----------------------------------------------------------------------------------------------------
  Function t_Journal_Type_Hiring return varchar2 is
  begin
    return t('journal_type: hiring');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Journal_Type_Transfer return varchar2 is
  begin
    return t('journal_type: transfer');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Journal_Type_Dismissal return varchar2 is
  begin
    return t('journal_type: dismissal');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Journal_Type_Schedule_Change return varchar2 is
  begin
    return t('journal_type: schedule_change');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Journal_Type_Wage_Change return varchar2 is
  begin
    return t('journal_type: wage_change');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Journal_Type_Rank_Change return varchar2 is
  begin
    return t('journal_type: rank_change');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Journal_Type_Limit_Change return varchar2 is
  begin
    return t('journal_type: vacation_limit_change');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Journal_Type(i_Journal_Type varchar2) return varchar2 is
  begin
    return --
    case i_Journal_Type --
    when Hpd_Pref.c_Journal_Type_Hiring then t_Journal_Type_Hiring --
    when Hpd_Pref.c_Journal_Type_Transfer then t_Journal_Type_Transfer --
    when Hpd_Pref.c_Journal_Type_Dismissal then t_Journal_Type_Dismissal --
    when Hpd_Pref.c_Journal_Type_Schedule_Change then t_Journal_Type_Schedule_Change --
    when Hpd_Pref.c_Journal_Type_Wage_Change then t_Journal_Type_Wage_Change --
    when Hpd_Pref.c_Journal_Type_Rank_Change then t_Journal_Type_Rank_Change --
    when Hpd_Pref.c_Journal_Type_Limit_Change then t_Journal_Type_Limit_Change --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Journal_Types return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Hpd_Pref.c_Journal_Type_Hiring,
                                          Hpd_Pref.c_Journal_Type_Transfer,
                                          Hpd_Pref.c_Journal_Type_Dismissal,
                                          Hpd_Pref.c_Journal_Type_Schedule_Change,
                                          Hpd_Pref.c_Journal_Type_Wage_Change,
                                          Hpd_Pref.c_Journal_Type_Rank_Change,
                                          Hpd_Pref.c_Journal_Type_Limit_Change),
                           Array_Varchar2(t_Journal_Type_Hiring,
                                          t_Journal_Type_Transfer,
                                          t_Journal_Type_Dismissal,
                                          t_Journal_Type_Schedule_Change,
                                          t_Journal_Type_Wage_Change,
                                          t_Journal_Type_Rank_Change,
                                          t_Journal_Type_Limit_Change));
  end;

  ----------------------------------------------------------------------------------------------------
  -- fte kinds
  ----------------------------------------------------------------------------------------------------
  Function t_Fte_Kind_Full return varchar2 is
  begin
    return t('fte_kind:full');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Fte_Kind_Half return varchar2 is
  begin
    return t('fte_kind:half');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Fte_Kind_Quarter return varchar2 is
  begin
    return t('fte_kind:quarter');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Fte_Kind_Occupied return varchar2 is
  begin
    return t('fte_kind:occupied');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Fte_Kind_Custom return varchar2 is
  begin
    return t('fte_kind:custom');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Fte_Kinds return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Hpd_Pref.c_Fte_Kind_Full,
                                          Hpd_Pref.c_Fte_Kind_Half,
                                          Hpd_Pref.c_Fte_Kind_Quarter,
                                          Hpd_Pref.c_Fte_Kind_Occupied,
                                          Hpd_Pref.c_Fte_Kind_Custom),
                           Array_Varchar2(t_Fte_Kind_Full,
                                          t_Fte_Kind_Half,
                                          t_Fte_Kind_Quarter,
                                          t_Fte_Kind_Occupied,
                                          t_Fte_Kind_Custom));
  end;

  ----------------------------------------------------------------------------------------------------
  -- Adjustment Kinds
  ----------------------------------------------------------------------------------------------------
  Function t_Adjustment_Kind_Full return varchar2 is
  begin
    return t('adjustment_kind: full');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Adjustment_Kind_Incomplete return varchar2 is
  begin
    return t('adjustment_kind: incomplete');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Adjustment_Kind(i_Adjustment_Kind varchar2) return varchar2 is
  begin
    return --
    case i_Adjustment_Kind --
    when Hpd_Pref.c_Adjustment_Kind_Full then t_Adjustment_Kind_Full --
    when Hpd_Pref.c_Adjustment_Kind_Incomplete then t_Adjustment_Kind_Incomplete --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Adjustment_Kinds return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Hpd_Pref.c_Adjustment_Kind_Full,
                                          Hpd_Pref.c_Adjustment_Kind_Incomplete),
                           Array_Varchar2(t_Adjustment_Kind_Full, t_Adjustment_Kind_Incomplete));
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Cv_Contract_Kind_Simple return varchar2 is
  begin
    return t('cv_contract_kind:simple');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Cv_Contract_Kind_Cyclical return varchar2 is
  begin
    return t('cv_contract_kind:cyclical');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Cv_Contract_Kind(i_Contract_Kind varchar2) return varchar2 is
  begin
    return --
    case i_Contract_Kind --
    when Hpd_Pref.c_Cv_Contract_Kind_Simple then t_Cv_Contract_Kind_Simple --
    when Hpd_Pref.c_Cv_Contract_Kind_Cyclical then t_Cv_Contract_Kind_Cyclical --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Cv_Contract_Kinds return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Hpd_Pref.c_Cv_Contract_Kind_Simple,
                                          Hpd_Pref.c_Cv_Contract_Kind_Cyclical),
                           Array_Varchar2(t_Cv_Contract_Kind_Simple, t_Cv_Contract_Kind_Cyclical));
  end;

  ----------------------------------------------------------------------------------------------------
  -- Application Status
  ----------------------------------------------------------------------------------------------------
  Function t_Application_Status_New return varchar2 is
  begin
    return t('application_status:new');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Application_Status_Waiting return varchar2 is
  begin
    return t('application_status:waiting');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Application_Status_Approved return varchar2 is
  begin
    return t('application_status:approved');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Application_Status_In_Progress return varchar2 is
  begin
    return t('application_status:in_progress');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Application_Status_Completed return varchar2 is
  begin
    return t('application_status:completed');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Application_Status_Canceled return varchar2 is
  begin
    return t('application_status:canceled');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Application_Status(i_Status varchar2) return varchar2 is
  begin
    return --
    case i_Status --
    when Hpd_Pref.c_Application_Status_New then t_Application_Status_New --
    when Hpd_Pref.c_Application_Status_Waiting then t_Application_Status_Waiting --
    when Hpd_Pref.c_Application_Status_Approved then t_Application_Status_Approved --
    when Hpd_Pref.c_Application_Status_In_Progress then t_Application_Status_In_Progress --
    when Hpd_Pref.c_Application_Status_Completed then t_Application_Status_Completed --
    when Hpd_Pref.c_Application_Status_Canceled then t_Application_Status_Canceled --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Application_Statuses return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Hpd_Pref.c_Application_Status_New,
                                          Hpd_Pref.c_Application_Status_Waiting,
                                          Hpd_Pref.c_Application_Status_Approved,
                                          Hpd_Pref.c_Application_Status_In_Progress,
                                          Hpd_Pref.c_Application_Status_Completed,
                                          Hpd_Pref.c_Application_Status_Canceled),
                           Array_Varchar2(t_Application_Status_New,
                                          t_Application_Status_Waiting,
                                          t_Application_Status_Approved,
                                          t_Application_Status_In_Progress,
                                          t_Application_Status_Completed,
                                          t_Application_Status_Canceled));
  end;

  ----------------------------------------------------------------------------------------------------
  -- Contract Employment
  ----------------------------------------------------------------------------------------------------
  Function t_Contract_Employment_Freelancer return varchar2 is
  begin
    return t('contract_employment:freelancer');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Contract_Employment_Staff_Member return varchar2 is
  begin
    return t('contract_employment:staff member');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Contract_Employment(i_Status varchar2) return varchar2 is
  begin
    return --
    case i_Status --
    when Hpd_Pref.c_Contract_Employment_Freelancer then t_Contract_Employment_Freelancer --
    when Hpd_Pref.c_Contract_Employment_Staff_Member then t_Contract_Employment_Staff_Member --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Contract_Employments return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Hpd_Pref.c_Contract_Employment_Freelancer,
                                          Hpd_Pref.c_Contract_Employment_Staff_Member),
                           Array_Varchar2(t_Contract_Employment_Freelancer,
                                          t_Contract_Employment_Staff_Member));
  end;

  ----------------------------------------------------------------------------------------------------
  -- journal notification
  ----------------------------------------------------------------------------------------------------
  Function t_Notification_Title_Journal_Post
  (
    i_Company_Id      number,
    i_User_Id         number,
    i_Journal_Type_Id number
  ) return varchar2 is
  begin
    return t('$1{person_name} posted $2{journal_type_name} journal',
             User_Name(i_Company_Id, i_User_Id),
             Journal_Type_Name(i_Company_Id, i_Journal_Type_Id));
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Notification_Title_Journal_Unpost
  (
    i_Company_Id      number,
    i_User_Id         number,
    i_Journal_Type_Id number
  ) return varchar2 is
  begin
    return t('$1{person_name} unposted $2{journal_type_name} journal',
             User_Name(i_Company_Id, i_User_Id),
             Journal_Type_Name(i_Company_Id, i_Journal_Type_Id));
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Notification_Title_Journal_Save
  (
    i_Company_Id      number,
    i_User_Id         number,
    i_Journal_Type_Id number
  ) return varchar2 is
  begin
    return t('$1{person_name} saved $2{journal_type_name} journal',
             User_Name(i_Company_Id, i_User_Id),
             Journal_Type_Name(i_Company_Id, i_Journal_Type_Id));
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Notification_Title_Journal_Update
  (
    i_Company_Id      number,
    i_User_Id         number,
    i_Journal_Type_Id number
  ) return varchar2 is
  begin
    return t('$1{person_name} updated $2{journal_type_name} journal',
             User_Name(i_Company_Id, i_User_Id),
             Journal_Type_Name(i_Company_Id, i_Journal_Type_Id));
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Notification_Title_Journal_Delete
  (
    i_Company_Id      number,
    i_User_Id         number,
    i_Journal_Type_Id number
  ) return varchar2 is
  begin
    return t('$1{person_name} deleted $2{journal_type_name} journal',
             User_Name(i_Company_Id, i_User_Id),
             Journal_Type_Name(i_Company_Id, i_Journal_Type_Id));
  end;

  ----------------------------------------------------------------------------------------------------
  -- application notification
  ----------------------------------------------------------------------------------------------------
  Function t_Notification_Title_Application_Created
  (
    i_Company_Id          number,
    i_User_Id             number,
    i_Application_Type_Id number,
    i_Application_Number  varchar2
  ) return varchar2 is
  begin
    return t('$1{user_name} created an application for $2{application_type_name} $3{application_number}',
             User_Name(i_Company_Id, i_User_Id),
             Application_Type_Name(i_Company_Id, i_Application_Type_Id),
             i_Application_Number);
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Notification_Title_Application_Status_Changed
  (
    i_Company_Id          number,
    i_User_Id             number,
    i_Application_Type_Id number,
    i_Application_Number  varchar2,
    i_Old_Status          varchar2,
    i_New_Status          varchar2
  ) return varchar2 is
  begin
    return t('$1{user_name} changed status of application for $2{application_type_name} $3{application_number} from $4{old_status_name} to $5{new_status_name}',
             User_Name(i_Company_Id, i_User_Id),
             Application_Type_Name(i_Company_Id, i_Application_Type_Id),
             i_Application_Number,
             t_Application_Status(i_Old_Status),
             t_Application_Status(i_New_Status));
  end;

end Hpd_Util;
/
