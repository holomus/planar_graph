create or replace package Ui_Vhr155 is
  ----------------------------------------------------------------------------------------------------  
  Function Model(p Hashmap) return Hashmap;
end Ui_Vhr155;
/
create or replace package body Ui_Vhr155 is
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
    return b.Translate('UI-VHR155:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------   
  Function Model(p Hashmap) return Hashmap is
    r_User                   Md_Users%rowtype;
    v_Staff_Settings         Hes_Pref.Staff_Track_Settings_Rt;
    v_Gps_Tracking_Settings  Hes_Pref.Staff_Gps_Tracking_Settings_Rt;
    v_Face_Register_Settings Hes_Pref.Staff_Face_Register_Rt;
    v_Request_Settings       Hes_Pref.Staff_Request_Manager_Approval_Rt;
    v_Change_Settings        Hes_Pref.Staff_Change_Manager_Approval_Rt;
    v_Track_Types            Array_Varchar2 := Array_Varchar2();
    v_Track_Steps            Array_Varchar2 := Array_Varchar2();
    v_Array                  Array_Varchar2;
    v_User_Id                number := p.r_Number('person_id');
    v_Filial_Id              number := Ui.Filial_Id;
    v_User_Exists            varchar2(1);
    v_Face_Recognition       varchar2(1000);
    v_Step                   varchar2(1000);
    v_Gps_Quality_Kind       varchar2(1);
    v_State                  varchar2(1) := 'P';
    result                   Hashmap := Hashmap;
  begin
    Uit_Href.Assert_Access_To_Employee(i_Employee_Id => v_User_Id,
                                       i_All         => true,
                                       i_Self        => true,
                                       i_Direct      => true,
                                       i_Undirect    => true);
  
    if Ui.Is_Filial_Head then
      v_Filial_Id := p.r_Number('filial_id');
    end if;
  
    if z_Md_Users.Exist(i_Company_Id => Ui.Company_Id, i_User_Id => v_User_Id, o_Row => r_User) then
      v_User_Exists := 'Y';
    
      if z_Md_User_Filials.Exist(i_Company_Id => Ui.Company_Id,
                                 i_User_Id    => v_User_Id,
                                 i_Filial_Id  => Ui.Filial_Id) then
        v_State := 'A';
      end if;
    
      -- filial head
      Result.Put('login', r_User.Login || '@' || z_Md_Companies.Load(Ui.Company_Id).Code);
      Result.Put('state', v_State);
      Result.Put('state_name', Md_Util.Decode(v_State, 'A', Ui.t_Active, 'P', Ui.t_Passive));
    else
      v_User_Exists := 'N';
    end if;
  
    Result.Put('user_exists', v_User_Exists);
  
    select (select k.Name
              from Md_Roles k
             where k.Company_Id = t.Company_Id
               and k.Role_Id = t.Role_Id)
      bulk collect
      into v_Array
      from Md_User_Roles t
     where t.Company_Id = Ui.Company_Id
       and t.User_Id = v_User_Id
       and t.Filial_Id = v_Filial_Id;
  
    Result.Put('roles', Fazo.Gather(v_Array, ', '));
  
    select (select w.Name
              from Mhr_Divisions w
             where w.Company_Id = q.Company_Id
               and w.Filial_Id = q.Filial_Id
               and w.Division_Id = q.Division_Id)
      bulk collect
      into v_Array
      from Href_Employee_Divisions q
     where q.Company_Id = Ui.Company_Id
       and q.Filial_Id = Ui.Filial_Id
       and q.Employee_Id = v_User_Id;
  
    Result.Put('divisions', Fazo.Gather(v_Array, ', '));
  
    v_Staff_Settings := Hes_Util.Staff_Track_Settings(i_Company_Id => Ui.Company_Id,
                                                      i_Filial_Id  => v_Filial_Id,
                                                      i_User_Id    => v_User_Id);
  
    if v_Staff_Settings.Track_Type_Input = 'Y' then
      Fazo.Push(v_Track_Types, t('input'));
    end if;
  
    if v_Staff_Settings.Track_Type_Output = 'Y' then
      Fazo.Push(v_Track_Types, t('output'));
    end if;
  
    if v_Staff_Settings.Track_Type_Check = 'Y' then
      if v_Staff_Settings.Track_Check_Location = 'Y' then
        Fazo.Push(v_Track_Types, t('check(check location)'));
      else
        Fazo.Push(v_Track_Types, t('check'));
      end if;
    end if;
  
    Result.Put('track_types', Fazo.Gather(v_Track_Types, ', '));
  
    if v_Staff_Settings.User_Settings = 'Y' then
      Result.Put('staff_track_user_setting_type', t('personal'));
    else
      Result.Put('staff_track_user_setting_type', t('default'));
    end if;
  
    Result.Put('staff_track_user_settings', v_Staff_Settings.User_Settings);
  
    if v_Staff_Settings.Face_Recognition = 'Y' then
      v_Face_Recognition := t('face_recognition');
    
      case v_Staff_Settings.Emotion_Wink || v_Staff_Settings.Emotion_Smile
        when 'YY' then
          v_Face_Recognition := v_Face_Recognition || '(' || t('emotion_wink') || ', ' ||
                                t('emotion_smile') || ')';
        when 'YN' then
          v_Face_Recognition := v_Face_Recognition || '(' || t('emotion_wink') || ')';
        when 'NY' then
          v_Face_Recognition := v_Face_Recognition || '(' || t('emotion_smile') || ')';
        else
          null;
      end case;
    
      Fazo.Push(v_Track_Steps, v_Face_Recognition);
    end if;
  
    if v_Staff_Settings.Gps_Determination = 'Y' then
      Fazo.Push(v_Track_Steps, t('gps_determination'));
    end if;
  
    if v_Staff_Settings.Track_Start = Hes_Pref.c_Pref_Staff_Ts_Gps_Determination and
       v_Track_Steps.Count = 2 then
      v_Step := v_Track_Steps(2);
      v_Track_Steps(2) := v_Track_Steps(1);
      v_Track_Steps(1) := v_Step;
    end if;
  
    Result.Put('track_steps', Fazo.Gather(v_Track_Steps, '; '));
    Result.Put('staff_last_track_type',
               Md_Util.Decode(v_Staff_Settings.Last_Track_Type, --
                              'Y',
                              t('enabled'),
                              'N',
                              t('not enabled')));
  
    v_Gps_Tracking_Settings := Hes_Util.Staff_Gps_Tracking_Settings(i_Company_Id => Ui.Company_Id,
                                                                    i_Filial_Id  => v_Filial_Id,
                                                                    i_User_Id    => v_User_Id);
  
    v_Gps_Quality_Kind := Hes_Util.Gps_Tracking_Qualty_Kind(i_Distance => v_Gps_Tracking_Settings.Distance,
                                                            i_Interval => v_Gps_Tracking_Settings.Interval);
  
    Result.Put('staff_gps_tracking_user_settings', v_Gps_Tracking_Settings.User_Settings);
    Result.Put('staff_gps_tracking_user_settings_type',
               Md_Util.Decode(v_Gps_Tracking_Settings.User_Settings, --
                              'Y',
                              t('personal'),
                              'N',
                              t('default')));
    Result.Put('staff_gps_tracking', v_Gps_Tracking_Settings.Enabled);
    Result.Put('staff_gps_tracking_type',
               Md_Util.Decode(v_Gps_Tracking_Settings.Enabled, --
                              'Y',
                              t('enabled'),
                              'N',
                              t('not enabled')));
    Result.Put('staff_gps_tracking_gps_track_collect',
               Md_Util.Decode(v_Gps_Tracking_Settings.Gps_Track_Collect_Enabled, --
                              'Y',
                              t('enabled'),
                              'N',
                              t('not enabled')));
    Result.Put('staff_gps_tracking_auto_output',
               Md_Util.Decode(v_Gps_Tracking_Settings.Auto_Output_Enabled, --
                              'Y',
                              t('enabled'),
                              'N',
                              t('not enabled')));
    Result.Put('staff_gps_tracking_distance', v_Gps_Tracking_Settings.Distance);
    Result.Put('staff_gps_tracking_interval', v_Gps_Tracking_Settings.Interval);
    Result.Put('staff_gps_tracking_quality_kind', v_Gps_Quality_Kind);
    Result.Put('staff_gps_tracking_quality_kind_name',
               Hes_Util.t_Gps_Tracking_Qualty_Kind(v_Gps_Quality_Kind));
  
    v_Face_Register_Settings := Hes_Util.Staff_Face_Register_Settings(i_Company_Id => Ui.Company_Id,
                                                                      i_Filial_Id  => v_Filial_Id,
                                                                      i_User_Id    => v_User_Id);
  
    Result.Put('staff_face_register_user_settings', v_Face_Register_Settings.User_Settings);
    Result.Put('staff_face_register_user_settings_type',
               Md_Util.Decode(v_Face_Register_Settings.User_Settings, --
                              'Y',
                              t('personal'),
                              'N',
                              t('default')));
    Result.Put('staff_face_register',
               Md_Util.Decode(v_Face_Register_Settings.Face_Register,
                              'Y',
                              t('enabled'),
                              'N',
                              t('not enabled')));
  
    v_Request_Settings := Hes_Util.Staff_Request_Manager_Approval_Settings(i_Company_Id => Ui.Company_Id,
                                                                           i_Filial_Id  => v_Filial_Id,
                                                                           i_User_Id    => v_User_Id);
  
    Result.Put('request_status_user_settings', v_Request_Settings.User_Settings);
    Result.Put('request_status_user_settings_type',
               Md_Util.Decode(v_Request_Settings.User_Settings, --
                              'Y',
                              t('personal'),
                              'N',
                              t('default')));
    Result.Put('request_status_settings',
               Md_Util.Decode(v_Request_Settings.Request_Settings,
                              'Y',
                              t('enabled'),
                              'N',
                              t('not enabled')));
  
    v_Change_Settings := Hes_Util.Staff_Change_Manager_Approval_Settings(i_Company_Id => Ui.Company_Id,
                                                                         i_Filial_Id  => v_Filial_Id,
                                                                         i_User_Id    => v_User_Id);
  
    Result.Put('change_status_user_settings', v_Change_Settings.User_Settings);
    Result.Put('change_status_user_settings_type',
               Md_Util.Decode(v_Change_Settings.User_Settings, --
                              'Y',
                              t('personal'),
                              'N',
                              t('default')));
    Result.Put('change_status_settings',
               Md_Util.Decode(v_Change_Settings.Change_Settings,
                              'Y',
                              t('enabled'),
                              'N',
                              t('not enabled')));
  
    -- licensing plans
    select q.Name
      bulk collect
      into v_Array
      from Md_Licenses q
     where exists (select 1
              from Kl_Licensing_Plans Lp
             where Lp.Company_Id = Ui.Company_Id
               and Lp.User_Id = v_User_Id
               and Lp.License_Code = q.License_Code)
       and (Ui.Company_Id = Md_Pref.c_Company_Head or exists
            (select 1
               from Md_Company_Projects Cp
              where Cp.Company_Id = Ui.Company_Id
                and Cp.Project_Code = q.Project_Code));
  
    Result.Put('licensing_plans', Fazo.Gather(v_Array, ', '));
  
    return result;
  end;

end Ui_Vhr155;
/
