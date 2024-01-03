create or replace package Hrm_Watcher is
  ----------------------------------------------------------------------------------------------------
  Procedure On_Division_Change(i_Division Mhr_Global.Division_Rt);
  ----------------------------------------------------------------------------------------------------
  Procedure On_Robot_Save(i_Robot Mrf_Robots%rowtype);
  ----------------------------------------------------------------------------------------------------  
  Procedure On_Manager_Change(i_Division_Manager Mrf_Division_Managers%rowtype);
end Hrm_Watcher;
/
create or replace package body Hrm_Watcher is
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
  Procedure On_Division_Change(i_Division Mhr_Global.Division_Rt) is
    r_Mhr_New              Mhr_Divisions%rowtype;
    r_Hrm_Old              Hrm_Divisions%rowtype;
    r_Manager              Mrf_Division_Managers%rowtype;
    v_Parent_Department_Id number;
    v_Hrm_Exists           boolean := true;
    v_Parent_Changed       boolean := false;
  begin
    if not z_Hrm_Divisions.Exist_Lock(i_Company_Id  => i_Division.Company_Id,
                                      i_Filial_Id   => i_Division.Filial_Id,
                                      i_Division_Id => i_Division.Division_Id,
                                      o_Row         => r_Hrm_Old) then
      r_Hrm_Old.Company_Id     := i_Division.Company_Id;
      r_Hrm_Old.Filial_Id      := i_Division.Filial_Id;
      r_Hrm_Old.Division_Id    := i_Division.Division_Id;
      r_Hrm_Old.Is_Department  := 'Y';
      r_Hrm_Old.Manager_Status := Hrm_Pref.c_Division_Manager_Status_Manual;
    
      v_Hrm_Exists := false;
    end if;
  
    v_Parent_Department_Id := r_Hrm_Old.Parent_Department_Id;
  
    r_Mhr_New := z_Mhr_Divisions.Lock_Load(i_Company_Id  => i_Division.Company_Id,
                                           i_Filial_Id   => i_Division.Filial_Id,
                                           i_Division_Id => i_Division.Division_Id);
  
    if not Fazo.Equal(i_Division.Old_Parent_Id, r_Mhr_New.Parent_Id) then
      v_Parent_Department_Id := Hrm_Util.Closest_Parent_Department_Id(i_Company_Id  => i_Division.Company_Id,
                                                                      i_Filial_Id   => i_Division.Filial_Id,
                                                                      i_Division_Id => i_Division.Division_Id);
    
      if not Fazo.Equal(r_Hrm_Old.Parent_Department_Id, v_Parent_Department_Id) then
        Hrm_Core.Assert_Division_Parent_Changeable(i_Company_Id    => i_Division.Company_Id,
                                                   i_Filial_Id     => i_Division.Filial_Id,
                                                   i_Division_Id   => i_Division.Division_Id,
                                                   i_Is_Department => r_Hrm_Old.Is_Department);
      
        v_Parent_Changed := true;
      end if;
    end if;
  
    if v_Parent_Department_Id is null and r_Hrm_Old.Is_Department = 'N' then
      Hrm_Error.Raise_027(Hrm_Util.t_Division_Kind_Team);
    end if;
  
    z_Hrm_Divisions.Save_One(i_Company_Id           => i_Division.Company_Id,
                             i_Filial_Id            => i_Division.Filial_Id,
                             i_Division_Id          => i_Division.Division_Id,
                             i_Parent_Department_Id => v_Parent_Department_Id,
                             i_Is_Department        => r_Hrm_Old.Is_Department,
                             i_Manager_Status       => r_Hrm_Old.Manager_Status);
  
    if v_Hrm_Exists and v_Parent_Changed then
      Hrm_Core.Update_Parent_Departments(i_Company_Id    => i_Division.Company_Id,
                                         i_Filial_Id     => i_Division.Filial_Id,
                                         i_Division_Id   => i_Division.Division_Id,
                                         i_Old_Parent_Id => case
                                                              when r_Hrm_Old.Is_Department = 'Y' then
                                                               r_Hrm_Old.Parent_Department_Id
                                                              else
                                                               i_Division.Division_Id
                                                            end,
                                         i_New_Parent_Id => case
                                                              when r_Hrm_Old.Is_Department = 'Y' then
                                                               i_Division.Division_Id
                                                              else
                                                               v_Parent_Department_Id
                                                            end);
      if r_Hrm_Old.Manager_Status = Hrm_Pref.c_Division_Manager_Status_Auto then
        r_Manager.Company_Id  := i_Division.Company_Id;
        r_Manager.Filial_Id   := i_Division.Filial_Id;
        r_Manager.Division_Id := i_Division.Division_Id;
      
        r_Manager.Manager_Id := z_Mrf_Division_Managers.Take(i_Company_Id => i_Division.Company_Id, --
                                i_Filial_Id => i_Division.Filial_Id, --
                                i_Division_Id => r_Mhr_New.Parent_Id).Manager_Id;
      
        On_Manager_Change(r_Manager);
      end if;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure On_Robot_Save(i_Robot Mrf_Robots%rowtype) is
    r_Robot Mrf_Robots%rowtype;
  begin
    if z_Hrm_Robots.Exist_Lock(i_Company_Id => i_Robot.Company_Id,
                               i_Filial_Id  => i_Robot.Filial_Id,
                               i_Robot_Id   => i_Robot.Robot_Id) then
      r_Robot := z_Mrf_Robots.Lock_Load(i_Company_Id => i_Robot.Company_Id,
                                        i_Filial_Id  => i_Robot.Filial_Id,
                                        i_Robot_Id   => i_Robot.Robot_Id);
    
      if Md_Env.Project_Code <> Verifix.Project_Code and
         Hrm_Util.Access_Edit_Div_Job_Of_Robot(i_Company_Id => i_Robot.Company_Id,
                                               i_Filial_Id  => i_Robot.Filial_Id,
                                               i_Robot_Id   => i_Robot.Robot_Id) = 'N' then
        if not Fazo.Equal(r_Robot.Division_Id, i_Robot.Division_Id) then
          b.Raise_Error(t('hrm_watcher.on_robot_save: cannot change division, robot_id=$1, old_division_id=$2, new_division_id=$3',
                          i_Robot.Robot_Id,
                          i_Robot.Division_Id,
                          r_Robot.Division_Id));
        end if;
      
        if not Fazo.Equal(r_Robot.Job_Id, i_Robot.Job_Id) then
          b.Raise_Error(t('hrm_watcher.on_robot_save: cannot change job, robot_id=$1, old_job_id=$2, new_job_id=$3',
                          i_Robot.Robot_Id,
                          i_Robot.Job_Id,
                          r_Robot.Job_Id));
        end if;
      end if;
    
      z_Hrm_Robots.Update_One(i_Company_Id => i_Robot.Company_Id,
                              i_Filial_Id  => i_Robot.Filial_Id,
                              i_Robot_Id   => i_Robot.Robot_Id);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------       
  Procedure On_Manager_Change(i_Division_Manager Mrf_Division_Managers%rowtype) is
  begin
    delete Hrm_Robot_Divisions p
     where p.Company_Id = i_Division_Manager.Company_Id
       and p.Filial_Id = i_Division_Manager.Filial_Id
       and p.Division_Id = i_Division_Manager.Division_Id
       and p.Access_Type = Hrm_Pref.c_Access_Type_Structural;
  
    if z_Mrf_Division_Managers.Exist(i_Company_Id  => i_Division_Manager.Company_Id,
                                     i_Filial_Id   => i_Division_Manager.Filial_Id,
                                     i_Division_Id => i_Division_Manager.Division_Id) and
       z_Hrm_Robots.Exist(i_Company_Id => i_Division_Manager.Company_Id,
                          i_Filial_Id  => i_Division_Manager.Filial_Id,
                          i_Robot_Id   => i_Division_Manager.Manager_Id) then
      z_Hrm_Robot_Divisions.Save_One(i_Company_Id  => i_Division_Manager.Company_Id,
                                     i_Filial_Id   => i_Division_Manager.Filial_Id,
                                     i_Robot_Id    => i_Division_Manager.Manager_Id,
                                     i_Division_Id => i_Division_Manager.Division_Id,
                                     i_Access_Type => Hrm_Pref.c_Access_Type_Structural);
    
      Hrm_Api.Update_Child_Manager(i_Company_Id     => i_Division_Manager.Company_Id,
                                   i_Filial_Id      => i_Division_Manager.Filial_Id,
                                   i_Division_Id    => i_Division_Manager.Division_Id,
                                   i_New_Manager_Id => i_Division_Manager.Manager_Id);
    end if;
  end;

end Hrm_Watcher;
/
