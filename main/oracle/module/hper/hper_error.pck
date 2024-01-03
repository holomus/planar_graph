create or replace package Hper_Error is
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_001
  (
    i_Plan_Type_Id   number,
    i_Plan_Type_Name varchar2,
    i_Calc_Kind      varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_002(i_Plan_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_003
  (
    i_Plan_Type_Name varchar2,
    i_First_Rule     varchar2,
    i_Second_Rule    varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_004(i_Main_Plan_Count number);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_005
  (
    i_Plan_Id              number,
    i_Current_Total_Weight number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_006
  (
    i_Plan_Id              number,
    i_Current_Total_Weight number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_007
  (
    i_Staff_Name    varchar2,
    i_Staff_Plan_Id number,
    i_Status        varchar2,
    i_Plan_Date     date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_008
  (
    i_Staff_Name    varchar2,
    i_Staff_Plan_Id number,
    i_Status        varchar2,
    i_Plan_Date     date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_009
  (
    i_Staff_Name    varchar2,
    i_Staff_Plan_Id number,
    i_Status        varchar2,
    i_Plan_Date     date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_010
  (
    i_Staff_Name    varchar2,
    i_Staff_Plan_Id number,
    i_Status        varchar2,
    i_Plan_Date     date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_011
  (
    i_Staff_Name    varchar2,
    i_Staff_Plan_Id number,
    i_Status        varchar2,
    i_Plan_Date     date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_012
  (
    i_Staff_Name    varchar2,
    i_Staff_Plan_Id number,
    i_Status        varchar2,
    i_Plan_Date     date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_013
  (
    i_Staff_Name    varchar2,
    i_Staff_Plan_Id number,
    i_Status        varchar2,
    i_Plan_Date     date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_014
  (
    i_Staff_Name    varchar2,
    i_Staff_Plan_Id number,
    i_Status        varchar2,
    i_Plan_Date     date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_015
  (
    i_Staff_Name    varchar2,
    i_Staff_Plan_Id number,
    i_Status        varchar2,
    i_Plan_Date     date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_016
  (
    i_Staff_Plan_Id number,
    i_Plan_Type_Id  number,
    i_Amount        number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_017(i_Month_End number);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_018(i_Plan_Type varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_019
  (
    i_Staff_Name    varchar2,
    i_Staff_Plan_Id number,
    i_Plan_Date     date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_020
  (
    i_Staff_Name    varchar2,
    i_Staff_Plan_Id number,
    i_Plan_Date     date
  );
end Hper_Error;
/
create or replace package body Hper_Error is
  ----------------------------------------------------------------------------------------------------  
  Function t
  (
    i_Message varchar2,
    i_P1      varchar2 := null,
    i_P2      varchar2 := null,
    i_P3      varchar2 := null,
    i_P4      varchar2 := null,
    i_P5      varchar2 := null,
    i_P6      varchar2 := null
  ) return varchar2 is
  begin
    return b.Translate('HPER:' || i_Message, Array_Varchar2(i_P1, i_P2, i_P3, i_P4, i_P5, i_P6));
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
    b.Raise_Extended(i_Code    => Verifix.Hper_Error_Code || i_Code,
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
    i_Plan_Type_Id   number,
    i_Plan_Type_Name varchar2,
    i_Calc_Kind      varchar2
  ) is
  begin
    Error(i_Code    => '001',
          i_Message => t('001:message: calc kind of $1{plan_type_name} is not task, plan_type_id=$2, calc_kind=$3',
                         i_Plan_Type_Name,
                         i_Plan_Type_Id,
                         Hper_Util.t_Calc_Kind(i_Calc_Kind)),
          i_Title   => t('001:title: calc kind of plan type is wrong'),
          i_S1      => t('001:solution: change calc kind of $1{plan_type_name} to task',
                         i_Plan_Type_Name));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_002(i_Plan_Id number) is
  begin
    Error(i_Code    => '002',
          i_Message => t('002:message: job, division and employment type are required for standard plan, plan_id=$1',
                         i_Plan_Id),
          i_S1      => t('002:solution: select job, division and employement type'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_003
  (
    i_Plan_Type_Name varchar2,
    i_First_Rule     varchar2,
    i_Second_Rule    varchar2
  ) is
  begin
    Error(i_Code    => '003',
          i_Message => t('003:message: plan type $1{plan_type_name} has intersection on rule $2{first_rule} and rule $3{second_rule}',
                         i_Plan_Type_Name,
                         i_First_Rule,
                         i_Second_Rule),
          i_Title   => t('003:title: rules intersected'),
          i_S1      => t('003:solution: change $1{first_rule} rule or $2{second_rule} rule',
                         i_First_Rule,
                         i_Second_Rule));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_004(i_Main_Plan_Count number) is
  begin
    Error(i_Code    => '004',
          i_Message => t('004:message: there must be at least one main plan, main_plan_count=$1',
                         i_Main_Plan_Count),
          i_S1      => t('004:solution: add at least one main plan'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_005
  (
    i_Plan_Id              number,
    i_Current_Total_Weight number
  ) is
  
    --------------------------------------------------
    Function Give_Solution return varchar2 is
      v_Excess_Weight number := i_Current_Total_Weight - 100;
    begin
      if v_Excess_Weight > 0 then
        return t('005:solution:reduce weight by $1{excess_weight}', Abs(v_Excess_Weight));
      end if;
    
      return t('005:solution:increase weight by $1{excess_weight}', Abs(v_Excess_Weight));
    end;
  
  begin
    Error(i_Code    => '005',
          i_Message => t('005:message: total weight of main plans must be 100, current total weight is $1, plan_id=$2',
                         i_Current_Total_Weight,
                         i_Plan_Id),
          i_Title   => t('005:title: total weight must be 100'),
          i_S1      => Give_Solution);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_006
  (
    i_Plan_Id              number,
    i_Current_Total_Weight number
  ) is
  
    --------------------------------------------------
    Function Give_Solution return varchar2 is
      v_Excess_Weight number := i_Current_Total_Weight - 100;
    begin
      if v_Excess_Weight > 0 then
        return t('006:solution:reduce weight by $1{excess_weight}', Abs(v_Excess_Weight));
      end if;
    
      return t('006:solution:increase weight by $1{excess_weight}', Abs(v_Excess_Weight));
    end;
  
  begin
    Error(i_Code    => '006',
          i_Message => t('006:message: total weight of extra plans must be 100, current total weight is $1, plan_id=$2',
                         i_Current_Total_Weight,
                         i_Plan_Id),
          i_Title   => t('006:title: total weight must be 100'),
          i_S1      => Give_Solution);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_007
  (
    i_Staff_Name    varchar2,
    i_Staff_Plan_Id number,
    i_Status        varchar2,
    i_Plan_Date     date
  ) is
  begin
    Error(i_Code    => '007',
          i_Message => t('007:message: staff plan must be draft or new, staff_name=$1, staff_plan_id=$2, status=$3, plan_date=$4',
                         i_Staff_Name,
                         i_Staff_Plan_Id,
                         Hper_Util.t_Staff_Plan_Status(i_Status),
                         i_Plan_Date),
          i_Title   => t('007:title: staff plan cannot be updated'),
          i_S1      => t('007:solution: change the status of staff plan to draft or new'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_008
  (
    i_Staff_Name    varchar2,
    i_Staff_Plan_Id number,
    i_Status        varchar2,
    i_Plan_Date     date
  ) is
  begin
    Error(i_Code    => '008',
          i_Message => t('008:message: staff plan must be draft or new, staff_name=$1, staff_plan_id=$2, status=$3, plan_date=$4',
                         i_Staff_Name,
                         i_Staff_Plan_Id,
                         Hper_Util.t_Staff_Plan_Status(i_Status),
                         i_Plan_Date),
          i_Title   => t('008:title: staff plan part cannot be saved'),
          i_S1      => t('008:solution: change the status of staff plan to draft or new'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_009
  (
    i_Staff_Name    varchar2,
    i_Staff_Plan_Id number,
    i_Status        varchar2,
    i_Plan_Date     date
  ) is
  begin
    Error(i_Code    => '009',
          i_Message => t('009:message: staff plan must be draft or new, staff_name=$1, staff_plan_id=$2, status=$3, plan_date=$4',
                         i_Staff_Name,
                         i_Staff_Plan_Id,
                         Hper_Util.t_Staff_Plan_Status(i_Status),
                         i_Plan_Date),
          i_Title   => t('009:title: staff plan part cannot be deleted'),
          i_S1      => t('009:solution: change the status of staff plan to draft or new'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_010
  (
    i_Staff_Name    varchar2,
    i_Staff_Plan_Id number,
    i_Status        varchar2,
    i_Plan_Date     date
  ) is
  begin
    Error(i_Code    => '010',
          i_Message => t('010:message: staff plan must be draft or new, staff_name=$1, staff_plan_id=$2, status=$3, plan_date=$4',
                         i_Staff_Name,
                         i_Staff_Plan_Id,
                         Hper_Util.t_Staff_Plan_Status(i_Status),
                         i_Plan_Date),
          i_Title   => t('010:title: staff plan tasks cannot be updated'),
          i_S1      => t('010:solution: change the status of staff plan to draft or new'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_011
  (
    i_Staff_Name    varchar2,
    i_Staff_Plan_Id number,
    i_Status        varchar2,
    i_Plan_Date     date
  ) is
  begin
    Error(i_Code    => '011',
          i_Message => t('011:message: staff plan can be draft when status is new, staff_name=$1, staff_plan_id=$2, status=$3, plan_date=$4',
                         i_Staff_Name,
                         i_Staff_Plan_Id,
                         Hper_Util.t_Staff_Plan_Status(i_Status),
                         i_Plan_Date),
          i_S1      => t('011:solution: change the status of staff plan to new'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_012
  (
    i_Staff_Name    varchar2,
    i_Staff_Plan_Id number,
    i_Status        varchar2,
    i_Plan_Date     date
  ) is
  begin
    Error(i_Code    => '012',
          i_Message => t('012:message: staff plan can be new when status is draft or waiting, staff_name=$1, staff_plan_id=$2, status=$3, plan_date=$4',
                         i_Staff_Name,
                         i_Staff_Plan_Id,
                         Hper_Util.t_Staff_Plan_Status(i_Status),
                         i_Plan_Date),
          i_S1      => t('012:solution: change the status of staff plan to draft or waiting'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_013
  (
    i_Staff_Name    varchar2,
    i_Staff_Plan_Id number,
    i_Status        varchar2,
    i_Plan_Date     date
  ) is
  begin
    Error(i_Code    => '013',
          i_Message => t('013:message: staff plan can be waiting when status is draft, new or completed, staff_name=$1, staff_plan_id=$2, status=$3, plan_date=$4',
                         i_Staff_Name,
                         i_Staff_Plan_Id,
                         Hper_Util.t_Staff_Plan_Status(i_Status),
                         i_Plan_Date),
          i_S1      => t('013:solution: change the status of staff plan to draft, new or completed'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_014
  (
    i_Staff_Name    varchar2,
    i_Staff_Plan_Id number,
    i_Status        varchar2,
    i_Plan_Date     date
  ) is
  begin
    Error(i_Code    => '014',
          i_Message => t('014:message: staff plan can be completed when status is waiting, staff_name=$1, staff_plan_id=$2, status=$3, plan_date=$4',
                         i_Staff_Name,
                         i_Staff_Plan_Id,
                         Hper_Util.t_Staff_Plan_Status(i_Status),
                         i_Plan_Date),
          i_S1      => t('014:solution: change the status of staff plan to waiting'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_015
  (
    i_Staff_Name    varchar2,
    i_Staff_Plan_Id number,
    i_Status        varchar2,
    i_Plan_Date     date
  ) is
  begin
    Error(i_Code    => '015',
          i_Message => t('015:message: staff plan can be deleted when status is draft, staff_name=$1, staff_plan_id=$2, status=$3, plan_date=$4',
                         i_Staff_Name,
                         i_Staff_Plan_Id,
                         Hper_Util.t_Staff_Plan_Status(i_Status),
                         i_Plan_Date),
          i_S1      => t('015:solution: change the status of staff plan to draft'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_016
  (
    i_Staff_Plan_Id number,
    i_Plan_Type_Id  number,
    i_Amount        number
  ) is
  begin
    Error(i_Code    => '016',
          i_Message => t('016:message: part amount must be equal to zero, staff_plan_id=$1, plan_type_id=$2, remined_amount=$3',
                         i_Staff_Plan_Id,
                         i_Plan_Type_Id,
                         i_Amount),
          i_S1      => t('016:solution: retry or contact to developers'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_017(i_Month_End number) is
  begin
    Error(i_Code    => '017',
          i_Message => t('017:message: month end must be in [1: 28], month_end:$1', i_Month_End),
          i_Title   => t('017:title: month end is wrong'),
          i_S1      => t('017:solution: change month end in the setting to a number in range [1: 28]'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_018(i_Plan_Type varchar2) is
  begin
    Error(i_Code    => '018',
          i_Message => t('018:message: item plan type must be main or extra, plan_type=$1',
                         i_Plan_Type),
          i_Title   => t('018:title: item plan type is wrong'),
          i_S1      => t('018:solution: change item plan type to main or extra'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_019
  (
    i_Staff_Name    varchar2,
    i_Staff_Plan_Id number,
    i_Plan_Date     date
  ) is
  begin
    Error(i_Code    => '019',
          i_Message => t('019:message: staff plan cannot be added manually to external plan type, staff_name=$1, staff_plan_id=$2, plan_date=$4',
                         i_Staff_Name,
                         i_Staff_Plan_Id,
                         i_Plan_Date),
          i_Title   => t('019:title: staff plan part cannot be saved'),
          i_S1      => t('019:solution: do not save part for this plan type'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_020
  (
    i_Staff_Name    varchar2,
    i_Staff_Plan_Id number,
    i_Plan_Date     date
  ) is
  begin
    Error(i_Code    => '020',
          i_Message => t('020:message: staff plan cannot be deleted manually from external plan type, staff_name=$1, staff_plan_id=$2, plan_date=$4',
                         i_Staff_Name,
                         i_Staff_Plan_Id,
                         i_Plan_Date),
          i_Title   => t('020:title: staff plan part cannot be deleted'));
  end;

end Hper_Error;
/
