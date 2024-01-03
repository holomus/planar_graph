create or replace package Hsc_Api is
  ----------------------------------------------------------------------------------------------------
  Procedure Setting_Save(i_Setting Hsc_Pref.Setting_Rt);
  ----------------------------------------------------------------------------------------------------
  Procedure Process_Save(i_Process Hsc_Processes%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Process_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Process_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Process_Action_Save(i_Action Hsc_Process_Actions%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Process_Action_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Action_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Driver_Save(i_Driver Hsc_Drivers%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Driver_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Driver_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Area_Save(i_Area Hsc_Areas%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Area_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Area_Id    number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Area_Add_Driver
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Area_Id    number,
    i_Driver_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Area_Remove_Driver
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Area_Id    number,
    i_Driver_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Object_Save(i_Object Hsc_Pref.Object_Rt);
  ----------------------------------------------------------------------------------------------------
  Procedure Object_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Object_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Object_Norm_Save(i_Norm Hsc_Pref.Object_Norm_Rt);
  ----------------------------------------------------------------------------------------------------
  Procedure Object_Norm_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Norm_Id    number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Job_Norm_Save(i_Norm Hsc_Job_Norms%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Job_Norm_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Norm_Id    number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Job_Round_Save(i_Round Hsc_Job_Rounds%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Job_Round_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Round_Id   number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Driver_Fact_Save(i_Fact Hsc_Driver_Facts%rowtype);
  ---------------------------------------------------------------------------------------------------- 
  Procedure Driver_Fact_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Fact_Id    number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Import_Settings_Save
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Starting_Row  number,
    i_Date_Column   number,
    i_Object_Column number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Server_Settings_Save(i_Settings Hsc_Server_Settings%rowtype);
end Hsc_Api;
/
create or replace package body Hsc_Api is
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
  Procedure Setting_Save(i_Setting Hsc_Pref.Setting_Rt) is
    v_Object_Group_Ids Array_Number := i_Setting.Object_Group_Ids;
  begin
    -- object groups
    for i in 1 .. v_Object_Group_Ids.Count
    loop
      z_Hsc_Object_Groups.Insert_Try(i_Company_Id        => i_Setting.Company_Id,
                                     i_Filial_Id         => i_Setting.Filial_Id,
                                     i_Division_Group_Id => v_Object_Group_Ids(i));
    end loop;
  
    delete Hsc_Object_Groups t
     where t.Company_Id = i_Setting.Company_Id
       and t.Filial_Id = i_Setting.Filial_Id
       and t.Division_Group_Id not member of v_Object_Group_Ids;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Process_Save(i_Process Hsc_Processes%rowtype) is
  begin
    z_Hsc_Processes.Save_Row(i_Process);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Process_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Process_Id number
  ) is
  begin
    z_Hsc_Processes.Delete_One(i_Company_Id => i_Company_Id,
                               i_Filial_Id  => i_Filial_Id,
                               i_Process_Id => i_Process_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Process_Action_Save(i_Action Hsc_Process_Actions%rowtype) is
    r_Action Hsc_Process_Actions%rowtype;
  begin
    if z_Hsc_Process_Actions.Exist_Lock(i_Company_Id => i_Action.Company_Id,
                                        i_Filial_Id  => i_Action.Filial_Id,
                                        i_Action_Id  => i_Action.Action_Id) then
      if r_Action.Process_Id != i_Action.Process_Id then
        b.Raise_Fatal('hsc_api.process_action_save: process_id cannot be changed, action_id=$1',
                      r_Action.Process_Id);
      end if;
    end if;
  
    z_Hsc_Process_Actions.Save_Row(i_Action);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Process_Action_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Action_Id  number
  ) is
  begin
    z_Hsc_Process_Actions.Delete_One(i_Company_Id => i_Company_Id,
                                     i_Filial_Id  => i_Filial_Id,
                                     i_Action_Id  => i_Action_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Driver_Save(i_Driver Hsc_Drivers%rowtype) is
    r_Driver Hsc_Drivers%rowtype;
  begin
    if z_Hsc_Drivers.Exist_Lock(i_Company_Id => i_Driver.Company_Id,
                                i_Filial_Id  => i_Driver.Filial_Id,
                                i_Driver_Id  => i_Driver.Driver_Id,
                                o_Row        => r_Driver) then
      if r_Driver.Pcode = Hsc_Pref.c_Pcode_Driver_Constant then
        b.Raise_Error(t('hsc_api.driver_save: cannot change system driver, driver_id=$1',
                        r_Driver.Driver_Id));
      end if;
    end if;
  
    z_Hsc_Drivers.Save_Row(i_Driver);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Driver_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Driver_Id  number
  ) is
    r_Driver Hsc_Drivers%rowtype;
  begin
    if z_Hsc_Drivers.Exist_Lock(i_Company_Id => i_Company_Id,
                                i_Filial_Id  => i_Filial_Id,
                                i_Driver_Id  => i_Driver_Id,
                                o_Row        => r_Driver) then
      if r_Driver.Pcode = Hsc_Pref.c_Pcode_Driver_Constant then
        b.Raise_Error(t('hsc_api.driver_delete: cannot delete system driver, driver_id=$1',
                        r_Driver.Driver_Id));
      end if;
    end if;
  
    z_Hsc_Drivers.Delete_One(i_Company_Id => i_Company_Id,
                             i_Filial_Id  => i_Filial_Id,
                             i_Driver_Id  => i_Driver_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Area_Save(i_Area Hsc_Areas%rowtype) is
    r_Area Hsc_Areas%rowtype;
  begin
    if not z_Hsc_Areas.Exist_Lock(i_Company_Id => i_Area.Company_Id,
                                  i_Filial_Id  => i_Area.Filial_Id,
                                  i_Area_Id    => i_Area.Area_Id,
                                  o_Row        => r_Area) then
      r_Area.Company_Id      := i_Area.Company_Id;
      r_Area.Filial_Id       := i_Area.Filial_Id;
      r_Area.Area_Id         := i_Area.Area_Id;
      r_Area.c_Drivers_Exist := 'N';
    end if;
  
    r_Area.Name  := i_Area.Name;
    r_Area.State := i_Area.State;
  
    z_Hsc_Areas.Save_Row(r_Area);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Area_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Area_Id    number
  ) is
  begin
    z_Hsc_Areas.Delete_One(i_Company_Id => i_Company_Id,
                           i_Filial_Id  => i_Filial_Id,
                           i_Area_Id    => i_Area_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Area_Add_Driver
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Area_Id    number,
    i_Driver_Id  number
  ) is
  begin
    z_Hsc_Area_Drivers.Insert_Try(i_Company_Id => i_Company_Id,
                                  i_Filial_Id  => i_Filial_Id,
                                  i_Area_Id    => i_Area_Id,
                                  i_Driver_Id  => i_Driver_Id);
  
    Hsc_Core.Make_Dirty_Area(i_Company_Id => i_Company_Id,
                             i_Filial_Id  => i_Filial_Id,
                             i_Area_Id    => i_Area_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Area_Remove_Driver
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Area_Id    number,
    i_Driver_Id  number
  ) is
  begin
    z_Hsc_Area_Drivers.Delete_One(i_Company_Id => i_Company_Id,
                                  i_Filial_Id  => i_Filial_Id,
                                  i_Area_Id    => i_Area_Id,
                                  i_Driver_Id  => i_Driver_Id);
  
    Hsc_Core.Make_Dirty_Area(i_Company_Id => i_Company_Id,
                             i_Filial_Id  => i_Filial_Id,
                             i_Area_Id    => i_Area_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Object_Save(i_Object Hsc_Pref.Object_Rt) is
    r_Object   Hsc_Objects%rowtype;
    v_Norm_Ids Array_Number := Array_Number();
    v_Norm     Hsc_Pref.Object_Norm_Rt;
    v_Exists   boolean := true;
  begin
    if not z_Hsc_Objects.Exist_Lock(i_Company_Id => i_Object.Company_Id,
                                    i_Filial_Id  => i_Object.Filial_Id,
                                    i_Object_Id  => i_Object.Object_Id,
                                    o_Row        => r_Object) then
      r_Object.Company_Id := i_Object.Company_Id;
      r_Object.Filial_Id  := i_Object.Filial_Id;
      r_Object.Object_Id  := i_Object.Object_Id;
    
      v_Exists := false;
    end if;
  
    r_Object.Note := i_Object.Note;
  
    z_Hsc_Objects.Save_Row(r_Object);
  
    -- object norms
    v_Norm_Ids := Array_Number();
    v_Norm_Ids.Extend(i_Object.Norms.Count);
  
    for i in 1 .. v_Norm_Ids.Count
    loop
      v_Norm := i_Object.Norms(i);
    
      Object_Norm_Save(v_Norm);
    end loop;
  
    if v_Exists then
      delete from Hsc_Object_Norms t
       where t.Company_Id = r_Object.Company_Id
         and t.Filial_Id = r_Object.Filial_Id
         and t.Object_Id = r_Object.Object_Id
         and t.Norm_Id not member of v_Norm_Ids;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Object_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Object_Id  number
  ) is
  begin
    z_Hsc_Objects.Delete_One(i_Company_Id => i_Company_Id,
                             i_Filial_Id  => i_Filial_Id,
                             i_Object_Id  => i_Object_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Object_Norm_Save(i_Norm Hsc_Pref.Object_Norm_Rt) is
    r_Norm    Hsc_Object_Norms%rowtype;
    v_Action  Hsc_Pref.Object_Norm_Action_Rt;
    v_Day_Nos Array_Number := Array_Number();
    v_Dummy   varchar2(1);
    v_Exists  boolean := true;
  begin
    if z_Hsc_Object_Norms.Exist_Lock(i_Company_Id => i_Norm.Company_Id,
                                     i_Filial_Id  => i_Norm.Filial_Id,
                                     i_Norm_Id    => i_Norm.Norm_Id,
                                     o_Row        => r_Norm) then
      if r_Norm.Object_Id != i_Norm.Object_Id then
        b.Raise_Fatal('hsc_api.object_norm_save: object_id cannot be changed, object_id=$1',
                      r_Norm.Object_Id);
      end if;
    else
      if not z_Hsc_Objects.Exist(i_Company_Id => i_Norm.Company_Id,
                                 i_Filial_Id  => i_Norm.Filial_Id,
                                 i_Object_Id  => i_Norm.Object_Id) then
        z_Hsc_Objects.Insert_One(i_Company_Id => i_Norm.Company_Id,
                                 i_Filial_Id  => i_Norm.Filial_Id,
                                 i_Object_Id  => i_Norm.Object_Id);
      end if;
    
      r_Norm.Company_Id := i_Norm.Company_Id;
      r_Norm.Filial_Id  := i_Norm.Filial_Id;
      r_Norm.Object_Id  := i_Norm.Object_Id;
      r_Norm.Norm_Id    := i_Norm.Norm_Id;
    
      v_Exists := false;
    end if;
  
    begin
      select 'x'
        into v_Dummy
        from Hsc_Object_Norms t
       where t.Company_Id = i_Norm.Company_Id
         and t.Filial_Id = i_Norm.Filial_Id
         and t.Norm_Id <> i_Norm.Norm_Id
         and t.Object_Id = i_Norm.Object_Id
         and t.Process_Id = i_Norm.Process_Id
         and t.Action_Id = i_Norm.Action_Id
         and t.Driver_Id = i_Norm.Driver_Id
         and t.Area_Id = i_Norm.Area_Id
         and t.Division_Id = i_Norm.Division_Id
         and t.Job_Id = i_Norm.Job_Id;
    
      b.Raise_Error(t('hsc_api:object_norm_save: unique constraint, $1',
                      Fazo.Gather(Array_Varchar2(z_Mhr_Divisions.Load      (i_Company_Id => i_Norm.Company_Id, i_Filial_Id => i_Norm.Filial_Id, i_Division_Id => i_Norm. Object_Id).Name,
                                                 z_Hsc_Processes.Load      (i_Company_Id => i_Norm.Company_Id, i_Filial_Id => i_Norm.Filial_Id, i_Process_Id => i_Norm. Process_Id).Name,
                                                 z_Hsc_Process_Actions.Load(i_Company_Id => i_Norm.Company_Id, i_Filial_Id => i_Norm.Filial_Id, i_Action_Id => i_Norm. Action_Id).Name,
                                                 z_Hsc_Drivers.Load        (i_Company_Id => i_Norm.Company_Id, i_Filial_Id => i_Norm.Filial_Id, i_Driver_Id => i_Norm. Driver_Id).Name,
                                                 z_Hsc_Areas.Load          (i_Company_Id => i_Norm.Company_Id, i_Filial_Id => i_Norm.Filial_Id, i_Area_Id => i_Norm. Area_Id).Name,
                                                 z_Mhr_Divisions.Load      (i_Company_Id => i_Norm.Company_Id, i_Filial_Id => i_Norm.Filial_Id, i_Division_Id => i_Norm. Division_Id).Name,
                                                 z_Mhr_Jobs.Load           (i_Company_Id => i_Norm.Company_Id, i_Filial_Id => i_Norm.Filial_Id, i_Job_Id => i_Norm. Job_Id).Name),
                                  ', ')));
    exception
      when No_Data_Found then
        null;
    end;
  
    r_Norm.Process_Id    := i_Norm.Process_Id;
    r_Norm.Action_Id     := i_Norm.Action_Id;
    r_Norm.Driver_Id     := i_Norm.Driver_Id;
    r_Norm.Area_Id       := i_Norm.Area_Id;
    r_Norm.Division_Id   := i_Norm.Division_Id;
    r_Norm.Job_Id        := i_Norm.Job_Id;
    r_Norm.Time_Value    := i_Norm.Time_Value;
    r_Norm.Action_Period := i_Norm.Action_Period;
  
    z_Hsc_Object_Norms.Save_Row(r_Norm);
  
    if r_Norm.Driver_Id =
       Hsc_Util.Driver_Constant_Id(i_Company_Id => r_Norm.Company_Id,
                                   i_Filial_Id  => r_Norm.Filial_Id) and i_Norm.Actions.Count = 0 then
      b.Raise_Fatal(t('hsc_api.objec_norm_save: at least one day frequency must be specified, norm_id=$1',
                      r_Norm.Norm_Id));
    end if;
  
    -- actions
    v_Day_Nos := Array_Number();
    v_Day_Nos.Extend(i_Norm.Actions.Count);
  
    for i in 1 .. v_Day_Nos.Count
    loop
      v_Action := i_Norm.Actions(i);
      v_Day_Nos(i) := v_Action.Day_No;
    
      z_Hsc_Object_Norm_Actions.Save_One(i_Company_Id => r_Norm.Company_Id,
                                         i_Filial_Id  => r_Norm.Filial_Id,
                                         i_Norm_Id    => r_Norm.Norm_Id,
                                         i_Day_No     => v_Action.Day_No,
                                         i_Frequency  => v_Action.Frequency);
    end loop;
  
    if v_Exists then
      delete from Hsc_Object_Norm_Actions t
       where t.Company_Id = r_Norm.Company_Id
         and t.Filial_Id = r_Norm.Filial_Id
         and t.Norm_Id = r_Norm.Norm_Id
         and t.Day_No not member of v_Day_Nos;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Object_Norm_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Norm_Id    number
  ) is
    r_Norm Hsc_Object_Norms%rowtype;
  begin
    r_Norm := z_Hsc_Object_Norms.Lock_Load(i_Company_Id => i_Company_Id,
                                           i_Filial_Id  => i_Filial_Id,
                                           i_Norm_Id    => i_Norm_Id);
  
    z_Hsc_Objects.Update_One(i_Company_Id => r_Norm.Company_Id,
                             i_Filial_Id  => r_Norm.Filial_Id,
                             i_Object_Id  => r_Norm.Object_Id);
  
    z_Hsc_Object_Norms.Delete_One(i_Company_Id => i_Company_Id,
                                  i_Filial_Id  => i_Filial_Id,
                                  i_Norm_Id    => i_Norm_Id);
  
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Job_Norm_Save(i_Norm Hsc_Job_Norms%rowtype) is
  begin
    z_Hsc_Job_Norms.Save_Row(i_Norm);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Job_Norm_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Norm_Id    number
  ) is
  begin
    z_Hsc_Job_Norms.Delete_One(i_Company_Id => i_Company_Id,
                               i_Filial_Id  => i_Filial_Id,
                               i_Norm_Id    => i_Norm_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Job_Round_Save(i_Round Hsc_Job_Rounds%rowtype) is
  begin
    z_Hsc_Job_Rounds.Save_Row(i_Round);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Job_Round_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Round_Id   number
  ) is
  begin
    z_Hsc_Job_Rounds.Delete_One(i_Company_Id => i_Company_Id,
                                i_Filial_Id  => i_Filial_Id,
                                i_Round_Id   => i_Round_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Driver_Fact_Save(i_Fact Hsc_Driver_Facts%rowtype) is
  begin
    Hsc_Core.Driver_Fact_Save(i_Fact);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Driver_Fact_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Fact_Id    number
  ) is
    r_Fact Hsc_Driver_Facts%rowtype;
  begin
    if z_Hsc_Driver_Facts.Exist_Lock(i_Company_Id => i_Company_Id,
                                     i_Filial_Id  => i_Filial_Id,
                                     i_Fact_Id    => i_Fact_Id,
                                     o_Row        => r_Fact) then
      null;
    end if;
  
    z_Hsc_Driver_Facts.Delete_One(i_Company_Id => i_Company_Id,
                                  i_Filial_Id  => i_Filial_Id,
                                  i_Fact_Id    => i_Fact_Id);
  
    if r_Fact.Company_Id is not null then
      Hsc_Core.Update_Priority(i_Company_Id   => r_Fact.Company_Id,
                               i_Filial_Id    => r_Fact.Filial_Id,
                               i_Object_Id    => r_Fact.Object_Id,
                               i_Area_Id      => r_Fact.Area_Id,
                               i_Driver_Id    => r_Fact.Driver_Id,
                               i_Fact_Date    => r_Fact.Fact_Date,
                               i_Fact_Type    => r_Fact.Fact_Type,
                               i_Is_Increment => false);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Import_Settings_Save
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Starting_Row  number,
    i_Date_Column   number,
    i_Object_Column number
  ) is
  begin
    Md_Api.Preference_Save(i_Company_Id => i_Company_Id,
                           i_Filial_Id  => i_Filial_Id,
                           i_Code       => Hsc_Pref.c_Import_Setting_Starting_Row,
                           i_Value      => i_Starting_Row);
  
    Md_Api.Preference_Save(i_Company_Id => i_Company_Id,
                           i_Filial_Id  => i_Filial_Id,
                           i_Code       => Hsc_Pref.c_Import_Setting_Date_Column,
                           i_Value      => i_Date_Column);
  
    Md_Api.Preference_Save(i_Company_Id => i_Company_Id,
                           i_Filial_Id  => i_Filial_Id,
                           i_Code       => Hsc_Pref.c_Import_Setting_Object_Column,
                           i_Value      => i_Object_Column);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Server_Settings_Save(i_Settings Hsc_Server_Settings%rowtype) is
  begin
    z_Hsc_Server_Settings.Save_Row(i_Settings);
  end;

end Hsc_Api;
/
