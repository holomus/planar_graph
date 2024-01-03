create or replace package Ui_Vhr88 is
  ----------------------------------------------------------------------------------------------------
  Function Query(p Hashmap) return Fazo_Query;
  ----------------------------------------------------------------------------------------------------
  Procedure Migr(p Hashmap);
  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap);
end Ui_Vhr88;
/
create or replace package body Ui_Vhr88 is
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
    return b.Translate('UI-VHR88:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Query(p Hashmap) return Fazo_Query is
    v_Query  varchar2(32767);
    v_Params Hashmap;
    v_Matrix Matrix_Varchar2;
    q        Fazo_Query;
  begin
    v_Params := Fazo.Zip_Map('company_id', Ui.Company_Id, 'device_id', p.r_Number('device_id'));
    v_Query  := 'select *
                  from hzk_migr_tracks q
                 where q.company_id = :company_id
                   and q.device_id = :device_id';
  
    if not Ui.Is_Filial_Head then
      v_Params.Put('filial_id', Ui.Filial_Id);
    
      v_Query := v_Query || --
                 ' and exists (select 1
                          from htt_location_filials lf
                         where lf.company_id = :company_id
                           and lf.filial_id = :filial_id
                           and lf.location_id = q.location_id)';
    end if;
  
    q := Fazo_Query(v_Query, v_Params);
  
    q.Number_Field('migr_track_id', 'pin', 'location_id');
    q.Varchar2_Field('track_type', 'mark_type');
    q.Date_Field('track_time');
  
    v_Matrix := Htt_Util.Track_Types;
  
    q.Option_Field('track_type_name', 'track_type', v_Matrix(1), v_Matrix(2));
  
    v_Matrix := Htt_Util.Mark_Types;
  
    q.Option_Field('mark_type_name', 'mark_type', v_Matrix(1), v_Matrix(2));
  
    v_Query := 'select * 
                  from htt_locations w 
                 where w.company_id = :company_id';
  
    if not Ui.Is_Filial_Head then
      v_Query := v_Query || --
                 ' and exists (select 1
                          from htt_location_filials lf
                         where lf.company_id = :company_id
                           and lf.filial_id = :filial_id
                           and lf.location_id = w.location_id)';
    end if;
  
    q.Refer_Field('location_name', 'location_id', 'htt_locations', 'location_id', 'name', v_Query);
  
    return q;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Migr(p Hashmap) is
    v_Tracks_Ids Array_Number := Fazo.Sort(p.r_Array_Number('track_id'));
  begin
    for i in 1 .. v_Tracks_Ids.Count
    loop
      Hzk_Api.Migr_Track_Save(i_Company_Id => Ui.Company_Id, i_Migr_Track_Id => v_Tracks_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Del(p Hashmap) is
    v_Tracks_Ids Array_Number := Fazo.Sort(p.r_Array_Number('track_id'));
  begin
    for i in 1 .. v_Tracks_Ids.Count
    loop
      Hzk_Api.Migr_Track_Delete(i_Company_Id => Ui.Company_Id, i_Migr_Track_Id => v_Tracks_Ids(i));
    end loop;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Validation is
  begin
    update Hzk_Migr_Tracks
       set Company_Id    = null,
           Migr_Track_Id = null,
           Pin           = null,
           Device_Id     = null,
           Location_Id   = null,
           Track_Type    = null,
           Track_Time    = null,
           Track_Date    = null,
           Mark_Type     = null;
    update Htt_Locations
       set Company_Id  = null,
           Location_Id = null,
           name        = null;
    update Htt_Location_Filials
       set Company_Id  = null,
           Filial_Id   = null,
           Location_Id = null;
  end;

end Ui_Vhr88;
/
