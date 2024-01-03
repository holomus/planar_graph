create or replace package Ui_Vhr83 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Track_Audit(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Model(p Hashmap) return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Procedure Set_Valid(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Set_Invalid(p Hashmap);
end Ui_Vhr83;
/
create or replace package body Ui_Vhr83 is
  ----------------------------------------------------------------------------------------------------
  Function Query_Track_Audit(p Hashmap) return Fazo_Query is
    v_Matrix    Matrix_Varchar2 := Md_Util.Events;
    v_Filial_Id number := Ui.Filial_Id;
    q           Fazo_Query;
  begin
    if Ui.Is_Filial_Head then
      v_Filial_Id := p.r_Number('filial_id');
    end if;
  
    q := Fazo_Query('select * 
                       from x_htt_tracks q
                      where q.t_company_id = :company_id 
                        and q.t_filial_id = :filial_id 
                        and q.track_id = :track_id',
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 v_Filial_Id,
                                 'track_id',
                                 p.r_Number('track_id')));
  
    q.Number_Field('t_user_id', 't_context_id', 'track_id');
    q.Varchar2_Field('t_event', 't_source_project_code', 'track_type', 'is_valid');
    q.Date_Field('t_timestamp', 't_date', 'track_time');
  
    q.Refer_Field('t_user_name',
                  't_user_id',
                  'md_users',
                  'user_id',
                  'name',
                  'select *
                     from md_users q
                    where q.company_id = :company_id');
    q.Refer_Field('t_source_project_name',
                  't_source_project_code',
                  'select s.project_code,
                          ui_kernel.project_name(s.project_code) project_name
                     from md_projects s',
                  'project_code',
                  'project_name',
                  'select s.project_code, 
                          ui_kernel.project_name(s.project_code) project_name
                     from md_projects s
                    where s.visible = ''Y''
                      and exists (select 1
                             from md_company_projects k
                            where k.company_id = :company_id
                              and k.project_code = s.project_code)');
  
    q.Option_Field('t_event_name', 't_event', v_Matrix(1), v_Matrix(2));
  
    v_Matrix := Htt_Util.Track_Types;
  
    q.Option_Field('track_type_name', 'track_type', v_Matrix(1), v_Matrix(2));
  
    q.Option_Field('is_valid_name',
                   'is_valid',
                   Array_Varchar2('Y', 'N'),
                   Array_Varchar2(Ui.t_Yes, Ui.t_No));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function References return Hashmap is
    result Hashmap;
  begin
    result := Fazo.Zip_Map('ual_personal',
                           Href_Pref.c_User_Access_Level_Personal,
                           'access_all_employee',
                           Uit_Href.User_Access_All_Employees);
  
    Result.Put('tt_input', Htt_Pref.c_Track_Type_Input);
    Result.Put('tt_output', Htt_Pref.c_Track_Type_Output);
    Result.Put('tt_merger', Htt_Pref.c_Track_Type_Merger);
    Result.Put('tt_check', Htt_Pref.c_Track_Type_Check);
    Result.Put('tt_potential', Htt_Pref.c_Track_Type_Potential_Output);
  
    return result;
  end;

  ---------------------------------------------------------------------------------------------------- 
  Function Model(p Hashmap) return Hashmap is
    r_Track     Htt_Tracks%rowtype;
    r_Device    Htt_Devices%rowtype;
    r_Location  Htt_Locations%rowtype;
    r_Person    Mr_Natural_Persons%rowtype;
    v_Filial_Id number := Ui.Filial_Id;
    result      Hashmap;
  
    --------------------------------------------------
    Function Get_Track_Types return Arraylist is
      result Matrix_Varchar2;
    begin
      select Array_Varchar2(q.Track_Type, Htt_Util.t_Track_Type(q.Track_Type))
        bulk collect
        into result
        from Htt_Timesheet_Tracks q
       where q.Company_Id = r_Track.Company_Id
         and q.Filial_Id = r_Track.Filial_Id
         and q.Track_Id = r_Track.Track_Id
       group by q.Track_Type
       order by Decode(q.Track_Type,
                       Htt_Pref.c_Track_Type_Input,
                       1,
                       Htt_Pref.c_Track_Type_Output,
                       2,
                       Htt_Pref.c_Track_Type_Merger,
                       3,
                       Htt_Pref.c_Track_Type_Potential_Output,
                       4,
                       5);
    
      if Result.Count = 0 then
        Fazo.Push(result,
                  Array_Varchar2(r_Track.Track_Type, Htt_Util.t_Track_Type(r_Track.Track_Type)));
      end if;
    
      return Fazo.Zip_Matrix(result);
    end;
  begin
    if Ui.Is_Filial_Head then
      v_Filial_Id := p.r_Number('filial_id');
    end if;
  
    r_Track := z_Htt_Tracks.Load(i_Company_Id => Ui.Company_Id,
                                 i_Filial_Id  => v_Filial_Id,
                                 i_Track_Id   => p.r_Number('track_id'));
  
    Uit_Href.Assert_Access_To_Employee(i_Employee_Id => r_Track.Person_Id,
                                       i_Filial_Id   => v_Filial_Id);
  
    result := z_Htt_Tracks.To_Map(r_Track,
                                  z.Filial_Id,
                                  z.Track_Id,
                                  z.Track_Time,
                                  z.Mark_Type,
                                  z.Latlng,
                                  z.Accuracy,
                                  z.Photo_Sha,
                                  z.Bssid,
                                  z.Note,
                                  z.Is_Valid,
                                  z.Created_On,
                                  z.Modified_On);
  
    Result.Put('created_by_name',
               z_Md_Users.Load(i_Company_Id => r_Track.Company_Id, i_User_Id => r_Track.Created_By).Name);
    Result.Put('modified_by_name',
               z_Md_Users.Load(i_Company_Id => r_Track.Company_Id, i_User_Id => r_Track.Modified_By).Name);
  
    r_Device := z_Htt_Devices.Take(i_Company_Id => Ui.Company_Id, i_Device_Id => r_Track.Device_Id);
  
    r_Location := z_Htt_Locations.Take(i_Company_Id  => Ui.Company_Id,
                                       i_Location_Id => r_Track.Location_Id);
  
    r_Person := z_Mr_Natural_Persons.Load(i_Company_Id => Ui.Company_Id,
                                          i_Person_Id  => r_Track.Person_Id);
  
    Result.Put('track_types', Get_Track_Types);
  
    Result.Put('mark_type_name', Htt_Util.t_Mark_Type(r_Track.Mark_Type));
    Result.Put('device_name', r_Device.Name);
    Result.Put('device_type_name',
               z_Htt_Device_Types.Take(i_Device_Type_Id => r_Device.Device_Type_Id).Name);
    Result.Put('device_serial_number', r_Device.Serial_Number);
    Result.Put('person_name', r_Person.Name);
    Result.Put('person_gender', r_Person.Gender);
    Result.Put('location_name', r_Location.Name);
    Result.Put('region_name',
               z_Md_Regions.Take(i_Company_Id => Ui.Company_Id, i_Region_Id => r_Location.Region_Id).Name);
    Result.Put('access_level', Uit_Href.User_Access_Level_For_Person(r_Person.Person_Id));
    Result.Put('references', References);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Set_Valid(p Hashmap) is
    r_Track     Htt_Tracks%rowtype;
    v_Filial_Id number := Ui.Filial_Id;
  begin
    if Ui.Is_Filial_Head then
      v_Filial_Id := p.r_Number('filial_id');
    end if;
  
    r_Track := z_Htt_Tracks.Lock_Load(i_Company_Id => Ui.Company_Id,
                                      i_Filial_Id  => v_Filial_Id,
                                      i_Track_Id   => p.r_Number('track_id'));
  
    Uit_Href.Assert_Access_To_Employee(i_Employee_Id => r_Track.Person_Id,
                                       i_Filial_Id   => v_Filial_Id,
                                       i_Self        => false);
  
    Htt_Api.Track_Set_Valid(i_Company_Id => r_Track.Company_Id,
                            i_Filial_Id  => r_Track.Filial_Id,
                            i_Track_Id   => r_Track.Track_Id);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Set_Invalid(p Hashmap) is
    r_Track     Htt_Tracks%rowtype;
    v_Filial_Id number := Ui.Filial_Id;
  begin
    if Ui.Is_Filial_Head then
      v_Filial_Id := p.r_Number('filial_id');
    end if;
  
    r_Track := z_Htt_Tracks.Lock_Load(i_Company_Id => Ui.Company_Id,
                                      i_Filial_Id  => v_Filial_Id,
                                      i_Track_Id   => p.r_Number('track_id'));
  
    Uit_Href.Assert_Access_To_Employee(i_Employee_Id => r_Track.Person_Id,
                                       i_Filial_Id   => v_Filial_Id,
                                       i_Self        => false);
  
    Htt_Api.Track_Set_Invalid(i_Company_Id => r_Track.Company_Id,
                              i_Filial_Id  => r_Track.Filial_Id,
                              i_Track_Id   => r_Track.Track_Id);
  end;

  ---------------------------------------------------------------------------------------------------- 
  Procedure Validation is
  begin
    update x_Htt_Tracks
       set t_Company_Id          = null,
           t_Filial_Id           = null,
           t_Event               = null,
           t_Timestamp           = null,
           t_Date                = null,
           t_User_Id             = null,
           t_Source_Project_Code = null,
           t_Context_Id          = null,
           Track_Id              = null,
           Track_Time            = null,
           Person_Id             = null,
           Track_Type            = null,
           Note                  = null;
    update Md_Users
       set Company_Id = null,
           User_Id    = null,
           name       = null;
    update Md_Projects
       set Project_Code = null,
           Visible      = null;
    update Md_Company_Projects
       set Company_Id   = null,
           Project_Code = null;
    update Htt_Location_Filials
       set Company_Id  = null,
           Filial_Id   = null,
           Location_Id = null;
  
    Uie.x(Ui_Kernel.Project_Name(null));
  end;

end Ui_Vhr83;
/
