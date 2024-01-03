create or replace package Hpr_Error is
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_001
  (
    i_Fact_Id     number,
    i_Status_Name varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_002
  (
    i_Fact_Id      number,
    i_Item_Fact_Id number,
    i_Item_Id      number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_003(i_Contract_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_004(i_Contract_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_005
  (
    i_Fact_Id     number,
    i_Month       date,
    i_Status_Name varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_006
  (
    i_Penalty_Kind varchar2,
    i_First_Rule   varchar2,
    i_Second_Rule  varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_007
  (
    i_Time_Rule    varchar2,
    i_Penalty_Kind varchar2,
    i_First_Rule   varchar2,
    i_Second_Rule  varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_008(i_Penalty_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_009(i_Penalty_Id number);
  ----------------------------------------------------------------------------------------------------              
  Procedure Raise_010
  (
    i_Timebook_Number varchar2,
    i_Staff_Name      varchar2,
    i_Period_Begin    date,
    i_Period_End      date
  );
  ----------------------------------------------------------------------------------------------------              
  Procedure Raise_011(i_Timebook_Number varchar2);
  ----------------------------------------------------------------------------------------------------           
  Procedure Raise_012
  (
    i_Sheet_Number varchar2,
    i_Staff_Name   varchar2,
    i_Period_Begin date,
    i_Period_End   date
  );
  ----------------------------------------------------------------------------------------------------           
  Procedure Raise_013
  (
    i_Charge_Id    number,
    i_Status_Names varchar2
  );
  ----------------------------------------------------------------------------------------------------           
  Procedure Raise_014(i_Charge_Id number);
  ----------------------------------------------------------------------------------------------------           
  Procedure Raise_015(i_Charge_Id number);
  ----------------------------------------------------------------------------------------------------           
  Procedure Raise_016(i_Charge_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_017
  (
    i_Oper_Type_Id   number,
    i_Oper_Type_Name number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_018
  (
    i_Staff_Name  varchar2,
    i_Turnout_Cnt number,
    i_Days_Limit  number,
    i_Booked_Date date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_019
  (
    i_Employee_Name varchar2,
    i_Days_Limit    number,
    i_Booked_Date   date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_020
  (
    i_Fact_Id     number,
    i_Status_Name varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_021
  (
    i_Fact_Id     number,
    i_Status_Name varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_022
  (
    i_Fact_Id     number,
    i_Status_Name varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_023
  (
    i_Fact_Id     number,
    i_Status_Name varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_024(i_Timebook_Number varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_025(i_Timebook_Number varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_026(i_Timebook_Number varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_027(i_Sheet_Number varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_028(i_Sheet_Number varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_029(i_Sheet_Number varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_030(i_Sheet_Number varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_031
  (
    i_Oper_Type_Id   number,
    i_Oper_Type_Name varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_032(i_Value number);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_033
  (
    i_Staff_Name    varchar2,
    i_Division_Name varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_034(i_Errors varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_035(i_Current_Payment_Kind varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_036;
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_037;
  ----------------------------------------------------------------------------------------------------              
  Procedure Raise_038(i_Payment_Number varchar2);
  ----------------------------------------------------------------------------------------------------              
  Procedure Raise_039
  (
    i_Payment_Number  varchar2,
    i_Staff_Name      varchar2,
    i_Bonus_Type_Name varchar2,
    i_Period_Begin    date,
    i_Period_End      date
  );
  ----------------------------------------------------------------------------------------------------              
  Procedure Raise_040
  (
    i_Payment_Number  varchar2,
    i_Staff_Name      varchar2,
    i_Bonus_Type_Name varchar2,
    i_Period_Begin    date,
    i_Period_End      date
  );
  ----------------------------------------------------------------------------------------------------              
  Procedure Raise_041(i_Payment_Number varchar2);
  ----------------------------------------------------------------------------------------------------              
  Procedure Raise_042(i_Payment_Number varchar2);
  ----------------------------------------------------------------------------------------------------              
  Procedure Raise_043(i_Payment_Number varchar2);
  ----------------------------------------------------------------------------------------------------              
  Procedure Raise_044
  (
    i_Payment_Number varchar2,
    i_Staff_Name     varchar2,
    i_Job_Name       varchar2,
    i_Period_Begin   date,
    i_Period_End     date
  );
  ----------------------------------------------------------------------------------------------------              
  Procedure Raise_045(i_Job_Name varchar2);
  ----------------------------------------------------------------------------------------------------              
  Procedure Raise_046;
  ----------------------------------------------------------------------------------------------------              
  Procedure Raise_047(i_Document_Number varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_048(i_Document_Number varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_049
  (
    i_Charge_Id       number := null,
    i_Staff_Name      varchar2,
    i_Status          varchar2,
    i_Document_Number varchar2,
    i_Document_Date   date,
    i_Book_Number     varchar2 := null,
    i_Book_Date       date := null
  );
  ----------------------------------------------------------------------------------------------------              
  Procedure Raise_050(i_Document_Number varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_051(i_Oper_Type_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_052(i_Policy_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_053(i_Policy_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_054
  (
    i_First_Row  number,
    i_Second_Row number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_055(i_Rule_Order number);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_056(i_Name number);
  ---------------------------------------------------------------------------------------------------- 
  Procedure Raise_057(i_Status varchar2);
  ---------------------------------------------------------------------------------------------------- 
  Procedure Raise_058;
  ---------------------------------------------------------------------------------------------------- 
  Procedure Raise_059;
  ---------------------------------------------------------------------------------------------------- 
  Procedure Raise_060;
  ---------------------------------------------------------------------------------------------------- 
  Procedure Raise_061(i_Status varchar2);
  ---------------------------------------------------------------------------------------------------- 
  Procedure Raise_062(i_Status varchar2);
end Hpr_Error;
/
create or replace package body Hpr_Error is
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
    return b.Translate('HPR:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
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
    b.Raise_Extended(i_Code    => Verifix.Hpr_Error_Code || i_Code,
                     i_Message => i_Message,
                     i_Title   => i_Title,
                     i_S1      => i_S1,
                     i_S2      => i_S2,
                     i_S3      => i_S3,
                     i_S4      => i_S4,
                     i_S5      => i_S5);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_001
  (
    i_Fact_Id     number,
    i_Status_Name varchar2
  ) is
  begin
    Error(i_Code    => '001',
          i_Message => t('001:message:status must be new, fact id: $1, current status: $2',
                         i_Fact_Id,
                         i_Status_Name),
          i_Title   => t('001:title:cannot save civil contract fact'),
          i_S1      => t('001:solution:change fact status to new and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_002
  (
    i_Fact_Id      number,
    i_Item_Fact_Id number,
    i_Item_Id      number
  ) is
  begin
    Error(i_Code    => '002',
          i_Message => t('002:message:item not belongs to fact, fact_id: $1, item_fact_id: $2, item_id: $3',
                         i_Fact_Id,
                         i_Item_Fact_Id,
                         i_Item_Id),
          i_Title   => t('002:title:cannot save civil contract fact'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_003(i_Contract_Id number) is
  begin
    Error(i_Code    => '003',
          i_Message => t('003:message:no access to add item'),
          i_Title   => t('003:title:cannot update civil contract fact'),
          i_S1      => t('003:solution:change access add item of contract $1{contract_id} to yes and try again',
                         i_Contract_Id));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_004(i_Contract_Id number) is
  begin
    Error(i_Code    => '004',
          i_Message => t('004:message:no access to add item'),
          i_Title   => t('004:title:cannot add civil contract fact'),
          i_S1      => t('004:solution:change access add item of contract $1{contract_id} to yes and try again',
                         i_Contract_Id));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_005
  (
    i_Fact_Id     number,
    i_Month       date,
    i_Status_Name varchar2
  ) is
  begin
    Error(i_Code    => '005',
          i_Message => t('005:message:to delete fact, status must be new, current status: $1, month: $2',
                         i_Status_Name,
                         to_char(i_Month, 'month yyyy')),
          i_Title   => t('005:title:cannot delete civil contract fact'),
          i_S1      => t('005:solution:change fact $1{fact_id} status to new and try again',
                         i_Fact_Id));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_006
  (
    i_Penalty_Kind varchar2,
    i_First_Rule   varchar2,
    i_Second_Rule  varchar2
  ) is
  begin
    Error(i_Code    => '006',
          i_Message => t('006:message:plan penalty time intersected, penalty_kind: $1, first_rule: $2, second_rule: $3',
                         i_Penalty_Kind,
                         i_First_Rule,
                         i_Second_Rule),
          i_Title   => t('006:title:penalty time intersection $1{penalty_kind}', i_Penalty_Kind),
          i_S1      => t('006:solution:remove intersection in rule times and try again'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_007
  (
    i_Time_Rule    varchar2,
    i_Penalty_Kind varchar2,
    i_First_Rule   varchar2,
    i_Second_Rule  varchar2
  ) is
  begin
    Error(i_Code    => '007',
          i_Message => t('007:message:plan penalty day intersection, penalty_kind: $1, first_rule: $2, second_rule: $3, time_rule: $4',
                         i_Penalty_Kind,
                         i_First_Rule,
                         i_Second_Rule,
                         i_Time_Rule),
          i_Title   => t('007:title:penalty day intersection $1{penalty_kind}', i_Penalty_Kind),
          i_S1      => t('007:solution:remove intersection in rule days and try again, time_rule:$1',
                         i_Time_Rule));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_008(i_Penalty_Id number) is
  begin
    Error(i_Code    => '008',
          i_Message => t('008:message:penalty month cannot be changed, penalty_id: $1', i_Penalty_Id));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_009(i_Penalty_Id number) is
  begin
    Error(i_Code    => '009',
          i_Message => t('009:message:penalty division cannot be changed, penalty_id: $1',
                         i_Penalty_Id));
  end;

  ----------------------------------------------------------------------------------------------------              
  Procedure Raise_010
  (
    i_Timebook_Number varchar2,
    i_Staff_Name      varchar2,
    i_Period_Begin    date,
    i_Period_End      date
  ) is
  begin
    Error(i_Code    => '010',
          i_Message => t('010:message:$1{staff_name} is blocked between $2{period_begin} and $3{period_end}',
                         i_Staff_Name,
                         i_Period_Begin,
                         i_Period_End),
          i_Title   => t('010:title:locked period found'),
          i_S1      => t('010:solution:unpost timebook $1{timebook_number} and try again',
                         i_Timebook_Number));
  end;

  ----------------------------------------------------------------------------------------------------              
  Procedure Raise_011(i_Timebook_Number varchar2) is
  begin
    Error(i_Code    => '011',
          i_Message => t('011:message:timebook is already posted, timebook_number: $1',
                         i_Timebook_Number));
  end;

  ----------------------------------------------------------------------------------------------------           
  Procedure Raise_012
  (
    i_Sheet_Number varchar2,
    i_Staff_Name   varchar2,
    i_Period_Begin date,
    i_Period_End   date
  ) is
  begin
    Error(i_Code    => '012',
          i_Message => t('012:message:another sheet is already posted for $1{staff_name}, period begin: $2, period end: $3',
                         i_Staff_Name,
                         i_Period_Begin,
                         i_Period_End),
          i_Title   => t('012:title:locked period found'),
          i_S1      => t('012:solution:unpost wage sheet $1{sheet_number} and try again',
                         i_Sheet_Number));
  end;

  ----------------------------------------------------------------------------------------------------           
  Procedure Raise_013
  (
    i_Charge_Id    number,
    i_Status_Names varchar2
  ) is
  begin
    Error(i_Code    => '013',
          i_Message => t('013:message:to use charge, status must be in $1{status_names}, charge_id: $2',
                         i_Status_Names,
                         i_Charge_Id),
          i_S1      => t('013:solution:change status one of $1{status_names} and try again',
                         i_Status_Names));
  end;

  ----------------------------------------------------------------------------------------------------           
  Procedure Raise_014(i_Charge_Id number) is
  begin
    Error(i_Code    => '014',
          i_Message => t('014:message:to cancel charge, status must be used, charge_id: $1',
                         i_Charge_Id));
  end;

  ----------------------------------------------------------------------------------------------------           
  Procedure Raise_015(i_Charge_Id number) is
  begin
    Error(i_Code    => '015',
          i_Message => t('015:message:to complete charge, status must be used, charge_id: $1',
                         i_Charge_Id));
  end;

  ----------------------------------------------------------------------------------------------------           
  Procedure Raise_016(i_Charge_Id number) is
  begin
    Error(i_Code    => '016',
          i_Message => t('016:message:to cancel complete charge, status must be complete, charge_id: $1',
                         i_Charge_Id));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_017
  (
    i_Oper_Type_Id   number,
    i_Oper_Type_Name number
  ) is
  begin
    Error(i_Code    => '017',
          i_Message => t('017:message:cannot change oper group of system oper type, oper_type_id: $1, oper_type_name: $2',
                         i_Oper_Type_Id,
                         i_Oper_Type_Name));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_018
  (
    i_Staff_Name  varchar2,
    i_Turnout_Cnt number,
    i_Days_Limit  number,
    i_Booked_Date date
  ) is
  begin
    Error(i_Code    => '018',
          i_Message => t('018:message:advance available only to employees worked $1{days_limit} days before $2{booked_date}. staff $3{staff_name} worked only $4{turnout_cnt} days',
                         i_Days_Limit,
                         i_Booked_Date,
                         i_Staff_Name,
                         i_Turnout_Cnt),
          i_Title   => t('018:title:new employee'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_019
  (
    i_Employee_Name varchar2,
    i_Days_Limit    number,
    i_Booked_Date   date
  ) is
  begin
    Error(i_Code    => '019',
          i_Message => t('019:message:advance available only to employees hired $1{days_limit} days before $2{booked_date}. employee $3{employee_name} after this date',
                         i_Days_Limit,
                         i_Booked_Date,
                         i_Employee_Name),
          i_Title   => t('019:title:new employee'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_020
  (
    i_Fact_Id     number,
    i_Status_Name varchar2
  ) is
  begin
    Error(i_Code    => '020',
          i_Message => t('020:message:return fact to new, status must be complete, fact_id: $1, current_status: $2',
                         i_Fact_Id,
                         i_Status_Name));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_021
  (
    i_Fact_Id     number,
    i_Status_Name varchar2
  ) is
  begin
    Error(i_Code    => '021',
          i_Message => t('021:message:to complete fact, status must be new, fact_id: $1, current_status: $2',
                         i_Fact_Id,
                         i_Status_Name));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_022
  (
    i_Fact_Id     number,
    i_Status_Name varchar2
  ) is
  begin
    Error(i_Code    => '022',
          i_Message => t('022:message:to accept fact, status must be complete, fact_id: $1, current_status: $2',
                         i_Fact_Id,
                         i_Status_Name));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_023
  (
    i_Fact_Id     number,
    i_Status_Name varchar2
  ) is
  begin
    Error(i_Code    => '023',
          i_Message => t('023:message:to return in complete, status must be accept, fact_id: $1, current_status: $2',
                         i_Fact_Id,
                         i_Status_Name));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_024(i_Timebook_Number varchar2) is
  begin
    Error(i_Code    => '024',
          i_Message => t('024:message:cannot post timebook. $1{timebook_number} timebook already posted',
                         i_Timebook_Number));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_025(i_Timebook_Number varchar2) is
  begin
    Error(i_Code    => '025',
          i_Message => t('025:message:cannot unpost timebook. $1{timebook_number} timebook already unposted',
                         i_Timebook_Number));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_026(i_Timebook_Number varchar2) is
  begin
    Error(i_Code    => '026',
          i_Message => t('026:message:cannot delete timebook. $1{timebook_number} timebook posted',
                         i_Timebook_Number),
          i_S1      => t('026:solution:before delete timebook, unpost it'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_027(i_Sheet_Number varchar2) is
  begin
    Error(i_Code    => '027',
          i_Message => t('027:message:cannot save wage sheet $1{sheet_number} wage sheet already posted',
                         i_Sheet_Number),
          i_S1      => t('027:solution:before save wage sheet, unpost it'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_028(i_Sheet_Number varchar2) is
  begin
    Error(i_Code    => '028',
          i_Message => t('028:message:cannot delete wage sheet. $1{sheet_number} wage sheet already posted',
                         i_Sheet_Number),
          i_S1      => t('028:solution:before delete wage sheet, unpost it'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_029(i_Sheet_Number varchar2) is
  begin
    Error(i_Code    => '029',
          i_Message => t('029:message:cannot posted wage sheet. $1{sheet_number} wage sheet already posted',
                         i_Sheet_Number));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_030(i_Sheet_Number varchar2) is
  begin
    Error(i_Code    => '030',
          i_Message => t('030:message:cannot unposted wage sheet. $1{sheet_number} wage sheet already unposted',
                         i_Sheet_Number));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_031
  (
    i_Oper_Type_Id   number,
    i_Oper_Type_Name varchar2
  ) is
  begin
    Error(i_Code    => '031',
          i_Message => t('031:message:cannot delete system oper type, oper_type_id: $1, oper_type_name: $2',
                         i_Oper_Type_Id,
                         i_Oper_Type_Name),
          i_Title   => t('031:title:cannot delete system oper type'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_032(i_Value number) is
  begin
    Error(i_Code    => '032',
          i_Message => t('032:message:overtime coefficient mus be positive, current_value: $1',
                         i_Value));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_033
  (
    i_Staff_Name    varchar2,
    i_Division_Name varchar2
  ) is
  begin
    Error(i_Code    => '033',
          i_Message => t('033:message:$1{division_name} of $2{staff_name} is wrong',
                         i_Division_Name,
                         i_Staff_Name));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_034(i_Errors varchar2) is
  begin
    Error(i_Code    => '034',
          i_Message => t('034:message:formula execution erors: $1{errors}', i_Errors),
          i_Title   => t('034:title:oper type formula invalid'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_035(i_Current_Payment_Kind varchar2) is
  begin
    Error(i_Code    => '035',
          i_Message => t('035:message:payment kind must be advance, current_payment_kind: $1',
                         i_Current_Payment_Kind));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_036 is
  begin
    Error(i_Code    => '036',
          i_Message => t('036:message:regular wage sheet cannot contains info about one-time operations'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_037 is
  begin
    Error(i_Code    => '037',
          i_Message => t('037:message:one-time wage sheet cannot contains info about regular operations'));
  end;

  ----------------------------------------------------------------------------------------------------              
  Procedure Raise_038(i_Payment_Number varchar2) is
  begin
    Error(i_Code    => '038',
          i_Message => t('038:message:sales bonus payment is already posted, payment_number: $1',
                         i_Payment_Number),
          i_Title   => t('038:title:cannot save sales bonus payment'),
          i_S1      => t('038:solution:before save sales bonus payment, unpost it'));
  end;

  ----------------------------------------------------------------------------------------------------              
  Procedure Raise_039
  (
    i_Payment_Number  varchar2,
    i_Staff_Name      varchar2,
    i_Bonus_Type_Name varchar2,
    i_Period_Begin    date,
    i_Period_End      date
  ) is
  begin
    Error(i_Code    => '039',
          i_Message => t('039:message:sales bonus $1{bonus type} for $2{staff_name} is paid between $3{period_begin} and $4{period_end}, payment_number=$5',
                         i_Bonus_Type_Name,
                         i_Staff_Name,
                         i_Period_Begin,
                         i_Period_End,
                         i_Payment_Number),
          i_Title   => t('039:title:sales bonus paid period found'),
          i_S1      => t('039:solution:delete this operation and try again'));
  end;

  ----------------------------------------------------------------------------------------------------              
  Procedure Raise_040
  (
    i_Payment_Number  varchar2,
    i_Staff_Name      varchar2,
    i_Bonus_Type_Name varchar2,
    i_Period_Begin    date,
    i_Period_End      date
  ) is
  begin
    Error(i_Code    => '040',
          i_Message => t('040:message:the period of sales bonus $1{bonus type} for $2{staff_name} is not between $3{period_begin} and $4{period_end}, payment_number=$5',
                         i_Bonus_Type_Name,
                         i_Staff_Name,
                         i_Period_Begin,
                         i_Period_End,
                         i_Payment_Number),
          i_Title   => t('040:title:sales bonus period is wrong'),
          i_S1      => t('040:solution:delete this operation and try again'),
          i_S2      => t('040:solution:change the period of payment and try again'));
  end;

  ----------------------------------------------------------------------------------------------------              
  Procedure Raise_041(i_Payment_Number varchar2) is
  begin
    Error(i_Code    => '041',
          i_Message => t('041:message:sales bonus payment is already posted, payment_number: $1',
                         i_Payment_Number),
          i_Title   => t('041:title:cannot post sales bonus payment'),
          i_S1      => t('041:solution:before post sales bonus payment, unpost it'));
  end;

  ----------------------------------------------------------------------------------------------------              
  Procedure Raise_042(i_Payment_Number varchar2) is
  begin
    Error(i_Code    => '042',
          i_Message => t('042:message:sales bonus payment is already unposted, payment_number: $1',
                         i_Payment_Number),
          i_Title   => t('042:title:cannot unpost sales bonus payment'),
          i_S1      => t('042:solution:before unpost sales bonus payment, post it'));
  end;

  ----------------------------------------------------------------------------------------------------              
  Procedure Raise_043(i_Payment_Number varchar2) is
  begin
    Error(i_Code    => '043',
          i_Message => t('043:message:sales bonus payment is already posted, payment_number: $1',
                         i_Payment_Number),
          i_Title   => t('043:title:cannot delete sales bonus payment'),
          i_S1      => t('043:solution:before delete sales bonus payment, unpost it'));
  end;

  ----------------------------------------------------------------------------------------------------              
  Procedure Raise_044
  (
    i_Payment_Number varchar2,
    i_Staff_Name     varchar2,
    i_Job_Name       varchar2,
    i_Period_Begin   date,
    i_Period_End     date
  ) is
  begin
    Error(i_Code    => '044',
          i_Message => t('044:message:$1{staff_name} is not worked to $2{job name} from $3{period_begin} to $4{period_end}, payment_number=$5',
                         i_Staff_Name,
                         i_Job_Name,
                         i_Period_Begin,
                         i_Period_End,
                         i_Payment_Number),
          i_Title   => t('044:title:the job of staff is wrong in payment operation'),
          i_S1      => t('044:solution:delete this operation and try again'),
          i_S2      => t('044:solution:change the job of staff and try again'));
  end;

  ----------------------------------------------------------------------------------------------------              
  Procedure Raise_045(i_Job_Name varchar2) is
  begin
    Error(i_Code    => '045',
          i_Message => t('045:message:no coa attached to $1{job_name}', i_Job_Name),
          i_S1      => t('045:solution:delete this operation and try again'),
          i_S2      => t('045:solution:attach coa to this job and try again'));
  end;

  ----------------------------------------------------------------------------------------------------              
  Procedure Raise_046 is
  begin
    Error(i_Code => '046', i_Message => t('046:message:you do not have access view salaries'));
  end;

  ----------------------------------------------------------------------------------------------------              
  Procedure Raise_047(i_Document_Number varchar2) is
  begin
    Error(i_Code    => '047',
          i_Message => t('047:message:charge document is already posted, document_number: $1{document_number}',
                         i_Document_Number));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_048(i_Document_Number varchar2) is
  begin
    Error(i_Code    => '048',
          i_Message => t('048:message:cannot delete charge document. $1{document_number} charge document posted',
                         i_Document_Number),
          i_S1      => t('048:solution:before delete charge document, unpost it'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_049
  (
    i_Charge_Id       number := null,
    i_Staff_Name      varchar2,
    i_Status          varchar2,
    i_Document_Number varchar2,
    i_Document_Date   date,
    i_Book_Number     varchar2 := null,
    i_Book_Date       date := null
  ) is
    t_Message  varchar2(4000);
    t_Solution varchar2(4000);
  begin
    if i_Status = Hpr_Pref.c_Charge_Status_New then
      t_Message  := t('049:message:you can not draft charge whose is not $1{status_name} in $2{documet_number} from $3{document_date} for $4{staff_name}',
                      Hpr_Util.t_Charge_Status(i_Status),
                      i_Document_Number,
                      i_Document_Date,
                      i_Staff_Name);
      t_Solution := t('049:solution:delete book with $1{book_number} and $2{book_date} and try again',
                      i_Book_Number,
                      i_Book_Date);
    elsif i_Status = Hpr_Pref.c_Charge_Status_Draft then
      t_Message := t('049:message:you cannot change status of charge to new if its status id not $1{satus_name} in $2{documet_number} from $3{document_date}, charge_id: $4{charge_id}',
                     Hpr_Util.t_Charge_Status(i_Status),
                     i_Document_Number,
                     i_Document_Date,
                     i_Charge_Id);
    end if;
  
    Error(i_Code => '049', i_Message => t_Message, i_S1 => t_Solution);
  end;

  ----------------------------------------------------------------------------------------------------              
  Procedure Raise_050(i_Document_Number varchar2) is
  begin
    Error(i_Code    => '050',
          i_Message => t('050:message:charge document is already unposted, document_number: $1{document_number}',
                         i_Document_Number));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_051(i_Oper_Type_Id number) is
  begin
    Error(i_Code    => '051',
          i_Message => t('051:message:estimation kind of oper type must be entered, oper_type_id: $1{oper_typr_id}',
                         i_Oper_Type_Id));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_052(i_Policy_Id number) is
  begin
    Error(i_Code    => '052',
          i_Message => t('052:message:nigttime policy month cannot be changed, policy_id: $1',
                         i_Policy_Id));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_053(i_Policy_Id number) is
  begin
    Error(i_Code    => '053',
          i_Message => t('053:message:nigttime policy division cannot be changed, policy_id: $1',
                         i_Policy_Id));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_054
  (
    i_First_Row  number,
    i_Second_Row number
  ) is
  begin
    Error(i_Code    => '054',
          i_Message => t('054:message:period of $1{first_row_number} rule has intersaction with period of $2{second_row_number} rule',
                         i_First_Row,
                         i_Second_Row));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_055(i_Rule_Order number) is
  begin
    Error(i_Code    => '055',
          i_Message => t('055:message:coefficient must be greater than 1 on $1{rule_order} rule',
                         i_Rule_Order));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_056(i_Name number) is
  begin
    Error(i_Code    => '056',
          i_Message => t('056:message:oper type not found with this name, name: $1{oper_type_name}',
                         i_Name));
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Raise_057(i_Status varchar2) is
  begin
    Error(i_Code    => '057',
          i_Message => t('057:message:for save credit status must be draft, current status: $1{current_status}',
                         i_Status));
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Raise_058 is
  begin
    Error(i_Code    => '058',
          i_Message => t('058:message:status already booked, you can not change status to book again'),
          i_S1      => t('058:solution:select other status, and try again'));
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Raise_059 is
  begin
    Error(i_Code    => '059',
          i_Message => t('059:message:status already draft, you can not change status to draft again'),
          i_S1      => t('059:solution:select other status, and try again'));
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Raise_060 is
  begin
    Error(i_Code    => '060',
          i_Message => t('060:message:status already complete, you can not change status to complete again'),
          i_S1      => t('060:solution:select other status, and try again'));
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Raise_061(i_Status varchar2) is
  begin
    Error(i_Code    => '061',
          i_Message => t('061:message:for archive status must be complete, current status: $1{current status}',
                         i_Status),
          i_S1      => t('061:solution:change status to complete and try again'));
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Raise_062(i_Status varchar2) is
  begin
    Error(i_Code    => '062',
          i_Message => t('062:message:for delete status must be draft, current status: $1{current status}',
                         i_Status),
          i_S1      => t('062:solution:change status to draft and try again'));
  end;

end Hpr_Error;
/
