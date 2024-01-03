create or replace package Ui_Vhr98 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Langs return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Badge_Templates return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Query_Job_Groups return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Function Get_Exceeded_Employees_From_Fte_Limit(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure save(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Activate_Timepad_User;
end Ui_Vhr98;
/
create or replace package body Ui_Vhr98 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Langs return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('md_langs', Fazo.Zip_Map('state', 'A'), true);
  
    q.Varchar2_Field('lang_code', 'name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Badge_Templates return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('href_badge_templates', Fazo.Zip_Map('state', 'A'), true);
  
    q.Number_Field('badge_template_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Job_Groups return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('mhr_job_groups', Fazo.Zip_Map('company_id', Ui.Company_Id, 'state', 'A'), true);
  
    q.Number_Field('job_group_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Get_Exceeded_Employees_From_Fte_Limit(p Hashmap) return Hashmap is
    v_Company_Id   number := Ui.Company_Id;
    v_Fte_Limit    number := Nvl(p.o_Number('fte_limit'), Href_Pref.c_Fte_Limit_Default);
    v_Current_Date date := Trunc(sysdate);
    v_Matrix       Matrix_Varchar2;
    result         Hashmap := Hashmap();
  begin
    select Array_Varchar2((select w.Name
                            from Mr_Natural_Persons w
                           where w.Company_Id = v_Company_Id
                             and w.Person_Id = q.Employee_Id), -- employee name
                          Listagg((select f.Name
                                    from Md_Filials f
                                   where f.Company_Id = v_Company_Id
                                     and f.Filial_Id = q.Filial_Id),
                                  ', '), -- filial name
                          sum(q.Fte)) -- total fte
      bulk collect
      into v_Matrix
      from Href_Staffs q
     where q.Company_Id = v_Company_Id
       and q.State = 'A'
       and q.Hiring_Date <= v_Current_Date
       and (q.Dismissal_Date is null or q.Dismissal_Date >= v_Current_Date)
       and exists (select 1
              from Md_Filials f
             where f.Company_Id = q.Company_Id
               and f.Filial_Id = q.Filial_Id
               and f.State = 'A')
     group by q.Employee_Id
    having sum(q.Fte) > v_Fte_Limit;
  
    Result.Put('exceeded_employees_from_fte_limit', Fazo.Zip_Matrix(v_Matrix));
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function References return Hashmap is
    result Hashmap;
  begin
    result := Fazo.Zip_Map('tt_input',
                           Htt_Util.t_Track_Type(Htt_Pref.c_Track_Type_Input),
                           'tt_output',
                           Htt_Util.t_Track_Type(Htt_Pref.c_Track_Type_Output),
                           'tt_check',
                           Htt_Util.t_Track_Type(Htt_Pref.c_Track_Type_Check),
                           'gps_tracking_distance_min',
                           Hes_Pref.c_Staff_Gps_Tracking_Distance_Min,
                           'gps_tracking_interval_min',
                           Hes_Pref.c_Staff_Gps_Tracking_Interval_Min);
  
    Result.Put('gtqk_custom', Hes_Pref.c_Gps_Tracking_Qualty_Kind_Custom);
    Result.Put('gps_tracking_quality_kinds',
               Fazo.Zip_Matrix_Transposed(Hes_Util.Gps_Tracking_Qualty_Kinds));
  
    -- verify person uniqueness
    Result.Put('vpu_column_name', Href_Pref.c_Vpu_Column_Name);
    Result.Put('vpu_column_passport_number', Href_Pref.c_Vpu_Column_Passport_Number);
    Result.Put('vpu_column_npin', Href_Pref.c_Vpu_Column_Npin);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Model return Hashmap is
    v_Staff_Settings         Hes_Pref.Staff_Track_Settings_Rt;
    v_Gps_Tracking_Settings  Hes_Pref.Staff_Gps_Tracking_Settings_Rt;
    v_Face_Register_Settings Hes_Pref.Staff_Face_Register_Rt;
    v_Request_Settings       Hes_Pref.Staff_Request_Manager_Approval_Rt;
    v_Change_Settings        Hes_Pref.Staff_Change_Manager_Approval_Rt;
    v_Change_Day_Limit       Hes_Pref.Change_Day_Limit_Rt;
    v_Timepad_Settings       Hes_Pref.Timepad_Track_Settings_Rt;
    v_Fte_Limit              Href_Pref.Fte_Limit_Rt;
    r_Settings               Hrm_Settings%rowtype;
    r_Timepad_User           Md_Users%rowtype;
    r_Timepad_Role           Md_Roles%rowtype;
    v_References             Hashmap := Hashmap();
    v_Badge_Template_Id      number;
    v_Company_Id             number := Ui.Company_Id;
    v_Filial_Id              number := Ui.Filial_Id;
    v_Filial_Head            number := Md_Pref.Filial_Head(v_Company_Id);
    v_Job_Groups             Matrix_Varchar2;
    result                   Hashmap := Hashmap();
  begin
    -- general settings
    Result.Put('duplicate_prevention', Hface_Util.Duplicate_Prevention(v_Company_Id));
    Result.Put('pin_autogenerate', Htt_Util.Pin_Autogenerate(v_Company_Id));
    Result.Put('photo_as_face_rec', Htt_Util.Photo_As_Face_Rec(v_Company_Id));
    Result.Put('overtime_coef', Hpr_Util.Load_Overtime_Coef(v_Company_Id));
    Result.Put('use_task_manager', Hes_Util.Load_Use_Task_Manager(v_Company_Id));
    Result.Put('user_single_device',
               case when Mt_Pref.User_Single_Device(v_Company_Id) then 'Y' else 'N' end);
    v_References.Put('overtime_coef_default', Hpr_Pref.c_Overtime_Coef_Default);
  
    v_Fte_Limit := Href_Util.Load_Fte_Limit(v_Company_Id);
  
    Result.Put('fte_limit_setting', v_Fte_Limit.Fte_Limit_Setting);
  
    if v_Fte_Limit.Fte_Limit_Setting = 'Y' then
      Result.Put('fte_limit', v_Fte_Limit.Fte_Limit);
    end if;
  
    v_References.Put('fte_limit_default', Href_Pref.c_Fte_Limit_Default);
  
    -- verify person uniqueness
    Result.Put('vpu_setting', Href_Util.Verify_Person_Uniqueness_Setting(Ui.Company_Id));
    Result.Put('vpu_column', Href_Util.Verify_Person_Uniqueness_Column(Ui.Company_Id));
  
    -- timepad settings
    v_Timepad_Settings := Hes_Util.Timepad_Track_Settings(v_Company_Id);
  
    Result.Put('timepad_qr_code_limit_time', v_Timepad_Settings.Qr_Code_Limit_Time);
    Result.Put('timepad_track_types', v_Timepad_Settings.Track_Types);
    Result.Put('timepad_mark_types', v_Timepad_Settings.Mark_Types);
    Result.Put('timepad_emotion_types', v_Timepad_Settings.Emotion_Types);
    Result.Put('timepad_lang_code', v_Timepad_Settings.Lang_Code);
    Result.Put('timepad_lang_name', z_Md_Langs.Load(v_Timepad_Settings.Lang_Code).Name);
  
    -- timepad user
    r_Timepad_User := z_Md_Users.Take(i_Company_Id => v_Company_Id,
                                      i_User_Id    => z_Href_Timepad_Users.Take(v_Company_Id).User_Id);
    r_Timepad_Role := z_Md_Roles.Take(i_Company_Id => v_Company_Id,
                                      i_Role_Id    => Md_Pref.Role_Id(i_Company_Id => v_Company_Id,
                                                                      i_Pcode      => Href_Pref.c_Pcode_Role_Timepad));
    Result.Put('timepad_user',
               Fazo.Zip_Map('user_state',
                            Nvl(r_Timepad_User.State, 'P'),
                            'filial_attached',
                            case when z_Md_User_Filials.Exist(i_Company_Id => v_Company_Id,
                                                    i_User_Id    => r_Timepad_User.User_Id,
                                                    i_Filial_Id  => v_Filial_Head) then 'Y' else 'N' end,
                            'role_granted',
                            case when z_Md_User_Roles.Exist(i_Company_Id => v_Company_Id,
                                                  i_User_Id    => r_Timepad_User.User_Id,
                                                  i_Filial_Id  => v_Filial_Head,
                                                  i_Role_Id    => r_Timepad_Role.Role_Id) then 'Y' else 'N' end,
                            'role_state',
                            Nvl(r_Timepad_Role.State, 'P'),
                            'project_attached',
                            case when
                            z_Md_Role_Projects.Exist(i_Company_Id   => v_Company_Id,
                                                     i_Role_Id      => r_Timepad_Role.Role_Id,
                                                     i_Project_Code => Verifix.Project_Code) then 'Y' else 'N' end));
  
    -- column required settings
    Result.Put('col_required_settings', Uit_Href.Col_Required_Settings);
  
    -- company badge template
    v_Badge_Template_Id := Href_Util.Company_Badge_Template_Id(v_Company_Id);
  
    Result.Put('badge_template_id', v_Badge_Template_Id);
    Result.Put('badge_template_name', z_Href_Badge_Templates.Take(v_Badge_Template_Id).Name);
  
    -- job groups whose salary hidden
    select Array_Varchar2(w.Job_Group_Id,
                          (select q.Name
                             from Mhr_Job_Groups q
                            where q.Company_Id = w.Company_Id
                              and q.Job_Group_Id = w.Job_Group_Id))
      bulk collect
      into v_Job_Groups
      from Hrm_Hidden_Salary_Job_Groups w
     where w.Company_Id = v_Company_Id;
  
    Result.Put('job_groups', Fazo.Zip_Matrix(v_Job_Groups));
    Result.Put('restrict_to_view_salaries', Hrm_Util.Restrict_To_View_All_Salaries(v_Company_Id));
    Result.Put('restrict_all_salaries', Hrm_Util.Restrict_All_Salaries(v_Company_Id));
  
    if not Ui.Is_Filial_Head then
      -- autogen staff number
      r_Settings := Hrm_Util.Load_Setting(i_Company_Id => v_Company_Id, i_Filial_Id => v_Filial_Id);
    
      Result.Put('autogen_staff_number', r_Settings.Autogen_Staff_Number);
      Result.Put('advanced_org_structure', r_Settings.Advanced_Org_Structure);
    
      -- staff settings data
      v_Staff_Settings := Hes_Util.Staff_Track_Settings(i_Company_Id => v_Company_Id,
                                                        i_Filial_Id  => v_Filial_Id);
    
      Result.Put('staff_track_type_input', v_Staff_Settings.Track_Type_Input);
      Result.Put('staff_track_type_output', v_Staff_Settings.Track_Type_Output);
      Result.Put('staff_track_type_check', v_Staff_Settings.Track_Type_Check);
      Result.Put('staff_track_by_qr_code', v_Staff_Settings.Track_By_Qr_Code);
      Result.Put('staff_track_potential', v_Staff_Settings.Track_Potential);
      Result.Put('staff_track_check_location', v_Staff_Settings.Track_Check_Location);
      Result.Put('staff_track_start', v_Staff_Settings.Track_Start);
      Result.Put('staff_gps_determination', v_Staff_Settings.Gps_Determination);
      Result.Put('staff_face_recognition', v_Staff_Settings.Face_Recognition);
      Result.Put('staff_ignore_invalid_track', v_Staff_Settings.Ignore_Invalid_Track);
      Result.Put('staff_emotion_wink', v_Staff_Settings.Emotion_Wink);
      Result.Put('staff_emotion_smile', v_Staff_Settings.Emotion_Smile);
      Result.Put('staff_last_track_type', v_Staff_Settings.Last_Track_Type);
    
      -- gps tracking settings
      v_Gps_Tracking_Settings := Hes_Util.Staff_Gps_Tracking_Settings(i_Company_Id => v_Company_Id,
                                                                      i_Filial_Id  => v_Filial_Id);
    
      Result.Put('staff_gps_tracking', v_Gps_Tracking_Settings.Enabled);
      Result.Put('staff_gps_tracking_gps_track_collect',
                 v_Gps_Tracking_Settings.Gps_Track_Collect_Enabled);
      Result.Put('staff_gps_tracking_auto_output', v_Gps_Tracking_Settings.Auto_Output_Enabled);
      Result.Put('disable_auto_checkout', v_Gps_Tracking_Settings.Disable_Auto_Checkout);
      Result.Put('staff_gps_tracking_distance', v_Gps_Tracking_Settings.Distance);
      Result.Put('staff_gps_tracking_interval', v_Gps_Tracking_Settings.Interval);
      Result.Put('staff_gps_tracking_quality_kind',
                 Hes_Util.Gps_Tracking_Qualty_Kind(i_Distance => v_Gps_Tracking_Settings.Distance,
                                                   i_Interval => v_Gps_Tracking_Settings.Interval));
    
      -- face registration
      v_Face_Register_Settings := Hes_Util.Staff_Face_Register_Settings(i_Company_Id => v_Company_Id,
                                                                        i_Filial_Id  => v_Filial_Id);
    
      Result.Put('face_register', v_Face_Register_Settings.Face_Register);
      Result.Put('allow_gallery', v_Face_Register_Settings.Allow_Gallery);
    
      -- request manager approval
      v_Request_Settings := Hes_Util.Staff_Request_Manager_Approval_Settings(i_Company_Id => v_Company_Id,
                                                                             i_Filial_Id  => v_Filial_Id);
    
      Result.Put('request_change_status', v_Request_Settings.Request_Settings);
      Result.Put('enable_request', v_Request_Settings.Enable_Request);
    
      -- change schedule manager approval
      v_Change_Settings := Hes_Util.Staff_Change_Manager_Approval_Settings(i_Company_Id => v_Company_Id,
                                                                           i_Filial_Id  => v_Filial_Id);
    
      Result.Put('change_schedule_status', v_Change_Settings.Change_Settings);
      Result.Put('enable_schedule_change', v_Change_Settings.Enable_Schedule_Change);
    
      -- change day limit
      v_Change_Day_Limit := Hes_Util.Staff_Change_Day_Limit_Settings(i_Company_Id => v_Company_Id,
                                                                     i_Filial_Id  => v_Filial_Id);
    
      Result.Put('change_with_restriction_days', v_Change_Day_Limit.Change_With_Restriction_Days);
    
      if v_Change_Day_Limit.Change_With_Restriction_Days = 'Y' then
        Result.Put('change_restriction_days', v_Change_Day_Limit.Change_Restriction_Days);
      end if;
    
      Result.Put('change_with_monthly_limit', v_Change_Day_Limit.Change_With_Monthly_Limit);
    
      if v_Change_Day_Limit.Change_With_Monthly_Limit = 'Y' then
        Result.Put('change_monthly_limit', v_Change_Day_Limit.Change_Monthly_Limit);
      end if;
    
      -- testing period change
      Result.Put('testing_period_change',
                 Hln_Util.Testing_Period_Change_Setting_Load(i_Company_Id => v_Company_Id,
                                                             i_Filial_Id  => v_Filial_Id));
    
      -- location sync person global     
      Result.Put('location_sync_person_global',
                 Htt_Util.Location_Sync_Global_Load(i_Company_Id => v_Company_Id,
                                                    i_Filial_Id  => v_Filial_Id));
    
      -- track trim settings
      Result.Put('schedule_trim_tracks',
                 Htt_Util.Schedule_Trim_Tracks(i_Company_Id => v_Company_Id,
                                               i_Filial_Id  => v_Filial_Id));
    
      -- references
      v_References.Put_All(References);
    end if;
  
    Result.Put('references', v_References);
  
    -- token expires in
    Result.Put('token_expires_in', Kauth_Pref.Token_Expires_In(v_Company_Id));
    Result.Put('token_expires_in_default', Kauth_Pref.c_Token_Expires_In);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure save(p Hashmap) is
    v_Staff_Track_Settings   Hes_Pref.Staff_Track_Settings_Rt;
    v_Gps_Tracking_Settings  Hes_Pref.Staff_Gps_Tracking_Settings_Rt;
    v_Timepad_Settings       Hes_Pref.Timepad_Track_Settings_Rt;
    v_Face_Register_Settings Hes_Pref.Staff_Face_Register_Rt;
    v_Request_Settings       Hes_Pref.Staff_Request_Manager_Approval_Rt;
    v_Change_Settings        Hes_Pref.Staff_Change_Manager_Approval_Rt;
    v_Change_Day_Limit       Hes_Pref.Change_Day_Limit_Rt;
    v_Col_Required_Settings  Href_Pref.Col_Required_Setting_Rt;
    v_Crs_Hashmap            Hashmap := p.r_Hashmap('col_required_settings');
    v_Fte_Limit              Href_Pref.Fte_Limit_Rt;
    r_Settings               Hrm_Settings%rowtype;
    v_Company_Id             number := Ui.Company_Id;
    v_Filial_Id              number := Ui.Filial_Id;
  begin
    -- general settings
    Hface_Api.Duplicate_Prevention_Save(i_Company_Id => v_Company_Id,
                                        i_Value      => p.o_Varchar2('duplicate_prevention'));
    Htt_Api.Pin_Autogenerate_Save(i_Company_Id => v_Company_Id,
                                  i_Value      => p.r_Varchar2('pin_autogenerate'));
    Htt_Api.Photo_As_Face_Rec_Save(i_Company_Id => v_Company_Id,
                                   i_Value      => p.r_Varchar2('photo_as_face_rec'));
    Hpr_Api.Overtime_Coef_Save(i_Company_Id => v_Company_Id,
                               i_Value      => p.o_Number('overtime_coef'));
    Hes_Api.Use_Task_Manager_Save(i_Company_Id => v_Company_Id,
                                  i_Value      => p.o_Varchar2('use_task_manager'));
    Mt_Api.User_Single_Device_Save(i_Company_Id    => v_Company_Id,
                                   i_Single_Device => case p.o_Varchar2('user_single_device')
                                                        when 'Y' then
                                                         true
                                                        else
                                                         false
                                                      end);
  
    v_Fte_Limit.Fte_Limit_Setting := p.r_Varchar2('fte_limit_setting');
  
    if v_Fte_Limit.Fte_Limit_Setting = 'Y' then
      v_Fte_Limit.Fte_Limit := Nvl(p.o_Number('fte_limit'), Href_Pref.c_Fte_Limit_Default);
    end if;
  
    Href_Api.Fte_Limit_Save(i_Company_Id => v_Company_Id, i_Setting => v_Fte_Limit);
  
    -- verify person uniqueness
    Href_Api.Verify_Person_Uniqueness_Setting_Save(i_Company_Id => Ui.Company_Id,
                                                   i_Value      => p.r_Varchar2('vpu_setting'));
    Href_Api.Verify_Person_Uniqueness_Column_Save(i_Company_Id => Ui.Company_Id,
                                                  i_Value      => p.r_Varchar2('vpu_column'));
  
    -- timepad settings
    v_Timepad_Settings.Qr_Code_Limit_Time := p.r_Number('timepad_qr_code_limit_time');
    v_Timepad_Settings.Track_Types        := p.r_Varchar2('timepad_track_types');
    v_Timepad_Settings.Mark_Types         := p.r_Varchar2('timepad_mark_types');
    v_Timepad_Settings.Emotion_Types      := p.r_Varchar2('timepad_emotion_types');
    v_Timepad_Settings.Lang_Code          := p.r_Varchar2('timepad_lang_code');
  
    Hes_Api.Timepad_Track_Settings_Save(i_Company_Id => v_Company_Id,
                                        i_Settings   => v_Timepad_Settings);
  
    -- column required settings save
    v_Col_Required_Settings.Last_Name        := v_Crs_Hashmap.r_Varchar2('last_name');
    v_Col_Required_Settings.Middle_Name      := v_Crs_Hashmap.r_Varchar2('middle_name');
    v_Col_Required_Settings.Birthday         := v_Crs_Hashmap.r_Varchar2('birthday');
    v_Col_Required_Settings.Phone_Number     := v_Crs_Hashmap.r_Varchar2('phone_number');
    v_Col_Required_Settings.Email            := v_Crs_Hashmap.r_Varchar2('email');
    v_Col_Required_Settings.Region           := v_Crs_Hashmap.r_Varchar2('region');
    v_Col_Required_Settings.Address          := v_Crs_Hashmap.r_Varchar2('address');
    v_Col_Required_Settings.Legal_Address    := v_Crs_Hashmap.r_Varchar2('legal_address');
    v_Col_Required_Settings.Passport         := v_Crs_Hashmap.r_Varchar2('passport');
    v_Col_Required_Settings.Npin             := v_Crs_Hashmap.r_Varchar2('npin');
    v_Col_Required_Settings.Iapa             := v_Crs_Hashmap.r_Varchar2('iapa');
    v_Col_Required_Settings.Request_Note     := v_Crs_Hashmap.r_Varchar2('request_note');
    v_Col_Required_Settings.Plan_Change_Note := v_Crs_Hashmap.r_Varchar2('plan_change_note');
  
    if v_Col_Required_Settings.Request_Note = 'Y' then
      v_Col_Required_Settings.Request_Note_Limit := v_Crs_Hashmap.r_Number('request_note_limit');
    end if;
  
    if v_Col_Required_Settings.Plan_Change_Note = 'Y' then
      v_Col_Required_Settings.Plan_Change_Note_Limit := v_Crs_Hashmap.r_Number('plan_change_note_limit');
    end if;
  
    Href_Api.Col_Required_Setting_Save(i_Company_Id => v_Company_Id,
                                       i_Setting    => v_Col_Required_Settings);
  
    -- company badge template save
    Md_Api.Preference_Save(i_Company_Id => v_Company_Id,
                           i_Filial_Id  => Md_Pref.Filial_Head(Ui.Company_Id),
                           i_Code       => Href_Pref.c_Pref_Badge_Template_Id,
                           i_Value      => p.r_Number('badge_template_id'));
  
    -- jobs groups whose salary hidden
    Hrm_Api.Save_Restrict_To_View_All_Salaries(i_Company_Id => v_Company_Id,
                                               i_Value      => p.r_Varchar2('restrict_to_view_salaries'));
    Hrm_Api.Save_Restrict_All_Salaries(i_Company_Id => v_Company_Id,
                                       i_Value      => p.o_Varchar2('restrict_all_salaries'));
    Hrm_Api.Hidden_Salary_Job_Group_Save(i_Company_Id    => v_Company_Id,
                                         i_Job_Group_Ids => p.o_Array_Number('job_group_id'));
  
    if not Ui.Is_Filial_Head then
      -- autogen staff number
      r_Settings                        := Hrm_Util.Load_Setting(i_Company_Id => v_Company_Id,
                                                                 i_Filial_Id  => v_Filial_Id);
      r_Settings.Autogen_Staff_Number   := p.r_Varchar2('autogen_staff_number');
      r_Settings.Advanced_Org_Structure := p.r_Varchar2('advanced_org_structure');
    
      Hrm_Api.Setting_Save(r_Settings);
    
      -- staff settings
      Uit_Hes.Staff_Settings(p => p, p_Staff_Track_Settings => v_Staff_Track_Settings);
    
      -- gps tracking settings
      Uit_Hes.Gps_Tracking_Settings(p => p, p_Gps_Tracking_Settings => v_Gps_Tracking_Settings);
    
      -- face registration
      v_Face_Register_Settings.Face_Register := p.r_Varchar2('face_register');
      v_Face_Register_Settings.Allow_Gallery := p.r_Varchar2('allow_gallery');
    
      if v_Face_Register_Settings.Face_Register = 'N' then
        v_Face_Register_Settings.Allow_Gallery := 'N';
      end if;
    
      -- request manager approval
      v_Request_Settings.Request_Settings := p.r_Varchar2('request_change_status');
      v_Request_Settings.Enable_Request   := p.r_Varchar2('enable_request');
    
      -- change schedule manager approval
      v_Change_Settings.Change_Settings        := p.r_Varchar2('change_schedule_status');
      v_Change_Settings.Enable_Schedule_Change := p.r_Varchar2('enable_schedule_change');
    
      -- change day restriction limit
      v_Change_Day_Limit.Change_With_Restriction_Days := p.r_Varchar2('change_with_restriction_days');
    
      if v_Change_Day_Limit.Change_With_Restriction_Days = 'Y' then
        v_Change_Day_Limit.Change_Restriction_Days := p.r_Number('change_restriction_days');
      end if;
    
      v_Change_Day_Limit.Change_With_Monthly_Limit := p.r_Varchar2('change_with_monthly_limit');
    
      if v_Change_Day_Limit.Change_With_Monthly_Limit = 'Y' then
        v_Change_Day_Limit.Change_Monthly_Limit := p.r_Number('change_monthly_limit');
      end if;
    
      Hes_Api.Settings_Save(i_Company_Id            => v_Company_Id,
                            i_Filial_Id             => v_Filial_Id,
                            i_Staff_Track_Settings  => v_Staff_Track_Settings,
                            i_Gps_Tracking_Settings => v_Gps_Tracking_Settings,
                            i_Face_Register         => v_Face_Register_Settings,
                            i_Request_Settings      => v_Request_Settings,
                            i_Change_Settings       => v_Change_Settings,
                            i_Change_Day_Limit      => v_Change_Day_Limit);
    
      -- testing period change
      Hln_Api.Testing_Period_Change_Setting_Save(i_Company_Id => v_Company_Id,
                                                 i_Filial_Id  => v_Filial_Id,
                                                 i_Value      => p.r_Varchar2('testing_period_change'));
    
      -- location sync person global
      Htt_Api.Location_Sync_Person_Global_Save(i_Company_Id => v_Company_Id,
                                               i_Filial_Id  => v_Filial_Id,
                                               i_Value      => p.r_Varchar2('location_sync_person_global'));
    
      -- track trim settings
      Htt_Api.Schedule_Trim_Tracks_Save(i_Company_Id => v_Company_Id,
                                        i_Filial_Id  => v_Filial_Id,
                                        i_Value      => p.o_Varchar2('schedule_trim_tracks'));
    end if;
  
    -- token expires in
    Kauth_Api.Token_Expires_In_Save(i_Company_Id => v_Company_Id,
                                    i_Value      => Nvl(p.o_Number('token_expires_in'),
                                                        Kauth_Pref.c_Token_Expires_In));
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Activate_Timepad_User is
    r_User         Md_Users%rowtype;
    r_Role         Md_Roles%rowtype;
    r_Timepad_User Href_Timepad_Users%rowtype;
    v_Company_Id   number := Ui.Company_Id;
    v_Company_Head number := Md_Pref.Company_Head;
    v_Filial_Head  number := Md_Pref.Filial_Head(v_Company_Id);
    v_Role_Id      number;
  begin
    r_Role.Role_Id := Md_Pref.Role_Id(i_Company_Id => v_Company_Id,
                                      i_Pcode      => Href_Pref.c_Pcode_Role_Timepad);
  
    -- role create
    if v_Role_Id is not null then
      r_Role := z_Md_Roles.Lock_Load(i_Company_Id => v_Company_Id, i_Role_Id => r_Role.Role_Id);
    else
      z_Md_Roles.Init(p_Row        => r_Role,
                      i_Company_Id => v_Company_Id,
                      i_Role_Id    => Md_Next.Role_Id,
                      i_Name       => 'Timepad',
                      i_State      => 'A',
                      i_Order_No   => 5,
                      i_Pcode      => Href_Pref.c_Pcode_Role_Timepad);
    
      z_Md_Roles.Insert_Row(r_Role);
    
      v_Role_Id := Md_Pref.Role_Id(i_Company_Id => v_Company_Head,
                                   i_Pcode      => Href_Pref.c_Pcode_Role_Timepad);
    
      for q in (select *
                  from Md_Role_Form_Actions f
                 where f.Company_Id = v_Company_Head
                   and f.Role_Id = v_Role_Id)
      loop
        z_Md_Role_Form_Actions.Insert_One(i_Company_Id => v_Company_Id,
                                          i_Role_Id    => r_Role.Role_Id,
                                          i_Form       => q.Form,
                                          i_Action_Key => q.Action_Key);
      end loop;
    
      for q in (select *
                  from Md_Role_Revoked_Columns g
                 where g.Company_Id = v_Company_Head
                   and g.Role_Id = v_Role_Id)
      loop
        z_Md_Role_Revoked_Columns.Insert_One(i_Company_Id  => v_Company_Id,
                                             i_Role_Id     => r_Role.Role_Id,
                                             i_Form        => q.Form,
                                             i_Grid        => q.Grid,
                                             i_Grid_Column => q.Grid_Column);
      end loop;
    
      for q in (select *
                  from Md_Role_Projects k
                 where k.Company_Id = v_Company_Head
                   and k.Role_Id = v_Role_Id)
      loop
        z_Md_Role_Projects.Insert_One(i_Company_Id   => v_Company_Id,
                                      i_Role_Id      => r_Role.Role_Id,
                                      i_Project_Code => q.Project_Code);
      end loop;
    end if;
  
    -- role activate
    if r_Role.State = 'P' then
      r_Role.State := 'A';
    
      Md_Api.Role_Save(r_Role);
    end if;
  
    -- role attach project
    if not z_Md_Role_Projects.Exist(i_Company_Id   => v_Company_Id,
                                    i_Role_Id      => r_Role.Role_Id,
                                    i_Project_Code => Verifix.Project_Code) then
      Md_Api.Role_Add_Project(i_Company_Id   => v_Company_Id,
                              i_Role_Id      => r_Role.Role_Id,
                              i_Project_Code => Verifix.Project_Code);
    end if;
  
    -- user create
    if not z_Href_Timepad_Users.Exist(i_Company_Id => v_Company_Id, o_Row => r_Timepad_User) then
      Href_Api.Create_Timepad_User(v_Company_Id);
    
      r_Timepad_User := z_Href_Timepad_Users.Load(v_Company_Id);
    end if;
  
    r_User := z_Md_Users.Lock_Load(i_Company_Id => v_Company_Id,
                                   i_User_Id    => r_Timepad_User.User_Id);
  
    -- user activate
    if r_User.State = 'P' then
      r_User.State := 'A';
    
      Md_Api.User_Save(r_User);
    end if;
  
    -- user filial attach
    if not z_Md_User_Filials.Exist_Lock(i_Company_Id => v_Company_Id,
                                        i_User_Id    => r_User.User_Id,
                                        i_Filial_Id  => v_Filial_Head) then
      Md_Api.User_Add_Filial(i_Company_Id => v_Company_Id,
                             i_User_Id    => r_User.User_Id,
                             i_Filial_Id  => v_Filial_Head);
    end if;
  
    -- user grant role
    if not z_Md_User_Roles.Exist_Lock(i_Company_Id => v_Company_Id,
                                      i_User_Id    => r_User.User_Id,
                                      i_Filial_Id  => v_Filial_Head,
                                      i_Role_Id    => r_Role.Role_Id) then
      Md_Api.Role_Grant(i_Company_Id => v_Company_Id,
                        i_User_Id    => r_User.User_Id,
                        i_Filial_Id  => v_Filial_Head,
                        i_Role_Id    => r_Role.Role_Id);
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Md_Langs
       set Lang_Code = null,
           name      = null,
           State     = null;
    update Href_Badge_Templates
       set Badge_Template_Id = null,
           name              = null,
           State             = null;
  end;

end Ui_Vhr98;
/
