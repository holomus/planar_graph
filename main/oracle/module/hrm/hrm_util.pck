create or replace package Hrm_Util is
  ----------------------------------------------------------------------------------------------------
  Function Load_Setting
  (
    i_Company_Id number,
    i_Filial_Id  number
  ) return Hrm_Settings%rowtype Result_Cache;
  ----------------------------------------------------------------------------------------------------
  Function Load_Template
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Division_Id number,
    i_Job_Id      number,
    i_Rank_Id     number
  ) return Hrm_Job_Templates%rowtype;
  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Enabled_Pos_History
  (
    i_Company_Id number,
    i_Filial_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Enabled_Position
  (
    i_Company_Id number,
    i_Filial_Id  number
  );
  ---------------------------------------------------------------------------------------------------- 
  Function Robot_Name
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Robot_Id    number,
    i_Division_Id number,
    i_Job_Id      number,
    i_Rank_Id     number := null
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------  
  Procedure Wage_Scale_Register_New
  (
    o_Register        out Hrm_Pref.Wage_Scale_Register_Rt,
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Register_Id     number,
    i_Register_Date   date,
    i_Register_Number varchar2,
    i_Wage_Scale_Id   number,
    i_With_Base_Wage  varchar2 := null,
    i_Round_Model     varchar2 := null,
    i_Base_Wage       number := null,
    i_Valid_From      date,
    i_Note            varchar2 := null
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Register_Add_Rank
  (
    p_Register in out nocopy Hrm_Pref.Wage_Scale_Register_Rt,
    i_Rank_Id  number
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Robot_New
  (
    o_Robot                    out Hrm_Pref.Robot_Rt,
    i_Company_Id               number,
    i_Filial_Id                number,
    i_Robot_Id                 number,
    i_Name                     varchar2,
    i_Code                     varchar2,
    i_Robot_Group_Id           number,
    i_Division_Id              number,
    i_Job_Id                   number,
    i_Org_Unit_Id              number,
    i_State                    varchar2,
    i_Opened_Date              date,
    i_Closed_Date              date,
    i_Schedule_Id              number,
    i_Rank_Id                  number,
    i_Vacation_Days_Limit      number,
    i_Labor_Function_Id        number,
    i_Description              varchar2,
    i_Hiring_Condition         varchar2,
    i_Contractual_Wage         varchar2,
    i_Wage_Scale_Id            number,
    i_Access_Hidden_Salary     varchar2,
    i_Position_Employment_Kind varchar2 := Hrm_Pref.c_Position_Employment_Staff,
    i_Planned_Fte              number := 1,
    i_Currency_Id              number,
    i_Role_Ids                 Array_Number := Array_Number(),
    i_Allowed_Division_Ids     Array_Number := Array_Number()
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Oper_Type_Add
  (
    p_Robot         in out nocopy Hrm_Pref.Robot_Rt,
    i_Oper_Type_Id  number,
    i_Indicator_Ids Array_Number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Indicator_Add
  (
    p_Robot           in out nocopy Hrm_Pref.Robot_Rt,
    i_Indicator_Id    number,
    i_Indicator_Value number
  );

  ----------------------------------------------------------------------------------------------------  
  Procedure Job_Template_New
  (
    o_Template            out Hrm_Pref.Job_Template_Rt,
    i_Company_Id          number,
    i_Filial_Id           number,
    i_Template_Id         number,
    i_Division_Id         number,
    i_Job_Id              number,
    i_Rank_Id             number,
    i_Schedule_Id         number,
    i_Vacation_Days_Limit number,
    i_Wage_Scale_Id       number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Job_Temp_Add_Oper_Type
  (
    p_Template      in out nocopy Hrm_Pref.Job_Template_Rt,
    i_Oper_Type_Id  number,
    i_Indicator_Ids Array_Number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Job_Temp_Add_Indicator
  (
    p_Template        in out nocopy Hrm_Pref.Job_Template_Rt,
    i_Indicator_Id    number,
    i_Indicator_Value number
  );
  ----------------------------------------------------------------------------------------------------
  -- job bonus type
  ----------------------------------------------------------------------------------------------------
  Procedure Job_Bonus_Type_New
  (
    o_Job_Bonus_Type in out Hrm_Pref.Job_Bonus_Type_Rt,
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Job_Id         number,
    i_Bonus_Types    Array_Varchar2,
    i_Percentages    Array_Number
  );
  ----------------------------------------------------------------------------------------------------
  -- division
  ----------------------------------------------------------------------------------------------------
  Procedure Division_New
  (
    o_Division      out Hrm_Pref.Division_Rt,
    i_Division      Mhr_Divisions%rowtype,
    i_Schedule_Id   number,
    i_Manager_Id    number,
    i_Is_Department varchar2,
    i_Subfilial_Id  number := null
  );
  ----------------------------------------------------------------------------------------------------
  Function Register_Change_Dates
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Wage_Scale_Id number,
    i_Begin_Date    date,
    i_End_Date      date
  ) return Array_Date;
  ----------------------------------------------------------------------------------------------------
  Function Closest_Parent_Department_Id
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Division_Id number
  ) return number;
  ----------------------------------------------------------------------------------------------------  
  Function Closest_Wage_Scale_Indicator_Value
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Wage_Scale_Id number,
    i_Indicator_Id  number,
    i_Period        date,
    i_Rank_Id       number
  ) return number;
  ----------------------------------------------------------------------------------------------------  
  Function Closest_Wage
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Wage_Scale_Id number,
    i_Period        date,
    i_Rank_Id       number
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Get_Robot_Wage
  (
    i_Company_Id       number,
    i_Filial_Id        number,
    i_Robot_Id         number,
    i_Contractual_Wage varchar2,
    i_Wage_Scale_Id    number,
    i_Rank_Id          number
  ) return number;
  ----------------------------------------------------------------------------------------------------  
  Function Closest_Register_Id
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Wage_Scale_Id number,
    i_Period        date
  ) return number;
  ----------------------------------------------------------------------------------------------------  
  Function Fix_Allowed_Divisions
  (
    i_Company_Id           number,
    i_Filial_Id            number,
    i_Robot_Id             number := null,
    i_Allowed_Division_Ids Array_Number
  ) return Array_Number;
  ----------------------------------------------------------------------------------------------------
  Function Access_To_Hidden_Salary_Job
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Job_Id     number,
    i_User_Id    number
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Has_Access_To_Hidden_Salary_Job
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Job_Id     number,
    i_User_Id    number
  ) return boolean;
  ----------------------------------------------------------------------------------------------------
  Function Access_Edit_Div_Job_Of_Robot
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Robot_Id   number
  ) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Get_Planned_Fte
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Robot_Id   number,
    i_Period     date := Trunc(sysdate)
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Restrict_To_View_All_Salaries(i_Company_Id number) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Restrict_All_Salaries(i_Company_Id number) return varchar2;
  ----------------------------------------------------------------------------------------------------   
  Procedure Access_To_Set_Closed_Date
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Robot_Id   number,
    i_Robot_Name varchar2
  );
  ----------------------------------------------------------------------------------------------------   
  Function Robot_Id_By_Name
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Name       varchar2
  ) return number;
  ----------------------------------------------------------------------------------------------------   
  Function Wage_Scale_Id_By_Name
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Name       varchar2
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function t_Bonus_Type(i_Bonus_Type varchar2) return varchar2;
  Function Bonus_Types return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Division_Kind_Department return varchar2;
  Function t_Division_Kind_Team return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Division_Kind(i_Is_Division varchar2) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function t_Position_Employment(i_Employment_Kind varchar2) return varchar2;
  Function Position_Employments return Matrix_Varchar2;
  ----------------------------------------------------------------------------------------------------   
  Function t_Robot_Division_Access_Type(i_Access_Type varchar2) return varchar2;
  Function Robot_Division_Access_Types return Matrix_Varchar2;
