create or replace package Ui_Vhr124 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Roles return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Job_Groups return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Login_Is_Valid(p Hashmap) return varchar2;
  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function save(p Hashmap) return Hashmap;
end Ui_Vhr124;
/
create or replace package body Ui_Vhr124 is
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
    return b.Translate('UI-VHR124:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Roles return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('md_roles', Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A'), true);
  
    q.Number_Field('role_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Job_Groups return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select q.job_group_id, q.name 
                       from mhr_job_groups q 
                      where q.company_id = :company_id 
                        and exists (select 1 
                               from hrm_hidden_salary_job_groups w
                              where w.company_id = q.company_id
                                and w.job_group_id = q.job_group_id)',
                    Fazo.Zip_Map('company_id', Ui.Company_Id));
  
    q.Number_Field('job_group_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Login_Is_Valid(p Hashmap) return varchar2 is
    v_Login   Md_Users.Login%type := Regexp_Replace(p.r_Varchar2('login'), '@', '');
    v_User_Id number := p.o_Number('user_id');
    v_Dummy   varchar2(1);
  begin
    select 'X'
      into v_Dummy
      from Md_Users u
     where u.Company_Id = Ui.Company_Id
       and u.Login = v_Login
       and (v_User_Id is null or u.User_Id <> v_User_Id);
  
    return 'N';
  exception
    when No_Data_Found then
      return 'Y';
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model(p Hashmap) return Hashmap is
    r_Person                Mr_Natural_Persons%rowtype;
    r_User                  Md_Users%rowtype;
    r_Setting               Hrm_Settings%rowtype;
    v_Staff_Settings        Hes_Pref.Staff_Track_Settings_Rt;
    v_Gps_Tracking_Settings Hes_Pref.Staff_Gps_Tracking_Settings_Rt;
    v_Face_Register         Hes_Pref.Staff_Face_Register_Rt;
    v_Request_Settings      Hes_Pref.Staff_Request_Manager_Approval_Rt;
    v_Change_Settings       Hes_Pref.Staff_Change_Manager_Approval_Rt;
    v_Change_Day_Limit      Hes_Pref.Change_Day_Limit_Rt;
  
    v_Company_Id               number := Ui.Company_Id;
    v_Filial_Id                number := Ui.Filial_Id;
    v_User_Id                  number := p.r_Number('person_id');
    v_Access_Hidden_Salary     varchar2(1);
    v_Access_To_Salary_Setting varchar2(1) := Hrm_Util.Restrict_To_View_All_Salaries(Ui.Company_Id);
  
    v_Sctructual_Divs Array_Number;
  
    v_Rec_Logins   Array_Varchar2;
    v_Matrix       Matrix_Varchar2;
    v_Division_Ids Array_Number;
    v_Data         Hashmap := Hashmap;
    result         Hashmap := Hashmap;
  begin
    r_Person := z_Mr_Natural_Persons.Load(i_Company_Id => v_Company_Id, i_Person_Id => v_User_Id);
  
    if z_Md_Users.Exist(i_Company_Id => v_Company_Id, --
                        i_User_Id    => v_User_Id,
                        o_Row        => r_User) then
      select Array_Varchar2(t.Role_Id,
                            (select k.Name
                               from Md_Roles k
                              where k.Company_Id = v_Company_Id
                                and k.Role_Id = t.Role_Id))
        bulk collect
        into v_Matrix
        from Md_User_Roles t
       where t.Company_Id = r_User.Company_Id
         and t.User_Id = r_User.User_Id
         and t.Filial_Id = v_Filial_Id;
    
      v_Data.Put('roles', Fazo.Zip_Matrix(v_Matrix));
      v_Data.Put('user_id', r_User.User_Id);
      v_Data.Put('login', r_User.Login);
    end if;
  
    select Ed.Division_Id
      bulk collect
      into v_Division_Ids
      from Href_Employee_Divisions Ed
     where Ed.Company_Id = v_Company_Id
       and Ed.Filial_Id = v_Filial_Id
       and Ed.Employee_Id = v_User_Id;
  
    v_Data.Put('division_ids', v_Division_Ids);
  
    v_Data.Put('person_id', v_User_Id);
    v_Data.Put('company_code', '@' || z_Md_Companies.Load(v_Company_Id).Code);
    v_Data.Put('password_exists', case when r_User.Password is not null then 'Y' else 'N' end);
    v_Data.Put('code', r_Person.Code);
    v_Data.Put('key_person',
               Nvl(z_Href_Person_Details.Take(i_Company_Id => v_Company_Id, i_Person_Id => v_User_Id).Key_Person,
                   'N'));
    v_Data.Put('state',
               case --
               when r_User.Company_Id is null then 'A' --
               when z_Md_User_Filials.Exist(i_Company_Id => v_Company_Id,
                                       i_User_Id    => v_User_Id,
                                       i_Filial_Id  => v_Filial_Id) then r_User.State --
               else 'P' end);
  
    v_Staff_Settings := Hes_Util.Staff_Track_Settings(i_Company_Id => v_Company_Id,
                                                      i_Filial_Id  => v_Filial_Id,
                                                      i_User_Id    => v_User_Id);
  
    v_Data.Put('staff_track_user_settings', Nvl(v_Staff_Settings.User_Settings, 'N'));
    v_Data.Put('staff_track_type_input', v_Staff_Settings.Track_Type_Input);
    v_Data.Put('staff_track_type_output', v_Staff_Settings.Track_Type_Output);
    v_Data.Put('staff_track_type_check', v_Staff_Settings.Track_Type_Check);
    v_Data.Put('staff_track_check_location', v_Staff_Settings.Track_Check_Location);
    v_Data.Put('staff_track_by_qr_code', v_Staff_Settings.Track_By_Qr_Code);
    v_Data.Put('staff_track_potential', v_Staff_Settings.Track_Potential);
    v_Data.Put('staff_track_start', v_Staff_Settings.Track_Start);
    v_Data.Put('staff_gps_determination', v_Staff_Settings.Gps_Determination);
    v_Data.Put('staff_face_recognition', v_Staff_Settings.Face_Recognition);
    v_Data.Put('staff_emotion_wink', v_Staff_Settings.Emotion_Wink);
    v_Data.Put('staff_emotion_smile', v_Staff_Settings.Emotion_Smile);
    v_Data.Put('staff_ignore_invalid_track', v_Staff_Settings.Ignore_Invalid_Track);
    v_Data.Put('staff_last_track_type', v_Staff_Settings.Last_Track_Type);
  
    v_Gps_Tracking_Settings := Hes_Util.Staff_Gps_Tracking_Settings(i_Company_Id => v_Company_Id,
                                                                    i_Filial_Id  => v_Filial_Id,
                                                                    i_User_Id    => v_User_Id);
  
    v_Data.Put('staff_gps_tracking_user_settings', v_Gps_Tracking_Settings.User_Settings);
    v_Data.Put('staff_gps_tracking', v_Gps_Tracking_Settings.Enabled);
    v_Data.Put('staff_gps_tracking_gps_track_collect',
               v_Gps_Tracking_Settings.Gps_Track_Collect_Enabled);
    v_Data.Put('staff_gps_tracking_auto_output', v_Gps_Tracking_Settings.Auto_Output_Enabled);
    v_Data.Put('disable_auto_checkout', v_Gps_Tracking_Settings.Disable_Auto_Checkout);
    v_Data.Put('staff_gps_tracking_distance', v_Gps_Tracking_Settings.Distance);
    v_Data.Put('staff_gps_tracking_interval', v_Gps_Tracking_Settings.Interval);
    v_Data.Put('staff_gps_tracking_quality_kind',
               Hes_Util.Gps_Tracking_Qualty_Kind(i_Distance => v_Gps_Tracking_Settings.Distance,
                                                 i_Interval => v_Gps_Tracking_Settings.Interval));
  
    v_Face_Register := Hes_Util.Staff_Face_Register_Settings(i_Company_Id => v_Company_Id,
                                                             i_Filial_Id  => v_Filial_Id,
                                                             i_User_Id    => v_User_Id);
  
    v_Data.Put('staff_face_register_user_settings', Nvl(v_Face_Register.User_Settings, 'N'));
    v_Data.Put('staff_face_register', v_Face_Register.Face_Register);
    v_Data.Put('staff_allow_gallery', v_Face_Register.Allow_Gallery);
  
    v_Request_Settings := Hes_Util.Staff_Request_Manager_Approval_Settings(i_Company_Id => v_Company_Id,
                                                                           i_Filial_Id  => v_Filial_Id,
                                                                           i_User_Id    => v_User_Id);
  
    v_Data.Put('request_status_user_settings', Nvl(v_Request_Settings.User_Settings, 'N'));
    v_Data.Put('request_status_settings', v_Request_Settings.Request_Settings);
    v_Data.Put('enable_request', v_Request_Settings.Enable_Request);
  
    v_Change_Settings := Hes_Util.Staff_Change_Manager_Approval_Settings(i_Company_Id => v_Company_Id,
                                                                         i_Filial_Id  => v_Filial_Id,
                                                                         i_User_Id    => v_User_Id);
  
    v_Data.Put('change_status_user_settings', Nvl(v_Change_Settings.User_Settings, 'N'));
    v_Data.Put('change_status_settings', v_Change_Settings.Change_Settings);
    v_Data.Put('enable_schedule_change', v_Change_Settings.Enable_Schedule_Change);
  
    v_Change_Day_Limit := Hes_Util.Staff_Change_Day_Limit_Settings(i_Company_Id => v_Company_Id,
                                                                   i_Filial_Id  => v_Filial_Id,
                                                                   i_User_Id    => v_User_Id);
  
    v_Data.Put('change_restriction_day_user_settings', Nvl(v_Change_Day_Limit.User_Settings, 'N'));
    v_Data.Put('change_with_restriction_days', v_Change_Day_Limit.Change_With_Restriction_Days);
    v_Data.Put('change_restriction_days', v_Change_Day_Limit.Change_Restriction_Days);
    v_Data.Put('change_with_monthly_limit', v_Change_Day_Limit.Change_With_Monthly_Limit);
    v_Data.Put('change_monthly_limit', v_Change_Day_Limit.Change_Monthly_Limit);
    v_Data.Put('access_all_employee',
               Nvl(z_Href_Person_Details.Take(i_Company_Id => v_Company_Id, i_Person_Id => v_User_Id).Access_All_Employees,
                   'N'));
    v_Data.Put('access_to_salary_setting', v_Access_To_Salary_Setting);
  
    if v_Access_To_Salary_Setting = 'Y' then
      v_Access_Hidden_Salary := Nvl(z_Href_Person_Details.Take(i_Company_Id => v_Company_Id, i_Person_Id => v_User_Id).Access_Hidden_Salary,
                                    'N');
    
      v_Data.Put('access_hidden_salary', v_Access_Hidden_Salary);
    
      if v_Access_Hidden_Salary = 'N' then
        select Array_Varchar2(q.Job_Group_Id,
                              (select w.Name
                                 from Mhr_Job_Groups w
                                where w.Company_Id = q.Company_Id
                                  and w.Job_Group_Id = q.Job_Group_Id))
          bulk collect
          into v_Matrix
          from Href_Person_Hidden_Salary_Job_Groups q
         where q.Company_Id = v_Company_Id
           and q.Person_Id = v_User_Id;
      
        v_Data.Put('job_groups', Fazo.Zip_Matrix(v_Matrix));
      end if;
    end if;
  
    -- licensing plan
    if Ui.Grant_Has('licensing_plan') then
      select Array_Varchar2(q.License_Code,
                            q.Name,
                            Nvl((select 'Y'
                                  from Kl_Licensing_Plans Lo
                                 where Lo.Company_Id = v_Company_Id
                                   and Lo.User_Id = v_User_Id
                                   and Lo.License_Code = q.License_Code),
                                'N'))
        bulk collect
        into v_Matrix
        from Md_Licenses q
       where q.Project_Code = Ui.Project_Code
         and q.Kind = Md_Pref.c_Lk_Grant
         and exists (select 1
                from Kl_Licensing_Settings Ls
               where Ls.License_Code = q.License_Code
                 and Ls.Licensing_Type = Kl_Pref.c_Lt_Plan)
         and (v_Company_Id = Md_Pref.c_Company_Head or exists
              (select 1
                 from Md_Company_Projects Cp
                where Cp.Company_Id = v_Company_Id
                  and Cp.Project_Code = q.Project_Code));
    
      v_Data.Put('licensing_plans', Fazo.Zip_Matrix(v_Matrix));
    end if;
  
    Result.Put('data', v_Data);
    Result.Put('tt_input', Htt_Util.t_Track_Type(Htt_Pref.c_Track_Type_Input));
    Result.Put('tt_output', Htt_Util.t_Track_Type(Htt_Pref.c_Track_Type_Output));
    Result.Put('tt_check', Htt_Util.t_Track_Type(Htt_Pref.c_Track_Type_Check));
    Result.Put('gps_tracking_distance_min', Hes_Pref.c_Staff_Gps_Tracking_Distance_Min);
    Result.Put('gps_tracking_interval_min', Hes_Pref.c_Staff_Gps_Tracking_Interval_Min);
    Result.Put('gtqk_custom', Hes_Pref.c_Gps_Tracking_Qualty_Kind_Custom);
    Result.Put('gps_tracking_quality_kinds',
               Fazo.Zip_Matrix_Transposed(Hes_Util.Gps_Tracking_Qualty_Kinds));
  
    -- divisions
    r_Setting := Hrm_Util.Load_Setting(i_Company_Id => v_Company_Id, --
                                       i_Filial_Id  => v_Filial_Id);
  
    Result.Put('position_enable', r_Setting.Position_Enable);
  
    if r_Setting.Position_Enable = 'N' then
      v_Sctructual_Divs := Href_Util.Get_Direct_Divisions(i_Company_Id  => v_Company_Id,
                                                          i_Filial_Id   => v_Filial_Id,
                                                          i_Employee_Id => v_User_Id);
      v_Sctructual_Divs := v_Sctructual_Divs multiset union
                           Href_Util.Get_Child_Divisions(i_Company_Id => v_Company_Id,
                                                         i_Filial_Id  => v_Filial_Id,
                                                         i_Parents    => v_Sctructual_Divs);
    
      select Array_Varchar2(q.Division_Id, q.Name, q.Parent_Id)
        bulk collect
        into v_Matrix
        from Mhr_Divisions q
       where q.Company_Id = v_Company_Id
         and q.Filial_Id = v_Filial_Id
         and (q.State = 'A' or exists
              (select 1
                 from Href_Employee_Divisions Ed
                where Ed.Company_Id = q.Company_Id
                  and Ed.Filial_Id = q.Filial_Id
                  and Ed.Employee_Id = v_User_Id
                  and Ed.Division_Id = q.Division_Id))
         and q.Division_Id not member of v_Sctructual_Divs
       order by Lower(q.Name);
    
      Result.Put('divisions', Fazo.Zip_Matrix(v_Matrix));
    end if;
  
    -- recommended logins
    v_Rec_Logins := Md_Util.Gen_Login(i_Company_Id => v_Company_Id,
                                      i_First_Name => r_Person.First_Name,
                                      i_Last_Name  => r_Person.Last_Name);
    for i in 1 .. v_Rec_Logins.Count
    loop
      v_Rec_Logins(i) := Md_Util.Login_Fixer(v_Rec_Logins(i));
    end loop;
  
    Result.Put('recommended_logins', v_Rec_Logins);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function save(p Hashmap) return Hashmap is
    r_Data                   Md_Users%rowtype;
    r_Person                 Mr_Natural_Persons%rowtype;
    r_Person_Detail          Href_Person_Details%rowtype;
    v_User_Id                number := p.r_Number('person_id');
    v_Login                  varchar2(200) := p.o_Varchar2('login');
    v_Password               varchar2(40) := p.o_Varchar2('password');
    v_Division_Ids           Array_Number := p.o_Array_Number('division_ids');
    v_Staff_Track_Settings   Hes_Pref.Staff_Track_Settings_Rt;
    v_Gps_Tracking_Settings  Hes_Pref.Staff_Gps_Tracking_Settings_Rt;
    v_Face_Register_Settings Hes_Pref.Staff_Face_Register_Rt;
    v_Request_Settings       Hes_Pref.Staff_Request_Manager_Approval_Rt;
    v_Change_Settings        Hes_Pref.Staff_Change_Manager_Approval_Rt;
    v_Change_Day_Limit       Hes_Pref.Change_Day_Limit_Rt;
    v_Role_Ids               Array_Number;
    result                   Hashmap := Hashmap();
  begin
    r_Person := z_Mr_Natural_Persons.Load(i_Company_Id => Ui.Company_Id, i_Person_Id => v_User_Id);
  
    if not z_Md_Users.Exist_Lock(i_Company_Id => r_Person.Company_Id, --
                                 i_User_Id    => v_User_Id,
                                 o_Row        => r_Data) then
    
      r_Data.Company_Id := r_Person.Company_Id;
      r_Data.User_Id    := r_Person.Person_Id;
      r_Data.Name       := r_Person.Name;
      r_Data.User_Kind  := Md_Pref.c_Uk_Normal;
      r_Data.State      := 'A';
    end if;
  
    if v_Login is not null then
      if v_Password is not null then
        r_Data.Password                 := Fazo.Hash_Sha1(v_Password);
        r_Data.Password_Changed_On      := sysdate;
        r_Data.Password_Change_Required := 'Y';
      elsif r_Data.Password is null then
        b.Raise_Error(t('password is required for new user'));
      end if;
    end if;
  
    r_Data.Login := v_Login;
  
    Md_Api.User_Save(r_Data);
  
    if p.r_Varchar2('state') = 'A' then
      if r_Data.State = 'P' then
        Href_Error.Raise_030(r_Data.Name);
      end if;
    
      Md_Api.User_Add_Filial(i_Company_Id => r_Data.Company_Id,
                             i_User_Id    => r_Data.User_Id,
                             i_Filial_Id  => Ui.Filial_Id);
    else
      Md_Api.User_Remove_Filial(i_Company_Id   => r_Data.Company_Id,
                                i_User_Id      => r_Data.User_Id,
                                i_Filial_Id    => Ui.Filial_Id,
                                i_Remove_Roles => false);
    end if;
  
    v_Role_Ids := Nvl(p.o_Array_Number('role_ids'), Array_Number());
  
    for i in 1 .. v_Role_Ids.Count
    loop
      Md_Api.Role_Grant(i_Company_Id => r_Data.Company_Id,
                        i_Filial_Id  => Ui.Filial_Id,
                        i_User_Id    => r_Data.User_Id,
                        i_Role_Id    => v_Role_Ids(i));
    end loop;
  
    for r in (select *
                from Md_User_Roles t
               where t.Company_Id = r_Data.Company_Id
                 and t.Filial_Id = Ui.Filial_Id
                 and t.User_Id = r_Data.User_Id
                 and t.Role_Id not member of v_Role_Ids)
    loop
      Md_Api.Role_Revoke(i_Company_Id => r.Company_Id,
                         i_Filial_Id  => r.Filial_Id,
                         i_User_Id    => r.User_Id,
                         i_Role_Id    => r.Role_Id);
    end loop;
  
    r_Person.Code := p.o_Varchar2('code');
  
    Mr_Api.Natural_Person_Save(r_Person);
  
    -- staff settings
    v_Staff_Track_Settings.User_Settings := p.o_Varchar2('staff_track_user_settings');
  
    if v_Staff_Track_Settings.User_Settings = 'Y' then
      Uit_Hes.Staff_Settings(p => p, p_Staff_Track_Settings => v_Staff_Track_Settings);
    end if;
  
    Hes_Api.Staff_Track_Settings_Save(i_Company_Id => Ui.Company_Id,
                                      i_Filial_Id  => Ui.Filial_Id,
                                      i_User_Id    => v_User_Id,
                                      i_Settings   => v_Staff_Track_Settings);
  
    -- gps tracking settings
    v_Gps_Tracking_Settings.User_Settings := p.o_Varchar2('staff_gps_tracking_user_settings');
  
    if v_Gps_Tracking_Settings.User_Settings = 'Y' then
      Uit_Hes.Gps_Tracking_Settings(p => p, p_Gps_Tracking_Settings => v_Gps_Tracking_Settings);
    end if;
  
    Hes_Api.Staff_Gps_Tracking_Settings_Save(i_Company_Id => Ui.Company_Id,
                                             i_Filial_Id  => Ui.Filial_Id,
                                             i_User_Id    => v_User_Id,
                                             i_Settings   => v_Gps_Tracking_Settings);
  
    if Ui.Grant_Has('licensing_plans') then
      Kl_Api.Licensing_Plan_Save(i_Company_Id    => r_Data.Company_Id,
                                 i_User_Id       => r_Data.User_Id,
                                 i_Project_Code  => Ui.Project_Code,
                                 i_License_Codes => p.r_Array_Varchar2('license_codes'));
    end if;
  
    -- face registration settings
    v_Face_Register_Settings.User_Settings := p.o_Varchar2('staff_face_register_user_settings');
  
    if v_Face_Register_Settings.User_Settings = 'Y' then
      v_Face_Register_Settings.Face_Register := p.r_Varchar2('staff_face_register');
      v_Face_Register_Settings.Allow_Gallery := p.r_Varchar2('staff_allow_gallery');
    
      if v_Face_Register_Settings.Face_Register = 'N' then
        v_Face_Register_Settings.Allow_Gallery := 'N';
      end if;
    end if;
  
    Hes_Api.Staff_Face_Register_Save(i_Company_Id => Ui.Company_Id,
                                     i_Filial_Id  => Ui.Filial_Id,
                                     i_User_Id    => v_User_Id,
                                     i_Settings   => v_Face_Register_Settings);
  
    -- request manager approval settings
    v_Request_Settings.User_Settings := p.o_Varchar2('request_status_user_settings');
  
    if v_Request_Settings.User_Settings = 'Y' then
      v_Request_Settings.Request_Settings := p.r_Varchar2('request_status_settings');
      v_Request_Settings.Enable_Request   := p.r_Varchar2('enable_request');
    end if;
  
    Hes_Api.Staff_Request_Manager_Approval_Save(i_Company_Id => Ui.Company_Id,
                                                i_Filial_Id  => Ui.Filial_Id,
                                                i_User_Id    => v_User_Id,
                                                i_Settings   => v_Request_Settings);
  
    Hes_Api.Staff_Enable_Request_Save(i_Company_Id => Ui.Company_Id,
                                      i_Filial_Id  => Ui.Filial_Id,
                                      i_User_Id    => v_User_Id,
                                      i_Settings   => v_Request_Settings);
  
    -- change schedule manager approval settings
    v_Change_Settings.User_Settings := p.o_Varchar2('change_status_user_settings');
  
    if v_Change_Settings.User_Settings = 'Y' then
      v_Change_Settings.Change_Settings        := p.r_Varchar2('change_status_settings');
      v_Change_Settings.Enable_Schedule_Change := p.r_Varchar2('enable_schedule_change');
    end if;
  
    Hes_Api.Staff_Change_Manager_Approval_Save(i_Company_Id => Ui.Company_Id,
                                               i_Filial_Id  => Ui.Filial_Id,
                                               i_User_Id    => v_User_Id,
                                               i_Settings   => v_Change_Settings);
  
    Hes_Api.Staff_Enable_Schedule_Change_Save(i_Company_Id => Ui.Company_Id,
                                              i_Filial_Id  => Ui.Filial_Id,
                                              i_User_Id    => v_User_Id,
                                              i_Settings   => v_Change_Settings);
  
    -- change day limit
    v_Change_Day_Limit.User_Settings := p.r_Varchar2('change_restriction_day_user_settings');
  
    if v_Change_Day_Limit.User_Settings = 'Y' then
      v_Change_Day_Limit.Change_With_Restriction_Days := p.r_Varchar2('change_with_restriction_days');
    
      if v_Change_Day_Limit.Change_With_Restriction_Days = 'Y' then
        v_Change_Day_Limit.Change_Restriction_Days := p.r_Number('change_restriction_days');
      end if;
    
      v_Change_Day_Limit.Change_With_Monthly_Limit := p.r_Varchar2('change_with_monthly_limit');
    
      if v_Change_Day_Limit.Change_With_Monthly_Limit = 'Y' then
        v_Change_Day_Limit.Change_Monthly_Limit := p.r_Number('change_monthly_limit');
      end if;
    end if;
  
    Hes_Api.Staff_Change_Days_Limit_Save(i_Company_Id => Ui.Company_Id,
                                         i_Filial_Id  => Ui.Filial_Id,
                                         i_User_Id    => v_User_Id,
                                         i_Settings   => v_Change_Day_Limit);
  
    if not z_Href_Person_Details.Exist_Lock(i_Company_Id => Ui.Company_Id,
                                            i_Person_Id  => v_User_Id,
                                            o_Row        => r_Person_Detail) then
      r_Person_Detail.Company_Id := Ui.Company_Id;
      r_Person_Detail.Person_Id  := v_User_Id;
      r_Person_Detail.Key_Person := 'N';
    end if;
  
    r_Person_Detail.Key_Person           := p.r_Varchar2('key_person');
    r_Person_Detail.Access_All_Employees := p.r_Varchar2('access_all_employee');
    r_Person_Detail.Access_Hidden_Salary := p.r_Varchar2('access_hidden_salary');
  
    Href_Api.Person_Detail_Save(r_Person_Detail, false);
  
    -- hidden salary job group
    Href_Api.Person_Hidden_Salary_Job_Groups_Save(i_Company_Id    => Ui.Company_Id,
                                                  i_Person_Id     => v_User_Id,
                                                  i_Job_Group_Ids => p.o_Array_Number('job_group_id'));
  
    -- divisions
    if r_Person_Detail.Access_All_Employees = 'Y' then
      v_Division_Ids := Array_Number();
    end if;
  
    Hrm_Api.Fix_Employee_Divisions(i_Company_Id   => Ui.Company_Id,
                                   i_Filial_Id    => Ui.Filial_Id,
                                   i_Employee_Id  => v_User_Id,
                                   i_Division_Ids => v_Division_Ids);
  
    -- return
    v_Gps_Tracking_Settings := Hes_Util.Staff_Gps_Tracking_Settings(i_Company_Id => Ui.Company_Id,
                                                                    i_Filial_Id  => Ui.Filial_Id,
                                                                    i_User_Id    => v_User_Id);
  
    Result.Put('staff_gps_tracking_user_settings', v_Gps_Tracking_Settings.User_Settings);
    Result.Put('staff_gps_tracking', v_Gps_Tracking_Settings.Enabled);
    Result.Put('staff_gps_tracking_gps_track_collect',
               v_Gps_Tracking_Settings.Gps_Track_Collect_Enabled);
    Result.Put('staff_gps_tracking_auto_output', v_Gps_Tracking_Settings.Auto_Output_Enabled);
    Result.Put('staff_gps_tracking_distance', v_Gps_Tracking_Settings.Distance);
    Result.Put('staff_gps_tracking_interval', v_Gps_Tracking_Settings.Interval);
    Result.Put('staff_gps_tracking_quality_kind',
               Hes_Util.Gps_Tracking_Qualty_Kind(i_Distance => v_Gps_Tracking_Settings.Distance,
                                                 i_Interval => v_Gps_Tracking_Settings.Interval));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Md_Roles
       set Company_Id = null,
           Role_Id    = null,
           name       = null,
           State      = null;
  end;

end Ui_Vhr124;
/
