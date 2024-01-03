PL/SQL Developer Test script 3.0
138
declare
  v_Company_Id number := -1;
  v_Filial_Id  number := -1;

  -------------------------------------------------- 
  Procedure Save_Hrm_Settings is
    r_Setting Hrm_Settings%rowtype;
  begin
    r_Setting := Hrm_Util.Load_Setting(i_Company_Id => v_Company_Id, --
                                       i_Filial_Id  => v_Filial_Id);
  
    r_Setting.Advanced_Org_Structure := 'Y';
  
    Hrm_Api.Setting_Save(r_Setting);
  end;

begin
  Biruni_Route.Context_Begin;
  Ui_Auth.Logon_As_System(v_Company_Id);

  Save_Hrm_Settings;

  for r in (select q.*
              from Hrm_Divisions q
             where q.Company_Id = v_Company_Id
               and q.Filial_Id = v_Filial_Id
               and q.Is_Department = 'Y'
               and exists (select 1
                      from Hr5_Migr_Keys_Store_Two Ks
                     where Ks.Company_Id = v_Company_Id
                       and Ks.Filial_Id = v_Filial_Id
                       and Ks.Key_Name = Hr5_Migr_Pref.c_Ref_Department_Group
                       and Ks.New_Id = q.Division_Id)
               and not exists (select 1
                      from Hrm_Robots Rb
                     where Rb.Company_Id = v_Company_Id
                       and Rb.Filial_Id = v_Filial_Id
                       and Rb.Org_Unit_Id = q.Division_Id))
  loop
    z_Hrm_Divisions.Update_One(i_Company_Id    => v_Company_Id,
                               i_Filial_Id     => v_Filial_Id,
                               i_Division_Id   => r.Division_Id,
                               i_Is_Department => Option_Varchar2('N'));
  end loop;

  for r in (select Dv.Division_Id,
                   (select Pd.Parent_Id
                      from Mhr_Parent_Divisions Pd
                     where Pd.Company_Id = v_Company_Id
                       and Pd.Filial_Id = v_Filial_Id
                       and Pd.Division_Id = Dv.Division_Id
                       and Pd.Lvl = (select min(q.Lvl)
                                       from Mhr_Parent_Divisions q
                                       join Hrm_Divisions p
                                         on p.Company_Id = q.Company_Id
                                        and p.Filial_Id = q.Filial_Id
                                        and p.Division_Id = q.Parent_Id
                                      where q.Company_Id = v_Company_Id
                                        and q.Filial_Id = v_Filial_Id
                                        and q.Division_Id = Dv.Division_Id
                                        and p.Is_Department = 'Y')) Parent_Department_Id
              from Hrm_Divisions Dv
             where Dv.Company_Id = v_Company_Id
               and Dv.Filial_Id = v_Filial_Id)
  loop
    z_Hrm_Divisions.Update_One(i_Company_Id           => v_Company_Id,
                               i_Filial_Id            => v_Filial_Id,
                               i_Division_Id          => r.Division_Id,
                               i_Parent_Department_Id => Option_Number(r.Parent_Department_Id));
  end loop;

  for r in (select q.*, Pm.Manager_Id
              from Hrm_Divisions q
              join Mhr_Divisions p
                on p.Company_Id = q.Company_Id
               and p.Filial_Id = q.Filial_Id
               and p.Division_Id = q.Division_Id
              join Mrf_Division_Managers Pm
                on Pm.Company_Id = q.Company_Id
               and Pm.Filial_Id = q.Filial_Id
               and Pm.Division_Id = q.Parent_Department_Id
             where q.Company_Id = v_Company_Id
               and q.Filial_Id = v_Filial_Id
               and q.Is_Department = 'N'
               and not exists (select 1
                      from Mrf_Division_Managers Dm
                     where Dm.Company_Id = v_Company_Id
                       and Dm.Filial_Id = v_Filial_Id
                       and Dm.Division_Id = q.Division_Id)
               and exists (select 1
                      from Hr5_Migr_Keys_Store_Two Ks
                     where Ks.Company_Id = v_Company_Id
                       and Ks.Filial_Id = v_Filial_Id
                       and Ks.Key_Name = Hr5_Migr_Pref.c_Ref_Department_Group
                       and Ks.New_Id = q.Division_Id))
  loop
    Hrm_Api.Division_Manager_Save(i_Company_Id  => v_Company_Id,
                                  i_Filial_Id   => v_Filial_Id,
                                  i_Division_Id => r.Division_Id,
                                  i_Robot_Id    => r.Manager_Id);
  end loop;

  for r in (select q.*, St.New_Id Team_Id
              from Hrm_Robots q
              join Hr5_Migr_Keys_Store_Two Ks
                on Ks.Company_Id = v_Company_Id
               and Ks.Filial_Id = v_Filial_Id
               and Ks.Key_Name = Hr5_Migr_Pref.c_Robot
               and Ks.New_Id = q.Robot_Id
              join Hr5_Hr_Robots Old_Rb
                on Old_Rb.Robot_Id = Ks.Old_Id
              join Hr5_Migr_Keys_Store_Two St
                on St.Company_Id = v_Company_Id
               and St.Filial_Id = v_Filial_Id
               and St.Key_Name = Hr5_Migr_Pref.c_Ref_Department_Group
               and St.Old_Id = Old_Rb.Group_Id
             where q.Company_Id = v_Company_Id
               and q.Filial_Id = v_Filial_Id)
  loop
    begin
      Hrm_Api.Update_Org_Unit(i_Company_Id  => v_Company_Id,
                              i_Filial_Id   => v_Filial_Id,
                              i_Robot_Id    => r.Robot_Id,
                              i_Org_Unit_Id => r.Team_Id);
    exception
      when others then
        Hr5_Migr_Api.Log_Error(i_Company_Id    => v_Company_Id,
                               i_Table_Name    => 'ERROR:' || Zt.Hrm_Robots.Name,
                               i_Key_Id        => r.Robot_Id,
                               i_Error_Message => Dbms_Utility.Format_Error_Stack || ' ' ||
                                                  Dbms_Utility.Format_Error_Backtrace);
    end;
  end loop;

  Biruni_Route.Context_End;

  Hpd_Core.Staff_Refresh_Cache(i_Company_Id => v_Company_Id);
end;
0
0
