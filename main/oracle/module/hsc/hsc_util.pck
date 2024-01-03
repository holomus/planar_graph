create or replace package Hsc_Util is
  ----------------------------------------------------------------------------------------------------
  Procedure Setting_New
  (
    o_Setting          out Hsc_Pref.Setting_Rt,
    i_Company_Id       number,
    i_Filial_Id        number,
    i_Object_Group_Ids Array_Number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Object_New
  (
    o_Object     out Hsc_Pref.Object_Rt,
    i_Company_Id number,
    i_Filial_Id  number,
    i_Object_Id  number,
    i_Note       varchar2 := null
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Object_Add_Norm
  (
    p_Object in out nocopy Hsc_Pref.Object_Rt,
    i_Norm   Hsc_Pref.Object_Norm_Rt
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Object_Norm_New
  (
    o_Norm          out Hsc_Pref.Object_Norm_Rt,
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Object_Id     number,
    i_Norm_Id       number,
    i_Process_Id    number,
    i_Action_Id     number,
    i_Driver_Id     number,
    i_Area_Id       number,
    i_Division_Id   number,
    i_Job_Id        number,
    i_Time_Value    number,
    i_Action_Period varchar2 := null
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Object_Norm_Add_Action
  (
    p_Norm      in out nocopy Hsc_Pref.Object_Norm_Rt,
    i_Day_No    number,
    i_Frequency number
  );
  ---------------------------------------------------------------------------------------------------- 
  Function Driver_Constant_Id
  (
    i_Company_Id number,
    i_Filial_Id  number
  ) return number;
  ---------------------------------------------------------------------------------------------------- 
  Function Take_Process_Id_By_Name
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Name       varchar2
  ) return number;
  ---------------------------------------------------------------------------------------------------- 
  Function Take_Action_Id_By_Name
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Process_Id number,
    i_Name       varchar2
  ) return number;
  ---------------------------------------------------------------------------------------------------- 
  Function Take_Driver_Id_By_Name
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Name       varchar2
  ) return number;
  ---------------------------------------------------------------------------------------------------- 
  Function Take_Area_Id_By_Name
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Name       varchar2
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Take_Job_Norm
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Object_Id   number,
    i_Division_Id number,
    i_Job_Id      number,
    i_Date        date
  ) return Hsc_Job_Norms%rowtype;
  ----------------------------------------------------------------------------------------------------
  Function Take_Job_Round
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Object_Id   number,
    i_Division_Id number,
    i_Job_Id      number
  ) return Hsc_Job_Rounds%rowtype;
  ----------------------------------------------------------------------------------------------------
  Function Take_Driver_Fact
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Object_Id  number,
    i_Area_Id    number,
    i_Driver_Id  number,
    i_Fact_Type  varchar2,
    i_Fact_Date  date
  ) return Hsc_Driver_Facts%rowtype;
  ---------------------------------------------------------------------------------------------------- 
  Function Next_Object_Norm_Id
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Object_Id   number,
    i_Process_Id  number,
    i_Action_Id   number,
    i_Driver_Id   number,
    i_Area_Id     number,
    i_Division_Id number,
    i_Job_Id      number
  ) return number;
  ---------------------------------------------------------------------------------------------------- 
  Function Next_Job_Norm_Id
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Object_Id   number,
    i_Division_Id number,
    i_Job_Id      number,
    i_Month       date
  ) return number;
  ---------------------------------------------------------------------------------------------------- 
  Function Next_Job_Round_Id
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Object_Id   number,
    i_Division_Id number,
    i_Job_Id      number
  ) return number;
  ---------------------------------------------------------------------------------------------------- 
  Function Next_Fact_Id
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Object_Id  number,
    i_Area_Id    number,
    i_Driver_Id  number,
    i_Fact_Type  varchar2,
    i_Fact_Date  date
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Procedure Load_Import_Settings
  (
    o_Starting_Row  out number,
    o_Date_Column   out number,
    o_Object_Column out number,
    i_Company_Id    number,
    i_Filial_Id     number
  );
  ---------------------------------------------------------------------------------------------------- 
  Function t_Driver_Fact_Type(i_Fact_Type varchar2) return varchar2;
  Function Driver_Fact_Types return Matrix_Varchar2;
