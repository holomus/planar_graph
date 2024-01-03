create or replace package Hrm_Api is
  ----------------------------------------------------------------------------------------------------
  Procedure Setting_Save(i_Setting Hrm_Settings%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Wage_Scale_Save(i_Wage_Scale Hrm_Wage_Scales%rowtype);
  ----------------------------------------------------------------------------------------------------
  Procedure Wage_Scale_Delete
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Wage_Scale_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Wage_Scale_Register_Save(i_Wage_Scale_Reg Hrm_Pref.Wage_Scale_Register_Rt);
  ----------------------------------------------------------------------------------------------------  
  Procedure Wage_Scale_Register_Post
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Register_Id number
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Wage_Scale_Register_Unpost
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Register_Id number
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Wage_Scale_Register_Delete
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Register_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Fix_Robot_Org_Structure
  (
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Robot_Id        number,
    i_New_Division_Id number,
    i_New_Job_Id      number,
    i_New_Robot_Name  varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Update_Org_Unit
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Robot_Id    number,
    i_Org_Unit_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Job_Roles_Save
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Job_Id     number,
    i_Role_Ids   Array_Number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Robot_Save
  (
    i_Robot Hrm_Pref.Robot_Rt,
    i_Self  boolean := false -- for hpd_core.Implicit_Robot_Save
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Robot_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Robot_Id   number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Robot_Hidden_Salary_Job_Groups_Save
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Robot_Id      number,
    i_Job_Group_Ids Array_Number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Restore_Robot_Person
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Robot_Id   number,
    i_Person_Id  number
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Job_Template_Save
  (
    i_Template Hrm_Pref.Job_Template_Rt,
    i_User_Id  number
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Job_Template_Delete
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Template_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Division_Schedule_Save
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Division_Id number,
    i_Schedule_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Division_Manager_Save
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Division_Id number,
    i_Robot_Id    number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Division_Manager_Delete
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Division_Id number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Update_Child_Manager
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Division_Id    number,
    i_New_Manager_Id number
  );
  ----------------------------------------------------------------------------------------------------  
  Procedure Fix_Employee_Divisions
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Employee_Id  number,
    i_Division_Ids Array_Number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Division_Save(i_Division Hrm_Pref.Division_Rt);
  ----------------------------------------------------------------------------------------------------
  Procedure Save_Job_Bonus_Type(i_Job_Bonus_Type Hrm_Pref.Job_Bonus_Type_Rt);
  ----------------------------------------------------------------------------------------------------
  Procedure Hidden_Salary_Job_Group_Save
  (
    i_Company_Id    number,
    i_Job_Group_Ids Array_Number
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Save_Restrict_To_View_All_Salaries
  (
    i_Company_Id number,
    i_Value      varchar2
  );
  ---------------------------------------------------------------------------------------------------- 
  Procedure Save_Restrict_All_Salaries
  (
    i_Company_Id number,
    i_Value      varchar2
  );
  ----------------------------------------------------------------------------------------------------
  Procedure Set_Closed_Date_To_Robot
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Robot_Id    number,
    i_Closed_Date date
  );
end Hrm_Api;
/
create or replace package body Hrm_Api is
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
  Procedure Setting_Save(i_Setting Hrm_Settings%rowtype) is
    v_Robot_Id number;
    r_Setting  Hrm_Settings%rowtype;
  
    -------------------------------------------------- 
    Function Get_Journal_Numbers
    (
      i_Company_Id number,
      i_Filial_Id  number,
      i_Robot_Id   number
    ) return Array_Varchar2 is
      result Array_Varchar2;
    begin
      select (select w.Journal_Number
                from Hpd_Journals w
               where w.Company_Id = q.Company_Id
                 and w.Filial_Id = q.Filial_Id
                 and w.Journal_Id = q.Journal_Id)
        bulk collect
        into result
        from Hpd_Page_Robots Pr
        join Hpd_Journal_Pages q
          on q.Company_Id = Pr.Company_Id
         and q.Filial_Id = Pr.Filial_Id
         and q.Page_Id = Pr.Page_Id
       where Pr.Company_Id = i_Company_Id
         and Pr.Filial_Id = i_Filial_Id
         and Pr.Robot_Id = i_Robot_Id;
    
      return set(result);
    end;
  
    --------------------------------------------------
    Procedure Delete_All_Book_Transactions is
    begin
      for r in (select *
                  from Hpd_Robot_Trans_Pages q
                 where q.Company_Id = i_Setting.Company_Id
                   and q.Filial_Id = i_Setting.Filial_Id)
      loop
        z_Hpd_Robot_Trans_Pages.Delete_One(i_Company_Id => i_Setting.Company_Id,
                                           i_Filial_Id  => i_Setting.Filial_Id,
                                           i_Page_Id    => r.Page_Id,
                                           i_Trans_Id   => r.Trans_Id);
      
        z_Hpd_Robot_Trans_Staffs.Delete_One(i_Company_Id     => i_Setting.Company_Id,
                                            i_Filial_Id      => i_Setting.Filial_Id,
                                            i_Robot_Trans_Id => r.Trans_Id);
      
        Hrm_Core.Robot_Transaction_Delete(i_Company_Id => i_Setting.Company_Id,
                                          i_Filial_Id  => i_Setting.Filial_Id,
                                          i_Trans_Id   => r.Trans_Id);
      end loop;
    
      update Hpd_Page_Robots q
         set q.Is_Booked = 'N'
       where q.Company_Id = i_Setting.Company_Id
         and q.Filial_Id = i_Setting.Filial_Id;
    end;
  begin
    r_Setting := Hrm_Util.Load_Setting(i_Company_Id => i_Setting.Company_Id,
                                       i_Filial_Id  => i_Setting.Filial_Id);
  
    if r_Setting.Position_Enable = 'Y' and i_Setting.Position_Enable = 'N' then
      if Hrm_Core.Exists_Robot_With_Multiple_Staffs(i_Company_Id => i_Setting.Company_Id,
                                                    i_Filial_Id  => i_Setting.Filial_Id,
                                                    o_Robot_Id   => v_Robot_Id) then
        Hrm_Error.Raise_013(i_Robot_Name      => z_Mrf_Robots.Load(i_Company_Id => i_Setting.Company_Id, --
                                                 i_Filial_Id => i_Setting.Filial_Id, --
                                                 i_Robot_Id => v_Robot_Id).Name,
                            i_Journal_Numbers => Get_Journal_Numbers(i_Company_Id => i_Setting.Company_Id, --
                                                                     i_Filial_Id  => i_Setting.Filial_Id, --
                                                                     i_Robot_Id   => v_Robot_Id));
      end if;
    
      if Hrm_Core.Exists_Robot_With_Booked_Trans(i_Company_Id => i_Setting.Company_Id,
                                                 i_Filial_Id  => i_Setting.Filial_Id,
                                                 o_Robot_Id   => v_Robot_Id) then
        Hrm_Error.Raise_014(z_Mrf_Robots.Load(i_Company_Id => i_Setting.Company_Id, --
                            i_Filial_Id => i_Setting.Filial_Id, --
                            i_Robot_Id => v_Robot_Id).Name);
      end if;
    
      Hrm_Core.Insert_Division_Manager_Infos(i_Company_Id => i_Setting.Company_Id,
                                             i_Filial_Id  => i_Setting.Filial_Id);
    end if;
  
    if r_Setting.Advanced_Org_Structure = 'Y' and i_Setting.Advanced_Org_Structure = 'N' then
      Hrm_Core.Assert_Advanced_Org_Structure_Changeable(i_Company_Id => i_Setting.Company_Id,
                                                        i_Filial_Id  => i_Setting.Filial_Id);
    end if;
  
    if i_Setting.Position_Booking = 'N' and
       r_Setting.Position_Booking <> i_Setting.Position_Booking then
      Delete_All_Book_Transactions;
    
      Hrm_Core.Dirty_Robots_Revise(i_Company_Id => i_Setting.Company_Id,
                                   i_Filial_Id  => i_Setting.Filial_Id);
    end if;
  
    z_Hrm_Settings.Save_Row(i_Setting);
  
    if r_Setting.Position_Enable = 'N' and i_Setting.Position_Enable = 'Y' then
      Hrm_Core.Open_Unopened_Robots(i_Company_Id => i_Setting.Company_Id,
                                    i_Filial_Id  => i_Setting.Filial_Id);
    
      Hrm_Core.Insert_Robot_Roles(i_Company_Id => i_Setting.Company_Id,
                                  i_Filial_Id  => i_Setting.Filial_Id);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Wage_Scale_Save(i_Wage_Scale Hrm_Wage_Scales%rowtype) is
  begin
    z_Hrm_Wage_Scales.Save_Row(i_Wage_Scale);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Wage_Scale_Delete
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Wage_Scale_Id number
  ) is
  begin
    z_Hrm_Wage_Scales.Delete_One(i_Company_Id    => i_Company_Id,
                                 i_Filial_Id     => i_Filial_Id,
                                 i_Wage_Scale_Id => i_Wage_Scale_Id);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Wage_Scale_Register_Save(i_Wage_Scale_Reg Hrm_Pref.Wage_Scale_Register_Rt) is
  begin
    Hrm_Core.Wage_Scale_Register_Save(i_Wage_Scale_Reg);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Wage_Scale_Register_Post
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Register_Id number
  ) is
    r_Register Hrm_Wage_Scale_Registers%rowtype;
  begin
    r_Register := z_Hrm_Wage_Scale_Registers.Lock_Load(i_Company_Id  => i_Company_Id,
                                                       i_Filial_Id   => i_Filial_Id,
                                                       i_Register_Id => i_Register_Id);
  
    if r_Register.Posted = 'Y' then
      Hrm_Error.Raise_015(r_Register.Register_Id);
    end if;
  
    z_Hrm_Wage_Scale_Registers.Update_One(i_Company_Id  => r_Register.Company_Id,
                                          i_Filial_Id   => r_Register.Filial_Id,
                                          i_Register_Id => r_Register.Register_Id,
                                          i_Posted      => Option_Varchar2('Y'));
  
    Hrm_Core.Last_Changed_Date_Refresh(i_Company_Id    => r_Register.Company_Id,
                                       i_Filial_Id     => r_Register.Filial_Id,
                                       i_Wage_Scale_Id => r_Register.Wage_Scale_Id);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Wage_Scale_Register_Unpost
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Register_Id number
  ) is
    r_Register Hrm_Wage_Scale_Registers%rowtype;
  begin
    r_Register := z_Hrm_Wage_Scale_Registers.Lock_Load(i_Company_Id  => i_Company_Id,
                                                       i_Filial_Id   => i_Filial_Id,
                                                       i_Register_Id => i_Register_Id);
  
    if r_Register.Posted = 'N' then
      Hrm_Error.Raise_016(r_Register.Register_Id);
    end if;
  
    z_Hrm_Wage_Scale_Registers.Update_One(i_Company_Id  => r_Register.Company_Id,
                                          i_Filial_Id   => r_Register.Filial_Id,
                                          i_Register_Id => r_Register.Register_Id,
                                          i_Posted      => Option_Varchar2('N'));
  
    Hrm_Core.Last_Changed_Date_Refresh(i_Company_Id    => r_Register.Company_Id,
                                       i_Filial_Id     => r_Register.Filial_Id,
                                       i_Wage_Scale_Id => r_Register.Wage_Scale_Id);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Wage_Scale_Register_Delete
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Register_Id number
  ) is
  begin
    z_Hrm_Wage_Scale_Registers.Delete_One(i_Company_Id  => i_Company_Id,
                                          i_Filial_Id   => i_Filial_Id,
                                          i_Register_Id => i_Register_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Fix_Robot_Org_Structure
  (
    i_Company_Id      number,
    i_Filial_Id       number,
    i_Robot_Id        number,
    i_New_Division_Id number,
    i_New_Job_Id      number,
    i_New_Robot_Name  varchar2
  ) is
    r_Robot        Mrf_Robots%rowtype;
    r_Hrm_Robot    Hrm_Robots%rowtype;
    r_Hrm_Division Hrm_Divisions%rowtype;
    r_Setting      Hrm_Settings%rowtype := Hrm_Util.Load_Setting(i_Company_Id => i_Company_Id,
                                                                 i_Filial_Id  => i_Filial_Id);
  
    v_Division_Id Option_Number;
    v_Job_Id      Option_Number;
    v_Robot_Name  Option_Varchar2;
  begin
    if r_Setting.Position_Fixing = 'N' then
      return;
    end if;
  
    if not z_Hrm_Robots.Exist_Lock(i_Company_Id => i_Company_Id,
                                   i_Filial_Id  => i_Filial_Id,
                                   i_Robot_Id   => i_Robot_Id) then
      return;
    end if;
  
    r_Robot := z_Mrf_Robots.Lock_Load(i_Company_Id => i_Company_Id,
                                      i_Filial_Id  => i_Filial_Id,
                                      i_Robot_Id   => i_Robot_Id);
  
    r_Hrm_Robot := z_Hrm_Robots.Lock_Load(i_Company_Id => i_Company_Id,
                                          i_Filial_Id  => i_Filial_Id,
                                          i_Robot_Id   => i_Robot_Id);
  
    r_Hrm_Division := z_Hrm_Divisions.Lock_Load(i_Company_Id  => i_Company_Id,
                                                i_Filial_Id   => i_Filial_Id,
                                                i_Division_Id => r_Hrm_Robot.Org_Unit_Id);
  
    if r_Robot.Division_Id <> i_New_Division_Id then
      v_Division_Id := Option_Number(i_New_Division_Id);
    else
      v_Division_Id := null;
    end if;
  
    if r_Robot.Job_Id <> i_New_Job_Id then
      v_Job_Id := Option_Number(i_New_Job_Id);
    else
      v_Job_Id := null;
    end if;
  
    if r_Robot.Name <> i_New_Robot_Name then
      v_Robot_Name := Option_Varchar2(i_New_Robot_Name);
    else
      v_Robot_Name := null;
    end if;
  
    if v_Division_Id is null and v_Job_Id is null and v_Robot_Name is null then
      return;
    end if;
  
    z_Mrf_Robots.Update_One(i_Company_Id  => i_Company_Id,
                            i_Filial_Id   => i_Filial_Id,
                            i_Robot_Id    => i_Robot_Id,
                            i_Division_Id => v_Division_Id,
                            i_Job_Id      => v_Job_Id,
                            i_Name        => v_Robot_Name);
  
    if v_Division_Id is not null and
       (r_Hrm_Division.Is_Department = 'Y' and i_New_Division_Id <> r_Hrm_Robot.Org_Unit_Id or
       r_Hrm_Division.Is_Department = 'N' and
       r_Hrm_Division.Parent_Department_Id <> i_New_Division_Id) then
      z_Hrm_Robots.Update_One(i_Company_Id  => i_Company_Id,
                              i_Filial_Id   => i_Filial_Id,
                              i_Robot_Id    => i_Robot_Id,
                              i_Org_Unit_Id => v_Division_Id);
    end if;
  
    for r in (select *
                from Hpd_Page_Robots q
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.Robot_Id = i_Robot_Id)
    loop
      z_Hpd_Page_Robots.Update_One(i_Company_Id  => i_Company_Id,
                                   i_Filial_Id   => i_Filial_Id,
                                   i_Page_Id     => r.Page_Id,
                                   i_Division_Id => v_Division_Id,
                                   i_Job_Id      => v_Job_Id);
    end loop;
  
    for r in (select *
                from Hpd_Trans_Robots q
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.Robot_Id = i_Robot_Id)
    loop
      z_Hpd_Trans_Robots.Update_One(i_Company_Id  => i_Company_Id,
                                    i_Filial_Id   => i_Filial_Id,
                                    i_Trans_Id    => r.Trans_Id,
                                    i_Division_Id => v_Division_Id,
                                    i_Job_Id      => v_Job_Id);
    end loop;
  
    for r in (select *
                from Href_Staffs q
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.Robot_Id = i_Robot_Id)
    loop
      Hpd_Core.Staff_Refresh_Cache(i_Company_Id => i_Company_Id,
                                   i_Filial_Id  => i_Filial_Id,
                                   i_Staff_Id   => r.Staff_Id);
    
      Htt_Core.Person_Sync_Locations(i_Company_Id => i_Company_Id,
                                     i_Filial_Id  => i_Filial_Id,
                                     i_Person_Id  => r.Employee_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Update_Org_Unit
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Robot_Id    number,
    i_Org_Unit_Id number
  ) is
    v_Org_Unit_Id number;
    r_Robot       Mrf_Robots%rowtype;
  begin
    r_Robot := z_Mrf_Robots.Load(i_Company_Id => i_Company_Id,
                                 i_Filial_Id  => i_Filial_Id,
                                 i_Robot_Id   => i_Robot_Id);
  
    v_Org_Unit_Id := Nvl(i_Org_Unit_Id, r_Robot.Division_Id);
  
    if Hrm_Util.Load_Setting(i_Company_Id => i_Company_Id, i_Filial_Id => i_Filial_Id).Advanced_Org_Structure = 'N' then
      return;
    elsif v_Org_Unit_Id <> r_Robot.Division_Id then
      Hrm_Core.Assert_Org_Unit_Department(i_Company_Id  => r_Robot.Company_Id,
                                          i_Filial_Id   => r_Robot.Filial_Id,
                                          i_Division_Id => r_Robot.Division_Id,
                                          i_Org_Unit_Id => v_Org_Unit_Id);
    end if;
  
    z_Hrm_Robots.Update_One(i_Company_Id  => r_Robot.Company_Id,
                            i_Filial_Id   => r_Robot.Filial_Id,
                            i_Robot_Id    => r_Robot.Robot_Id,
                            i_Org_Unit_Id => Option_Number(v_Org_Unit_Id));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Job_Roles_Save
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Job_Id     number,
    i_Role_Ids   Array_Number
  ) is
  begin
    for i in 1 .. i_Role_Ids.Count
    loop
      z_Hrm_Job_Roles.Insert_Try(i_Company_Id => i_Company_Id,
                                 i_Filial_Id  => i_Filial_Id,
                                 i_Job_Id     => i_Job_Id,
                                 i_Role_Id    => i_Role_Ids(i));
    end loop;
  
    delete from Hrm_Job_Roles t
     where t.Company_Id = i_Company_Id
       and t.Filial_Id = i_Filial_Id
       and t.Job_Id = i_Job_Id
       and t.Role_Id not member of i_Role_Ids;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Robot_Save
  (
    i_Robot Hrm_Pref.Robot_Rt,
    i_Self  boolean := false -- for hpd_core.Implicit_Robot_Save
  ) is
    r_Settings      Hrm_Settings%rowtype := Hrm_Util.Load_Setting(i_Company_Id => i_Robot.Robot.Company_Id,
                                                                  i_Filial_Id  => i_Robot.Robot.Filial_Id);
    r_Mrf_Robot     Mrf_Robots%rowtype;
    r_Robot         Hrm_Robots%rowtype;
    r_Old_Robot     Hrm_Robots%rowtype;
    v_Oper_Type     Href_Pref.Oper_Type_Rt;
    v_Indicator     Href_Pref.Indicator_Rt;
    v_Oper_Type_Ids Array_Number;
    v_Register_Id   number;
    v_Value         number;
    v_User_Id       number;
  
    --------------------------------------------------
    Function Take_Register_Indicator_Value
    (
      i_Register_Id  number,
      i_Indicator_Id number,
      i_Rank_Id      number := null
    ) return number is
      v_Value number;
    begin
      select max(q.Indicator_Value)
        into v_Value
        from Hrm_Register_Rank_Indicators q
       where q.Company_Id = i_Robot.Robot.Company_Id
         and q.Filial_Id = i_Robot.Robot.Filial_Id
         and q.Register_Id = i_Register_Id
         and q.Indicator_Id = i_Indicator_Id
         and (i_Rank_Id is null or q.Rank_Id = i_Rank_Id);
    
      return v_Value;
    exception
      when No_Data_Found then
        return null;
    end;
  
    --------------------------------------------------
    Procedure Attach_Roles
    (
      i_Company_Id   number,
      i_Filial_Id    number,
      i_Robot_Id     number,
      i_Role_Ids     Array_Number,
      i_Is_New_Robot boolean
    ) is
      v_Role_Ids      Array_Number := i_Role_Ids;
      v_Staff_Role_Id number := Md_Util.Role_Id(i_Company_Id => i_Company_Id,
                                                i_Pcode      => Href_Pref.c_Pcode_Role_Staff);
    begin
      if i_Is_New_Robot and not Fazo.Contains(v_Role_Ids, v_Staff_Role_Id) then
        Fazo.Push(v_Role_Ids, v_Staff_Role_Id);
      end if;
    
      for r in (select *
                  from Mrf_Robot_Roles t
                 where t.Company_Id = i_Company_Id
                   and t.Filial_Id = i_Filial_Id
                   and t.Robot_Id = i_Robot_Id
                   and t.Role_Id not in (select Column_Value
                                           from table(v_Role_Ids)))
      loop
        Mrf_Api.Robot_Remove_Role(i_Company_Id => r.Company_Id,
                                  i_Robot_Id   => r.Robot_Id,
                                  i_Filial_Id  => r.Filial_Id,
                                  i_Role_Id    => r.Role_Id);
      end loop;
    
      for i in 1 .. v_Role_Ids.Count
      loop
        Mrf_Api.Robot_Add_Role(i_Company_Id => i_Company_Id,
                               i_Robot_Id   => i_Robot_Id,
                               i_Filial_Id  => i_Filial_Id,
                               i_Role_Id    => v_Role_Ids(i));
      end loop;
    end;
  
  begin
    if z_Mrf_Robots.Exist_Lock(i_Company_Id => i_Robot.Robot.Company_Id,
                               i_Filial_Id  => i_Robot.Robot.Filial_Id,
                               i_Robot_Id   => i_Robot.Robot.Robot_Id,
                               o_Row        => r_Mrf_Robot) and
       z_Hrm_Robots.Exist_Lock(i_Company_Id => i_Robot.Robot.Company_Id,
                               i_Filial_Id  => i_Robot.Robot.Filial_Id,
                               i_Robot_Id   => i_Robot.Robot.Robot_Id,
                               o_Row        => r_Old_Robot) and --
       r_Settings.Position_Enable = 'Y' and
       Hrm_Util.Access_Edit_Div_Job_Of_Robot(i_Company_Id => i_Robot.Robot.Company_Id,
                                             i_Filial_Id  => i_Robot.Robot.Filial_Id,
                                             i_Robot_Id   => i_Robot.Robot.Robot_Id) = 'N' then
      if r_Mrf_Robot.Division_Id <> i_Robot.Robot.Division_Id then
        Hrm_Error.Raise_017(i_Robot_Name   => r_Mrf_Robot.Name,
                            i_Old_Division => z_Mhr_Divisions.Load(i_Company_Id => r_Mrf_Robot.Company_Id, --
                                              i_Filial_Id => r_Mrf_Robot.Filial_Id, --
                                              i_Division_Id => r_Mrf_Robot.Division_Id).Name);
      end if;
    
      if r_Mrf_Robot.Job_Id <> i_Robot.Robot.Job_Id then
        Hrm_Error.Raise_018(i_Robot_Name => r_Mrf_Robot.Name,
                            i_Old_Job    => z_Mhr_Jobs.Load(i_Company_Id => r_Mrf_Robot.Company_Id, --
                                            i_Filial_Id => r_Mrf_Robot.Filial_Id, --
                                            i_Job_Id => r_Mrf_Robot.Job_Id).Name);
      end if;
    end if;
  
    if i_Robot.Planned_Fte > 1 or i_Robot.Planned_Fte < 0 then
      Hrm_Error.Raise_020(i_Robot.Planned_Fte);
    end if;
  
    if z_Mrf_Robots.Exist_Lock(i_Company_Id => i_Robot.Robot.Company_Id,
                               i_Filial_Id  => i_Robot.Robot.Filial_Id,
                               i_Robot_Id   => i_Robot.Robot.Robot_Id,
                               o_Row        => r_Mrf_Robot) then
      r_Mrf_Robot.Name           := i_Robot.Robot.Name;
      r_Mrf_Robot.Code           := i_Robot.Robot.Code;
      r_Mrf_Robot.Robot_Group_Id := i_Robot.Robot.Robot_Group_Id;
      r_Mrf_Robot.Division_Id    := i_Robot.Robot.Division_Id;
      r_Mrf_Robot.Job_Id         := i_Robot.Robot.Job_Id;
      r_Mrf_Robot.State          := i_Robot.Robot.State;
    
      Mrf_Api.Robot_Save(r_Mrf_Robot);
    else
      Mrf_Api.Robot_Save(i_Robot.Robot);
    end if;
  
    z_Hrm_Robots.Init(p_Row                      => r_Robot,
                      i_Company_Id               => i_Robot.Robot.Company_Id,
                      i_Filial_Id                => i_Robot.Robot.Filial_Id,
                      i_Robot_Id                 => i_Robot.Robot.Robot_Id,
                      i_Org_Unit_Id              => Nvl(i_Robot.Org_Unit_Id,
                                                        i_Robot.Robot.Division_Id),
                      i_Opened_Date              => i_Robot.Opened_Date,
                      i_Closed_Date              => i_Robot.Closed_Date,
                      i_Schedule_Id              => i_Robot.Schedule_Id,
                      i_Rank_Id                  => i_Robot.Rank_Id,
                      i_Labor_Function_Id        => i_Robot.Labor_Function_Id,
                      i_Description              => i_Robot.Description,
                      i_Hiring_Condition         => i_Robot.Hiring_Condition,
                      i_Contractual_Wage         => i_Robot.Contractual_Wage,
                      i_Access_Hidden_Salary     => i_Robot.Access_Hidden_Salary,
                      i_Currency_Id              => i_Robot.Currency_Id,
                      i_Position_Employment_Kind => Nvl(i_Robot.Position_Employment_Kind,
                                                        Hrm_Pref.c_Position_Employment_Staff));
  
    -- temporarily done to avoid taking user_id as a param
    v_User_Id := z_Mrf_Robots.Load(i_Company_Id => i_Robot.Robot.Company_Id, i_Filial_Id => i_Robot.Robot.Filial_Id, i_Robot_Id => i_Robot.Robot.Robot_Id).Modified_By;
  
    if Hrm_Util.Has_Access_To_Hidden_Salary_Job(i_Company_Id => i_Robot.Robot.Company_Id,
                                                i_Filial_Id  => i_Robot.Robot.Filial_Id,
                                                i_Job_Id     => i_Robot.Robot.Job_Id,
                                                i_User_Id    => v_User_Id) or i_Self then
      if r_Robot.Contractual_Wage = 'N' then
        r_Robot.Wage_Scale_Id := i_Robot.Wage_Scale_Id;
      end if;
    else
      r_Robot.Contractual_Wage := Nvl(r_Old_Robot.Contractual_Wage, 'Y');
      r_Robot.Wage_Scale_Id    := r_Old_Robot.Wage_Scale_Id;
    end if;
  
    if r_Settings.Position_Enable = 'N' and r_Old_Robot.Company_Id is not null then
      r_Robot.Opened_Date := r_Old_Robot.Opened_Date;
      r_Robot.Closed_Date := r_Old_Robot.Closed_Date;
    end if;
  
    if r_Settings.Advanced_Org_Structure = 'N' then
      r_Robot.Org_Unit_Id := i_Robot.Robot.Division_Id;
    elsif r_Robot.Org_Unit_Id <> i_Robot.Robot.Division_Id then
      Hrm_Core.Assert_Org_Unit_Department(i_Company_Id  => r_Robot.Company_Id,
                                          i_Filial_Id   => r_Robot.Filial_Id,
                                          i_Division_Id => i_Robot.Robot.Division_Id,
                                          i_Org_Unit_Id => r_Robot.Org_Unit_Id);
    end if;
  
    if r_Old_Robot.Position_Employment_Kind is not null then
      r_Robot.Position_Employment_Kind := r_Old_Robot.Position_Employment_Kind;
    end if;
  
    z_Hrm_Robots.Save_Row(r_Robot);
  
    -- save robot vacation days limits
    if i_Robot.Vacation_Days_Limit is not null then
      z_Hrm_Robot_Vacation_Limits.Save_One(i_Company_Id => r_Robot.Company_Id,
                                           i_Filial_Id  => r_Robot.Filial_Id,
                                           i_Robot_Id   => r_Robot.Robot_Id,
                                           i_Days_Limit => i_Robot.Vacation_Days_Limit);
    end if;
  
    if r_Settings.Position_Enable = 'Y' then
      Hrm_Core.Robot_Plans_Delete(i_Company_Id => r_Robot.Company_Id,
                                  i_Filial_Id  => r_Robot.Filial_Id,
                                  i_Robot_Id   => r_Robot.Robot_Id);
    
      Hrm_Core.Robot_Open(i_Company_Id  => r_Robot.Company_Id,
                          i_Filial_Id   => r_Robot.Filial_Id,
                          i_Robot_Id    => r_Robot.Robot_Id,
                          i_Open_Date   => r_Robot.Opened_Date,
                          i_Planned_Fte => i_Robot.Planned_Fte);
    
      if r_Robot.Closed_Date is not null then
        Hrm_Core.Robot_Close(i_Company_Id => r_Robot.Company_Id,
                             i_Filial_Id  => r_Robot.Filial_Id,
                             i_Robot_Id   => r_Robot.Robot_Id,
                             i_Close_Date => r_Robot.Closed_Date);
      end if;
    end if;
  
    -- save oper types and indicators
    if Hrm_Util.Has_Access_To_Hidden_Salary_Job(i_Company_Id => i_Robot.Robot.Company_Id,
                                                i_Filial_Id  => i_Robot.Robot.Filial_Id,
                                                i_Job_Id     => i_Robot.Robot.Job_Id,
                                                i_User_Id    => v_User_Id) or i_Self then
      v_Oper_Type_Ids := Array_Number();
      v_Oper_Type_Ids.Extend(i_Robot.Oper_Types.Count);
    
      for i in 1 .. i_Robot.Indicators.Count
      loop
        v_Indicator := i_Robot.Indicators(i);
      
        z_Hrm_Robot_Indicators.Save_One(i_Company_Id      => r_Robot.Company_Id,
                                        i_Filial_Id       => r_Robot.Filial_Id,
                                        i_Robot_Id        => r_Robot.Robot_Id,
                                        i_Indicator_Id    => v_Indicator.Indicator_Id,
                                        i_Indicator_Value => v_Indicator.Indicator_Value);
      end loop;
    
      for i in 1 .. i_Robot.Oper_Types.Count
      loop
        v_Oper_Type := i_Robot.Oper_Types(i);
        v_Oper_Type_Ids(i) := v_Oper_Type.Oper_Type_Id;
      
        z_Hrm_Robot_Oper_Types.Insert_Try(i_Company_Id   => r_Robot.Company_Id,
                                          i_Filial_Id    => r_Robot.Filial_Id,
                                          i_Robot_Id     => r_Robot.Robot_Id,
                                          i_Oper_Type_Id => v_Oper_Type.Oper_Type_Id);
      
        for j in 1 .. v_Oper_Type.Indicator_Ids.Count
        loop
          z_Hrm_Oper_Type_Indicators.Insert_Try(i_Company_Id   => r_Robot.Company_Id,
                                                i_Filial_Id    => r_Robot.Filial_Id,
                                                i_Robot_Id     => r_Robot.Robot_Id,
                                                i_Oper_Type_Id => v_Oper_Type.Oper_Type_Id,
                                                i_Indicator_Id => v_Oper_Type.Indicator_Ids(j));
        end loop;
      
        for r in (select *
                    from Hrm_Oper_Type_Indicators t
                   where t.Company_Id = r_Robot.Company_Id
                     and t.Filial_Id = r_Robot.Filial_Id
                     and t.Robot_Id = r_Robot.Robot_Id
                     and t.Oper_Type_Id = v_Oper_Type.Oper_Type_Id
                     and t.Indicator_Id not member of v_Oper_Type.Indicator_Ids)
        loop
          z_Hrm_Oper_Type_Indicators.Delete_One(i_Company_Id   => r_Robot.Company_Id,
                                                i_Filial_Id    => r_Robot.Filial_Id,
                                                i_Robot_Id     => r_Robot.Robot_Id,
                                                i_Oper_Type_Id => r.Oper_Type_Id,
                                                i_Indicator_Id => r.Indicator_Id);
        end loop;
      end loop;
    
      for r in (select *
                  from Hrm_Robot_Oper_Types t
                 where t.Company_Id = r_Robot.Company_Id
                   and t.Filial_Id = r_Robot.Filial_Id
                   and t.Robot_Id = r_Robot.Robot_Id
                   and t.Oper_Type_Id not member of v_Oper_Type_Ids)
      loop
        z_Hrm_Robot_Oper_Types.Delete_One(i_Company_Id   => r_Robot.Company_Id,
                                          i_Filial_Id    => r_Robot.Filial_Id,
                                          i_Robot_Id     => r_Robot.Robot_Id,
                                          i_Oper_Type_Id => r.Oper_Type_Id);
      end loop;
    
      for r in (select q.Indicator_Id
                  from Hrm_Robot_Indicators q
                 where q.Company_Id = r_Robot.Company_Id
                   and q.Filial_Id = r_Robot.Filial_Id
                   and q.Robot_Id = r_Robot.Robot_Id
                   and not exists (select 1
                          from Hrm_Oper_Type_Indicators w
                         where w.Company_Id = q.Company_Id
                           and w.Filial_Id = q.Filial_Id
                           and w.Robot_Id = q.Robot_Id
                           and w.Indicator_Id = q.Indicator_Id))
      loop
        z_Hrm_Robot_Indicators.Delete_One(i_Company_Id   => r_Robot.Company_Id,
                                          i_Filial_Id    => r_Robot.Filial_Id,
                                          i_Robot_Id     => r_Robot.Robot_Id,
                                          i_Indicator_Id => r.Indicator_Id);
      end loop;
    end if;
  
    -- fix not contractual wage indicator
    if r_Robot.Contractual_Wage = 'N' then
      v_Register_Id := Hrm_Util.Closest_Register_Id(i_Company_Id    => r_Robot.Company_Id,
                                                    i_Filial_Id     => r_Robot.Filial_Id,
                                                    i_Wage_Scale_Id => r_Robot.Wage_Scale_Id,
                                                    i_Period        => r_Robot.Opened_Date);
    
      for i in 1 .. i_Robot.Indicators.Count
      loop
        v_Indicator := i_Robot.Indicators(i);
      
        v_Value := Take_Register_Indicator_Value(i_Register_Id  => v_Register_Id,
                                                 i_Indicator_Id => v_Indicator.Indicator_Id,
                                                 i_Rank_Id      => r_Robot.Rank_Id);
      
        if v_Value is not null then
          z_Hrm_Robot_Indicators.Save_One(i_Company_Id      => r_Robot.Company_Id,
                                          i_Filial_Id       => r_Robot.Filial_Id,
                                          i_Robot_Id        => r_Robot.Robot_Id,
                                          i_Indicator_Id    => v_Indicator.Indicator_Id,
                                          i_Indicator_Value => v_Value);
        end if;
      end loop;
    end if;
  
    Hrm_Core.Fix_Robot_Divisions(i_Company_Id           => r_Robot.Company_Id,
                                 i_Filial_Id            => r_Robot.Filial_Id,
                                 i_Robot_Id             => r_Robot.Robot_Id,
                                 i_Allowed_Division_Ids => i_Robot.Allowed_Division_Ids);
  
    if r_Settings.Position_Enable = 'Y' then
      Attach_Roles(i_Company_Id   => r_Robot.Company_Id,
                   i_Filial_Id    => r_Robot.Filial_Id,
                   i_Robot_Id     => r_Robot.Robot_Id,
                   i_Role_Ids     => i_Robot.Role_Ids,
                   i_Is_New_Robot => case
                                       when r_Old_Robot.Robot_Id is null then
                                        true
                                       else
                                        false
                                     end);
    end if;
  
    Hrm_Core.Dirty_Robots_Revise(i_Company_Id => r_Robot.Company_Id,
                                 i_Filial_Id  => r_Robot.Filial_Id);
  
    Hrm_Core.Staff_Refresh_Cache(i_Company_Id => r_Robot.Company_Id,
                                 i_Filial_Id  => r_Robot.Filial_Id,
                                 i_Robot_Id   => r_Robot.Robot_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Robot_Delete
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Robot_Id   number
  ) is
  begin
    Hrm_Core.Robot_Plans_Delete(i_Company_Id => i_Company_Id,
                                i_Filial_Id  => i_Filial_Id,
                                i_Robot_Id   => i_Robot_Id);
    Hrm_Core.Dirty_Robots_Revise(i_Company_Id => i_Company_Id, i_Filial_Id => i_Filial_Id);
  
    z_Hrm_Robots.Delete_One(i_Company_Id => i_Company_Id,
                            i_Filial_Id  => i_Filial_Id,
                            i_Robot_Id   => i_Robot_Id);
  
    Mrf_Api.Robot_Delete(i_Company_Id => i_Company_Id,
                         i_Filial_Id  => i_Filial_Id,
                         i_Robot_Id   => i_Robot_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Robot_Hidden_Salary_Job_Groups_Save
  (
    i_Company_Id    number,
    i_Filial_Id     number,
    i_Robot_Id      number,
    i_Job_Group_Ids Array_Number
  ) is
  begin
    if Hrm_Util.Load_Setting(i_Company_Id => i_Company_Id, i_Filial_Id => i_Filial_Id).Position_Enable = 'N' then
      return;
    end if;
  
    for i in 1 .. i_Job_Group_Ids.Count
    loop
      if z_Hrm_Hidden_Salary_Job_Groups.Exist(i_Company_Id   => i_Company_Id,
                                              i_Job_Group_Id => i_Job_Group_Ids(i)) then
        z_Hrm_Robot_Hidden_Salary_Job_Groups.Insert_Try(i_Company_Id   => i_Company_Id,
                                                        i_Filial_Id    => i_Filial_Id,
                                                        i_Robot_Id     => i_Robot_Id,
                                                        i_Job_Group_Id => i_Job_Group_Ids(i));
      end if;
    end loop;
  
    delete Hrm_Robot_Hidden_Salary_Job_Groups q
     where q.Company_Id = i_Company_Id
       and q.Filial_Id = i_Filial_Id
       and q.Robot_Id = i_Robot_Id
       and q.Job_Group_Id not member of i_Job_Group_Ids;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Restore_Robot_Person
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Robot_Id   number,
    i_Person_Id  number
  ) is
  begin
    z_Mrf_Robots.Update_One(i_Company_Id => i_Company_Id,
                            i_Filial_Id  => i_Filial_Id,
                            i_Robot_Id   => i_Robot_Id,
                            i_Person_Id  => Option_Number(i_Person_Id));
  
    z_Mrf_Robot_Persons.Insert_Try(i_Company_Id => i_Company_Id,
                                   i_Filial_Id  => i_Filial_Id,
                                   i_Robot_Id   => i_Robot_Id,
                                   i_Person_Id  => i_Person_Id);
  
    Mrf_Api.Make_Dirty_Robot_Persons(i_Company_Id => i_Company_Id,
                                     i_Filial_Id  => i_Filial_Id,
                                     i_Person_Id  => i_Person_Id);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Job_Template_Save
  (
    i_Template Hrm_Pref.Job_Template_Rt,
    i_User_Id  number
  ) is
    r_Template      Hrm_Job_Templates%rowtype;
    v_Oper_Type     Href_Pref.Oper_Type_Rt;
    v_Indicator     Href_Pref.Indicator_Rt;
    v_Oper_Type_Ids Array_Number;
    v_Exists        boolean := true;
  begin
    if not z_Hrm_Job_Templates.Exist_Lock(i_Company_Id  => i_Template.Company_Id,
                                          i_Filial_Id   => i_Template.Filial_Id,
                                          i_Template_Id => i_Template.Template_Id,
                                          o_Row         => r_Template) then
      v_Exists               := false;
      r_Template.Company_Id  := i_Template.Company_Id;
      r_Template.Filial_Id   := i_Template.Filial_Id;
      r_Template.Template_Id := i_Template.Template_Id;
    end if;
  
    r_Template.Division_Id         := i_Template.Division_Id;
    r_Template.Job_Id              := i_Template.Job_Id;
    r_Template.Rank_Id             := i_Template.Rank_Id;
    r_Template.Schedule_Id         := i_Template.Schedule_Id;
    r_Template.Vacation_Days_Limit := i_Template.Vacation_Days_Limit;
  
    if Hrm_Util.Has_Access_To_Hidden_Salary_Job(i_Company_Id => r_Template.Company_Id,
                                                i_Filial_Id  => r_Template.Filial_Id,
                                                i_Job_Id     => r_Template.Job_Id,
                                                i_User_Id    => i_User_Id) then
      r_Template.Wage_Scale_Id := i_Template.Wage_Scale_Id;
    end if;
  
    if v_Exists then
      z_Hrm_Job_Templates.Update_Row(r_Template);
    else
      z_Hrm_Job_Templates.Insert_Row(r_Template);
    end if;
  
    -- oper types
    if Hrm_Util.Has_Access_To_Hidden_Salary_Job(i_Company_Id => r_Template.Company_Id,
                                                i_Filial_Id  => r_Template.Filial_Id,
                                                i_Job_Id     => r_Template.Job_Id,
                                                i_User_Id    => i_User_Id) then
      v_Oper_Type_Ids := Array_Number();
      v_Oper_Type_Ids.Extend(i_Template.Oper_Types.Count);
    
      for i in 1 .. i_Template.Indicators.Count
      loop
        v_Indicator := i_Template.Indicators(i);
      
        z_Hrm_Template_Indicators.Save_One(i_Company_Id      => r_Template.Company_Id,
                                           i_Filial_Id       => r_Template.Filial_Id,
                                           i_Template_Id     => r_Template.Template_Id,
                                           i_Indicator_Id    => v_Indicator.Indicator_Id,
                                           i_Indicator_Value => v_Indicator.Indicator_Value);
      end loop;
    
      for i in 1 .. i_Template.Oper_Types.Count
      loop
        v_Oper_Type := i_Template.Oper_Types(i);
        v_Oper_Type_Ids(i) := v_Oper_Type.Oper_Type_Id;
      
        z_Hrm_Template_Oper_Types.Insert_Try(i_Company_Id   => r_Template.Company_Id,
                                             i_Filial_Id    => r_Template.Filial_Id,
                                             i_Template_Id  => r_Template.Template_Id,
                                             i_Oper_Type_Id => v_Oper_Type.Oper_Type_Id);
      
        for j in 1 .. v_Oper_Type.Indicator_Ids.Count
        loop
          z_Hrm_Temp_Oper_Type_Indicators.Insert_Try(i_Company_Id   => r_Template.Company_Id,
                                                     i_Filial_Id    => r_Template.Filial_Id,
                                                     i_Template_Id  => r_Template.Template_Id,
                                                     i_Oper_Type_Id => v_Oper_Type.Oper_Type_Id,
                                                     i_Indicator_Id => v_Oper_Type.Indicator_Ids(j));
        end loop;
      
        for r in (select *
                    from Hrm_Temp_Oper_Type_Indicators t
                   where t.Company_Id = r_Template.Company_Id
                     and t.Filial_Id = r_Template.Filial_Id
                     and t.Template_Id = r_Template.Template_Id
                     and t.Oper_Type_Id = v_Oper_Type.Oper_Type_Id
                     and t.Indicator_Id not member of v_Oper_Type.Indicator_Ids)
        loop
          z_Hrm_Temp_Oper_Type_Indicators.Delete_One(i_Company_Id   => r_Template.Company_Id,
                                                     i_Filial_Id    => r_Template.Filial_Id,
                                                     i_Template_Id  => r_Template.Template_Id,
                                                     i_Oper_Type_Id => r.Oper_Type_Id,
                                                     i_Indicator_Id => r.Indicator_Id);
        end loop;
      end loop;
    
      for r in (select *
                  from Hrm_Template_Oper_Types t
                 where t.Company_Id = r_Template.Company_Id
                   and t.Filial_Id = r_Template.Filial_Id
                   and t.Template_Id = r_Template.Template_Id
                   and t.Oper_Type_Id not member of v_Oper_Type_Ids)
      loop
        z_Hrm_Template_Oper_Types.Delete_One(i_Company_Id   => r_Template.Company_Id,
                                             i_Filial_Id    => r_Template.Filial_Id,
                                             i_Template_Id  => r_Template.Template_Id,
                                             i_Oper_Type_Id => r.Oper_Type_Id);
      end loop;
    
      for r in (select q.Indicator_Id
                  from Hrm_Template_Indicators q
                 where q.Company_Id = r_Template.Company_Id
                   and q.Filial_Id = r_Template.Filial_Id
                   and q.Template_Id = r_Template.Template_Id
                   and not exists (select 1
                          from Hrm_Temp_Oper_Type_Indicators w
                         where w.Company_Id = q.Company_Id
                           and w.Filial_Id = q.Filial_Id
                           and w.Template_Id = q.Template_Id
                           and w.Indicator_Id = q.Indicator_Id))
      loop
        z_Hrm_Template_Indicators.Delete_One(i_Company_Id   => r_Template.Company_Id,
                                             i_Filial_Id    => r_Template.Filial_Id,
                                             i_Template_Id  => r_Template.Template_Id,
                                             i_Indicator_Id => r.Indicator_Id);
      end loop;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Job_Template_Delete
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Template_Id number
  ) is
  begin
    z_Hrm_Job_Templates.Delete_One(i_Company_Id  => i_Company_Id,
                                   i_Filial_Id   => i_Filial_Id,
                                   i_Template_Id => i_Template_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Division_Schedule_Save
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Division_Id number,
    i_Schedule_Id number
  ) is
  begin
    if i_Schedule_Id is not null then
      z_Hrm_Division_Schedules.Save_One(i_Company_Id  => i_Company_Id,
                                        i_Filial_Id   => i_Filial_Id,
                                        i_Division_Id => i_Division_Id,
                                        i_Schedule_Id => i_Schedule_Id);
    else
      z_Hrm_Division_Schedules.Delete_One(i_Company_Id  => i_Company_Id,
                                          i_Filial_Id   => i_Filial_Id,
                                          i_Division_Id => i_Division_Id);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Division_Manager_Save
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Division_Id number,
    i_Robot_Id    number
  ) is
    r_Setting Hrm_Settings%rowtype;
    r_Robot   Mrf_Robots%rowtype;
    r_Manager Mrf_Division_Managers%rowtype;
  begin
    r_Setting := Hrm_Util.Load_Setting(i_Company_Id => i_Company_Id, i_Filial_Id => i_Filial_Id);
  
    if r_Setting.Position_Enable = 'N' then
      r_Robot := z_Mrf_Robots.Lock_Load(i_Company_Id => i_Company_Id,
                                        i_Filial_Id  => i_Filial_Id,
                                        i_Robot_Id   => i_Robot_Id);
    
      z_Hrm_Division_Managers.Save_One(i_Company_Id  => i_Company_Id,
                                       i_Filial_Id   => i_Filial_Id,
                                       i_Division_Id => i_Division_Id,
                                       i_Employee_Id => r_Robot.Person_Id);
    end if;
  
    r_Manager.Company_Id  := i_Company_Id;
    r_Manager.Filial_Id   := i_Filial_Id;
    r_Manager.Division_Id := i_Division_Id;
    r_Manager.Manager_Id  := i_Robot_Id;
  
    Mrf_Api.Division_Manager_Save(r_Manager);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Division_Manager_Delete
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Division_Id number
  ) is
    r_Setting Hrm_Settings%rowtype;
  begin
    r_Setting := Hrm_Util.Load_Setting(i_Company_Id => i_Company_Id, i_Filial_Id => i_Filial_Id);
  
    if r_Setting.Position_Enable = 'N' then
      z_Hrm_Division_Managers.Delete_One(i_Company_Id  => i_Company_Id,
                                         i_Filial_Id   => i_Filial_Id,
                                         i_Division_Id => i_Division_Id);
    end if;
  
    Mrf_Api.Division_Manager_Delete(i_Company_Id  => i_Company_Id,
                                    i_Filial_Id   => i_Filial_Id,
                                    i_Division_Id => i_Division_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Update_Child_Manager
  (
    i_Company_Id     number,
    i_Filial_Id      number,
    i_Division_Id    number,
    i_New_Manager_Id number
  ) is
  begin
    for r in (select q.*
                from Mhr_Parent_Divisions q
                join Hrm_Divisions Hd
                  on Hd.Company_Id = q.Company_Id
                 and Hd.Filial_Id = q.Filial_Id
                 and Hd.Division_Id = q.Division_Id
               where q.Company_Id = i_Company_Id
                 and q.Filial_Id = i_Filial_Id
                 and q.Parent_Id = i_Division_Id
                 and Hd.Manager_Status = Hrm_Pref.c_Division_Manager_Status_Auto
                 and q.Lvl = (select min(p.Lvl)
                                from Mhr_Parent_Divisions p
                                join Hrm_Divisions d
                                  on d.Company_Id = p.Company_Id
                                 and d.Filial_Id = p.Filial_Id
                                 and d.Division_Id = p.Parent_Id
                               where p.Company_Id = q.Company_Id
                                 and p.Filial_Id = q.Filial_Id
                                 and p.Division_Id = q.Division_Id
                                 and (p.Parent_Id = q.Parent_Id or
                                     d.Manager_Status = Hrm_Pref.c_Division_Manager_Status_Manual)
                                 and p.Lvl <= q.Lvl))
    loop
      if i_New_Manager_Id is not null then
        Division_Manager_Save(i_Company_Id  => i_Company_Id,
                              i_Filial_Id   => i_Filial_Id,
                              i_Division_Id => r.Division_Id,
                              i_Robot_Id    => i_New_Manager_Id);
      else
        Division_Manager_Delete(i_Company_Id  => i_Company_Id,
                                i_Filial_Id   => i_Filial_Id,
                                i_Division_Id => r.Division_Id);
      end if;
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Fix_Employee_Divisions
  (
    i_Company_Id   number,
    i_Filial_Id    number,
    i_Employee_Id  number,
    i_Division_Ids Array_Number
  ) is
    r_Setting      Hrm_Settings%rowtype;
    v_Robot_Id     number;
    v_Division_Ids Array_Number := Array_Number();
  begin
    r_Setting := Hrm_Util.Load_Setting(i_Company_Id => i_Company_Id, --
                                       i_Filial_Id  => i_Filial_Id);
  
    if r_Setting.Position_Enable = 'N' then
      begin
        select r.Robot_Id
          into v_Robot_Id
          from Mrf_Robots r
         where r.Company_Id = i_Company_Id
           and r.Filial_Id = i_Filial_Id
           and r.Person_Id = i_Employee_Id
           and Rownum = 1;
      exception
        when No_Data_Found then
          v_Robot_Id := null;
      end;
    
      v_Division_Ids := Hrm_Util.Fix_Allowed_Divisions(i_Company_Id           => i_Company_Id,
                                                       i_Filial_Id            => i_Filial_Id,
                                                       i_Robot_Id             => v_Robot_Id,
                                                       i_Allowed_Division_Ids => i_Division_Ids);
    
      for r in (select *
                  from Href_Employee_Divisions Ed
                 where Ed.Company_Id = i_Company_Id
                   and Ed.Filial_Id = i_Filial_Id
                   and Ed.Employee_Id = i_Employee_Id
                   and Ed.Division_Id not member of v_Division_Ids)
      loop
        z_Href_Employee_Divisions.Delete_One(i_Company_Id  => r.Company_Id,
                                             i_Filial_Id   => r.Filial_Id,
                                             i_Employee_Id => r.Employee_Id,
                                             i_Division_Id => r.Division_Id);
      end loop;
    
      for i in 1 .. v_Division_Ids.Count
      loop
        z_Href_Employee_Divisions.Insert_Try(i_Company_Id  => i_Company_Id,
                                             i_Filial_Id   => i_Filial_Id,
                                             i_Employee_Id => i_Employee_Id,
                                             i_Division_Id => v_Division_Ids(i));
      end loop;
    
      if v_Robot_Id is not null then
        Hrm_Core.Fix_Robot_Divisions(i_Company_Id           => i_Company_Id,
                                     i_Filial_Id            => i_Filial_Id,
                                     i_Robot_Id             => v_Robot_Id,
                                     i_Allowed_Division_Ids => v_Division_Ids);
      end if;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Division_Save(i_Division Hrm_Pref.Division_Rt) is
    r_Division Mhr_Divisions%rowtype := i_Division.Division;
    r_Hrm_Old  Hrm_Divisions%rowtype;
    r_Settings Hrm_Settings%rowtype := Hrm_Util.Load_Setting(i_Company_Id => r_Division.Company_Id,
                                                             i_Filial_Id  => r_Division.Filial_Id);
  
    v_Parent_Department_Id number;
    v_Is_Department        varchar2(1) := i_Division.Is_Department;
    v_Manager_Id           number := i_Division.Manager_Id;
    v_Manager_Status       varchar2(1) := Hrm_Pref.c_Division_Manager_Status_Manual;
    v_Kind_Changed         boolean := false;
    v_Parent_Changed       boolean := false;
  begin
    if v_Is_Department = 'N' and r_Settings.Advanced_Org_Structure = 'N' then
      v_Is_Department := 'Y';
    end if;
  
    if z_Hrm_Divisions.Exist_Lock(i_Company_Id  => r_Division.Company_Id,
                                  i_Filial_Id   => r_Division.Filial_Id,
                                  i_Division_Id => r_Division.Division_Id,
                                  o_Row         => r_Hrm_Old) then
      if r_Hrm_Old.Is_Department <> v_Is_Department then
        Hrm_Core.Assert_Department_Status_Changeable(i_Company_Id    => r_Division.Company_Id,
                                                     i_Filial_Id     => r_Division.Filial_Id,
                                                     i_Division_Id   => r_Division.Division_Id,
                                                     i_Is_Department => v_Is_Department);
      
        v_Kind_Changed := true;
      end if;
    end if;
  
    Mhr_Api.Division_Save(r_Division);
  
    v_Parent_Department_Id := Hrm_Util.Closest_Parent_Department_Id(i_Company_Id  => r_Division.Company_Id,
                                                                    i_Filial_Id   => r_Division.Filial_Id,
                                                                    i_Division_Id => r_Division.Division_Id);
  
    if r_Hrm_Old.Company_Id is not null and
       not Fazo.Equal(r_Hrm_Old.Parent_Department_Id, v_Parent_Department_Id) then
      Hrm_Core.Assert_Division_Parent_Changeable(i_Company_Id    => r_Division.Company_Id,
                                                 i_Filial_Id     => r_Division.Filial_Id,
                                                 i_Division_Id   => r_Division.Division_Id,
                                                 i_Is_Department => v_Is_Department);
    
      v_Parent_Changed := true;
    end if;
  
    if v_Parent_Department_Id is null and v_Is_Department = 'N' then
      Hrm_Error.Raise_027(Hrm_Util.t_Division_Kind_Team);
    end if;
  
    if v_Is_Department = 'N' and v_Manager_Id is null then
      v_Manager_Status := Hrm_Pref.c_Division_Manager_Status_Auto;
    
      v_Manager_Id := z_Mrf_Division_Managers.Take(i_Company_Id => r_Division.Company_Id, --
                      i_Filial_Id => r_Division.Filial_Id, --
                      i_Division_Id => r_Division.Parent_Id).Manager_Id;
    end if;
  
    z_Hrm_Divisions.Save_One(i_Company_Id           => r_Division.Company_Id,
                             i_Filial_Id            => r_Division.Filial_Id,
                             i_Division_Id          => r_Division.Division_Id,
                             i_Parent_Department_Id => v_Parent_Department_Id,
                             i_Is_Department        => v_Is_Department,
                             i_Manager_Status       => v_Manager_Status,
                             i_Subfilial_Id         => i_Division.Subfilial_Id);
  
    if v_Manager_Id is not null then
      Division_Manager_Save(i_Company_Id  => r_Division.Company_Id,
                            i_Filial_Id   => r_Division.Filial_Id,
                            i_Division_Id => r_Division.Division_Id,
                            i_Robot_Id    => v_Manager_Id);
    else
      Division_Manager_Delete(i_Company_Id  => r_Division.Company_Id,
                              i_Filial_Id   => r_Division.Filial_Id,
                              i_Division_Id => r_Division.Division_Id);
    end if;
  
    Update_Child_Manager(i_Company_Id     => r_Division.Company_Id,
                         i_Filial_Id      => r_Division.Filial_Id,
                         i_Division_Id    => r_Division.Division_Id,
                         i_New_Manager_Id => v_Manager_Id);
  
    Division_Schedule_Save(i_Company_Id  => r_Division.Company_Id,
                           i_Filial_Id   => r_Division.Filial_Id,
                           i_Division_Id => r_Division.Division_Id,
                           i_Schedule_Id => i_Division.Schedule_Id);
  
    if v_Kind_Changed or v_Parent_Changed then
      Hrm_Core.Update_Parent_Departments(i_Company_Id    => r_Division.Company_Id,
                                         i_Filial_Id     => r_Division.Filial_Id,
                                         i_Division_Id   => r_Division.Division_Id,
                                         i_Old_Parent_Id => case
                                                              when r_Hrm_Old.Is_Department = 'Y' then
                                                               r_Division.Division_Id
                                                              else
                                                               r_Hrm_Old.Parent_Department_Id
                                                            end,
                                         i_New_Parent_Id => case
                                                              when v_Is_Department = 'Y' then
                                                               r_Division.Division_Id
                                                              else
                                                               v_Parent_Department_Id
                                                            end);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Job_Bonus_Type(i_Job_Bonus_Type Hrm_Pref.Job_Bonus_Type_Rt) is
  begin
    delete from Hrm_Job_Bonus_Types q
     where q.Company_Id = i_Job_Bonus_Type.Company_Id
       and q.Filial_Id = i_Job_Bonus_Type.Filial_Id
       and q.Job_Id = i_Job_Bonus_Type.Job_Id
       and q.Bonus_Type not member of i_Job_Bonus_Type.Bonus_Types;
  
    for i in 1 .. i_Job_Bonus_Type.Bonus_Types.Count
    loop
      z_Hrm_Job_Bonus_Types.Save_One(i_Company_Id => i_Job_Bonus_Type.Company_Id,
                                     i_Filial_Id  => i_Job_Bonus_Type.Filial_Id,
                                     i_Job_Id     => i_Job_Bonus_Type.Job_Id,
                                     i_Bonus_Type => i_Job_Bonus_Type.Bonus_Types(i),
                                     i_Percentage => i_Job_Bonus_Type.Percentages(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Hidden_Salary_Job_Group_Save
  (
    i_Company_Id    number,
    i_Job_Group_Ids Array_Number
  ) is
  begin
    for i in 1 .. i_Job_Group_Ids.Count
    loop
      z_Hrm_Hidden_Salary_Job_Groups.Insert_Try(i_Company_Id   => i_Company_Id,
                                                i_Job_Group_Id => i_Job_Group_Ids(i));
    end loop;
  
    delete from Hrm_Hidden_Salary_Job_Groups q
     where q.Company_Id = i_Company_Id
       and q.Job_Group_Id not member of i_Job_Group_Ids;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Save_Restrict_To_View_All_Salaries
  (
    i_Company_Id number,
    i_Value      varchar2
  ) is
  begin
    if i_Value not in ('Y', 'N') then
      Hrm_Error.Raise_019(i_Value);
    end if;
  
    Md_Api.Preference_Save(i_Company_Id => i_Company_Id,
                           i_Filial_Id  => Md_Pref.Filial_Head(i_Company_Id),
                           i_Code       => Hrm_Pref.c_Pref_Restrict_To_View_All_Salaries,
                           i_Value      => i_Value);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Save_Restrict_All_Salaries
  (
    i_Company_Id number,
    i_Value      varchar2
  ) is
  begin
    if i_Value not in ('Y', 'N') then
      Hrm_Error.Raise_029(i_Value);
    end if;
  
    Md_Api.Preference_Save(i_Company_Id => i_Company_Id,
                           i_Filial_Id  => Md_Pref.Filial_Head(i_Company_Id),
                           i_Code       => Hrm_Pref.c_Pref_Restrict_All_Salaries,
                           i_Value      => i_Value);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Set_Closed_Date_To_Robot
  (
    i_Company_Id  number,
    i_Filial_Id   number,
    i_Robot_Id    number,
    i_Closed_Date date
  ) is
    r_Robot Mrf_Robots%rowtype;
  begin
    r_Robot := z_Mrf_Robots.Lock_Load(i_Company_Id => i_Company_Id,
                                      i_Filial_Id  => i_Filial_Id,
                                      i_Robot_Id   => i_Robot_Id);
  
    Hrm_Util.Access_To_Set_Closed_Date(i_Company_Id => i_Company_Id,
                                       i_Filial_Id  => i_Filial_Id,
                                       i_Robot_Id   => i_Robot_Id,
                                       i_Robot_Name => r_Robot.Name);
  
    z_Hrm_Robots.Update_One(i_Company_Id  => i_Company_Id,
                            i_Filial_Id   => i_Filial_Id,
                            i_Robot_Id    => i_Robot_Id,
                            i_Closed_Date => Option_Date(i_Closed_Date));
  
    Hrm_Core.Robot_Close(i_Company_Id => i_Company_Id,
                         i_Filial_Id  => i_Filial_Id,
                         i_Robot_Id   => i_Robot_Id,
                         i_Close_Date => i_Closed_Date);
  
    Hrm_Core.Dirty_Robots_Revise(i_Company_Id => i_Company_Id, i_Filial_Id => i_Filial_Id);
  end;

end Hrm_Api;
/
