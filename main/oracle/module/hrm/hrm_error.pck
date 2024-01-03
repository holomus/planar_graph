create or replace package Hrm_Error is
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_001
  (
    i_Robot_Id   number,
    i_Name       varchar2,
    i_Period     date,
    i_Planed_Fte number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_002
  (
    i_Robot_Id   number,
    i_Name       varchar2,
    i_Period     date,
    i_Booked_Fte number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_003
  (
    i_Name         varchar2,
    i_Period       date,
    i_Occupied_Fte number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_004
  (
    i_Name   varchar2,
    i_Period date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_005
  (
    i_Name       varchar2,
    i_Period     date,
    i_Exceed_Fte number,
    i_Booked_Fte number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_006
  (
    i_Robot_Id   number,
    i_Trans_Date date
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_007;
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_008(i_Register_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_009;
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_010;
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_011;
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_012;
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_013
  (
    i_Robot_Name      varchar2,
    i_Journal_Numbers Array_Varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_014(i_Robot_Name varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_015(i_Register_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_016(i_Register_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_017
  (
    i_Robot_Name   varchar2,
    i_Old_Division varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_018
  (
    i_Robot_Name varchar2,
    i_Old_Job    varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_019(i_Value varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_020(i_Value number);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_021
  (
    i_Division_Name varchar2,
    i_Division_Kind varchar2,
    i_Staff_Name    varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_022
  (
    i_Division_Name varchar2,
    i_Division_Kind varchar2,
    i_Robot_Name    varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_023
  (
    i_Division_Name varchar2,
    i_Staff_Name    varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_024
  (
    i_Division_Name varchar2,
    i_Robot_Name    varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_025(i_Division_Name varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_026
  (
    i_Division_Name varchar2,
    i_Org_Unit_Name varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_027(i_Division_Kind varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_028(i_Division_Name varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_029(i_Value varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_030(i_Robot_Name varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_031(i_Register_Number varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_032
  (
    i_Register_Number varchar2,
    i_Indicator_Name  varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_033(i_Robot_Name varchar2);
  ----------------------------------------------------------------------------------------------------
  Procedure Raise_034(i_Wage_Scale_Name varchar2);
end Hrm_Error;
/
create or replace package body Hrm_Error is
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
    return b.Translate('HRM:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
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
    b.Raise_Extended(i_Code    => Verifix.Hrm_Error_Code || i_Code,
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
    i_Robot_Id   number,
    i_Name       varchar2,
    i_Period     date,
    i_Planed_Fte number
  ) is
  begin
    Error(i_Code    => '001',
          i_Message => t('001:message:planed_fte robot not between range, robot_id=$1, robot_name=$2, period=$3, planed_fte=$4',
                         i_Robot_Id,
                         i_Name,
                         i_Period,
                         i_Planed_Fte),
          i_Title   => t('001:title:planned fte exceeded'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_002
  (
    i_Robot_Id   number,
    i_Name       varchar2,
    i_Period     date,
    i_Booked_Fte number
  ) is
  begin
    Error(i_Code    => '002',
          i_Message => t('002:message:cannot book fte ($1{booked_fte}) for robot $2{robot_name}, exceeded range between 0 and 1. booked_fte = $3{booked_fte}',
                         i_Name,
                         i_Period,
                         i_Booked_Fte),
          i_Title   => t('002:title:book fte exceeded'),
          i_S1      => t('002:solution:book less fte for robot $1{robot_id}', i_Robot_Id));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_003
  (
    i_Name         varchar2,
    i_Period       date,
    i_Occupied_Fte number
  ) is
  begin
    Error(i_Code    => '003',
          i_Message => t('003:message:cannot occupy fte ($1{occupied_fte}) for robot $2{robot_name}, exceeded range between 0 and 1',
                         i_Name,
                         i_Period,
                         i_Occupied_Fte),
          i_Title   => t('003:title:occupied fte exceeded'),
          i_S1      => t('003:solution:choose another fte kind with less fte value'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_004
  (
    i_Name   varchar2,
    i_Period date
  ) is
  begin
    Error(i_Code    => '004',
          i_Message => t('004:message:planned fte exceeded for robot $1{robot_name} on $2{period}',
                         i_Name,
                         i_Period),
          i_Title   => t('004:title:planned fte exceeded'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_005
  (
    i_Name       varchar2,
    i_Period     date,
    i_Exceed_Fte number,
    i_Booked_Fte number
  ) is
  begin
    Error(i_Code    => '005',
          i_Message => t('005:message:robot $1{robot_name} has $2{exceed_fte} exceeding fte on $3{exceed_period}',
                         i_Name,
                         i_Exceed_Fte,
                         i_Period),
          i_Title   => t('005:title:not enough fte'),
          i_S1      => t('005:solution:choose another fte kind with less fte value'),
          i_S2      => case
                         when i_Booked_Fte > 0 then
                          t('005:solution:book less fte')
                         else
                          null
                       end);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_006
  (
    i_Robot_Id   number,
    i_Trans_Date date
  ) is
  begin
    Error(i_Code    => '006',
          i_Message => t('006:message:implicitly created robot cannot have booked transaction, robot_id=$1, trans_date=$2',
                         i_Robot_Id,
                         i_Trans_Date));
  
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_007 is
  begin
    Error(i_Code => '007', i_Message => t('007:message:robot turnover fte kind not found'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_008(i_Register_Id number) is
  begin
    Error(i_Code    => '008',
          i_Message => t('008:message:cannot change/save wage register. wage register $1{register_id} already posted',
                         i_Register_Id),
          i_S1      => t('008:solution:post wage register with changes'),
          i_S2      => t('008:solution:unpost wage register then save changes'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_009 is
  begin
    Error(i_Code => '009', i_Message => t('009:message:wage register round model must be given'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_010 is
  begin
    Error(i_Code    => '010',
          i_Message => t('010:message:wage register base wage model must be given'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_011 is
  begin
    Error(i_Code => '011', i_Message => t('011:message:cannot save register without ranks'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_012 is
  begin
    Error(i_Code => '012', i_Message => t('012:message:wage register coefficient must be given'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_013
  (
    i_Robot_Name      varchar2,
    i_Journal_Numbers Array_Varchar2
  ) is
  begin
    Error(i_Code    => '013',
          i_Message => t('013:message:cannot disable positions, robot $1{robot_name} was used by multiple staffs',
                         i_Robot_Name),
          i_S1      => t('013:solution:remove robot from all but one journals $1{journal_numbers}',
                         Fazo.Gather(i_Journal_Numbers, ', ')));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_014(i_Robot_Name varchar2) is
  begin
    Error(i_Code    => '014',
          i_Message => t('014:message:cannot disable positions, robot $1{robot_name} has booked fte',
                         i_Robot_Name),
          i_S1      => t('014:solution:remove all bookings for robot $1{robot_name}', i_Robot_Name));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_015(i_Register_Id number) is
  begin
    Error(i_Code    => '015',
          i_Message => t('015:message:cannot post wage register. wage register $1{register_id} already posted',
                         i_Register_Id));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_016(i_Register_Id number) is
  begin
    Error(i_Code    => '016',
          i_Message => t('016:message:to unpost register $1{register_id} it should be initially posted',
                         i_Register_Id));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_017
  (
    i_Robot_Name   varchar2,
    i_Old_Division varchar2
  ) is
  begin
    Error(i_Code    => '017',
          i_Message => t('017:message:cannot save robot $1{robot_name}, division change is not allowed',
                         i_Robot_Name),
          i_Title   => t('017:title:cannot change division'),
          i_S1      => t('017:solution:restore old division ($1{old_division}) and try again',
                         i_Old_Division));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_018
  (
    i_Robot_Name varchar2,
    i_Old_Job    varchar2
  ) is
  begin
    Error(i_Code    => '018',
          i_Message => t('018:message:cannot save robot $1{robot_name}, job change is not allowed',
                         i_Robot_Name),
          i_Title   => t('018:title:cannot change job'),
          i_S1      => t('018:solution:restore old job ($1{old_job}) and try again', i_Old_Job));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_019(i_Value varchar2) is
  begin
    Error(i_Code    => '019',
          i_Message => t('019:message:restrict view hidden salaries value must be in (Y, N), value: $1{value}',
                         i_Value));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_020(i_Value number) is
  begin
    Error(i_Code    => '020',
          i_Message => t('020:message:planned fte should be between 0 and 1, value: $1{planned_fte}',
                         i_Value));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_021
  (
    i_Division_Name varchar2,
    i_Division_Kind varchar2,
    i_Staff_Name    varchar2
  ) is
  begin
    Error(i_Code    => '021',
          i_Message => t('021:message:division $1{division_name} could not become $1{division_kind_name} because staff $3{staff_name} will change its department as result',
                         i_Division_Name,
                         i_Division_Kind,
                         i_Staff_Name),
          i_Title   => t('021:title:org structure'),
          i_S1      => t('021:solution:manually change department for staff $1{staff_name}',
                         i_Staff_Name));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_022
  (
    i_Division_Name varchar2,
    i_Division_Kind varchar2,
    i_Robot_Name    varchar2
  ) is
  begin
    Error(i_Code    => '022',
          i_Message => t('022:message:division $1{division_name} could not become $1{division_kind_name} because robot $3{robot_name} will change its department as result',
                         i_Division_Name,
                         i_Division_Kind,
                         i_Robot_Name),
          i_Title   => t('022:title:org structure'),
          i_S1      => t('022:solution:manually change department for robot $1{robot_name}',
                         i_Robot_Name));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_023
  (
    i_Division_Name varchar2,
    i_Staff_Name    varchar2
  ) is
  begin
    Error(i_Code    => '023',
          i_Message => t('023:message:division $1{division_name} could not change its parent because staff $2{staff_name} will change its department as result',
                         i_Division_Name,
                         i_Staff_Name),
          i_Title   => t('023:title:org structure'),
          i_S1      => t('023:solution:manually change department for staff $1{staff_name}',
                         i_Staff_Name));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_024
  (
    i_Division_Name varchar2,
    i_Robot_Name    varchar2
  ) is
  begin
    Error(i_Code    => '024',
          i_Message => t('024:message:division $1{division_name} could not change its parent because robot $2{robot_name} will change its department as result',
                         i_Division_Name,
                         i_Robot_Name),
          i_Title   => t('024:title:org structure'),
          i_S1      => t('024:solution:manually change department for robot $1{robot_name}',
                         i_Robot_Name));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_025(i_Division_Name varchar2) is
  begin
    Error(i_Code    => '025',
          i_Message => t('025:message:could not change org structure settings because division $1{division_name} uses advanced settings',
                         i_Division_Name),
          i_Title   => t('025:title:org structure'),
          i_S1      => t('025:solution:remove or change all divisions that are not departments'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_026
  (
    i_Division_Name varchar2,
    i_Org_Unit_Name varchar2
  ) is
  begin
    Error(i_Code    => '026',
          i_Message => t('026:message:org unit $1{org_unit_name} is not a child of division $2{division_name}',
                         i_Org_Unit_Name,
                         i_Division_Name),
          i_Title   => t('026:title:org structure'),
          i_S1      => t('026:solution:choose a child of division $1{division_name}',
                         i_Division_Name));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_027(i_Division_Kind varchar2) is
  begin
    Error(i_Code    => '027',
          i_Message => t('027:message:$1{division_kind} division should have parent department',
                         i_Division_Kind),
          i_Title   => t('027:title:org structure'),
          i_S1      => t('027:solution:set parent division from departments'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_028(i_Division_Name varchar2) is
  begin
    Error(i_Code    => '028',
          i_Message => t('028:message:robot must be assigned to department'),
          i_Title   => t('028:title:org structure'),
          i_S1      => t('028:solution:change division $1{division_name} to department',
                         i_Division_Name),
          i_S2      => t('028:solution:choose another division'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_029(i_Value varchar2) is
  begin
    Error(i_Code    => '029',
          i_Message => t('029:message:restrict all salaries value must be in (Y, N), value: $1{value}',
                         i_Value));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_030(i_Robot_Name varchar2) is
  begin
    Error(i_Code    => '030',
          i_Message => t('030:message:you cannot set closed date for $1{robot_name}', i_Robot_Name),
          i_Title   => t('030:title:find robot persons'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_031(i_Register_Number varchar2) is
  begin
    Error(i_Code    => '031',
          i_Message => t('031:message:for save wage scale register, wage must be set, $1{register_number}',
                         i_Register_Number),
          i_Title   => t('031:title:wage not found'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_032
  (
    i_Register_Number varchar2,
    i_Indicator_Name  varchar2
  ) is
  begin
    Error(i_Code    => '032',
          i_Message => t('032:message:indicator must be system indicator, register number: $1{register_number}, indicator name : $2{indicator_name}',
                         i_Register_Number,
                         i_Indicator_Name),
          i_Title   => t('032:title:indicator is not system indicator'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_033(i_Robot_Name varchar2) is
  begin
    Error(i_Code    => '033',
          i_Message => t('033:message:robot not found with this name, name: $1{robot name}',
                         i_Robot_Name),
          i_Title   => t('033:title:robot not found'));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Raise_034(i_Wage_Scale_Name varchar2) is
  begin
    Error(i_Code    => '034',
          i_Message => t('034:message:wage scale not found with this name, name: $1{wage scale name}',
                         i_Wage_Scale_Name),
          i_Title   => t('034:title:wage scale not found'));
  end;

end Hrm_Error;
/
