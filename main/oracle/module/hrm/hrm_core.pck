create or replace package Hrm_Core is
  ----------------------------------------------------------------------------------------------------
  Procedure Update_Parent_Departments
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Division_Id   number,
    i_Old_Parent_Id number,
    i_New_Parent_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Department_Status_Changeable
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Division_Id   number,
    i_Is_Department varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Division_Parent_Changeable
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Division_Id   number,
    i_Is_Department varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Advanced_Org_Structure_Changeable
  (
    i_Company_Id number,
    i_Filial_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Org_Unit_Department
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Division_Id number,
    i_Org_Unit_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Insert_Robot_Roles
  (
    i_Company_Id number,
    i_Filial_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Insert_Division_Manager_Infos
  (
    i_Company_Id number,
    i_Filial_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Open_Unopened_Robots
  (
    i_Company_Id number,
    i_Filial_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Function Exists_Robot_With_Multiple_Staffs
  (
    i_Company_Id number,
    i_Filial_Id  number,
    o_Robot_Id   out number
  ) return boolean;
  ----------------------------------------------------------------------------------------------------
  Function Exists_Robot_With_Booked_Trans
  (
    i_Company_Id number,
    i_Filial_Id  number,
    o_Robot_Id   out number
  ) return boolean;
  ----------------------------------------------------------------------------------------------------
  Procedure Staff_Refresh_Cache
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Robot_Id   number
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Robot_Person_Refresh_Cache
  (
    i_Company_Id       number,
    i_Filial_Id        number,
    i_Robot_Id         number,
    i_Position_Enabled varchar2
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Robot_Person_Refresh_Cache(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------  
  Procedure Fix_Robot_Divisions
  (
    i_Company_Id           number,
    i_Filial_Id            number,
    i_Robot_Id             number,
    i_Allowed_Division_Ids Array_Number
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Sync_Division_Managers
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Sync_Division_Managers(i_Company_Id number);
  ----------------------------------------------------------------------------------------------------
  Procedure Revise_Robot_Dates
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Robot_Id   number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Dirty_Robots_Revise
  (
    i_Company_Id number,
    i_Filial_Id  number
  );
  ----------------------------------------------------------------------------------------------------
  Function Robot_Transaction_Insert
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Robot_Id   number,
    i_Trans_Date date,
    i_Fte_Kind   varchar2,
    i_Fte        number,
    i_Tag        varchar2 := null
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Procedure Robot_Transaction_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Trans_Id   number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Robot_Plans_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Robot_Id   number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Robot_Open
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Robot_Id    number,
    i_Open_Date   date,
    i_Planned_Fte number := 1
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Robot_Close
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Robot_Id   number,
    i_Close_Date date
  );
  ----------------------------------------------------------------------------------------------------
  Function Robot_Occupy
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Robot_Id    number,
    i_Occupy_Date date,
    i_Fte         number,
    i_Is_Booked   boolean := false,
    i_Tag         varchar2 := null
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Function Robot_Unoccupy
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Robot_Id    number,
    i_Occupy_Date date,
    i_Fte         number,
    i_Is_Booked   boolean := false,
    i_Tag         varchar2 := null
  ) return number;
  ----------------------------------------------------------------------------------------------------
  Procedure Wage_Scale_Register_Save(i_Wage_Scale_Reg Hrm_Pref.Wage_Scale_Register_Rt);
  ----------------------------------------------------------------------------------------------------
  Procedure Last_Changed_Date_Refresh
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Wage_Scale_Id number
  );
end Hrm_Core;
/
create or replace package body Hrm_Core is
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
    return b.Translate('HRM:' || i_Message, Array_Varchar2(i_P1, i_P2, i_P3, i_P4, i_P5, i_P6));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Update_Parent_Departments
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Division_Id   number,
    i_Old_Parent_Id number,
    i_New_Parent_Id number
  ) is
  begin
    update Hrm_Divisions q
       set q.Parent_Department_Id = i_New_Parent_Id
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Parent_Department_Id = i_Old_Parent_Id
       and exists (select 1
              from Mhr_Parent_Divisions Pd
             where Pd.Company_Id = i_Company_Id
               and Pd.Filial_Id = i_Filial_Id
               and Pd.Parent_Id = i_Division_Id
               and Pd.Division_Id = q.Division_Id);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Division_Used_In_Robots
  (
    o_Robot_Id    out number,
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Division_Id number
  ) return boolean is
    v_Org_Unit_Ids Array_Number;
  begin
    select Qr.Division_Id
      bulk collect
      into v_Org_Unit_Ids
      from (select Dv.*
              from Mhr_Divisions Dv
              join Hrm_Divisions q
                on q.Company_Id = Dv.Company_Id
               and q.Filial_Id = Dv.Filial_Id
               and q.Division_Id = Dv.Division_Id
             where Dv.Company_Id = i_Company_Id
               and Dv.Filial_Id = i_Filial_Id
               and Dv.Division_Id in (select Pd.Division_Id
                                        from Mhr_Parent_Divisions Pd
                                       where Pd.Company_Id = i_Company_Id
                                         and Pd.Filial_Id = i_Filial_Id
                                         and Pd.Parent_Id = i_Division_Id)
               and q.Is_Department = 'N') Qr
     start with Qr.Parent_Id = i_Division_Id
    connect by Qr.Parent_Id = prior Qr.Division_Id;
  
    Fazo.Push(v_Org_Unit_Ids, i_Division_Id);
  
    select Rb.Robot_Id
      into o_Robot_Id
      from Hrm_Robots Rb
     where Rb.Company_Id = i_Company_Id
       and Rb.Filial_Id = i_Filial_Id
       and Rb.Org_Unit_Id member of v_Org_Unit_Ids
       and Rownum = 1;
  
    return true;
  exception
    when No_Data_Found then
      return false;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Department_Status_Changeable
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Division_Id   number,
    i_Is_Department varchar2
  ) is
    v_Robot_Id      number;
    v_Division_Kind varchar2(100 char) := case
                                            when i_Is_Department = 'Y' then
                                             Hrm_Util.t_Division_Kind_Department
                                            else
                                             Hrm_Util.t_Division_Kind_Team
                                          end;
    r_Settings      Hrm_Settings%rowtype;
    r_Division      Mhr_Divisions%rowtype;
    r_Robot         Mrf_Robots%rowtype;
  begin
    if Division_Used_In_Robots(o_Robot_Id    => v_Robot_Id,
                               i_Company_Id  => i_Company_Id,
                               i_Filial_Id   => i_Filial_Id,
                               i_Division_Id => i_Division_Id) then
      r_Settings := Hrm_Util.Load_Setting(i_Company_Id => i_Company_Id, i_Filial_Id => i_Filial_Id);
    
      r_Division := z_Mhr_Divisions.Load(i_Company_Id  => i_Company_Id,
                                         i_Filial_Id   => i_Filial_Id,
                                         i_Division_Id => i_Division_Id);
    
      r_Robot := z_Mrf_Robots.Load(i_Company_Id => i_Company_Id,
                                   i_Filial_Id  => i_Filial_Id,
                                   i_Robot_Id   => v_Robot_Id);
    
      if r_Settings.Position_Enable = 'Y' then
        Hrm_Error.Raise_022(i_Division_Name => r_Division.Name,
                            i_Division_Kind => v_Division_Kind,
                            i_Robot_Name    => r_Robot.Name);
      else
        Hrm_Error.Raise_021(i_Division_Name => r_Division.Name,
                            i_Division_Kind => v_Division_Kind,
                            i_Staff_Name    => z_Mr_Natural_Persons.Take(i_Company_Id => i_Company_Id, --
                                               i_Person_Id => r_Robot.Person_Id).Name);
      end if;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Division_Parent_Changeable
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Division_Id   number,
    i_Is_Department varchar2
  ) is
    v_Robot_Id number;
    r_Settings Hrm_Settings%rowtype;
    r_Division Mhr_Divisions%rowtype;
    r_Robot    Mrf_Robots%rowtype;
  begin
    if i_Is_Department = 'N' and
       Division_Used_In_Robots(o_Robot_Id    => v_Robot_Id,
                               i_Company_Id  => i_Company_Id,
                               i_Filial_Id   => i_Filial_Id,
                               i_Division_Id => i_Division_Id) then
      r_Settings := Hrm_Util.Load_Setting(i_Company_Id => i_Company_Id, i_Filial_Id => i_Filial_Id);
    
      r_Division := z_Mhr_Divisions.Load(i_Company_Id  => i_Company_Id,
                                         i_Filial_Id   => i_Filial_Id,
                                         i_Division_Id => i_Division_Id);
    
      r_Robot := z_Mrf_Robots.Load(i_Company_Id => i_Company_Id,
                                   i_Filial_Id  => i_Filial_Id,
                                   i_Robot_Id   => v_Robot_Id);
    
      if r_Settings.Position_Enable = 'Y' then
        Hrm_Error.Raise_024(i_Division_Name => r_Division.Name, --
                            i_Robot_Name    => r_Robot.Name);
      else
        Hrm_Error.Raise_023(i_Division_Name => r_Division.Name,
                            i_Staff_Name    => z_Mr_Natural_Persons.Take(i_Company_Id => i_Company_Id, --
                                               i_Person_Id => r_Robot.Person_Id).Name);
      end if;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Advanced_Org_Structure_Changeable
  (
    i_Company_Id number,
    i_Filial_Id  number
  ) is
    r_Division Mhr_Divisions%rowtype;
  begin
    select q.Division_Id
      into r_Division.Division_Id
      from Hrm_Divisions q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Is_Department = 'N'
       and Rownum = 1;
  
    r_Division := z_Mhr_Divisions.Load(i_Company_Id  => i_Company_Id,
                                       i_Filial_Id   => i_Filial_Id,
                                       i_Division_Id => r_Division.Division_Id);
  
    Hrm_Error.Raise_025(r_Division.Name);
  exception
    when No_Data_Found then
      null;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Assert_Org_Unit_Department
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Division_Id number,
    i_Org_Unit_Id number
  ) is
    r_Division Hrm_Divisions%rowtype;
    r_Org_Unit Hrm_Divisions%rowtype;
  begin
    r_Org_Unit := z_Hrm_Divisions.Take(i_Company_Id  => i_Company_Id,
                                       i_Filial_Id   => i_Filial_Id,
                                       i_Division_Id => i_Org_Unit_Id);
  
    r_Division := z_Hrm_Divisions.Take(i_Company_Id  => i_Company_Id,
                                       i_Filial_Id   => i_Filial_Id,
                                       i_Division_Id => i_Division_Id);
  
    if r_Division.Is_Department = 'N' then
      Hrm_Error.Raise_028(i_Division_Name => z_Mhr_Divisions.Take(i_Company_Id => i_Company_Id, --
                                             i_Filial_Id => i_Filial_Id, --
                                             i_Division_Id => i_Division_Id).Name);
    end if;
  
    if not Fazo.Equal(r_Org_Unit.Parent_Department_Id, i_Division_Id) then
      Hrm_Error.Raise_026(i_Division_Name => z_Mhr_Divisions.Take(i_Company_Id => i_Company_Id, --
                                             i_Filial_Id => i_Filial_Id, --
                                             i_Division_Id => i_Division_Id).Name,
                          i_Org_Unit_Name => z_Mhr_Divisions.Take(i_Company_Id => i_Company_Id, --
                                             i_Filial_Id => i_Filial_Id, --
                                             i_Division_Id => i_Org_Unit_Id).Name);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Insert_Robot_Roles
  (
    i_Company_Id number,
    i_Filial_Id  number
  ) is
    v_Staff_Role_Id number := Md_Util.Role_Id(i_Company_Id => i_Company_Id,
                                              i_Pcode      => Href_Pref.c_Pcode_Role_Staff);
  
  begin
    -- insert user roles when position enabled
    for r in (select Rb.*,
                     Nvl((select 'Y'
                           from Mrf_Robot_Persons Rp
                          where Rp.Company_Id = Rb.Company_Id
                            and Rp.Filial_Id = Rb.Filial_Id
                            and Rp.Robot_Id = Rb.Robot_Id
                            and Rownum = 1),
                         'N') Has_Person
                from Hrm_Robots Rb
               where Rb.Company_Id = i_Company_Id
                 and Rb.Filial_Id = i_Filial_Id)
    loop
      if r.Has_Person = 'N' then
        Mrf_Api.Robot_Add_Role(i_Company_Id => i_Company_Id,
                               i_Robot_Id   => r.Robot_Id,
                               i_Filial_Id  => i_Filial_Id,
                               i_Role_Id    => v_Staff_Role_Id);
      else
        for Rl in (select *
                     from Mrf_Robot_Persons Rp
                     join Md_User_Roles Ur
                       on Ur.Company_Id = i_Company_Id
                      and Ur.Filial_Id = i_Filial_Id
                      and Ur.User_Id = Rp.Person_Id
                    where Rp.Company_Id = i_Company_Id
                      and Rp.Filial_Id = i_Filial_Id
                      and Rp.Robot_Id = r.Robot_Id
                      and not exists (select 1
                             from Mrf_Robot_Roles p
                            where p.Company_Id = Rp.Company_Id
                              and p.Filial_Id = Rp.Filial_Id
                              and p.Robot_Id = Rp.Robot_Id
                              and p.Role_Id = Ur.Role_Id))
        loop
          Mrf_Api.Robot_Add_Role(i_Company_Id => i_Company_Id,
                                 i_Robot_Id   => r.Robot_Id,
                                 i_Filial_Id  => i_Filial_Id,
                                 i_Role_Id    => Rl.Role_Id);
        end loop;
      end if;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Insert_Division_Manager_Infos
  (
    i_Company_Id number,
    i_Filial_Id  number
  ) is
  begin
    -- clear data before position was enabled
    delete Hrm_Division_Managers p
     where p.Company_Id = i_Company_Id
       and p.Filial_Id = i_Filial_Id;
  
    -- insert data when position enabled
    for r in (select p.Division_Id, p.Manager_Id, q.Person_Id
                from Mrf_Division_Managers p
                join Mrf_Robots q
                  on q.Company_Id = p.Company_Id
                 and q.Filial_Id = p.Filial_Id
                 and q.Robot_Id = p.Manager_Id
               where p.Company_Id = i_Company_Id
                 and p.Filial_Id = i_Filial_Id
                 and exists (select *
                        from Mhr_Employees t
                       where t.Company_Id = q.Company_Id
                         and t.Filial_Id = q.Filial_Id
                         and t.Employee_Id = q.Person_Id))
    loop
      z_Hrm_Division_Managers.Insert_One(i_Company_Id  => i_Company_Id,
                                         i_Filial_Id   => i_Filial_Id,
                                         i_Division_Id => r.Division_Id,
                                         i_Employee_Id => r.Person_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Open_Unopened_Robots
  (
    i_Company_Id number,
    i_Filial_Id  number
  ) is
  begin
    for r in (select *
                from Hrm_Robots p
               where p.Company_Id = i_Company_Id
                 and p.Filial_Id = i_Filial_Id
                 and not exists (select *
                        from Hrm_Robot_Transactions q
                       where q.Company_Id = p.Company_Id
                         and q.Filial_Id = p.Filial_Id
                         and q.Robot_Id = p.Robot_Id))
    loop
      Robot_Open(i_Company_Id => r.Company_Id,
                 i_Filial_Id  => r.Filial_Id,
                 i_Robot_Id   => r.Robot_Id,
                 i_Open_Date  => r.Opened_Date);
    
      if r.Closed_Date is not null then
        Robot_Close(i_Company_Id => r.Company_Id,
                    i_Filial_Id  => r.Filial_Id,
                    i_Robot_Id   => r.Robot_Id,
                    i_Close_Date => r.Closed_Date);
      end if;
    end loop;
  
    Dirty_Robots_Revise(i_Company_Id => i_Company_Id, i_Filial_Id => i_Filial_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Exists_Robot_With_Multiple_Staffs
  (
    i_Company_Id number,
    i_Filial_Id  number,
    o_Robot_Id   out number
  ) return boolean is
  begin
    select Qr.Robot_Id
      into o_Robot_Id
      from (select p.Robot_Id
              from Hpd_Page_Robots p
             where p.Company_Id = i_Company_Id
               and p.Filial_Id = i_Filial_Id
             group by p.Robot_Id
            having count(*) > 1) Qr
     where Rownum = 1;
  
    return true;
  exception
    when No_Data_Found then
      return false;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Exists_Robot_With_Booked_Trans
  (
    i_Company_Id number,
    i_Filial_Id  number,
    o_Robot_Id   out number
  ) return boolean is
  begin
    select q.Robot_Id
      into o_Robot_Id
      from Hrm_Robot_Transactions q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Fte_Kind = Hrm_Pref.c_Fte_Kind_Booked
       and Rownum = 1;
  
    return true;
  exception
    when No_Data_Found then
      return false;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Staff_Refresh_Cache
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Robot_Id   number
  ) is
    r_Settings Hrm_Settings%rowtype;
  begin
    r_Settings := Hrm_Util.Load_Setting(i_Company_Id => i_Company_Id, i_Filial_Id => i_Filial_Id);
  
    if r_Settings.Position_Enable = 'N' then
      return;
    end if;
  
    for r in (select Ac.Staff_Id
                from Mrf_Robot_Persons Rp
                join Hpd_Agreements_Cache Ac
                  on Ac.Company_Id = Rp.Company_Id
                 and Ac.Filial_Id = Rp.Filial_Id
                 and Ac.Robot_Id = Rp.Robot_Id
                 and Trunc(sysdate) between Ac.Begin_Date and Ac.End_Date
               where Rp.Company_Id = i_Company_Id
                 and Rp.Filial_Id = i_Filial_Id
                 and Rp.Robot_Id = i_Robot_Id)
    loop
      Hpd_Core.Staff_Refresh_Cache(i_Company_Id => i_Company_Id,
                                   i_Filial_Id  => i_Filial_Id,
                                   i_Staff_Id   => r.Staff_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Robot_Person_Refresh_Cache
  (
    i_Company_Id       number,
    i_Filial_Id        number,
    i_Robot_Id         number,
    i_Position_Enabled varchar2
  ) is
    v_Person_Ids Array_Number;
    v_Person_Id  number;
    v_Date       date := Trunc(sysdate);
  begin
    select q.Person_Id
      bulk collect
      into v_Person_Ids
      from (select (select s.Employee_Id
                      from Href_Staffs s
                     where s.Company_Id = i_Company_Id
                       and s.Filial_Id = i_Filial_Id
                       and s.Staff_Id = r.Staff_Id) as Person_Id
              from Hrm_Robot_Transactions t
              join Hpd_Robot_Trans_Staffs r
                on t.Company_Id = r.Company_Id
               and t.Filial_Id = r.Filial_Id
               and t.Trans_Id = r.Robot_Trans_Id
             where t.Company_Id = i_Company_Id
               and t.Filial_Id = i_Filial_Id
               and t.Robot_Id = i_Robot_Id
               and t.Trans_Date <= v_Date
               and t.Fte_Kind = Hrm_Pref.c_Fte_Kind_Occupied
             group by r.Staff_Id
            having sum(t.Fte) > 0) q
     group by q.Person_Id;
  
    -- clear unnecessary persons
    for r in (select *
                from Mrf_Robot_Persons Rp
               where Rp.Company_Id = i_Company_Id
                 and Rp.Filial_Id = i_Filial_Id
                 and Rp.Robot_Id = i_Robot_Id
                 and Rp.Person_Id not member of v_Person_Ids)
    loop
      z_Mrf_Robot_Persons.Delete_One(i_Company_Id => i_Company_Id,
                                     i_Filial_Id  => i_Filial_Id,
                                     i_Robot_Id   => i_Robot_Id,
                                     i_Person_Id  => r.Person_Id);
    
      if i_Position_Enabled = 'Y' then
        Mrf_Api.Make_Dirty_Robot_Persons(i_Company_Id => i_Company_Id,
                                         i_Filial_Id  => i_Filial_Id,
                                         i_Person_Id  => r.Person_Id);
      end if;
    end loop;
  
    -- insert persons
    if v_Person_Ids.Count > 0 then
      for i in 1 .. v_Person_Ids.Count
      loop
        if not z_Mrf_Robot_Persons.Exist(i_Company_Id => i_Company_Id,
                                         i_Filial_Id  => i_Filial_Id,
                                         i_Robot_Id   => i_Robot_Id,
                                         i_Person_Id  => v_Person_Ids(i)) then
          z_Mrf_Robot_Persons.Insert_One(i_Company_Id => i_Company_Id,
                                         i_Filial_Id  => i_Filial_Id,
                                         i_Robot_Id   => i_Robot_Id,
                                         i_Person_Id  => v_Person_Ids(i));
          if i_Position_Enabled = 'Y' then
            Mrf_Api.Make_Dirty_Robot_Persons(i_Company_Id => i_Company_Id,
                                             i_Filial_Id  => i_Filial_Id,
                                             i_Person_Id  => v_Person_Ids(i));
          end if;
        end if;
      end loop;
    
      v_Person_Id := v_Person_Ids(1);
    end if;
  
    z_Mrf_Robots.Update_One(i_Company_Id => i_Company_Id,
                            i_Filial_Id  => i_Filial_Id,
                            i_Robot_Id   => i_Robot_Id,
                            i_Person_Id  => Option_Number(v_Person_Id));
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Robot_Person_Refresh_Cache(i_Company_Id number) is
    v_Date        date := Trunc(sysdate);
    v_Filial_Head number := Md_Pref.Filial_Head(i_Company_Id);
    v_User_System number := Md_Pref.User_System(i_Company_Id);
    r_Settings    Hrm_Settings%rowtype;
  begin
    for r in (select q.Company_Id, q.Filial_Id
                from Md_Filials q
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id <> v_Filial_Head
                 and q.State = 'A')
    loop
      Biruni_Route.Context_Begin;
    
      Ui_Context.Init(i_User_Id      => v_User_System,
                      i_Filial_Id    => r.Filial_Id,
                      i_Project_Code => Verifix.Project_Code);
    
      r_Settings := Hrm_Util.Load_Setting(i_Company_Id => i_Company_Id, i_Filial_Id => r.Filial_Id);
    
      for Rbt in (select *
                    from Hrm_Robots q
                   where q.Company_Id = r.Company_Id
                     and q.Filial_Id = r.Filial_Id
                     and v_Date between q.Opened_Date and Nvl(q.Closed_Date, Href_Pref.c_Max_Date))
      loop
        Robot_Person_Refresh_Cache(i_Company_Id       => Rbt.Company_Id,
                                   i_Filial_Id        => Rbt.Filial_Id,
                                   i_Robot_Id         => Rbt.Robot_Id,
                                   i_Position_Enabled => r_Settings.Position_Enable);
      end loop;
    
      if r_Settings.Position_Enable = 'Y' then
        Mrf_Api.Gen_Robot_Person_Roles;
      else
        delete Mrf_Dirty_Robot_Persons;
      end if;
    
      Biruni_Route.Context_End;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Fix_Robot_Divisions
  (
    i_Company_Id           number,
    i_Filial_Id            number,
    i_Robot_Id             number,
    i_Allowed_Division_Ids Array_Number
  ) is
  begin
    for r in (select *
                from Hrm_Robot_Divisions Rd
               where Rd.Company_Id = i_Company_Id
                 and Rd.Filial_Id = i_Filial_Id
                 and Rd.Robot_Id = i_Robot_Id
                 and Rd.Division_Id not member of
               i_Allowed_Division_Ids
                 and Rd.Access_Type = Hrm_Pref.c_Access_Type_Manual)
    loop
      z_Hrm_Robot_Divisions.Delete_One(i_Company_Id  => r.Company_Id,
                                       i_Filial_Id   => r.Filial_Id,
                                       i_Robot_Id    => r.Robot_Id,
                                       i_Division_Id => r.Division_Id);
    end loop;
  
    for i in 1 .. i_Allowed_Division_Ids.Count
    loop
      z_Hrm_Robot_Divisions.Save_One(i_Company_Id  => i_Company_Id,
                                     i_Filial_Id   => i_Filial_Id,
                                     i_Robot_Id    => i_Robot_Id,
                                     i_Division_Id => i_Allowed_Division_Ids(i),
                                     i_Access_Type => Hrm_Pref.c_Access_Type_Manual);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Sync_Division_Managers
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Staff_Id   number
  ) is
    r_Setting      Hrm_Settings%rowtype;
    r_Staff        Href_Staffs%rowtype;
    r_Manager      Mrf_Division_Managers%rowtype;
    v_Division_Ids Array_Number := Array_Number();
    v_Curr_Date    date := Trunc(sysdate);
  begin
    r_Setting := Hrm_Util.Load_Setting(i_Company_Id => i_Company_Id, i_Filial_Id => i_Filial_Id);
  
    if r_Setting.Position_Enable = 'Y' then
      return;
    end if;
  
    r_Staff := z_Href_Staffs.Load(i_Company_Id => i_Company_Id,
                                  i_Filial_Id  => i_Filial_Id,
                                  i_Staff_Id   => i_Staff_Id);
  
    if r_Staff.Staff_Kind <> Href_Pref.c_Staff_Kind_Primary then
      return;
    end if;
  
    -- refresh robot manual accesses
    if r_Staff.State = 'A' and v_Curr_Date between r_Staff.Hiring_Date and
       Nvl(r_Staff.Dismissal_Date, Href_Pref.c_Max_Date) then
      select Ed.Division_Id
        bulk collect
        into v_Division_Ids
        from Href_Employee_Divisions Ed
       where Ed.Company_Id = i_Company_Id
         and Ed.Filial_Id = i_Filial_Id
         and Ed.Employee_Id = r_Staff.Employee_Id;
    
      v_Division_Ids := Hrm_Util.Fix_Allowed_Divisions(i_Company_Id           => i_Company_Id,
                                                       i_Filial_Id            => i_Filial_Id,
                                                       i_Robot_Id             => r_Staff.Robot_Id,
                                                       i_Allowed_Division_Ids => v_Division_Ids);
    end if;
  
    Fix_Robot_Divisions(i_Company_Id           => i_Company_Id,
                        i_Filial_Id            => i_Filial_Id,
                        i_Robot_Id             => r_Staff.Robot_Id,
                        i_Allowed_Division_Ids => v_Division_Ids);
  
    -- refresh division manager robot
    if r_Staff.State = 'A' and v_Curr_Date between r_Staff.Hiring_Date and
       Nvl(r_Staff.Dismissal_Date, Href_Pref.c_Max_Date) then
      r_Manager.Company_Id := i_Company_Id;
      r_Manager.Filial_Id  := i_Filial_Id;
      r_Manager.Manager_Id := r_Staff.Robot_Id;
    
      for r in (select *
                  from Hrm_Division_Managers p
                 where p.Company_Id = i_Company_Id
                   and p.Filial_Id = i_Filial_Id
                   and p.Employee_Id = r_Staff.Employee_Id)
      loop
        r_Manager.Division_Id := r.Division_Id;
      
        Mrf_Api.Division_Manager_Save(r_Manager);
      end loop;
    else
      for r in (select *
                  from Hrm_Division_Managers p
                 where p.Company_Id = i_Company_Id
                   and p.Filial_Id = i_Filial_Id
                   and p.Employee_Id = r_Staff.Employee_Id)
      loop
        Mrf_Api.Division_Manager_Delete(i_Company_Id  => r.Company_Id,
                                        i_Filial_Id   => r.Filial_Id,
                                        i_Division_Id => r.Division_Id);
      end loop;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Sync_Division_Managers(i_Company_Id number) is
    v_Date        date := Trunc(sysdate);
    v_Filial_Head number := Md_Pref.Filial_Head(i_Company_Id);
    v_User_System number := Md_Pref.User_System(i_Company_Id);
  begin
    for r in (select q.Company_Id, q.Filial_Id
                from Md_Filials q
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id <> v_Filial_Head
                 and q.State = 'A')
    loop
      Biruni_Route.Context_Begin;
    
      Ui_Context.Init(i_User_Id      => v_User_System,
                      i_Filial_Id    => r.Filial_Id,
                      i_Project_Code => Verifix.Project_Code);
    
      for St in (select q.Company_Id, q.Filial_Id, q.Staff_Id
                   from Href_Staffs q
                  where q.Company_Id = r.Company_Id
                    and q.Filial_Id = r.Filial_Id
                    and q.State = 'A'
                    and q.Staff_Kind = Href_Pref.c_Staff_Kind_Primary
                    and q.Hiring_Date <= v_Date
                    and (q.Dismissal_Date is null or q.Dismissal_Date + 1 >= v_Date))
      loop
        Sync_Division_Managers(i_Company_Id => St.Company_Id,
                               i_Filial_Id  => St.Filial_Id,
                               i_Staff_Id   => St.Staff_Id);
      end loop;
    
      Biruni_Route.Context_End;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Check_Turnover
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Robot_Id   number
  ) is
  begin
    for r in (select q.*,
                     (select w.Name
                        from Mrf_Robots w
                       where w.Robot_Id = q.Robot_Id) name
                from Hrm_Robot_Turnover q
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.Robot_Id = i_Robot_Id
                 and not (q.Planed_Fte between 0 and 1 and q.Booked_Fte between 0 and 1 and
                      q.Occupied_Fte between 0 and 1 and q.Fte between 0 and 1)
               order by q.Period)
    loop
      if not r.Planed_Fte between 0 and 1 then
        Hrm_Error.Raise_001(i_Robot_Id   => r.Robot_Id,
                            i_Name       => r.Name,
                            i_Period     => r.Period,
                            i_Planed_Fte => r.Planed_Fte);
      end if;
    
      if not r.Booked_Fte between 0 and 1 then
        Hrm_Error.Raise_002(i_Robot_Id   => r.Robot_Id,
                            i_Name       => r.Name,
                            i_Period     => r.Period,
                            i_Booked_Fte => r.Booked_Fte);
      end if;
    
      if not r.Occupied_Fte between 0 and 1 then
        Hrm_Error.Raise_003(i_Name         => r.Name,
                            i_Period       => r.Period,
                            i_Occupied_Fte => r.Occupied_Fte);
      end if;
    
      if not r.Fte between 0 and 1 then
        if r.Fte > 1 then
          Hrm_Error.Raise_004(i_Name => r.Name, i_Period => r.Period);
        end if;
      
        Hrm_Error.Raise_005(i_Name       => r.Name,
                            i_Period     => r.Period,
                            i_Exceed_Fte => r.Occupied_Fte + r.Booked_Fte - r.Planed_Fte,
                            i_Booked_Fte => r.Booked_Fte);
      end if;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Revise_Robot_Dates
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Robot_Id   number
  ) is
    r_Setting       Hrm_Settings%rowtype;
    v_Last_Occupy   Hrm_Robot_Transactions%rowtype;
    v_Last_Planned  Hrm_Robot_Transactions%rowtype;
    v_First_Planned Hrm_Robot_Transactions%rowtype;
    v_First_Occupy  Hrm_Robot_Transactions%rowtype;
    v_Insert_Close  boolean := false;
    v_Remove_Close  boolean := false;
    v_Insert_Open   boolean := false;
    v_Remove_Open   boolean := false;
  
    --------------------------------------------------
    Procedure Assert_Booked_Transaction_Not_Exist is
      v_Date date;
    begin
      select p.Trans_Date
        into v_Date
        from Hrm_Robot_Transactions p
       where p.Company_Id = i_Company_Id
         and p.Filial_Id = i_Filial_Id
         and p.Robot_Id = i_Robot_Id
         and p.Fte_Kind = Hrm_Pref.c_Fte_Kind_Booked
         and Rownum = 1;
    
      Hrm_Error.Raise_006(i_Robot_Id => i_Robot_Id, i_Trans_Date => v_Date);
    exception
      when No_Data_Found then
        null;
    end;
  
    -------------------------------------------------- 
    Function Last_Trans
    (
      i_Company_Id number,
      i_Filial_Id  number,
      i_Robot_Id   number,
      i_Fte_Kind   varchar2
    ) return Hrm_Robot_Transactions%rowtype is
      v_Trans Hrm_Robot_Transactions%rowtype;
    begin
      select p.*
        into v_Trans
        from Hrm_Robot_Transactions p
       where p.Company_Id = i_Company_Id
         and p.Filial_Id = i_Filial_Id
         and p.Robot_Id = i_Robot_Id
         and p.Fte_Kind = i_Fte_Kind
         and p.Trans_Date = (select max(q.Trans_Date)
                               from Hrm_Robot_Transactions q
                              where q.Company_Id = p.Company_Id
                                and q.Filial_Id = p.Filial_Id
                                and q.Robot_Id = p.Robot_Id
                                and q.Fte_Kind = p.Fte_Kind);
    
      return v_Trans;
    exception
      when No_Data_Found then
        return null;
    end;
  
    -------------------------------------------------- 
    Function First_Trans
    (
      i_Company_Id number,
      i_Filial_Id  number,
      i_Robot_Id   number,
      i_Fte_Kind   varchar2
    ) return Hrm_Robot_Transactions%rowtype is
      v_Trans Hrm_Robot_Transactions%rowtype;
    begin
      select p.*
        into v_Trans
        from Hrm_Robot_Transactions p
       where p.Company_Id = i_Company_Id
         and p.Filial_Id = i_Filial_Id
         and p.Robot_Id = i_Robot_Id
         and p.Fte_Kind = i_Fte_Kind
         and p.Trans_Date = (select min(q.Trans_Date)
                               from Hrm_Robot_Transactions q
                              where q.Company_Id = p.Company_Id
                                and q.Filial_Id = p.Filial_Id
                                and q.Robot_Id = p.Robot_Id
                                and q.Fte_Kind = p.Fte_Kind);
    
      return v_Trans;
    exception
      when No_Data_Found then
        return null;
    end;
  
    --------------------------------------------------
    Procedure Update_Robot_Closed_Date
    (
      i_Company_Id        number,
      i_Filial_Id         number,
      i_Robot_Id          number,
      i_Remove_Close      boolean,
      i_Insert_Close      boolean,
      i_First_Occupy_Date date,
      i_Last_Occupy_Date  date
    ) is
      v_Close_Date date;
    begin
      if i_Insert_Close then
        v_Close_Date := i_Last_Occupy_Date;
      end if;
    
      z_Hrm_Robots.Update_One(i_Company_Id  => i_Company_Id,
                              i_Filial_Id   => i_Filial_Id,
                              i_Robot_Id    => i_Robot_Id,
                              i_Opened_Date => case
                                                 when i_First_Occupy_Date is not null then
                                                  Option_Date(i_First_Occupy_Date)
                                                 else
                                                  null
                                               end,
                              i_Closed_Date => case
                                                 when i_Insert_Close or i_Remove_Close then
                                                  Option_Date(v_Close_Date - 1)
                                                 else
                                                  null
                                               end);
    end;
  begin
    r_Setting := Hrm_Util.Load_Setting(i_Company_Id => i_Company_Id, i_Filial_Id => i_Filial_Id);
  
    if r_Setting.Position_Enable = 'Y' then
      return;
    end if;
  
    Assert_Booked_Transaction_Not_Exist;
  
    v_Last_Occupy   := Last_Trans(i_Company_Id => i_Company_Id,
                                  i_Filial_Id  => i_Filial_Id,
                                  i_Robot_Id   => i_Robot_Id,
                                  i_Fte_Kind   => Hrm_Pref.c_Fte_Kind_Occupied);
    v_Last_Planned  := Last_Trans(i_Company_Id => i_Company_Id,
                                  i_Filial_Id  => i_Filial_Id,
                                  i_Robot_Id   => i_Robot_Id,
                                  i_Fte_Kind   => Hrm_Pref.c_Fte_Kind_Planed);
    v_First_Occupy  := First_Trans(i_Company_Id => i_Company_Id,
                                   i_Filial_Id  => i_Filial_Id,
                                   i_Robot_Id   => i_Robot_Id,
                                   i_Fte_Kind   => Hrm_Pref.c_Fte_Kind_Occupied);
    v_First_Planned := First_Trans(i_Company_Id => i_Company_Id,
                                   i_Filial_Id  => i_Filial_Id,
                                   i_Robot_Id   => i_Robot_Id,
                                   i_Fte_Kind   => Hrm_Pref.c_Fte_Kind_Planed);
  
    if v_Last_Occupy.Fte < 0 then
      v_Remove_Close := v_Last_Planned.Trans_Date <> v_Last_Occupy.Trans_Date and
                        v_Last_Planned.Fte < 0;
    
      v_Insert_Close := v_Last_Planned.Company_Id is null or v_Last_Planned.Fte > 0 or
                        v_Remove_Close;
    else
      v_Remove_Close := v_Last_Planned.Fte < 0;
    end if;
  
    if v_First_Occupy.Company_Id is null then
      v_Remove_Open := v_First_Planned.Company_Id is not null;
    else
      v_Remove_Open := v_First_Planned.Trans_Date <> v_First_Occupy.Trans_Date and
                       v_First_Planned.Fte > 0;
    
      v_Insert_Open := v_First_Planned.Company_Id is null or v_First_Planned.Fte < 0 or
                       v_Remove_Open;
    end if;
  
    if v_Remove_Close then
      Robot_Transaction_Delete(i_Company_Id => v_Last_Planned.Company_Id,
                               i_Filial_Id  => v_Last_Planned.Filial_Id,
                               i_Trans_Id   => v_Last_Planned.Trans_Id);
    end if;
  
    if v_Insert_Close then
      Robot_Close(i_Company_Id => v_Last_Occupy.Company_Id,
                  i_Filial_Id  => v_Last_Occupy.Filial_Id,
                  i_Robot_Id   => v_Last_Occupy.Robot_Id,
                  i_Close_Date => v_Last_Occupy.Trans_Date - 1);
    end if;
  
    if v_Remove_Open then
      Robot_Transaction_Delete(i_Company_Id => v_First_Planned.Company_Id,
                               i_Filial_Id  => v_First_Planned.Filial_Id,
                               i_Trans_Id   => v_First_Planned.Trans_Id);
    end if;
  
    if v_Insert_Open then
      Robot_Open(i_Company_Id => v_First_Occupy.Company_Id,
                 i_Filial_Id  => v_First_Occupy.Filial_Id,
                 i_Robot_Id   => v_First_Occupy.Robot_Id,
                 i_Open_Date  => v_First_Occupy.Trans_Date);
    end if;
  
    Update_Robot_Closed_Date(i_Company_Id        => i_Company_Id,
                             i_Filial_Id         => i_Filial_Id,
                             i_Robot_Id          => i_Robot_Id,
                             i_Remove_Close      => v_Remove_Close,
                             i_Insert_Close      => v_Insert_Close,
                             i_First_Occupy_Date => v_First_Occupy.Trans_Date,
                             i_Last_Occupy_Date  => v_Last_Occupy.Trans_Date);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Dirty_Robots_Revise
  (
    i_Company_Id number,
    i_Filial_Id  number
  ) is
    r_Settings Hrm_Settings%rowtype;
  begin
    r_Settings := Hrm_Util.Load_Setting(i_Company_Id => i_Company_Id, i_Filial_Id => i_Filial_Id);
  
    for r in (select *
                from Hrm_Dirty_Robots Dr
               where Dr.Company_Id = i_Company_Id
                 and Dr.Filial_Id = i_Filial_Id)
    loop
      Revise_Robot_Dates(i_Company_Id => r.Company_Id,
                         i_Filial_Id  => r.Filial_Id,
                         i_Robot_Id   => r.Robot_Id);
    
      Check_Turnover(i_Company_Id => r.Company_Id,
                     i_Filial_Id  => r.Filial_Id,
                     i_Robot_Id   => r.Robot_Id);
    
      Robot_Person_Refresh_Cache(i_Company_Id       => r.Company_Id,
                                 i_Filial_Id        => r.Filial_Id,
                                 i_Robot_Id         => r.Robot_Id,
                                 i_Position_Enabled => r_Settings.Position_Enable);
    end loop;
  
    if r_Settings.Position_Enable = 'Y' then
      Mrf_Api.Gen_Robot_Person_Roles;
    else
      delete Mrf_Dirty_Robot_Persons;
    end if;
  
    delete Hrm_Dirty_Robots Dr
     where Dr.Company_Id = i_Company_Id
       and Dr.Filial_Id = i_Filial_Id;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Make_Dirty_Robot
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Robot_Id   number
  ) is
    v_Dummy varchar2(1);
  begin
    select 'x'
      into v_Dummy
      from Hrm_Dirty_Robots q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Robot_Id = i_Robot_Id;
  exception
    when No_Data_Found then
      insert into Hrm_Dirty_Robots
        (Company_Id, Filial_Id, Robot_Id)
      values
        (i_Company_Id, i_Filial_Id, i_Robot_Id);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Robot_Turnover_Evaluate
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Robot_Id   number,
    i_Trans_Date date,
    i_Fte_Kind   varchar2,
    i_Fte        number
  ) is
    v_Periods      Array_Date;
    v_Planed_Fte   number := 0;
    v_Booked_Fte   number := 0;
    v_Occupied_Fte number := 0;
    --------------------------------------------------
    Procedure Insert_Turnover is
      g Hrm_Robot_Turnover%rowtype;
    begin
      for r in (select *
                  from (select *
                          from Hrm_Robot_Turnover t
                         where t.Company_Id = i_Company_Id
                           and t.Filial_Id = i_Filial_Id
                           and t.Robot_Id = i_Robot_Id
                           and t.Period < i_Trans_Date
                         order by t.Period desc)
                 where Rownum = 1)
      loop
        g              := r;
        g.Period       := i_Trans_Date;
        g.Planed_Fte   := g.Planed_Fte + v_Planed_Fte;
        g.Booked_Fte   := g.Booked_Fte + v_Booked_Fte;
        g.Occupied_Fte := g.Occupied_Fte + v_Occupied_Fte;
      
        z_Hrm_Robot_Turnover.Insert_Row(g);
        return;
      end loop;
    
      g.Company_Id   := i_Company_Id;
      g.Filial_Id    := i_Filial_Id;
      g.Robot_Id     := i_Robot_Id;
      g.Period       := i_Trans_Date;
      g.Planed_Fte   := v_Planed_Fte;
      g.Booked_Fte   := v_Booked_Fte;
      g.Occupied_Fte := v_Occupied_Fte;
    
      z_Hrm_Robot_Turnover.Insert_Row(g);
    end;
  begin
    case i_Fte_Kind
      when Hrm_Pref.c_Fte_Kind_Planed then
        v_Planed_Fte := i_Fte;
      when Hrm_Pref.c_Fte_Kind_Booked then
        v_Booked_Fte := i_Fte;
      when Hrm_Pref.c_Fte_Kind_Occupied then
        v_Occupied_Fte := i_Fte;
      else
        Hrm_Error.Raise_007;
    end case;
  
    z_Hrm_Robots.Lock_Only(i_Company_Id => i_Company_Id,
                           i_Filial_Id  => i_Filial_Id,
                           i_Robot_Id   => i_Robot_Id);
  
    update Hrm_Robot_Turnover q
       set q.Planed_Fte   = q.Planed_Fte + v_Planed_Fte,
           q.Booked_Fte   = q.Booked_Fte + v_Booked_Fte,
           q.Occupied_Fte = q.Occupied_Fte + v_Occupied_Fte
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Robot_Id = i_Robot_Id
       and q.Period >= i_Trans_Date
    returning q.Period bulk collect into v_Periods;
  
    if i_Trans_Date not member of v_Periods then
      Insert_Turnover;
    end if;
  
    Make_Dirty_Robot(i_Company_Id => i_Company_Id,
                     i_Filial_Id  => i_Filial_Id,
                     i_Robot_Id   => i_Robot_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Robot_Transaction_Insert
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Robot_Id   number,
    i_Trans_Date date,
    i_Fte_Kind   varchar2,
    i_Fte        number,
    i_Tag        varchar2
  ) return number is
    v_Trans_Id number := Hrm_Robot_Transactions_Sq.Nextval;
  begin
    z_Hrm_Robot_Transactions.Insert_One(i_Company_Id => i_Company_Id,
                                        i_Filial_Id  => i_Filial_Id,
                                        i_Trans_Id   => v_Trans_Id,
                                        i_Robot_Id   => i_Robot_Id,
                                        i_Trans_Date => i_Trans_Date,
                                        i_Fte_Kind   => i_Fte_Kind,
                                        i_Fte        => i_Fte,
                                        i_Tag        => i_Tag);
  
    Robot_Turnover_Evaluate(i_Company_Id => i_Company_Id,
                            i_Filial_Id  => i_Filial_Id,
                            i_Robot_Id   => i_Robot_Id,
                            i_Trans_Date => i_Trans_Date,
                            i_Fte_Kind   => i_Fte_Kind,
                            i_Fte        => i_Fte);
  
    return v_Trans_Id;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Robot_Transaction_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Trans_Id   number
  ) is
    r_Transaction Hrm_Robot_Transactions%rowtype;
  begin
    r_Transaction := z_Hrm_Robot_Transactions.Load(i_Company_Id => i_Company_Id,
                                                   i_Filial_Id  => i_Filial_Id,
                                                   i_Trans_Id   => i_Trans_Id);
  
    Robot_Turnover_Evaluate(i_Company_Id => r_Transaction.Company_Id,
                            i_Filial_Id  => r_Transaction.Filial_Id,
                            i_Robot_Id   => r_Transaction.Robot_Id,
                            i_Trans_Date => r_Transaction.Trans_Date,
                            i_Fte_Kind   => r_Transaction.Fte_Kind,
                            i_Fte        => -1 * r_Transaction.Fte);
  
    z_Hrm_Robot_Transactions.Delete_One(i_Company_Id => i_Company_Id,
                                        i_Filial_Id  => i_Filial_Id,
                                        i_Trans_Id   => i_Trans_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Robot_Plans_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Robot_Id   number
  ) is
  begin
    for r in (select *
                from Hrm_Robot_Transactions p
               where p.Company_Id = i_Company_Id
                 and p.Filial_Id = i_Filial_Id
                 and p.Robot_Id = i_Robot_Id
                 and p.Fte_Kind = Hrm_Pref.c_Fte_Kind_Planed
               order by p.Trans_Date desc)
    loop
      Robot_Transaction_Delete(i_Company_Id => r.Company_Id,
                               i_Filial_Id  => r.Filial_Id,
                               i_Trans_Id   => r.Trans_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Robot_Open
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Robot_Id    number,
    i_Open_Date   date,
    i_Planned_Fte number := 1
  ) is
    v_Id number;
  begin
    v_Id := Robot_Transaction_Insert(i_Company_Id => i_Company_Id,
                                     i_Filial_Id  => i_Filial_Id,
                                     i_Robot_Id   => i_Robot_Id,
                                     i_Trans_Date => i_Open_Date,
                                     i_Fte_Kind   => Hrm_Pref.c_Fte_Kind_Planed,
                                     i_Fte        => i_Planned_Fte,
                                     i_Tag        => 'robot open');
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Robot_Close
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Robot_Id   number,
    i_Close_Date date
  ) is
    v_Id          number;
    v_Planned_Fte number;
  begin
    v_Planned_Fte := Hrm_Util.Get_Planned_Fte(i_Company_Id => i_Company_Id,
                                              i_Filial_Id  => i_Filial_Id,
                                              i_Robot_Id   => i_Robot_Id,
                                              i_Period     => i_Close_Date);
  
    v_Id := Robot_Transaction_Insert(i_Company_Id => i_Company_Id,
                                     i_Filial_Id  => i_Filial_Id,
                                     i_Robot_Id   => i_Robot_Id,
                                     i_Trans_Date => i_Close_Date + 1,
                                     i_Fte_Kind   => Hrm_Pref.c_Fte_Kind_Planed,
                                     i_Fte        => -v_Planned_Fte,
                                     i_Tag        => 'robot close');
  end;

  ----------------------------------------------------------------------------------------------------
  Function Robot_Occupy
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Robot_Id    number,
    i_Occupy_Date date,
    i_Fte         number,
    i_Is_Booked   boolean,
    i_Tag         varchar2
  ) return number is
    v_Fte_Kind varchar2(1) := Hrm_Pref.c_Fte_Kind_Occupied;
  begin
    if i_Is_Booked then
      v_Fte_Kind := Hrm_Pref.c_Fte_Kind_Booked;
    end if;
  
    return Robot_Transaction_Insert(i_Company_Id => i_Company_Id,
                                    i_Filial_Id  => i_Filial_Id,
                                    i_Robot_Id   => i_Robot_Id,
                                    i_Trans_Date => i_Occupy_Date,
                                    i_Fte_Kind   => v_Fte_Kind,
                                    i_Fte        => i_Fte,
                                    i_Tag        => i_Tag);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Robot_Unoccupy
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Robot_Id    number,
    i_Occupy_Date date,
    i_Fte         number,
    i_Is_Booked   boolean,
    i_Tag         varchar2
  ) return number is
    v_Fte_Kind varchar2(1) := Hrm_Pref.c_Fte_Kind_Occupied;
  begin
    if i_Is_Booked then
      v_Fte_Kind := Hrm_Pref.c_Fte_Kind_Booked;
    end if;
  
    return Robot_Transaction_Insert(i_Company_Id => i_Company_Id,
                                    i_Filial_Id  => i_Filial_Id,
                                    i_Robot_Id   => i_Robot_Id,
                                    i_Trans_Date => i_Occupy_Date,
                                    i_Fte_Kind   => v_Fte_Kind,
                                    i_Fte        => -1 * i_Fte,
                                    i_Tag        => i_Tag);
  end;

  ----------------------------------------------------------------------------------------------------      
  Procedure Wage_Scale_Register_Save(i_Wage_Scale_Reg Hrm_Pref.Wage_Scale_Register_Rt) is
    r_Register          Hrm_Wage_Scale_Registers%rowtype;
    r_Reg_Ranks         Hrm_Register_Ranks%rowtype;
    r_Reg_Indicator     Hrm_Register_Rank_Indicators%rowtype;
    r_Indicator         Href_Indicators%rowtype;
    v_Rank_Ids          Array_Number;
    v_Indicator_Ids     Array_Number;
    v_Reg_Rank          Hrm_Pref.Register_Ranks_Rt;
    v_Reg_Indicator     Hrm_Pref.Register_Rank_Indicator_Rt;
    v_Round_Model       Round_Model;
    v_Wage_Exists       boolean := false;
    v_Wage_Indicator_Id number := Href_Util.Indicator_Id(i_Company_Id => i_Wage_Scale_Reg.Company_Id,
                                                         i_Pcode      => Href_Pref.c_Pcode_Indicator_Wage);
    v_Exists            boolean;
  begin
    if z_Hrm_Wage_Scale_Registers.Exist_Lock(i_Company_Id  => i_Wage_Scale_Reg.Company_Id,
                                             i_Filial_Id   => i_Wage_Scale_Reg.Filial_Id,
                                             i_Register_Id => i_Wage_Scale_Reg.Register_Id,
                                             o_Row         => r_Register) then
      if r_Register.Posted = 'Y' then
        Hrm_Error.Raise_008(r_Register.Register_Id);
      end if;
    
      v_Exists := true;
    else
      r_Register.Company_Id  := i_Wage_Scale_Reg.Company_Id;
      r_Register.Filial_Id   := i_Wage_Scale_Reg.Filial_Id;
      r_Register.Register_Id := i_Wage_Scale_Reg.Register_Id;
      r_Register.Posted      := 'N';
    
      v_Exists := false;
    end if;
  
    r_Register.Register_Date   := i_Wage_Scale_Reg.Register_Date;
    r_Register.Register_Number := i_Wage_Scale_Reg.Register_Number;
    r_Register.Wage_Scale_Id   := i_Wage_Scale_Reg.Wage_Scale_Id;
    r_Register.Valid_From      := i_Wage_Scale_Reg.Valid_From;
    r_Register.Note            := i_Wage_Scale_Reg.Note;
  
    if i_Wage_Scale_Reg.With_Base_Wage = 'Y' then
      if i_Wage_Scale_Reg.Round_Model is null then
        Hrm_Error.Raise_009;
      else
        r_Register.Round_Model := i_Wage_Scale_Reg.Round_Model;
        v_Round_Model          := Round_Model(r_Register.Round_Model);
      end if;
    
      if i_Wage_Scale_Reg.Base_Wage is null then
        Hrm_Error.Raise_010;
      else
        r_Register.Base_Wage := i_Wage_Scale_Reg.Base_Wage;
      end if;
    else
      r_Register.Round_Model := null;
      r_Register.Base_Wage   := null;
    end if;
  
    if v_Exists then
      z_Hrm_Wage_Scale_Registers.Update_Row(r_Register);
    else
      if r_Register.Register_Number is null then
        r_Register.Register_Number := Md_Core.Gen_Number(i_Company_Id => i_Wage_Scale_Reg.Company_Id,
                                                         i_Filial_Id  => i_Wage_Scale_Reg.Filial_Id,
                                                         i_Table      => Zt.Hrm_Wage_Scale_Registers,
                                                         i_Column     => z.Register_Number);
      end if;
    
      z_Hrm_Wage_Scale_Registers.Insert_Row(r_Register);
    end if;
  
    v_Rank_Ids := Array_Number();
    v_Rank_Ids.Extend(i_Wage_Scale_Reg.Ranks.Count);
  
    if i_Wage_Scale_Reg.Ranks.Count = 0 then
      Hrm_Error.Raise_011;
    end if;
  
    for i in 1 .. i_Wage_Scale_Reg.Ranks.Count
    loop
      v_Reg_Rank := i_Wage_Scale_Reg.Ranks(i);
    
      v_Rank_Ids(i) := v_Reg_Rank.Rank_Id;
    
      r_Reg_Ranks.Company_Id  := r_Register.Company_Id;
      r_Reg_Ranks.Filial_Id   := r_Register.Filial_Id;
      r_Reg_Ranks.Register_Id := r_Register.Register_Id;
      r_Reg_Ranks.Rank_Id     := v_Reg_Rank.Rank_Id;
      r_Reg_Ranks.Order_No    := i;
    
      z_Hrm_Register_Ranks.Save_Row(r_Reg_Ranks);
    
      v_Indicator_Ids := Array_Number();
      v_Indicator_Ids.Extend(v_Reg_Rank.Indicators.Count);
    
      for j in 1 .. v_Reg_Rank.Indicators.Count
      loop
        v_Reg_Indicator := v_Reg_Rank.Indicators(j);
        v_Indicator_Ids(j) := v_Reg_Indicator.Indicator_Id;
      
        if not v_Wage_Exists and v_Wage_Indicator_Id = v_Reg_Indicator.Indicator_Id then
          v_Wage_Exists := true;
        end if;
      
        r_Indicator := z_Href_Indicators.Load(i_Company_Id   => r_Reg_Ranks.Company_Id,
                                              i_Indicator_Id => v_Reg_Indicator.Indicator_Id);
      
        if r_Indicator.Used = Href_Pref.c_Indicator_Used_Automatically then
          Hrm_Error.Raise_032(i_Register_Number => r_Register.Register_Number,
                              i_Indicator_Name  => r_Indicator.Name);
        end if;
      
        r_Reg_Indicator.Company_Id      := r_Reg_Ranks.Company_Id;
        r_Reg_Indicator.Filial_Id       := r_Reg_Ranks.Filial_Id;
        r_Reg_Indicator.Register_Id     := r_Reg_Ranks.Register_Id;
        r_Reg_Indicator.Rank_Id         := r_Reg_Ranks.Rank_Id;
        r_Reg_Indicator.Indicator_Id    := v_Reg_Indicator.Indicator_Id;
        r_Reg_Indicator.Indicator_Value := v_Reg_Indicator.Indicator_Value;
      
        if i_Wage_Scale_Reg.With_Base_Wage = 'Y' then
          if v_Reg_Indicator.Coefficient is null then
            Hrm_Error.Raise_012;
          else
            r_Reg_Indicator.Coefficient     := v_Reg_Indicator.Coefficient;
            r_Reg_Indicator.Indicator_Value := v_Round_Model.Eval(r_Register.Base_Wage *
                                                                  r_Reg_Indicator.Coefficient);
          end if;
        end if;
      
        z_Hrm_Register_Rank_Indicators.Save_Row(r_Reg_Indicator);
      end loop;
    
      if not v_Wage_Exists then
        Hrm_Error.Raise_031(r_Register.Register_Number);
      end if;
    
      -- remove unnecessary indicators
      delete from Hrm_Register_Rank_Indicators w
       where w.Company_Id = r_Reg_Ranks.Company_Id
         and w.Filial_Id = r_Reg_Ranks.Filial_Id
         and w.Register_Id = r_Reg_Ranks.Register_Id
         and w.Rank_Id = r_Reg_Ranks.Rank_Id
         and w.Indicator_Id not member of v_Indicator_Ids;
    end loop;
  
    -- remove unnecessary ranks
    delete from Hrm_Register_Ranks w
     where w.Company_Id = r_Register.Company_Id
       and w.Filial_Id = r_Register.Filial_Id
       and w.Register_Id = r_Register.Register_Id
       and w.Rank_Id not member of v_Rank_Ids;
  end;

  ----------------------------------------------------------------------------------------------------      
  Procedure Last_Changed_Date_Refresh
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Wage_Scale_Id number
  ) is
    v_Last_Changed_Date date;
  begin
    begin
      select max(r.Valid_From)
        into v_Last_Changed_Date
        from Hrm_Wage_Scale_Registers r
       where r.Company_Id = i_Company_Id
         and r.Filial_Id = i_Filial_Id
         and r.Wage_Scale_Id = i_Wage_Scale_Id
         and r.Posted = 'Y';
    exception
      when No_Data_Found then
        null;
    end;
  
    z_Hrm_Wage_Scales.Update_One(i_Company_Id        => i_Company_Id,
                                 i_Filial_Id         => i_Filial_Id,
                                 i_Wage_Scale_Id     => i_Wage_Scale_Id,
                                 i_Last_Changed_Date => Option_Date(v_Last_Changed_Date));
  end;

end Hrm_Core;
/
