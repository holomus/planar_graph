create or replace package Ui_Vhr479 is
  ----------------------------------------------------------------------------------------------------
  Function Modal(p Hashmap) return Hashmap;
end Ui_Vhr479;
/
create or replace package body Ui_Vhr479 is
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
    return b.Translate('UI-VHR479:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Function Tracks
  (
    i_Company_Id number,
    i_Filial_Id  number,
    i_Track_Id   number,
    i_Context_Id number
  ) return Matrix_Varchar2 is
    r_Last         x_Htt_Tracks%rowtype;
    v_Data         Matrix_Varchar2 := Matrix_Varchar2();
    v_Diff_Columns Array_Varchar2;

    --------------------------------------------------
    Procedure Get_Difference
    (
      i_Name          varchar2,
      i_Title         varchar2,
      i_Last_Value    varchar2,
      i_Current_Value varchar2
    ) is
    begin
      if i_Name member of v_Diff_Columns then
        Fazo.Push(v_Data, i_Title, i_Last_Value, i_Current_Value);
      end if;
    end;
  begin
    for r in (select q.*
                from x_Htt_Tracks q
               where q.t_Company_Id = i_Company_Id
                 and q.t_Filial_Id = i_Filial_Id
                 and q.Track_Id = i_Track_Id
                 and q.t_Context_Id = i_Context_Id)
    loop
      if r.t_Event = 'U' then
        begin
          select *
            into r_Last
            from (select *
                    from x_Htt_Tracks t
                   where t.t_Company_Id = r.t_Company_Id
                     and t.t_Filial_Id = i_Filial_Id
                     and t.Track_Id = r.Track_Id
                     and t.t_Context_Id <> i_Context_Id
                     and t.t_Timestamp <= r.t_Timestamp
                   order by t_Timestamp desc) t
           where Rownum = 1;

        exception
          when others then
            null;
        end;
      elsif r.t_Event = 'D' then
        r_Last := r;
        r      := null;
      else
        r_Last := null;
      end if;

      v_Diff_Columns := z_x_Htt_Tracks.Difference(r, r_Last);

      Get_Difference(z.Track_Date, t('track date'), r_Last.Track_Date, r.Track_Date);
      Get_Difference(z.Person_Id,
                     t('person name'),
                     z_Mr_Natural_Persons.Take(i_Company_Id => i_Company_Id, i_Person_Id => r_Last.Person_Id).Name,
                     z_Mr_Natural_Persons.Take(i_Company_Id => i_Company_Id, i_Person_Id => r.Person_Id).Name);
      Get_Difference(z.Track_Type,
                     t('track type'),
                     Htt_Util.t_Track_Type(r_Last.Track_Type),
                     Htt_Util.t_Track_Type(r.Track_Type));
      Get_Difference(z.Mark_Type,
                     t('mark type'),
                     Htt_Util.t_Mark_Type(r_Last.Mark_Type),
                     Htt_Util.t_Mark_Type(r.Mark_Type));
      Get_Difference(z.Device_Id,
                     t('device name'),
                     z_Htt_Device_Types.Take(i_Device_Type_Id => r_Last.Device_Id).Name,
                     z_Htt_Device_Types.Take(i_Device_Type_Id => r.Device_Id).Name);
      Get_Difference(z.Location_Id,
                     t('location name'),
                     z_Htt_Locations.Take(i_Company_Id => i_Company_Id, i_Location_Id => r_Last.Location_Id).Name,
                     z_Htt_Locations.Take(i_Company_Id => i_Company_Id, i_Location_Id => r.Location_Id).Name);
      Get_Difference(z.Latlng, t('latlng'), r_Last.Latlng, r_Last.Latlng);
      Get_Difference(z.Accuracy, t('accuracy'), r_Last.Accuracy, r.Accuracy);
      Get_Difference(z.Bssid, t('bssid'), r_Last.Bssid, r.Bssid);
      Get_Difference(z.Note, t('note'), r_Last.Note, r.Note);
      Get_Difference(z.Is_Valid,
                     t('is valid'),
                     Md_Util.Decode(r_Last.Is_Valid, 'Y', Ui.t_Yes, 'N', Ui.t_No),
                     Md_Util.Decode(r.Is_Valid, 'Y', Ui.t_Yes, 'N', Ui.t_No));
    end loop;

    return v_Data;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Modal(p Hashmap) return Hashmap is
    v_Track_Id  number := p.r_Number('track_id');
    v_Filial_Id number := Ui.Filial_Id;
    result      Hashmap := Hashmap();
  begin
    if Ui.Is_Filial_Head then
      v_Filial_Id := p.r_Number('filial_id');
    end if;

    Result.Put('name', Htt_Util.Tname_Track(v_Track_Id));
    Result.Put('track',
               Fazo.Zip_Matrix(Tracks(i_Company_Id => Ui.Company_Id,
                                      i_Filial_Id  => v_Filial_Id,
                                      i_Track_Id   => v_Track_Id,
                                      i_Context_Id => p.r_Number('context_id'))));

    return result;
  end;

end Ui_Vhr479;
/