end Hrm_Util;
/
create or replace package body Hrm_Util is
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
  Function Load_Setting
  (
    i_Company_Id number,
    i_Filial_Id  number
  ) return Hrm_Settings%rowtype Result_Cache is
    result Hrm_Settings%rowtype;
  begin
    if not z_Hrm_Settings.Exist(i_Company_Id => i_Company_Id,
                                i_Filial_Id  => i_Filial_Id,
                                o_Row        => result) then
      Result.Company_Id             := i_Company_Id;
      Result.Filial_Id              := i_Filial_Id;
      Result.Position_Enable        := 'N';
      Result.Position_Check         := 'N';
      Result.Keep_Rank              := 'N';
      Result.Keep_Salary            := 'N';
      Result.Keep_Schedule          := 'N';
      Result.Keep_Vacation_Limit    := 'N';
      Result.Position_Booking       := 'N';
      Result.Position_History       := 'N';
      Result.Position_Fixing        := 'N';
      Result.Parttime_Enable        := 'N';
      Result.Rank_Enable            := 'N';
      Result.Wage_Scale_Enable      := 'N';
      Result.Notification_Enable    := 'N';
      Result.Autogen_Staff_Number   := 'Y';
      Result.Advanced_Org_Structure := 'N';
    end if;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Template
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Division_Id number,
    i_Job_Id      number,
    i_Rank_Id     number
  ) return Hrm_Job_Templates%rowtype is
    r_Template Hrm_Job_Templates%rowtype;
  begin
    if i_Rank_Id is not null then
      select s.*
        into r_Template
        from Hrm_Job_Templates s
       where s.Company_Id = i_Company_Id
         and s.Filial_Id = i_Filial_Id
         and s.Division_Id = i_Division_Id
         and s.Job_Id = i_Job_Id
         and s.Rank_Id = i_Rank_Id;
    else
      select s.*
        into r_Template
        from Hrm_Job_Templates s
       where s.Company_Id = i_Company_Id
         and s.Filial_Id = i_Filial_Id
         and s.Division_Id = i_Division_Id
         and s.Job_Id = i_Job_Id
         and s.Rank_Id is null;
    end if;
  
    return r_Template;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Enabled_Pos_History
  (
    i_Company_Id number,
    i_Filial_Id  number
  ) is
    r_Setting Hrm_Settings%rowtype;
  begin
    r_Setting := Load_Setting(i_Company_Id => i_Company_Id, i_Filial_Id => i_Filial_Id);
  
    if r_Setting.Position_Enable = 'N' then
      b.Raise_Error(t('initially, to do enabling position'));
    end if;
  
    if r_Setting.Position_History = 'N' then
      b.Raise_Error(t('initially, to do enabling position history'));
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Enabled_Position
  (
    i_Company_Id number,
    i_Filial_Id  number
  ) is
    r_Setting Hrm_Settings%rowtype;
  begin
    r_Setting := Load_Setting(i_Company_Id => i_Company_Id, i_Filial_Id => i_Filial_Id);
  
    if r_Setting.Position_Enable = 'N' then
      b.Raise_Error(t('initially, to do enabling position'));
    end if;
  
    if r_Setting.Position_History = 'Y' then
      b.Raise_Error(t('initially, to do disabling position history'));
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Robot_Name
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Robot_Id    number,
    i_Division_Id number,
    i_Job_Id      number,
    i_Rank_Id     number := null
  ) return varchar2 is
    v_Name varchar2(200 char);
    result varchar2(200 char);
  begin
    v_Name := z_Mhr_Divisions.Load(i_Company_Id => i_Company_Id, --
              i_Filial_Id => i_Filial_Id, --
              i_Division_Id => i_Division_Id).Name;
  
    result := '/' || v_Name || '/(' || i_Robot_Id || ')';
  
    if i_Rank_Id is not null then
      v_Name := z_Mhr_Ranks.Load(i_Company_Id => i_Company_Id, --
                i_Filial_Id => i_Filial_Id, --
                i_Rank_Id => i_Rank_Id).Name;
    
      result := ', ' || v_Name || result;
    end if;
  
    v_Name := z_Mhr_Jobs.Load(i_Company_Id => i_Company_Id, --
              i_Filial_Id => i_Filial_Id, --
              i_Job_Id => i_Job_Id).Name;
  
    return v_Name || result;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Wage_Scale_Register_New
  (
    o_Register        out Hrm_Pref.Wage_Scale_Register_Rt,
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Register_Id     number,
    i_Register_Date   date,
    i_Register_Number varchar2,
    i_Wage_Scale_Id   number,
    i_With_Base_Wage  varchar2,
    i_Round_Model     varchar2,
    i_Base_Wage       number,
    i_Valid_From      date,
    i_Note            varchar2
  ) is
  begin
    o_Register.Company_Id      := i_Company_Id;
    o_Register.Filial_Id       := i_Filial_Id;
    o_Register.Register_Id     := i_Register_Id;
    o_Register.Register_Date   := i_Register_Date;
    o_Register.Register_Number := i_Register_Number;
    o_Register.Wage_Scale_Id   := i_Wage_Scale_Id;
    o_Register.With_Base_Wage  := i_With_Base_Wage;
    o_Register.Round_Model     := i_Round_Model;
    o_Register.Base_Wage       := i_Base_Wage;
    o_Register.Valid_From      := i_Valid_From;
    o_Register.Note            := i_Note;
  
    o_Register.Ranks := Hrm_Pref.Register_Ranks_Nt();
  end;
  ----------------------------------------------------------------------------------------------------  
  Procedure Register_Add_Rank
  (
    p_Register in out nocopy Hrm_Pref.Wage_Scale_Register_Rt,
    i_Rank_Id  number
  ) is
    v_Rank Hrm_Pref.Register_Ranks_Rt;
  begin
    v_Rank.Rank_Id    := i_Rank_Id;
    v_Rank.Indicators := Hrm_Pref.Regiser_Rank_Indicator_Nt();
  
    p_Register.Ranks.Extend();
    p_Register.Ranks(p_Register.Ranks.Count) := v_Rank;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Robot_New
  (
    o_Robot                    out Hrm_Pref.Robot_Rt,
    i_Company_Id               number,
    i_Filial_Id                number,
    i_Robot_Id                 number,
    i_Name                     varchar2,
    i_Code                     varchar2,
    i_Robot_Group_Id           number,
    i_Division_Id              number,
    i_Job_Id                   number,
    i_Org_Unit_Id              number,
    i_State                    varchar2,
    i_Opened_Date              date,
    i_Closed_Date              date,
    i_Schedule_Id              number,
    i_Rank_Id                  number,
    i_Vacation_Days_Limit      number,
    i_Labor_Function_Id        number,
    i_Description              varchar2,
    i_Hiring_Condition         varchar2,
    i_Contractual_Wage         varchar2,
    i_Wage_Scale_Id            number,
    i_Access_Hidden_Salary     varchar2,
    i_Position_Employment_Kind varchar2 := Hrm_Pref.c_Position_Employment_Staff,
    i_Planned_Fte              number := 1,
    i_Currency_Id              number,
    i_Role_Ids                 Array_Number,
    i_Allowed_Division_Ids     Array_Number
  ) is
  begin
    z_Mrf_Robots.Init(p_Row            => o_Robot.Robot,
                      i_Company_Id     => i_Company_Id,
                      i_Filial_Id      => i_Filial_Id,
                      i_Robot_Id       => i_Robot_Id,
                      i_Name           => i_Name,
                      i_Code           => i_Code,
                      i_Robot_Group_Id => i_Robot_Group_Id,
                      i_Division_Id    => i_Division_Id,
                      i_Job_Id         => i_Job_Id,
                      i_State          => i_State);
  
    o_Robot.Org_Unit_Id              := i_Org_Unit_Id;
    o_Robot.Opened_Date              := i_Opened_Date;
    o_Robot.Closed_Date              := i_Closed_Date;
    o_Robot.Schedule_Id              := i_Schedule_Id;
    o_Robot.Rank_Id                  := i_Rank_Id;
    o_Robot.Vacation_Days_Limit      := i_Vacation_Days_Limit;
    o_Robot.Labor_Function_Id        := i_Labor_Function_Id;
    o_Robot.Description              := i_Description;
    o_Robot.Hiring_Condition         := i_Hiring_Condition;
    o_Robot.Contractual_Wage         := i_Contractual_Wage;
    o_Robot.Wage_Scale_Id            := i_Wage_Scale_Id;
    o_Robot.Access_Hidden_Salary     := i_Access_Hidden_Salary;
    o_Robot.Planned_Fte              := i_Planned_Fte;
    o_Robot.Position_Employment_Kind := i_Position_Employment_Kind;
    o_Robot.Currency_Id              := i_Currency_Id;
    o_Robot.Allowed_Division_Ids     := i_Allowed_Division_Ids;
    o_Robot.Role_Ids                 := i_Role_Ids;
  
    o_Robot.Indicators := Href_Pref.Indicator_Nt();
    o_Robot.Oper_Types := Href_Pref.Oper_Type_Nt();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Oper_Type_Add
  (
    p_Robot         in out nocopy Hrm_Pref.Robot_Rt,
    i_Oper_Type_Id  number,
    i_Indicator_Ids Array_Number
  ) is
    v_Oper_Type Href_Pref.Oper_Type_Rt;
  begin
    v_Oper_Type.Oper_Type_Id  := i_Oper_Type_Id;
    v_Oper_Type.Indicator_Ids := i_Indicator_Ids;
  
    p_Robot.Oper_Types.Extend;
    p_Robot.Oper_Types(p_Robot.Oper_Types.Count) := v_Oper_Type;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Indicator_Add
  (
    p_Robot           in out nocopy Hrm_Pref.Robot_Rt,
    i_Indicator_Id    number,
    i_Indicator_Value number
  ) is
    v_Indicator Href_Pref.Indicator_Rt;
  begin
    v_Indicator.Indicator_Id    := i_Indicator_Id;
    v_Indicator.Indicator_Value := i_Indicator_Value;
  
    p_Robot.Indicators.Extend;
    p_Robot.Indicators(p_Robot.Indicators.Count) := v_Indicator;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Job_Template_New
  (
    o_Template            out Hrm_Pref.Job_Template_Rt,
    i_Company_Id          number,
    i_Filial_Id           number,
    i_Template_Id         number,
    i_Division_Id         number,
    i_Job_Id              number,
    i_Rank_Id             number,
    i_Schedule_Id         number,
    i_Vacation_Days_Limit number,
    i_Wage_Scale_Id       number
  ) is
  begin
    o_Template.Company_Id          := i_Company_Id;
    o_Template.Filial_Id           := i_Filial_Id;
    o_Template.Template_Id         := i_Template_Id;
    o_Template.Division_Id         := i_Division_Id;
    o_Template.Job_Id              := i_Job_Id;
    o_Template.Rank_Id             := i_Rank_Id;
    o_Template.Schedule_Id         := i_Schedule_Id;
    o_Template.Vacation_Days_Limit := i_Vacation_Days_Limit;
    o_Template.Wage_Scale_Id       := i_Wage_Scale_Id;
  
    o_Template.Indicators := Href_Pref.Indicator_Nt();
    o_Template.Oper_Types := Href_Pref.Oper_Type_Nt();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Job_Temp_Add_Oper_Type
  (
    p_Template      in out nocopy Hrm_Pref.Job_Template_Rt,
    i_Oper_Type_Id  number,
    i_Indicator_Ids Array_Number
  ) is
    v_Oper_Type Href_Pref.Oper_Type_Rt;
  begin
    v_Oper_Type.Oper_Type_Id  := i_Oper_Type_Id;
    v_Oper_Type.Indicator_Ids := i_Indicator_Ids;
  
    p_Template.Oper_Types.Extend;
    p_Template.Oper_Types(p_Template.Oper_Types.Count) := v_Oper_Type;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Job_Temp_Add_Indicator
  (
    p_Template        in out nocopy Hrm_Pref.Job_Template_Rt,
    i_Indicator_Id    number,
    i_Indicator_Value number
  ) is
    v_Indicator Href_Pref.Indicator_Rt;
  begin
    v_Indicator.Indicator_Id    := i_Indicator_Id;
    v_Indicator.Indicator_Value := i_Indicator_Value;
  
    p_Template.Indicators.Extend;
    p_Template.Indicators(p_Template.Indicators.Count) := v_Indicator;
  end;

  ----------------------------------------------------------------------------------------------------
  -- job bonus type
  ----------------------------------------------------------------------------------------------------
  Procedure Job_Bonus_Type_New
  (
    o_Job_Bonus_Type in out Hrm_Pref.Job_Bonus_Type_Rt,
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Job_Id         number,
    i_Bonus_Types    Array_Varchar2,
    i_Percentages    Array_Number
  ) is
  begin
    o_Job_Bonus_Type.Company_Id  := i_Company_Id;
    o_Job_Bonus_Type.Filial_Id   := i_Filial_Id;
    o_Job_Bonus_Type.Job_Id      := i_Job_Id;
    o_Job_Bonus_Type.Bonus_Types := i_Bonus_Types;
    o_Job_Bonus_Type.Percentages := i_Percentages;
  end;

  ----------------------------------------------------------------------------------------------------
  -- division
  ----------------------------------------------------------------------------------------------------
  Procedure Division_New
  (
    o_Division      out Hrm_Pref.Division_Rt,
    i_Division      Mhr_Divisions%rowtype,
    i_Schedule_Id   number,
    i_Manager_Id    number,
    i_Is_Department varchar2,
    i_Subfilial_Id  number := null
  ) is
  begin
    o_Division.Division      := i_Division;
    o_Division.Schedule_Id   := i_Schedule_Id;
    o_Division.Manager_Id    := i_Manager_Id;
    o_Division.Is_Department := i_Is_Department;
    o_Division.Subfilial_Id  := i_Subfilial_Id;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Register_Change_Dates
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Wage_Scale_Id number,
    i_Begin_Date    date,
    i_End_Date      date
  ) return Array_Date is
    result Array_Date;
  begin
    select q.Valid_From
      bulk collect
      into result
      from Hrm_Wage_Scale_Registers q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Wage_Scale_Id = i_Wage_Scale_Id
       and q.Valid_From between i_Begin_Date and i_End_Date
       and q.Posted = 'Y';
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Closest_Parent_Department_Id
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Division_Id number
  ) return number is
    result number;
  begin
    select Pd.Parent_Id
      into result
      from Mhr_Parent_Divisions Pd
     where Pd.Company_Id = i_Company_Id
       and Pd.Filial_Id = i_Filial_Id
       and Pd.Division_Id = i_Division_Id
       and Pd.Lvl = (select min(q.Lvl)
                       from Mhr_Parent_Divisions q
                       join Hrm_Divisions p
                         on p.Company_Id = q.Company_Id
                        and p.Filial_Id = q.Filial_Id
                        and p.Division_Id = q.Parent_Id
                      where q.Company_Id = i_Company_Id
                        and q.Filial_Id = i_Filial_Id
                        and q.Division_Id = i_Division_Id
                        and p.Is_Department = 'Y');
  
    return result;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Closest_Wage_Scale_Indicator_Value
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Wage_Scale_Id number,
    i_Indicator_Id  number,
    i_Period        date,
    i_Rank_Id       number
  ) return number is
    result number;
  begin
    select r.Indicator_Value
      into result
      from Hrm_Wage_Scale_Registers t
      join Hrm_Register_Rank_Indicators r
        on r.Company_Id = t.Company_Id
       and r.Filial_Id = t.Filial_Id
       and r.Register_Id = t.Register_Id
       and r.Rank_Id = i_Rank_Id
       and r.Indicator_Id = i_Indicator_Id
     where t.Company_Id = i_Company_Id
       and t.Filial_Id = i_Filial_Id
       and t.Wage_Scale_Id = i_Wage_Scale_Id
       and t.Valid_From <= i_Period
       and t.Posted = 'Y'
     order by t.Valid_From desc
     fetch first row only;
  
    return result;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Closest_Wage
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Wage_Scale_Id number,
    i_Period        date,
    i_Rank_Id       number
  ) return number is
  begin
    return Closest_Wage_Scale_Indicator_Value(i_Company_Id    => i_Company_Id,
                                              i_Filial_Id     => i_Filial_Id,
                                              i_Wage_Scale_Id => i_Wage_Scale_Id,
                                              i_Indicator_Id  => Href_Util.Indicator_Id(i_Company_Id => i_Company_Id,
                                                                                        i_Pcode      => Href_Pref.c_Pcode_Indicator_Wage),
                                              i_Period        => i_Period,
                                              i_Rank_Id       => i_Rank_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Robot_Wage
  (
    i_Company_Id       number,
    i_Filial_Id        number,
    i_Robot_Id         number,
    i_Contractual_Wage varchar2,
    i_Wage_Scale_Id    number,
    i_Rank_Id          number
  ) return number is
    v_Current_Date      date := Trunc(sysdate);
    v_Wage_Indicator_Id number;
  
    ----------------------------------------------------------------------------------------------------
    Function Get_Max_Wage_Scale return number is
      result number;
    begin
      select (select max(r.Indicator_Value)
                from Hrm_Register_Rank_Indicators r
               where r.Company_Id = t.Company_Id
                 and r.Filial_Id = t.Filial_Id
                 and r.Register_Id = t.Register_Id
                 and r.Indicator_Id =
                     Href_Util.Indicator_Id(i_Company_Id => r.Company_Id,
                                            i_Pcode      => Href_Pref.c_Pcode_Indicator_Wage))
        into result
        from Hrm_Wage_Scale_Registers t
       where t.Company_Id = i_Company_Id
         and t.Filial_Id = i_Filial_Id
         and t.Wage_Scale_Id = i_Wage_Scale_Id
         and t.Valid_From <= v_Current_Date
         and t.Posted = 'Y'
       order by t.Valid_From desc
       fetch first row only;
    
      return result;
    exception
      when No_Data_Found then
        return null;
    end;
  begin
    if i_Contractual_Wage = 'N' then
      if i_Rank_Id is null then
        return Get_Max_Wage_Scale;
      end if;
    
      return Hrm_Util.Closest_Wage(i_Company_Id    => i_Company_Id,
                                   i_Filial_Id     => i_Filial_Id,
                                   i_Wage_Scale_Id => i_Wage_Scale_Id,
                                   i_Period        => v_Current_Date,
                                   i_Rank_Id       => i_Rank_Id);
    end if;
  
    v_Wage_Indicator_Id := Href_Util.Indicator_Id(i_Company_Id => i_Company_Id,
                                                  i_Pcode      => Href_Pref.c_Pcode_Indicator_Wage);
  
    return z_Hrm_Robot_Indicators.Take(i_Company_Id   => i_Company_Id,
                                       i_Filial_Id    => i_Filial_Id,
                                       i_Robot_Id     => i_Robot_Id,
                                       i_Indicator_Id => v_Wage_Indicator_Id).Indicator_Value;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Closest_Register_Id
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Wage_Scale_Id number,
    i_Period        date
  ) return number is
    result number;
  begin
    select t.Register_Id
      into result
      from Hrm_Wage_Scale_Registers t
     where t.Company_Id = i_Company_Id
       and t.Filial_Id = i_Filial_Id
       and t.Wage_Scale_Id = i_Wage_Scale_Id
       and t.Valid_From <= i_Period
       and t.Posted = 'Y'
     order by t.Valid_From
     fetch first row only;
  
    return result;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Fix_Allowed_Divisions
  (
    i_Company_Id           number,
    i_Filial_Id            number,
    i_Robot_Id             number := null,
    i_Allowed_Division_Ids Array_Number
  ) return Array_Number is
    v_Is_Child                boolean;
    v_Structural_Division_Ids Array_Number;
    v_Allowed_Division_Ids    Array_Number := Nvl(i_Allowed_Division_Ids, Array_Number());
    result                    Array_Number := Array_Number();
  begin
    if i_Robot_Id is not null then
      select d.Division_Id
        bulk collect
        into v_Structural_Division_Ids
        from Hrm_Robot_Divisions d
       where d.Company_Id = i_Company_Id
         and d.Filial_Id = i_Filial_Id
         and d.Robot_Id = i_Robot_Id
         and d.Access_Type = Hrm_Pref.c_Access_Type_Structural;
    
      v_Allowed_Division_Ids := v_Allowed_Division_Ids multiset Except v_Structural_Division_Ids;
    end if;
  
    for i in 1 .. v_Allowed_Division_Ids.Count
    loop
      v_Is_Child := false;
    
      for j in 1 .. v_Allowed_Division_Ids.Count
      loop
        if z_Mhr_Parent_Divisions.Exist(i_Company_Id  => i_Company_Id,
                                        i_Filial_Id   => i_Filial_Id,
                                        i_Division_Id => v_Allowed_Division_Ids(i),
                                        i_Parent_Id   => v_Allowed_Division_Ids(j)) then
          v_Is_Child := true;
          exit;
        end if;
      end loop;
    
      if not v_Is_Child then
        Fazo.Push(result, v_Allowed_Division_Ids(i));
      end if;
    end loop;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function User_Access_To_Hidden_Salary
  (
    i_Company_Id   number,
    i_User_Id      number,
    i_Job_Group_Id number
  ) return varchar2 is
    v_User_Setting          varchar2(1);
    v_Restrict_All_Salaries varchar2(1);
  begin
    v_User_Setting := Href_Util.Access_Hidden_Salary(i_Company_Id => i_Company_Id,
                                                     i_User_Id    => i_User_Id);
    if v_User_Setting = 'Y' then
      return 'Y';
    else
      v_Restrict_All_Salaries := Hrm_Util.Restrict_All_Salaries(i_Company_Id);
    
      if v_Restrict_All_Salaries = 'N' then
        if z_Hrm_Hidden_Salary_Job_Groups.Exist(i_Company_Id   => i_Company_Id,
                                                i_Job_Group_Id => i_Job_Group_Id) then
          if z_Href_Person_Hidden_Salary_Job_Groups.Exist(i_Company_Id   => i_Company_Id,
                                                          i_Person_Id    => i_User_Id,
                                                          i_Job_Group_Id => i_Job_Group_Id) then
            return 'Y';
          else
            return 'N';
          end if;
        else
          return 'Y';
        end if;
      else
        if z_Href_Person_Hidden_Salary_Job_Groups.Exist(i_Company_Id   => i_Company_Id,
                                                        i_Person_Id    => i_User_Id,
                                                        i_Job_Group_Id => i_Job_Group_Id) then
          return 'Y';
        else
          return 'N';
        end if;
      end if;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Robot_Access_To_Hidden_Salary
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_User_Id      number,
    i_Job_Group_Id number
  ) return varchar2 is
    v_Robot_Setting         varchar2(1);
    v_Restrict_All_Salaries varchar2(1) := Hrm_Util.Restrict_All_Salaries(i_Company_Id);
    v_User_Robot_Ids        Array_Number;
  begin
    select q.Robot_Id
      bulk collect
      into v_User_Robot_Ids
      from Mrf_Robot_Persons q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Person_Id = i_User_Id;
  
    for i in 1 .. v_User_Robot_Ids.Count
    loop
      v_Robot_Setting := Nvl(z_Hrm_Robots.Take(i_Company_Id => i_Company_Id, i_Filial_Id => i_Filial_Id, i_Robot_Id => v_User_Robot_Ids(i)).Access_Hidden_Salary,
                             'N');
    
      if v_Robot_Setting = 'Y' then
        return 'Y';
      else
        if v_Restrict_All_Salaries = 'N' then
          if z_Hrm_Hidden_Salary_Job_Groups.Exist(i_Company_Id   => i_Company_Id,
                                                  i_Job_Group_Id => i_Job_Group_Id) then
            if z_Hrm_Robot_Hidden_Salary_Job_Groups.Exist(i_Company_Id   => i_Company_Id,
                                                          i_Filial_Id    => i_Filial_Id,
                                                          i_Robot_Id     => v_User_Robot_Ids(i),
                                                          i_Job_Group_Id => i_Job_Group_Id) then
              return 'Y';
            else
              continue;
            end if;
          else
            return 'Y';
          end if;
        else
          if z_Hrm_Robot_Hidden_Salary_Job_Groups.Exist(i_Company_Id   => i_Company_Id,
                                                        i_Filial_Id    => i_Filial_Id,
                                                        i_Robot_Id     => v_User_Robot_Ids(i),
                                                        i_Job_Group_Id => i_Job_Group_Id) then
            return 'Y';
          else
            continue;
          end if;
        end if;
      end if;
    end loop;
  
    return 'N';
  end;

  ----------------------------------------------------------------------------------------------------
  Function Access_To_Hidden_Salary_Job
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Job_Id     number,
    i_User_Id    number
  ) return varchar2 is
    v_Job_Group_Id number;
    r_Setting      Hrm_Settings%rowtype;
  begin
    if i_User_Id = Md_Pref.User_Admin(i_Company_Id) --
       or Hrm_Util.Restrict_To_View_All_Salaries(i_Company_Id) = 'N' then
      return 'Y';
    end if;
  
    v_Job_Group_Id := z_Mhr_Jobs.Take(i_Company_Id => i_Company_Id, i_Filial_Id => i_Filial_Id, i_Job_Id => i_Job_Id).Job_Group_Id;
  
    if v_Job_Group_Id is null --
       or (Hrm_Util.Restrict_All_Salaries(i_Company_Id) = 'N' and
       not z_Hrm_Hidden_Salary_Job_Groups.Exist(i_Company_Id   => i_Company_Id,
                                                    i_Job_Group_Id => v_Job_Group_Id)) then
      return 'Y';
    end if;
  
    r_Setting := Hrm_Util.Load_Setting(i_Company_Id => i_Company_Id, --
                                       i_Filial_Id  => i_Filial_Id);
  
    if r_Setting.Position_Enable = 'N' then
      return User_Access_To_Hidden_Salary(i_Company_Id   => i_Company_Id,
                                          i_User_Id      => i_User_Id,
                                          i_Job_Group_Id => v_Job_Group_Id);
    else
      return Robot_Access_To_Hidden_Salary(i_Company_Id   => i_Company_Id,
                                           i_Filial_Id    => i_Filial_Id,
                                           i_User_Id      => i_User_Id,
                                           i_Job_Group_Id => v_Job_Group_Id);
    
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Has_Access_To_Hidden_Salary_Job
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Job_Id     number,
    i_User_Id    number
  ) return boolean is
  begin
    return Access_To_Hidden_Salary_Job(i_Company_Id => i_Company_Id,
                                       i_Filial_Id  => i_Filial_Id,
                                       i_Job_Id     => i_Job_Id,
                                       i_User_Id    => i_User_Id) = 'Y';
  end;

  ----------------------------------------------------------------------------------------------------
  Function Access_Edit_Div_Job_Of_Robot
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Robot_Id   number
  ) return varchar2 is
    v_Dummy varchar2(1);
  begin
    select 'N'
      into v_Dummy
      from Hpd_Page_Robots q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Robot_Id = i_Robot_Id
       and Rownum = 1;
  
    return v_Dummy;
  exception
    when No_Data_Found then
      return 'Y';
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Planned_Fte
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Robot_Id   number,
    i_Period     date := Trunc(sysdate)
  ) return number is
    v_Planned_Fte number;
  begin
    select q.Fte
      into v_Planned_Fte
      from Hrm_Robot_Transactions q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Robot_Id = i_Robot_Id
       and q.Fte_Kind = Hrm_Pref.c_Fte_Kind_Planed
       and q.Fte > 0
       and q.Trans_Date = (select max(t.Trans_Date)
                             from Hrm_Robot_Transactions t
                            where t.Company_Id = q.Company_Id
                              and t.Filial_Id = q.Filial_Id
                              and t.Robot_Id = q.Robot_Id
                              and t.Fte_Kind = Hrm_Pref.c_Fte_Kind_Planed
                              and t.Fte > 0
                              and t.Trans_Date <= i_Period)
       and Rownum = 1;
  
    return v_Planned_Fte;
  exception
    when No_Data_Found then
      return 1;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Restrict_To_View_All_Salaries(i_Company_Id number) return varchar2 is
  begin
    return Nvl(Md_Pref.Load(i_Company_Id => i_Company_Id,
                            i_Filial_Id  => Md_Pref.Filial_Head(i_Company_Id),
                            i_Code       => Hrm_Pref.c_Pref_Restrict_To_View_All_Salaries),
               'N');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Restrict_All_Salaries(i_Company_Id number) return varchar2 is
  begin
    return Nvl(Md_Pref.Load(i_Company_Id => i_Company_Id,
                            i_Filial_Id  => Md_Pref.Filial_Head(i_Company_Id),
                            i_Code       => Hrm_Pref.c_Pref_Restrict_All_Salaries),
               'N');
  end;

  ----------------------------------------------------------------------------------------------------   
  Procedure Access_To_Set_Closed_Date
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Robot_Id   number,
    i_Robot_Name varchar2
  ) is
    v_Dummy varchar2(1);
  begin
    select 'Y'
      into v_Dummy
      from Mrf_Robot_Persons q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Robot_Id = i_Robot_Id
       and Rownum = 1;
  
    Hrm_Error.Raise_030(i_Robot_Name);
  exception
    when No_Data_Found then
      null;
  end;

  ----------------------------------------------------------------------------------------------------   
  Function Robot_Id_By_Name
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Name       varchar2
  ) return number is
    v_Id number;
  begin
    select q.Robot_Id
      into v_Id
      from Mrf_Robots q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Name = i_Name;
  
    return v_Id;
  exception
    when No_Data_Found then
      Hrm_Error.Raise_033(i_Name);
  end;

  ----------------------------------------------------------------------------------------------------   
  Function Wage_Scale_Id_By_Name
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Name       varchar2
  ) return number is
    v_Id number;
  begin
    select q.Wage_Scale_Id
      into v_Id
      from Hrm_Wage_Scales q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Name = i_Name;
  
    return v_Id;
  exception
    when No_Data_Found then
      Hrm_Error.Raise_034(i_Name);
  end;

  ----------------------------------------------------------------------------------------------------
  -- bonus types
  ----------------------------------------------------------------------------------------------------
  Function t_Bonus_Type_Personal_Sales return varchar2 is
  begin
    return t('bonus_type: personal sales');
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function t_Bonus_Type_Department_Sales return varchar2 is
  begin
    return t('bonus_type: department sales');
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function t_Bonus_Type_Successful_Delivery return varchar2 is
  begin
    return t('bonus_type: successful delivery');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Bonus_Type(i_Bonus_Type varchar2) return varchar2 is
  begin
    return --
    case i_Bonus_Type --
    when Hrm_Pref.c_Bonus_Type_Personal_Sales then t_Bonus_Type_Personal_Sales --
    when Hrm_Pref.c_Bonus_Type_Department_Sales then t_Bonus_Type_Department_Sales --
    when Hrm_Pref.c_Bonus_Type_Successful_Delivery then t_Bonus_Type_Successful_Delivery --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Bonus_Types return Matrix_Varchar2 is
  begin
    -- todo: Owner: Sherzod; text: umcommit them
    return Matrix_Varchar2(Array_Varchar2(Hrm_Pref.c_Bonus_Type_Personal_Sales,
                                          Hrm_Pref.c_Bonus_Type_Department_Sales
                                          /*, Hrm_Pref.c_Bonus_Type_Successful_Delivery*/),
                           Array_Varchar2(t_Bonus_Type_Personal_Sales,
                                          t_Bonus_Type_Department_Sales
                                          /*, t_Bonus_Type_Successful_Delivery*/));
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Division_Kind_Department return varchar2 is
  begin
    return t('division_kind:department');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Division_Kind_Team return varchar2 is
  begin
    return t('division_kind:team');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Division_Kind(i_Is_Division varchar2) return varchar2 is
  begin
    return case i_Is_Division --
    when 'Y' then t_Division_Kind_Department --
    when 'N' then t_Division_Kind_Team --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  -- Position Employment Kind
  ----------------------------------------------------------------------------------------------------
  Function t_Position_Employment_Contractor return varchar2 is
  begin
    return t('position_employment:contractor');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Position_Employment_Staff return varchar2 is
  begin
    return t('position_employment:staff');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Position_Employment(i_Employment_Kind varchar2) return varchar2 is
  begin
    return --
    case i_Employment_Kind --
    when Hrm_Pref.c_Position_Employment_Contractor then t_Position_Employment_Contractor --
    when Hrm_Pref.c_Position_Employment_Staff then t_Position_Employment_Staff --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Position_Employments return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Hrm_Pref.c_Position_Employment_Staff,
                                          Hrm_Pref.c_Position_Employment_Contractor),
                           Array_Varchar2(t_Position_Employment_Staff,
                                          t_Position_Employment_Contractor));
  end;

  ----------------------------------------------------------------------------------------------------   
  -- Robot Division Access Type
  ----------------------------------------------------------------------------------------------------   
  Function t_Robot_Division_Access_Type_Manual return varchar2 is
  begin
    return t('division_access_type:manual');
  end;

  ----------------------------------------------------------------------------------------------------   
  Function t_Robot_Division_Access_Type_Structural return varchar2 is
  begin
    return t('division_access_type:structural');
  end;

  ----------------------------------------------------------------------------------------------------   
  Function t_Robot_Division_Access_Type(i_Access_Type varchar2) return varchar2 is
  begin
    return --
    case i_Access_Type --
    when Hrm_Pref.c_Access_Type_Manual then t_Robot_Division_Access_Type_Manual --
    when Hrm_Pref.c_Access_Type_Structural then t_Robot_Division_Access_Type_Structural --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Robot_Division_Access_Types return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Hrm_Pref.c_Access_Type_Manual,
                                          Hrm_Pref.c_Access_Type_Structural),
                           Array_Varchar2(t_Robot_Division_Access_Type_Manual,
                                          t_Robot_Division_Access_Type_Structural));
  end;

end Hrm_Util;
/
