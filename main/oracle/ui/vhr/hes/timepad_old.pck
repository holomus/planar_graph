create or replace package Ui_Vx114 is
  ----------------------------------------------------------------------------------------------------
  Function Load_Settings return Hashmap;
  ----------------------------------------------------------------------------------------------------
  Function Load_Holidays return Json_Array_t;
  ----------------------------------------------------------------------------------------------------
  Function Save_Tracks(p Hashmap) return Hashmap;
end Ui_Vx114;
/
create or replace package body Ui_Vx114 is
  ----------------------------------------------------------------------------------------------------
  g_Company_Id number;
  g_User_Id    number;
  g_Device     Htt_Devices%rowtype;

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
    return b.Translate('UI-VX114:' || i_Message, i_P1, i_P2, i_P3, i_P4, i_P5);
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Last_Seen_Modify is
    pragma autonomous_transaction;
  begin
    z_Htt_Devices.Update_One(i_Company_Id   => g_Device.Company_Id,
                             i_Device_Id    => g_Device.Device_Id,
                             i_Last_Seen_On => Option_Date(Current_Timestamp));
  
    commit;
  exception
    when others then
      rollback;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Init
  (
    i_Company_Id number,
    i_User_Id    number
  ) is
    v_Serial_Number  Htt_Devices.Serial_Number%type;
    v_Token          Kauth_Tokens.Token%type := Ui_Context.Token;
    v_Device_Type_Id number := Htt_Util.Device_Type_Id(Htt_Pref.c_Pcode_Device_Type_Timepad);
  begin
    g_Company_Id := i_Company_Id;
    g_User_Id    := i_User_Id;
  
    select d.Device_Code
      into v_Serial_Number
      from Mt_Devices d
     where d.Company_Id = g_Company_Id
       and exists (select 1
              from Mt_Hosts h
             where h.Company_Id = g_Company_Id
               and h.Device_Id = d.Device_Id
               and h.User_Id = g_User_Id
               and exists (select 1
                      from Kauth_Tokens Kt
                     where Kt.Company_Id = g_Company_Id
                       and Kt.Token_Id = h.Token_Id
                       and Kt.Token = v_Token));
    begin
      select d.*
        into g_Device
        from Htt_Devices d
       where d.Company_Id = g_Company_Id
         and d.Device_Type_Id = v_Device_Type_Id
         and d.Serial_Number = v_Serial_Number;
    exception
      when No_Data_Found then
        b.Raise_Error(t('initially, you must create timepad device, sn: $1', v_Serial_Number));
    end;
  
    Last_Seen_Modify;
  
    if g_Device.State = 'P' then
      b.Raise_Error(t('device status is passive, sn: $1', v_Serial_Number));
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Settings return Hashmap is
    v_Photos        Array_Varchar2;
    v_Items         Arraylist;
    v_Item          Hashmap;
    v_Track_Types   Array_Varchar2;
    v_Mark_Types    Array_Varchar2;
    v_Emotion_Types Array_Varchar2;
    v_Settings      Hes_Pref.Timepad_Track_Settings_Rt;
    v_Lang_Code     varchar2(10);
    result          Hashmap := Hashmap();
  begin
    Init(Ui.Company_Id, Ui.User_Id);
  
    Result.Put('group_id', to_char(g_Company_Id));
  
    Result.Put('face_recognation', 'Y');
    Result.Put('track_type_input', 'N');
    Result.Put('track_type_output', 'N');
    Result.Put('track_type_track', 'N');
    Result.Put('mark_type_face', 'N');
    Result.Put('mark_type_qr_code', 'N');
    Result.Put('mark_type_password', 'N');
    Result.Put('emotion_wink', 'N');
    Result.Put('emotion_smile', 'N');
    Result.Put('location_id', g_Device.Location_Id);
  
    if g_Device.Use_Settings = 'Y' then
      v_Settings := Hes_Util.Timepad_Track_Settings(g_Company_Id);
    
      v_Track_Types   := Fazo.Split(v_Settings.Track_Types, ',');
      v_Mark_Types    := Fazo.Split(v_Settings.Mark_Types, ',');
      v_Emotion_Types := Fazo.Split(v_Settings.Emotion_Types, ',');
      v_Lang_Code     := v_Settings.Lang_Code;
    else
      v_Track_Types   := Fazo.Split(g_Device.Track_Types, ',');
      v_Mark_Types    := Fazo.Split(g_Device.Mark_Types, ',');
      v_Emotion_Types := Fazo.Split(g_Device.Emotion_Types, ',');
      v_Lang_Code     := g_Device.Lang_Code;
    end if;
  
    if Fazo.Contains(v_Track_Types, Htt_Pref.c_Track_Type_Input) then
      Result.Put('track_type_input', 'Y');
    end if;
    if Fazo.Contains(v_Track_Types, Htt_Pref.c_Track_Type_Output) then
      Result.Put('track_type_output', 'Y');
    end if;
    if Fazo.Contains(v_Track_Types, Htt_Pref.c_Track_Type_Check) then
      Result.Put('track_type_track', 'Y');
    end if;
  
    if Fazo.Contains(v_Mark_Types, Htt_Pref.c_Mark_Type_Face) then
      Result.Put('mark_type_face', 'Y');
    end if;
    if Fazo.Contains(v_Mark_Types, Htt_Pref.c_Mark_Type_Qr_Code) then
      Result.Put('mark_type_qr_code', 'Y');
    end if;
    if Fazo.Contains(v_Mark_Types, Htt_Pref.c_Mark_Type_Password) then
      Result.Put('mark_type_password', 'Y');
    end if;
  
    if Fazo.Contains(v_Emotion_Types, Htt_Pref.c_Emotion_Type_Wink) then
      Result.Put('emotion_wink', 'Y');
    end if;
  
    if Fazo.Contains(v_Emotion_Types, Htt_Pref.c_Emotion_Type_Smile) then
      Result.Put('emotion_smile', 'Y');
    end if;
  
    -- persons
    v_Items := Arraylist();
    for r in (select q.*, --
                     trim(w.Last_Name || ' ' || w.First_Name) Person_Name,
                     w.Birthday
                from Htt_Persons q
                join Mr_Natural_Persons w
                  on w.Company_Id = q.Company_Id
                 and w.Person_Id = q.Person_Id
               where q.Company_Id = g_Company_Id
                 and exists
               (select 1
                        from Htt_Location_Persons w
                       where w.Company_Id = g_Company_Id
                         and w.Location_Id = g_Device.Location_Id
                         and w.Person_Id = q.Person_Id
                         and exists
                       (select 1
                                from Href_Staffs s
                               where s.Company_Id = g_Company_Id
                                 and s.Filial_Id = w.Filial_Id
                                 and s.Employee_Id = w.Person_Id
                                 and s.Hiring_Date <= Trunc(sysdate)
                                 and (s.Dismissal_Date is null or s.Dismissal_Date >= Trunc(sysdate))
                                 and s.State = 'A')
                         and not exists (select *
                                from Htt_Blocked_Person_Tracking Bl
                               where Bl.Company_Id = w.Company_Id
                                 and Bl.Filial_Id = w.Filial_Id
                                 and Bl.Employee_Id = w.Person_Id)))
    loop
      v_Item := Hashmap();
      v_Item.Put('person_id', r.Person_Id);
      v_Item.Put('pin', r.Pin);
      v_Item.Put('pin_code', r.Pin_Code);
      v_Item.Put('qr_code', r.Qr_Code);
      v_Item.Put('lang_code', v_Lang_Code);
      v_Item.Put('name', r.Person_Name);
      v_Item.Put('birthday', r.Birthday);
    
      select c.Photo_Sha
        bulk collect
        into v_Photos
        from Htt_Person_Photos c
       where c.Company_Id = g_Company_Id
         and c.Person_Id = r.Person_Id;
    
      v_Item.Put('cv_photos', v_Photos);
    
      v_Items.Push(v_Item);
    end loop;
    Result.Put('persons', v_Items);
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Load_Holidays return Json_Array_t is
    v_Begin_Date date := Trunc(sysdate);
    v_End_Date   date := Add_Months(v_Begin_Date, 3);
    v_Filial_Ids Array_Number;
    v_Holidays   Glist;
    v_Data       Gmap;
    result       Glist := Glist();
  begin
    Init(Ui.Company_Id, Ui.User_Id);
  
    select Lf.Filial_Id
      bulk collect
      into v_Filial_Ids
      from Htt_Location_Filials Lf
     where Lf.Company_Id = g_Company_Id
       and Lf.Location_Id = g_Device.Location_Id;
  
    for r in (select q.Person_Id,
                     (select Json_Arrayagg(Json_Object('name' value h.Name,
                                                       'holiday_date' value
                                                       to_char(h.Calendar_Date, 'dd.mm.yyyy')))
                        from Htt_Calendar_Days h
                        join Href_Staffs St
                          on St.Company_Id = g_Company_Id
                         and St.Filial_Id member of v_Filial_Ids
                         and St.Employee_Id = q.Person_Id
                         and h.Calendar_Id =
                             (select Sch.Calendar_Id
                                from Htt_Schedules Sch
                               where Sch.Company_Id = St.Company_Id
                                 and Sch.Filial_Id = St.Filial_Id
                                 and Sch.Schedule_Id = St.Schedule_Id)
                         and St.Filial_Id = h.Filial_Id
                       where h.Company_Id = g_Company_Id
                         and h.Filial_Id member of
                       v_Filial_Ids
                         and h.Calendar_Date between v_Begin_Date and v_End_Date) Holidays
                from Htt_Persons q
               where q.Company_Id = g_Company_Id
                 and exists
               (select 1
                        from Htt_Location_Persons s
                       where s.Company_Id = g_Device.Company_Id
                         and s.Location_Id = g_Device.Location_Id
                         and s.Person_Id = q.Person_Id
                         and not exists (select *
                                from Htt_Blocked_Person_Tracking Bl
                               where Bl.Company_Id = s.Company_Id
                                 and Bl.Filial_Id = s.Filial_Id
                                 and Bl.Employee_Id = s.Person_Id)))
    loop
      continue when r.Holidays is null;
    
      v_Data := Gmap();
    
      v_Data.Put('person_id', r.Person_Id);
    
      v_Holidays := Glist(Json_Array_t(r.Holidays));
      v_Data.Put('holidays', v_Holidays);
    
      Result.Push(v_Data.Val);
    end loop;
  
    return Result.Val;
  end;

  ----------------------------------------------------------------------------------------------------
  Function Save_Tracks(p Hashmap) return Hashmap is
    r_Track            Htt_Tracks%rowtype;
    v_Items            Arraylist;
    v_Item             Hashmap;
    v_Track_Ids        Array_Number := Array_Number();
    v_Track_Types      Array_Varchar2 := Array_Varchar2();
    v_Filial_Ids       Array_Number;
    v_Sysdate          date := Trunc(sysdate);
    v_Track_Type       varchar2(1);
    v_Face_Recognition varchar2(1);
    result             Hashmap := Hashmap();
  begin
    Init(Ui.Company_Id, Ui.User_Id);
  
    v_Items := p.r_Arraylist('tracks');
    v_Track_Ids.Extend(v_Items.Count);
    v_Track_Types.Extend(v_Items.Count);
  
    for i in 1 .. v_Items.Count
    loop
      v_Item := Treat(v_Items.r_Hashmap(i) as Hashmap);
    
      z_Htt_Tracks.Init(p_Row         => r_Track,
                        i_Company_Id  => g_Company_Id,
                        i_Person_Id   => v_Item.r_Number('person_id'),
                        i_Track_Type  => v_Item.o_Varchar2('track_type'),
                        i_Device_Id   => g_Device.Device_Id,
                        i_Location_Id => Nvl(v_Item.o_Number('location_id'), g_Device.Location_Id),
                        i_Mark_Type   => v_Item.r_Varchar2('mark_type'),
                        i_Photo_Sha   => v_Item.o_Varchar2('photo_sha'));
    
      if r_Track.Track_Type = 'T' then
        r_Track.Track_Type := Htt_Pref.c_Track_Type_Check;
      end if;
    
      r_Track.Track_Date := Trunc(r_Track.Track_Time);
      v_Track_Type       := r_Track.Track_Type;
    
      if r_Track.Mark_Type = Htt_Pref.c_Mark_Type_Face and v_Face_Recognition = 'N' then
        b.Raise_Error(t('device cannot use face recognition, device_id=$1', g_Device.Device_Id));
      end if;
    
      r_Track.Track_Time := Htt_Util.Convert_Timestamp(i_Date     => v_Item.r_Date('track_time',
                                                                                   Href_Pref.c_Date_Format_Second),
                                                       i_Timezone => Htt_Util.Load_Timezone(i_Company_Id  => r_Track.Company_Id,
                                                                                            i_Location_Id => r_Track.Location_Id));
    
      v_Filial_Ids := Htt_Util.Get_Filial_Ids(i_Company_Id  => r_Track.Company_Id,
                                              i_Location_Id => r_Track.Location_Id,
                                              i_Person_Id   => r_Track.Person_Id);
    
      if v_Filial_Ids.Count = 0 then
        b.Raise_Error(t('user does not have access to location, device_id=$1, location_id=$2, user_id=$3',
                        g_Device.Device_Id,
                        g_Device.Location_Id,
                        r_Track.Person_Id));
      end if;
    
      for j in 1 .. v_Filial_Ids.Count
      loop
        r_Track.Filial_Id := v_Filial_Ids(j);
        r_Track.Track_Id  := Htt_Next.Track_Id;
      
        if v_Track_Type is null then
          begin
            select Decode(Last_Track_Type,
                          Htt_Pref.c_Track_Type_Input,
                          Htt_Pref.c_Track_Type_Output,
                          Htt_Pref.c_Track_Type_Input)
              into r_Track.Track_Type
              from (select t.Track_Type as Last_Track_Type
                      from Htt_Tracks t
                     where t.Company_Id = r_Track.Company_Id
                       and t.Filial_Id = r_Track.Filial_Id
                       and t.Person_Id = r_Track.Person_Id
                       and t.Track_Date = v_Sysdate
                       and t.Track_Type <> Htt_Pref.c_Track_Type_Check
                     order by t.Track_Time desc)
             where Rownum = 1;
          exception
            when No_Data_Found then
              r_Track.Track_Type := Htt_Pref.c_Track_Type_Input;
          end;
        end if;
      
        Htt_Api.Track_Add(r_Track);
      end loop;
    
      v_Track_Ids(i) := Nvl(v_Item.o_Number('track_id'), r_Track.Track_Id);
      v_Track_Types(i) := r_Track.Track_Type;
    end loop;
  
    Result.Put('track_ids', v_Track_Ids);
    Result.Put('track_types', v_Track_Types);
  
    return result;
  end;

end Ui_Vx114;
/
