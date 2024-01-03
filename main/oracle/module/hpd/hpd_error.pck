create or replace package Hpd_Error is
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_001(i_Staff_Name varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_002
  (
    i_Staff_Name        varchar2,
    i_Intersection_Date date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_003;
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_004
  (
    i_Staff_Name    varchar2,
    i_Exceed_Date   date,
    i_Exceed_Amount number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_005
  (
    i_Staff_Name       varchar2,
    i_First_Dismissal  date,
    i_Second_Dismissal date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_006
  (
    i_Interval_Kind varchar2,
    i_Trans_Type    varchar2,
    i_Staff_Name    varchar2,
    i_Begin_Date    date,
    i_End_Date      date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_007
  (
    i_Staff_Name  varchar2,
    i_Trans_Type  varchar2,
    i_Trans_Date  date,
    i_Hiring_Date date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_008
  (
    i_Staff_Name     varchar2,
    i_Trans_Type     varchar2,
    i_Trans_Date     date,
    i_Dismissal_Date date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_009(i_Staff_Name varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_010
  (
    i_Staff_Name       varchar2,
    i_Primary_Hiring   date,
    i_Secondary_Hiring date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_011
  (
    i_Staff_Name          varchar2,
    i_Primary_Dismissal   date,
    i_Secondary_Dismissal date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_012
  (
    i_Staff_Name  varchar2,
    i_Hiring_Date date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_013
  (
    i_Staff_Name  varchar2,
    i_Hiring_Date date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_014
  (
    i_Staff_Name  varchar2,
    i_Trans_Type  varchar2,
    i_Trans_Date  date,
    i_Hiring_Date date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_015
  (
    i_Staff_Name    varchar2,
    i_Dismissed_Cnt number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_016
  (
    i_Staff_Name     varchar2,
    i_Hiring_Date    date,
    i_Dismissal_Date date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_017(i_Staff_Name varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_018(i_Staff_Name varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_019
  (
    i_Staff_Name       varchar2,
    i_Secondary_Hiring date,
    i_Primary_Hiring   date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_020
  (
    i_Staff_Name     varchar2,
    i_Hiring_Date    date,
    i_Dismissal_Date date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_021(i_Staff_Name varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_022(i_Journal_Number varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_023(i_Journal_Number varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_024
  (
    i_Staff_Name      varchar2,
    i_Interval_Begin  date,
    i_Interval_End    date,
    i_Intersect_Begin date,
    i_Intersect_End   date,
    i_Interval_Kind   varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_025
  (
    i_Staff_Name    varchar2,
    i_Interval_Kind varchar2,
    i_Charge_Begin  date,
    i_Charge_End    date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_026(i_Contract_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_027(i_Contract_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_028
  (
    i_Person_Name varchar2,
    i_Fact_Month  date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_029(i_Contract_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_030;
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_031(i_Contract_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_032
  (
    i_Timeoff_Id number,
    i_Journal_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_033(i_Staff_Name varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_034
  (
    i_Journal_Type   varchar2,
    i_Expected_Types Array_Varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_035(i_Journal_Number varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_036
  (
    i_Journal_Type   varchar2,
    i_Expected_Types Array_Varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_037
  (
    i_Staff_Name     varchar2,
    i_Journal_Number varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_038(i_Journal_Number varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_039(i_Contract_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_040(i_Contract_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_041(i_Contract_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_042
  (
    i_Overtime_Id number,
    i_Journal_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_043;
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_044
  (
    i_Staff_Name      varchar2,
    i_Oper_Group_Name varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_045;
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_046(i_Journal_Type_Name varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_047;
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_048;
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_049(i_Staff_Name varchar2);
  ---------------------------------------------------------------------------------------------------- 
  Procedure Raise_050
  (
    i_Date  date,
    i_Month date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_051;
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_052(i_Time_Kind_Name varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_053
  (
    i_Staff_Name      varchar2,
    i_Adjustment_Date date,
    i_Journal_Number  varchar2,
    i_Journal_Date    date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_054
  (
    i_Staff_Name      varchar2,
    i_Adjustment_Date date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_055
  (
    i_Application_Number varchar2,
    i_Status             varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_056
  (
    i_Application_Number varchar2,
    i_Status             varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_057;
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_058
  (
    i_Application_Number varchar2,
    i_Status             varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_059
  (
    i_Application_Number varchar2,
    i_Status             varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_060
  (
    i_Application_Number varchar2,
    i_Status             varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_061
  (
    i_Application_Number varchar2,
    i_Status             varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_062
  (
    i_Application_Number varchar2,
    i_Status             varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_063
  (
    i_Application_Number varchar2,
    i_Status             varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_064
  (
    i_Application_Number varchar2,
    i_Status             varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_065(i_Application_Number varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_066
  (
    i_Application_Number        varchar2,
    i_Journal_Number            varchar2,
    i_Journal_Employee_Name     varchar2,
    i_Application_Employee_Name varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_067
  (
    i_Application_Number varchar2,
    i_Journal_Number     varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_068
  (
    i_Jounal_Id         number,
    i_Journal_Number    varchar2,
    i_Journal_Type_Name varchar2,
    i_Source_Table      varchar2,
    i_Source_Id         number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_069
  (
    i_Jounal_Id         number,
    i_Journal_Number    varchar2,
    i_Journal_Type_Name varchar2,
    i_Source_Table      varchar2,
    i_Source_Id         number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_070
  (
    i_Jounal_Id         number,
    i_Journal_Number    varchar2,
    i_Journal_Type_Name varchar2,
    i_Source_Table      varchar2,
    i_Source_Id         number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_071
  (
    i_Wrong_Application_Type    varchar2,
    i_Expected_Application_Type varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_072;
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_073(i_Staff_Id number);
  ----------------------------------------------------------------------------------------------------  
  Procedure Raise_074
  (
    i_Journal_Id     number,
    i_Journal_Number varchar2,
    i_Staff_Name     varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_075
  (
    i_Interval_Kind varchar2,
    i_Staff_Name    varchar2,
    i_Timeoff_Date  date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_076
  (
    i_Interval_Kind   varchar2,
    i_Staff_Name      varchar2,
    i_Adjustment_Date date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_077;
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_078(i_Employee_Name varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_079(i_Application_Number varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_080(i_Application_Type_Name varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_081;
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_082(i_Staff_Name varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_083(i_Staff_Name varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_084
  (
    i_Document_Status varchar2,
    i_Journal_Number  varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_085
  (
    i_Document_Status varchar2,
    i_Journal_Number  varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_086
  (
    i_Document_Status varchar2,
    i_Journal_Number  varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_087
  (
    i_Document_Status varchar2,
    i_Journal_Number  varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_088(i_Journal_Type_Name varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_089(i_Journal_Number varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_090
  (
    i_Document_Status varchar2,
    i_Journal_Number  varchar2
  );
end Hpd_Error;
/
create or replace package body Hpd_Error is
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
  Procedure Error
  (
    i_Code    varchar2,
    i_Message varchar2,
    i_Title   varchar2 := null,
    i_S1      varchar2 := null,
    i_S2      varchar2 := null,
    i_S3      varchar2 := null,
    i_S4      varchar2 := null,
    i_S5      varchar2 := null
  ) is
  begin
    b.Raise_Extended(i_Code    => Verifix.Hpd_Error_Code || i_Code,
                     i_Message => i_Message,
                     i_Title   => i_Title,
                     i_S1      => i_S1,
                     i_S2      => i_S2,
                     i_S3      => i_S3,
                     i_S4      => i_S4,
                     i_S5      => i_S5);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function t_Interval_Kind(i_Interval_Kind varchar2) return varchar2 is
  begin
    case i_Interval_Kind
      when Hpd_Pref.c_Lock_Interval_Kind_Timebook then
        return t('error:interval_kind:timebook');
      when Hpd_Pref.c_Lock_Interval_Kind_Performance then
        return t('error:interval_kind:perfomance');
      when Hpd_Pref.c_Lock_Interval_Kind_Timeoff_Business_Trip then
        return t('error:interval_kind:business_trip');
      when Hpd_Pref.c_Lock_Interval_Kind_Timeoff_Sick_Leave then
        return t('error:interval_kind:sick_leave');
      when Hpd_Pref.c_Lock_Interval_Kind_Timeoff_Vacation then
        return t('error:interval_kind:vacation');
      when Hpd_Pref.c_Lock_Interval_Kind_Timeoff then
        return t('error:interval_kind:timeoff');
      when Hpd_Pref.c_Lock_Interval_Kind_Sales_Bonus_Personal_Sales then
        return t('error:interval_kind:sales_bonus_personal_sales');
      when Hpd_Pref.c_Lock_Interval_Kind_Sales_Bonus_Department_Sales then
        return t('error:interval_kind:sales_bonus_department_sales');
      when Hpd_Pref.c_Lock_Interval_Kind_Sales_Bonus_Successful_Delivery then
        return t('error:interval_kind:sales_bonus_successful_delivery');
      else
        b.Raise_Not_Implemented;
    end case;
  
    return null;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function t_Trans_Type(i_Trans_Type varchar2) return varchar2 is
  begin
    case i_Trans_Type
      when Hpd_Pref.c_Transaction_Type_Robot then
        return t('error:trans_type:robot');
      when Hpd_Pref.c_Transaction_Type_Operation then
        return t('error:trans_type:operation');
      when Hpd_Pref.c_Transaction_Type_Schedule then
        return t('error:trans_type:schedule');
      when Hpd_Pref.c_Transaction_Type_Rank then
        return t('error:trans_type:rank');
      when Hpd_Pref.c_Transaction_Type_Vacation_Limit then
        return t('error:trans_type:vacation limit');
      when Hpd_Pref.c_Transaction_Type_Currency then
        return t('error:trans_type:currency');
      else
        b.Raise_Not_Implemented;
    end case;
  
    return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Journal_Source_Info
  (
    i_Jounal_Id         number,
    i_Journal_Type_Name varchar2,
    i_Source_Table      varchar2,
    i_Source_Id         number,
    o_Source_Name       out varchar2,
    o_Source_Id         out number
  ) is
  begin
    if i_Source_Table is null then
      o_Source_Name := i_Journal_Type_Name;
      o_Source_Id   := i_Jounal_Id;
    elsif i_Source_Table = Zt.Htm_Recommended_Rank_Documents.Name then
      o_Source_Name := t('error:source:recommended rank document');
      o_Source_Id   := i_Source_Id;
    else
      b.Raise_Not_Implemented;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_001(i_Staff_Name varchar2) is
  begin
    Error(i_Code    => '001',
          i_Message => t('001:message:unpost staff $1 hiring', i_Staff_Name),
          i_Title   => t('001:title:cannot delete staff'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_002
  (
    i_Staff_Name        varchar2,
    i_Intersection_Date date
  ) is
  begin
    Error(i_Code    => '002',
          i_Message => t('002:message:employee $1{employee_name} staffs intersect on $2{intersection_date}',
                         i_Staff_Name,
                         i_Intersection_Date),
          i_Title   => t('002:title:staff intersection found'),
          i_S1      => t('002:solution:move hiring date after $2{intersection_date}',
                         i_Intersection_Date));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_003 is
  begin
    Error(i_Code    => '003',
          i_Message => t('003:message:got unregistered vacation turnover days kind'),
          i_Title   => t('003:title:days kind not found {vacation turnover days kind}'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_004
  (
    i_Staff_Name    varchar2,
    i_Exceed_Date   date,
    i_Exceed_Amount number
  ) is
  begin
    Error(i_Code    => '004',
          i_Message => t('004:message:cannot post vacation for $1{staff_name} on $2{exceed_date}, exceed_amount=$3',
                         i_Staff_Name,
                         i_Exceed_Date,
                         i_Exceed_Amount),
          i_Title   => t('004:title:vacation limit exceeded'),
          i_S1      => t('004:solution:add vacation limit days or decrease vacation days'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_005
  (
    i_Staff_Name       varchar2,
    i_First_Dismissal  date,
    i_Second_Dismissal date
  ) is
  begin
    Error(i_Code    => '005',
          i_Message => t('005:message:staff $1{staff_name} has dismissal on $1{first_dismissal_date} and $2{second_dismissal_data_two}',
                         i_Staff_Name,
                         i_First_Dismissal,
                         i_Second_Dismissal),
          i_Title   => t('005:title:two dismissals found'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_006
  (
    i_Interval_Kind varchar2,
    i_Trans_Type    varchar2,
    i_Staff_Name    varchar2,
    i_Begin_Date    date,
    i_End_Date      date
  ) is
    v_t_Interval_Kind varchar2(50) := t_Interval_Kind(i_Interval_Kind);
    v_t_Trans_Type    varchar2(50) := t_Trans_Type(i_Trans_Type);
  
    --------------------------------------------------
    Function Blocked_Period
    (
      i_Begin_Date date,
      i_End_Date   date
    ) return varchar2 is
      result varchar2(100) := to_char(i_End_Date, 'month yyyy');
    begin
      if Trunc(i_Begin_Date, 'mon') != Trunc(i_End_Date, 'mon') then
        result := to_char(i_Begin_Date, 'month yyyy') || ' – ' || result;
      end if;
    
      return result;
    end;
  begin
    Error(i_Code    => '006',
          i_Message => t('006:message:$1{interval_kind} blocks $2{trans_type} changes for staff $3{staff_name} between $4{begin_date} and $5{end_date}',
                         v_t_Interval_Kind,
                         v_t_Trans_Type,
                         i_Staff_Name,
                         i_Begin_Date,
                         i_End_Date),
          i_Title   => t('006:title:locked interval found'),
          i_S1      => t('006:solution:unpost $1{interval_kind} on $2{blocked_period}',
                         v_t_Interval_Kind,
                         Blocked_Period(i_Begin_Date, i_End_Date)),
          i_S2      => t('006:solution:move $1{trans_type} change date after $2{block_end_date}',
                         v_t_Trans_Type,
                         i_End_Date));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_007
  (
    i_Staff_Name  varchar2,
    i_Trans_Type  varchar2,
    i_Trans_Date  date,
    i_Hiring_Date date
  ) is
  begin
    Error(i_Code    => '007',
          i_Message => t('007:message:cannot post transaction for $1{staff_name}, because $2{trans_type} transaction on $3{trans_date} comes before hiring_date ($4{hiring_date})',
                         i_Staff_Name,
                         t_Trans_Type(i_Trans_Type),
                         i_Trans_Date,
                         i_Hiring_Date),
          i_Title   => t('007:title:found transaction before hiring'),
          i_S1      => t('007:solution:move transaction date after hiring date ($1{hiring_date})',
                         i_Hiring_Date),
          i_S2      => t('007:solution:move hiring date before transaction date ($1{trans_date})',
                         i_Trans_Date));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_008
  (
    i_Staff_Name     varchar2,
    i_Trans_Type     varchar2,
    i_Trans_Date     date,
    i_Dismissal_Date date
  ) is
  begin
    Error(i_Code    => '008',
          i_Message => t('008:message:cannot post transaction for $1{staff_name}, because $2{trans_type} transaction on $3{trans_date} comes after dimissal ($4{dismissal_date})',
                         i_Staff_Name,
                         t_Trans_Type(i_Trans_Type),
                         i_Trans_Date,
                         i_Dismissal_Date),
          i_Title   => t('008:title:found transaction after dismissal'),
          i_S1      => t('008:solution:move transaction date before dismissal date ($1{dismissal_date})',
                         i_Dismissal_Date),
          i_S2      => t('008:solution:move dismissal date after transaction date ($1{trans_date})',
                         i_Trans_Date));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_009(i_Staff_Name varchar2) is
  begin
    Error(i_Code    => '009',
          i_Message => t('009:message:to remove $1{staff_name} hirings all transactions should be unposted',
                         i_Staff_Name),
          i_Title   => t('009:title:staff has posted transactions'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_010
  (
    i_Staff_Name       varchar2,
    i_Primary_Hiring   date,
    i_Secondary_Hiring date
  ) is
  begin
    Error(i_Code    => '010',
          i_Message => t('010:message:secondary job for staff $1{staff_name} started ($2{secondary_hiring}) before primary job ($3{primary_hiring})',
                         i_Staff_Name,
                         i_Secondary_Hiring,
                         i_Primary_Hiring),
          i_Title   => t('010:title:secondary job cross out primary job'),
          i_S1      => t('010:solution:move secondary hiring date after primary hiring date ($1{primary_hiring})',
                         i_Primary_Hiring));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_011
  (
    i_Staff_Name          varchar2,
    i_Primary_Dismissal   date,
    i_Secondary_Dismissal date
  ) is
  begin
    Error(i_Code    => '011',
          i_Message => t('011:message:secondary job for staff $1{staff_name} ended ($2{secondary_dismissal}) after primary job ($3{primary_dismissal})',
                         i_Staff_Name,
                         i_Secondary_Dismissal,
                         i_Primary_Dismissal),
          i_Title   => t('011:title:secondary job cross out primary job'),
          i_S1      => t('011:solution:move secondary dismissal date before primary dismissal date ($1{primary_hiring})',
                         i_Primary_Dismissal));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_012
  (
    i_Staff_Name  varchar2,
    i_Hiring_Date date
  ) is
  begin
    Error(i_Code    => '012',
          i_Message => t('012:message:staff $1{staff_name} secondary job requires primary job to be created',
                         i_Staff_Name),
          i_Title   => t('012:title:primary job not found'),
          i_S1      => t('012:solution:create primary job for staff $1{staff_name} before $2{hiring_date}',
                         i_Staff_Name,
                         i_Hiring_Date));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_013
  (
    i_Staff_Name  varchar2,
    i_Hiring_Date date
  ) is
  begin
    Error(i_Code    => '013',
          i_Message => t('013:message:multiple primary jobs found after $1{hiring_date} for staff $2{staff_name}',
                         i_Hiring_Date,
                         i_Staff_Name),
          i_Title   => t('013:title:secondary job intersects multiple primary jobs'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_014
  (
    i_Staff_Name  varchar2,
    i_Trans_Type  varchar2,
    i_Trans_Date  date,
    i_Hiring_Date date
  ) is
  begin
    Error(i_Code    => '014',
          i_Message => t('014:message:cannot post transaction for $1{staff_name}, because $2{trans_type} transaction on $3{trans_date} comes before hiring_date ($4{hiring_date})',
                         i_Staff_Name,
                         t_Trans_Type(i_Trans_Type),
                         i_Trans_Date,
                         i_Hiring_Date),
          i_Title   => t('014:title:transaction before hiring date'),
          i_S1      => t('014:solution:move transaction date after hiring date ($1{hiring_date})',
                         i_Hiring_Date),
          i_S2      => t('014:solution:move hiring date before transaction date ($2{trans_date})',
                         i_Trans_Date));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_015
  (
    i_Staff_Name    varchar2,
    i_Dismissed_Cnt number
  ) is
  begin
    Error(i_Code    => '015',
          i_Message => t('015:message:staff $1{staff_name} was dismissed $2{dismissed_cnt} times',
                         i_Staff_Name,
                         i_Dismissed_Cnt),
          i_Title   => t('015:title:multiple dismissals found'),
          i_S1      => t('015:solution:unpost one of dismissals'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_016
  (
    i_Staff_Name     varchar2,
    i_Hiring_Date    date,
    i_Dismissal_Date date
  ) is
  begin
    Error(i_Code    => '016',
          i_Message => t('016:message:hiring date ($1{hiring_date}) for staff $2{staff_name} should not come after dismissal date ($3{dismissal_date})',
                         i_Hiring_Date,
                         i_Staff_Name,
                         i_Dismissal_Date),
          i_Title   => t('016:title:hiring after dismissal'),
          i_S1      => t('016:solution:move hiring date before dismissal date ($1{dismissal_date})',
                         i_Dismissal_Date),
          i_S2      => t('016:solution:move dismissal date after desired hiring date ($1{hiring_date})',
                         i_Hiring_Date));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_017(i_Staff_Name varchar2) is
  begin
    Error(i_Code    => '017',
          i_Message => t('017:message:cannot remove hiring. staff $1{staff_name} is already dismissed',
                         i_Staff_Name),
          i_S1      => t('017:solution:unpost dismissal and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_018(i_Staff_Name varchar2) is
  begin
    Error(i_Code    => '018',
          i_Message => t('018:message:cannot remove hiring. staff $1{staff_name} has secondary jobs',
                         i_Staff_Name),
          i_S1      => t('018:solution:remove all secondary jobs and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_019
  (
    i_Staff_Name       varchar2,
    i_Secondary_Hiring date,
    i_Primary_Hiring   date
  ) is
  begin
    Error(i_Code    => '019',
          i_Message => t('019:message:cannot change hiring date. secondary job for staff $1{staff_name} starts ($2{secondary_hiring}) before hiring date ($3{primary_hiring})',
                         i_Staff_Name,
                         i_Secondary_Hiring,
                         i_Primary_Hiring),
          i_S1      => t('019:solution:move hiring date before secondary job start ($1{secondary_hiring})',
                         i_Secondary_Hiring),
          i_S2      => t('019:solution:move secondary job start after hiring date ($1{orimary_hiring})',
                         i_Primary_Hiring));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_020
  (
    i_Staff_Name     varchar2,
    i_Hiring_Date    date,
    i_Dismissal_Date date
  ) is
  begin
    Error(i_Code    => '020',
          i_Message => t('020:message:dismissal date ($1{dismissal_date}) for staff $2{staff_name} should not come before hiring date ($3{hiring_date})',
                         i_Dismissal_Date,
                         i_Staff_Name,
                         i_Hiring_Date),
          i_Title   => t('020:title:dismissal before hiring'),
          i_S1      => t('020:solution:move dismissal date after hiring date ($1{hiring_date})',
                         i_Hiring_Date),
          i_S2      => t('020:solution:move hiring date before desired dismissal date ($1{dismissal_date})',
                         i_Dismissal_Date));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_021(i_Staff_Name varchar2) is
  begin
    Error(i_Code    => '021',
          i_Message => t('021:message:staff kind changed for staff $1{staff_name} when transfering other position',
                         i_Staff_Name),
          i_Title   => t('021:title:cannot change staff kind'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_022(i_Journal_Number varchar2) is
  begin
    Error(i_Code    => '022',
          i_Message => t('022:message:journal $1{journal_number} already posted', i_Journal_Number));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_023(i_Journal_Number varchar2) is
  begin
    Error(i_Code    => '023',
          i_Message => t('023:message:to unpost journal $1{journal_number} it should be initially posted',
                         i_Journal_Number));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_024
  (
    i_Staff_Name      varchar2,
    i_Interval_Begin  date,
    i_Interval_End    date,
    i_Intersect_Begin date,
    i_Intersect_End   date,
    i_Interval_Kind   varchar2
  ) is
    v_t_Interval_Kind varchar2(50) := t_Interval_Kind(i_Interval_Kind);
  
    --------------------------------------------------
    Function Give_Solution return varchar2 is
      v_Begin_Inside boolean := i_Interval_Begin between i_Intersect_Begin and i_Intersect_End;
      v_End_Inside   boolean := i_Interval_End between i_Intersect_Begin and i_Intersect_End;
    begin
      case
        when v_Begin_Inside and not v_End_Inside then
          return t('024:solution:move $1{interval_kind} start date after $2{intersect_end}',
                   v_t_Interval_Kind,
                   i_Intersect_End);
        when not v_Begin_Inside and v_End_Inside then
          return t('024:solution:move $1{interval_kind} end date before $2{intersect_start}',
                   v_t_Interval_Kind,
                   i_Intersect_Begin);
        when v_Begin_Inside and v_End_Inside then
          return t('024:solution:move $1{interval_kind} out of $2{intersect_start} and $3{intersect_end}',
                   v_t_Interval_Kind,
                   i_Intersect_Begin,
                   i_Intersect_End);
        else
          b.Raise_Not_Implemented;
      end case;
    
      return null;
    end;
  begin
    Error(i_Code    => '024',
          i_Message => t('024:message:found intersection for staff $1{staff_name} on $2{intersect_start} – $3{intersect_date}',
                         i_Staff_Name,
                         i_Intersect_Begin,
                         i_Intersect_End),
          i_Title   => t('024:title:cannot post $1{interval_kind}', v_t_Interval_Kind),
          i_S1      => Give_Solution);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_025
  (
    i_Staff_Name    varchar2,
    i_Interval_Kind varchar2,
    i_Charge_Begin  date,
    i_Charge_End    date
  ) is
  begin
    Error(i_Code    => '025',
          i_Message => t('025:message:cannot unpost $1{interval_kind} for staff $2{staff_name}, found charge linked to interval on $3{charge_begin} – $4{charge_end}',
                         t_Interval_Kind(i_Interval_Kind),
                         i_Staff_Name,
                         i_Charge_Begin,
                         i_Charge_End),
          i_Title   => t('025:title:used charge found'),
          i_S1      => t('025:solution:remove charge by deleting its book'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_026(i_Contract_Id number) is
  begin
    Error(i_Code    => '026',
          i_Message => t('026:message:cv contract $1{contract_id} already posted', i_Contract_Id));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_027(i_Contract_Id number) is
  begin
    Error(i_Code    => '027',
          i_Message => t('027:message:to unpost cv contract $1{contract_id} it should be initially posted',
                         i_Contract_Id));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_028
  (
    i_Person_Name varchar2,
    i_Fact_Month  date
  ) is
  begin
    Error(i_Code    => '028',
          i_Message => t('028:message:cannot unpost cv contract for $1{person_name}, found facts linked to interval on $2{facts_month}',
                         i_Person_Name,
                         to_char(i_Fact_Month, 'month yyyy')),
          i_Title   => t('028:title:used facts found'),
          i_S1      => t('028:solution:unpost facts and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_029(i_Contract_Id number) is
  begin
    Error(i_Code    => '029',
          i_Message => t('029:message:to early close cv contract $1{contract_id} it should be initially posted',
                         i_Contract_Id));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_030 is
  begin
    Error(i_Code    => '030',
          i_Message => t('030:message:fatal:there is not any changed transactions'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_031(i_Contract_Id number) is
  begin
    Error(i_Code    => '031',
          i_Message => t('031:message:cv contract $1{contract_id} must have date for early closure',
                         i_Contract_Id));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_032
  (
    i_Timeoff_Id number,
    i_Journal_Id number
  ) is
  begin
    Error(i_Code    => '032',
          i_Message => t('032:message:cannot save timeoff. Timeoffs journal cannot be changed, trying to change timeoff $1{timeoff_id} in journal $2{journal_id}',
                         i_Timeoff_Id,
                         i_Journal_Id));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_033(i_Staff_Name varchar2) is
  begin
    Error(i_Code    => '033',
          i_Message => t('033:message:to delete staff first unpost staff $1 hiring', i_Staff_Name),
          i_Title   => t('033:title:cannot delete staff'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_034
  (
    i_Journal_Type   varchar2,
    i_Expected_Types Array_Varchar2
  ) is
  begin
    Error(i_Code    => '034',
          i_Message => t('034:message:expected journal types $1{journal types} but got $2{wrong_journal_type}',
                         Fazo.Gather(i_Expected_Types, ', '),
                         i_Journal_Type),
          i_Title   => t('034:title:wrong journal type'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_035(i_Journal_Number varchar2) is
  begin
    Error(i_Code    => '035',
          i_Message => t('035:message:cannot change/save journal. journal $1{journal_number} already posted',
                         i_Journal_Number),
          i_S1      => t('035:solution:post journal with changes'),
          i_S2      => t('035:solution:unpost journal then save changes'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_036
  (
    i_Journal_Type   varchar2,
    i_Expected_Types Array_Varchar2
  ) is
  begin
    Error(i_Code    => '036',
          i_Message => t('036:message:journal type was $1{wrong_journal_type} but got expected journal types $2{journal types}',
                         i_Journal_Type,
                         Fazo.Gather(i_Expected_Types, ', ')),
          i_Title   => t('036:title:journal type cannot change'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_037
  (
    i_Staff_Name     varchar2,
    i_Journal_Number varchar2
  ) is
  begin
    Error(i_Code    => '037',
          i_Message => t('037:message:cannot delete hiring for staff $1{staff_name} found journal $2{journal_number} linked to staff',
                         i_Staff_Name,
                         i_Journal_Number),
          i_Title   => t('037:title:staff linked other journals'),
          i_S1      => t('037:solution:remove staff from journal $1{journal_number} and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_038(i_Journal_Number varchar2) is
  begin
    Error(i_Code    => '038',
          i_Message => t('038:message:cannot delete journal. journal $1{journal_number} already posted',
                         i_Journal_Number),
          i_S1      => t('038:solution:unpost journal and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_039(i_Contract_Id number) is
  begin
    Error(i_Code    => '039',
          i_Message => t('039:message:contract $1{contract_id} has no items, when access to add item is No contract must have at least one item',
                         i_Contract_Id),
          i_Title   => t('039:title:no contract items'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_040(i_Contract_Id number) is
  begin
    Error(i_Code    => '040',
          i_Message => t('040:message:cannot change/save cv contract. cv contract $1{contract_id} already posted',
                         i_Contract_Id),
          i_S1      => t('040:solution:post contract with changes'),
          i_S2      => t('040:solution:unpost contract then save changes'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_041(i_Contract_Id number) is
  begin
    Error(i_Code    => '041',
          i_Message => t('041:message:cannot delete cv contract. cv contract $1{contract_id} must be unposted',
                         i_Contract_Id),
          i_S1      => t('041:solution:unpost contract and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_042
  (
    i_Overtime_Id number,
    i_Journal_Id  number
  ) is
  begin
    Error(i_Code    => '042',
          i_Message => t('042:message:cannot save overtime. overtimes journal cannot be changed, trying to change overtime $1{overtime_id} in journal $2{journal_id}',
                         i_Overtime_Id,
                         i_Journal_Id));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_043 is
  begin
    Error(i_Code => '043', i_Message => t('043:message:journal type not registered'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_044
  (
    i_Staff_Name      varchar2,
    i_Oper_Group_Name varchar2
  ) is
  begin
    Error(i_Code    => '044',
          i_Message => t('044:message:staff $1{staff_name} has several oper types attached for $2{oper_group_name}',
                         i_Staff_Name,
                         i_Oper_Group_Name),
          i_S1      => t('044:solution:remove all but one oper types and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_045 is
  begin
    Error(i_Code    => '045',
          i_Message => t('045:message:singular type journal cannot contain more than 1 page'),
          i_S1      => t('045:solution:change journal type to multiple'),
          i_S2      => t('045:solution:send each page in separate journal'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_046(i_Journal_Type_Name varchar2) is
  begin
    Error(i_Code    => '046',
          i_Message => t('046:message:cannot change existing journal type'),
          i_S1      => t('046:solution:restore old journal type $1{journal_type_name}',
                         i_Journal_Type_Name));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_047 is
  begin
    Error(i_Code    => '047',
          i_Message => t('047:message:cannot change page in singular journal type'),
          i_S1      => t('047:solution:change journal type to multiple'),
          i_S2      => t('047:solution:send each employee in separate journal'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_048 is
  begin
    Error(i_Code    => '048',
          i_Message => t('048:message:too many pages. given journal has several journals, route ($1{request_route_uri}) allows only one page per journal',
                         b_Session.Request_Route_Uri));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_049(i_Staff_Name varchar2) is
  begin
    Error(i_Code    => '049',
          i_Message => t('049:message:schedule for $1{staff_name} is not selected in schedule change journal',
                         i_Staff_Name),
          i_S1      => t('049:solution:select schedule for $1{staff_name}', i_Staff_Name));
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Raise_050
  (
    i_Date  date,
    i_Month date
  ) is
  begin
    Error(i_Code    => '050',
          i_Message => t('050:message:given overtime date $1 doesnt belong to the given month $2',
                         i_Date,
                         i_Month));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_051 is
  begin
    Error(i_Code    => '051',
          i_Message => t('051:message:too many overtime journals assigned to one journal'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_052(i_Time_Kind_Name varchar2) is
  begin
    Error(i_Code    => '052',
          i_Message => t('052:message:chosen time kind $1{time_kind_name} is not a vacation time kind',
                         i_Time_Kind_Name),
          i_Title   => t('052:title:wrong time kind'),
          i_S1      => t('052:solution:choose vacation time kind or one of its descendants'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_053
  (
    i_Staff_Name      varchar2,
    i_Adjustment_Date date,
    i_Journal_Number  varchar2,
    i_Journal_Date    date
  ) is
  begin
    Error(i_Code    => '053',
          i_Message => t('053:message:timebook adjustment for $1{staff_name} on $2{adjustment_date} has already been calced in $3{journal_number} from $4{journal_date}',
                         i_Staff_Name,
                         i_Adjustment_Date,
                         i_Journal_Number,
                         i_Journal_Date),
          i_Title   => t('053:title:timebook adjustment has already been calced'),
          i_S1      => t('053:solution:remove adjustment  for $1{staff_name} on $2{adjustment_date} from journal and try again',
                         i_Staff_Name,
                         i_Adjustment_Date),
          i_S2      => t('053:solution:unpost journal $1{journal_number} from $2{journal_date} and try again',
                         i_Journal_Number,
                         i_Journal_Date));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_054
  (
    i_Staff_Name      varchar2,
    i_Adjustment_Date date
  ) is
  begin
    Error(i_Code    => '054',
          i_Message => t('054:message:timesheet for $1{staff_name} on $2{adjustment_date} is not found',
                         i_Staff_Name,
                         i_Adjustment_Date),
          i_Title   => t('054:title:timesheet is not found'),
          i_S1      => t('054:solution:set daily schedule for $1{staff_name} on $2{adjustment_date} and try again',
                         i_Staff_Name,
                         i_Adjustment_Date));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_055
  (
    i_Application_Number varchar2,
    i_Status             varchar2
  ) is
  begin
    Error(i_Code    => '055',
          i_Message => t('055:message:application $1{application_number} cannot be deleted in status $2{status_name}',
                         i_Application_Number,
                         Hpd_Util.t_Application_Status(i_Status)),
          i_S1      => t('055:solution:change status to new and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_056
  (
    i_Application_Number varchar2,
    i_Status             varchar2
  ) is
  begin
    Error(i_Code    => '056',
          i_Message => t('056:message:application $1{application_number} cannot be edited in status $2{status_name}',
                         i_Application_Number,
                         Hpd_Util.t_Application_Status(i_Status)),
          i_S1      => t('056:solution:change status to new and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_057 is
  begin
    Error(i_Code => '057', i_Message => t('057:message:application type not registered'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_058
  (
    i_Application_Number varchar2,
    i_Status             varchar2
  ) is
  begin
    Error(i_Code    => '058',
          i_Message => t('058:message:status new{status_name} can only be assigned from status waiting{status_name}, application_number=$1, status_name=$2',
                         i_Application_Number,
                         Hpd_Util.t_Application_Status(i_Status)),
          i_Title   => t('058:title:invalid status transition'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_059
  (
    i_Application_Number varchar2,
    i_Status             varchar2
  ) is
  begin
    Error(i_Code    => '059',
          i_Message => t('059:message:status waiting{status_name} can only be assigned from statuses (new, approved, canceled){status_names}, application_number=$1, status_name=$2',
                         i_Application_Number,
                         Hpd_Util.t_Application_Status(i_Status)),
          i_Title   => t('059:title:invalid status transition'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_060
  (
    i_Application_Number varchar2,
    i_Status             varchar2
  ) is
  begin
    Error(i_Code    => '060',
          i_Message => t('060:message:status approved{status_name} can only be assigned from statuses (waiting, in progress){status_names}, application_number=$1, status_name=$2',
                         i_Application_Number,
                         Hpd_Util.t_Application_Status(i_Status)),
          i_Title   => t('060:title:invalid status transition'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_061
  (
    i_Application_Number varchar2,
    i_Status             varchar2
  ) is
  begin
    Error(i_Code    => '061',
          i_Message => t('061:message:status in progress{status_name} can only be assigned from statuses (approved, complete){status_names}, application_number=$1, status_name=$2',
                         i_Application_Number,
                         Hpd_Util.t_Application_Status(i_Status)),
          i_Title   => t('061:title:invalid status transition'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_062
  (
    i_Application_Number varchar2,
    i_Status             varchar2
  ) is
  begin
    Error(i_Code    => '062',
          i_Message => t('062:message:status complete{status_name} can only be assigned from status in progress{status_name}, application_number=$1, status_name=$2',
                         i_Application_Number,
                         Hpd_Util.t_Application_Status(i_Status)),
          i_Title   => t('062:title:invalid status transition'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_063
  (
    i_Application_Number varchar2,
    i_Status             varchar2
  ) is
  begin
    Error(i_Code    => '063',
          i_Message => t('063:message:status canceled{status_name} can only be assigned from status waiting{status_name}, application_number=$1, status_name=$2',
                         i_Application_Number,
                         Hpd_Util.t_Application_Status(i_Status)),
          i_Title   => t('063:title:invalid status transition'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_064
  (
    i_Application_Number varchar2,
    i_Status             varchar2
  ) is
  begin
    Error(i_Code    => '064',
          i_Message => t('064:message:application $1{application_number} result can be binded only when status is in progress{status_name}, status_name=$2',
                         i_Application_Number,
                         Hpd_Util.t_Application_Status(i_Status)));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_065(i_Application_Number varchar2) is
  begin
    Error(i_Code    => '065',
          i_Message => t('065:message:application $1{application_number} result not found',
                         i_Application_Number),
          i_S1      => t('065:solution:you might need to add a posted journal based on this application'),
          i_S2      => t('065:solution:you might need to add a robot based on this application'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_066
  (
    i_Application_Number        varchar2,
    i_Journal_Number            varchar2,
    i_Journal_Employee_Name     varchar2,
    i_Application_Employee_Name varchar2
  ) is
  begin
    Error(i_Code    => '066',
          i_Message => t('066:message:application $1{application_number} based journal $2{journal_number} employee $3{employee_name} does not match with employee $4{employee_name} in application',
                         i_Application_Number,
                         i_Journal_Number,
                         i_Journal_Employee_Name,
                         i_Application_Employee_Name));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_067
  (
    i_Application_Number varchar2,
    i_Journal_Number     varchar2
  ) is
  begin
    Error(i_Code    => '067',
          i_Message => t('067:message:application $1{application_number} based journal $2{journal_number} already exists',
                         i_Application_Number,
                         i_Journal_Number),
          i_S1      => t('067:solution:you can delete journal $1{journal_number} and try to add new',
                         i_Journal_Number),
          i_S2      => t('067:solution:you can edit existing journal $1{journal_number}',
                         i_Journal_Number));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_068
  (
    i_Jounal_Id         number,
    i_Journal_Number    varchar2,
    i_Journal_Type_Name varchar2,
    i_Source_Table      varchar2,
    i_Source_Id         number
  ) is
    v_Source_Name varchar2(500 char);
    v_Source_Id   number;
  begin
    Journal_Source_Info(i_Jounal_Id         => i_Jounal_Id,
                        i_Journal_Type_Name => i_Journal_Type_Name,
                        i_Source_Table      => i_Source_Table,
                        i_Source_Id         => i_Source_Id,
                        o_Source_Name       => v_Source_Name,
                        o_Source_Id         => v_Source_Id);
  
    Error(i_Code    => '068',
          i_Message => t('068:message:cannot change/save journal. the source of the journal $1{journal_number} cannot be changed',
                         i_Journal_Number),
          i_Title   => t('063:title:the source is changed'),
          i_S1      => t('068:solution:do this action in $1{source_name} form and source_id is $2{source_id}'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_069
  (
    i_Jounal_Id         number,
    i_Journal_Number    varchar2,
    i_Journal_Type_Name varchar2,
    i_Source_Table      varchar2,
    i_Source_Id         number
  ) is
    v_Source_Name varchar2(500 char);
    v_Source_Id   number;
  begin
    Journal_Source_Info(i_Jounal_Id         => i_Jounal_Id,
                        i_Journal_Type_Name => i_Journal_Type_Name,
                        i_Source_Table      => i_Source_Table,
                        i_Source_Id         => i_Source_Id,
                        o_Source_Name       => v_Source_Name,
                        o_Source_Id         => v_Source_Id);
  
    Error(i_Code    => '069',
          i_Message => t('069:message:cannot post journal. the source of the journal $1{journal_number} and the source of this action are not equal',
                         i_Journal_Number),
          i_Title   => t('069:title:the source is changed'),
          i_S1      => t('069:solution:do this action in $1{source_name} form and source_id is $2{source_id}',
                         v_Source_Name,
                         v_Source_Id),
          i_S2      => t('069:solution:remove this jounal from the list and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_070
  (
    i_Jounal_Id         number,
    i_Journal_Number    varchar2,
    i_Journal_Type_Name varchar2,
    i_Source_Table      varchar2,
    i_Source_Id         number
  ) is
    v_Source_Name varchar2(500 char);
    v_Source_Id   number;
  begin
    Journal_Source_Info(i_Jounal_Id         => i_Jounal_Id,
                        i_Journal_Type_Name => i_Journal_Type_Name,
                        i_Source_Table      => i_Source_Table,
                        i_Source_Id         => i_Source_Id,
                        o_Source_Name       => v_Source_Name,
                        o_Source_Id         => v_Source_Id);
  
    Error(i_Code    => '070',
          i_Message => t('070:message:cannot unpost/delete journal. the source of the journal $1{journal_number} and the source of this action are not equal',
                         i_Journal_Number),
          i_Title   => t('070:title:the source is changed'),
          i_S1      => t('070:solution:do this action in $1{source_name} form and source_id is $2{source_id}',
                         v_Source_Name,
                         v_Source_Id),
          i_S2      => t('070:solution:remove this jounal from the list and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_071
  (
    i_Wrong_Application_Type    varchar2,
    i_Expected_Application_Type varchar2
  ) is
  begin
    Error(i_Code    => '071',
          i_Message => t('071:message:when saving application expected $1{expected_application_type_name} application type, but got $2{wrong_application_type_name} application type',
                         i_Wrong_Application_Type,
                         i_Expected_Application_Type),
          i_Title   => t('071:title:application type cannot be changed'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_072 is
  begin
    Error(i_Code    => '072',
          i_Message => t('072:message:you must select currency when it is enabled'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_073(i_Staff_Id number) is
  begin
    Error(i_Code    => '073',
          i_Message => t('073:message:hiring journal not found, staff_id: $1{staff_id}', i_Staff_Id));
  end;

  ----------------------------------------------------------------------------------------------------    
  Procedure Raise_074
  (
    i_Journal_Id     number,
    i_Journal_Number varchar2,
    i_Staff_Name     varchar2
  ) is
  begin
    Error(i_Code    => '074',
          i_Title   => t('074:title:continuous transaction'),
          i_Message => t('074:message:staff $1{staff_name} must have at least one continuous transaction',
                         i_Staff_Name),
          i_S1      => t('074:solution:in journal $1{journal_number} (ID: $2{journal_id}) remove end date',
                         i_Journal_Number,
                         i_Journal_Id));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_075
  (
    i_Interval_Kind varchar2,
    i_Staff_Name    varchar2,
    i_Timeoff_Date  date
  ) is
    v_t_Interval_Kind varchar2(50) := t_Interval_Kind(i_Interval_Kind);
  begin
    Error(i_Code    => '075',
          i_Message => t('075:message:$1{interval_kind} blocks timesheet adjustments for staff $2{staff_name} on $3{timeoff_date}',
                         v_t_Interval_Kind,
                         i_Staff_Name,
                         i_Timeoff_Date),
          i_Title   => t('075:title:timeoff found'),
          i_S1      => t('075:solution:unpost $1{interval_kind} on $2{timeoff_date}',
                         v_t_Interval_Kind,
                         i_Timeoff_Date));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_076
  (
    i_Interval_Kind   varchar2,
    i_Staff_Name      varchar2,
    i_Adjustment_Date date
  ) is
    v_t_Interval_Kind varchar2(50) := t_Interval_Kind(i_Interval_Kind);
  begin
    Error(i_Code    => '076',
          i_Message => t('076:message:timesheet adjustment blocks $1{interval_kind} for staff $2{staff_name} on $3{adjustment_date}',
                         v_t_Interval_Kind,
                         i_Staff_Name,
                         i_Adjustment_Date),
          i_Title   => t('076:title:timesheet adjustment found'),
          i_S1      => t('076:solution:unpost timesheet adjustment on $1{adjustment_date}',
                         i_Adjustment_Date));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_077 is
  begin
    Error(i_Code => '077', i_Message => t('077:message:you must select at least one region'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_078(i_Employee_Name varchar2) is
  begin
    Error(i_Code    => '078',
          i_Message => t('078:message:fte of $1{employee_name} has exceeded the fte limit',
                         i_Employee_Name));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_079(i_Application_Number varchar2) is
  begin
    Error(i_Code    => '079',
          i_Message => t('079:message:application $1{application_number} must have at least one transferred staff',
                         i_Application_Number),
          i_Title   => t('079:title:no transfers found'),
          i_S1      => t('079:solution:try to add at least one staff transfer into application $1{application_number} and try again',
                         i_Application_Number));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_080(i_Application_Type_Name varchar2) is
  begin
    Error(i_Code    => '080',
          i_Message => t('080:message:application must have at least one staff transfer, application_type=$1',
                         i_Application_Type_Name),
          i_Title   => t('080:title:no transfers found'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_081 is
  begin
    Error(i_Code => '081', i_Message => t('081:message:contractor journal must have an end date'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_082(i_Staff_Name varchar2) is
  begin
    Error(i_Code    => '082',
          i_Message => t('082:message:cannot change employment type to contractor'),
          i_S1      => t('082:solution:remove staff $1 from journal', i_Staff_Name));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_083(i_Staff_Name varchar2) is
  begin
    Error(i_Code    => '083',
          i_Message => t('083:message:cannot have contractor employees in transfer journal'),
          i_S1      => t('083:solution:remove staff $1 from journal', i_Staff_Name));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_084
  (
    i_Document_Status varchar2,
    i_Journal_Number  varchar2
  ) is
  begin
    Error(i_Code    => '084',
          i_Message => t('084:message:for post this journal, sign document status must be approved, sign document status: $1{document_status}, journal number: $2{journal_number}',
                         i_Document_Status,
                         i_Journal_Number),
          i_Title   => t('084:title:cannot post this journal'),
          i_S1      => t('084:solution:change sign document status to approved and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_085
  (
    i_Document_Status varchar2,
    i_Journal_Number  varchar2
  ) is
  begin
    Error(i_Code    => '085',
          i_Message => t('085:message:for delete this journal, sign document status must be draft, sign document status: $1{document_status}, journal number: $2{journal_number}',
                         i_Document_Status,
                         i_Journal_Number),
          i_Title   => t('085:title:cannot delete this journal'),
          i_S1      => t('085:solution:change sign document status to draft and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_086
  (
    i_Document_Status varchar2,
    i_Journal_Number  varchar2
  ) is
  begin
    Error(i_Code    => '086',
          i_Message => t('086:message:for edit this journal, sign document status must be draft, sign document status: $1{document_status}, journal number: $2{journal_number}',
                         i_Document_Status,
                         i_Journal_Number),
          i_Title   => t('086:title:cannot edit this journal'),
          i_S1      => t('086:solution:change sign document status to draft and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_087
  (
    i_Document_Status varchar2,
    i_Journal_Number  varchar2
  ) is
  begin
    Error(i_Code    => '087',
          i_Message => t('087:message:for unpost this journal, sign document status must be approved, sign document status: $1{document_status}, journal number: $2{journal_number}',
                         i_Document_Status,
                         i_Journal_Number),
          i_Title   => t('087:title:cannot unpost this journal'),
          i_S1      => t('087:solution:change sign document status to approved and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_088(i_Journal_Type_Name varchar2) is
  begin
    Error(i_Code    => '088',
          i_Message => t('088:message:for save sign document you must create sign template for this journal type, journal type name: $1{journal_type_name}',
                         i_Journal_Type_Name),
          i_Title   => t('088:title:cannot save sign document'),
          i_S1      => t('088:solution:create sign template for this journal and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_089(i_Journal_Number varchar2) is
  begin
    Error(i_Code    => '089',
          i_Message => t('089:message:for save sign document journal must be unposted, journal number: $1{journal_number}',
                         i_Journal_Number),
          i_Title   => t('089:title:cannot save sign document'),
          i_S1      => t('089:solution:unpost journal and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_090
  (
    i_Document_Status varchar2,
    i_Journal_Number  varchar2
  ) is
  begin
    Error(i_Code    => '090',
          i_Message => t('090:message:for edit journal sign document status must be draft and journal must be unposted, sign document status: $1{status}, journal number: $2{journal_number}',
                         i_Document_Status,
                         i_Journal_Number),
          i_Title   => t('090:title:you cannot edit journal'),
          i_S1      => t('090:solution:unpost journal and change sign document status to draft and try again'));
  end;

end Hpd_Error;
/