end Hsc_Util;
/
create or replace package body Hsc_Util is
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
    return b.Translate('HSC:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Setting_New
  (
    o_Setting          out Hsc_Pref.Setting_Rt,
    i_Company_Id       number,
    i_Filial_Id        number,
    i_Object_Group_Ids Array_Number
  ) is
  begin
    o_Setting.Company_Id       := i_Company_Id;
    o_Setting.Filial_Id        := i_Filial_Id;
    o_Setting.Object_Group_Ids := i_Object_Group_Ids;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Object_New
  (
    o_Object     out Hsc_Pref.Object_Rt,
    i_Company_Id number,
    i_Filial_Id  number,
    i_Object_Id  number,
    i_Note       varchar2 := null
  ) is
  begin
    o_Object.Company_Id := i_Company_Id;
    o_Object.Filial_Id  := i_Filial_Id;
    o_Object.Object_Id  := i_Object_Id;
    o_Object.Note       := i_Note;
  
    o_Object.Norms := Hsc_Pref.Object_Norm_Nt();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Object_Add_Norm
  (
    p_Object in out nocopy Hsc_Pref.Object_Rt,
    i_Norm   Hsc_Pref.Object_Norm_Rt
  ) is
  begin
    p_Object.Norms.Extend;
    p_Object.Norms(p_Object.Norms.Count) := i_Norm;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Object_Norm_New
  (
    o_Norm          out Hsc_Pref.Object_Norm_Rt,
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Object_Id     number,
    i_Norm_Id       number,
    i_Process_Id    number,
    i_Action_Id     number,
    i_Driver_Id     number,
    i_Area_Id       number,
    i_Division_Id   number,
    i_Job_Id        number,
    i_Time_Value    number,
    i_Action_Period varchar2 := null
  ) is
  begin
    o_Norm.Company_Id    := i_Company_Id;
    o_Norm.Filial_Id     := i_Filial_Id;
    o_Norm.Object_Id     := i_Object_Id;
    o_Norm.Norm_Id       := i_Norm_Id;
    o_Norm.Process_Id    := i_Process_Id;
    o_Norm.Action_Id     := i_Action_Id;
    o_Norm.Driver_Id     := i_Driver_Id;
    o_Norm.Area_Id       := i_Area_Id;
    o_Norm.Division_Id   := i_Division_Id;
    o_Norm.Job_Id        := i_Job_Id;
    o_Norm.Time_Value    := i_Time_Value;
    o_Norm.Action_Period := i_Action_Period;
    o_Norm.Actions       := Hsc_Pref.Object_Norm_Action_Nt();
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Object_Norm_Add_Action
  (
    p_Norm      in out nocopy Hsc_Pref.Object_Norm_Rt,
    i_Day_No    number,
    i_Frequency number
  ) is
    v_Action Hsc_Pref.Object_Norm_Action_Rt;
  begin
    v_Action.Day_No    := i_Day_No;
    v_Action.Frequency := i_Frequency;
  
    p_Norm.Actions.Extend;
    p_Norm.Actions(p_Norm.Actions.Count) := v_Action;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Driver_Constant_Id
  (
    i_Company_Id number,
    i_Filial_Id  number
  ) return number is
    result number;
  begin
    select t.Driver_Id
      into result
      from Hsc_Drivers t
     where t.Company_Id = i_Company_Id
       and t.Filial_Id = i_Filial_Id
       and t.Pcode = Hsc_Pref.c_Pcode_Driver_Constant;
  
    return result;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Take_Process_Id_By_Name
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Name       varchar2
  ) return number is
    result number;
  begin
    select q.Process_Id
      into result
      from Hsc_Processes q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and Lower(q.Name) = Lower(i_Name);
  
    return result;
  exception
    when No_Data_Found then
      return null;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Take_Action_Id_By_Name
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Process_Id number,
    i_Name       varchar2
  ) return number is
    result number;
  begin
    select q.Action_Id
      into result
      from Hsc_Process_Actions q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Process_Id = i_Process_Id
       and Lower(q.Name) = Lower(i_Name);
  
    return result;
  exception
    when No_Data_Found then
      return null;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Take_Driver_Id_By_Name
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Name       varchar2
  ) return number is
    result number;
  begin
    select q.Driver_Id
      into result
      from Hsc_Drivers q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and Lower(q.Name) = Lower(i_Name);
  
    return result;
  exception
    when No_Data_Found then
      return null;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Take_Area_Id_By_Name
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Name       varchar2
  ) return number is
    result number;
  begin
    select q.Area_Id
      into result
      from Hsc_Areas q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and Lower(q.Name) = Lower(i_Name);
  
    return result;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Take_Job_Norm
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Object_Id   number,
    i_Division_Id number,
    i_Job_Id      number,
    i_Date        date
  ) return Hsc_Job_Norms%rowtype is
    v_Month date := Trunc(i_Date, 'mon');
    result  Hsc_Job_Norms%rowtype;
  begin
    select q.*
      into result
      from Hsc_Job_Norms q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Object_Id = i_Object_Id
       and Decode(q.Division_Id, i_Division_Id, 1, 0) = 1
       and q.Job_Id = i_Job_Id
       and q.Month = (select max(p.Month)
                        from Hsc_Job_Norms p
                       where p.Company_Id = i_Company_Id
                         and p.Filial_Id = i_Filial_Id
                         and p.Object_Id = i_Object_Id
                         and Decode(p.Division_Id, i_Division_Id, 1, 0) = 1
                         and p.Job_Id = i_Job_Id
                         and p.Month <= v_Month);
  
    return result;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Take_Job_Round
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Object_Id   number,
    i_Division_Id number,
    i_Job_Id      number
  ) return Hsc_Job_Rounds%rowtype is
    result Hsc_Job_Rounds%rowtype;
  begin
    select q.*
      into result
      from Hsc_Job_Rounds q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Object_Id = i_Object_Id
       and Decode(q.Division_Id, i_Division_Id, 1, 0) = 1
       and q.Job_Id = i_Job_Id;
  
    return result;
  exception
    when No_Data_Found then
      return null;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Take_Driver_Fact
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Object_Id  number,
    i_Area_Id    number,
    i_Driver_Id  number,
    i_Fact_Type  varchar2,
    i_Fact_Date  date
  ) return Hsc_Driver_Facts%rowtype is
    r_Fact Hsc_Driver_Facts%rowtype;
  begin
    select t.*
      into r_Fact
      from Hsc_Driver_Facts t
     where t.Company_Id = i_Company_Id
       and t.Filial_Id = i_Filial_Id
       and t.Object_Id = i_Object_Id
       and t.Area_Id = i_Area_Id
       and t.Driver_Id = i_Driver_Id
       and t.Fact_Type = i_Fact_Type
       and t.Fact_Date = i_Fact_Date;
  
    return r_Fact;
  exception
    when No_Data_Found then
      return null;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Next_Object_Norm_Id
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Object_Id   number,
    i_Process_Id  number,
    i_Action_Id   number,
    i_Driver_Id   number,
    i_Area_Id     number,
    i_Division_Id number,
    i_Job_Id      number
  ) return number is
    result number;
  begin
    select t.Norm_Id
      into result
      from Hsc_Object_Norms t
     where t.Company_Id = i_Company_Id
       and t.Filial_Id = i_Filial_Id
       and t.Object_Id = i_Object_Id
       and t.Process_Id = i_Process_Id
       and t.Action_Id = i_Action_Id
       and t.Driver_Id = i_Driver_Id
       and t.Area_Id = i_Area_Id
       and Decode(t.Division_Id, i_Division_Id, 1, 0) = 1
       and t.Job_Id = i_Job_Id;
  
    return result;
  exception
    when No_Data_Found then
      return Hsc_Next.Object_Norm_Id;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Next_Job_Norm_Id
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Object_Id   number,
    i_Division_Id number,
    i_Job_Id      number,
    i_Month       date
  ) return number is
    result number;
  begin
    select t.Norm_Id
      into result
      from Hsc_Job_Norms t
     where t.Company_Id = i_Company_Id
       and t.Filial_Id = i_Filial_Id
       and t.Object_Id = i_Object_Id
       and Decode(t.Division_Id, i_Division_Id, 1, 0) = 1
       and t.Job_Id = i_Job_Id
       and t.Month = i_Month;
  
    return result;
  exception
    when No_Data_Found then
      return Hsc_Next.Job_Norm_Id;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Next_Job_Round_Id
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Object_Id   number,
    i_Division_Id number,
    i_Job_Id      number
  ) return number is
    result number;
  begin
    select t.Round_Id
      into result
      from Hsc_Job_Rounds t
     where t.Company_Id = i_Company_Id
       and t.Filial_Id = i_Filial_Id
       and t.Object_Id = i_Object_Id
       and Decode(t.Division_Id, i_Division_Id, 1, 0) = 1
       and t.Job_Id = i_Job_Id;
  
    return result;
  exception
    when No_Data_Found then
      return Hsc_Next.Job_Round_Id;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Next_Fact_Id
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Object_Id  number,
    i_Area_Id    number,
    i_Driver_Id  number,
    i_Fact_Type  varchar2,
    i_Fact_Date  date
  ) return number is
    r_Fact Hsc_Driver_Facts%rowtype;
  begin
    r_Fact := Take_Driver_Fact(i_Company_Id => i_Company_Id,
                               i_Filial_Id  => i_Filial_Id,
                               i_Object_Id  => i_Object_Id,
                               i_Area_Id    => i_Area_Id,
                               i_Driver_Id  => i_Driver_Id,
                               i_Fact_Type  => i_Fact_Type,
                               i_Fact_Date  => i_Fact_Date);
  
    if r_Fact.Fact_Id is null then
      return Hsc_Next.Driver_Fact_Id;
    end if;
  
    return r_Fact.Fact_Id;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Load_Import_Settings
  (
    o_Starting_Row  out number,
    o_Date_Column   out number,
    o_Object_Column out number,
    i_Company_Id    number,
    i_Filial_Id     number
  ) is
  begin
    o_Starting_Row := Nvl(Md_Pref.Load(i_Company_Id => i_Company_Id,
                                       i_Filial_Id  => i_Filial_Id,
                                       i_Code       => Hsc_Pref.c_Import_Setting_Starting_Row),
                          Hsc_Pref.c_Default_Starting_Row);
  
    o_Date_Column := Nvl(Md_Pref.Load(i_Company_Id => i_Company_Id,
                                      i_Filial_Id  => i_Filial_Id,
                                      i_Code       => Hsc_Pref.c_Import_Setting_Date_Column),
                         Hsc_Pref.c_Default_Date_Column);
  
    o_Object_Column := Nvl(Md_Pref.Load(i_Company_Id => i_Company_Id,
                                        i_Filial_Id  => i_Filial_Id,
                                        i_Code       => Hsc_Pref.c_Import_Setting_Object_Column),
                           Hsc_Pref.c_Default_Object_Column);
  end;

  ----------------------------------------------------------------------------------------------------
  -- driver fact type 
  ----------------------------------------------------------------------------------------------------
  Function t_Driver_Fact_Type_Actual return varchar2 is
  begin
    return t('driver_fact_type:actual');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Driver_Fact_Type_Weekly_Predict return varchar2 is
  begin
    return t('driver_fact_type:weekly_predict');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Driver_Fact_Type_Mothly_Predict return varchar2 is
  begin
    return t('driver_fact_type:mothly_predict');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Driver_Fact_Type_Quarterly_Predict return varchar2 is
  begin
    return t('driver_fact_type:quarterly_predict');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Driver_Fact_Type_Yearly_Predict return varchar2 is
  begin
    return t('driver_fact_type:yearly_predict');
  end;

  ----------------------------------------------------------------------------------------------------
  Function t_Driver_Fact_Type(i_Fact_Type varchar2) return varchar2 is
  begin
    return case i_Fact_Type --
    when Hsc_Pref.c_Fact_Type_Actual then t_Driver_Fact_Type_Actual --
    when Hsc_Pref.c_Fact_Type_Weekly_Predict then t_Driver_Fact_Type_Weekly_Predict --
    when Hsc_Pref.c_Fact_Type_Montly_Predict then t_Driver_Fact_Type_Mothly_Predict --
    when Hsc_Pref.c_Fact_Type_Quarterly_Predict then t_Driver_Fact_Type_Quarterly_Predict --
    when Hsc_Pref.c_Fact_Type_Yearly_Predict then t_Driver_Fact_Type_Yearly_Predict --
    end;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Driver_Fact_Types return Matrix_Varchar2 is
  begin
    return Matrix_Varchar2(Array_Varchar2(Hsc_Pref.c_Fact_Type_Actual,
                                          Hsc_Pref.c_Fact_Type_Weekly_Predict,
                                          Hsc_Pref.c_Fact_Type_Montly_Predict,
                                          Hsc_Pref.c_Fact_Type_Quarterly_Predict,
                                          Hsc_Pref.c_Fact_Type_Yearly_Predict),
                           Array_Varchar2(t_Driver_Fact_Type_Actual, --
                                          t_Driver_Fact_Type_Weekly_Predict,
                                          t_Driver_Fact_Type_Mothly_Predict,
                                          t_Driver_Fact_Type_Quarterly_Predict,
                                          t_Driver_Fact_Type_Yearly_Predict));
  end;

end Hsc_Util;
/
