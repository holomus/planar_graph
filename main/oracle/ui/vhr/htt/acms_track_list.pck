create or replace package Ui_Vhr474 is
  ----------------------------------------------------------------------------------------------------  
  Function Query(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Integrate(p Hashmap);
end Ui_Vhr474;
/
create or replace package body Ui_Vhr474 is
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
    return b.Translate('UI-VHR474:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------  
  Function Query(p Hashmap) return Fazo_Query is
    v_Matrix Matrix_Varchar2;
    q        Fazo_Query;
  begin
    q := Fazo_Query('htt_acms_tracks',
                    Fazo.Zip_Map('company_id', Ui.Company_Id, 'device_id', p.r_Number('device_id')),
                    true);
  
    q.Varchar2_Field('track_type', 'mark_type', 'status', 'error_text');
    q.Number_Field('track_id', 'person_id');
    q.Date_Field('track_datetime');
  
    q.Refer_Field('person_name',
                  'person_id',
                  'mr_natural_persons',
                  'person_id',
                  'name',
                  'select *
                     from mr_natural_persons q
                    where q.company_id = :company_id');
  
    v_Matrix := Htt_Util.Acms_Mark_Types;
    q.Option_Field('mark_type_name', 'mark_type', v_Matrix(1), v_Matrix(2));
  
    v_Matrix := Htt_Util.Track_Types;
    q.Option_Field('track_type_name', 'track_type', v_Matrix(1), v_Matrix(2));
  
    v_Matrix := Htt_Util.Acms_Track_Statuses;
    q.Option_Field('status_name', 'status', v_Matrix(1), v_Matrix(2));
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Integrate(p Hashmap) is
    v_Track_Ids  Array_Number := Fazo.Sort(p.r_Array_Number('track_id'));
    v_Device_Id  number := p.r_Number('device_id');
    v_Company_Id number := Ui.Company_Id;
    r_Acms_Track Htt_Acms_Tracks%rowtype;
  begin
    for i in 1 .. v_Track_Ids.Count
    loop
      r_Acms_Track := z_Htt_Acms_Tracks.Lock_Load(i_Company_Id => v_Company_Id,
                                                  i_Track_Id   => v_Track_Ids(i));
    
      if r_Acms_Track.Device_Id <> v_Device_Id then
        b.Raise_Error(t('the track depends on another device, track_id: $1', r_Acms_Track.Track_Id));
      end if;
    
      Htt_Api.Acms_Track_Integrate(i_Company_Id => v_Company_Id,
                                   i_Track_Id   => r_Acms_Track.Track_Id);
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Htt_Acms_Tracks
       set Company_Id     = null,
           Track_Id       = null,
           Device_Id      = null,
           Person_Id      = null,
           Track_Type     = null,
           Track_Datetime = null,
           Mark_Type      = null,
           Status         = null,
           Error_Text     = null;
  
    update Mr_Natural_Persons
       set Company_Id = null,
           name       = null,
           State      = null;
  end;

end Ui_Vhr474;
/
