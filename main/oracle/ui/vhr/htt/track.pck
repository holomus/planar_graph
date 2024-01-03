create or replace package Ui_Vhr77 is
  ----------------------------------------------------------------------------------------------------  
  Function Query_Persons return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Query_Locations return Fazo_Query;
  ----------------------------------------------------------------------------------------------------  
  Function Add_Model return Hashmap;
  ----------------------------------------------------------------------------------------------------  
  Procedure Add(p Hashmap);
end Ui_Vhr77;
/
create or replace package body Ui_Vhr77 is
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
    return b.Translate('UI-VHR77:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Persons return Fazo_Query is
    v_Query varchar2(32767);
    q       Fazo_Query;
  begin
    v_Query := 'select q.*,
                       (select p.org_unit_id
                          from href_staffs p
                         where p.company_id = :company_id
                           and p.filial_id = :filial_id
                           and p.employee_id = q.person_id
                           and p.state = ''A''
                           and p.staff_kind = :primary
                           and p.hiring_date <= :current_date
                           and :current_date <= nvl(p.dismissal_date, :current_date)) org_unit_id
                  from mr_natural_persons q
                 where exists (select 1 
                          from mhr_employees s
                         where s.company_id = :company_id
                           and s.filial_id = :filial_id
                           and s.employee_id = q.person_id
                           and s.state = ''A'')
                   and q.company_id = :company_id
                   and q.person_id != :user_id';
  
    v_Query := Uit_Href.Make_Subordinated_Query(i_Query          => v_Query,
                                                i_Include_Self   => false,
                                                i_Include_Manual => true,
                                                i_Filter_Key     => 'person_id');
  
    q := Fazo_Query(v_Query,
                    Fazo.Zip_Map('company_id',
                                 Ui.Company_Id,
                                 'filial_id',
                                 Ui.Filial_Id,
                                 'user_id',
                                 Ui.User_Id,
                                 'primary',
                                 Href_Pref.c_Staff_Kind_Primary,
                                 'current_date',
                                 Trunc(sysdate)));
  
    q.Number_Field('person_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query_Locations return Fazo_Query is
    q Fazo_Query;
  begin
    q := Fazo_Query('select *
                       from htt_locations q
                      where q.company_id = :company_id
                        and q.prohibited = ''N''
                        and q.state = ''A''
                        and exists (select 1
                               from htt_location_filials lf
                              where lf.company_id = :company_id
                                and lf.filial_id = :filial_id
                                and lf.location_id = q.location_id)',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'filial_id', Ui.Filial_Id));
  
    q.Number_Field('location_id');
    q.Varchar2_Field('name');
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Add_Model return Hashmap is
    result Hashmap;
  begin
    Uit_Href.Assert_Access_All_Employees;
  
    result := Fazo.Zip_Map('default_latlng',
                           Md_Pref.Filial_Default_Location(i_Company_Id => Ui.Company_Id,
                                                           i_Filial_Id  => Ui.Filial_Id),
                           'track_time',
                           to_char(sysdate, Href_Pref.c_Date_Format_Minute),
                           'is_valid',
                           'Y');
  
    if Ui.Grant_Has('track_type_check') then
      Result.Put('track_type', Htt_Pref.c_Track_Type_Check);
    elsif Ui.Grant_Has('track_type_input') then
      Result.Put('track_type', Htt_Pref.c_Track_Type_Input);
    elsif Ui.Grant_Has('track_type_output') then
      Result.Put('track_type', Htt_Pref.c_Track_Type_Output);
    end if;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Add(p Hashmap) is
    r_Track Htt_Tracks%rowtype;
  begin
    Uit_Href.Assert_Access_All_Employees;
  
    r_Track := z_Htt_Tracks.To_Row(p, --
                                   z.Person_Id,
                                   z.Location_Id,
                                   z.Track_Type,
                                   z.Note,
                                   z.Is_Valid);
  
    case r_Track.Track_Type
      when Htt_Pref.c_Track_Type_Check then
        if not Ui.Grant_Has('track_type_check') then
          b.Raise_Unauthorized;
        end if;
      when Htt_Pref.c_Track_Type_Input then
        if not Ui.Grant_Has('track_type_input') then
          b.Raise_Unauthorized;
        end if;
      when Htt_Pref.c_Track_Type_Output then
        if not Ui.Grant_Has('track_type_output') then
          b.Raise_Unauthorized;
        end if;
      else
        b.Raise_Error(t('track type not selected'));
    end case;
  
    r_Track.Company_Id := Ui.Company_Id;
    r_Track.Filial_Id  := Ui.Filial_Id;
    r_Track.Track_Id   := Htt_Next.Track_Id;
    r_Track.Track_Time := p.r_Date('track_time');
    r_Track.Mark_Type  := Htt_Pref.c_Mark_Type_Manual;
  
    Htt_Api.Track_Add(r_Track);
  end;

  ----------------------------------------------------------------------------------------------------  
  Procedure Validation is
  begin
    update Mr_Natural_Persons
       set Company_Id = null,
           Person_Id  = null,
           name       = null,
           State      = null;
    update Mhr_Employees
       set Company_Id  = null,
           Filial_Id   = null,
           Employee_Id = null,
           Division_Id = null,
           State       = null;
    update Href_Staffs
       set Company_Id     = null,
           Filial_Id      = null,
           Employee_Id    = null,
           Org_Unit_Id    = null,
           Hiring_Date    = null,
           Dismissal_Date = null,
           State          = null;
    update Htt_Locations
       set Company_Id  = null,
           Location_Id = null,
           name        = null,
           Prohibited  = null,
           State       = null;
    update Htt_Location_Filials
       set Company_Id  = null,
           Filial_Id   = null,
           Location_Id = null;
  end;

end Ui_Vhr77;
/
